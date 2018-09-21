#!/usr/bin/expect
puts "create cluster..."
spawn aws ecs create-cluster --cluster-name devops-cluster
puts  "create ec2 instance..."
spawn aws ec2 run-instances --image-id ami-5253c32d --count 1 --instance-type t2.micro --key-name devops-kep-pair --security-group-ids sg-884bbdc2 --subnet-id subnet-09e68f06 --iam-instance-profile Name="ecsInstanceRole" --user-data file://user_data_script
puts "waiting for ec2 instance to be associated with container..."
for {set x 0} {$x==0} {} {
spawn aws ecs list-container-instances --cluster devops-cluster
expect "*arn:aws*" {
puts "associated!"
set x 1
}
sleep 5
}

puts "create task1..."
spawn aws ecs register-task-definition --cli-input-json file://task.json
expect
puts "create task2..."
spawn aws ecs register-task-definition --cli-input-json file://anothertask.json
expect
puts "Run task1..."
spawn aws ecs run-task --cluster devops-cluster --task-definition devops-task-1:1 --count 1
expect
puts "Run task2..."
spawn aws ecs run-task --cluster devops-cluster --task-definition devops-task-2:1 --count 1
expect
puts "completed!"
