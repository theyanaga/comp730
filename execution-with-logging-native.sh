#! /bin/zsh

THREADS=$1
MAX_PRIME=$2
FILE="./native/native-$MAX_PRIME-$THREADS.csv"

function run_benchmark() {
	sysbench --threads=$THREADS cpu --cpu-max-prime=$MAX_PRIME run &
	BACK_PID=$!
	wait $BACK_PID 
}

function get_benchmarks() {
	while true 
	do
			ps auxwww | grep sysbench | gawk '$4=systime() {if ($11 == "sysbench") print $4","$3}' >> $FILE
	done
}

# Run the program two times (warm-up), and then start measuring for the first 5 trials.

# Warm up
for i in {1..2}
do 
	run_benchmark
done

# Run the 5 trials
get_benchmarks &
MONITOR_PID=$!
for j in {1..5}
do 
	## Use & to continue waiting for the program in parallel.
	run_benchmark &
	BACK_PID=$!
	# We need to start recording the metrics for CPU usage here. 
	wait $BACK_PID
done

kill -9 $MONITOR_PID

