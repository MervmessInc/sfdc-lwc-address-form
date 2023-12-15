# Address Input Form

An address input form that used ISO Country data to dynamically populated the address region / state field based on the selected country.

Supported countries ~ AT, AU, CA, DE, ES, GB, IE, IT, PL, US, ZA 


# Project Initialization

[Scratch Org Builder](https://github.com/MervmessInc/sfdx-scratch-org-builder)

```
sf-org_builder -a addrs_form -e <admin_email_addr> -d 30 --debug
```

# CCI ~ Data faker

[Install CumulusCI](https://cumulusci.readthedocs.io/en/stable/get-started.html)

```
cci org import <sfdx_alias> <cci_alias>
cci org default <cci_alias>
cci org list
cci task run update_admin_profile
cci task run account_faker
```
