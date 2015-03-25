# jellyfish-azure

Jellyfish module for Microsoft Azure

# Features
Adds abilities to provision storage, VMs, and SQL Database Servers

## Installation
Include in the gemfile
```
gem 'jellyfish--azure'
```
or download from GitHub and reference locally:
```
gem 'jellyfish-azure', path: '../jellyfish-azure'
```

Add settings to your .env file:
```
    JF_AZURE_SUB_ID                = YOUR AZURE SUBSCRIPTION ID
    JF_AZURE_PEM_PATH              = YOUR AZURE PEM PATH
    JF_AZURE_API_URL               = https://management.core.windows.net
```