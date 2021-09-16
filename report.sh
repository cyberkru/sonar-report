#!/bin/bash

echo "Component: $COMPONENTKEY"
echo "Connecting...."

node ./index.js \
        --sonarurl="https://sonarcloud.io"  \
        --sonartoken="$SONARTOKEN" \
        --sonarorganization="$ORGANIZATION" \
        --sonarcomponent="$COMPONENTKEY" \
        --project="$COMPONENTKEY" \
        --application="$COMPONENTKEY" \
        --release="1.0.0" \
        --sinceleakperiod="false" \
        --allbugs="false" > report.html

echo "Done...."

echo "Sending to Dojo..."

curl -X POST --header "Content-Type:multipart/form-data" --header "Authorization:Token $DOJOKEY" -F "engagement=${EGID}" -F "scan_type=SonarQube Scan detailed" -F 'file=@./report.html' --url "http://${DOJOIP}/api/v2/import-scan/"
printf "\nDone\n"
