#!/bin/bash

. ~/bind-update/script/var.list

ifcheck(){
	if [ $? -eq 0 ]
	then
		echo "  OK : count-${d} : Success dnsperf" >> ${LOG}
		d=$(( d + 1 ))
	else
		echo "NG: Miss dnsperf." >> ${LOG}
		exit 1
	fi
}
#キャッシュ溜める　100q/secを600秒 
dnsperf -l 6 -e -s 127.0.0.1 -t 6 -Q 100 -d ${SCRIPT_DIR}/queryfile-example-current > ${DNSPERF_DIR}/dnsperf_0.log
ifcheck

#限界テスト：1回目　2000q/secを30秒
dnsperf -l 3 -e -s 127.0.0.1 -t 6 -Q 2000 -d ${SCRIPT_DIR}/queryfile-example-current > ${DNSPERF_DIR}/dnsperf_1.log
ifcheck

#限界テスト：2回目 2000q/secを30秒
dnsperf -l 3 -e -s 127.0.0.1 -t 6 -Q 2000 -d ${SCRIPT_DIR}/queryfile-example-current > ${DNSPERF_DIR}/dnsperf_2.log
ifcheck

#限界テスト：3回目 2000q/secを30秒
dnsperf -l 3 -e -s 127.0.0.1 -t 6 -Q 2000 -d ${SCRIPT_DIR}/queryfile-example-current > ${DNSPERF_DIR}/dnsperf_3.log
ifcheck

#限界テスト：4回目 2000q/secを30秒
dnsperf -l 3 -e -s 127.0.0.1 -t 6 -Q 2000 -d ${SCRIPT_DIR}/queryfile-example-current > ${DNSPERF_DIR}/dnsperf_4.log
ifcheck

#限界テスト：5回目 2000q/secを30秒
dnsperf -l 3 -e -s 127.0.0.1 -t 6 -Q 2000 -d ${SCRIPT_DIR}/queryfile-example-current > ${DNSPERF_DIR}/dnsperf_5.log
ifcheck

exit 0
