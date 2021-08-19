
#!/bin/bash

# Defining the Default Values 
clear
TRY_INTERVAL_DEFAULT=5
TRY_NUMBER_DEFAULT=12
TRY_COMMAND_DEFAULT=NULL

#Checking whether the first entered value is empty or not
while [ -n "$1" ]
do 
	case "$1" in
		#if the first entered value is -i so the next item is interval
		#then checking whether the entered value is an integer or not
		-i) interval="$2"
			echo  "You Have Entered -i Switch With The $interval Value"
		       	if ! [[ "$2" =~ ^[0-9]+$ ]];then
				echo "$2 Is Not a Valid Input,Exiting..."
				exit 1
			fi
			#SHIFT is a bash built-in which kind of removes arguments from the beginning of the argument list. Given that the 3 arguments provided to the script are available in $1, $2, $3, then a call to shift will make $2 the new $1. A shift 2 will shift by two making new $1 the old $3			
			shift;;
		-n) number="$2"
			echo "You Have Entered -n Switch With The $number Value"
			if ! [[ "$2" =~ ^[0-9]+$ ]];then
				echo "$2 Is Not a Valid Input,Exiting..."
				exit 1
			fi
			shift ;;
		*) echo "The Command To be Executed is: $*"
			cmd=$*
			break ;;
	esac
	shift
done
#${VAR:-WORD} If VAR is not defined or null, the expansion of WORD is substituted; otherwise the value of VAR is substituted
echo "Interval Is: ${interval:-$TRY_INTERVAL_DEFAULT} "
echo ""
echo "Number of Try Is: ${number:-$TRY_NUMBER_DEFAULT} "
echo ""
echo "And The Entered Command is: ${cmd:-$TRY_COMMAND_DEFAULT}"
#executing the command
($cmd) 2>/dev/null
#saving the exit status of the command to use in furthur conditions
exitcode=$?
#if the exit status is equal to zero then it means the command has successfully executed
if [ $exitcode -eq 0 ]; then
        echo " $cmd executed Successfully"
        exit 0
        else
		#if the exit status is not 0 it means it has to be executed for the defined number in NUMBER variable
		while [ $exitcode -ne 0  ]; do
                        echo "Round $number: Watiing for $interval seconds , Executing The: $cmd  Command or Program"
                        sleep $interval
                        number=$[ $number - 1 ]
                        ($cmd) 2>/dev/null
                        exitcode=$?
                        if [ $number -eq 0 ]; then
                                echo " Failure on executing the $cmd ..."
                                exit 1
                        fi
                        if [ $exitcode -eq 0 ]; then
                                echo " $cmd executed Successfully..."
                                exit 0
                        fi
                done
fi
