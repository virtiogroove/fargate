eksctl create cluster --name MyCluster --zones --fargate --region


kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-efs-csi-driver/master/deploy/kubernetes/base/csidriver.yaml
#or
kubectl apply -f https://raw.githubusercontent.com/virtiogroove/fargate/main/prometheus/aws-csi.yaml
# Note usually it returns
aws eks describe-cluster --name MyCluster --query "cluster.resourcesVpcConfig.vpcId" --output text -
#grab output which is somrthing like below
#vpc-<exampledb76d3e813>

aws ec2 describe-vpcs --vpc-ids vpc-0046a8f551bedce74 --query "Vpcs[].CidrBlock" --output text --region us-east-1
192.168.0.0/16 #VPC CIDR
vpc-12345 #Your VPC id


#Create a security group that allows inbound NFS traffic for your Amazon EFS mount points.

#    Open the Amazon VPC console at https://console.aws.amazon.com/vpc/
#Choose Security Groups in the left navigation panel, and then choose Create security group.
#Enter a name and description for your security group, and choose the VPC that your Amazon EKS cluster is using.
#Under Inbound rules, select Add rule.
#Under Type, select NFS.
#Under Source, select Custom, and paste the VPC CIDR range that you obtained in the previous step.
#Choose Create security group.

aws efs describe-file-systems --query "FileSystems[*].FileSystemId" --output text --region us-east-1
#change your pv files for alertmanager and server and 
kubectl apply -f efs-storage-class.yaml


helm install prometheus prometheus-community/prometheus --namespace default -f values-fargate.yaml


kubectl apply -f pvc-prometheus-alertmanager.yaml
kubectl apply -f pvc-prometheus-server.yaml

kubectl apply -f pv-prometheus-alertmanager.yaml
kubectl apply -f pv-prometheus-server.yaml

#add all three subnets for my EFS filesystem (reached in the AWS console via EFS>your filesystem>Network tab>Manage button) #to the following security groups:
#eksctl-<clustername>-cluster-ClusterSharedNodeSecurityGroup-########
#eks-cluster-sg-<clustername>-#########


#Delete resources
helm uninstall prometheus
aws cloudformation delete-stack --stack-name MyCluster 
