#!/bin/sh

# Get the code
# git clone --depth 1 https://github.com/supabase/supabase
# Go to the docker folder
cd supabase/docker
# Copy the fake env vars
cp .env.example .env
# Start
docker-compose up -d