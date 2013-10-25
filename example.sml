use "assertions.sml";
use "smell_spec.sml";

val _ = SmellSpec.runTests [
  Describe "math" [
    It "can do addition" (fn _ => Assert.equal (2,2))
  ]
]
