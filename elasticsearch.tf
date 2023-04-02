
provider "aws" {
  region     = "ap-south-1"
  access_key = "key"
  secret_key = "key"
}

resource "aws_instance" "example" {
  ami           = "ami-02eb7a4783e7e9317"
  instance_type = "t2.micro"
  key_name      = "projectpak"

  provisioner "remote-exec" {
    # connection {
    #   type = "ssh"
    #   host = "aws_instance.example.public_ip"
    #   user = "ubuntu"

    # }

    inline = [
      "sudo apt-get update",
      "sudo apt-get install openjdk-8-jre-headless -y",
      "sudo apt-get update",
      "wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.10.2-linux-x86_64.tar.gz",
      "tar -xzf elasticsearch-7.10.2-linux-x86_64.tar.gz",
      "sudo mv elasticsearch-7.10.2 /usr/local/elasticsearch",
      "sudo chown -R ubuntu:ubuntu /usr/local/elasticsearch",
      "cd /usr/local/elasticsearch/bin",
      "./elasticsearch-keystore create",
      "./elasticsearch-keystore add xpack.security.transport.ssl.key",
      "./elasticsearch-keystore add xpack.security.transport.ssl.certificate",
      "./elasticsearch-keystore add xpack.security.transport.ssl.certificate_authorities",
    ]
  }
}

output "elasticsearch_url" {
  value = "https://" + aws_instance.example.public_ip + ":9200"
}