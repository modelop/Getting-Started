#!/bin/bash -x


# Move to the right directory so our local file paths work later
cd /usr/local/airflow/processing

# Connect
fastscore connect https://dashboard:8000/dashboard

# Make sure environment looks good
fastscore fleet

# Give the logfile something to show :)
echo "Hello, world!"
