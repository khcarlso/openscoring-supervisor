# Overview
Openscoring (openscoring.io) provides an API for interacting with predictive models deployed via PMML files. This docker image runs supervisor as the primary executable which then runs both the openscoring engine and a model directory watch process so that changes to PMML in that directory are automatically add/deleted/updated.

# Running the container
Since this container will run openscoring and also watch the model-directory, a couple of things need to be specified:
* Volume mapping (-v) for mapping a host directory to the container.
* ENV that points to the URL for the model output (MODELURL).

In the example below, the host directory is "/Users/me/pmml"

### Run openscoring-supervisor container
`docker run -p 8080:8080 -p 9001:9001 -e MODELURL="http://localhost:8080/openscoring/model" -v /Users/me/pmml:/opt/openscoring/model-dir -d khcarlso/openscoring-supervisor`


### Openscoring security
Openscoring, by default, only allows access to certain REST API calls from IP address that match the IP of the openscoring instance. Since many will be accessing the API from the host IP and not the container IP, this causes security exceptions to be thrown.

To fix this, the application.conf file can be modified to allow IP address access to administrator only functions. Modify the IP list in the file then rebuild the container.

If you don't know what IP address you need to add, build and run the container as is, then watch the logs (docker logs -f <container>) to see what IP address you are using.

# Build the image after modifications
`docker build -t khcarlso/openscoring-supervisor .`

# Supervisor control panel
This docker image exposes port 9001 which provides access to the control panel allowing control over the openscoring and openscoring-watch processes.






