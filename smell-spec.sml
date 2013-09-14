(* General equal *)

infix is;
fun n is m = (n = m, "");

(* Exceptions *)

infix should_raise;
fun (f, args) should_raise e =
  (f args; (false, "No exception was raised"))
  handle e' => if exnName e = exnName e' then (true, "")
               else (false, "expected " ^ exnName e ^ " to be raise but got " ^
               exnName e');

(* Int *)

infix is_int;
fun n is_int m = (n = m,
  "expected " ^ Int.toString(m) ^ " to equal " ^ Int.toString(n));

infix is_not_int;
fun n is_not_int m = (n <> m,
  "expected " ^ Int.toString(m) ^ " not to equal " ^ Int.toString(n));

infix is_greater_than_int;
fun n is_greater_than_int m = (n > m,
  "expected " ^ Int.toString(m) ^ " to be greater than " ^ Int.toString(n));

infix is_not_greater_than_int;
fun n is_not_greater_than_int m = (n < m,
  "expected " ^ Int.toString(m) ^ " not to be greater than " ^ Int.toString(n));

infix is_less_than_int;
fun n is_less_than_int m = (n < m,
  "expected " ^ Int.toString(m) ^ " to be less than " ^ Int.toString(n));

infix is_not_less_than_int;
fun n is_not_less_than_int m = (n > m,
  "expected " ^ Int.toString(m) ^ " not to be less than " ^ Int.toString(n));

(* String *)

infix is_str;
fun n is_str m = (n = m, "expected \"" ^ m ^ "\" to equal \"" ^ n ^ "\"");

(* ------------- *)

val testResults = ref ["", ""];

fun append (str1, str2) =
  testResults := [List.nth(!testResults, 0) ^ str1, List.nth(!testResults, 1) ^ str2];

fun describe (desc_text, x) =
  let
    fun dot (str, (boolean, message)) =
      if boolean then "." else "F"

    fun all_dots [] = ""
      | all_dots (x::xs) = dot(x) ^ all_dots(xs)

    fun failure_message (str, (boolean, message)) =
      if boolean then "" else "\n\nFAIL: " ^ desc_text ^ " " ^ str ^ "\n" ^ message

    fun all_failure_messages [] = ""
      | all_failure_messages (x::xs) = failure_message(x) ^ all_failure_messages(xs)
  in
    append(all_dots(x), all_failure_messages(x))
  end;

fun this (text, assertion) = (text, assertion);

fun joinList [] = ""
  | joinList (x::xs) = x ^ joinList(xs);

fun runTests () = print(joinList(!testResults) ^ "\n\n");
