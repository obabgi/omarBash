#!/bin/bash

#Security measure to see if you are a root
root_check(){

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "you loged in as $USER, you need to be a root to proceed"
    exit
fi

}


#error_check() {
#  if [ $1 -gt 0 ];then
#    echo -e "ERROR: $1 with $2"
#  fi
#}






# This script Count the number of lines in a list of files
count_lines () {
  f=$1  
  # this is the return value.
  l=`wc -l $f | sed 's/^\([0-9]*\).*$/\1/'`

  logger -i 'count_line log :) '
}

count_line(){
	echo "counts the lines of code in this file $0 " 
	l=0
	n=0
	s=0
	while [ "$*" != ""  ];do
        	count_lines $1
        	echo "$1: $l"
        	n=$[ $n + 1 ]
        	s=$[ $s + $l ]
		shift
	done

	echo "$n file(s) in total, with $s lines in total"

}

#check if file(s) exist
checkFile(){
	#if the number of the argument less than 1 send it to logfile

	if [ $# -lt 1 ]
		then
  		echo "you need to insert an argument.. Ex: file.txt"
  		echo "Usage: $0 logfile" >&2
  		exit 1
  	fi
  	for index in $*; do
  		if [[ ! -f $index ]]; then
  			echo "****************************"
  			echo -e "\nERROR: $index does not exist\n"
  			echo "****************************"
  			exit 1
  		fi
  	done
}

#just printing OS information
getOSInfo(){
	lsb_release -a | tail -n 4
}

main(){
	echo -e "\nWELCOME to my first scripting language. This scripts takes files as an argument and prints how many lines are there. Also provide the user othr useful information "
	echo "============================"
	root_check $@

   	echo "you logged in as root"
	echo "============================"

	checkFile $@

	getOSInfo
	echo "============================"

	count_line $@
	#here just asking the user if they want to check thier ip address
	q=true
	
	while $q; do
	read -p "Do you want to see your ip address? Enter yes or no  " yn
    	
	case $yn in
       
	[yes]* ) ifconfig | awk '/inet addr/{print substr($2,6)}' ; q=false;;
        [no]* ) q=false;;
        * ) echo "Please answer yes or no.";;
    	esac
	
	done

	echo "============================"

	logger -i 'the address log :) '
	
	echo -e "\nHere are log file details\n"	
	tail /var/log/messages
}

main $@
