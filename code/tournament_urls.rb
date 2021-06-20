#!/usr/bin/ruby -w

@tournament_hash = {
  "6093cc1e140480419bec5948" => "https://battlefy.com/hsesports/tournaments/6093cc1e140480419bec5948/stage",
  "609dafe88aefa26532815457" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815457/stage",
  "609dafe88aefa26532815458" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815458/stage",
  "609dafe88aefa26532815459" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815459/stage",
  "609dafe88aefa2653281545a" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281545a/stage",
  "609dafe88aefa2653281545b" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281545b/stage",
  "609dafe88aefa2653281545c" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281545c/stage",
  "609dafe88aefa2653281545d" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281545d/stage",
  "609dafe88aefa2653281545e" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281545e/stage",
  "609dafe88aefa2653281545f" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281545f/stage",
  "609dafe88aefa26532815460" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815460/stage",
  "609dafe88aefa26532815461" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815461/stage",
  "609dafe88aefa26532815462" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815462/stage",
  "609dafe88aefa26532815463" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815463/stage",
  "609dafe88aefa26532815464" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815464/stage",
  "609dafe88aefa26532815465" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815465/stage",
  "609dafe88aefa26532815466" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815466/stage",
  "609dafe88aefa26532815467" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815467/stage",
  "609dafe88aefa26532815468" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815468/stage",
  "609dafe88aefa26532815469" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815469/stage",
  "609dafe88aefa2653281546a" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281546a/stage",
  "609dafe88aefa2653281546b" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281546b/stage",
  "609dafe88aefa2653281546c" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281546c/stage",
  "609dafe88aefa2653281546d" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281546d/stage",
  "609dafe88aefa2653281546e" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281546e/stage",
  "609dafe88aefa2653281546f" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281546f/stage",
  "609dafe88aefa26532815470" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815470/stage",
  "609dafe88aefa26532815471" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815471/stage",
  "609dafe88aefa26532815472" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815472/stage",
  "609dafe88aefa26532815473" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815473/stage",
  "609dafe88aefa26532815474" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815474/stage",
  "609dafe88aefa26532815475" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815475/stage",
  "609dafe88aefa26532815476" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815476/stage",
  "609dafe88aefa26532815477" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815477/stage",
  "609dafe88aefa26532815478" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815478/stage",
  "609dafe88aefa26532815479" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815479/stage",
  "609dafe88aefa2653281547a" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281547a/stage",
  "609dafe88aefa2653281547b" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281547b/stage",
  "609dafe88aefa2653281547c" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281547c/stage",
  "609dafe88aefa2653281547d" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281547d/stage",
  "609dafe88aefa2653281547e" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281547e/stage",
  "609dafe88aefa2653281547f" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281547f/stage",
  "609dafe88aefa26532815480" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815480/stage",
  "609dafe88aefa26532815481" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815481/stage",
  "609dafe88aefa26532815482" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815482/stage",
  "609dafe88aefa26532815483" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815483/stage",
  "609dafe88aefa26532815484" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815484/stage",
  "609dafe88aefa26532815485" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815485/stage",
  "609dafe88aefa26532815486" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815486/stage",
  "609dafe88aefa26532815487" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815487/stage",
  "609dafe88aefa26532815488" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815488/stage",
  "609dafe88aefa26532815489" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815489/stage",
  "609dafe88aefa2653281548a" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281548a/stage",
  "609dafe88aefa2653281548b" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281548b/stage",
  "609dafe88aefa2653281548c" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281548c/stage",
  "609dafe88aefa2653281548d" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281548d/stage",
  "609dafe88aefa2653281548e" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281548e/stage",
  "609dafe88aefa2653281548f" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281548f/stage",
  "609dafe88aefa26532815490" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815490/stage",
  "609dafe88aefa26532815491" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815491/stage",
  "609dafe88aefa26532815492" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815492/stage",
  "609dafe88aefa26532815493" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815493/stage",
  "609dafe88aefa26532815494" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815494/stage",
  "609dafe88aefa26532815495" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815495/stage",
  "609dafe88aefa26532815496" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815496/stage",
  "609dafe88aefa26532815497" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815497/stage",
  "609dafe88aefa26532815498" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815498/stage",
  "609dafe88aefa26532815499" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa26532815499/stage",
  "609dafe88aefa2653281549a" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281549a/stage",
  "609dafe88aefa2653281549b" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281549b/stage",
  "609dafe88aefa2653281549c" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281549c/stage",
  "609dafe88aefa2653281549d" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281549d/stage",
  "609dafe88aefa2653281549e" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281549e/stage",
  "609dafe88aefa2653281549f" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa2653281549f/stage",
  "609dafe88aefa265328154a0" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154a0/stage",
  "609dafe88aefa265328154a1" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154a1/stage",
  "609dafe88aefa265328154a2" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154a2/stage",
  "609dafe88aefa265328154a3" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154a3/stage",
  "609dafe88aefa265328154a4" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154a4/stage",
  "609dafe88aefa265328154a5" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154a5/stage",
  "609dafe88aefa265328154a6" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154a6/stage",
  "609dafe88aefa265328154a7" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154a7/stage",
  "609dafe88aefa265328154a8" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154a8/stage",
  "609dafe88aefa265328154a9" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154a9/stage",
  "609dafe88aefa265328154aa" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154aa/stage",
  "609dafe88aefa265328154ab" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154ab/stage",
  "609dafe88aefa265328154ac" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154ac/stage",
  "609dafe88aefa265328154ad" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154ad/stage",
  "609dafe88aefa265328154ae" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154ae/stage",
  "609dafe88aefa265328154af" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154af/stage",
  "609dafe88aefa265328154b0" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154b0/stage",
  "609dafe88aefa265328154b1" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154b1/stage",
  "609dafe88aefa265328154b2" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154b2/stage",
  "609dafe88aefa265328154b3" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154b3/stage",
  "609dafe88aefa265328154b4" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154b4/stage",
  "609dafe88aefa265328154b5" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154b5/stage",
  "609dafe88aefa265328154b6" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154b6/stage",
  "609dafe88aefa265328154b7" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154b7/stage",
  "609dafe88aefa265328154b8" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154b8/stage",
  "609dafe88aefa265328154b9" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154b9/stage",
  "609dafe88aefa265328154ba" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154ba/stage",
  "609dafe88aefa265328154bb" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154bb/stage",
  "609dafe88aefa265328154bc" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154bc/stage",
  "609dafe88aefa265328154bd" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154bd/stage",
  "609dafe88aefa265328154be" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154be/stage",
  "609dafe88aefa265328154bf" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154bf/stage",
  "609dafe88aefa265328154c0" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154c0/stage",
  "609dafe88aefa265328154c1" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154c1/stage",
  "609dafe88aefa265328154c2" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154c2/stage",
  "609dafe88aefa265328154c3" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154c3/stage",
  "609dafe88aefa265328154c4" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154c4/stage",
  "609dafe88aefa265328154c5" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154c5/stage",
  "609dafe88aefa265328154c6" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154c6/stage",
  "609dafe88aefa265328154c7" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154c7/stage",
  "609dafe88aefa265328154c8" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154c8/stage",
  "609dafe88aefa265328154c9" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154c9/stage",
  "609dafe88aefa265328154ca" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154ca/stage",
  "609dafe88aefa265328154cb" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154cb/stage",
  "609dafe88aefa265328154cc" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154cc/stage",
  "609dafe88aefa265328154cd" => "https://battlefy.com/hsesports/tournaments/609dafe88aefa265328154cd/stage",
}
