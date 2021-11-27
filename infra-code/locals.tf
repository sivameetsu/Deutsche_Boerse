locals {
  user_data = base64encode(templatefile("${path.module}/userdata.sh.tpl", {
  hostname  = var.hostname
    }
  ))
}
