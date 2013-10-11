datatype itBlock      = It' of (string * (unit -> bool))
datatype decribeBlock = Describe' of (string * itBlock list)

fun It str f = It' (str, f)
fun Describe str l = Describe' (str, l)

structure Assert =
struct
  fun equal (x, y) = x = y
end

structure AssertNot =
struct
  fun equal (x, y) = x <> y
end

structure SmellSpec =
struct
  local
    fun processIt (It' (str, f)) = (str, f())

    fun dotOrF it =
      case processIt(it) of
           (_, true)  => "."
         | (_, false) => "F"

    fun processDescribe (Describe' (desc, its)) =
      let
        fun message it =
          case processIt(it) of
               (str, true) => ""
             | (str, false) => "FAIL: "^desc^", "^str^"\n\n"

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

  in
    fun runTests tests =
      let
        fun helper (dots, messages) = dots^"\n\n"^messages
      in
        (
          print "\nTest results\n\n"
        ; print (helper (processDescribes tests))
        ; print "\n"
        )
      end
  end
end
