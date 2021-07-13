#!/bin/bash
curl -s https://raw.githubusercontent.com/lmc999/GamePing/main/GameIP.csv > /tmp/GameIP.csv
ip_file='/tmp/GameIP.csv'

Font_Black="\033[30m";
Font_Red="\033[31m";
Font_Green="\033[32m";
Font_Yellow="\033[33m";
Font_Blue="\033[34m";
Font_Purple="\033[35m";
Font_SkyBlue="\033[36m";
Font_White="\033[37m";
Font_Suffix="\033[0m";

local_isp=$(curl -s -4 --max-time 30 https://api.ip.sb/geoip/ | cut -f1 -d"," | cut -f4 -d '"')

function check_os(){

	os_detail=$(cat /etc/os-release)
	if_debian=$(echo $os_detail | grep 'ebian')
	if_redhat=$(echo $os_detail | grep 'rhel')
	os_version=$(grep 'VERSION_ID' /etc/os-release | cut -d '"' -f 2 | tr -d '.')
	if [ -n "$if_debian" ];then
		InstallMethod="apt install"
	elif [ -n "$if_redhat" ];then
		if [[ "$os_version" -gt 7 ]];then
			InstallMethod="dnf install"
		else
			InstallMethod="yum install"
		fi
	fi
}
check_os

function check_dependencies(){	
	
	bc --help > /dev/null 2>&1
		if [[ "$?" -ne "0" ]];then
			echo -e "${Font_Green}正在安装bc...${Font_Suffix}" 
			$InstallMethod bc -y > /dev/null 2>&1
		fi
	fping -h > /dev/null 2>&1
		if [[ "$?" -ne "0" ]];then
			echo -e "${Font_Green}正在安装fping...${Font_Suffix}" 
			$InstallMethod fping -y > /dev/null 2>&1
		fi	
}		
check_dependencies
	

function show_TableHead(){

    echo -n -e "${Font_Yellow}Game\t\tLocation\tLatency\t\tPacket Loss\t\tIDC\t\tServer ID${Font_Suffix}\n"
	echo -e "---------------------------------------------------------------------------------------------------"
}	
show_TableHead

function LOL_Ping(){
	echo -n -e "\t\t\t\t${Font_Red}【League of Legends】${Font_Suffix}\n"
	echo ""
	local Area=$1
	show_TableHead
	if [ -n "$Area" ];then
		cat ${ip_file} | sed "/\<LOL\>/I! d" | sed "/\<$Area\>/I! d" > /tmp/IP_To_Ping.csv
	else
		cat ${ip_file} | sed "/\<LOL\>/I! d" > /tmp/IP_To_Ping.csv
	fi
	local ip_file='/tmp/IP_To_Ping.csv'
	while read -r line || [[ -n $line ]];do
		content=$(echo $line)
		local game=$(echo $content | awk '{print $1}' | cut -f1 -d",")
		local ip=$(echo $content | awk '{print $2}' | cut -f1 -d",")
		local country=$(echo $content | awk '{print $3}' | cut -f1 -d",")
		local idc=$(echo $content | awk '{print $4}' | cut -f1 -d",")
		local area=$(echo $content | awk '{print $5}' | cut -f1 -d",")
		local ServerID=$(echo $content | awk '{print $6}' | cut -f1 -d",")
		#screen -dmS LOL `ping $ip -w 4 -c 4 > /tmp/ping.txt`
		ping $ip -w 4 -c 4 > /tmp/result.txt 2>&1 
		cat /tmp/result.txt | grep '100%' >/dev/null 2>&1
		
		if [[ "$?" -eq "0" ]];then
			ip_prefix=${ip}/24
			newip=$(fping $ip_prefix -ag -r 1 | head -n 1)
			local result=$(ping $newip -w 4 -c 4)
		else
			local result=$(cat /tmp/result.txt)
		fi	
			
		local packetloss=$(echo $result | grep 'packet loss' | sed 's/packet loss.*//' | awk '{print $NF}')	
		local latency=$(echo $result | grep 'avg' | sed 's/.*=//' | cut -f2 -d"/")	
		
		if [ $(echo "$latency < 50" | bc) -eq 1 ];then
			LatencyClor="\033[32m"
		else
			LatencyClor="\033[31m"
		fi	
		
		if [ $(echo "$(echo $packetloss |cut -f1 -d"%") < 5" | bc) -eq 1 ];then
			PacketlossClor="\033[32m"
		else
			PacketlossClor="\033[31m"
		fi
		echo -n -e "${Font_SkyBlue}$game${Font_Suffix}\t\t  ${Font_Purple}$country${Font_Suffix}\t\t${LatencyClor}$latency ms${Font_Suffix}\t    ${PacketlossClor}$packetloss${Font_Suffix}\t\t    ${Font_Blue} $idc${Font_Suffix}\\t\t    ${Font_Red}$ServerID${Font_Suffix}\n"
	done < ${ip_file}	

	echo -e "==================================================================================================="
	echo ""
}

function PUBG_Ping(){
	echo -n -e "\t\t\t\t${Font_Red}【PlayerUnknown's Battlegrounds】${Font_Suffix}\n"
	echo ""
	local Area=$1
	show_TableHead
	if [ -n "$Area" ];then
		cat ${ip_file} | sed "/\<PUBG\>/I! d" | sed "/\<$Area\>/I! d" > /tmp/IP_To_Ping.csv
	else
		cat ${ip_file} | sed "/\<PUBG\>/I! d" > /tmp/IP_To_Ping.csv
	fi
	local ip_file='/tmp/IP_To_Ping.csv'
	while read -r line || [[ -n $line ]];do
		content=$(echo $line)
		local game=$(echo $content | awk '{print $1}' | cut -f1 -d",")
		local ip=$(echo $content | awk '{print $2}' | cut -f1 -d",")
		local country=$(echo $content | awk '{print $3}' | cut -f1 -d",")
		local idc=$(echo $content | awk '{print $4}' | cut -f1 -d",")
		local area=$(echo $content | awk '{print $5}' | cut -f1 -d",")
		local ServerID=$(echo $content | awk '{print $6}' | cut -f1 -d",")
		#screen -dmS LOL `ping $ip -w 4 -c 4 > /tmp/ping.txt`
		ping $ip -w 4 -c 4 > /tmp/result.txt 2>&1 
		cat /tmp/result.txt | grep '100%' >/dev/null 2>&1
		
		if [[ "$?" -eq "0" ]];then
			ip_prefix=${ip}/24
			newip=$(fping $ip_prefix -ag -r 1 | head -n 1)
			local result=$(ping $newip -w 4 -c 4)
		else
			local result=$(cat /tmp/result.txt)
		fi	
			
		local packetloss=$(echo $result | grep 'packet loss' | sed 's/packet loss.*//' | awk '{print $NF}')	
		local latency=$(echo $result | grep 'avg' | sed 's/.*=//' | cut -f2 -d"/")	
		
		if [ $(echo "$latency < 50" | bc) -eq 1 ];then
			LatencyClor="\033[32m"
		else
			LatencyClor="\033[31m"
		fi	
		
		if [ $(echo "$(echo $packetloss |cut -f1 -d"%") < 5" | bc) -eq 1 ];then
			PacketlossClor="\033[32m"
		else
			PacketlossClor="\033[31m"
		fi
		echo -n -e "${Font_SkyBlue}$game${Font_Suffix}\t\t  ${Font_Purple}$country${Font_Suffix}\t\t${LatencyClor}$latency ms${Font_Suffix}\t    ${PacketlossClor}$packetloss${Font_Suffix}\t\t    ${Font_Blue}   $idc${Font_Suffix}\t${Font_Red}     $ServerID${Font_Suffix}\n"
	done < ${ip_file}	

	echo -e "==================================================================================================="
	echo ""
}

function R6S_Ping(){
	echo -n -e "\t\t\t\t${Font_Red}【Tom Clancy's Rainbow Six Siege】${Font_Suffix}\n"
	echo ""
	local Area=$1
	show_TableHead
	if [ -n "$Area" ];then
		cat ${ip_file} | sed "/\<R6S\>/I! d" | sed "/\<$Area\>/I! d" > /tmp/IP_To_Ping.csv
	else
		cat ${ip_file} | sed "/\<R6S\>/I! d" > /tmp/IP_To_Ping.csv
	fi
	
	local ip_file='/tmp/IP_To_Ping.csv'
	while read -r line || [[ -n $line ]];do
		content=$(echo $line)
		local game=$(echo $content | awk '{print $1}' | cut -f1 -d",")
		local ip=$(echo $content | awk '{print $2}' | cut -f1 -d",")
		local country=$(echo $content | awk '{print $3}' | cut -f1 -d",")
		local idc=$(echo $content | awk '{print $4}' | cut -f1 -d",")
		local area=$(echo $content | awk '{print $5}' | cut -f1 -d",")
		local ServerID=$(echo $content | awk '{print $6}' | cut -f1 -d",")
		#screen -dmS LOL `ping $ip -w 4 -c 4 > /tmp/ping.txt`
		ping $ip -w 4 -c 4 > /tmp/result.txt 2>&1 
		cat /tmp/result.txt | grep '100%' >/dev/null 2>&1
		
		if [[ "$?" -eq "0" ]];then
			ip_prefix=${ip}/24
			newip=$(fping $ip_prefix -ag -r 1 | head -n 1)
			local result=$(ping $newip -w 4 -c 4)
		else
			local result=$(cat /tmp/result.txt)
		fi	
			
		local packetloss=$(echo $result | grep 'packet loss' | sed 's/packet loss.*//' | awk '{print $NF}')	
		local latency=$(echo $result | grep 'avg' | sed 's/.*=//' | cut -f2 -d"/")	
		
		if [ $(echo "$latency < 50" | bc) -eq 1 ];then
			LatencyClor="\033[32m"
		else
			LatencyClor="\033[31m"
		fi	
		
		if [ $(echo "$(echo $packetloss |cut -f1 -d"%") < 5" | bc) -eq 1 ];then
			PacketlossClor="\033[32m"
		else
			PacketlossClor="\033[31m"
		fi
		echo -n -e "${Font_SkyBlue}$game${Font_Suffix}\t\t  ${Font_Purple}$country${Font_Suffix}\t\t${LatencyClor}$latency ms${Font_Suffix}\t    ${PacketlossClor}$packetloss${Font_Suffix}\t\t    ${Font_Blue}   $idc${Font_Suffix}\t\t${Font_Red}   $ServerID${Font_Suffix}\n"
	done < ${ip_file}	

	echo -e "==================================================================================================="
	echo ""
}

function ApexLegends_Ping(){
	echo -n -e "\t\t\t\t\t${Font_Red}【Apex Legends】${Font_Suffix}\n"
	echo ""
	local Area=$1
	show_TableHead
	if [ -n "$Area" ];then
		cat ${ip_file} | sed "/\<Apex\>/I! d" | sed "/\<$Area\>/I! d" > /tmp/IP_To_Ping.csv
	else
		cat ${ip_file} | sed "/\<Apex\>/I! d" > /tmp/IP_To_Ping.csv
	fi
	local ip_file='/tmp/IP_To_Ping.csv'
	while read -r line || [[ -n $line ]];do
		content=$(echo $line)
		local game=$(echo $content | awk '{print $1}' | cut -f1 -d",")
		local ip=$(echo $content | awk '{print $2}' | cut -f1 -d",")
		local country=$(echo $content | awk '{print $3}' | cut -f1 -d",")
		local idc=$(echo $content | awk '{print $4}' | cut -f1 -d",")
		local area=$(echo $content | awk '{print $5}' | cut -f1 -d",")
		local ServerID=$(echo $content | awk '{print $6}' | cut -f1 -d",")
		#screen -dmS LOL `ping $ip -w 4 -c 4 > /tmp/ping.txt`
		ping $ip -w 4 -c 4 > /tmp/result.txt 2>&1 
		cat /tmp/result.txt | grep '100%' >/dev/null 2>&1
		
		if [[ "$?" -eq "0" ]];then
			ip_prefix=${ip}/24
			newip=$(fping $ip_prefix -ag -r 1 | head -n 1)
			local result=$(ping $newip -w 4 -c 4)
		else
			local result=$(cat /tmp/result.txt)
		fi	
			
		local packetloss=$(echo $result | grep 'packet loss' | sed 's/packet loss.*//' | awk '{print $NF}')	
		local latency=$(echo $result | grep 'avg' | sed 's/.*=//' | cut -f2 -d"/")	
		
		if [ $(echo "$latency < 50" | bc) -eq 1 ];then
			LatencyClor="\033[32m"
		else
			LatencyClor="\033[31m"
		fi	
		
		if [ $(echo "$(echo $packetloss |cut -f1 -d"%") < 5" | bc) -eq 1 ];then
			PacketlossClor="\033[32m"
		else
			PacketlossClor="\033[31m"
		fi
		echo -n -e "${Font_SkyBlue}$game${Font_Suffix}\t\t  ${Font_Purple}$country${Font_Suffix}\t\t${LatencyClor}$latency ms${Font_Suffix}\t    ${PacketlossClor}$packetloss${Font_Suffix}\t\t    ${Font_Blue}   $idc${Font_Suffix}\\t\t    ${Font_Red} $ServerID${Font_Suffix}\n"
	done < ${ip_file}	

	echo -e "==================================================================================================="
	echo ""
}


function GamePing(){
LOL_Ping ${1}
PUBG_Ping ${1}
R6S_Ping ${1}
ApexLegends_Ping ${1}
}

function Goodbye(){
echo -e "${Font_Green}本次测试已结束，感谢使用此脚本 ${Font_Suffix}"
echo -e "${Font_Red}测试使用ICMP Ping，结果仅供参考 ${Font_Suffix}"
}

clear;

function ScriptTitle(){
echo -e "联机游戏区域延迟测试";
echo ""
echo -e "${Font_Green}项目地址${Font_Suffix} ${Font_Yellow}https://github.com/lmc999/GamePing ${Font_Suffix}";
echo -e "${Font_Green}BUG反馈或使用交流可加TG群组${Font_Suffix} ${Font_Yellow}https://t.me/gameaccelerate ${Font_Suffix}";
echo ""
echo -e " ** 测试时间: $(date)";
echo ""
echo -e " ${Font_SkyBlue}** 您的网络为: ${local_isp}${Font_Suffix} "
echo ""

}
ScriptTitle

function Start(){
echo -e "${Font_Red}请选择需要检测的区域，直接按回车进行全区域检测${Font_Suffix}"
echo -e "${Font_SkyBlue}输入数字【1】：【亚服延迟检测】检测${Font_Suffix}"
echo -e "${Font_SkyBlue}输入数字【2】：【美服延迟检测】检测${Font_Suffix}"
echo -e "${Font_SkyBlue}输入数字【3】：【欧服延迟检测】检测${Font_Suffix}"
echo -e "${Font_SkyBlue}输入数字【4】：【澳服延迟检测】检测${Font_Suffix}"
echo -e "${Font_SkyBlue}输入数字【5】：【南美延迟检测】检测${Font_Suffix}"
read -p "请输入正确数字或直接按回车:" num
}
Start

function RunScript(){
	if [[ -n "${num}" ]]; then
		if [[ "$num" -eq 1 ]]; then
			clear
			ScriptTitle
			GamePing ASIA
			Goodbye
			
		elif [[ "$num" -eq 2 ]]; then
			clear
			ScriptTitle
			GamePing AMERICAS
			Goodbye
			
		elif [[ "$num" -eq 3 ]]; then
			clear
			ScriptTitle
			GamePing EUROPE
			Goodbye
			
		elif [[ "$num" -eq 4 ]]; then
			clear
			ScriptTitle
			GamePing OCEANIA
			Goodbye
			
		elif [[ "$num" -eq 5 ]]; then
			clear
			ScriptTitle
			GamePing LATINAMERICA
			Goodbye
		else
			echo -e "${Font_Red}请重新执行脚本并输入正确号码${Font_Suffix}"
			return
		fi	
	else
		clear
		ScriptTitle
		GamePing
		Goodbye
	fi
}	
RunScript
