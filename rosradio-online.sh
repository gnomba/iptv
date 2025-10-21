#!/bin/bash

vBASE_URL="https://rosradio-online.ru"
echo "[+] ${vBASE_URL}"
vREGIONS="$(curl -s ${vBASE_URL}/regions.htm | grep ' target=streams ' | sed 's/<\/a><\/li><li>/\n/g;s/<\/a><\/li><\/ul>/\n/g;s/<ul><li>//g' | awk -F\' '{print $2}' | sed '/^$/d')"

for vSTATION in ${vREGIONS}; do
    echo "   + ${vSTATION}"
    vSTATION_URL="${vBASE_URL}/${vSTATION}"
    vDETAIL_LIST="$(curl -s ${vSTATION_URL} | grep -o detail_.*.htm)"
    for vDETAIL_ITEM in ${vDETAIL_LIST}; do
        echo "    - ${vDETAIL_ITEM}"
        vDETAIL_URL="${vBASE_URL}/${vDETAIL_ITEM}"
        vDETAIL_HTML="$(curl -s ${vDETAIL_URL} | sed 's/ (Горный Алтай)//g')"
        vDETAIL_NAME="$(echo "${vDETAIL_HTML}" | grep '<td class=city>' | sed 's/^<tr height=70><td class=city>//;s/<\/td><\/tr>.*$//')"
        echo "${vDETAIL_NAME}"
        vNAME="$(echo "${vDETAIL_NAME}" | awk -F"<br>" '{print $1}')"; echo "${vNAME}"
        vCITY="$(echo "${vDETAIL_NAME}" | grep -oP "(?<=<br>)[^(']+(?= \()")"; echo "${vCITY}"
        vREGION="$(echo "${vDETAIL_NAME}" | grep -oP '\(\K.*?(?=\))')"; echo "${vREGION}"
        vFM="$(echo "${vDETAIL_NAME}" | awk -F"<br>" '{print $3}')"; echo "${vFM}"
        vDETAIL_LOGO="$(echo "${vDETAIL_HTML}" | grep -o 'logos.*.jpg')"; echo "${vDETAIL_LOGO}"
        vLOGO="${vBASE_URL}/${vDETAIL_LOGO}"; echo "${vLOGO}"
        #break
    done

    #break
done

exit 0
