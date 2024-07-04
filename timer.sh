#!/bin/bash

start_time=$(date +%s)

# Wait for the database service to be ready
echo "Waiting for the database to be ready..."
while ! mysqladmin ping -h database --silent; do
    echo "Database is not ready yet. Retrying in 1 second..."
    sleep 1
done

end_time=$(date +%s)
total_time=$((end_time - start_time))

echo "Database is ready! Total startup time: $total_time seconds"

# Proceed with migrations
#php artisan migrate --force

# Start the Apache server
#apache2-foreground
