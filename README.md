## Create a alpha server and alpha client for where alpha server acts as ssh logging service

Infra setup:

1. Infra has been created using terraform where seperate modules are created for compute and networking

2. Modules are being called by the files from the infra directory which creates the aws resources required

3. Terraform provisioners (Ex: remote exec) are used to deploy the scripts and to make necessary changes to the server
 
It creates:
1. Alpha server 
2. Alpha client-1
3. Alpha client-2

Application/logic:

1. A shell script has been created which takes care of logging the clients which are accessing the alpha server
2. This script gives us the successful and failed ssh attempts and this script is placed as a cronjob

Implementation:

1. Navigate to infra/nodes and just execute the terraform plan and terraform apply
2. This will not only create the infrastructure but also deploy the required scripts and displays the ssh logging output in the console

Backup mechanism:

1. We can save the logs in storage bucket s3 or in any centralized locations in the cloud and run a maintenance script which cleans up the old log entries.

Below screenshot provides the ssh logging output at the end. 

![Screenshot 2022-01-28 at 5 47 40 AM](https://user-images.githubusercontent.com/60593526/151464851-1bb7c272-6ee8-4ecd-b192-5cb99d14f1d3.png)


