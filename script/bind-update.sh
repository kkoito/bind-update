#!/bin/sh

###環境変数
. ~/bind-update/script/var.list 2> /dev/null 
. ~/bind-update/script/func.list 2> /dev/null

if [ ! -e ${SCRIPT_DIR}/${DNSPERFLIST} ]
then
        wget http://pkgs.fedoraproject.org/repo/pkgs/dnsperf/queryfile-example-current.gz/md5/851024fb2d6320ae126b0dcc4f5bb578/queryfile-example-current.gz -P ${SCRIPT_DIR}
        gzip -d ${SCRIPT_DIR}/${DNSPERFLIST}.gz
        if [ ! -e ${SCRIPT_DIR}/${DNSPERFLIST} ]
        then
		echo "BIND TEST : Get miss query-list"  >> ${LOG}
		exit 1
        fi
fi



###処理開始
#ディレクトリ作成
ansible-playbook ${ANSIBLE_DIR}/site.yml -i ${ANSIBLE_DIR}/hosts/product --tags default

#設定ファイルコピー
ansible-playbook ${ANSIBLE_DIR}/site.yml -i ${ANSIBLE_DIR}/hosts/product --tags copy

#dnsperfインストール
ansible-playbook ${ANSIBLE_DIR}/site.yml -i ${ANSIBLE_DIR}/hosts/product --tags install

fun_mv

#bindアップデート一回目
ansible-playbook ${ANSIBLE_DIR}/site.yml -i ${ANSIBLE_DIR}/hosts/product --tags playbook

ansible-playbook ${ANSIBLE_DIR}/site.yml -i ${ANSIBLE_DIR}/hosts/product --tags copy


echo "<< `date +"%Y/%m/%d-%H:%M:%S"` >>" >> ${LOG}
echo "  BIND TEST : START " >> ${LOG}
sudo diff ${FILES_DIR}/bind_version.txt ${FILES_DIR}/${i}-bind_version.txt
if [ $? -eq 1 ]
then
	echo "  RESULT : Updated , Continue the process" >> ${LOG}
	sh ${SCRIPT_DIR}/mail.sh
	fun_dig
	fun_diff
	fun_wget
	donwload.sh
	i=$(( i + 1 ))
        fun_mv

	ansible-playbook ${ANSIBLE_DIR}/site.yml -i ${ANSIBLE_DIR}/hosts/product --tags failback
	ansible-playbook ${ANSIBLE_DIR}/site.yml -i ${ANSIBLE_DIR}/hosts/product --tags copy
	fun_dig
	fun_diff
	fun_wget
        i=$(( i + 1 ))
	fun_mv

	ansible-playbook ${ANSIBLE_DIR}/site.yml -i ${ANSIBLE_DIR}/hosts/product --tags playbook
	ansible-playbook ${ANSIBLE_DIR}/site.yml -i ${ANSIBLE_DIR}/hosts/product --tags copy
	fun_diff
        i=$(( i + 1 ))
	fun_mv

	sh ${SCRIPT_DIR}/dnsperf.sh
	echo   "SUCCESS : Please check configures in ${NEWPKG_DIR}/`date +%Y%m%d`" >> ${LOG}
	echo "  BIND TEST : END"  >> ${LOG}
        mv  ${BACKUP_DIR} ${NEWPKG_DIR}/`date +"%Y%m%d"`
else
	echo "  RESULT : No Updated " >> ${LOG}
	echo "  BIND TEST : END"  >> ${LOG}
fi

exit 0
