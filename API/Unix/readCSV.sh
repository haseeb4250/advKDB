#!/bin/bash
gcc -DKXVER=3 -o test test.c c.o -lpthread
./test
