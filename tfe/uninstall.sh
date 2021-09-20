
# ---------------------------------------------------------------------------------------------------------------------
# Uninstall Replicated/Clean Docker (CendOS/Fedora/RHEL)
# ---------------------------------------------------------------------------------------------------------------------
sudo systemctl stop replicated replicated-ui replicated-operator
sudo service replicated stop
sudo service replicated-ui stop
sudo service replicated-operator stop
sudo docker stop replicated-premkit
sudo docker stop replicated-statsd
sudo docker rm -f replicated replicated-ui replicated-operator replicated-premkit replicated-statsd retraced-api retraced-processor retraced-cron retraced-nsqd retraced-postgres
sudo docker images | grep "quay\.io/replicated" | awk '{print $3}' | xargs sudo docker rmi -f
sudo docker images | grep "registry\.replicated\.com/library/retraced" | awk '{print $3}' | xargs sudo docker rmi -f
sudo yum remove -y replicated replicated-ui replicated-operator
sudo rm -rf /var/lib/replicated* /etc/replicated* /etc/init/replicated* /etc/default/replicated* /etc/systemd/system/replicated* /etc/sysconfig/replicated* /etc/systemd/system/multi-user.target.wants/replicated* /run/replicated*





# ---------------------------------------------------------------------------------------------------------------------
# Uninstall Replicated/Clean Docker Ubuntu
# ---------------------------------------------------------------------------------------------------------------------
sudo service replicated stop
sudo service replicated-ui stop
sudo service replicated-operator stop
sudo docker stop replicated-premkit
sudo docker stop replicated-statsd
sudo docker rm -f replicated replicated-ui replicated-operator replicated-premkit replicated-statsd retraced-api retraced-processor retraced-cron retraced-nsqd retraced-postgres
sudo docker images | grep "quay\.io/replicated" | awk '{print $3}' | xargs sudo docker rmi -f
sudo docker images | grep "registry\.replicated\.com/library/retraced" | awk '{print $3}' | xargs sudo docker rmi -f
sudo apt-get remove -y replicated replicated-ui replicated-operator
sudo apt-get purge -y replicated replicated-ui replicated-operator
sudo rm -rf /var/lib/replicated* /etc/replicated* /etc/init/replicated* /etc/init.d/replicated* /etc/default/replicated* /var/log/upstart/replicated* /etc/systemd/system/replicated*
# Clean up Docker (cleans ALL Docker)
sudo docker container stop $(sudo docker container ls -a -q) && sudo docker system prune -a -f --volumes
DROP SCHEMA vault CASCADE;
DROP SCHEMA registry CASCADE;
DROP SCHEMA rails CASCADE;
