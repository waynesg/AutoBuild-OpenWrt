#!/bin/bash
#
# DO NOT EDIT THIS FILE but add config options to /etc/default/motd
# any changes will be lost on board support package update
#
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

THIS_SCRIPT="sysinfo"
MOTD_DISABLE=""

SHOW_IP_PATTERN="^[ewr].*|^br.*|^lt.*|^umts.*"

DATA_STORAGE=/userdisk/data
MEDIA_STORAGE=/userdisk/snail


[[ -f /etc/default/motd ]] && . /etc/default/motd
for f in $MOTD_DISABLE; do
	[[ $f == $THIS_SCRIPT ]] && exit 0
done


# don't edit below here
function display()
{
	# $1=name $2=value $3=red_limit $4=minimal_show_limit $5=unit $6=after $7=acs/desc{
	# battery red color is opposite, lower number
	if [[ "$1" == "Battery" ]]; then
		local great="<";
	else
		local great=">";
	fi
	if [[ -n "$2" && "$2" > "0" && (( "${2%.*}" -ge "$4" )) ]]; then
		printf "%-14s%s" "$1:"
		if awk "BEGIN{exit ! ($2 $great $3)}"; then
			echo -ne "\e[0;91m $2";
		else
			echo -ne "\e[0;92m $2";
		fi
		printf "%-1s%s\x1B[0m" "$5"
		printf "%-11s%s\t" "$6"
		return 1
	fi
} # display


