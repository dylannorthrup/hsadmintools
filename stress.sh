#!/bin/bash

while true; do
#  echo "bracket_id=5cae58e6781331034e4b95b4" | /usr/bin/ruby $(pwd)/code/match_status.rb
  REQUEST_METHOD=GET QUERY_STRING="bracket_id=5cae58e6781331034e4b95b4" PATH_INFO=/match_status.rb ./d.cgi
  if [ $? -ne 0 ]; then
    exit
  fi
done
