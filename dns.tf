locals {
  # Get the "subdomain" — everything except the first part of the hostname
  sub_domain = join(".", slice(split(".", local.hostnames[0]), 1, length(split(".", local.hostnames[0]))))

  # zone based on last two parts of the first hostname
  zone = regex("[^.]+\\.[^.]+$", local.hostnames[0])
}

# just add some CNAMEs for the SBD certificates. Make sure you have the credentials to also update DNS records!
resource "akamai_dns_record" "dv_cname" {

  # loop through each item in our known hostnames set
  for_each = toset(local.hostnames)

  # get the key or value, same in this instance 
  zone = regex("[^.]+\\.[^.]+$", each.key)
  name = "_acme-challenge.${each.value}"

  # let's lookup target value from our map of maps with value from hostnames[] as key
  target = [lookup(local.dv_records["_acme-challenge.${each.value}"], "target")]

  recordtype = "CNAME"
  ttl        = 60
}



# create a SPF record for the subdomain
resource "akamai_dns_record" "spf" {
  zone       = local.zone
  name       = local.sub_domain
  target     = ["v=spf1 -all"]
  recordtype = "TXT"
  ttl        = 3600
}

# create a dmarc record for the subdomain
resource "akamai_dns_record" "dmarc" {
  zone       = local.zone
  name       = "_dmarc.${local.sub_domain}"
  target     = ["parkeddomain.dmarc.postnl.nl"]
  recordtype = "CNAME"
  ttl        = 3600
}

# create a tlsrpt record for the subdomain
resource "akamai_dns_record" "tlsrpt" {
  zone       = local.zone
  name       = "_smtp._tls.${local.sub_domain}"
  target     = ["tlsrpt.postnl.nl"]
  recordtype = "CNAME"
  ttl        = 3600
}
