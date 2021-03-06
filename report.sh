#!/bin/bash

echo "Component: $COMPONENTKEY"
echo "Connecting...."

node ./index.js \
        --sonarurl="https://sonarcloud.io"  \
        --sonartoken="$SONARTOKEN" \
        --sonarorganization="$ORGANIZATION" \
        --sonarcomponent="$COMPONENTKEY" \
        --project="$COMPONENTKEY" \
        --branch="$BRANCH" \
        --application="$COMPONENTKEY" \
        --release="1.0.0" \
        --sinceleakperiod="false" \
        --allbugs="false" > report.html

echo "Done...."

if test -f "report.html"; then
        echo "Sending to Dojo..."

        PRODID=$(curl -k -s -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Token ${DOJOKEY}" --url "${DOJOURL}/api/v2/products/?limit=1000" | jq -c '[.results[] | select(.name | contains('\"${PRODNAME}\"'))][0] | .id')
        EGID=$(curl -k -s -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Token ${DOJOKEY}" --url "${DOJOURL}/api/v2/engagements/?limit=1000" | jq -c "[.results[] | select(.product == ${PRODID})]" | jq  -c '[.[] | select(.engagement_type == "CI/CD" and .branch_tag == '\"${BRANCH}\"')][0] | .id')
        #EGID=$(curl -s -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Token $DOJOKEY" --url "${DOJOURL}/api/v2/engagements/?limit=1000" | jq -c "[.results[] | select(.product == ${PRODID})][0] | .id")
        curl -k -X POST --header "Content-Type:multipart/form-data" --header "Authorization:Token $DOJOKEY" -F "engagement=${EGID}" -F "branch_tag=${BRANCH}" -F "environment=${BRANCH}" -F "close_old_findings=true" -F "scan_type=SonarQube Scan detailed" -F 'file=@./report.html' --url "${DOJOURL}/api/v2/import-scan/"
        printf "\nDone\n"
fi 
