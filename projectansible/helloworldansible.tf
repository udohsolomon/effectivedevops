# Provider Configuration for AWS
provider "aws" {
  region = "us-east-1"
}

# Resource Configuration for AWS
resource "aws_instance" "myserver" {
  ami                    = "ami-cfe4b2b0"
  instance_type          = "t2.micro"
  key_name               = "devec2key"
  vpc_security_group_ids = ["sg-6f51d835"]

  tags = {
    Name = "helloworld"
  }

  # Provisioner for applying Ansible playbook
  # Provisioner for applying Ansible playbook
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/devec2key.pem")
      host        = self.public_ip
    }
  }
  provisioner "local-exec" {
    command = "echo '${self.public_ip}' >> ./myinventory"
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i myinventory --private-key=~/.ssh/devec2key.pem helloworld.yml"
  }
}

# IP address of newly created EC2 instance
output "myserver" {
  value = aws_instance.myserver.public_ip
}

