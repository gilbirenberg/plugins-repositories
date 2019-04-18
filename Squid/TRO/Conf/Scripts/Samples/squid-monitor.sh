#!/bin/bash -f

# expected command line:
# squid-monitor.sh <command> -p <port number, default is 3128> -l <SQUID install location>

PORT=3128
COMMAND=resources
moType=SquidResources
SQUID_HOME=/usr/squid

while [[ $# -gt 0 ]]
do
	case $1 in
		-p)
			PORT=$2
			shift
			shift
			;;
		-l)
			SQUID_HOME=$2
			shift
			shift
			;;
		resources)
			COMMAND=resources
			moType=SquidResources
			shift
			;;
		server)
			COMMAND=$1
			moType=SquidServer
			shift
			;;
		client)
			COMMAND=$1
			moType=SquidClient
			shift
			;;
		icp)
			COMMAND=$1
			moType=SquidICP
			shift
			;;
		Syscalls)
			COMMAND=$1
			moType=SquidSysCalls
			shift
			;;
			
		*)
			COMMAND=$1
			moType=Squid$1
			shift
			;;
	esac
done

#echo SQUID_HOME=$SQUID_HOME
#echo PORT=$PORT
#echo COMMAND=$COMMAND

CLIENT=$SQUID_HOME/bin/squidclient
if [ ! -f "$CLIENT" ]; then
	echo -e "Invalid value provided for <SQUID install location>" 1>&2
	exit 1
fi

function processAttribute()
{
	#echo -e "processAttribute() receiving arg:$1, with command:$COMMAND"
	isNotResourceArg=$(echo $1 |grep -c "server\|client\|icp\|syscalls")
	if [ "$isNotResourceArg" = "1" ] && [[ "$1" == "$COMMAND"* ]]; then
		takeParam=true
	elif [ "$isNotResourceArg" = "0" ]; then
		takeParam=true
	else
		takeParam=false
	fi

	if [ "$takeParam" = "true" ]; then
		if [ "$1" = "sample_start_time" ] || [ "$1" = "sample_end_time" ]; then
			#echo -e "processAttribute(): $2 is not numeric"
			continue
		elif [ $# -eq 2 ]; then
			outString+=$(printf ",%s=%f" $1 $3)
		else
			if [[ "$3" == "/"* ]]; then
				outString+=$(printf ",%s_per_%s=%f" $1 ${3//\/} $2)
			elif [ "$3" = "%" ]; then
				outString+=$(printf ",%s_Pct=%f" $1 $2)
			else
				outString+=$(printf ",%s_%s=%f" $1 $3 $2)
			fi
		fi
	fi
}

useText="0"
outString="$moType=squid-$PORT"
for line in $($CLIENT -p $PORT -h localhost cache_object://localhost/ mgr:utilization | tr -s ' ' '~')
do
	cleanLine=$(echo $line | sed -e 's/~/ /g' -e 's/[\n\t\r=]//g' -e 's/\// \//' -e 's/\%/ \%/')
	if [[ "$cleanLine" == "Last "* ]]; then
		if [ "$useText" = "1" ]; then
			break
		else
			useText="0"
		fi
	fi
	if [ "$cleanLine" = "Last 5 minutes:" ]; then
		useText="1"
	elif [ "$useText" = "1" ]; then
		processAttribute $cleanLine
	fi
done

echo $outString
