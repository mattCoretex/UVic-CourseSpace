#!/bin/bash

#Extract returned quizzes from UVic course space
#author: Mek O.
#email: aobchey00@uvic.ca


FILE=$1
OUTPUT=$(echo $FILE | sed 's/\..*//g')
OUTPUT_Q="$OUTPUT""_Questions"
OUTPUT_C="$OUTPUT""_Choices"
OUTPUT_A="$OUTPUT""_Answers"

COUNT=$((COUNT = 0))
DIR="CoureSpace"

if [ ! -d $DIR ]; then
	mkdir $DIR
fi

cat $FILE | grep '.qtext' | cut -d '<' -f13 | grep -oP '>.*' | awk '{print NR, "\t", $0}' | sed -r 's/(^.*$)/\1\n/g' > $OUTPUT_Q


cat $FILE | grep -oP 'answernumber.*' | grep -oP '>.*' | sed -e 's/<[^>]*>//' | sed 's/<.*//g' | sed -r 's/(>a.*)/\n\1/g' | while read -r line ; do  echo "$line" ; if [ "$line" == ""  ] ; then echo "$((COUNT += 1))"")"; fi; done > $OUTPUT_C

COUNT=$((COUNT=0))
cat $FILE | grep -oP "answernumber.*Correct" | grep -oP '>.*/l' | sed -r 's/<[^>]*>//g' | sed -r 's/([.].*)(<.*)/\1/g' | while read -r line; do echo -e "$((COUNT += 1))""\n""$line""\n\n"; done > $OUTPUT_A



mv $OUTPUT_Q $DIR/$OUTPUT_Q
mv $OUTPUT_A $DIR/$OUTPUT_A
mv $OUTPUT_C $DIR/$OUTPUT_C




