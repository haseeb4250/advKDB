#!/bin/bash
printf "================================= \n"
printf "          START SCRIPT \n"
printf "================================= \n"
printf "Loading config \n"
source instance.config

printf "********************************** \n"
printf "Define q source \n"
export q=$(find ~ -name q | grep l32)
	if [[ ! -z "$q" ]]
	then
        printf "Found q executable $q \n"
	else
		printf "q not found \n"
	fi

shutTP()
{
printf "********************************** \n"
printf "Checking Tickerplant \n"
if [[ -z $(ps -ef | grep tick.q | grep -v grep | grep -v rlwrap) ]]
	then
        	printf "Tickerplant not running \n"
	else
        	printf "Tickerplant running at: \n"
            printf "$(ps -ef | grep tick.q | grep -v grep | grep -v rlwrap) \n"
            printf "Tickerplant shutting down \n"
            kill $(ps -ef | grep tick.q | grep -v grep | grep -v rlwrap | awk '{print $2}')
    fi
sleep 2
}

shutRDB1()
{
printf "********************************** \n"
printf "Checking RDB1 \n"
if [[ -z $(ps -ef | grep r.q | grep $RDB1_PORT | grep -v grep | grep -v rlwrap) ]]
	then
            printf "RDB1 not running \n"
   	else
        	printf "RDB1 running at: \n"
            printf "$(ps -ef | grep r.q | grep $RDB1_PORT | grep -v grep | grep -v rlwrap) \n"
            printf "RDB1 shutting down \n"
            kill $(ps -ef | grep r.q | grep $RDB1_PORT | grep -v grep | grep -v rlwrap| awk '{print $2}')
    fi
sleep 2
}

shutRDB2()
{
printf "********************************** \n"
printf "Checking RDB2 \n"
if [[ -z $(ps -ef | grep r.q | grep $RDB2_PORT | grep -v grep | grep -v rlwrap) ]]
	then
            printf "RDB2 not running \n"
	else
        	printf "RDB2 running at: \n"
            printf "$(ps -ef | grep r.q | grep $RDB2_PORT | grep -v grep | grep -v rlwrap) \n"
            printf "RDB2 shutting down \n"
            kill $(ps -ef | grep r.q | grep $RDB2_PORT | grep -v grep | grep -v rlwrap| awk '{print $2}')
    fi
sleep 2
}

shutFH()
{
printf "********************************** \n"
printf "Checking Feedhanlder \n"
if [[ -z $(ps -ef | grep feed.q | grep -v grep | grep -v rlwrap) ]]
	then
        	printf "Feedhanlder not running \n"
	else
        	printf "Feedhandlder running at: \n"
            printf "$(ps -ef | grep feed.q | grep -v grep | grep -v rlwrap) \n"
            printf "Feedhandlder shutting down \n"
            kill $(ps -ef | grep feed.q | grep -v grep | grep -v rlwrap| awk '{print $2}')
    fi
sleep 2
}

shutCEP()
{
printf "********************************** \n"
printf "Checking Complex Event Processor \n"
if [[ -z $(ps -ef | grep cep.q | grep -v grep | grep -v rlwrap) ]]
	then
        	printf "CEP not running \n"
	else
        	printf "CEP running at: \n"
            printf "$(ps -ef | grep cep.q | grep -v grep | grep -v rlwrap) \n"
            printf "CEP shutting down \n"
            kill $(ps -ef | grep cep.q | grep -v grep | grep -v rlwrap| awk '{print $2}')
    fi
}

shutHDB()
{
printf "********************************** \n"
printf "Checking HDB \n"
if [[ -z $(ps -ef | grep hdb.q | grep -v grep | grep -v rlwrap) ]]
	then
        	printf "HDB not running \n"
	else
        	printf "HDB running at: \n"
            printf "$(ps -ef | grep hdb.q | grep -v grep | grep -v rlwrap) \n"
            printf "HDB shutting down \n"
            kill $(ps -ef | grep hdb.q | grep -v grep | grep -v rlwrap| awk '{print $2}')
    fi
}

if [ "$1" = "ALL" ]
then 
    shutTP
    shutRDB1
    shutRDB2
    shutFH
    shutCEP
    shutHDB
elif [ "$1" = "TP" ]
then
    shutTP
elif [ "$1" = "RDB1" ]
then
    shutRDB1
elif [ "$1" = "RDB2" ]
then
    shutRDB2
elif [ "$1" = "FH" ]
then
    shutFH
elif [ "$1" = "CEP" ]
then
    shutCEP
elif [ "$1" = "HDB" ]
then
    shutHDB
fi 

printf "********************************** \n"
printf "================================= \n"
printf "              EXIT \n"
printf "================================= \n"