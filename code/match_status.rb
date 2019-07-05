#!/usr/bin/ruby -w
#
#

require 'open-uri'
require 'json'
require 'cgi'
require 'mysql'
require 'date'

@cgi = CGI.new
params = @cgi.params

@out_dir = "/home/docxstudios/web/hs/snapshots"
@tournament_type='swiss'  # Other option is 'single_elim'

@tournament_hash = {
  "5cf17673e6c9150307a0dacc" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-1/5cf17673e6c9150307a0dacc/stage",
  "5cf17673e6c9150307a0dacd" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-2/5cf17673e6c9150307a0dacd/stage",
  "5cf17673e6c9150307a0dace" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-3/5cf17673e6c9150307a0dace/stage",
  "5cf17673e6c9150307a0dacf" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-4/5cf17673e6c9150307a0dacf/stage",
  "5cf17673e6c9150307a0dad0" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-5/5cf17673e6c9150307a0dad0/stage",
  "5cf17673e6c9150307a0dad1" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-6/5cf17673e6c9150307a0dad1/stage",
  "5cf17673e6c9150307a0dad2" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-7/5cf17673e6c9150307a0dad2/stage",
  "5cf17673e6c9150307a0dad3" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-8/5cf17673e6c9150307a0dad3/stage",
  "5cf17673e6c9150307a0dad4" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-9/5cf17673e6c9150307a0dad4/stage",
  "5cf17673e6c9150307a0dad5" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-10/5cf17673e6c9150307a0dad5/stage",
  "5cf17673e6c9150307a0dad6" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-11/5cf17673e6c9150307a0dad6/stage",
  "5cf17673e6c9150307a0dad7" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-12/5cf17673e6c9150307a0dad7/stage",
  "5cf17673e6c9150307a0dad8" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-13/5cf17673e6c9150307a0dad8/stage",
  "5cf17673e6c9150307a0dad9" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-14/5cf17673e6c9150307a0dad9/stage",
  "5cf17673e6c9150307a0dada" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-15/5cf17673e6c9150307a0dada/stage",
  "5cf17673e6c9150307a0dadb" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-16/5cf17673e6c9150307a0dadb/stage",
  "5cf17673e6c9150307a0dadc" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-17/5cf17673e6c9150307a0dadc/stage",
  "5cf17673e6c9150307a0dadd" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-18/5cf17673e6c9150307a0dadd/stage",
  "5cf17673e6c9150307a0dade" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-20/5cf17673e6c9150307a0dade/stage",
  "5cf17673e6c9150307a0dadf" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-22/5cf17673e6c9150307a0dadf/stage",
  "5cf17673e6c9150307a0dae0" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-24/5cf17673e6c9150307a0dae0/stage",
  "5cf17673e6c9150307a0dae1" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-25/5cf17673e6c9150307a0dae1/stage",
  "5cf17673e6c9150307a0dae2" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-26/5cf17673e6c9150307a0dae2/stage",
  "5cf17673e6c9150307a0dae3" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-27/5cf17673e6c9150307a0dae3/stage",
  "5cf17673e6c9150307a0dae4" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-28/5cf17673e6c9150307a0dae4/stage",
  "5cf17673e6c9150307a0dae5" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-29/5cf17673e6c9150307a0dae5/stage",
  "5cf17673e6c9150307a0dae6" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-30/5cf17673e6c9150307a0dae6/stage",
  "5cf17673e6c9150307a0dae7" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-31/5cf17673e6c9150307a0dae7/stage",
  "5cf17673e6c9150307a0dae8" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-32/5cf17673e6c9150307a0dae8/stage",
  "5cf17673e6c9150307a0dae9" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-33/5cf17673e6c9150307a0dae9/stage",
  "5cf17673e6c9150307a0daea" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-34/5cf17673e6c9150307a0daea/stage",
  "5cf17673e6c9150307a0daeb" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-35/5cf17673e6c9150307a0daeb/stage",
  "5cf17673e6c9150307a0daec" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-36/5cf17673e6c9150307a0daec/stage",
  "5cf17673e6c9150307a0daed" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-37/5cf17673e6c9150307a0daed/stage",
  "5cf17673e6c9150307a0daee" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-38/5cf17673e6c9150307a0daee/stage",
  "5cf17673e6c9150307a0daef" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-39/5cf17673e6c9150307a0daef/stage",
  "5cf17673e6c9150307a0daf0" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-40/5cf17673e6c9150307a0daf0/stage",
  "5cf17673e6c9150307a0daf1" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-41/5cf17673e6c9150307a0daf1/stage",
  "5cf17673e6c9150307a0daf2" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-42/5cf17673e6c9150307a0daf2/stage",
  "5cf17673e6c9150307a0daf3" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-43/5cf17673e6c9150307a0daf3/stage",
  "5cf17673e6c9150307a0daf4" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-44/5cf17673e6c9150307a0daf4/stage",
  "5cf17673e6c9150307a0daf5" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-45/5cf17673e6c9150307a0daf5/stage",
  "5cf17673e6c9150307a0daf6" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-46/5cf17673e6c9150307a0daf6/stage",
  "5cf17673e6c9150307a0daf7" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-47/5cf17673e6c9150307a0daf7/stage",
  "5cf17673e6c9150307a0daf8" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-48/5cf17673e6c9150307a0daf8/stage",
  "5cf17673e6c9150307a0daf9" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-49/5cf17673e6c9150307a0daf9/stage",
  "5cf17673e6c9150307a0dafa" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-50/5cf17673e6c9150307a0dafa/stage",
  "5cf17673e6c9150307a0dafb" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-51/5cf17673e6c9150307a0dafb/stage",
  "5cf17673e6c9150307a0dafc" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-52/5cf17673e6c9150307a0dafc/stage",
  "5cf17673e6c9150307a0dafd" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-53/5cf17673e6c9150307a0dafd/stage",
  "5cf17673e6c9150307a0dafe" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-54/5cf17673e6c9150307a0dafe/stage",
  "5cf17673e6c9150307a0daff" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-55/5cf17673e6c9150307a0daff/stage",
  "5cf17673e6c9150307a0db00" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-56/5cf17673e6c9150307a0db00/stage",
  "5cf17673e6c9150307a0db01" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-57/5cf17673e6c9150307a0db01/stage",
  "5cf17673e6c9150307a0db02" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-58/5cf17673e6c9150307a0db02/stage",
  "5cf17673e6c9150307a0db03" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-59/5cf17673e6c9150307a0db03/stage",
  "5cf17673e6c9150307a0db04" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-60/5cf17673e6c9150307a0db04/stage",
  "5cf17673e6c9150307a0db05" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-61/5cf17673e6c9150307a0db05/stage",
  "5cf17673e6c9150307a0db06" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-62/5cf17673e6c9150307a0db06/stage",
  "5cf17673e6c9150307a0db07" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-63/5cf17673e6c9150307a0db07/stage",
  "5cf17673e6c9150307a0db08" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-64/5cf17673e6c9150307a0db08/stage",
  "5cf17673e6c9150307a0db09" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-65/5cf17673e6c9150307a0db09/stage",
  "5cf17673e6c9150307a0db0a" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-66/5cf17673e6c9150307a0db0a/stage",
  "5cf17673e6c9150307a0db0b" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-67/5cf17673e6c9150307a0db0b/stage",
  "5cf17673e6c9150307a0db0c" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-68/5cf17673e6c9150307a0db0c/stage",
  "5cf17673e6c9150307a0db0d" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-69/5cf17673e6c9150307a0db0d/stage",
  "5cf17673e6c9150307a0db0e" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-70/5cf17673e6c9150307a0db0e/stage",
  "5cf17673e6c9150307a0db0f" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-71/5cf17673e6c9150307a0db0f/stage",
  "5cf17673e6c9150307a0db10" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-72/5cf17673e6c9150307a0db10/stage",
  "5cf17673e6c9150307a0db11" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-73/5cf17673e6c9150307a0db11/stage",
  "5cf17673e6c9150307a0db12" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-74/5cf17673e6c9150307a0db12/stage",
  "5cf17673e6c9150307a0db13" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-75/5cf17673e6c9150307a0db13/stage",
  "5cf17673e6c9150307a0db14" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-76/5cf17673e6c9150307a0db14/stage",
  "5cf17673e6c9150307a0db15" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-77/5cf17673e6c9150307a0db15/stage",
  "5cf17673e6c9150307a0db16" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-78/5cf17673e6c9150307a0db16/stage",
  "5cf17673e6c9150307a0db17" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-79/5cf17673e6c9150307a0db17/stage",
  "5cf17673e6c9150307a0db18" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-80/5cf17673e6c9150307a0db18/stage",
  "5cf17673e6c9150307a0db19" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-81/5cf17673e6c9150307a0db19/stage",
  "5cf17673e6c9150307a0db1a" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-82/5cf17673e6c9150307a0db1a/stage",
  "5cf17673e6c9150307a0db1b" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-83/5cf17673e6c9150307a0db1b/stage",
  "5cf17673e6c9150307a0db1c" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-84/5cf17673e6c9150307a0db1c/stage",
  "5cf17673e6c9150307a0db1d" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-85/5cf17673e6c9150307a0db1d/stage",
  "5cf17673e6c9150307a0db1e" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-86/5cf17673e6c9150307a0db1e/stage",
  "5cf17673e6c9150307a0db1f" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-87/5cf17673e6c9150307a0db1f/stage",
  "5cf17673e6c9150307a0db20" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-88/5cf17673e6c9150307a0db20/stage",
  "5cf17673e6c9150307a0db21" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-89/5cf17673e6c9150307a0db21/stage",
  "5cf17673e6c9150307a0db22" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-90/5cf17673e6c9150307a0db22/stage",
  "5cf17673e6c9150307a0db23" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-91/5cf17673e6c9150307a0db23/stage",
  "5cf17673e6c9150307a0db24" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-92/5cf17673e6c9150307a0db24/stage",
  "5cf17673e6c9150307a0db25" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-93/5cf17673e6c9150307a0db25/stage",
  "5cf17673e6c9150307a0db26" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-94/5cf17673e6c9150307a0db26/stage",
  "5cf17673e6c9150307a0db27" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-95/5cf17673e6c9150307a0db27/stage",
  "5cf17673e6c9150307a0db28" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-96/5cf17673e6c9150307a0db28/stage",
  "5cf17673e6c9150307a0db29" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-97/5cf17673e6c9150307a0db29/stage",
  "5cf17673e6c9150307a0db2a" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-98/5cf17673e6c9150307a0db2a/stage",
  "5cf17673e6c9150307a0db2b" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-99/5cf17673e6c9150307a0db2b/stage",
  "5cf17673e6c9150307a0db2c" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-100/5cf17673e6c9150307a0db2c/stage",
  "5cf17673e6c9150307a0db2d" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-101/5cf17673e6c9150307a0db2d/stage",
  "5cf17673e6c9150307a0db2e" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-102/5cf17673e6c9150307a0db2e/stage",
  "5cf17673e6c9150307a0db2f" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-103/5cf17673e6c9150307a0db2f/stage",
  "5cf17673e6c9150307a0db30" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-104/5cf17673e6c9150307a0db30/stage",
  "5cf17673e6c9150307a0db31" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-105/5cf17673e6c9150307a0db31/stage",
  "5cf17673e6c9150307a0db32" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-106/5cf17673e6c9150307a0db32/stage",
  "5cf17673e6c9150307a0db33" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-107/5cf17673e6c9150307a0db33/stage",
  "5cf17673e6c9150307a0db34" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-108/5cf17673e6c9150307a0db34/stage",
  "5cf17673e6c9150307a0db35" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-109/5cf17673e6c9150307a0db35/stage",
  "5cf17673e6c9150307a0db36" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-110/5cf17673e6c9150307a0db36/stage",
  "5cf17673e6c9150307a0db37" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-111/5cf17673e6c9150307a0db37/stage",
  "5cf17673e6c9150307a0db38" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-112/5cf17673e6c9150307a0db38/stage",
  "5cf17673e6c9150307a0db39" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-113/5cf17673e6c9150307a0db39/stage",
  "5cf17673e6c9150307a0db3a" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-114/5cf17673e6c9150307a0db3a/stage",
  "5cf17673e6c9150307a0db3b" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-116/5cf17673e6c9150307a0db3b/stage",
  "5cf17673e6c9150307a0db3c" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-118/5cf17673e6c9150307a0db3c/stage",
  "5cf17673e6c9150307a0db3d" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-120/5cf17673e6c9150307a0db3d/stage",
  "5d1be516468f0e6079f812a5" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-asia-ladder-qualifier-july/5d1be516468f0e6079f812a5/stage",
  "5d1be4713c523d5ea9a2acc7" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-europe-ladder-qualifier-july/5d1be4713c523d5ea9a2acc7/stage",
  "5d1be2963e32cd6352a21218" => "https://battlefy.com/hsesports/hearthstone-masters-qualifier-bucharest-americas-ladder-qualifier-july/5d1be2963e32cd6352a21218/stage",
  '5cbf4115a26a68033a3cefb8' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-1/5cbf4115a26a68033a3cefb8/stage',
  '5cbf451f61ef9b0308be5e5c' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-2/5cbf451f61ef9b0308be5e5c/stage',
  '5cbf451f61ef9b0308be5e5d' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-3/5cbf451f61ef9b0308be5e5d/stage',
  '5cbf451f61ef9b0308be5e5e' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-4/5cbf451f61ef9b0308be5e5e/stage',
  '5cbf451f61ef9b0308be5e5f' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-5/5cbf451f61ef9b0308be5e5f/stage',
  '5cbf451f61ef9b0308be5e60' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-6/5cbf451f61ef9b0308be5e60/stage',
  '5cbf451f61ef9b0308be5e61' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-7/5cbf451f61ef9b0308be5e61/stage',
  '5cbf451f61ef9b0308be5e62' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-8/5cbf451f61ef9b0308be5e62/stage',
  '5cbf451f61ef9b0308be5e63' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-9/5cbf451f61ef9b0308be5e63/stage',
  '5cbf451f61ef9b0308be5e64' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-10/5cbf451f61ef9b0308be5e64/stage',
  '5cbf451f61ef9b0308be5e65' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-11/5cbf451f61ef9b0308be5e65/stage',
  '5cbf451f61ef9b0308be5e66' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-12/5cbf451f61ef9b0308be5e66/stage',
  '5cbf451f61ef9b0308be5e67' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-13/5cbf451f61ef9b0308be5e67/stage',
  '5cbf451f61ef9b0308be5e68' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-14/5cbf451f61ef9b0308be5e68/stage',
  '5cbf451f61ef9b0308be5e69' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-15/5cbf451f61ef9b0308be5e69/stage',
  '5cbf451f61ef9b0308be5e6a' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-16/5cbf451f61ef9b0308be5e6a/stage',
  '5cbf451f61ef9b0308be5e6b' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-17/5cbf451f61ef9b0308be5e6b/stage',
  '5cbf451f61ef9b0308be5e6c' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-18/5cbf451f61ef9b0308be5e6c/stage',
  '5cbf451f61ef9b0308be5e6d' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-20/5cbf451f61ef9b0308be5e6d/stage',
  '5cbf451f61ef9b0308be5e6e' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-22/5cbf451f61ef9b0308be5e6e/stage',
  '5cbf451f61ef9b0308be5e6f' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-24/5cbf451f61ef9b0308be5e6f/stage',
  '5cbf451f61ef9b0308be5e70' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-25/5cbf451f61ef9b0308be5e70/stage',
  '5cbf451f61ef9b0308be5e71' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-26/5cbf451f61ef9b0308be5e71/stage',
  '5cbf451f61ef9b0308be5e72' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-27/5cbf451f61ef9b0308be5e72/stage',
  '5cbf451f61ef9b0308be5e73' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-28/5cbf451f61ef9b0308be5e73/stage',
  '5cbf451f61ef9b0308be5e74' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-29/5cbf451f61ef9b0308be5e74/stage',
  '5cbf451f61ef9b0308be5e75' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-30/5cbf451f61ef9b0308be5e75/stage',
  '5cbf451f61ef9b0308be5e76' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-31/5cbf451f61ef9b0308be5e76/stage',
  '5cbf451f61ef9b0308be5e77' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-32/5cbf451f61ef9b0308be5e77/stage',
  '5cbf451f61ef9b0308be5e78' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-33/5cbf451f61ef9b0308be5e78/stage',
  '5cbf451f61ef9b0308be5e79' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-34/5cbf451f61ef9b0308be5e79/stage',
  '5cbf451f61ef9b0308be5e7a' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-35/5cbf451f61ef9b0308be5e7a/stage',
  '5cbf451f61ef9b0308be5e7b' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-36/5cbf451f61ef9b0308be5e7b/stage',
  '5cbf451f61ef9b0308be5e7c' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-37/5cbf451f61ef9b0308be5e7c/stage',
  '5cbf451f61ef9b0308be5e7d' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-38/5cbf451f61ef9b0308be5e7d/stage',
  '5cbf451f61ef9b0308be5e7e' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-39/5cbf451f61ef9b0308be5e7e/stage',
  '5cbf451f61ef9b0308be5e7f' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-40/5cbf451f61ef9b0308be5e7f/stage',
  '5cbf451f61ef9b0308be5e80' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-41/5cbf451f61ef9b0308be5e80/stage',
  '5cbf451f61ef9b0308be5e81' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-42/5cbf451f61ef9b0308be5e81/stage',
  '5cbf451f61ef9b0308be5e82' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-43/5cbf451f61ef9b0308be5e82/stage',
  '5cbf451f61ef9b0308be5e83' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-44/5cbf451f61ef9b0308be5e83/stage',
  '5cbf451f61ef9b0308be5e84' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-45/5cbf451f61ef9b0308be5e84/stage',
  '5cbf451f61ef9b0308be5e85' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-46/5cbf451f61ef9b0308be5e85/stage',
  '5cbf451f61ef9b0308be5e86' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-47/5cbf451f61ef9b0308be5e86/stage',
  '5cbf451f61ef9b0308be5e87' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-48/5cbf451f61ef9b0308be5e87/stage',
  '5cbf451f61ef9b0308be5e88' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-49/5cbf451f61ef9b0308be5e88/stage',
  '5cbf451f61ef9b0308be5e89' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-50/5cbf451f61ef9b0308be5e89/stage',
  '5cbf451f61ef9b0308be5e8a' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-51/5cbf451f61ef9b0308be5e8a/stage',
  '5cbf451f61ef9b0308be5e8b' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-52/5cbf451f61ef9b0308be5e8b/stage',
  '5cbf451f61ef9b0308be5e8c' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-53/5cbf451f61ef9b0308be5e8c/stage',
  '5cbf451f61ef9b0308be5e8d' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-54/5cbf451f61ef9b0308be5e8d/stage',
  '5cbf451f61ef9b0308be5e8e' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-55/5cbf451f61ef9b0308be5e8e/stage',
  '5cbf451f61ef9b0308be5e8f' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-56/5cbf451f61ef9b0308be5e8f/stage',
  '5cbf451f61ef9b0308be5e90' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-57/5cbf451f61ef9b0308be5e90/stage',
  '5cbf451f61ef9b0308be5e91' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-58/5cbf451f61ef9b0308be5e91/stage',
  '5cbf451f61ef9b0308be5e92' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-59/5cbf451f61ef9b0308be5e92/stage',
  '5cbf451f61ef9b0308be5e93' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-60/5cbf451f61ef9b0308be5e93/stage',
  '5cbf451f61ef9b0308be5e94' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-61/5cbf451f61ef9b0308be5e94/stage',
  '5cbf451f61ef9b0308be5e95' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-62/5cbf451f61ef9b0308be5e95/stage',
  '5cbf451f61ef9b0308be5e96' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-63/5cbf451f61ef9b0308be5e96/stage',
  '5cbf451f61ef9b0308be5e97' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-64/5cbf451f61ef9b0308be5e97/stage',
  '5cbf451f61ef9b0308be5e98' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-65/5cbf451f61ef9b0308be5e98/stage',
  '5cbf451f61ef9b0308be5e99' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-66/5cbf451f61ef9b0308be5e99/stage',
  '5cbf451f61ef9b0308be5e9a' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-67/5cbf451f61ef9b0308be5e9a/stage',
  '5cbf451f61ef9b0308be5e9b' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-68/5cbf451f61ef9b0308be5e9b/stage',
  '5cbf451f61ef9b0308be5e9c' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-69/5cbf451f61ef9b0308be5e9c/stage',
  '5cbf451f61ef9b0308be5e9d' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-70/5cbf451f61ef9b0308be5e9d/stage',
  '5cbf451f61ef9b0308be5e9e' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-71/5cbf451f61ef9b0308be5e9e/stage',
  '5cbf451f61ef9b0308be5e9f' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-72/5cbf451f61ef9b0308be5e9f/stage',
  '5cbf451f61ef9b0308be5ea0' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-73/5cbf451f61ef9b0308be5ea0/stage',
  '5cbf451f61ef9b0308be5ea1' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-74/5cbf451f61ef9b0308be5ea1/stage',
  '5cbf451f61ef9b0308be5ea2' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-75/5cbf451f61ef9b0308be5ea2/stage',
  '5cbf451f61ef9b0308be5ea3' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-76/5cbf451f61ef9b0308be5ea3/stage',
  '5cbf451f61ef9b0308be5ea4' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-77/5cbf451f61ef9b0308be5ea4/stage',
  '5cbf451f61ef9b0308be5ea5' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-78/5cbf451f61ef9b0308be5ea5/stage',
  '5cbf451f61ef9b0308be5ea6' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-79/5cbf451f61ef9b0308be5ea6/stage',
  '5cbf451f61ef9b0308be5ea7' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-80/5cbf451f61ef9b0308be5ea7/stage',
  '5cbf451f61ef9b0308be5ea8' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-81/5cbf451f61ef9b0308be5ea8/stage',
  '5cbf451f61ef9b0308be5ea9' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-82/5cbf451f61ef9b0308be5ea9/stage',
  '5cbf451f61ef9b0308be5eaa' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-83/5cbf451f61ef9b0308be5eaa/stage',
  '5cbf451f61ef9b0308be5eab' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-84/5cbf451f61ef9b0308be5eab/stage',
  '5cbf451f61ef9b0308be5eac' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-85/5cbf451f61ef9b0308be5eac/stage',
  '5cbf451f61ef9b0308be5ead' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-86/5cbf451f61ef9b0308be5ead/stage',
  '5cbf451f61ef9b0308be5eae' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-87/5cbf451f61ef9b0308be5eae/stage',
  '5cbf451f61ef9b0308be5eaf' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-88/5cbf451f61ef9b0308be5eaf/stage',
  '5cbf451f61ef9b0308be5eb0' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-89/5cbf451f61ef9b0308be5eb0/stage',
  '5cbf451f61ef9b0308be5eb1' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-90/5cbf451f61ef9b0308be5eb1/stage',
  '5cbf451f61ef9b0308be5eb2' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-91/5cbf451f61ef9b0308be5eb2/stage',
  '5cbf451f61ef9b0308be5eb3' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-92/5cbf451f61ef9b0308be5eb3/stage',
  '5cbf451f61ef9b0308be5eb4' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-93/5cbf451f61ef9b0308be5eb4/stage',
  '5cbf451f61ef9b0308be5eb5' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-94/5cbf451f61ef9b0308be5eb5/stage',
  '5cbf451f61ef9b0308be5eb6' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-95/5cbf451f61ef9b0308be5eb6/stage',
  '5cbf451f61ef9b0308be5eb7' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-96/5cbf451f61ef9b0308be5eb7/stage',
  '5cbf451f61ef9b0308be5eb8' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-97/5cbf451f61ef9b0308be5eb8/stage',
  '5cbf451f61ef9b0308be5eb9' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-98/5cbf451f61ef9b0308be5eb9/stage',
  '5cbf451f61ef9b0308be5eba' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-99/5cbf451f61ef9b0308be5eba/stage',
  '5cbf451f61ef9b0308be5ebb' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-100/5cbf451f61ef9b0308be5ebb/stage',
  '5cbf451f61ef9b0308be5ebc' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-101/5cbf451f61ef9b0308be5ebc/stage',
  '5cbf451f61ef9b0308be5ebd' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-102/5cbf451f61ef9b0308be5ebd/stage',
  '5cbf451f61ef9b0308be5ebe' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-103/5cbf451f61ef9b0308be5ebe/stage',
  '5cbf451f61ef9b0308be5ebf' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-104/5cbf451f61ef9b0308be5ebf/stage',
  '5cbf451f61ef9b0308be5ec0' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-105/5cbf451f61ef9b0308be5ec0/stage',
  '5cbf451f61ef9b0308be5ec1' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-106/5cbf451f61ef9b0308be5ec1/stage',
  '5cbf451f61ef9b0308be5ec2' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-107/5cbf451f61ef9b0308be5ec2/stage',
  '5cbf451f61ef9b0308be5ec3' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-108/5cbf451f61ef9b0308be5ec3/stage',
  '5cbf451f61ef9b0308be5ec4' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-109/5cbf451f61ef9b0308be5ec4/stage',
  '5cbf451f61ef9b0308be5ec5' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-110/5cbf451f61ef9b0308be5ec5/stage',
  '5cbf451f61ef9b0308be5ec6' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-111/5cbf451f61ef9b0308be5ec6/stage',
  '5cbf451f61ef9b0308be5ec7' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-112/5cbf451f61ef9b0308be5ec7/stage',
  '5cbf451f61ef9b0308be5ec8' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-113/5cbf451f61ef9b0308be5ec8/stage',
  '5cbf451f61ef9b0308be5ec9' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-114/5cbf451f61ef9b0308be5ec9/stage',
  '5cbf451f61ef9b0308be5eca' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-115/5cbf451f61ef9b0308be5eca/stage',
  '5cbf451f61ef9b0308be5ecb' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-116/5cbf451f61ef9b0308be5ecb/stage',
  '5cbf451f61ef9b0308be5ecc' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-117/5cbf451f61ef9b0308be5ecc/stage',
  '5cbf451f61ef9b0308be5ecd' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-118/5cbf451f61ef9b0308be5ecd/stage',
  '5cbf451f61ef9b0308be5ece' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-119/5cbf451f61ef9b0308be5ece/stage',
  '5cbf451f61ef9b0308be5ecf' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-120/5cbf451f61ef9b0308be5ecf/stage',
  '5cbf451f61ef9b0308be5ed0' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-121/5cbf451f61ef9b0308be5ed0/stage',
  '5cbf451f61ef9b0308be5ed1' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-122/5cbf451f61ef9b0308be5ed1/stage',
  '5cbf451f61ef9b0308be5ed2' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-123/5cbf451f61ef9b0308be5ed2/stage',
  '5cbf451f61ef9b0308be5ed3' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-124/5cbf451f61ef9b0308be5ed3/stage',
  '5cbf451f61ef9b0308be5ed4' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-125/5cbf451f61ef9b0308be5ed4/stage',
  '5cbf451f61ef9b0308be5ed5' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-126/5cbf451f61ef9b0308be5ed5/stage',
  '5cbf451f61ef9b0308be5ed6' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-127/5cbf451f61ef9b0308be5ed6/stage',
  '5cbf451f61ef9b0308be5ed7' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-128/5cbf451f61ef9b0308be5ed7/stage',
  '5cbf451f61ef9b0308be5ed8' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-129/5cbf451f61ef9b0308be5ed8/stage',
  '5cbf451f61ef9b0308be5ed9' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-130/5cbf451f61ef9b0308be5ed9/stage',
  '5cbf451f61ef9b0308be5eda' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-131/5cbf451f61ef9b0308be5eda/stage',
  '5cbf451f61ef9b0308be5edb' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-132/5cbf451f61ef9b0308be5edb/stage',
  '5cbf451f61ef9b0308be5edc' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-133/5cbf451f61ef9b0308be5edc/stage',
  '5cbf451f61ef9b0308be5edd' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-134/5cbf451f61ef9b0308be5edd/stage',
  '5cbf451f61ef9b0308be5ede' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-135/5cbf451f61ef9b0308be5ede/stage',
  '5cbf451f61ef9b0308be5edf' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-136/5cbf451f61ef9b0308be5edf/stage',
  '5cbf451f61ef9b0308be5ee0' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-137/5cbf451f61ef9b0308be5ee0/stage',
  '5cbf451f61ef9b0308be5ee1' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-138/5cbf451f61ef9b0308be5ee1/stage',
  '5cbf451f61ef9b0308be5ee2' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-139/5cbf451f61ef9b0308be5ee2/stage',
  '5cbf451f61ef9b0308be5ee3' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-140/5cbf451f61ef9b0308be5ee3/stage',
  '5cbf451f61ef9b0308be5ee4' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-141/5cbf451f61ef9b0308be5ee4/stage',
  '5cbf451f61ef9b0308be5ee5' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-142/5cbf451f61ef9b0308be5ee5/stage',
  '5cbf451f61ef9b0308be5ee6' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-143/5cbf451f61ef9b0308be5ee6/stage',
  '5cbf451f61ef9b0308be5ee7' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-144/5cbf451f61ef9b0308be5ee7/stage',
  '5ce440630f8f2f03431a7bfc' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-145/5ce440630f8f2f03431a7bfc/stage',
  '5cbf451f61ef9b0308be5ee8' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-146/5cbf451f61ef9b0308be5ee8/stage',
  '5ce44160fcff9f034566b246' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-147/5ce44160fcff9f034566b246/stage',
  '5cbf451f61ef9b0308be5ee9' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-148/5cbf451f61ef9b0308be5ee9/stage',
  '5ce4423f63f196036b77cc5e' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-149/5ce4423f63f196036b77cc5e/stage',
  '5cbf451f61ef9b0308be5eea' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-150/5cbf451f61ef9b0308be5eea/stage',
  '5cbf451f61ef9b0308be5eeb' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-151/5cbf451f61ef9b0308be5eeb/stage',
  '5cbf451f61ef9b0308be5eec' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-152/5cbf451f61ef9b0308be5eec/stage',
  '5cbf451f61ef9b0308be5eed' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-153/5cbf451f61ef9b0308be5eed/stage',
  '5cbf451f61ef9b0308be5eee' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-154/5cbf451f61ef9b0308be5eee/stage',
  '5cbf451f61ef9b0308be5eef' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-155/5cbf451f61ef9b0308be5eef/stage',
  '5cbf451f61ef9b0308be5ef0' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-156/5cbf451f61ef9b0308be5ef0/stage',
  '5cbf451f61ef9b0308be5ef1' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-157/5cbf451f61ef9b0308be5ef1/stage',
  '5cbf451f61ef9b0308be5ef2' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-158/5cbf451f61ef9b0308be5ef2/stage',
  '5cbf451f61ef9b0308be5ef3' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-159/5cbf451f61ef9b0308be5ef3/stage',
  '5cbf451f61ef9b0308be5ef4' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-160/5cbf451f61ef9b0308be5ef4/stage',
  '5cbf451f61ef9b0308be5ef5' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-161/5cbf451f61ef9b0308be5ef5/stage',
  '5cbf451f61ef9b0308be5ef6' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-162/5cbf451f61ef9b0308be5ef6/stage',
  '5cbf451f61ef9b0308be5ef7' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-163/5cbf451f61ef9b0308be5ef7/stage',
  '5cbf451f61ef9b0308be5ef8' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-164/5cbf451f61ef9b0308be5ef8/stage',
  '5cbf451f61ef9b0308be5ef9' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-165/5cbf451f61ef9b0308be5ef9/stage',
  '5cbf451f61ef9b0308be5efa' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-166/5cbf451f61ef9b0308be5efa/stage',
  '5cbf451f61ef9b0308be5efb' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-167/5cbf451f61ef9b0308be5efb/stage',
  '5cbf451f61ef9b0308be5efc' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-168/5cbf451f61ef9b0308be5efc/stage',
  '5cbf451f61ef9b0308be5efd' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-169/5cbf451f61ef9b0308be5efd/stage',
  '5cbf451f61ef9b0308be5efe' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-170/5cbf451f61ef9b0308be5efe/stage',
  '5cbf451f61ef9b0308be5eff' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-171/5cbf451f61ef9b0308be5eff/stage',
  '5cbf451f61ef9b0308be5f00' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-172/5cbf451f61ef9b0308be5f00/stage',
  '5cbf451f61ef9b0308be5f01' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-173/5cbf451f61ef9b0308be5f01/stage',
  '5cbf451f61ef9b0308be5f02' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-174/5cbf451f61ef9b0308be5f02/stage',
  '5ce445180ed74003314fd866' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-175/5ce445180ed74003314fd866/stage',
  '5cbf451f61ef9b0308be5f03' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-176/5cbf451f61ef9b0308be5f03/stage',
  '5ce4456c5d90b203486a8c78' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-177/5ce4456c5d90b203486a8c78/stage',
  '5cbf451f61ef9b0308be5f04' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-178/5cbf451f61ef9b0308be5f04/stage',
  '5ce445b790d9fc0325b5377c' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-179/5ce445b790d9fc0325b5377c/stage',
  '5cbf451f61ef9b0308be5f05' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-180/5cbf451f61ef9b0308be5f05/stage',
  '5cbf451f61ef9b0308be5f06' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-181/5cbf451f61ef9b0308be5f06/stage',
  '5cbf451f61ef9b0308be5f07' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-182/5cbf451f61ef9b0308be5f07/stage',
  '5cbf451f61ef9b0308be5f08' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-183/5cbf451f61ef9b0308be5f08/stage',
  '5cbf451f61ef9b0308be5f09' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-184/5cbf451f61ef9b0308be5f09/stage',
  '5cbf451f61ef9b0308be5f0a' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-185/5cbf451f61ef9b0308be5f0a/stage',
  '5cbf451f61ef9b0308be5f0b' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-186/5cbf451f61ef9b0308be5f0b/stage',
  '5cbf451f61ef9b0308be5f0c' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-187/5cbf451f61ef9b0308be5f0c/stage',
  '5cbf451f61ef9b0308be5f0d' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-188/5cbf451f61ef9b0308be5f0d/stage',
  '5cbf451f61ef9b0308be5f0e' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-189/5cbf451f61ef9b0308be5f0e/stage',
  '5cbf451f61ef9b0308be5f0f' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-190/5cbf451f61ef9b0308be5f0f/stage',
  '5cbf451f61ef9b0308be5f10' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-191/5cbf451f61ef9b0308be5f10/stage',
  '5cbf451f61ef9b0308be5f11' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-192/5cbf451f61ef9b0308be5f11/stage',
  '5cbf451f61ef9b0308be5f12' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-193/5cbf451f61ef9b0308be5f12/stage',
  '5cbf451f61ef9b0308be5f13' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-194/5cbf451f61ef9b0308be5f13/stage',
  '5cbf451f61ef9b0308be5f14' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-195/5cbf451f61ef9b0308be5f14/stage',
  '5cbf451f61ef9b0308be5f15' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-196/5cbf451f61ef9b0308be5f15/stage',
  '5cbf451f61ef9b0308be5f16' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-197/5cbf451f61ef9b0308be5f16/stage',
  '5cbf451f61ef9b0308be5f17' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-198/5cbf451f61ef9b0308be5f17/stage',
  '5cbf451f61ef9b0308be5f18' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-200/5cbf451f61ef9b0308be5f18/stage',
  '5cbf451f61ef9b0308be5f19' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-202/5cbf451f61ef9b0308be5f19/stage',
  '5cbf451f61ef9b0308be5f1a' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-204/5cbf451f61ef9b0308be5f1a/stage',
  '5ce4463c972ffa032d91bd97' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-205/5ce4463c972ffa032d91bd97/stage',
  '5cbf451f61ef9b0308be5f1b' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-206/5cbf451f61ef9b0308be5f1b/stage',
  '5ce4480c9a16010348640f44' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-207/5ce4480c9a16010348640f44/stage',
  '5cbf451f61ef9b0308be5f1c' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-208/5cbf451f61ef9b0308be5f1c/stage',
  '5ce4486de3b73f051f9e8725' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-209/5ce4486de3b73f051f9e8725/stage',
  '5cbf451f61ef9b0308be5f1d' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-210/5cbf451f61ef9b0308be5f1d/stage',
  '5cbf451f61ef9b0308be5f1e' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-211/5cbf451f61ef9b0308be5f1e/stage',
  '5cbf451f61ef9b0308be5f1f' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-212/5cbf451f61ef9b0308be5f1f/stage',
  '5cbf451f61ef9b0308be5f20' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-213/5cbf451f61ef9b0308be5f20/stage',
  '5cbf451f61ef9b0308be5f21' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-214/5cbf451f61ef9b0308be5f21/stage',
  '5cbf451f61ef9b0308be5f22' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-215/5cbf451f61ef9b0308be5f22/stage',
  '5cbf451f61ef9b0308be5f23' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-216/5cbf451f61ef9b0308be5f23/stage',
  '5cbf451f61ef9b0308be5f24' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-217/5cbf451f61ef9b0308be5f24/stage',
  '5cbf451f61ef9b0308be5f25' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-218/5cbf451f61ef9b0308be5f25/stage',
  '5cbf451f61ef9b0308be5f26' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-219/5cbf451f61ef9b0308be5f26/stage',
  '5cbf451f61ef9b0308be5f27' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-220/5cbf451f61ef9b0308be5f27/stage',
  '5cbf451f61ef9b0308be5f28' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-221/5cbf451f61ef9b0308be5f28/stage',
  '5cbf451f61ef9b0308be5f29' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-222/5cbf451f61ef9b0308be5f29/stage',
  '5cbf451f61ef9b0308be5f2a' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-223/5cbf451f61ef9b0308be5f2a/stage',
  '5cbf451f61ef9b0308be5f2b' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-224/5cbf451f61ef9b0308be5f2b/stage',
  '5cbf451f61ef9b0308be5f2c' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-225/5cbf451f61ef9b0308be5f2c/stage',
  '5cbf451f61ef9b0308be5f2d' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-226/5cbf451f61ef9b0308be5f2d/stage',
  '5cbf451f61ef9b0308be5f2e' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-227/5cbf451f61ef9b0308be5f2e/stage',
  '5cbf451f61ef9b0308be5f2f' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-228/5cbf451f61ef9b0308be5f2f/stage',
  '5cbf451f61ef9b0308be5f30' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-229/5cbf451f61ef9b0308be5f30/stage',
  '5cbf451f61ef9b0308be5f31' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-230/5cbf451f61ef9b0308be5f31/stage',
  '5cbf451f61ef9b0308be5f32' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-231/5cbf451f61ef9b0308be5f32/stage',
  '5cbf451f61ef9b0308be5f33' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-232/5cbf451f61ef9b0308be5f33/stage',
  '5cbf451f61ef9b0308be5f34' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-233/5cbf451f61ef9b0308be5f34/stage',
  '5cbf451f61ef9b0308be5f35' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-234/5cbf451f61ef9b0308be5f35/stage',
  '5ce44b619a16010348640f45' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-235/5ce44b619a16010348640f45/stage',
  '5cbf451f61ef9b0308be5f36' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-236/5cbf451f61ef9b0308be5f36/stage',
  '5ce44bc76577fc032b9a7fc4' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-237/5ce44bc76577fc032b9a7fc4/stage',
  '5cbf451f61ef9b0308be5f37' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-238/5cbf451f61ef9b0308be5f37/stage',
  '5ce44c194854c103285a1e68' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-239/5ce44c194854c103285a1e68/stage',
  '5cbf451f61ef9b0308be5f38' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-240/5cbf451f61ef9b0308be5f38/stage',
  '5cfee625e5eb1f1142300c33' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-81m/5cfee625e5eb1f1142300c33/stage',
  '5cfee6d0338cff1167b1e290' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-82m/5cfee6d0338cff1167b1e290/stage',
  '5cfee41791abb011523e3876' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-81m/5cfee41791abb011523e3876/stage',
  '5cd0d56a8b8d66030a9e5179' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-asia-ladder-qualifier/5cd0d56a8b8d66030a9e5179/stage',
  '5cd0d615b90e24030f21c583' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-europe-ladder-qualifier/5cd0d615b90e24030f21c583/stage',
  '5cd0d3288b8d66030a9e5165' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-americas-ladder-qualifier/5cd0d3288b8d66030a9e5165/stage',
  '5cfeea27e78f8a1178cc6cf0' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-asia-ladder-qualifier-may/5cfeea27e78f8a1178cc6cf0/stage',
  '5cfeec582761671197785086' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-eiurope-ladder-qualifier-may/5cfeec582761671197785086/stage',
  '5cfeecf72e924f116ce63af2' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-americas-ladder-qualifier-may/5cfeecf72e924f116ce63af2/stage',
}

