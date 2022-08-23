resource "null_resource" "ansible" {
  triggers = {
    abc = timestamp()
  }
  count        = length(data.aws_instances.instances.private_ips)
  provisioner "remote-exec" {
    connection {
      user     = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["SSH_USER"]
      password = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["SSH_PASS"]
      host     = element(data.aws_instances.instances.private_ips, count.index)
    }
    inline = [
      "ansible-pull -U https://github.com/krishnavamsi7616/roboshop-ansible.git roboshop.yml -e HOST=localhost -e ROLE=${var.COMPONENT} -e ENV=${var.ENV} -e DOCDB_ENDPOINT=${data.terraform_remote_state.mutable.outputs.DOCDB_ENDPOINT} -e REDIS_ENDPOINT=${data.terraform_remote_state.mutable.outputs.REDIS_ENDPOINT} -e MYSQL_ENDPOINT=${data.terraform_remote_state.mutable.outputs.MYSQL_ENDPOINT}",
    ]
  }
}