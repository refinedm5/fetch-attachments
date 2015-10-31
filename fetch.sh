#!/bin/bash
DIR=/home/fetcher/Maildir
LOG=/home/fetcher/Maildir/getmail.log
date +%r-%-d/%-m/%-y >> $LOG
fetchmail
mv $DIR/new/* $DIR/process/landing/
cd $DIR/process/landing/
shopt -s nullglob
for i in *
do
echo "processing $i" >> $LOG
mkdir $DIR/process/extract/$i
cp $i $DIR/process/extract/$i/
echo "saving backup $i to archive"  >> $LOG
mv $i $DIR/process/archive
echo "unpacking $i" >> $LOG
munpack -C $DIR/process/extract/$i -q $DIR/process/extract/$i/$i
echo "converting pdf.." >> $LOG
	for x in $DIR/process/extract/$i/*.pdf
	do
	ranx=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)
	gs -sDEVICE=tiff24nc -dNOPAUSE -r300x300 -sOutputFile=$DIR/process/extra
ct/$i/$i-$ranx.tiff -- $x
        rm $x
	done

echo "next, the jpegs.." >> $LOG
	for y in $DIR/process/extract/$i/*.jpg
     	do
        rany=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)
        convert $y $DIR/process/extract/$i/$i-$rany.tiff
        rm $y
	done

echo "last, the pngs.." >> $LOG
        for z in $DIR/process/extract/$i/*.png
        do
        ranz=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)
        convert $z $DIR/process/extract/$i/$i-$ranz.tiff
        rm $z     
        done

done
shopt -u nullglob
echo "finishing.." >> $LOG
mv $DIR/process/extract/* /$DIR/process/store/ 
echo "done!" >> $LOG
