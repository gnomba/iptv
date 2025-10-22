#!/bin/bash

vRED='\033[0;31m'
vGREEN='\033[0;32m'
vNC='\033[0m' # No Color

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
        vCITY="$(echo "${vDETAIL_NAME}" | grep -oP "(?<=<br>)[^(']+(?= \()")"
        if [[ "${vCITY}" == "" ]]; then
            vCITY="$(echo "${vDETAIL_NAME}" | awk -F"<br>" '{print $2}')"
        fi
        echo "${vCITY}"
        vREGION="$(echo "${vDETAIL_NAME}" | grep -oP '\(\K.*?(?=\))')"
        if [[ "${vREGION}" == "" ]]; then
            vREGION="$(echo "${vDETAIL_NAME}" | awk -F"<br>" '{print $2}')"
        fi
        echo "${vREGION}"
        vFM="$(echo "${vDETAIL_NAME}" | awk -F"<br>" '{print $3}')"; echo "${vFM}"
        vDETAIL_LOGO="$(echo "${vDETAIL_HTML}" | grep -o 'logos.*.jpg')"; echo "${vDETAIL_LOGO}"
        vLOGO="${vBASE_URL}/${vDETAIL_LOGO}"; echo "${vLOGO}"

        vHTTP_LIST="$(echo "${vDETAIL_HTML}" | grep 'a class=link' | sed "s/<[^>]*>//g")"
        #echo "LIST: ${vHTTP_LIST}"
        for vHTTP_ITEM in ${vHTTP_LIST}; do
            echo "ITEM ->  ${vHTTP_ITEM}"
            sleep 1
            vTEMP_FILE="$(mktemp)"; echo "${vTEMP_FILE}"
            timeout 5 ffprobe -hide_banner -v 0 -select_streams v -print_format flat -show_format -show_streams ${vHTTP_ITEM} 2>&1 > "${vTEMP_FILE}"
            ll ${vTEMP_FILE}; cat ${vTEMP_FILE}
            vRESULT="$(grep 'format_name=' "${vTEMP_FILE}" | awk -F'"' '{print $2}')"
            rm -fv "${vTEMP_FILE}"
            echo "vRESULT=${vRESULT}"
            if [[ "${vRESULT}" != "" ]]; then
                echo -e " ${vGREEN}[+] CHECK: OK -> ${vRESULT}${vNC}"
            else
                echo -e " ${vRED}[-] CHECK: ${vRESULT}${vNC}"
            fi
        done
        break
    done

    break
done

exit 0
