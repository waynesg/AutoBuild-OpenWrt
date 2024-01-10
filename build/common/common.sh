#!/bin/bash
# https://github.com/mdtycl/Compile-OpenWrt
# common Module by mdtycl
# matrix.target=${Modelfile}

TIME() {
Compte=$(date +%Y年%m月%d号%H时%M分)
[[ -z "$1" ]] && {
	echo -ne " "
} || {
     case $1 in
	r) export Color="\e[31m";;
	g) export Color="\e[32m";;
	b) export Color="\e[34m";;
	y) export Color="\e[33m";;
	z) export Color="\e[35m";;
	l) export Color="\e[36m";;
      esac
	[[ $# -lt 2 ]] && echo -e "\e[36m\e[0m ${1}" || {
		echo -e "\e[36m\e[0m ${Color}${2}\e[0m"
	 }
      }
}

function settings_variable() {
if [[ -n "${REPO_BRANCH}" ]]; then
  ymlpath="build/${FOLDER_NAME}/settings.ini"
  if [[ ! -d "build/${FOLDER_NAME}/relevance" ]]; then
    mkdir -p build/${FOLDER_NAME}/relevance
  else
    rm -rf build/${FOLDER_NAME}/relevance/*.ini
  fi
  ymlsettings="build/${FOLDER_NAME}/relevance/settings.ini"
  echo "ymlsettings=${ymlsettings}" >> ${GITHUB_ENV}
  cp -Rf "${ymlpath}" "${ymlsettings}"
  
  if [[ `echo "${CPU_SELECTION}" |grep -Eoc 'E5'` -eq '1' ]] || [[ `echo "${CPU_SELECTION}" |grep -Eoc 'e5'` -eq '1' ]]; then
    export CPU_SELECTION="E5"
  elif [[ `echo "${CPU_SELECTION}" |grep -Eoc '8370'` -eq '1' ]]; then
    export CPU_SELECTION="8370"
  elif [[ `echo "${CPU_SELECTION}" |grep -Eoc '8272'` -eq '1' ]]; then
    export CPU_SELECTION="8272"
  elif [[ `echo "${CPU_SELECTION}" |grep -Eoc '8171'` -eq '1' ]]; then
    export CPU_SELECTION="8171"
  else
    export CPU_SELECTION="E5"
  fi
  
  REPO_URL1="$(grep "REPO_URL=" "${ymlpath}" |sed 's/^[ ]*//g' |grep -v '^#' |awk '{print $(1)}' |sed 's?=?\\&?g' |sed 's?"?\\&?g')"
  REPO_BRANCH1="$(grep "REPO_BRANCH=" "${ymlpath}" |sed 's/^[ ]*//g' |grep -v '^#' |awk '{print $(1)}' |sed 's?=?\\&?g' |sed 's?"?\\&?g')"
  CONFIG_FILE1="$(grep "CONFIG_FILE=" "${ymlpath}" |sed 's/^[ ]*//g' |grep -v '^#' |awk '{print $(1)}' |sed 's?=?\\&?g' |sed 's?"?\\&?g')"
  UPLOAD_FIRMWARE1="$(grep "UPLOAD_FIRMWARE=" "${ymlpath}" |sed 's/^[ ]*//g' |grep -v '^#' |awk '{print $(1)}' |sed 's?=?\\&?g' |sed 's?"?\\&?g')"
  UPLOAD_RELEASE1="$(grep "UPLOAD_RELEASE=" "${ymlpath}" |sed 's/^[ ]*//g' |grep -v '^#' |awk '{print $(1)}' |sed 's?=?\\&?g' |sed 's?"?\\&?g')"
  CPU_SELECTION1="$(grep "CPU_SELECTION=" "${ymlpath}" |sed 's/^[ ]*//g' |grep -v '^#' |awk '{print $(1)}' |sed 's?=?\\&?g' |sed 's?"?\\&?g')"
  USE_CACHEWRTBUILD1="$(grep "USE_CACHEWRTBUILD=" "${ymlpath}" |sed 's/^[ ]*//g' |grep -v '^#' |awk '{print $(1)}' |sed 's?=?\\&?g' |sed 's?"?\\&?g')"
  REGULAR_UPDATE1="$(grep "REGULAR_UPDATE=" "${ymlpath}" |sed 's/^[ ]*//g' |grep -v '^#' |awk '{print $(1)}' |sed 's?=?\\&?g' |sed 's?"?\\&?g')"
  
  REPO_URL2="REPO_URL\\=\\\"${REPO_URL}\\\""
  REPO_BRANCH2="REPO_BRANCH\\=\\\"${REPO_BRANCH}\\\""
  CONFIG_FILE2="CONFIG_FILE\\=\\\"${CONFIG_FILE}\\\""
  UPLOAD_FIRMWARE2="UPLOAD_FIRMWARE\\=\\\"${UPLOAD_FIRMWARE}\\\""
  UPLOAD_RELEASE2="UPLOAD_RELEASE\\=\\\"${UPLOAD_RELEASE}\\\""
  CPU_SELECTION2="CPU_SELECTION\\=\\\"${CPU_SELECTION}\\\""
  USE_CACHEWRTBUILD2="USE_CACHEWRTBUILD\\=\\\"${USE_CACHEWRTBUILD}\\\""
  REGULAR_UPDATE2="REGULAR_UPDATE\\=\\\"${REGULAR_UPDATE}\\\""

  sed -i "s?${REPO_URL1}?${REPO_URL2}?g" "${ymlsettings}"
  sed -i "s?${REPO_BRANCH1}?${REPO_BRANCH2}?g" "${ymlsettings}"
  sed -i "s?${CONFIG_FILE1}?${CONFIG_FILE2}?g" "${ymlsettings}"
  sed -i "s?${UPLOAD_FIRMWARE1}?${UPLOAD_FIRMWARE2}?g" "${ymlsettings}"
  sed -i "s?${UPLOAD_RELEASE1}?${UPLOAD_RELEASE2}?g" "${ymlsettings}"
  sed -i "s?${CPU_SELECTION1}?${CPU_SELECTION2}?g" "${ymlsettings}"
  sed -i "s?${USE_CACHEWRTBUILD1}?${USE_CACHEWRTBUILD2}?g" "${ymlsettings}"
  sed -i "s?${REGULAR_UPDATE1}?${REGULAR_UPDATE2}?g" "${ymlsettings}"
  export t1=`date -d "$(date +'%Y-%m-%d %H:%M:%S')" +%s`
  echo "t1=${t1}" >> ${GITHUB_ENV}
  mv "${ymlsettings}" build/${FOLDER_NAME}/relevance/${t1}.ini
else
  export t1="1234567"
  echo "t1=${t1}" >> ${GITHUB_ENV}
fi
}


