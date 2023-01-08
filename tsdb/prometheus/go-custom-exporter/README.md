######################################################################################
##                          Prometheus Sample Usage                                 ##
######################################################################################
#Startup Prometheus Using Container
mkdir -p /opt/tsdb/prometheus-persistence;chmod -R 777 /opt/tsdb/prometheus-persistence;podman run -itd --name prometheus -p 9090:9090 -v /opt/tsdb/prometheus-persistence/:/opt/bitnami/prometheus/data/:Z bitnami/prometheus:latest

#Prepare Go Development Environment
go mod init
go mod vendor
go get github.com/prometheus/common/version
go get github.com/sirupsen/logrus
go get github.com/prometheus/client_golang/prometheus
go get github.com/prometheus/client_golang/prometheus/promauto
go get github.com/prometheus/client_golang/prometheus/promhttp
go mod vendor

#Reference Doc 
https://percona.community/blog/2021/07/21/create-your-own-exporter-in-go/