def pdebug(msg="")
  return unless @DEBUG
  @output.concat("DEBUG: #{msg}<br>\n")
end

def bail_and_redirect()
  target_url = 'http://doc-x.net/hs/match_status.html'
  @cgi.out( "status" => "REDIRECT", "Location" => target_url, "type" => "text/html") {
    "Redirecting to data input page: #{target_url}\n"
  }
  exit
end

def bogus_match_data(bid=nil?)
  return true if bid.nil?
  return false if bid.match(/^[a-f0-9]{24}$/)
  return true
end

def tell_em_dano(bid=nil)
  @output.concat("<pre>\n")
  @output.concat("Provided bracket ID (#{bid}) did not match pattern. Hit the back button and try again.\n")
  @output.concat("</pre>\n")
#  exit
end

if params.empty? then
  bail_and_redirect
end
if params['bracket_id'].nil?
  bail_and_redirect
end

@DEBUG = false
@DEBUG = true if $0.match(/ms.rb$/)

@refresh = true
unless params['refresh'][0].nil? then
  if params['refresh'][0] == "false" then
    @refresh = false
  end
end

@snapshot = false
unless params['snapshot'][0].nil? then
  if params['snapshot'][0] == "true" then
    @snapshot = true
  end
end

@active_round = 0
@output = ""

