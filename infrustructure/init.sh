#!/bin/bash
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 644435390668.dkr.ecr.us-west-2.amazonaws.com
docker compose up -d