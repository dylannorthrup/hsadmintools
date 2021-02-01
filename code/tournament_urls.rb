#!/usr/bin/ruby -w

@tournament_hash = {
  "5fdcfeacaffbb17464342433" => "https://battlefy.com/hsesports/tournaments/5fdcfeacaffbb17464342433/stage",
  "600a5bf4d9ca200f90967179" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f90967179/stage",
  "600a5bf4d9ca200f9096717a" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f9096717a/stage",
  "600a5bf4d9ca200f9096717b" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f9096717b/stage",
  "600a5bf4d9ca200f9096717c" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f9096717c/stage",
  "600a5bf4d9ca200f9096717d" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f9096717d/stage",
  "600a5bf4d9ca200f9096717e" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f9096717e/stage",
  "600a5bf4d9ca200f9096717f" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f9096717f/stage",
  "600a5bf4d9ca200f90967180" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f90967180/stage",
  "600a5bf4d9ca200f90967181" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f90967181/stage",
  "600a5bf4d9ca200f90967182" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f90967182/stage",
  "600a5bf4d9ca200f90967183" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f90967183/stage",
  "600a5bf4d9ca200f90967184" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f90967184/stage",
  "600a5bf4d9ca200f90967185" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f90967185/stage",
  "600a5bf4d9ca200f90967186" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f90967186/stage",
  "600a5bf4d9ca200f90967187" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f90967187/stage",
  "600a5bf4d9ca200f90967188" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f90967188/stage",
  "600a5bf4d9ca200f90967189" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f90967189/stage",
  "600a5bf4d9ca200f9096718a" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f9096718a/stage",
  "600a5bf4d9ca200f9096718b" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f9096718b/stage",
  "600a5bf4d9ca200f9096718c" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f9096718c/stage",
  "600a5bf4d9ca200f9096718d" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f9096718d/stage",
  "600a5bf4d9ca200f9096718e" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f9096718e/stage",
  "600a5bf4d9ca200f9096718f" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f9096718f/stage",
  "600a5bf4d9ca200f90967190" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f90967190/stage",
  "600a5bf4d9ca200f90967191" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f90967191/stage",
  "600a5bf4d9ca200f90967192" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f90967192/stage",
  "600a5bf4d9ca200f90967193" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f90967193/stage",
  "600a5bf4d9ca200f90967194" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f90967194/stage",
  "600a5bf4d9ca200f90967195" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f90967195/stage",
  "600a5bf4d9ca200f90967196" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f90967196/stage",
  "600a5bf4d9ca200f90967197" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f90967197/stage",
  "600a5bf4d9ca200f90967198" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f90967198/stage",
  "600a5bf4d9ca200f90967199" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f90967199/stage",
  "600a5bf4d9ca200f9096719a" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f9096719a/stage",
  "600a5bf4d9ca200f9096719b" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f9096719b/stage",
  "600a5bf4d9ca200f9096719c" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f9096719c/stage",
  "600a5bf4d9ca200f9096719d" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f9096719d/stage",
  "600a5bf4d9ca200f9096719e" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f9096719e/stage",
  "600a5bf4d9ca200f9096719f" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f9096719f/stage",
  "600a5bf4d9ca200f909671a0" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671a0/stage",
  "600a5bf4d9ca200f909671a1" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671a1/stage",
  "600a5bf4d9ca200f909671a2" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671a2/stage",
  "600a5bf4d9ca200f909671a3" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671a3/stage",
  "600a5bf4d9ca200f909671a4" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671a4/stage",
  "600a5bf4d9ca200f909671a5" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671a5/stage",
  "600a5bf4d9ca200f909671a6" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671a6/stage",
  "600a5bf4d9ca200f909671a7" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671a7/stage",
  "600a5bf4d9ca200f909671a8" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671a8/stage",
  "600a5bf4d9ca200f909671a9" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671a9/stage",
  "600a5bf4d9ca200f909671aa" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671aa/stage",
  "600a5bf4d9ca200f909671ab" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671ab/stage",
  "600a5bf4d9ca200f909671ac" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671ac/stage",
  "600a5bf4d9ca200f909671ad" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671ad/stage",
  "600a5bf4d9ca200f909671ae" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671ae/stage",
  "600a5bf4d9ca200f909671af" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671af/stage",
  "600a5bf4d9ca200f909671b0" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671b0/stage",
  "600a5bf4d9ca200f909671b1" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671b1/stage",
  "600a5bf4d9ca200f909671b2" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671b2/stage",
  "600a5bf4d9ca200f909671b3" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671b3/stage",
  "600a5bf4d9ca200f909671b4" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671b4/stage",
  "600a5bf4d9ca200f909671b5" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671b5/stage",
  "600a5bf4d9ca200f909671b6" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671b6/stage",
  "600a5bf4d9ca200f909671b7" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671b7/stage",
  "600a5bf4d9ca200f909671b8" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671b8/stage",
  "600a5bf4d9ca200f909671b9" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671b9/stage",
  "600a5bf4d9ca200f909671ba" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671ba/stage",
  "600a5bf4d9ca200f909671bb" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671bb/stage",
  "600a5bf4d9ca200f909671bc" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671bc/stage",
  "600a5bf4d9ca200f909671bd" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671bd/stage",
  "600a5bf4d9ca200f909671be" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671be/stage",
  "600a5bf4d9ca200f909671bf" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671bf/stage",
  "600a5bf4d9ca200f909671c0" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671c0/stage",
  "600a5bf4d9ca200f909671c1" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671c1/stage",
  "600a5bf4d9ca200f909671c2" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671c2/stage",
  "600a5bf4d9ca200f909671c3" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671c3/stage",
  "600a5bf4d9ca200f909671c4" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671c4/stage",
  "600a5bf4d9ca200f909671c5" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671c5/stage",
  "600a5bf4d9ca200f909671c6" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671c6/stage",
  "600a5bf4d9ca200f909671c7" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671c7/stage",
  "600a5bf4d9ca200f909671c8" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671c8/stage",
  "600a5bf4d9ca200f909671c9" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671c9/stage",
  "600a5bf4d9ca200f909671ca" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671ca/stage",
  "600a5bf4d9ca200f909671cb" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671cb/stage",
  "600a5bf4d9ca200f909671cc" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671cc/stage",
  "600a5bf4d9ca200f909671cd" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671cd/stage",
  "600a5bf4d9ca200f909671ce" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671ce/stage",
  "600a5bf4d9ca200f909671cf" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671cf/stage",
  "600a5bf4d9ca200f909671d0" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671d0/stage",
  "600a5bf4d9ca200f909671d1" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671d1/stage",
  "600a5bf4d9ca200f909671d2" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671d2/stage",
  "600a5bf4d9ca200f909671d3" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671d3/stage",
  "600a5bf4d9ca200f909671d4" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671d4/stage",
  "600a5bf4d9ca200f909671d5" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671d5/stage",
  "600a5bf4d9ca200f909671d6" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671d6/stage",
  "600a5bf4d9ca200f909671d7" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671d7/stage",
  "600a5bf4d9ca200f909671d8" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671d8/stage",
  "600a5bf4d9ca200f909671d9" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671d9/stage",
  "600a5bf4d9ca200f909671da" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671da/stage",
  "600a5bf4d9ca200f909671db" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671db/stage",
  "600a5bf4d9ca200f909671dc" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671dc/stage",
  "600a5bf4d9ca200f909671dd" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671dd/stage",
  "600a5bf4d9ca200f909671de" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671de/stage",
  "600a5bf4d9ca200f909671e1" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671e1/stage",
  "600a5bf4d9ca200f909671df" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671df/stage",
  "600a5bf4d9ca200f909671e2" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671e2/stage",
  "600a5bf4d9ca200f909671e0" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671e0/stage",
  "600a5bf4d9ca200f909671e3" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671e3/stage",
  "600a5bf4d9ca200f909671e4" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671e4/stage",
  "600a5bf4d9ca200f909671e5" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671e5/stage",
  "600a5bf4d9ca200f909671e6" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671e6/stage",
  "600a5bf4d9ca200f909671ea" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671ea/stage",
  "600a5bf4d9ca200f909671eb" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671eb/stage",
  "600a5bf4d9ca200f909671ec" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671ec/stage",
  "600a5bf4d9ca200f909671ed" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671ed/stage",
  "600a5bf4d9ca200f909671ee" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671ee/stage",
  "600a5bf4d9ca200f909671ef" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671ef/stage",
  "600a5bf4d9ca200f909671e7" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671e7/stage",
  "600a5bf4d9ca200f909671e8" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671e8/stage",
  "600a5bf4d9ca200f909671e9" => "https://battlefy.com/hsesports/tournaments/600a5bf4d9ca200f909671e9/stage",
}
