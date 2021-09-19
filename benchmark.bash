#!/bin/bash

echo starting four sorts in python | tee -a result.txt

time python3 assign2-DewsDavid31.py | tee -a result.txt

echo starting four sorts in swift | tee -a result.txt

swiftc assign2-DewsDavid31.swift | tee -a result.txt

time ./assign2-DewsDavid31 | tee -a result.txt 

