# comp730

## Process for Measuring

1. Spin up this repository on a dev container.
2. On your local machine, open a new terminal window.
3. In this new terminal window, type docker stats. You should see something displaying the CPU utilization of the container.

## Setting up metrics

1. Run `cd docker-monitoring` OUTSIDE your dev container. 
2. The command to spin up data monitoring: `docker compose up`.
3. You can access metrics in `http://localhost:9090` and running the query `rate(container_cpu_user_seconds_total[30s]) * 100`, which gives a metric of the CPU utilization.
4. Then, spin up the dev container, and run your metrics. An example command would be: `sysbench --test=cpu run --threads=10` to measure the CPU utilization of the container. 

## Graphs

In order to generate graphs, run the command `jupyter notebook` and select the `graphs.ipynb` file, which contains all the code for the generation of the graphs displayed in this paper.

## Interpreting results

If you get a result, such as `200% utilization CPU utilization`, that means you're using over 100% of two cores in your computer.
