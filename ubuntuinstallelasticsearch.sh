apt-get update
apt-get upgrade
apt-get install curl git -y
apt-get install python-software-properties -y
apt-get install openjdk-7-jre-headless -y
apt-get update

wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.2.1.deb
sudo dpkg -i elasticsearch-1.2.1.deb
rm elasticsearch-1.2.1.deb

sed -i "s/#cluster.name: elasticsearch/cluster.name: helpsearch/g" /etc/elasticsearch/elasticsearch.yml 
sed -i "s/#node.name: \"Franz Kafka\"/node.name: \"$HOSTNAME\"/g" /etc/elasticsearch/elasticsearch.yml 
sed -i 's/#transport.tcp.compress: true/transport.tcp.compress: true/g' /etc/elasticsearch/elasticsearch.yml 
sed -i 's/#index.number_of_replicas: 1/index.number_of_replicas: 3/g' /etc/elasticsearch/elasticsearch.yml 
sed -i 's/#discovery.zen.minimum_master_nodes: 1/discovery.zen.minimum_master_nodes: 2/g' /etc/elasticsearch/elasticsearch.yml


#deb does not add by default
update-rc.d elasticsearch defaults 95 10

/etc/init.d/elasticsearch start

/usr/share/elasticsearch/bin/plugin -i elasticsearch/marvel/latest
/usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head

echo "marvel.agent.exporter.es.hosts: [\"search1:9200\",\"search2:9200\",\"search3:9200\"]" >> /etc/elasticsearch/elasticsearch.yml

apt-get install ganglia-monitor nagios-nrpe-server -y
