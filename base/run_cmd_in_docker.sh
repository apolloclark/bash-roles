#!/bin/bash -eux

# list all the container id's
for container in `docker ps -q`; do 

  # https://docs.docker.com/engine/reference/commandline/inspect/
  # docker inspect --format='{{.Name}}' $container;
  CONTAINER_IMAGE=$(docker inspect --format='{{.Config.Image}}' $container);

  # run a command
  # https://docs.docker.com/engine/reference/commandline/exec/
  # cat /etc/*-release
  # whoami
  CMD_OUTPUT=$(docker exec -it $container sh -c 'cat /etc/*-release');
  
  echo "$CONTAINER_IMAGE | $CMD_OUTPUT";
  echo "";
done
