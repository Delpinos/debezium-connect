#!/bin/bash

sudo mkdir -p data/zookeeper-1/var/lib/zookeeper/data
sudo mkdir -p data/zookeeper-1/var/lib/zookeeper/log

sudo mkdir -p data/zookeeper-1/etc/zookeeper/secrets
sudo mkdir -p data/zookeeper-2/var/lib/zookeeper/data

sudo mkdir -p data/zookeeper-2/var/lib/zookeeper/log
sudo mkdir -p data/zookeeper-2/etc/zookeeper/secrets

sudo mkdir -p data/zookeeper-3/var/lib/zookeeper/data
sudo mkdir -p data/zookeeper-3/var/lib/zookeeper/log

sudo mkdir -p data/zookeeper-3/etc/zookeeper/secrets
sudo mkdir -p data/zookeeper-4/var/lib/zookeeper/data

sudo mkdir -p data/zookeeper-4/var/lib/zookeeper/log
sudo mkdir -p data/zookeeper-4/etc/zookeeper/secrets

sudo mkdir -p data/broker-1/var/lib/kafka/data
sudo mkdir -p data/broker-1/etc/kafka/secrets

sudo mkdir -p data/broker-2/var/lib/kafka/data
sudo mkdir -p data/broker-2/etc/kafka/secrets

sudo mkdir -p data/broker-3/var/lib/kafka/data
sudo mkdir -p data/broker-3/etc/kafka/secrets

sudo mkdir -p data/broker-4/var/lib/kafka/data
sudo mkdir -p data/broker-4/etc/kafka/secrets

sudo mkdir -p data/zookeeper-control-center-1/var/lib/zookeeper/data
sudo mkdir -p data/zookeeper-control-center-1/var/lib/zookeeper/log

sudo mkdir -p data/broker-control-center-1/var/lib/kafka/data
sudo mkdir -p data/broker-control-center-1/etc/kafka/secrets

# Make sure the user has the read and write permissions.
sudo chown -R 1000:1000 data

docker-compose -f docker-compose.postgres.yml -f docker-compose.confluent.yml -f docker-compose.yml up -d --force-recreate --build
