#!/usr/bin/env bash

set -e

#git update-index --refresh
#git diff-index --quiet HEAD --

sshHost="-p 22 -C $RELAY_SSH_USER@$RELAY_URL"
scpHost="$RELAY_SSH_USER@$RELAY_URL"
##Build App
if [ "$1" == 'NOTEST' ]; then
	./build.sh prod
else
	./test.sh && ./build.sh prod
fi

#Update system
ssh $sshHost "sudo apt update"
ssh $sshHost "sudo apt upgrade -y"
ssh $sshHost "sudo apt autoremove -y"
ssh $sshHost "sudo shutdown -r now"  || echo "System shutdown"


#Wait for host to come back online
until [ "$(ssh $sshHost "echo ok")" = "ok" ]; do
  sleep 1;
  echo "Trying to connect to host again..."
done

ssh $sshHost "mkdir -p ~/app"

ssh $sshHost "sudo rm ~/app/relay" || echo "No exec file found"
scp -P "22" ./docker-compose.prod.yml $scpHost:~/app/
ssh $sshHost "POSTGRES_PASSWORD=${POSTGRES_PASSWORD} docker compose -f ~/app/docker-compose.prod.yml pull" || echo "Docker compose not yet started"
ssh $sshHost "POSTGRES_PASSWORD=${POSTGRES_PASSWORD} docker compose -f ~/app/docker-compose.prod.yml down" || echo "Docker not running"
scp -P "22" ./relay $scpHost:~/app/
ssh $sshHost "POSTGRES_PASSWORD=${POSTGRES_PASSWORD} docker compose -f ~/app/docker-compose.prod.yml up -d --remove-orphans"
ssh $sshHost "docker image prune -f"
ssh $sshHost "cd ~/app && RELAY_URL=${RELAY_URL} POSTGRES_PASSWORD=${POSTGRES_PASSWORD} ./relay &"