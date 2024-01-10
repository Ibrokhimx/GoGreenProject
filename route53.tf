resource "aws_route53_zone" "primary" {
  name = "uzinx.org"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "alias_route53_record" {
  zone_id = aws_route53_zone.primary.zone_id # Replace with your zone ID
  name    = "uzinx.org"                      # Replace with your name/domain/subdomain
  type    = "A"

  alias {
    name                   = aws_lb.WEB_alb.dns_name
    zone_id                = aws_lb.WEB_alb.zone_id
    evaluate_target_health = true
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "uzinx.org"
  type    = "A"
  ttl     = 300
  records = [aws_lb.WEB_alb.dns_name]
}
