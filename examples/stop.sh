#!/bin/bash

docker-compose -f docker-compose.postgres.yml -f docker-compose.confluent.yml -f docker-compose.yml down
