(* let printlist items = *)
(*   Printf.printf "%s" (String.concat ", " (List.map string_of_int items));; *)

(* Day 1.1 *)
let arr1 = [3; 4; 2; 1; 3; 3]
let arr2 = [4; 3; 5; 3; 9; 3]
let rec zipdiff a b acc =
  match (a, b) with
  | [], [] -> List.rev acc
  | x::xs, y::ys -> zipdiff xs ys ( (x-y) :: acc)
  | _, _ -> failwith "Bad" ;;

let res = zipdiff arr1 arr2 [] in
List.iter (Printf.printf "%d ") res;;

let solution a b =
  let sorted1 = List.sort (compare) a and sorted2 = List.sort (compare) b in
  let diffed = zipdiff sorted1 sorted2 [] in
  List.fold_left (+) 0 (List.map abs diffed);;

let res2 = solution arr1 arr2 in
Printf.printf "%d " res2;;

(* Read a file and parse its two columns into separate lists *)
let read_file filename =
  let ic = open_in filename in
  let rec read_line acc1 acc2 =
    try
      let line = input_line ic in
      match Str.split (Str.regexp {| +|}) line with
      | [x; y] -> read_line (int_of_string x :: acc1) (int_of_string y :: acc2)
      | _ -> failwith ("Malformed line, got: " ^ line)
    with
    | End_of_file -> (List.rev acc1, List.rev acc2)  (* Reverse to maintain order *)
  in
  let result =
    try
      read_line [] []
    with e ->
      close_in_noerr ic;
      raise e
  in
  close_in ic;
  result

let () =
  let col1, col2 = read_file "bin/day1.txt" in let result_d1p1 = solution col1 col2 in
  (* Printf.printf "Column 1: %s\n" (String.concat ", " (List.map string_of_int col1)); *)
  (* Printf.printf "Column 2: %s\n" (String.concat ", " (List.map string_of_int col2)); *)
  Printf.printf "\nSolution p1: %s\n" (string_of_int result_d1p1);;

(* Day 1.2 *)
(*
  Pseudocode
  ----------
  We need to do something like:
    - For each element of array 1, multiply its value by the number of times it occurs in array 2. Sum the results.
    - sum(map(x -> x*occurences(x, array2), array1))

  Example
  ------
  let arr1 = [3; 4; 2; 1; 3; 3]
  let arr2 = [4; 3; 5; 3; 9; 3]
  3*3 + 4*1 + 2*0 + 1*0 + 3*3 + 3*3 = 31
*)

(* Helper since we are going to sum over bools *)
let eq a b = Bool.to_int (a = b);;

(* Count occurrences of int in list[int] *)
let occurrences arr x =
  List.fold_left (+) 0 (List.map (eq x) arr);;

(* Verify it works for the test input *)
assert ((occurrences arr2 9) = 1);;
assert ((occurrences arr2 3) = 3);;

let sum arr = List.fold_left (+) 0 arr;;

(*  value*n_occurences *)
let mulocc items1 x =
  x*(occurrences items1 x);; (* val*n_occ*)

(* sum value*n_occurences *)
let solution_d1p2 items1 items2 =
  items2
  |> List.map (mulocc items1)  (* val*n_occ*)
  |> sum;; (* Sum [val*n_occ] *)


let test_input_result_d1p2 = solution_d1p2 arr1 arr2 in Printf.printf "%d " test_input_result_d1p2;;

let col1, col2 = read_file "bin/day1.txt" in 
  let answer_d1p2 = solution_d1p2 col1 col2 in
  Printf.printf "\nSolution p2: %s\n" (string_of_int answer_d1p2);;

(* Day 2 *)
(*
  Pseudocode
  ----------
  results = map(is_valid, rows)

  (* Checks both conditions to see if a row is valid *)
  is_valid = is_monotonic and is_safe_change

  (* Checks if a row is strictly monotonic *)
  is_monotonic row =
    prev = row[0]
    increasing = row[0] < row[1]
    for x in row:
      if prev >= x and increasing: return false
      if prev <= x and not increasing: return false
    return true

  (* Checks if the changes are at least 1 and at most 3 *)
  is_safe_change row =
    changes = [abs(a-b) for (a, b) in pairs(row)]
    return all(1 <= changes <= 3)
*)

(* Checks if a list is strictly monotonic *)
let is_monotonic row =
  match row with
  | [] | [_] -> true  (* Base cases: empty or single-element list *)
  | x1 :: x2 :: xs ->
      let increasing = x1 < x2 in
      let rec aux prev = function
        | [] -> true
        | y :: ys ->
            if (prev < y) <> increasing then false
            else aux y ys
      in aux x2 xs

(* Test cases *)
let () =
  let test1 = is_monotonic [1; 2; 3; 4] in  (* true *)
  let test2 = is_monotonic [4; 3; 2; 1] in  (* true *)
  let test3 = is_monotonic [1; 3; 2; 4] in  (* false *)
  let test4 = is_monotonic [1] in           (* true *)
  let test5 = is_monotonic [] in            (* true *)
  Printf.printf "Test 1: %b\nTest 2: %b\nTest 3: %b\nTest 4: %b\nTest 5: %b\n"
    test1 test2 test3 test4 test5
