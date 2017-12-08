#!/bin/bash

# author: Akshay Suresh
# date : 12/08/2017
# title : extract and crop audio from youtube audio

help() {
	echo "Usage $1 <url> <start-time> <end-time>"
	echo "Example: "
	echo "$1 https://www.youtube.com/watch?v=arMu4f8rnBk 00:00:05 00:04:30"
	exit 1
}

if [ $# -ne 3 ]
then
	help $0
fi

url=$1
st=$2
et=$3

# calculate duration
sthr=`echo $st | cut -d ":" -f1`
ethr=`echo $et | cut -d ":" -f1`
stmin=`echo $st | cut -d ":" -f2`
etmin=`echo $et | cut -d ":" -f2`
stsec=`echo $st | cut -d ":" -f3`
etsec=`echo $et | cut -d ":" -f3`
durhr=$((ethr-sthr))
durmin=$((etmin-stmin))
dursec=$((etsec-stsec))
dur=$durhr":"$durmin":"$dursec

# create directory
dirname=`date +"%s"`
echo "creating temporary directory $dirname"
mkdir $dirname
cd $dirname

# extract the audio
youtube-dl -x --audio-format "mp3" $url

# get the filename
filename=`ls | grep "mp3"`

# crop the audio
avconv -i "$filename" -ss $st -t $dur -codec copy "$filename""_cropped.mp3"

mv "$filename""_cropped.mp3"