unless @snapshot then
  @output.concat("Content-type: text/html; charset=UTF-8\n")
  @output.concat("\n")
end
@output.concat("<html>\n")
@output.concat("<head>\n")
if @refresh then
  @output.concat("<meta http-equiv='refresh' content='60'>\n")
end
if @snapshot then
  @output.concat("<meta charset=UTF-8 />\n")
end
@output.concat("<title>Match status</title>\n")
@output.concat("</head>\n")
@output.concat("<body>\n")

@bracket_id = params['bracket_id'][0]

if @bracket_id.nil? then
  @output.concat("<pre>\n")
  @output.concat("Something weird happened. Try manually refreshing your browser. Or yell at Dylan\n")
  @output.concat("DEBUG: '#{@bracket_id}'\n")
  @output.concat("</pre>\n")
end

if bogus_match_data(@bracket_id) then
  tell_em_dano(@bracket_id)
  exit
end

@base_cf_url = 'https://dtmwra1jsgyb0.cloudfront.net/stages'
# 24 hex characters
@tourney_hash = @bracket_id

# Give a round number and get the results from that round
def get_round(round=nil, tourney_url=nil)
  return if round.nil?
  return if tourney_url.nil?
  full_url = "#{tourney_url}/#{round}/matches"
  pdebug("Full URL for this round's JSON: #{full_url}<br>\n") 
  raw_json = open(full_url, {ssl_verify_mode: 0}).read

  begin
    j_data = JSON.parse(raw_json)
  rescue JSON::ParserError, Encoding::InvalidByteSequenceError => e
    @output.concat("Had problem parsing #{path}: #{e}\n")
    return Hash.new
  end
  return j_data
