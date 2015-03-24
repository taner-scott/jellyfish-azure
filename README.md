# jellyfish-azure

Jellyfish module for Microsoft Azure

# Features
Adds abilities to provision storage, VMs, and SQL Database Servers

## Installation
Include in the gemfile
```
gem 'jellyfish-fog-azure'
```
or download from GitHub and reference locally:
```
gem 'jellyfish-fog-azure', path: '../jellyfish-azure'
```

Add settings to your .env file:
```
    AZURE_SUB_ID                = YOUR AZURE SUBSCRIPTION ID
    AZURE_PEM_PATH              = YOUR AZURE PEM PATH
    AZURE_API_URL               = https://management.core.windows.net
```