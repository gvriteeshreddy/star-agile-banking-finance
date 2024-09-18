resource "aws_instance" "test-server" {
  ami = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  key_name = "testing-keypair"
  vpc_security_group_ids = ["sg-0f0f4504af5402c8a"]

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("./testing-keypair.pem")
    host = self.public_ip
    timeout = "10m"
  }

  provisioner "remote-exec" {
    inline = ["echo 'wait to start the instance'"]
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.test-server.public_ip} > inventory"
  }

  provisioner "local-exec" {
    command = "ansible-playbook /var/lib/jenkins/workspace/banking/terraform-files/ansibleplaybook.yml"
  }

  tags = {
    Name = "test-server"
  }
}
