resource "aws_acm_certificate" "cert" {
  domain_name       = trimsuffix(data.google_dns_managed_zone.uid2-0.dns_name, ".")
  subject_alternative_names = [ "aws.${trimsuffix(data.google_dns_managed_zone.uid2-0.dns_name, ".")}" ]
  validation_method = "DNS"

  tags = {
    environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_dns_record_set" "uid2-0_root" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  name = each.value.name
  type = each.value.type
  ttl  = 60

  managed_zone =  data.google_dns_managed_zone.uid2-0.name
  rrdatas = [ each.value.record ]
}
