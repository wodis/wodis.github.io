#!/bin/sh
if [ $# -lt 1 ]
then
        echo "need version parameter,exit!!";
        exit;
fi

suffix=$1
#suffix="png"

host="http://www.openwudi.com"

year=`date '+%Y'`
time=`date '+%s'`
file_name=${time}"."${suffix}
url=${host}"/images/"${year}"/"${file_name}

echo ${file_name}
echo ${url}
echo "!["${file_name}"]("${url}")"