datatype spec = It' of (string * (unit -> assertionResult))
              | Describe' of (string * spec list)
              | When' of (string * spec list)

fun It x y = It' (x, y)
fun Describe x y = Describe' (x, y)
fun When x y = When' (x, y)

structure SmellSpec =
struct
  local
    (* Slightly smarter string concatenation *)
    fun cat ("", b) = b
      | cat (a, "") = a
      | cat (a, b) = a ^ " " ^ b

    (* Flattens a tree structure of tests into a linear list *)
    fun flattenTests (tests: spec list) =
      let
        fun flatMap (f, l) = List.concat(List.map f l)
        fun flattenWithContext (t: spec, ctxt: string) =
          case t of
               It' (msg, test) => [{ctxt=cat(ctxt, msg), test=test}]
             | Describe' (what, subtests) => flatMap(
                 (fn t => flattenWithContext(t, cat(ctxt, what))),
                 subtests)
             | When' (subcontext, subtests) => flatMap(
                 (fn t => flattenWithContext(t, cat(ctxt, subcontext))),
                 subtests)
      in
        flatMap((fn t => flattenWithContext(t, "")), tests)
      end

    fun runSingleTest f =
      f() handle error => Failed ("raised " ^ exnMessage(error))

    fun constructMessages testsWithResults =
      let fun messageForTest {result=Passed, ...} = ""
            | messageForTest {result=(Failed msg), ctxt="", ...} = msg ^ "\n"
            | messageForTest {result=(Failed msg), ctxt=ctxt, test=_} = ctxt ^ ": " ^ msg ^ "\n"
      in
        foldr (op ^) "" (map messageForTest testsWithResults)
      end

    fun constructDots results =
      let fun dotForResult Passed = "."
            | dotForResult (Failed _) = "F"
      in
        foldr (op ^) "" (map dotForResult results)
      end

  in
    fun runTests tests =
      let
        val flattenedTests = flattenTests tests
        val results = (map runSingleTest (map #test flattenedTests))
        val testsWithResults = (map
          (fn (a, b) => {ctxt=(#ctxt a), test=(#test a), result=b})
          (ListPair.zip(flattenedTests, results)))
        val dots = constructDots results
        val messages = constructMessages testsWithResults
        val numberOfTests = length flattenedTests
      in
        (
          print "\n"
        ; print "Test results\n\n"
        ; print (dots ^ "\n\n")
        ; print (messages ^ "\n")
        ; print (Int.toString(numberOfTests) ^ " " ^ (if numberOfTests = 1 then "test" else "tests") ^ "\n")
        )
      end
  end
end
