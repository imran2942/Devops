#!/bin/bash

# Wait for database service to be ready
echo "Waiting for database to be ready..."
while ! mysqladmin ping -h database --silent; do
    echo "Database is not ready yet. Retrying in 1 second..."
    sleep 1
done

echo "Database is ready. Proceeding with migrations..."
