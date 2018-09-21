sudo nano /etc/var/jenkins
wget http://localhost:8081/jnlpJars/jenkins-cli.jar
java -jar jenkins-cli.jar -s http://localhost:8081 who-am-i
java -jar jenkins-cli.jar -s http://localhost:8081/ install-plugin git
sudo service jenkins restart
java -jar jenkins-cli.jar -s http://localhost:8081/ create-job build_petclinic build.xml