end

def get_match_name(hash=nil, t_id=nil)
#  @output.concat("In get_match_name with t_id '#{t_id}'\n")
  return if hash.nil?
  return if t_id.nil?
  if @tournament_hash[t_id].nil? then
    return "No name for hash #{t_id}"
  end
  name = @tournament_hash[t_id].clone
  name.gsub!('https://battlefy.com/hsesports/', '')
  name.gsub!(/\/.*/, '')
#  @output.concat("get_match_name found name of #{name} for #{t_id}</pre>\n")
  return name
end

def extract_json_data(data_json=nil, current_round=nil)
  return if data_json.nil?
  return if current_round.nil?
  @active_round = current_round
  tournament_id = data_json[0]['top']['team']['tournamentID']
  creation_time = data_json[0]['createdAt']
  creation_time.gsub!(/\.\d\d\dZ$/, ' UTC')
  creation_time.gsub!(/-(\d\d)T(\d\d):/, '-\1 \2:')
  name = get_match_name(@tournament_hash, tournament_id)
  #      @output.concat("Name is #{name}\n")
  if @tournament_type == "swiss" then
    @output.concat("<h1> Ongoing Round #{current_round} Matches (#{name})</h1>\n")
  else
    @output.concat("<h1> Match data for Single Elimination Tournament '#{name}'</h1>\n")
    @output.concat("<b>List of matches that have been going for more than 10 minutes</b><p>\n")
  end
  @output.concat("Data last refreshed at <tt>#{Time.now.utc.to_s}</tt><br>\n")
  @output.concat("The round began at <tt>#{creation_time}</tt>\n")
  @output.concat("<p>\n")
  if @snapshot then
    @output.concat("")
  elsif @refresh then
    @output.concat("<a href='http://doc-x.net/hs#{@cgi.path_info}?bracket_id=#{@bracket_id}&refresh=false'>Update and <b>stop</b> refreshing every 60 seconds.</a><br>\n")
    @output.concat("<a href='http://doc-x.net/hs#{@cgi.path_info}?bracket_id=#{@bracket_id}&snapshot=true' target='_blank'>Take Tournament Snapshot.</a>\n")
  else
    @output.concat("<a href='http://doc-x.net/hs#{@cgi.path_info}?bracket_id=#{@bracket_id}&refresh=true'>Update and <b>begin</b> refreshing every 60 seconds.</a><br>\n")
    @output.concat("<a href='http://doc-x.net/hs#{@cgi.path_info}?bracket_id=#{@bracket_id}&snapshot=true'>Take Tournament Snapshot.</a> <b>Be Aware: Snapshots are always of the tournament state when you click, not whatever you see on this page.</b>\n")
  end
  @output.concat("\n")
  @output.concat("<ul>\n")
  return data_json