function Diy_variable() {
if [[ -n "${BENDI_VERSION}" ]]; then
  source "${GITHUB_WORKSPACE}/operates/${FOLDER_NAME}/settings.ini"
elif [[ "${Manually_Run}" == "1" ]]; then
  source "${GITHUB_WORKSPACE}/build/${FOLDER_NAME}/settings.ini"
  echo "t1=1234567" >> ${GITHUB_ENV}
else
  if [[ -z "${t1}" ]]; then
    t1="$(grep "CPU_PASSWORD=" "${GITHUB_WORKSPACE}/.github/workflows/compile.yml" |grep -v '^#' |grep -Eo '[0-9]+')"
    echo "${t1}"
  fi
  if [[ "${t1}" == "1234567" ]]; then
    source "${GITHUB_WORKSPACE}/build/${FOLDER_NAME}/settings.ini"
    echo "t1=1234567" >> ${GITHUB_ENV}
  elif [[ -f "${GITHUB_WORKSPACE}/build/${FOLDER_NAME}/relevance/${t1}.ini" ]]; then
    source "${GITHUB_WORKSPACE}/build/${FOLDER_NAME}/relevance/${t1}.ini"
    echo "t1=${t1}" >> ${GITHUB_ENV}
    echo "运行${t1}.ini"
  else
    source "${GITHUB_WORKSPACE}/build/${FOLDER_NAME}/settings.ini"
  fi
fi
}
#####################
# 触发
#####################
function build_openwrt() {
cd ${GITHUB_WORKSPACE}
if [[ `echo "${CPU_SELECTION}" |grep -Eoc 'E5'` -eq '1' ]] || [[ `echo "${CPU_SELECTION}" |grep -Eoc 'e5'` -eq '1' ]]; then
  export CPU_SELECTIO="E5"
  export kaisbianyixx="Compile"
elif [[ `echo "${CPU_SELECTION}" |grep -Eoc '8370'` -eq '1' ]]; then
  export CPU_SELECTIO="8370"
  export kaisbianyixx="8370-Compile"
elif [[ `echo "${CPU_SELECTION}" |grep -Eoc '8272'` -eq '1' ]]; then
  export CPU_SELECTIO="8272"
  export kaisbianyixx="8272-Compile"
elif [[ `echo "${CPU_SELECTION}" |grep -Eoc '8171'` -eq '1' ]]; then
  export CPU_SELECTIO="8171"
  export kaisbianyixx="8171-Compile"
else
  export kaisbianyixx=Compile""
fi
git clone -b main https://github.com/${Apidz}.git ${FOLDER_NAME}
export YML_PATH="${FOLDER_NAME}/.github/workflows/compile.yml"
export TARGET1="$(grep 'target: \[' "${YML_PATH}" |sed 's/^[ ]*//g' |grep -v '^#' |sed 's/\[/\\&/' |sed 's/\]/\\&/')"
export TARGET2="target: \\[${FOLDER_NAME}\\]"
export PATHS1="$(grep -Eo "\- '.*'" "${YML_PATH}" |sed 's/^[ ]*//g' |grep -v "^#" |awk 'NR==1')"
export PATHS2="- 'build/${FOLDER_NAME}/relevance/start'"
export cpu1="CPU_OPTIMIZATION=.*"
export cpu2="CPU_OPTIMIZATION\\=\\\"${CPU_SELECTIO}\\\""
export CPU_PASS1="CPU_PASSWORD=.*"
if [[ "${t1}" == "1234567" ]]; then
  export CPU_PASS2="CPU_PASSWORD\\=\\\"1234567\\\""
else
  if [[ -f "${GITHUB_WORKSPACE}/build/${FOLDER_NAME}/relevance/${t1}.ini" ]]; then
    rm -fr ${FOLDER_NAME}/build/${FOLDER_NAME}/relevance/*.ini
    mv "${GITHUB_WORKSPACE}/build/${FOLDER_NAME}/relevance/${t1}.ini" ${FOLDER_NAME}/build/${FOLDER_NAME}/relevance/${t1}.ini
  fi
  export CPU_PASS2="CPU_PASSWORD\\=\\\"${t1}\\\""
  echo "$CPU_PASS2"
fi

if [[ -n "${CPU_PASS1}" ]] && [[ -n "${CPU_PASS2}" ]]; then
  sed -i "s?${CPU_PASS1}?${CPU_PASS2}?g" "${YML_PATH}"
else
  echo "获取变量失败,请勿胡乱修改compile.yml文件"
  exit 1
fi

if [[ -n "${PATHS1}" ]] && [[ -n "${TARGET1}" ]]; then
  sed -i "s?${PATHS1}?${PATHS2}?g" "${YML_PATH}"
  sed -i "s?${TARGET1}?${TARGET2}?g" "${YML_PATH}"
else
  echo "获取变量失败,请勿胡乱修改compile.yml文件"
  exit 1
fi
if [[ -n ${cpu1} ]] && [[ -n ${cpu2} ]]; then
  sed -i "s?${cpu1}?${cpu2}?g" "${YML_PATH}"
else
  echo "获取变量失败,请勿胡乱修改定时启动编译时的数值设置"
  exit 1
fi
cp -Rf config.txt ${FOLDER_NAME}/build/${FOLDER_NAME}/${CONFIG_FILE}

restartsj="$(cat "${FOLDER_NAME}/build/${FOLDER_NAME}/relevance/start" |awk '$0=NR" "$0' |awk 'END {print}' |awk '{print $(1)}')"
if [[ "${restartsj}" -lt "3" ]]; then
  echo "${CODE}-${REPO_BRANCH}-${CONFIG_FILE}-$(date +%Y年%m月%d号%H时%M分%S秒)" >> ${FOLDER_NAME}/build/${FOLDER_NAME}/relevance/start
else
  echo "${CODE}-${REPO_BRANCH}-${CONFIG_FILE}-$(date +%Y年%m月%d号%H时%M分%S秒)" > ${FOLDER_NAME}/build/${FOLDER_NAME}/relevance/start
fi

cd ${FOLDER_NAME}
git add .
git commit -m "${kaisbianyixx}-${FOLDER_NAME}-${LUCI_EDITION}-${TARGET_PROFILE}"
git push --force "https://${REPO_TOKEN}@github.com/${Apidz}" HEAD:main
}
################################################################################################################
# LEDE源码通用diy.sh文件
################################################################################################################
Diy_lede() {
find . -name 'luci-app-argon-config' -o -name 'luci-theme-argon' -o -name 'luci-theme-material' -o -name 'luci-app-serverchan' | xargs -i rm -rf {}
#find . -name 'netdata' -o -name 'luci-app-netdata' -o -name 'luci-app-serverchan' | xargs -i rm -rf {}
find . -name 'luci-app-pushbot' -o -name 'luci-app-unblockmusic' -o -name 'luci-app-omcproxy' | xargs -i rm -rf {}
find . -name 'mosdns' -o -name 'luci-app-mosdns' -o -name 'v2dat' | xargs -i rm -rf {}
find . -name 'adguardhome' -o -name 'go-aliyundrive-webdav' | xargs -i rm -rf {}
find . -name 'msd_lite' -o -name 'v2ray-geodata' -o -name 'luci-lib-ipkg' | xargs -i rm -rf {}
}
################################################################################################################
# LIENOL源码通用diy.sh文件
################################################################################################################
Diy_lienol() {

find . -name 'luci-app-netdata' -o -name 'netdata' -o -name 'luci-theme-argon' | xargs -i rm -rf {}
find . -name 'ddns-scripts_aliyun' -o -name 'ddns-scripts_dnspod' -o -name 'luci-app-wol' | xargs -i rm -rf {}
find . -name 'luci-app-wrtbwmon' -o -name 'wrtbwmon' -o -name 'pdnsd-alt' | xargs -i rm -rf {}

}


################################################################################################################
# 天灵源码18.06 diy.sh文件
################################################################################################################
Diy_mortal() {

find . -name 'luci-app-argon-config' -o -name 'luci-theme-argon' -o -name 'luci-light' | xargs -i rm -rf {}
find . -name 'luci-app-netdata' -o -name 'netdata' -o -name 'luci-theme-openwrt' -o -name 'luci-app-cifs' | xargs -i rm -rf {}
find . -name 'luci-app-wrtbwmon' -o -name 'wrtbwmon' | xargs -i rm -rf {}
}

function CPU_Priority() {
export TARGET_BOARD="$(awk -F '[="]+' '/TARGET_BOARD/{print $2}' build/${FOLDER_NAME}/${CONFIG_FILE})"
export TARGET_SUBTARGET="$(awk -F '[="]+' '/TARGET_SUBTARGET/{print $2}' build/${FOLDER_NAME}/${CONFIG_FILE})"
if [[ `grep -Eoc 'CONFIG_TARGET_x86_64=y' build/${FOLDER_NAME}/${CONFIG_FILE}` -eq '1' ]]; then
  export TARGET_PROFILE="x86-64"
elif [[ `grep -Eoc 'CONFIG_TARGET_x86=y' build/${FOLDER_NAME}/${CONFIG_FILE}` -eq '1' ]]; then
  export TARGET_PROFILE="x86-32"
elif [[ `grep -Eoc 'CONFIG_TARGET_armvirt_64_Default=y' build/${FOLDER_NAME}/${CONFIG_FILE}` -eq '1' ]]; then
  export TARGET_PROFILE="Armvirt_64"
elif [[ `grep -Eoc "CONFIG_TARGET.*DEVICE.*=y" build/${FOLDER_NAME}/${CONFIG_FILE}` -eq '1' ]]; then
  export TARGET_PROFILE="$(grep -Eo "CONFIG_TARGET.*DEVICE.*=y" build/${FOLDER_NAME}/${CONFIG_FILE} | sed -r 's/.*DEVICE_(.*)=y/\1/')"
else
  export TARGET_PROFILE="$(cat "build/${FOLDER_NAME}/${CONFIG_FILE}" |grep "CONFIG_TARGET_.*=y" |awk 'END {print}'|sed "s/CONFIG_TARGET_//g"|sed "s/=y//g")"
fi

cpu_model=`cat /proc/cpuinfo  |grep 'model name' |gawk -F : '{print $2}' | uniq -c  | sed 's/^ \+[0-9]\+ //g'`
TIME y "正在使用CPU型号：${cpu_model}"

if [[ -n "${CPU_SELECTIOY}" ]]; then
  CPU_OPTIMIZATION="${CPU_SELECTIOY}"
fi

case "${CPU_OPTIMIZATION}" in
E5|弃用E5系列|弃用E5)
  if [[ `echo "${cpu_model}" |grep -Eoc "E5"` -eq '1' ]]; then
    export chonglaixx="Recompile-Kick-E5"
    export Continue_selecting="1"
  else
    TIME g " 恭喜,正在使用非E5系列CPU执行编译"
    export Continue_selecting="0"
  fi
;;
8370|8272|8171|8370C|8272CL|8171M)
  if [[ `echo "${cpu_model}" |grep -Eoc "${CPU_OPTIMIZATION}"` -eq '0' ]]; then
    export chonglaixx="Recompile-Non-${CPU_OPTIMIZATION}"
    export Continue_selecting="1"
  else
    TIME g " 恭喜,正是您想要的${CPU_OPTIMIZATION}CPU"
    export Continue_selecting="0"
  fi
;;
*)
  echo "${CPU_OPTIMIZATION},变量检测有错误"
  export Continue_selecting="0"
;;
esac

if [[ "${Continue_selecting}" == "1" ]]; then
  cd ${GITHUB_WORKSPACE}
  git clone -b main https://github.com/${Apidz}.git ${FOLDER_NAME}
  if [[ ! -d "${FOLDER_NAME}/build/${FOLDER_NAME}/relevance" ]]; then
    mkdir -p "${FOLDER_NAME}/build/${FOLDER_NAME}/relevance"
  fi
  rm -rf ${FOLDER_NAME}/build/${FOLDER_NAME}
  cp -Rf build/${FOLDER_NAME} ${FOLDER_NAME}/build/${FOLDER_NAME}
  rm -rf ${FOLDER_NAME}/build/${FOLDER_NAME}/*.sh
  cp -Rf build/${FOLDER_NAME}/${DIY_PART_SH} ${FOLDER_NAME}/build/${FOLDER_NAME}/${DIY_PART_SH}
  
  rm -rf ${FOLDER_NAME}/.github/workflows
  cp -Rf .github/workflows ${FOLDER_NAME}/.github/workflows
  
  if [[ -n "${CPU_SELECTIOY}" ]]; then
    YML_PATH="${FOLDER_NAME}/.github/workflows/compile.yml"
    rm -fr ${FOLDER_NAME}/build/${FOLDER_NAME}/relevance/*.ini
    cpu1="CPU_OPTIMIZATION=.*"
    cpu2="CPU_OPTIMIZATION\\=\\\"${CPU_SELECTIOY}\\\""
    CPU_PASS1="CPU_PASSWORD=.*"
    CPU_PASS2="CPU_PASSWORD\\=\\\"1234567\\\""
    if [[ -n "${cpu1}" ]] && [[ -n "${cpu2}" ]]; then
      sed -i "s?${cpu1}?${cpu2}?g" "${YML_PATH}"
    else
      echo "获取变量失败,请勿胡乱修改compile.yml文件"
      exit 1
    fi
    if [[ -n "${CPU_PASS1}" ]] && [[ -n "${CPU_PASS2}" ]]; then
      sed -i "s?${CPU_PASS1}?${CPU_PASS2}?g" "${YML_PATH}"
    else
      echo "获取变量失败,请勿胡乱修改compile.yml文件"
      exit 1
    fi
  fi
  
  restarts="$(cat "${FOLDER_NAME}/build/${FOLDER_NAME}/relevance/start" |awk '$0=NR" "$0' |awk 'END {print}' |awk '{print $(1)}')"
  if [[ "${restarts}" -lt "3" ]]; then
    echo "${SOURCE}-${REPO_BRANCH}-${CONFIG_FILE}-$(date +%Y年%m月%d号%H时%M分%S秒)" >> ${FOLDER_NAME}/build/${FOLDER_NAME}/relevance/start
  else
    echo "${SOURCE}-${REPO_BRANCH}-${CONFIG_FILE}-$(date +%Y年%m月%d号%H时%M分%S秒)" > ${FOLDER_NAME}/build/${FOLDER_NAME}/relevance/start
  fi
  
  cd ${FOLDER_NAME}
  git add .
  git commit -m "${chonglaixx}-${FOLDER_NAME}-${LUCI_EDITION}-${TARGET_PROFILE}"
  git push --force "https://${REPO_TOKEN}@github.com/${Apidz}" HEAD:main
  exit 1
fi
}
################################################################################################################
# 全部作者源码公共diy.sh文件
################################################################################################################
Diy_all() {

if [[ ${REGULAR_UPDATE} == "true" ]]; then
        git clone https://github.com/waynesg/luci-app-autoupdate feeds/luci/applications/luci-app-autoupdate
	cp -Rf "${PATH1}"/{AutoUpdate.sh,AutoBuild_Tools.sh,replace.sh} package/base-files/files/bin
	sed -i 's/"定时更新"/"更新固件"/g' feeds/luci/applications/luci-app-autoupdate/po/zh-cn/autoupdate.po
	sed -i 's/定时更新 LUCI/固件更新 LUCI/g' feeds/luci/applications/luci-app-autoupdate/po/zh-cn/autoupdate.po
fi
if [[ "${REPO_BRANCH}" == "master" ]]; then
	cp -Rf "${Home}"/build/common/LEDE/files "${Home}"
	cp -Rf "${Home}"/build/common/LEDE/diy/* "${Home}"
	cp -Rf "${Home}"/build/common/LEDE/patches/* "${PATH1}/patches"
elif [[ "${REPO_BRANCH}" == "19.07" ]]; then
	cp -Rf "${Home}"/build/common/LIENOL/files "${Home}"
	cp -Rf "${Home}"/build/common/LIENOL/diy/* "${Home}"
	cp -Rf "${Home}"/build/common/LIENOL/patches/* "${PATH1}/patches"
#elif [[ "${REPO_BRANCH}" == "openwrt-22.03" ]]; then
#	cp -Rf "${Home}"/build/common/OFFICIAL/files "${Home}"
#	cp -Rf "${Home}"/build/common/OFFICIAL/diy/* "${Home}"
#	cp -Rf "${Home}"/build/common/OFFICIAL/patches/* "${PATH1}/patches"

fi
if [ -n "$(ls -A "${PATH1}/diy" 2>/dev/null)" ]; then
	cp -Rf "${PATH1}"/diy/* "${Home}"
fi
if [ -n "$(ls -A "${PATH1}/files" 2>/dev/null)" ]; then
	cp -Rf "${PATH1}/files" "${Home}" && chmod -R +x ${Home}/files
fi
if [ -n "$(ls -A "${PATH1}/patches" 2>/dev/null)" ]; then
	find "${PATH1}/patches" -type f -name '*.patch' -print0 | sort -z | xargs -I % -t -0 -n 1 sh -c "cat '%'  | patch -d './' -p1 --forward --no-backup-if-mismatch"
fi
}

################################################################################################################
# 判断脚本是否缺少主要文件（如果缺少settings.ini设置文件在检测脚本设置就运行错误了）
################################################################################################################
Diy_settings() {
rm -rf ${Home}/build/QUEWENJIANerros
if [ -z "$(ls -A "$PATH1/${CONFIG_FILE}" 2>/dev/null)" ]; then
	echo
	TIME r "错误提示：编译脚本缺少[${CONFIG_FILE}]名称的配置文件,请在[build/${Modelfile}]文件夹内补齐"
	echo "errors" > ${Home}/build/QUEWENJIANerros
	echo
fi
if [ -z "$(ls -A "$PATH1/${DIY_PART_SH}" 2>/dev/null)" ]; then
	echo
	TIME r "错误提示：编译脚本缺少[${DIY_PART_SH}]名称的自定义设置文件,请在[build/${Modelfile}]文件夹内补齐"
	echo "errors" > ${Home}/build/QUEWENJIANerros
	echo
fi
if [ -n "$(ls -A "${Home}/build/QUEWENJIANerros" 2>/dev/null)" ]; then
rm -rf ${Home}/build/QUEWENJIANerros
exit 1
fi
rm -rf {build,README.md}
}


################################################################################################################
# 判断插件冲突
################################################################################################################
Diy_chajian() {
echo
make defconfig > /dev/null 2>&1
echo "TIME b \"					插件冲突信息\"" > ${Home}/CHONGTU

if [[ `grep -c "CONFIG_TARGET_ROOTFS_EXT4FS=y" ${Home}/.config` -eq '1' ]]; then
	if [[ `grep -c "CONFIG_TARGET_ROOTFS_PARTSIZE" ${Home}/.config` -eq '0' ]]; then
		sed -i '/CONFIG_TARGET_ROOTFS_PARTSIZE/d' ${Home}/.config > /dev/null 2>&1
		echo -e "\nCONFIG_TARGET_ROOTFS_PARTSIZE=950" >> ${Home}/.config
	fi
	egrep -o "CONFIG_TARGET_ROOTFS_PARTSIZE=+.*?[0-9]" ${Home}/.config > ${Home}/EXT4PARTSIZE
	sed -i 's|CONFIG_TARGET_ROOTFS_PARTSIZE=||g' ${Home}/EXT4PARTSIZE
	PARTSIZE="$(cat EXT4PARTSIZE)"
	if [[ "${PARTSIZE}" -lt "950" ]];then
		sed -i '/CONFIG_TARGET_ROOTFS_PARTSIZE/d' ${Home}/.config > /dev/null 2>&1
		echo -e "\nCONFIG_TARGET_ROOTFS_PARTSIZE=950" >> ${Home}/.config
		echo "TIME g \" \"" > ${Home}/EXT4
		echo "TIME r \"EXT4提示：请注意，您选择了ext4安装的固件格式,而检测到您的分配的固件系统分区过小\"" >> ${Home}/EXT4
		echo "TIME y \"为避免编译出错,建议修改成950或者以上比较好,已帮您修改成950M\"" >> ${Home}/EXT4
		echo "TIME g \" \"" >> ${Home}/EXT4
	fi
	rm -rf ${Home}/EXT4PARTSIZE
fi
if [ -n "$(ls -A "${Home}/Chajianlibiao" 2>/dev/null)" ]; then
	echo "TIME y \"  插件冲突会导致编译失败，以上操作如非您所需，请关闭此次编译，重新开始编译，避开冲突重新选择插件\"" >>CHONGTU
	echo "TIME z \"\"" >>CHONGTU
else
	rm -rf CHONGTU
fi
}


################################################################################################################
# 为编译做最后处理
################################################################################################################
Diy_chuli() {

sed -i '$ s/exit 0$//' ${Home}/package/base-files/files/etc/rc.local
echo '
if [[ `grep -c "coremark" /etc/crontabs/root` -eq '1' ]]; then
  sed -i '/coremark/d' /etc/crontabs/root
fi
/etc/init.d/network restart
/etc/init.d/uhttpd restart
exit 0
' >> ${Home}/package/base-files/files/etc/rc.local

if [[ "${REPO_BRANCH}" == "19.07" ]]; then
	sed -i 's/PATCHVER:=4.9/PATCHVER:=4.14/g' target/linux/*/Makefile
	sed -i 's/PATCHVER:=4.19/PATCHVER:=4.14/g' target/linux/*/Makefile
fi

if [[ "${TARGET_BOARD}" == "x86" ]]; then
	cp -Rf "${Home}"/build/common/Custom/DRM-I915 target/linux/x86/DRM-I915
	for X in $(ls -1 target/linux/x86 | grep "config-"); do echo -e "\n$(cat target/linux/x86/DRM-I915)" >> target/linux/x86/${X}; done
fi

if [[ `grep -c "CONFIG_PACKAGE_ntfs-3g=y" ${Home}/.config` -eq '1' ]]; then
	mkdir -p files/etc/hotplug.d/block && curl -fsSL  https://raw.githubusercontent.com/281677160/openwrt-package/usb/block/10-mount > files/etc/hotplug.d/block/10-mount
fi


if [[ `grep -c "CONFIG_PACKAGE_luci-app-adguardhome=y" ${Home}/.config` -eq '1' ]]; then
	if [[ `grep -c "CONFIG_ARCH=\"x86_64\"" ${Home}/.config` -eq '1' ]]; then
		Arch="amd64"
	elif [[ `grep -c "CONFIG_ARCH=\"i386\"" ${Home}/.config` -eq '1' ]]; then
		Arch="i386"
	elif [[ `grep -c "CONFIG_ARCH=\"aarch64\"" ${Home}/.config` -eq '1' ]]; then
		Arch="arm64"
	fi
	if [[ `grep -c "CONFIG_ARCH=\"arm\"" ${Home}/.config` -eq '1' ]]; then
		if [[ `grep -c "CONFIG_arm_v7=y" ${Home}/.config` -eq '1' ]]; then
			Arch="armv7"
		fi	
	fi
	if [[ "${Arch}" =~ (amd64|i386|armeb|armv7) ]]; then
		downloader="curl -L -k --retry 2 --connect-timeout 20 -o"
		latest_ver="$($downloader - https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest 2>/dev/null|grep -E 'tag_name' |grep -E 'v[0-9.]+' -o 2>/dev/null)"
		wget -q https://github.com/AdguardTeam/AdGuardHome/releases/download/${latest_ver}/AdGuardHome_linux_${Arch}.tar.gz
		tar -zxvf AdGuardHome_linux_${Arch}.tar.gz -C ${Home} > /dev/null 2>&1
		mkdir -p files/usr/bin
		mv -f AdGuardHome/AdGuardHome files/usr/bin
		chmod 777 files/usr/bin/AdGuardHome
		rm -rf {AdGuardHome_linux_${Arch}.tar.gz,AdGuardHome}
	fi
fi

if [[ "${BY_INFORMATION}" == "true" ]]; then
	grep -i CONFIG_PACKAGE_luci-app .config | grep  -v \# > Plug-in
	grep -i CONFIG_PACKAGE_luci-theme .config | grep  -v \# >> Plug-in
	if [[ `grep -c "CONFIG_PACKAGE_luci-i18n-qbittorrent-zh-cn=y" ${Home}/.config` -eq '0' ]]; then
		if [[ `grep -c "luci-app-qbittorrent_static" ${Home}/Plug-in` -eq '1' ]]; then
			sed -i '/qbittorrent/d' Plug-in
		fi
	fi
	sed -i '/INCLUDE/d' Plug-in > /dev/null 2>&1
	sed -i '/=m/d' Plug-in > /dev/null 2>&1
	sed -i 's/CONFIG_PACKAGE_/、/g' Plug-in
	sed -i 's/=y/\"/g' Plug-in
	awk '$0=NR$0' Plug-in > Plug-2
	awk '{print "	" $0}' Plug-2 > Plug-in
	sed -i "s/^/TIME g \"/g" Plug-in
	cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c > CPU
        cat /proc/cpuinfo | grep "cpu cores" | uniq >> CPU
        sed -i 's|[[:space:]]||g; s|^.||' CPU && sed -i 's|CPU||g; s|pucores:||' CPU
        CPUNAME="$(awk 'NR==1' CPU)" && CPUCORES="$(awk 'NR==2' CPU)"
        rm -rf CPU

	#if [[ `grep -c "KERNEL_PATCHVER:=" ${Home}/target/linux/${TARGET_BOARD}/Makefile` -eq '1' ]]; then
	#	PATCHVER=$(grep KERNEL_PATCHVER:= ${Home}/target/linux/${TARGET_BOARD}/Makefile | cut -c18-100)
	#elif [[ `grep -c "KERNEL_PATCHVER=" ${Home}/target/linux/${TARGET_BOARD}/Makefile` -eq '1' ]]; then
	#	PATCHVER=$(grep KERNEL_PATCHVER= ${Home}/target/linux/${TARGET_BOARD}/Makefile | cut -c17-100)
	#else
		PATCHVER="unknown"
	#fi
	if [[ ! "${PATCHVER}" == "unknown" ]]; then
		PATCHVER=$(egrep -o "${PATCHVER}.[0-9]+" ${Home}/include/kernel-version.mk)
	fi
	
	if [[ "${Modelfile}" == "openwrt_amlogic" ]]; then
		[[ -e $GITHUB_WORKSPACE/amlogic_openwrt ]] && source $GITHUB_WORKSPACE/amlogic_openwrt
		[[ "${amlogic_kernel}" == "5.4.155" ]] && {
			curl -fsSL https://raw.githubusercontent.com/mdtycl/amlogic-s905d/master/.github/workflows/build-openwrt-lede.yml > open.yml
			Make_ker="$(cat open.yml | grep ./make | cut -d "k" -f3 | sed s/[[:space:]]//g)"
			TARGET_kernel="${Make_ker}"
			TARGET_model="${amlogic_model}"
		} || {
			TARGET_kernel="${amlogic_kernel}"
			TARGET_model="${amlogic_model}"
		}
	fi
fi
rm -rf ${Home}/files/{README,README.md}
}


################################################################################################################
# 提示信息
################################################################################################################
GONGGAO() {
[[ -z "$1" ]] && {
	echo -ne " "
} || {
	case $1 in
		r) export Color="\e[31;1m";;
		g) export Color="\e[32m";;
		b) export Color="\e[34m";;
		y) export Color="\e[33m";;
		z) export Color="\e[36m";;
	esac
		echo -e "\n\e[35;1m[$(date "+ 提示信息 ")]\e[0m ${Color}${2}\e[0m"
	}
}

Diy_gonggao() {
GONGGAO y "《Lede_source文件，Luci版本为18.06，内核版本为5.15》"
GONGGAO y "《Lienol_source文件，Luci版本为17.01，内核版本为4.14》"
GONGGAO y "《Mortal_source文件，Luci版本为18.06，内核版本为5.4》"
GONGGAO y "《openwrt_amlogic文件，编译N1盒子专用，Luci版本为18.06，内核版本为5.4》"
echo
}


################################################################################################################
# 编译信息
################################################################################################################
Diy_xinxi() {
if [[ "${TARGET_PROFILE}" =~ (friendlyarm_nanopi-r2s|friendlyarm_nanopi-r4s|armvirt) ]]; then
	REGULAR_UPDATE="false"
fi
export KERNEL_PATCH="$(grep "KERNEL_PATCHVER" "${GITHUB_WORKSPACE}/openwrt/target/linux/${TARGET_BOARD}/Makefile" |grep -Eo "[0-9]+\.[0-9]+")"
export KERNEL_patc="kernel-${KERNEL_PATCH}"
if [[ `ls -1 "${GITHUB_WORKSPACE}/openwrt/include" |grep -c "${KERNEL_patc}"` -eq '1' ]]; then
  export LINUX_KERNEL="$(grep "LINUX_KERNEL_HASH" "${GITHUB_WORKSPACE}/openwrt/include/${KERNEL_patc}" |sed s/[[:space:]]//g |cut -d '-' -f2 |cut -d '=' -f1)"
  [[ -z ${LINUX_KERNEL} ]] && export LINUX_KERNEL="nono"
else
  export LINUX_KERNEL="$(grep "LINUX_KERNEL_HASH" "${GITHUB_WORKSPACE}/openwrt/include/kernel-version.mk" |grep -Eo "${KERNEL_PATCH}\.[0-9]+")"
  [[ -z ${LINUX_KERNEL} ]] && export LINUX_KERNEL="nono"
fi
echo
TIME b "编译源码: ${CODE}"
TIME b "源码链接: ${REPO_URL}"
TIME b "源码分支: ${REPO_BRANCH}"
TIME b "源码作者: ${ZUOZHE}"
TIME b "固件内核: ${LINUX_KERNEL}"
TIME b "Luci版本: ${LUCI_EDITION}"
[[ "${Modelfile}" == "openwrt_amlogic" ]] && {
	TIME b "编译机型: ${TARGET_model}"
	TIME b "打包内核: ${TARGET_kernel}"
} || {
	TIME b "编译机型: ${TARGET_PROFILE}"
}
TIME b "固件作者: ${Author}"
TIME b "仓库地址: ${Github}"
TIME b "启动编号: #${Run_number}（${CangKu}仓库第${Run_number}次启动[${Run_workflow}]工作流程）"
TIME b "编译时间: ${Compte}"
[[ "${Modelfile}" == "openwrt_amlogic" ]] && {
	TIME g "友情提示：您当前使用【${Modelfile}】文件夹编译【${TARGET_model}】固件"
} || {
	TIME g "友情提示：您当前使用【${Modelfile}】文件夹编译【${TARGET_PROFILE}】固件"
}
echo

if [[ ${UPLOAD_FIRMWARE} == "true" ]]; then
	TIME y "上传固件在github actions: 开启"
else
	TIME r "上传固件在github actions: 关闭"
fi
if [[ ${UPLOAD_CONFIG} == "true" ]]; then
	TIME y "上传[.config]配置文件: 开启"
else
	TIME r "上传[.config]配置文件: 关闭"
fi
if [[ ${UPLOAD_BIN_DIR} == "true" ]]; then
	TIME y "上传BIN文件夹(固件+IPK): 开启"
else
	TIME r "上传BIN文件夹(固件+IPK): 关闭"
fi
if [[ ${UPLOAD_COWTRANSFER} == "true" ]]; then
	TIME y "上传固件至【奶牛快传】和【WETRANSFER】: 开启"
else
	TIME r "上传固件至【奶牛快传】和【WETRANSFER】: 关闭"
fi
if [[ ${UPLOAD_RELEASE} == "true" ]]; then
	TIME y "发布固件: 开启"
else
	TIME r "发布固件: 关闭"
fi
if [[ ${SERVERCHAN_SCKEY} == "true" ]]; then
	TIME y "微信/电报通知: 开启"
else
	TIME r "微信/电报通知: 关闭"
fi
if [[ ${SSH_ACTIONS} == "true" ]]; then
	TIME y "SSH远程连接: 开启"
else
	TIME r "SSH远程连接: 关闭"
fi
if [[ ${BY_INFORMATION} == "true" ]]; then
	TIME y "编译信息显示: 开启"
fi
if [[ ${SSHYC} == "true" ]]; then
	TIME y "SSH远程连接临时开关: 开启"
fi
if [[ ${REGULAR_UPDATE} == "true" ]]; then
	TIME y "把定时自动更新插件编译进固件: 开启"
else
	TIME r "把定时自动更新插件编译进固件: 关闭"
fi
if [[ ${REGULAR_UPDATE} == "true" ]]; then
	echo
	TIME l "定时自动更新信息"
	TIME z "插件版本: ${AutoUpdate_Version}"
	if [[ ${TARGET_PROFILE} == "x86-64" ]]; then
		TIME b "传统固件: ${Legacy_Firmware}"
		TIME b "UEFI固件: ${UEFI_Firmware}"
		TIME b "固件后缀: ${Firmware_sfx}"
	else
		TIME b "固件名称: ${Up_Firmware}"
		TIME b "固件后缀: ${Firmware_sfx}"
	fi
	TIME b "固件版本: ${Openwrt_Version}"
	TIME b "云端路径: ${Github_UP_RELEASE}"
	TIME g "《编译成功后，会自动把固件发布到指定地址，然后才会生成云端路径》"
	TIME g "《普通的那个发布固件跟云端的发布路径是两码事，如果你不需要普通发布的可以不用打开发布功能》"	
else
	echo
fi
echo
TIME z " 系统空间      类型   容量  已用  可用 使用率"
cd ../ && df -hT $PWD && cd openwrt
echo
TIME z "  本编译 服务器的 CPU型号为 [ ${CPUNAME} ]"
echo
TIME z "  使用 核心数 为 [ ${CPUCORES} ], 线程数为 [ $(nproc) ]"
echo
TIME z "  随机分配到 E5系列CPU 编译是 最慢的, 8171M 的CPU 快很多，8272CL 的又比 8171M 快些！"
echo
TIME z "  如果编译的插件较多，而又分配到 E5系列 的 CPU，建议关闭 重新再来！"
echo
TIME z "  下面将使用 [ $(nproc) 线程 ] 编译固件"
echo
if [ -n "$(ls -A "${Home}/EXT4" 2>/dev/null)" ]; then
	echo
	echo
	chmod -R +x ${Home}/EXT4
	source ${Home}/EXT4
	rm -rf EXT4
fi
if [ -n "$(ls -A "${Home}/Chajianlibiao" 2>/dev/null)" ]; then
	echo
	echo
	chmod -R +x ${Home}/CHONGTU
	source ${Home}/CHONGTU
	rm -rf {CHONGTU,Chajianlibiao}
	echo
	echo
fi
if [ -n "$(ls -A "${Home}/Plug-in" 2>/dev/null)" ]; then
	TIME r "	      已选插件列表"
	chmod -R +x ${Home}/Plug-in
	source ${Home}/Plug-in
	rm -rf {Plug-in,Plug-2}
	echo
fi
}
