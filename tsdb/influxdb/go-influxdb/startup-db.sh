mkdir -p /opt/tsdb/influxdb2
mkdir -p /opt/tsdb/influxcfg
chmod -R 755 /opt/tsdb
podman run -itd --name influxdb --hostname=influxdb -p 8086:8086 \
      -v /opt/tsdb/influxdb2:/var/lib/influxdb2:Z \
      -v /opt/tsdb/influxcfg:/etc/influxdb2:Z \
      -e DOCKER_INFLUXDB_INIT_MODE=setup \
      -e DOCKER_INFLUXDB_INIT_USERNAME=influxadm \
      -e DOCKER_INFLUXDB_INIT_PASSWORD=1nfluxp2ssw0rd  \
      -e DOCKER_INFLUXDB_INIT_ORG=rh-ocp-qe \
      -e DOCKER_INFLUXDB_INIT_BUCKET=perfscale \
      -e DOCKER_INFLUXDB_INIT_ADMIN_TOKEN=ocp-perfscale-super-secret-auth-token \
      influxdb:latest
      #-e DOCKER_INFLUXDB_INIT_RETENTION=1w 
