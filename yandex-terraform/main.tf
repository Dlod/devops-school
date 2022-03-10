terraform {
  required_providers {
    yandex = {
      source = "terraform-registry.storage.yandexcloud.net/yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

locals {
  folder_id = "b1gg3fk5l7lmghchhs41"
  image_id = "fd8mfc6omiki5govl68h"
  region = "ru-central1-a"
  public_key = "/Users/mikhailrozov/.ssh/id_rsa_devops_school.pub"
  private_key = "/Users/mikhailrozov/.ssh/id_rsa_devops_school"
  bucket_name = "boxfusevv"
}

provider "yandex" {
  token     = "AQAAAAASlZsxAATuwUNHSQ4axk8mjZRipGorL6U"
  cloud_id  = "b1gse4qfafv97a9h9b38"
  folder_id = local.folder_id
  zone      = local.region
}

// Create SA
resource "yandex_iam_service_account" "sa" {
  folder_id = local.folder_id
  name      = "tf-test-sa"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = local.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

// Use keys to create bucket
resource "yandex_storage_bucket" "boxfusevv" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = local.bucket_name
}

resource "yandex_compute_instance" "vm-1" {
  name = "terraform1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = local.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("${local.public_key}")}"
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo apt update",
  #     "sudo apt install git maven openjdk-8-jdk awscli -y ",
  #     "sudo git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git /srv/boxfuse",
  #     "sudo chmod -R 0777 /srv/boxfuse",
  #     "mvn package -f /srv/boxfuse",
  #     "aws --profile default configure set aws_access_key_id ${yandex_iam_service_account_static_access_key.sa-static-key.access_key}",
  #     "aws --profile default configure set aws_secret_access_key ${yandex_iam_service_account_static_access_key.sa-static-key.secret_key}",
  #     "aws configure set region ${local.region}",
  #     "aws --endpoint-url=https://storage.yandexcloud.net/ s3 cp  /srv/boxfuse/target/hello-1.0.war s3://${local.bucket_name}/"
  #   ]
  #   connection {
  #     type     = "ssh"
  #     user     = "ubuntu"
  #     private_key = "${file("${local.private_key}")}"
  #     host = "${yandex_compute_instance.vm-1.network_interface.0.nat_ip_address}"
  #   }
  # }
}

# resource "yandex_compute_instance" "vm-2" {
#   name = "terraform2"

#   resources {
#     cores  = 2
#     memory = 2
#   }

#   boot_disk {
#     initialize_params {
#       image_id = local.image_id
#     }
#   }

#   network_interface {
#     subnet_id = yandex_vpc_subnet.subnet-1.id
#     nat       = true
#   }

#   metadata = {
#     ssh-keys = "ubuntu:${file("${local.public_key}")}"
#   }


#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt update",
#       "sudo apt install tomcat9 awscli -y ",
#       "aws --profile default configure set aws_access_key_id ${yandex_iam_service_account_static_access_key.sa-static-key.access_key}",
#       "aws --profile default configure set aws_secret_access_key ${yandex_iam_service_account_static_access_key.sa-static-key.secret_key}",
#       "aws configure set region ${local.region}",
#       "aws --endpoint-url=https://storage.yandexcloud.net/ s3 cp s3://${local.bucket_name}/hello-1.0.war /var/lib/tomcat9/webapps/",
#       "mv /var/lib/tomcat9/webapps/hello-1.0.war /var/lib/tomcat9/webapps/hello.war",
#       "sudo systemctl restart tomcat9"
#     ]
#     connection {
#       type     = "ssh"
#       user     = "ubuntu"
#       private_key = "${file("${local.private_key}")}"
#       host = "${yandex_compute_instance.vm-2.network_interface.0.nat_ip_address}"
#     }
#   }
#   depends_on = [
#     yandex_compute_instance.vm-1
#   ]
# }

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

# output "internal_ip_address_vm_2" {
#   value = yandex_compute_instance.vm-2.network_interface.0.ip_address
# }


output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

# output "external_ip_address_vm_2" {
#   value = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
# }


