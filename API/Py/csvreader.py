#!/usr/bin/env python
#api python script
import sys
import csv
import os.path
import pyQ


def print_lines():
    print("+-------------------+")


def print_double():
    print("=====================")


def print_info(x):
    print("INFO: {}".format(x))


def err(x):
    print("ERROR: {}".format(x))


def validate_arg(x):
    chk = x[-3:]
    if chk == "csv":
        info("Input file is a valid csv, proceeding to ingest csv")
    else:
        err("Input file is not a valid csv")
        exit(1)


def open_csv(handle, x):
    i = 0
    if os.path.isfile(x):
        with open(x, "rb") as csvfile:
            csv_reader = csv.reader(csvfile, delimiter=",")
            csv_file = x.split("/")[-1]
            if csv_file == "csvTrade.csv":
                print("Pushing Trade Data")
                for row in csv_reader:
                    if i > 0:
                        handle.castTime(row[0])
                        row[2] = int(row[2])
                        row[3] = float(row[3])
                        handle.sendTradeMsg(handle.kdbTime,row[1],row[2],row[3])
                    i += 1
            elif csv_file == "csvQuote.csv":
                print("Pushing Quote Data")
                for row in csv_reader:
                    if i > 0:
                        handle.castTime(row[0])
                        row[2]=int(row[2])
                        row[3]=float(row[3])
                        row[4]=int(row[4])
                        row[5]=float(row[5])
                        handle.sendQuoteMsg(handle.kdbTime,row[1],row[2],row[3],row[4],row[5])
                    i += 1
    else:
        err("Input file cannot be found")
        exit(1)

######################
# start of script
######################


printDouble()
print("Initialisation of Python Api script")
print("---Based off c api wrapped in python---")
printDouble()
print("List of CSV\n {}/advKDB/csvFiles/csvTrade.csv\n {}/advKDB/csvFiles/"
      "csvQuote.csv".format(os.getenv("HOME"), os.getenv("HOME")))
csvFile = raw_input('Enter CSV Path: ')
validateArg(csvFile)
printLines()
# need to obtain host and port env
info("Attempt to open handle to port {} on hostname {}".format(os.getenv(
    "TICK_PORT"), "localhost"))
try:
    h = pyQ.kdbQ("localhost", int(os.getenv("TICK_PORT")))
    info("Handle opened with q-python instance {}".format(h))
except Exception as e:
    err("Unable to connect to q process " + str(e))
    exit(1)
openCSV(h, csvFile)
