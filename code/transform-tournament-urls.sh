#!/bin/bash
#
# cat file into this script and it should output the transformed but ready to read into the match_status script

echo "#!/usr/bin/ruby -w"
echo ""
echo "@tournament_hash = {"
sed -e 's/info.*/stage/' | awk -F/ '{print "  \"" $(NF-1) "\" => \"" $0 "\","}'
echo "}"
