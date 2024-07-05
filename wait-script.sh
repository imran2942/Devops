<<<<<<< HEAD
#!/bin/bash

# Wait for database service to be ready
echo "Waiting for database to be ready..."
while ! mysqladmin ping -h database --silent; do
    echo "Database is not ready yet. Retrying in 1 second..."
    sleep 1
done

echo "Database is ready. Proceeding with migrations..."
=======
#!/bin/bash

# Wait for database service to be ready
echo "Waiting for database to be ready..."
while ! mysqladmin ping -h database --silent; do
    echo "Database is not ready yet. Retrying in 1 second..."
    sleep 1
done

echo "Database is ready. Proceeding with migrations..."
>>>>>>> ea8b744a3957dd501e609cb7aaed1c11d224c5fc
