# comp730

## Process for Measuring

1. Spin up this repository on a dev container.
2. On your local machine, open a new terminal window.
3. In this new terminal window, type docker stats. You should see something displaying the CPU utilization of the container.

## Setting up cAdvisor (Google's Monitoring Engine) 

Just run the following command: 

`VERSION=v0.35.0 # use the latest release version from https://github.com/google/cadvisor/releases
sudo docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:rw \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  gcr.io/cadvisor/cadvisor:$VERSION`
  
It should work fine, if it throws an error the second time you run it, you can just run: `docker start #`, where `#` is the ID of the container you are tryingto run. 

### Metrics with cAdvisor

To see the metrics, you can just go to the endpoint `localhost:8080/metrics`.
 