end

def get_single_elim_data(tourney_url)
  return if tourney_url.nil?
  @tournament_type = 'single_elim'
  data_json = Array.new
  1.upto(8) do |round|
    pdebug("Getting single_elim round data for #{round}")
    new_data = get_round(round, tourney_url)
    data_json.concat(new_data) unless new_data.nil? 
  end
  return data_json
end

# Iterate through the rounds from top down until you find a round that has matches
def find_active_round(t_url=nil)
  8.downto(1) do |current_round|
    data_json = get_round(current_round, t_url)
    if data_json.length() > 0 then
      # Check to see if we're in a swiss or single-elim match
      pdebug("JSON has #{data_json.length()} elements")
      if data_json.length() == 1 then
        pdebug("We only have 1 event which seems suspicious. Going to assume this is Single Elim")
        #data_json = get_round(round=1, tourney_url=t_url)
        data_json = get_single_elim_data(t_url)
        return extract_json_data(data_json, 1)
      else
        return extract_json_data(data_json, current_round)
      end
    end
  end
  @output.concat("Went through all rounds and did not find matches. Seems bad, dawg.\n")
  exit
end

# Print user name (and ready status if they aren't ready)
def print_user(user=nil)
  return if user.nil?
  if @tournament_type == 'swiss' then
    name = user['name']
  else
    if user['team'].nil?
      name = 'team_not_defined'
    else
      name = user['team']['name']
    end
  end
  return if name.nil?
  if user['readyAt'].nil?
    name += " <font color='red'>(NOT-READY)</font>"
  end
  return name
