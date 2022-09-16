#!/usr/bin/env bash

set -e

./build.sh

if [ "$1" == 'test' ]; then
	POSTGRES_HOST=localhost SERVER_PORT=8444 POSTGRES_PORT=5433 POSTGRES_PASSWORD=relay_test POSTGRES_USER=relay_test POSTGRES_DB=relay_test ./relay
else
	POSTGRES_HOST=localhost SERVER_PORT=8080 POSTGRES_PORT=5434 POSTGRES_PASSWORD=relay POSTGRES_USER=relay POSTGRES_DB=relay ./relay
fi
