#!/bin/bash
printf "================================= \n"
printf "        STARTING TEST \n"
printf "================================= \n"
printf "Checking Tickerplant \n"
if [[ -z $(ps -ef | grep tick.q | grep -v grep | grep -v rlwrap) ]]
	then
        	printf "Tickerplant not running \n"
	else
        	printf "Tickerplant running at: \n"
            printf "$(ps -ef | grep tick.q | grep -v grep | grep -v rlwrap) \n"
    fi
printf "********************************** \n"
printf "Checking RDB1 \n"
if [[ -z $(ps -ef | grep r.q | grep 5011 | grep -v grep | grep -v rlwrap) ]]
	then
        	printf "RDB1 not running \n"
	else
        	printf "RDB1 running at: \n"
            printf "$(ps -ef | grep r.q | grep 5011 | grep -v grep | grep -v rlwrap) \n"
    fi
printf "********************************** \n"
printf "Checking RDB2 \n"
if [[ -z $(ps -ef | grep r.q | grep 5013 | grep -v grep | grep -v rlwrap) ]]
	then
        	printf "RDB2 not running \n"
	else
        	printf "RDB2 running at: \n"
            printf "$(ps -ef | grep r.q | grep 5013 | grep -v grep | grep -v rlwrap) \n"
    fi
printf "********************************** \n"
printf "Checking Feedhanlder \n"
if [[ -z $(ps -ef | grep feed.q | grep -v grep | grep -v rlwrap) ]]
	then
        	printf "Feedhandler not running \n"
	else
        	printf "Feedhandlder running at: \n"
            printf "$(ps -ef | grep feed.q | grep -v grep | grep -v rlwrap) \n"
    fi
printf "********************************** \n"
printf "Checking Complex Event Processor \n"
if [[ -z $(ps -ef | grep cep.q | grep -v grep | grep -v rlwrap) ]]
	then
        	printf "CEP not running \n"
	else
        	printf "CEP running at: \n"
            printf "$(ps -ef | grep cep.q | grep -v grep | grep -v rlwrap) \n"
    fi
printf "********************************** \n"
printf "================================= \n"
printf "           END TEST \n"
printf "================================= \n"