cookbook_file "/var/opt/spring-petclinic-2.0.0.BUILD-SNAPSHOT.jar" do
   source "spring-petclinic-2.0.0.BUILD-SNAPSHOT.jar"
end

execute "run spring-petclinic-2.0.0.BUILD-SNAPSHOT.jar in directory" do
  command "java -jar spring-petclinic-2.0.0.BUILD-SNAPSHOT.jar"
  cwd "/var/opt"
  action :run
end
