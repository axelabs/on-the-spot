#!/bin/bash

# Script applied to each ECS cluster instance by cloud init

# Define the cluster for the ECS agent
echo ECS_CLUSTER=webapp >> /etc/ecs/ecs.config
