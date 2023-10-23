open Printf

type tree =
  | Leaf of int
  | Node of string * tree * tree

let rec parse_input () =
  try
    let line = input_line stdin in
    let split_index = String.index line ':' in
    let label = String.sub line 0 split_index in
    let value = String.sub line (split_index + 1) (String.length line - split_index - 1) in
    
    match label with
    | "Leaf" -> Leaf (int_of_string value)
    | "Node" ->
        let left = parse_input () in
        let right = parse_input () in
        Node (value, left, right)
    | _ -> failwith "Invalid input"
  with End_of_file -> failwith "Unexpected end of input"

let rec pre_order = function
  | Leaf v -> "Leaf:" ^ string_of_int v ^ "\n"
  | Node (v, left, right) ->
      "Node:" ^ v ^ "\n" ^
      pre_order left ^
      pre_order right

let rec post_order = function
  | Leaf v -> "Leaf:" ^ string_of_int v ^ "\n"
  | Node (v, left, right) ->
      post_order left ^
      post_order right ^
      "Node:" ^ v ^ "\n"

let rec in_order = function
  | Leaf v -> "Leaf:" ^ string_of_int v ^ "\n"
  | Node (v, left, right) ->
      in_order left ^
      "Node:" ^ v ^ "\n" ^
      in_order right

let rec size = function
  | Leaf _ -> 1
  | Node (_, left, right) -> 1 + size left + size right

let rec depth = function
  | Leaf _ -> 0
  | Node (_, left, right) -> 1 + max (depth left) (depth right)

let rec list_leaves_acc acc = function
  | Leaf v -> v :: acc
  | Node (_, left, right) ->
      list_leaves_acc (list_leaves_acc acc left) right

let list_leaves tree =
  let leaf_values = list_leaves_acc [] tree in
  List.rev leaf_values |> List.map string_of_int |> String.concat ", "

let result =
  match Sys.argv with
  | [| _; "pre-order" |] -> print_endline (pre_order (parse_input ()))
  | [| _; "post-order" |] -> print_endline (post_order (parse_input ()))
  | [| _; "in-order" |] -> print_endline (in_order (parse_input ()))
  | [| _; "list" |] -> print_endline (list_leaves (parse_input ()))
  | [| _; "size" |] ->
    let t = parse_input () in
    Printf.printf " %d\n" (size t)
  | [| _; "depth" |] -> print_endline (string_of_int (depth (parse_input ())))
  | _ -> exit 1
       

                  

                  
                  

      
      
      
      
      