end

def get_json_data(hash=nil?)
  return if hash.nil?
  url = "#{@base_cf_url}/#{hash}/rounds"
  data_json = find_active_round(url)
  return data_json
end

def get_match_url(hash=nil, t_id=nil, m_id=nil)
  return if hash.nil?
  return if t_id.nil?
  return if m_id.nil?
  if @tournament_hash[t_id].nil? then
    return "/hs/missing_tournament_urls.html"
  end
  return "#{@tournament_hash[t_id]}/#{hash}/match/#{m_id}"
end

def get_db_con
  pw = File.open("/home/docxstudios/hs_tournaments.pw").read.chomp
  con = Mysql.new 'mysql.doc-x.net', 'hs_tournaments', pw, 'hs_tournaments'
  return con
end

def update_bracket_tracker(b_id=nil, t_id=nil)
  return if b_id.nil?
  return if t_id.nil?
  #@output.concat("<ul>\n")
  #@output.concat("<li> Getting DB Con\n")
  con = get_db_con
  #@output.concat("<li> Generating query\n")
  query = "REPLACE INTO bracket_tracker (bracket_id, tournament_id) VALUES('#{b_id}', '#{t_id}')"
  #@output.concat("<li> Running query #{query}\n")
  con.query(query)
  #@output.concat("<li> Done\n")
  #@output.concat("</ul><p>\n")
