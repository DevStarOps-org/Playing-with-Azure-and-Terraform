# Create a CSR and generate a CA certificate
resource "tls_private_key" "domain" {
  algorithm = "RSA"
}

resource "tls_cert_request" "domain" {
  private_key_pem = tls_private_key.domain.private_key_pem

  subject {
    common_name  = var.hostname
    organization = "Gordon Beeming"
  }
}

resource "cloudflare_origin_ca_certificate" "domain" {
  csr                = tls_cert_request.domain.cert_request_pem
  hostnames          = [var.hostname]
  request_type       = "origin-rsa"
  requested_validity = 5475
}

resource "cloudflare_record" "main" {
  zone_id         = var.cloudflare_zone_id
  name            = var.dns_record
  value           = data.dns_a_record_set.app_ip_address.addrs[0]
  type            = "A"
  ttl             = 1
  proxied         = true
  allow_overwrite = false
}

resource "cloudflare_record" "txt-verify" {
  zone_id         = var.cloudflare_zone_id
  name            = "asuid.${var.dns_record}"
  value           = azurerm_linux_web_app.webapp.custom_domain_verification_id
  type            = "TXT"
  ttl             = 1
  proxied         = false
  allow_overwrite = false
}

resource "random_uuid" "pfx_pass" {
}

resource "pkcs12_from_pem" "domain_pfx" {
  password        = random_uuid.pfx_pass.result
  cert_pem        = cloudflare_origin_ca_certificate.domain.certificate
  private_key_pem = tls_private_key.domain.private_key_pem
}

resource "local_file" "result" {
  filename       = "resources/domain.pfx"
  content_base64 = pkcs12_from_pem.domain_pfx.result
}

variable "dns_record" {
  type = string
}

variable "hostname" {
  type = string
}
