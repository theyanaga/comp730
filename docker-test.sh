#! /bin/zsh

# Function that runs sysbench with the correct arguments
function run_benchmark() {
	sysbench --threads=$1 cpu --cpu-max-prime=$2 run &
	SYSBENCH_PID=$!
	# wait for this to end before returning and running another one. 
	wait $SYSBENCH_PID
}

# Function that runs the 5 trials with the proper arguments
function run_all_trials() {
	THREADS=$1
	NUMS=$2
	for j in {1..5}
	do
		## Use & to continue waiting for the program in parallel.
		run_benchmark $THREADS $NUMS &
		BACK_PID=$!
		# We need to start recording the metrics for CPU usage here.
		wait $BACK_PID
	done
}

# Iterate through the threads. 
for t in {1..4..1}
do
	# Iterate through the different max primes
	for ((num = 16; num <= 128; num = num * 2))
	do
		# Just write the command
		run_all_trials $t $num 
		sleep 2
	done
	sleep 2
done



