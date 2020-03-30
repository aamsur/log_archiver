#!/bin/bash

# current file dir
_DIR=$(dirname "$(readlink -f "$0")")

# read .env from current file dir
LOG_EXT=$(grep -Po '(?<=LOG_EXT=").*?(?=")' $_DIR/.env)
LOG_PATH_STRING=$(grep LOG_PATH_STRING $_DIR/.env | cut -d '=' -f2)

# convert string into array
# we need to loop this path
LOG_PATH=($(echo "$LOG_PATH_STRING" | tr ',' '\n'))

TODAY=$(date '+%d_%m_%Y')

if [ -z $LOG_EXT ]; then
    echo "Mohon periksa kembali file $_DIR/.env !"
    exit 0
fi

function _archv_log() {
	printf "[~] Mengarsipkan file ${LOG_EXT} ...\n\n"
	for x in $(find $(echo ${LOG_PATH[*]}) -type f -name "*.${LOG_EXT}" -mtime +30 -print);
	do
		tar zcvf ${x}_${TODAY}.tgz $x 2> .removing.tmp
		if [[ $? -eq 0 ]]; then
			printf "[*] Berhasil mengarsipkan file: ${x}\n"
		else
			printf "[!] Gagal mengarsipkan file: ${x}\n"
		fi
		rm -f $x .removing.tmp
	done
	wait
	printf "\n[+] Mengarsipkan selesai ...\n"
}

echo "-=============================-"
(date '+%Y/%m/%d %H:%M:%S')
_archv_log
