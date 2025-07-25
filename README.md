# Terraform Simple Property - Akamai Configuration

This Terraform configuration manages Akamai CDN properties with integrated DNS management, designed for creating and configuring delivery properties with automatic certificate provisioning and DNS record creation.

## Overview

This configuration creates:

- Akamai delivery property with dynamic hostname support
- Will create one unique Akamai edgehostname per property
- Will create unique CP Code per property which will be the same as property name.
- Automatic SSL certificate provisioning via the Secure By Default option (SBD).
- DNS records including CNAME for SBD certificate approval, SPF, DMARC, and TLSRPT records
- Support for multiple Akamai products (ION, DSA, Download Delivery)

## Features

- **Dynamic Hostname Processing**: Accepts comma-separated hostnames and automatically processes them
- **Flexible Product Support**: Supports ION, DSA, and Download Delivery products
- **Automatic Certificate Management**: Handles SSL certificate provisioning with domain validation
- **DNS Integration**: Creates necessary DNS records for certificate validation and email security
- **Security Policy Configuration**: Configurable security levels (low, medium, high) (future use)
- **Network Selection**: Supports both Enhanced Secure (edgekey.net) and FreeFlow (edgesuite.net) networks

## Prerequisites

1. **Akamai CLI and Credentials**:

   - Install Akamai CLI (optional to get group name and check permissions)
   - Configure edgerc file at `~/.edgerc` with the correct section
   - Ensure you have appropriate permissions for Property Manager (PAPI) and EdgeDNS

2. **Terraform**:
   - Terraform >= 0.14
   - Akamai Provider >= 8.0.0

## File Structure

```
.
├── main.tf           # Main resource definitions
├── provider.tf       # Akamai provider configuration
├── variables.tf      # Input variable definitions
├── outputs.tf        # Output values
├── dns.tf            # DNS record management
├── terraform.tfvars  # Variable values (customize this)
└── template/         # Property rule templates (referenced but not included)
    └── rules.tftpl   # Property rules template with dynamic hostname section
```

## Configuration

### Required Variables

All defined variables have a default value. They can be overwritten using the local [terraform.tfvars file or set ENV vars](https://developer.hashicorp.com/terraform/language/values/variables#environment-variables).

Copy and customize the `terraform.tfvars` file if you want to use other

```hcl
# Akamai group name
group_name = "Your-Akamai-Group-Name"

# Email for notifications
email = "your-email@domain.com"

# Domain suffix (edgekey.net for Enhanced Secure, edgesuite.net for FreeFlow)
domain_suffix = "edgekey.net"

# CP Code name (will reuse if exists)
cpcode = "your-cpcode-name"

# Hostnames (comma-separated list)
hostnames = "api.service.a15.example.com, api.service.p15.example.com"

# Security policy level
security_policy = "medium"

# Product type
product_name = "dsa"

# Edge Hostname
edge_hostname = "my.edge.hostname.edgekey.net"
```

## Usage

1. **Initialize Terraform**:

   ```bash
   terraform init
   ```

2. **Customize Configuration**:
   Edit `terraform.tfvars` with your specific values.

3. **Plan Deployment**:

   ```bash
   terraform plan
   ```

4. **Deploy**:

   ```bash
   terraform apply
   ```

5. **View Outputs**:
   ```bash
   terraform output
   ```

## Outputs

| Output            | Description                 |
| ----------------- | --------------------------- |
| `hostnames`       | List of processed hostnames |
| `property_name`   | Generated property name     |
| `security_policy` | Applied security policy     |

## DNS Records Created

The configuration automatically creates:

- **CNAME Records**: For certificate domain validation (`_acme-challenge.*`)
- **SPF Record**: Email security (`v=spf1 -all`)
- **DMARC Record**: Email authentication policy
- **TLSRPT Record**: TLS reporting configuration

## Important Notes

1. **Template Dependency**: The configuration references `template/rules.tftpl` which should contain your property rules template.

2. **DNS Permissions**: Ensure your Akamai credentials have EdgeDNS permissions for automatic DNS record creation.

3. **Hostname Format**: Hostnames must follow the pattern `hostname.subdomain.(p15|a15|r15|s15|t15).domain.tld`.

4. **CP Code**: The configuration will create one new CP Code per property.

5. **Certificate Provisioning**: Uses Akamai's default certificate provisioning (SBD) with domain validation.

## Troubleshooting

- **Permission Errors**: Verify EdgeRC credentials and API permissions
- **DNS Validation Issues**: Ensure DNS zone exists and is manageable via EdgeDNS. We're only managing records, not the zone itself.
- **Template Errors**: Verify the `template/rules.tftpl` file exists and is properly formatted
- **Hostname Validation**: Check that hostnames match the required pattern

## Security Considerations

- Store EdgeRC credentials securely. They will rotate after a certain period of time, be aware of that.
- Use appropriate security policy levels based on your requirements.

## Support

For issues related to:

- Terraform configuration: Check Terraform documentation
- Akamai Provider: Refer to the [Akamai Terraform Provider documentation](https://registry.terraform.io/providers/akamai/akamai/latest/docs)
