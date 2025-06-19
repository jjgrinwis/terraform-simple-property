# map of akamai products, just to make life easy
variable "aka_products" {
  description = "map of akamai products"
  type        = map(string)

  default = {
    "ion" = "prd_Fresca"
    "dsa" = "prd_Site_Accel"
    "dd"  = "prd_Download_Delivery"
  }
}

variable "cpcode" {
  description = "Your unique Akamai CPcode name to be used with your property"
  type        = string
  default     = "jgrinwis"
}

# akamai product to use
variable "product_name" {
  description = "The Akamai delivery product name"
  type        = string
  default     = "dsa"
  validation {
    condition     = contains(keys(var.aka_products), lower(var.product_name))
    error_message = "Product name must be one of: ion, dsa, dd."
  }
}

variable "domain_suffix" {
  description = "edgehostname suffix"
  type        = string
  default     = "edgekey.net"
  validation {
    condition     = contains(["edgekey.net", "edgesuite.net"], var.domain_suffix)
    error_message = "Domain suffix must be one of: edgekey.net(ESSL), or edgesuite.net(FF)."
  }
}

# IPV4, IPV6_PERFORMANCE or IPV6_COMPLIANCE
variable "ip_behavior" {
  description = "use IPV4 to only use IPv4"
  type        = string
  default     = "IPV6_COMPLIANCE"
  validation {
    condition     = contains(["IPV4", "IPV6_PERFORMANCE", "IPV6_COMPLIANCE"], var.ip_behavior)
    error_message = "IP behavior must be one of: IPV4, IPV6_PERFORMANCE, IPV6_COMPLIANCE."
  }
}

# below some required input vars
variable "group_name" {
  description = "Akamai group to use this resource in"
  type        = string
  default     = "Akamai Demo-M-1YX7F61"
}

variable "email" {
  description = "Email address of users to inform when property gets created"
  type        = string
  default     = "test@test.nl"
  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.email))
    error_message = "Email must be a valid email address."
  }
}

variable "hostnames" {
  description = "A list of hostnames, comma separated. These hostnames will be used in the property and will be used to create CNAME records in EdgeDNS."
  type        = string
  validation {
    condition = alltrue([
      for fqdn in split(",", var.hostnames) :
      can(regex("^\\s*[a-zA-Z0-9-]+\\.[a-zA-Z0-9-]+\\.(p15|a15|r15|s15|t15)\\.great-demo\\.com\\s*$", fqdn))
    ])
    error_message = "Each entry in the comma separated list must be a valid hostname in the format hostname.subdomain.domain.tld (e.g., api.pnl-lsp-mservice.a15.great-demo.com)."
  }
}

# not setting a default, that should be done in the no code module to it can be easy switched in the UI if needed.
variable "security_policy" {
  description = "The security policy to use for the property"
  type        = string
  #default     = "low"
  validation {
    condition     = contains(["low", "medium", "high"], var.security_policy)
    error_message = "Security policy must be one of: low, medium, high."
  }
}