function get_ip_addresses()
{
	local ips=()
	for f in /sys/class/net/*; do
		local intf=$(basename $f)
		# match only interface names starting with e (Ethernet), br (bridge), w (wireless), r (some Ralink drivers use ra<number> format)
		if [[ $intf =~ $SHOW_IP_PATTERN ]]; then
			local tmp=$(ip -4 addr show dev $intf | awk '/inet/ {print $2}' | cut -d'/' -f1)
			# add both name and IP - can be informative but becomes ugly with long persistent/predictable device names
			#[[ -n $tmp ]] && ips+=("$intf: $tmp")
			# add IP only
			[[ -n $tmp ]] && ips+=("$tmp")
		fi
	done
	echo "${ips[@]}"
} # get_ip_addresses


function storage_info()
{
	# storage info
	RootInfo=$(df -h /)
	root_usage=$(awk '/\// {print $(NF-1)}' <<<${RootInfo} | sed 's/%//g')
	root_total=$(awk '/\// {print $(NF-4)}' <<<${RootInfo})

	# storage info
	BootInfo=$(df -h /boot)
	boot_usage=$(awk '/\// {print $(NF-1)}' <<<${BootInfo} | sed 's/%//g')
	boot_total=$(awk '/\// {print $(NF-4)}' <<<${BootInfo})
	
	StorageInfo=$(df -h $MEDIA_STORAGE 2>/dev/null | grep $MEDIA_STORAGE)
	if [[ -n "${StorageInfo}" && ${RootInfo} != *$MEDIA_STORAGE* ]]; then
		media_usage=$(awk '/\// {print $(NF-1)}' <<<${StorageInfo} | sed 's/%//g')
		media_total=$(awk '/\// {print $(NF-4)}' <<<${StorageInfo})
	fi

	StorageInfo=$(df -h $DATA_STORAGE 2>/dev/null | grep $DATA_STORAGE)
	if [[ -n "${StorageInfo}" && ${RootInfo} != *$DATA_STORAGE* ]]; then
		data_usage=$(awk '/\// {print $(NF-1)}' <<<${StorageInfo} | sed 's/%//g')
		data_total=$(awk '/\// {print $(NF-4)}' <<<${StorageInfo})
	fi
} # storage_info

function get_data_storage()
{
    if which lsblk >/dev/null;then
	root_name=$(lsblk -l -o NAME,MOUNTPOINT | awk '$2~/^\/$/ {print $1'})
	mmc_name=$(echo $root_name | awk '{print substr($1,1,length($1)-2);}')
	if echo $mmc_name | grep mmcblk >/dev/null;then
	    DATA_STORAGE="/mnt/${mmc_name}p4"
	fi
    fi
}


# query various systems and send some stuff to the background for overall faster execution.
# Works only with ambienttemp and batteryinfo since A20 is slow enough :)
ip_address=$(get_ip_addresses &)
storage_info
critical_load=$(( 1 + $(grep -c processor /proc/cpuinfo) / 2 ))

# get uptime, logged in users and load in one take
UptimeString=$(uptime | tr -d ',')
time=$(awk -F" " '{print $3" "$4}' <<<"${UptimeString}")
load="$(awk -F"average: " '{print $2}'<<<"${UptimeString}")"
case ${time} in
	1:*) # 1-2 hours
		time=$(awk -F" " '{print $3" 小时"}' <<<"${UptimeString}")
		;;
	*:*) # 2-24 hours
		time=$(awk -F" " '{print $3" 小时"}' <<<"${UptimeString}")
		;;
	*day) # days
		days=$(awk -F" " '{print $3"天"}' <<<"${UptimeString}")
		time=$(awk -F" " '{print $5}' <<<"${UptimeString}")
		time="$days "$(awk -F":" '{print $1"小时 "$2"分钟"}' <<<"${time}")
		;;
esac


# memory and swap
mem_info=$(LC_ALL=C free -w 2>/dev/null | grep "^Mem" || LC_ALL=C free | grep "^Mem")
memory_usage=$(awk '{printf("%.0f",(($2-($4+$6))/$2) * 100)}' <<<${mem_info})
memory_total=$(awk '{printf("%d",$2/1024)}' <<<${mem_info})
swap_info=$(LC_ALL=C free -m | grep "^Swap")
swap_usage=$( (awk '/Swap/ { printf("%3.0f", $3/$2*100) }' <<<${swap_info} 2>/dev/null || echo 0) | tr -c -d '[:digit:]')
swap_total=$(awk '{print $(2)}' <<<${swap_info})

#cpuinfo
cpuinfo_raw=$(ubus call luci getCPUInfo 2>/dev/null | jsonfilter -e '@.cpuinfo')
# 去掉括号内的内容，比如 "(1800.008MHz, 45.0°C)"
cpuinfo_no_paren=$(echo "$cpuinfo_raw" | sed -E 's/ *\([^)]*\)//g')
# 去掉类似 "x 2C 2T" 这种核心线程信息
cpu_model=$(echo "$cpuinfo_no_paren" | sed -E 's/ x [0-9]+C [0-9]+T//g')
# 获取物理核心数（不重复 core id）
core_count=$(grep '^core id' /proc/cpuinfo 2>/dev/null | sort -u | wc -l)
[ "$core_count" -eq 0 ] && core_count=$(grep -c '^processor' /proc/cpuinfo)

# chassis vendor
bios_vendor=`cat /sys/class/dmi/id/bios_vendor`
product_version=`cat /sys/class/dmi/id/product_version`

# display info
printf "设备信息： 软路由迷你电脑工控机"
echo ""

printf "制 造 商:  \x1B[94m%s\x1B[0m" "$bios_vendor $product_version"
echo ""

printf "内核版本:  \x1B[33m%s\x1B[39m" "$(uname -rs)" 
echo ""

printf "处 理 器:  \x1B[91m%s 核心x%d\x1B[0m\n" "$cpu_model" "$core_count"

cpu_extra=$(echo "$cpuinfo_raw" | sed -nE 's/.*\(([^)]*)\).*/\1/p')
printf "CPU 信息:  \x1B[92m%s\x1B[0m\n" "$cpu_extra"

display "系统负载" "${load%% *}" "${critical_load}" "0" "" "${load#* }"
printf "运行时间:  \x1B[92m%s\x1B[0m\t\t" "$time"
echo "" # fixed newline

display "内存已用" "$memory_usage" "70" "0" "%" " of ${memory_total}MB"
display "交换内存" "$swap_usage" "10" "0" "%" " of $swap_total""Mb"
printf "IP  地址:  \x1B[92m%s\x1B[0m" "$ip_address"
echo "" # fixed newline

display "启动存储" "$boot_usage" "90" "1" "%" " of $boot_total"
display "系统存储" "$root_usage" "90" "1" "%" " of $root_total"
echo ""


echo ""
