output "hostnames" {
  description = "Hostnames used in the property"
  value       = local.hostnames
}
/* output "dv_records" {
  description = "Our CNAME records for SBD will also contain the deployment status"
  value       = local.dv_records
} */
output "property_name" {
  description = "Name the property and cpcode"
  value       = local.property_name
}
output "security_policy" {
  description = "The security policy used for this property"
  value       = var.security_policy
}
