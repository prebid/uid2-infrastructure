# Generare providers for all regions so we dont end up with orpha resources2

resource "local_file" "providers" {
    content     = templatefile("${path.module}/templates/providers.tf.tpl", { regions = local.aws_regions })
    filename = "${path.root}/../stage2/providers_generated.tf"
    file_permission = "0644"
}

resource "local_file" "eks_modules" {
    content     = templatefile("${path.module}/templates/eks.tf.tpl", { regions = var.regions, environment = var.environment, aws_acm_certificate = aws_acm_certificate.cert.arn, mission_control_project_id = var.mission_control_project_id })
    filename = "${path.root}/../stage2/eks_generated.tf"
    file_permission = "0644"
}
