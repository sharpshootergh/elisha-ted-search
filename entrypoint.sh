#!/bin/sh

# Moving static files to the directory which is mounted to a named volume
# This named volume will be exposed to the proxy which will in turn just 
# Serve the files for me....
mv  /app/src/main/resources/static/* /var/static_files
cp /app/conf/default.conf /var/nginx/default.conf

# Removing the static files form the previous location
# rm -rf /app/src/main/resources/static


# Running the application
java -jar /app/target/*.jar --spring.config.location=./application.properties