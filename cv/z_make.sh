#!/bin/bash
# z_make.sh
# 2016-09-08 david.montaner@gmail.com
# compile my latex cv

## clear files
rm logs/*
rm *.aux
rm *.log
rm *.out
rm *.pdf

## compile
xelatex david_montaner_cv.tex

## keep logs
mkdir logs
mv *.aux logs/
mv *.log logs/
mv *.out logs/
