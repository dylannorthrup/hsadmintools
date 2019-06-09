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
  '5cbf451f61ef9b0308be5e92' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-59/5cbf451f61ef9b0308be5e92/info?infoTab=details',
  '5cbf451f61ef9b0308be5e93' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-60/5cbf451f61ef9b0308be5e93/info?infoTab=details',
  '5cbf451f61ef9b0308be5e94' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-61/5cbf451f61ef9b0308be5e94/info?infoTab=details',
  '5cbf451f61ef9b0308be5e95' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-62/5cbf451f61ef9b0308be5e95/info?infoTab=details',
  '5cbf451f61ef9b0308be5e96' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-63/5cbf451f61ef9b0308be5e96/info?infoTab=details',
  '5cbf451f61ef9b0308be5e97' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-64/5cbf451f61ef9b0308be5e97/info?infoTab=details',
  '5cbf451f61ef9b0308be5e98' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-65/5cbf451f61ef9b0308be5e98/info?infoTab=details',
  '5cbf451f61ef9b0308be5e99' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-66/5cbf451f61ef9b0308be5e99/info?infoTab=details',
  '5cbf451f61ef9b0308be5e9a' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-67/5cbf451f61ef9b0308be5e9a/info?infoTab=details',
  '5cbf451f61ef9b0308be5e9b' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-68/5cbf451f61ef9b0308be5e9b/info?infoTab=details',
  '5cbf451f61ef9b0308be5e9c' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-69/5cbf451f61ef9b0308be5e9c/info?infoTab=details',
  '5cbf451f61ef9b0308be5e9d' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-70/5cbf451f61ef9b0308be5e9d/info?infoTab=details',
  '5cbf451f61ef9b0308be5e9e' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-71/5cbf451f61ef9b0308be5e9e/info?infoTab=details',
  '5cbf451f61ef9b0308be5e9f' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-72/5cbf451f61ef9b0308be5e9f/info?infoTab=details',
  '5cbf451f61ef9b0308be5ea0' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-73/5cbf451f61ef9b0308be5ea0/info?infoTab=details',
  '5cbf451f61ef9b0308be5ea1' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-74/5cbf451f61ef9b0308be5ea1/info?infoTab=details',
  '5cbf451f61ef9b0308be5ea2' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-75/5cbf451f61ef9b0308be5ea2/info?infoTab=details',
  '5cbf451f61ef9b0308be5ea3' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-76/5cbf451f61ef9b0308be5ea3/info?infoTab=details',
  '5cbf451f61ef9b0308be5ea4' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-77/5cbf451f61ef9b0308be5ea4/info?infoTab=details',
  '5cbf451f61ef9b0308be5ea5' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-78/5cbf451f61ef9b0308be5ea5/info?infoTab=details',
  '5cbf451f61ef9b0308be5ea6' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-79/5cbf451f61ef9b0308be5ea6/info?infoTab=details',
  '5cbf451f61ef9b0308be5ea7' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-80/5cbf451f61ef9b0308be5ea7/info?infoTab=details',
  '5cbf451f61ef9b0308be5ea8' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-81/5cbf451f61ef9b0308be5ea8/info?infoTab=details',
  '5cbf451f61ef9b0308be5ea9' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-82/5cbf451f61ef9b0308be5ea9/info?infoTab=details',
  '5cbf451f61ef9b0308be5eaa' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-83/5cbf451f61ef9b0308be5eaa/info?infoTab=details',
  '5cbf451f61ef9b0308be5eab' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-84/5cbf451f61ef9b0308be5eab/info?infoTab=details',
  '5cbf451f61ef9b0308be5eac' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-85/5cbf451f61ef9b0308be5eac/info?infoTab=details',
  '5cbf451f61ef9b0308be5ead' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-86/5cbf451f61ef9b0308be5ead/info?infoTab=details',
  '5cbf451f61ef9b0308be5eae' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-87/5cbf451f61ef9b0308be5eae/info?infoTab=details',
  '5cbf451f61ef9b0308be5eaf' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-88/5cbf451f61ef9b0308be5eaf/info?infoTab=details',
  '5cbf451f61ef9b0308be5eb0' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-89/5cbf451f61ef9b0308be5eb0/info?infoTab=details',
  '5cbf451f61ef9b0308be5eb1' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-90/5cbf451f61ef9b0308be5eb1/info?infoTab=details',
  '5cbf451f61ef9b0308be5eb2' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-91/5cbf451f61ef9b0308be5eb2/info?infoTab=details',
  '5cbf451f61ef9b0308be5eb3' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-92/5cbf451f61ef9b0308be5eb3/info?infoTab=details',
  '5cbf451f61ef9b0308be5eb4' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-93/5cbf451f61ef9b0308be5eb4/info?infoTab=details',
  '5cbf451f61ef9b0308be5eb5' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-94/5cbf451f61ef9b0308be5eb5/info?infoTab=details',
  '5cbf451f61ef9b0308be5eb6' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-95/5cbf451f61ef9b0308be5eb6/info?infoTab=details',
  '5cbf451f61ef9b0308be5eb7' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-96/5cbf451f61ef9b0308be5eb7/info?infoTab=details',
  '5cbf451f61ef9b0308be5eb8' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-97/5cbf451f61ef9b0308be5eb8/info?infoTab=details',
  '5cbf451f61ef9b0308be5eb9' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-98/5cbf451f61ef9b0308be5eb9/info?infoTab=details',
  '5cbf451f61ef9b0308be5eba' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-99/5cbf451f61ef9b0308be5eba/info?infoTab=details',
  '5cbf451f61ef9b0308be5ebb' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-100/5cbf451f61ef9b0308be5ebb/info?infoTab=details',
  '5cbf451f61ef9b0308be5ebc' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-101/5cbf451f61ef9b0308be5ebc/info?infoTab=details',
  '5cbf451f61ef9b0308be5ebd' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-102/5cbf451f61ef9b0308be5ebd/info?infoTab=details',
  '5cbf451f61ef9b0308be5ebe' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-103/5cbf451f61ef9b0308be5ebe/info?infoTab=details',
  '5cbf451f61ef9b0308be5ebf' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-104/5cbf451f61ef9b0308be5ebf/info?infoTab=details',
  '5cbf451f61ef9b0308be5ec0' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-105/5cbf451f61ef9b0308be5ec0/info?infoTab=details',
  '5cbf451f61ef9b0308be5ec1' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-106/5cbf451f61ef9b0308be5ec1/info?infoTab=details',
  '5cbf451f61ef9b0308be5ec2' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-107/5cbf451f61ef9b0308be5ec2/info?infoTab=details',
  '5cbf451f61ef9b0308be5ec3' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-108/5cbf451f61ef9b0308be5ec3/info?infoTab=details',
  '5cbf451f61ef9b0308be5ec4' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-109/5cbf451f61ef9b0308be5ec4/info?infoTab=details',
  '5cbf451f61ef9b0308be5ec5' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-110/5cbf451f61ef9b0308be5ec5/info?infoTab=details',
  '5cbf451f61ef9b0308be5ec6' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-111/5cbf451f61ef9b0308be5ec6/info?infoTab=details',
  '5cbf451f61ef9b0308be5ec7' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-112/5cbf451f61ef9b0308be5ec7/info?infoTab=details',
  '5cbf451f61ef9b0308be5ec8' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-113/5cbf451f61ef9b0308be5ec8/info?infoTab=details',
  '5cbf451f61ef9b0308be5ec9' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-114/5cbf451f61ef9b0308be5ec9/info?infoTab=details',
  '5cbf451f61ef9b0308be5eca' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-115/5cbf451f61ef9b0308be5eca/info?infoTab=details',
  '5cbf451f61ef9b0308be5ecb' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-116/5cbf451f61ef9b0308be5ecb/info?infoTab=details',
  '5cbf451f61ef9b0308be5ecc' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-117/5cbf451f61ef9b0308be5ecc/info?infoTab=details',
  '5cbf451f61ef9b0308be5ecd' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-118/5cbf451f61ef9b0308be5ecd/info?infoTab=details',
  '5cbf451f61ef9b0308be5ece' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-119/5cbf451f61ef9b0308be5ece/info?infoTab=details',
  '5cbf451f61ef9b0308be5ecf' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-120/5cbf451f61ef9b0308be5ecf/info?infoTab=details',
  '5cbf451f61ef9b0308be5ed0' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-121/5cbf451f61ef9b0308be5ed0/info?infoTab=details',
  '5cbf451f61ef9b0308be5ed1' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-122/5cbf451f61ef9b0308be5ed1/info?infoTab=details',
  '5cbf451f61ef9b0308be5ed2' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-123/5cbf451f61ef9b0308be5ed2/info?infoTab=details',
  '5cbf451f61ef9b0308be5ed3' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-124/5cbf451f61ef9b0308be5ed3/info?infoTab=details',
  '5cbf451f61ef9b0308be5ed4' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-125/5cbf451f61ef9b0308be5ed4/info?infoTab=details',
  '5cbf451f61ef9b0308be5ed5' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-126/5cbf451f61ef9b0308be5ed5/info?infoTab=details',
  '5cbf451f61ef9b0308be5ed6' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-127/5cbf451f61ef9b0308be5ed6/info?infoTab=details',
  '5cbf451f61ef9b0308be5ed7' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-128/5cbf451f61ef9b0308be5ed7/info?infoTab=details',
  '5cbf451f61ef9b0308be5ed8' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-129/5cbf451f61ef9b0308be5ed8/info?infoTab=details',
  '5cbf451f61ef9b0308be5ed9' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-130/5cbf451f61ef9b0308be5ed9/info?infoTab=details',
  '5cbf451f61ef9b0308be5eda' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-131/5cbf451f61ef9b0308be5eda/info?infoTab=details',
  '5cbf451f61ef9b0308be5edb' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-132/5cbf451f61ef9b0308be5edb/info?infoTab=details',
  '5cbf451f61ef9b0308be5edc' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-133/5cbf451f61ef9b0308be5edc/info?infoTab=details',
  '5cbf451f61ef9b0308be5edd' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-134/5cbf451f61ef9b0308be5edd/info?infoTab=details',
  '5cbf451f61ef9b0308be5ede' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-135/5cbf451f61ef9b0308be5ede/info?infoTab=details',
  '5cbf451f61ef9b0308be5edf' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-136/5cbf451f61ef9b0308be5edf/info?infoTab=details',
  '5cbf451f61ef9b0308be5ee0' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-137/5cbf451f61ef9b0308be5ee0/info?infoTab=details',
  '5cbf451f61ef9b0308be5ee1' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-138/5cbf451f61ef9b0308be5ee1/info?infoTab=details',
  '5cbf451f61ef9b0308be5ee2' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-139/5cbf451f61ef9b0308be5ee2/info?infoTab=details',
  '5cbf451f61ef9b0308be5ee3' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-140/5cbf451f61ef9b0308be5ee3/info?infoTab=details',
  '5cbf451f61ef9b0308be5ee4' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-141/5cbf451f61ef9b0308be5ee4/info?infoTab=details',
  '5cbf451f61ef9b0308be5ee5' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-142/5cbf451f61ef9b0308be5ee5/info?infoTab=details',
  '5cbf451f61ef9b0308be5ee6' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-143/5cbf451f61ef9b0308be5ee6/info?infoTab=details',
  '5cbf451f61ef9b0308be5ee7' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-144/5cbf451f61ef9b0308be5ee7/info?infoTab=details',
  '5ce440630f8f2f03431a7bfc' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-145/5ce440630f8f2f03431a7bfc/info?infoTab=details',
  '5cbf451f61ef9b0308be5ee8' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-146/5cbf451f61ef9b0308be5ee8/info?infoTab=details',
  '5ce44160fcff9f034566b246' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-147/5ce44160fcff9f034566b246/info?infoTab=details',
  '5cbf451f61ef9b0308be5ee9' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-148/5cbf451f61ef9b0308be5ee9/info?infoTab=details',
  '5ce4423f63f196036b77cc5e' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-149/5ce4423f63f196036b77cc5e/info?infoTab=details',
  '5cbf451f61ef9b0308be5eea' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-150/5cbf451f61ef9b0308be5eea/info?infoTab=details',
  '5cbf451f61ef9b0308be5eeb' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-151/5cbf451f61ef9b0308be5eeb/info?infoTab=details',
  '5cbf451f61ef9b0308be5eec' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-152/5cbf451f61ef9b0308be5eec/info?infoTab=details',
  '5cbf451f61ef9b0308be5eed' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-153/5cbf451f61ef9b0308be5eed/info?infoTab=details',
  '5cbf451f61ef9b0308be5eee' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-154/5cbf451f61ef9b0308be5eee/info?infoTab=details',
  '5cbf451f61ef9b0308be5eef' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-155/5cbf451f61ef9b0308be5eef/info?infoTab=details',
  '5cbf451f61ef9b0308be5ef0' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-156/5cbf451f61ef9b0308be5ef0/info?infoTab=details',
  '5cbf451f61ef9b0308be5ef1' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-157/5cbf451f61ef9b0308be5ef1/info?infoTab=details',
  '5cbf451f61ef9b0308be5ef2' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-158/5cbf451f61ef9b0308be5ef2/info?infoTab=details',
  '5cbf451f61ef9b0308be5ef3' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-159/5cbf451f61ef9b0308be5ef3/info?infoTab=details',
  '5cbf451f61ef9b0308be5ef4' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-160/5cbf451f61ef9b0308be5ef4/info?infoTab=details',
  '5cbf451f61ef9b0308be5ef5' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-161/5cbf451f61ef9b0308be5ef5/info?infoTab=details',
  '5cbf451f61ef9b0308be5ef6' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-162/5cbf451f61ef9b0308be5ef6/info?infoTab=details',
  '5cbf451f61ef9b0308be5ef7' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-163/5cbf451f61ef9b0308be5ef7/info?infoTab=details',
  '5cbf451f61ef9b0308be5ef8' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-164/5cbf451f61ef9b0308be5ef8/info?infoTab=details',
  '5cbf451f61ef9b0308be5ef9' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-165/5cbf451f61ef9b0308be5ef9/info?infoTab=details',
  '5cbf451f61ef9b0308be5efa' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-166/5cbf451f61ef9b0308be5efa/info?infoTab=details',
  '5cbf451f61ef9b0308be5efb' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-167/5cbf451f61ef9b0308be5efb/info?infoTab=details',
  '5cbf451f61ef9b0308be5efc' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-168/5cbf451f61ef9b0308be5efc/info?infoTab=details',
  '5cbf451f61ef9b0308be5efd' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-169/5cbf451f61ef9b0308be5efd/info?infoTab=details',
  '5cbf451f61ef9b0308be5efe' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-170/5cbf451f61ef9b0308be5efe/info?infoTab=details',
  '5cbf451f61ef9b0308be5eff' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-171/5cbf451f61ef9b0308be5eff/info?infoTab=details',
  '5cbf451f61ef9b0308be5f00' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-172/5cbf451f61ef9b0308be5f00/info?infoTab=details',
  '5cbf451f61ef9b0308be5f01' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-173/5cbf451f61ef9b0308be5f01/info?infoTab=details',
  '5cbf451f61ef9b0308be5f02' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-174/5cbf451f61ef9b0308be5f02/info?infoTab=details',
  '5ce445180ed74003314fd866' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-175/5ce445180ed74003314fd866/info?infoTab=details',
  '5cbf451f61ef9b0308be5f03' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-176/5cbf451f61ef9b0308be5f03/info?infoTab=details',
  '5ce4456c5d90b203486a8c78' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-177/5ce4456c5d90b203486a8c78/info?infoTab=details',
  '5cbf451f61ef9b0308be5f04' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-178/5cbf451f61ef9b0308be5f04/info?infoTab=details',
  '5ce445b790d9fc0325b5377c' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-179/5ce445b790d9fc0325b5377c/info?infoTab=details',
  '5cbf451f61ef9b0308be5f05' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-180/5cbf451f61ef9b0308be5f05/info?infoTab=details',
  '5cbf451f61ef9b0308be5f06' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-181/5cbf451f61ef9b0308be5f06/info?infoTab=details',
  '5cbf451f61ef9b0308be5f07' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-182/5cbf451f61ef9b0308be5f07/info?infoTab=details',
  '5cbf451f61ef9b0308be5f08' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-183/5cbf451f61ef9b0308be5f08/info?infoTab=details',
  '5cbf451f61ef9b0308be5f09' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-184/5cbf451f61ef9b0308be5f09/info?infoTab=details',
  '5cbf451f61ef9b0308be5f0a' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-185/5cbf451f61ef9b0308be5f0a/info?infoTab=details',
  '5cbf451f61ef9b0308be5f0b' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-186/5cbf451f61ef9b0308be5f0b/info?infoTab=details',
  '5cbf451f61ef9b0308be5f0c' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-187/5cbf451f61ef9b0308be5f0c/info?infoTab=details',
  '5cbf451f61ef9b0308be5f0d' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-188/5cbf451f61ef9b0308be5f0d/info?infoTab=details',
  '5cbf451f61ef9b0308be5f0e' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-189/5cbf451f61ef9b0308be5f0e/info?infoTab=details',
  '5cbf451f61ef9b0308be5f0f' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-190/5cbf451f61ef9b0308be5f0f/info?infoTab=details',
  '5cbf451f61ef9b0308be5f10' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-191/5cbf451f61ef9b0308be5f10/info?infoTab=details',
  '5cbf451f61ef9b0308be5f11' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-192/5cbf451f61ef9b0308be5f11/info?infoTab=details',
  '5cbf451f61ef9b0308be5f12' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-193/5cbf451f61ef9b0308be5f12/info?infoTab=details',
  '5cbf451f61ef9b0308be5f13' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-194/5cbf451f61ef9b0308be5f13/info?infoTab=details',
  '5cbf451f61ef9b0308be5f14' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-195/5cbf451f61ef9b0308be5f14/info?infoTab=details',
  '5cbf451f61ef9b0308be5f15' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-196/5cbf451f61ef9b0308be5f15/info?infoTab=details',
  '5cbf451f61ef9b0308be5f16' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-197/5cbf451f61ef9b0308be5f16/info?infoTab=details',
  '5cbf451f61ef9b0308be5f17' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-198/5cbf451f61ef9b0308be5f17/info?infoTab=details',
  '' => 'Leave blank',
  '5cbf451f61ef9b0308be5f18' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-200/5cbf451f61ef9b0308be5f18/info?infoTab=details',
  '' => 'Leave blank',
  '5cbf451f61ef9b0308be5f19' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-202/5cbf451f61ef9b0308be5f19/info?infoTab=details',
  '' => 'Leave blank',
  '5cbf451f61ef9b0308be5f1a' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-204/5cbf451f61ef9b0308be5f1a/info?infoTab=details',
  '5ce4463c972ffa032d91bd97' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-205/5ce4463c972ffa032d91bd97/info?infoTab=details',
  '5cbf451f61ef9b0308be5f1b' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-206/5cbf451f61ef9b0308be5f1b/info?infoTab=details',
  '5ce4480c9a16010348640f44' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-207/5ce4480c9a16010348640f44/info?infoTab=details',
  '5cbf451f61ef9b0308be5f1c' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-208/5cbf451f61ef9b0308be5f1c/info?infoTab=details',
  '5ce4486de3b73f051f9e8725' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-209/5ce4486de3b73f051f9e8725/info?infoTab=details',
  '5cbf451f61ef9b0308be5f1d' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-210/5cbf451f61ef9b0308be5f1d/info?infoTab=details',
  '5cbf451f61ef9b0308be5f1e' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-211/5cbf451f61ef9b0308be5f1e/info?infoTab=details',
  '5cbf451f61ef9b0308be5f1f' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-212/5cbf451f61ef9b0308be5f1f/info?infoTab=details',
  '5cbf451f61ef9b0308be5f20' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-213/5cbf451f61ef9b0308be5f20/info?infoTab=details',
  '5cbf451f61ef9b0308be5f21' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-214/5cbf451f61ef9b0308be5f21/info?infoTab=details',
  '5cbf451f61ef9b0308be5f22' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-215/5cbf451f61ef9b0308be5f22/info?infoTab=details',
  '5cbf451f61ef9b0308be5f23' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-216/5cbf451f61ef9b0308be5f23/info?infoTab=details',
  '5cbf451f61ef9b0308be5f24' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-217/5cbf451f61ef9b0308be5f24/info?infoTab=details',
  '5cbf451f61ef9b0308be5f25' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-218/5cbf451f61ef9b0308be5f25/info?infoTab=details',
  '5cbf451f61ef9b0308be5f26' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-219/5cbf451f61ef9b0308be5f26/info?infoTab=details',
  '5cbf451f61ef9b0308be5f27' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-220/5cbf451f61ef9b0308be5f27/info?infoTab=details',
  '5cbf451f61ef9b0308be5f28' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-221/5cbf451f61ef9b0308be5f28/info?infoTab=details',
  '5cbf451f61ef9b0308be5f29' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-222/5cbf451f61ef9b0308be5f29/info?infoTab=details',
  '5cbf451f61ef9b0308be5f2a' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-223/5cbf451f61ef9b0308be5f2a/info?infoTab=details',
  '5cbf451f61ef9b0308be5f2b' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-224/5cbf451f61ef9b0308be5f2b/info?infoTab=details',
  '5cbf451f61ef9b0308be5f2c' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-225/5cbf451f61ef9b0308be5f2c/info?infoTab=details',
  '5cbf451f61ef9b0308be5f2d' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-226/5cbf451f61ef9b0308be5f2d/info?infoTab=details',
  '5cbf451f61ef9b0308be5f2e' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-227/5cbf451f61ef9b0308be5f2e/info?infoTab=details',
  '5cbf451f61ef9b0308be5f2f' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-228/5cbf451f61ef9b0308be5f2f/info?infoTab=details',
  '5cbf451f61ef9b0308be5f30' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-229/5cbf451f61ef9b0308be5f30/info?infoTab=details',
  '5cbf451f61ef9b0308be5f31' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-230/5cbf451f61ef9b0308be5f31/info?infoTab=details',
  '5cbf451f61ef9b0308be5f32' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-231/5cbf451f61ef9b0308be5f32/info?infoTab=details',
  '5cbf451f61ef9b0308be5f33' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-232/5cbf451f61ef9b0308be5f33/info?infoTab=details',
  '5cbf451f61ef9b0308be5f34' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-233/5cbf451f61ef9b0308be5f34/info?infoTab=details',
  '5cbf451f61ef9b0308be5f35' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-234/5cbf451f61ef9b0308be5f35/info?infoTab=details',
  '5ce44b619a16010348640f45' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-235/5ce44b619a16010348640f45/info?infoTab=details',
  '5cbf451f61ef9b0308be5f36' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-236/5cbf451f61ef9b0308be5f36/info?infoTab=details',
  '5ce44bc76577fc032b9a7fc4' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-237/5ce44bc76577fc032b9a7fc4/info?infoTab=details',
  '5cbf451f61ef9b0308be5f37' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-238/5cbf451f61ef9b0308be5f37/info?infoTab=details',
  '5ce44c194854c103285a1e68' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-239/5ce44c194854c103285a1e68/info?infoTab=details',
  '5cbf451f61ef9b0308be5f38' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-240/5cbf451f61ef9b0308be5f38/info?infoTab=details',
  '5cd0d56a8b8d66030a9e5179' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-asia-ladder-qualifier/5cd0d56a8b8d66030a9e5179/info?infoTab=details',
  '5cd0d615b90e24030f21c583' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-europe-ladder-qualifier/5cd0d615b90e24030f21c583/info?infoTab=details',
  '5cd0d3288b8d66030a9e5165' => 'https://battlefy.com/hsesports/hearthstone-masters-qualifier-seoul-americas-ladder-qualifier/5cd0d3288b8d66030a9e5165/info?infoTab=details',
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
    @output.concat("<h1> Match data for Swiss tournament '#{name}'</h1>\n")
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
