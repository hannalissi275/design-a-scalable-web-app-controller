#!/bin/bash

# Define the application name
APP_NAME="Scalable Web App"

# Set the configuration file
CONFIG_FILE="config.json"

# Load the configuration
load_config() {
  if [ -f "$CONFIG_FILE" ]; then
    # Use jq to parse the JSON config file
    CONFIG=$(jq -r '.[] | @uri' "$CONFIG_FILE")
  else
    echo "Error: Config file not found!"
    exit 1
  fi
}

# Define the controllers
controllers=("users" "products" "orders")

# Define the routes
routes=("GET /users" "POST /users" "GET /products" "POST /products" "GET /orders" "POST /orders")

# Create the controllers and routes
create_controllers() {
  for controller in "${controllers[@]}"; do
    mkdir -p "app/controllers/$controller"
    touch "app/controllers/$controller/$controller.js"
  done
  
  for route in "${routes[@]}"; do
    IFS=' ' read -r -a route_array <<< "$route"
    method=${route_array[0]}
    path=${route_array[1]}
    controller=${path//\//""}
    echo "$method $path => $controller->$method" >> "app/routes.js"
  done
}

# Initialize the application
init_app() {
  mkdir -p app/controllers
  mkdir -p app/routes
  touch app/routes.js
  create_controllers
}

# Run the application
run_app() {
  node app/routes.js
}

# Main entry point
main() {
  init_app
  run_app
}

main