end

data_json = get_json_data(@tourney_hash)

tourney_id = ''
begin
  tourney_id = data_json[0]['top']['team']['tournamentID']
rescue
  @output.concat("Ran into issue with tourney_id\n")
end
begin
  pdebug("Updating Bracket Tracker")
  update_bracket_tracker(b_id=@bracket_id, t_id=tourney_id)
rescue
  @output.concat("Ran into issue with updating bracket_tracker(#{@bracket_id}, #{tourney_id})\n")
end

def print_swiss_match(f=nil)
  # If the match is not complete, print that out
  if not f['isComplete'] then
    tourney_id = f['top']['team']['tournamentID']
    match_url = get_match_url(hash=@tourney_hash, t_id=tourney_id, m_id=f['_id'])
    @output.concat("<li> <a href='#{match_url}' target='_blank'>Ongoing Match: #{f['matchNumber']} - #{print_user(f['top'])} vs #{print_user(f['bottom'])}</a>\n")
  else
    # Byes only have one user and are complete, so skip them
    return if f['isBye']
    # If the match is complete but one of the users is not ready, note that.
    if f['bottom']['readyAt'].nil? or f['top']['readyAt'].nil? then
      if f['bottom']['disqualified'] != true and f['top']['disqualified'] != true then
        tourney_id = f['top']['team']['tournamentID']
        match_url = get_match_url(hash=@tourney_hash, t_id=tourney_id, m_id=f['_id'])
        @output.concat("<li> <a href='#{match_url}' target='_blank'>Completd Match-User Not Ready: #{f['matchNumber']}  - #{print_user(f['top'])} vs #{print_user(f['bottom'])}</a>\n")
      end
    end
  end
