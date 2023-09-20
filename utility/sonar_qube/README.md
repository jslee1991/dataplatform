1. make pv (hostpath: all node can be deployed)
mkdir -p /tmp/sonar/data
mkdir -p /tmp/sonar/logs
mkdir -p /tmp/sonar/exten
mkdir -p /tmp/mssql

2. deploy mssql
kubectl apply -f mssql/

3. create seceret
sh mssql/create.sh

4. deploy sonnar-qube
kubectl apply -f sonar-qube.yaml
