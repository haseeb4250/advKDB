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

startTP()
{
printf "********************************** \n"
printf "Checking Tickerplant \n"
if [[ -z $(ps -ef | grep tick.q | grep -v grep | grep -v rlwrap) ]]
	then
        	printf "Starting Tickerplant \n"
            cd $SCRIPTS_DIR
            ($q tick.q sym $TPLOG_DIR -p $TP_PORT -t 1000 > /dev/null 2>&1 &)
	else
        	printf "Tickerplant already running at: \n"
            printf "$(ps -ef | grep tick.q | grep -v grep | grep -v rlwrap) \n"
    fi
sleep 2
}

startRDB1()
{
printf "********************************** \n"
printf "Checking RDB1 \n"
if [[ -z $(ps -ef | grep r.q | grep $RDB1_PORT | grep -v grep | grep -v rlwrap) ]]
	then
            printf "Starting RDB1 \n"
            cd $SCRIPTS_DIR
            #($q tick/r.q localhost:5010 localhost:5012 -tab "trade,quote" -p 5011 > /dev/null 2>&1 &)
        	($q tick/r.q localhost:$TP_PORT localhost:$HDB_PORT -tab "trade,quote" -p $RDB1_PORT > /dev/null 2>&1 &)
	else
        	printf "RDB1 already running at: \n"
            printf "$(ps -ef | grep r.q | grep $RDB1_PORT | grep -v grep | grep -v rlwrap) \n"
    fi
sleep 2
}

startRDB2()
{
printf "********************************** \n"
printf "Checking RDB2 \n"
if [[ -z $(ps -ef | grep r.q | grep $RDB2_PORT | grep -v grep | grep -v rlwrap) ]]
	then
            printf "Starting RDB2 \n"
            cd $SCRIPTS_DIR
            #($q tick/r.q localhost:5010 localhost:5012 -tab "trade,quote" -p 5011 > /dev/null 2>&1 &)
        	($q tick/r.q localhost:$TP_PORT localhost:$HDB_PORT -tab "agrTab" -p $RDB2_PORT > /dev/null 2>&1 &)
	else
        	printf "RDB2 already running at: \n"
            printf "$(ps -ef | grep r.q | grep $RDB2_PORT | grep -v grep | grep -v rlwrap) \n"
    fi
sleep 2
}

startFH()
{
printf "********************************** \n"
printf "Checking Feedhanlder \n"
if [[ -z $(ps -ef | grep feed.q | grep -v grep | grep -v rlwrap) ]]
	then
        	printf "Starting Feedhanlder \n"
            cd $SCRIPTS_DIR
        	($q feed.q -p $FH_PORT > /dev/null 2>&1 &)
	else
        	printf "Feedhandlder running at: \n"
            printf "$(ps -ef | grep feed.q | grep -v grep | grep -v rlwrap) \n"
    fi
sleep 2
}

startCEP()
{
printf "********************************** \n"
printf "Checking Complex Event Processor \n"
if [[ -z $(ps -ef | grep cep.q | grep -v grep | grep -v rlwrap) ]]
	then
        	printf "Starting CEP \n"
            cd $SCRIPTS_DIR
            ($q tick/cep.q localhost:$TP_PORT localhost:$HDB_PORT -tab "trade,quote" -p $CEP_PORT > /dev/null 2>&1 &)
	else
        	printf "CEP running at: \n"
            printf "$(ps -ef | grep cep.q | grep -v grep | grep -v rlwrap) \n"
    fi
sleep 2
}

startHDB()
{
printf "********************************** \n"
printf "Checking HDB \n"
if [[ -z $(ps -ef | grep hdb.q | grep -v grep | grep -v rlwrap) ]]
	then
        	printf "Starting HDB \n"
            cd $SCRIPTS_DIR
            ($q tick/hdb.q -p $HDB_PORT > /dev/null 2>&1 &)
	else
        	printf "HDB running at: \n"
            printf "$(ps -ef | grep hdb.q | grep -v grep | grep -v rlwrap) \n"
    fi
sleep 2
}

if [ "$1" = "ALL" ]
then 
    startTP
    startRDB1
    startRDB2
    startFH
    startCEP
    startHDB
elif [ "$1" = "TP" ]
then
    startTP
elif [ "$1" = "RDB1" ]
then
    startRDB1
elif [ "$1" = "RDB2" ]
then
    startRDB2
elif [ "$1" = "FH" ]
then
    startFH
elif [ "$1" = "CEP" ]
then
    startCEP
elif [ "$1" = "HDB" ]
then
    startHDB
fi 

printf "********************************** \n"
printf "================================= \n"
printf "              EXIT \n"
printf "================================= \n"