#! /bin/zsh

THREADS=4
MAX_PRIME=16000 
FILE="output-16-4.txt"


function run_benchmark() {
	sysbench --threads=$THREADS cpu --cpu-max-prime=$MAX_PRIME run &
	BACK_PID=$!
	wait $BACK_PID 
}

function get_benchmarks() {
	while true 
	do 
		ps auxwww | awk '{print "process_cpu_usage{pid="$2",name=\""$11"\"}",$3}' >> $FILE
 		sleep 0.0001	
	done
}

# Run the program two times (warm-up), and then start measuring for the first 5 trials.

# Warm up

function run_all_benchmarks() {
	
	echo "<WARM UP DONE --------------------------------------------->" >> $FILE 
	
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
	
}

# Run one warm up round, then run all the trials one after another. 
for i in {1..2}
do 
	run_benchmark
done

# Start the docker process
docker stats > docker-output.txt
# Get the PID of the docker process to kill it after we're done.
$DOCKER_STATS_PID=$!

# Iterate through the threads. 
for t in {1..4..1}
do
	# Iterate through the different max primes
	for ((num = 16; num <= 128; num = num * 2))
	do
		DIRTY_FILE="output-$num-$t.txt"

		# Run command and write to dirty file.

		CLEAN_FILE="clean-$num-$t.txt"

		# Get dirty file, grep sysbench and pipe to clean file.
		cat $DIRTY_FILE | grep sysbench > $CLEAN_FILE
	done
done

kill -9 $DOCKER_STATS_PID
