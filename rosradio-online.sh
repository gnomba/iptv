#!/bin/bash

#set -x

vSTART="$(date)"
vRED='\033[0;31m'
vGREEN='\033[0;32m'
vYELLOW='\033[0;33m'
vNoColor='\033[0m' # No Color

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
        vNAME="$(echo "${vDETAIL_NAME}" | awk -F"<br>" '{print $1}')"
        #echo "${vNAME}"
        vCITY="$(echo "${vDETAIL_NAME}" | grep -oP "(?<=<br>)[^(']+(?= \()")"
        if [[ "${vCITY}" == "" ]]; then
            vCITY="$(echo "${vDETAIL_NAME}" | awk -F"<br>" '{print $2}')"
        fi
        #echo "${vCITY}"
        vREGION="$(echo "${vDETAIL_NAME}" | grep -oP '\(\K.*?(?=\))')"
        if [[ "${vREGION}" == "" ]]; then
            vREGION="$(echo "${vDETAIL_NAME}" | awk -F"<br>" '{print $2}')"
        fi
        #echo "${vREGION}"
        vFM="$(echo "${vDETAIL_NAME}" | awk -F"<br>" '{print $3}')"
        #echo "${vFM}"
        vDETAIL_LOGO="$(echo "${vDETAIL_HTML}" | grep -o 'logos.*.jpg')"
        #echo "${vDETAIL_LOGO}"
        vLOGO="${vBASE_URL}/${vDETAIL_LOGO}"
        #echo "${vLOGO}"

        vHTTP_LIST="$(echo "${vDETAIL_HTML}" | grep 'a class=link' | sed "s/<[^>]*>//g" | sed "s/Draw_Question2//g;s/(11)//g;s/\r$//g")"
        #echo "LIST: ${vHTTP_LIST}"
        for vHTTP_ITEM in ${vHTTP_LIST}; do
            echo -e "ITEM ${vYELLOW}->${vNoColor}  ${vHTTP_ITEM}"
            #vRESULT="$(curl -s --max-time 5 -A "Mozilla/5.0" -H "Icy-MetaData:0" -o /dev/null -w "%{http_code}" "${vHTTP_ITEM}")"
            #echo "vRESULT=${vRESULT}"
            #if [[ "${vRESULT}" != "404" && -n "${vHTTP_ITEM}" ]]; then
            #    echo -e " ${vGREEN}[+] CHECK: OK -> \"${vRESULT}\"${vNoColor}"
            #    echo -e "#EXTINF:-1 tvg-name=\"${vNAME}\" tvg-logo=\"${vLOGO}\" group-title=\"${vREGION}\",${vNAME} [${vCITY} ${vFM}]\n${vHTTP_ITEM}\n" >> rosradio-online_${vREGION// /_}.m3u
            #else
            #    echo -e " ${vRED}[-] CHECK: \"${vRESULT}\"${vNoColor}"
            #    echo -e "#EXTINF:-1 tvg-name=\"${vNAME}\" tvg-logo=\"${vLOGO}\" group-title=\"${vREGION}\",${vNAME} [${vCITY} ${vFM}]\n${vHTTP_ITEM}\n" >> ${vRESULT}.txt
            #fi
            echo -e "#EXTINF:-1 tvg-name=\"${vNAME}\" tvg-logo=\"${vLOGO}\" group-title=\"${vREGION}\",${vNAME} [${vCITY} ${vFM}]\n${vHTTP_ITEM}\n" >> rosradio-online.m3u
            #vRESULT=""
        done
        #break
    done

    #break
done

vSTOP="$(date)"
echo -e "vSTART=${vSTART}\nvSTOP=${vSTOP}\n"

exit 0

#URL="http://voicemaikop.hostingradio.ru:8003/voicemaikop32.aacp"
#vRESULT=$(curl -s --output /dev/null --write-out "%{http_code}" --max-time 2 "$URL")
#echo "$vRESULT"

#curl -s --fail --max-time 2 "$URL" > /dev/null \
#  && echo "OK" \
#  || echo "FAIL"