end

def print_single_elim_match(f=nil)
  if not f['isComplete'] then
    pdebug("<pre>===\n#{f}</pre>")
    if not f['top'].nil? and not f['top']['team'].nil? and not f['top']['team']['tournamentID'].nil?
      now = Time.now
      updatedAt = DateTime.parse(f['updatedAt']).to_time.to_i
      diff = now - updatedAt
      # For these matches, we only *really* care about matches that are more than 10 minutes old
      return unless diff.to_i >= 600 
      # Also, we only print out matches if the players have not readied up
      return if f['top'].nil?
      return if f['top']['team'].nil?
      return unless f['top']['team']['readyAt'].nil?
      return if f['bottom'].nil?
      return if f['bottom']['team'].nil?
      return unless f['bottom']['team']['readyAt'].nil?
      tourney_id = f['top']['team']['tournamentID']
      match_url = get_match_url(@tourney_hash, tourney_id, f['_id'])
      @output.concat("<li> <a href='#{match_url}' target='_blank'>Ongoing Match: #{f['matchNumber']} - #{print_user(f['top'])} vs #{print_user(f['bottom'])}</a> [match duration #{Time.at(diff).utc.strftime('%H:%M:%S')}]\n")
    end
  else
    # Byes only have one user and are complete, so skip them
    return if f['isBye']
  end
  return "Unprocessed"
end

data_json.each do |f|
  if @tournament_type == 'swiss'
    print_swiss_match(f)
  else
    print_single_elim_match(f)
  end
end

@output.concat("</ul>\n")
@output.concat("</body>\n")
@output.concat("</html>\n")

if @snapshot then
  now = Time.now.utc.to_s
  now.gsub!(/ UTC$/, '')
  now.gsub!(/^.* /, '')
  now.gsub!(/:/, '')
  fname = "#{@bracket_id}-round#{@active_round}-#{now}.html"
  fqfn = "#{@out_dir}/#{fname}"
  url = "/hs/snapshots/#{fname}"
  fout = File.write(fqfn, @output)
  puts "Content-type: text/html; charset=UTF-8"
  puts ""
  puts "<html>"
  puts "<head>"
  puts "<title>Match status Snapshot Taken</title>"
  puts "</head>"
  puts "<body>"
  puts "<h1>Match status Snapshot Taken</h1>"
  puts "You can access it <a href='#{url}'>http://doc-x.net#{url}</a>"
  puts "</body>"
  puts "</html>"
else
  puts @output
end
