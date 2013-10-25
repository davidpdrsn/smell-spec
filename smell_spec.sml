datatype spec = It' of (string * (unit -> assertionResult))
              | Describe' of (string * spec list)
              | When' of (string * spec list)

fun It x y = It' (x, y)
fun Describe x y = Describe' (x, y)
fun When x y = When' (x, y)

structure SmellSpec =
struct
  local
    fun msgForAssertion ((str, f), desc, acc) =
      case f() of
           Passed => acc
         | Failed msg => acc^"FAIL: "^desc^str^"\n"^msg^"\n\n"

    fun dotForAssertion ((str, f), acc) =
      case f() of
           Passed => acc^"."
         | Failed msg => acc^"F"

    local
      fun process (desc, tests) =
        let
          fun s "" = ""
            | s x = x^" "
          fun helper' (desc, [], acc, prevDesc) = raise Domain
            | helper' (desc, test::tests, acc, prevDesc) =
              acc^
              helper((test, ""), s(prevDesc)^desc^" ")^
              (foldl (fn (x, acc) => acc^helper((x, ""), s(prevDesc)^desc)) "" tests)
          and helper ((It' x, acc), prevDesc) = msgForAssertion (x, desc^" "^prevDesc, acc)
            | helper ((Describe' (desc, tests), acc), prevDesc) =
              helper' (desc, tests, acc, prevDesc)
            | helper ((When' (desc, tests), acc), prevDesc) =
              helper' (desc, tests, acc, prevDesc)
        in
          foldl (fn (x, acc) => acc^helper((x, ""), "")) "" tests
        end

      fun makeMsg' (It' x) = msgForAssertion (x, "", "")
        | makeMsg' (Describe' (desc, tests)) = process (desc, tests)
        | makeMsg' (When' (desc, tests)) = process (desc, tests)
    in
      fun makeMsg x = makeMsg' x
    end

    local
      fun helper (desc, tests) =
        let
          fun foo (desc, [], acc) = acc
            | foo (desc, test::tests, acc) =
              acc^helper'(test, "")^(foldl helper' "" tests)
          and helper' (It' x, acc) = dotForAssertion (x, acc)
            | helper' (Describe' (desc, tests), acc) = foo (desc, tests, acc)
            | helper' (When' (desc, tests), acc) = foo (desc, tests, acc)
        in
          foldl helper' "" tests
        end
      and makeDot' (It' x) = dotForAssertion (x, "")
        | makeDot' (Describe' (desc, tests)) = helper (desc, tests)
        | makeDot' (When' (desc, tests)) = helper (desc, tests)
    in
      fun makeDot x = makeDot' x
    end

    local
      fun h x = foldl (fn (x, acc) => numberOfIts(x)+acc) 0 x
      and numberOfIts (It' _) = 1
        | numberOfIts (Describe' (_, x)) = h x
        | numberOfIts (When' (_, x)) = h x
    in
      fun numberOfTests x = foldl (fn (x, acc) => acc+numberOfIts(x)) 0 x
    end
  in
    fun runTests tests =
      let
        val dots = foldl (fn (x, acc) => acc^(makeDot x)) "" tests
        val msgs = foldl (fn (x, acc) => acc^(makeMsg x)) "" tests
        val timer = Timer.startRealTimer()
        val numberOfTests = Int.toString(numberOfTests tests)
      in
        (
          print "\n"
        ; print "Test results\n\n"
        ; print dots
        ; print "\n\n"
        ; print msgs
        ; print (numberOfTests^" "^(if numberOfTests = "1" then "test" else "tests"))
        ; print (" ran in ")
        ; print (Int.toString (Time.toMilliseconds(Timer.checkRealTimer timer)))
        ; print (" milliseconds")
        ; print "\n\n"
        )
      end
  end
end
