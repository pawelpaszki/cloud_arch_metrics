#!/bin/bash
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
# send first request to make sure that request count won't send corrupted data
curl -X POST -H "Content-Type: application/json" -d '{"instanceID":"'"$INSTANCE_ID"'"}' 'http://localhost:8000/api'

CPU_USED_USER=$(iostat | tail -5 | head -1 | awk '{print $1}')
CPU_USED_SYSTEM=$(iostat | tail -5 | head -1 | awk '{print $3}')
CPU_USED_IOWAIT=$(iostat | tail -5 | head -1 | awk '{print $4}')
CPU_IDLE=$(iostat | tail -5 | head -1 | awk '{print $6}')
MEMORY_TOTAL=$(free | tail -2 | head -1 | awk '{print $2}')
MEMORY_USED=$(free | tail -2 | head -1 | awk '{print $3}')
MEMORY_FREE=$(free | tail -2 | head -1 | awk '{print $4}')
MEMORY_AVAILABLE=$(free | tail -2 | head -1 | awk '{print $6}')
REQUEST_COUNT=$(sudo docker logs --tail 1 sample_docker_node_my-node-app_1 | awk '{print $2}' | sed 's/,//')

aws cloudwatch put-metric-data --metric-name cpu-used-user --dimensions Instance=$INSTANCE_ID --namespace "Assignment_1" --value $CPU_USED_USER
aws cloudwatch put-metric-data --metric-name cpu-used-system --dimensions Instance=$INSTANCE_ID --namespace "Assignment_1" --value $CPU_USED_SYSTEM
aws cloudwatch put-metric-data --metric-name cpu-used-iowait --dimensions Instance=$INSTANCE_ID --namespace "Assignment_1" --value $CPU_USED_IOWAIT
aws cloudwatch put-metric-data --metric-name cpu-idle --dimensions Instance=$INSTANCE_ID --namespace "Assignment_1" --value $CPU_IDLE
aws cloudwatch put-metric-data --metric-name memory-total --dimensions Instance=$INSTANCE_ID --namespace "Assignment_1" --value $MEMORY_TOTAL
aws cloudwatch put-metric-data --metric-name memory-used --dimensions Instance=$INSTANCE_ID --namespace "Assignment_1" --value $MEMORY_USED
aws cloudwatch put-metric-data --metric-name memory-free --dimensions Instance=$INSTANCE_ID --namespace "Assignment_1" --value $MEMORY_FREE
aws cloudwatch put-metric-data --metric-name memory-available --dimensions Instance=$INSTANCE_ID --namespace "Assignment_1" --value $MEMORY_AVAILABLE
aws cloudwatch put-metric-data --metric-name request-count --dimensions Instance=$INSTANCE_ID --namespace "Assignment_1" --value $REQUEST_COUNT
