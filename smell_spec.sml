use "./assertions.sml";

datatype itBlock      = It' of (string * (unit -> (string * bool)))
datatype decribeBlock = Describe' of (string * itBlock list)

fun It str f = It' (str, f)
fun Describe str l = Describe' (str, l)

structure SmellSpec =
struct
  local
    fun processIt (It' (str, f)) = (str, f())

    fun dotOrF it =
      case processIt(it) of
           (_, (_, true))  => "."
         | (_, (_, false)) => "F"

    fun processDescribe (Describe' (desc, its)) =
      let
        fun message it =
          case processIt(it) of
               (_, (_, true)) => ""
             | (str, (mesg, false)) => "FAIL: "^desc^", "^str^"\n"^mesg^"\n\n"

        val dots = foldl (fn (it, acc) => acc ^ dotOrF(it)) "" its
        val messages = foldl (fn (it, acc) => acc ^ message(it)) "" its
      in
        (dots, messages)
      end

    fun processDescribes describes =
      foldl (fn (desc, (accD, accM)) =>
              case (processDescribe(desc)) of
                   (dots, messages) => (accD^dots, accM^messages)
            ) ("", "") describes

    fun numberOfTests [] = 0
      | numberOfTests (t::ts) =
        let
          fun tests (Describe' (_, its)) = length its
        in
          tests(t) + numberOfTests(ts)
        end
  in
    fun runTests tests =
      let
        fun helper (dots, messages) = dots^"\n\n"^messages
        val numberOfTests = Int.toString(numberOfTests tests)
        val timer = Timer.startRealTimer()
      in
        (
          print "\nTest results\n\n"
        ; print (helper (processDescribes tests))
        ; print (numberOfTests^" "^(if numberOfTests = "1" then "test" else "tests"))
        ; print (" ran in ")
        ; print (Int.toString (Time.toMilliseconds(Timer.checkRealTimer timer)))
        ; print (" milliseconds")
        ; print "\n\n"
        )
      end
  end
end
