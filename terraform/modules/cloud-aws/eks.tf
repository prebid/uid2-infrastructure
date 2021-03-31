resource "local_file" "providers" {
    content     = templatefile("${path.module}/templates/providers.tf.tpl", { regions = var.regions })
    filename = "${path.root}/../stage2/providers_generated.tf"
    file_permission = "0644"
}

resource "local_file" "eks_modules" {
    content     = templatefile("${path.module}/templates/eks.tf.tpl", { regions = var.regions, environment = var.environment })
    filename = "${path.root}/../stage2/eks_generated.tf"
    file_permission = "0644"
}
