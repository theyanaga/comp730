#! /bin/zsh

FILE="./docker-stats/docker-stats-$2-$3.csv" 

while true;
do
	docker stats $1 --no-stream --format {{.CPUPerc}} | gawk '$2=systime() sub(/%/,","); {print $1 $2}' >> $FILE
done
