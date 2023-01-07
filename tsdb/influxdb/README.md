##################################################################################
#                  All Sample from InfluxDB Official Doc                         #
##################################################################################
1. Startup Influxdb
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

2. Access Web Console
WebUI:
http://192.168.56.10:8086/

3. Create an All Access API token.
influx auth create \
    --all-access \
    --host http://localhost:8086 \
    --org rh-ocp-qe \
    --token ocp-perfscale-super-secret-auth-token

4. Query an All Access API token.

podman  exec influxdb influx auth list       --user influxadm      --hide-headers | cut -f 3
ocp-perfscale-super-secret-auth-token


podman exec influxdb influx auth list       --user influxadm     --json | jq -r '.[].token'
ocp-perfscale-super-secret-auth-token
your-api-token-used-for-influx-auth

5. Configure authentication credentials.
influx config create \
  --config-name rh-ocp-qe-api-cfg \
  --host-url http://localhost:8086 \
  --org rh-ocp-qe \
  --token your-api-token-used-for-influx-auth


export INFLUX_TOKEN=your-api-token-used-for-influx-auth
export INFLUX_ORG=rh-ocp-qe
export INFLUX_HOST=http://localhost:8086

6. Create bucket
6.1.Using CLI
export INFLUX_TOKEN=your-api-token-used-for-influx-auth
influx bucket create --org rh-ocp-qe --name home-iot-mon
6.2.Using Http API
export INFLUX_ORG_ID=d4b2d59e7cfc0f13
export INFLUX_TOKEN=your-api-token-used-for-influx-auth
export INFLUX_HOST=http://localhost:8086
curl --request POST "$INFLUX_HOST/api/v2/buckets"   --header "Authorization: Token $INFLUX_TOKEN"   --header "Content-Type: applicaion/json"   --data '{
    "orgID": "'"$INFLUX_ORG_ID"'",
    "name": "home-iot-mon",
    "retentionRules": [
      {
        "type": "expire",
        "everySeconds": 0
      }
    ]
 }'
{
    "code": "conflict",
    "message": "bucket with name test1 already exists”
7. Create Config
influx config create   -n config-rh-ocp   -u http://localhost:8086   -p influxadm:1nfluxp2ssw0rd  -o rh-ocp     
Active    Name        URL            Org
    config-rh-ocp    http://localhost:8086    rh-ocp 

cat /etc/influxdb2/influx-configs 
[default]
  url = "http://localhost:8086"
  token = "ocp-perfscale-super-secret-auth-token"
  org = "rh-ocp-qe"
  active = true

8. Write Data
export INFLUX_TOKEN=zjDdu3hIVhgu1SKwhHsPA_zmU2VnwtNQc4ftsSejTSO6jgjsKl3bzDhHz71zifv9mv0KC_x5vWlDZiLpacp70w==
export INFLUX_ORG=rh-ocp-qe
export INFLUX_HOST=http://localhost:8086
influx write \
     --bucket home-iot-mon \
     --precision s "
   home,room=Living\ Room temp=21.1,hum=35.9,co=0i 1641024000
   home,room=Kitchen temp=21.0,hum=35.9,co=0i 1641024000
   home,room=Living\ Room temp=21.4,hum=35.9,co=0i 1641027600
   home,room=Kitchen temp=23.0,hum=36.2,co=0i 1641027600
   home,room=Living\ Room temp=21.8,hum=36.0,co=0i 1641031200
   home,room=Kitchen temp=22.7,hum=36.1,co=0i 1641031200
   home,room=Living\ Room temp=22.2,hum=36.0,co=0i 1641034800
   home,room=Kitchen temp=22.4,hum=36.0,co=0i 1641034800
   home,room=Living\ Room temp=22.2,hum=35.9,co=0i 1641038400
   "

export INFLUX_ORG=rh-ocp-qe
export INFLUX_HOST=http://localhost:8086
export INFLUX_TOKEN=zjDdu3hIVhgu1SKwhHsPA_zmU2VnwtNQc4ftsSejTSO6jgjsKl3bzDhHz71zifv9mv0KC_x5vWlDZiLpacp70w==

curl --request POST "$INFLUX_HOST/api/v2/write?org=$INFLUX_ORG&bucket=get-started&precision=s"   --header "Authorization: Token $INFLUX_TOKEN"   --header "Content-Type: text/plain; charset=utf-8"   --header "Accept: application/json"   --data-binary "
home,room=Living\ Room temp=21.1,hum=35.9,co=0i 1641024000
home,room=Kitchen temp=21.0,hum=35.9,co=0i 1641024000
home,room=Living\ Room temp=21.4,hum=35.9,co=0i 1641027600
home,room=Kitchen temp=23.0,hum=36.2,co=0i 1641027600
home,room=Living\ Room temp=21.8,hum=36.0,co=0i 1641031200
home,room=Kitchen temp=22.7,hum=36.1,co=0i 1641031200
home,room=Living\ Room temp=22.2,hum=36.0,co=0i 1641034800
home,room=Kitchen temp=22.4,hum=36.0,co=0i 1641034800
home,room=Living\ Room temp=22.2,hum=35.9,co=0i 1641038400
home,room=Kitchen temp=22.5,hum=36.0,co=0i 1641038400
home,room=Living\ Room temp=22.4,hum=36.0,co=0i 1641042000
home,room=Kitchen temp=22.8,hum=36.5,co=1i 1641042000
home,room=Living\ Room temp=22.3,hum=36.1,co=0i 1641045600
home,room=Kitchen temp=22.8,hum=36.3,co=1i 1641045600
home,room=Living\ Room temp=22.3,hum=36.1,co=1i 1641049200
home,room=Kitchen temp=22.7,hum=36.2,co=3i 1641049200
home,room=Living\ Room temp=22.4,hum=36.0,co=4i 1641052800
home,room=Kitchen temp=22.4,hum=36.0,co=7i 1641052800
home,room=Living\ Room temp=22.6,hum=35.9,co=5i 1641056400
home,room=Kitchen temp=22.7,hum=36.0,co=9i 1641056400
home,room=Living\ Room temp=22.8,hum=36.2,co=9i 1641060000
home,room=Kitchen temp=23.3,hum=36.9,co=18i 1641060000
home,room=Living\ Room temp=22.5,hum=36.3,co=14i 1641063600
home,room=Kitchen temp=23.1,hum=36.6,co=22i 1641063600
home,room=Living\ Room temp=22.2,hum=36.4,co=17i 1641067200
home,room=Kitchen temp=22.7,hum=36.5,co=26i 1641067200
"

9. Query DATA
9.1.Query Using CLI
influx query '
from(bucket: "home-iot-mon")
    |> range(start: 2022-01-01T08:00:00Z, stop: 2022-01-01T20:00:01Z)
    |> filter(fn: (r) => r._measurement == "home")
    |> filter(fn: (r) => r._field== "co" or r._field == "hum" or r._field == "temp")
'
9.2 Query Using Http API
curl --request POST "$INFLUX_HOST/api/v2/query?org=$INFLUX_ORG&bucket=get-started"   --header "Authorization: Token $INFLUX_TOKEN"   --header "Content-Type: application/vnd.flux"   --header "Accept: application/csv"   --data 'from(bucket: "home-iot-mon")
    |> range(start: 2022-01-01T08:00:00Z, stop: 2022-01-01T20:00:01Z)
    |> filter(fn: (r) => r._measurement == "home")
    |> filter(fn: (r) => r._field== "co" or r._field == "hum" or r._field == "temp")
  '
