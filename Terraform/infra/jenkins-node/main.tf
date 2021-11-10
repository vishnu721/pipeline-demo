data "terraform_remote_state" "vpc_info" {
  backend = "s3"
  config = {
    bucket = "vishnu-remote"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

data terraform_remote_state "jenkins-master" {
    backend = "s3"
    config = {      
      bucket = "vishnu-remote"
      key = "ec2/terraform.tfstate"
      region = "us-east-1"
     }
}

resource "aws_instance" "jenkins-node" {
  ami = "ami-0f8f3e38c86610f2c"
  instance_type          = "t2.micro"
  key_name               = "LinuxServer"
  vpc_security_group_ids = ["${data.terraform_remote_state.vpc_info.outputs.default_security_group_id}"]
  security_groups = [ "jenkins-node-sg" ]
  subnet_id              = data.terraform_remote_state.vpc_info.outputs.public_subnet_ids[0]
  tags = {
    Terraform = "true"
    Env       = "dev"
    Name      = "Jenkins-Node"
  }


  provisioner "local-exec" {
         command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ec2-user --private-key ./LinuxServer.pem -i '${aws_instance.jenkins-node.public_ip},' playbook.yml"
     }

}

resource "aws_security_group" "jenkins-node-sg" {
  name = "jenkins-node-sg"
  
  vpc_id = data.terraform_remote_state.vpc_info.outputs.id
  ingress = [ {
    description = "Allow SSH from Jenkins Master"
    cidr_blocks = [ "${data.terraform_remote_state.jenkins-master.outputs.public-ip[0]}/32" ]
    from_port = 22
    protocol = "tcp"
    to_port = 22
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
  },
   {
    description = "Allow SSH from Local system"
    cidr_blocks = [ "122.171.168.76/32" ]
    from_port = 22
    protocol = "tcp"
    to_port = 22
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
  } ]
  egress = [ {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
    description = "Outbound all"
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids = []
    security_groups = []
    self = false

  } ]
  
  tags = {
    "Name" = "jenkins-node-sg"
  }
  
}