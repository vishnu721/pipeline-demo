data "terraform_remote_state" "vpc_info" {
  backend = "s3"
  config = {
    bucket = "vishnu-remote"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_instance" "jenkins-node" {
  ami = "ami-0f8f3e38c86610f2c"
  instance_type          = "t2.micro"
  key_name               = "LinuxServer"
  vpc_security_group_ids = ["${data.terraform_remote_state.vpc_info.outputs.default_security_group_id}"]
  subnet_id              = data.terraform_remote_state.vpc_info.outputs.public_subnet_ids[0]
  tags = {
    Terraform = "true"
    Env       = "dev"
    Name      = "Jenkins-Node"
  }

  provisioner "remote-exec" {
    inline = ["echo Hello"]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("./LinuxServer.pem")
    }
  }

  provisioner "local-exec" {
         command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ec2-user --private-key ./LinuxServer.pem -i '${aws_instance.jenkins-node.public_ip},' playbook.yml"
     }

}