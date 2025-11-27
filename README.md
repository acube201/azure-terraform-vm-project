# Azure Terraform VM Project

![Static Badge](https://img.shields.io/badge/Terraform%20-v1.13.3-%20purple)
![Static Badge](https://img.shields.io/badge/Azure-%20East%20us%202-blue)


This Terraform project automates the deployment of a **Windows Virtual Machine** on **Microsoft Azure** with the following resources:

- Resource Group  
- Virtual Network & Subnet  
- Public IP  
- Network Security Group (RDP enabled)  
- Network Interface  
- Windows VM (2019 Datacenter)

---

## Prerequisites

Before running this project, ensure you have:

- An active **Azure subscription**  
- **Terraform >= 1.5.x** installed  
- **Azure CLI** installed and logged in (`az login`)  
- **Git** (optional, for version control)

---

## Getting Started

1. **Clone the repository**

```bash
git clone https://github.com/acube201/azure-terraform-vm-project.git
cd azure-terraform-vm-project
