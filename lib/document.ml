open Value

exception Json_error of string

type key = string
type value = Value.t

type t = {
  document_id : string;
  data : (key * value) list;
}

let make id = { document_id = id; data = [] }

let set_data pairs document =
  { document_id = document.document_id; data = pairs }

let update_data pairs document =
  let updated_data =
    List.map
      (fun (k, v) ->
        if List.mem_assoc k pairs then (k, List.assoc k pairs) else (k, v))
      document.data
    @ List.filter (fun (k, _) -> not (List.mem_assoc k document.data)) pairs
  in
  { document_id = document.document_id; data = updated_data }

let delete_field key document =
  if not (List.mem_assoc key document.data) then raise Not_found
  else
    {
      document_id = document.document_id;
      data = List.remove_assoc key document.data;
    }

let document_id document = document.document_id
let data document = document.data

let string_of_document ?(tabs = 0) document =
  let tabs_str = String.make tabs '\t' in
  let data_str =
    document.data
    |> List.map (fun (k, v) ->
           tabs_str ^ "\t\t\"" ^ k ^ "\": \"" ^ Value.string_of_value v ^ "\"")
    |> String.concat ", \n"
  in
  tabs_str ^ "{\n" ^ tabs_str ^ "\t\"document_id\": \"" ^ document.document_id
  ^ "\", \n" ^ tabs_str ^ "\t\"data\": {\n" ^ data_str ^ "\n" ^ tabs_str ^ "\t}"
  ^ tabs_str ^ "\n" ^ tabs_str ^ "}"

let to_json document filename =
  let oc = open_out filename in
  Printf.fprintf oc "%s" (string_of_document document);
  close_out oc

let parse_source f source =
  try
    match f source with
    | Map m ->
        let id, data =
          ( TMap.find "document_id" m |> string_of_value,
            TMap.find "data" m |> map_of_value |> TMap.bindings )
        in
        make id |> set_data data
    | _ -> failwith "Impossible branch: document.from_json"
  with
  | Parser.Syntax_error -> raise (Json_error "Invalid JSON syntax.")
  | Lexer.Invalid_token -> raise (Json_error "Invalid token.")
  | Not_found -> raise (Json_error "document_id or data fields doesn't exist.")
  | Type_error -> raise (Json_error "incorrect types for document_id or data.")

let from_json = parse_source Parser.parse_file
let from_json_string = parse_source Parser.parse_string
let union doc1 doc2 = update_data (data doc2) doc1

let intersect doc1 doc2 =
  let data1 = data doc1 in
  let data2 = data doc2 in
  let intersected_data =
    List.filter (fun (k, _) -> List.mem_assoc k data2) data1
  in
  set_data intersected_data doc1

let difference doc1 doc2 =
  let data1 = data doc1 in
  let data2 = data doc2 in
  let diff_data =
    List.filter (fun (k, _) -> not (List.mem_assoc k data2)) data1
  in
  set_data diff_data doc1
