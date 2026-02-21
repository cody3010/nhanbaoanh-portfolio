# Enterprise-Grade Secure Azure Hub-and-Spoke Architecture

## 📖 Overview
This repository contains the complete Infrastructure as Code (Azure CLI / PowerShell) to deploy a highly secure, production-ready environment on Microsoft Azure. It implements a **Hub-and-Spoke** network topology, emphasizing strict traffic isolation, centralized firewall inspection, and Zero Trust principles for both IaaS and PaaS services.

This architecture is designed to host containerized microservices via Azure Kubernetes Service (AKS) with an Azure SQL backend, simulating a real-world hybrid enterprise environment.

## 🎯 Key Architectural Highlights

* **Hub-and-Spoke Topology:** Centralized shared services (Firewall, Bastion, App Gateway, VPN) in the Hub, isolating production workloads in the Spoke.
* **Centralized Egress & Forced Tunneling:** All outbound traffic from the AKS nodes and subnets is strictly routed through **Azure Firewall** via custom Route Tables (UDRs), preventing data exfiltration.
* **Zero Public Access for PaaS:** Azure SQL Database is completely hidden from the internet using **Azure Private Link (Private Endpoints)**, receiving a private IP within the Spoke VNet.
* **Application Gateway Ingress Controller (AGIC):** Layer 7 load balancing directly integrated with AKS pods, leveraging Azure Application Gateway.
* **Automated TLS/SSL Management:** Integrated `cert-manager` for automatic Let's Encrypt certificate provisioning via HTTP-01 challenges.
* **Hybrid Cloud Ready:** Includes a fully configured Site-to-Site VPN Gateway to simulate On-Premises connectivity to the Azure environment.
* **Secure Administration:** Azure Bastion deployed for secure, agentless RDP/SSH access to internal management jumpboxes without exposing public IPs.

## 🗺️ Architecture Diagram
![Enterprise Hub-and-Spoke Architecture](Images/Architecture-Diagram.svg)

## 🚀 Deployment Phases

The deployment script (divided into 39 steps) is categorized into the following logical phases:

### Phase 1: Core Networking & Routing
* Provision Hub and Spoke Virtual Networks (VNets).
* Establish bidirectional VNet Peering.
* Configure User-Defined Routes (UDRs) to enforce traffic flow through the Hub.

### Phase 2: Network Security & Firewall Protection
* Deploy Azure Firewall with strict Network and Application Rules (allowing only specific FQDNs like ACR, Microsoft Updates, and Let's Encrypt APIs).
* Create and attach granular Network Security Groups (NSGs) for Bastion, App Gateway, Management, AKS Nodes, and Database subnets.

### Phase 3: Hybrid Connectivity & Management
* Deploy Azure Bastion and a Windows Jumpbox for secure administration.
* Provision Azure VPN Gateway and establish a Site-to-Site connection with a simulated On-Premises environment.

### Phase 4: Container Orchestration (AKS & ACR)
* Deploy Azure Container Registry (ACR) and import backend/frontend application images.
* Provision a private Azure Kubernetes Service (AKS) cluster integrated with Azure CNI and Managed Identities.
* Implement Horizontal Pod Autoscaling (HPA) for dynamic workload management.

### Phase 5: Ingress & Certificate Automation
* Deploy Azure Application Gateway and enable the AGIC add-on for the AKS cluster.
* Configure Azure DNS Zones and map custom domain records.
* Deploy `cert-manager` and `ClusterIssuer` to secure ingress traffic with Let's Encrypt SSL/TLS certificates.

### Phase 6: Secure Data Tier
* Deploy Azure SQL logical server with **Public Network Access completely disabled**.
* Create an Azure SQL Database.
* Provision a Private Endpoint and link it with Azure Private DNS Zones to resolve the database connection privately from the AKS cluster and Jumpbox.

## 🛠️ Prerequisites to Run the Script
If you wish to deploy this architecture, ensure you have the following prerequisites:
1.  **Azure Subscription:** With sufficient Quota (especially vCPUs for `Standard_B2s` or similar instances).
2.  **Azure CLI:** Installed and authenticated (`az login`).
3.  **Kubectl:** Installed to manage the AKS cluster.
4.  **Registered Providers:** Ensure `Microsoft.Sql` and other necessary resource providers are registered in your subscription.
5.  **Domain Name:** A custom domain managed via Azure DNS for the Ingress/SSL configuration.

## 📝 Usage
1. Review the variables in **Step 1** of the script and update them to match your naming conventions, passwords, and custom domain (`$DomainName`).
2. Execute the script sequentially block by block using PowerShell or Bash.
3. Allow approximately 45-60 minutes for the full deployment (VPN Gateways and AKS clusters take the most time).


## 📸 Deployment Validation (Proof of Work)
*Below are the actual results from the Azure Portal and AKS Terminal after running the infrastructure scripts.*

<details>
<summary><b>1. Network Routing & Forced Tunneling (UDRs)</b></summary>
<br>
Chứng minh toàn bộ traffic từ Spoke được ép đi qua IP của Hub Firewall (10.0.1.4).
<br><br>
![Route Table AKS](./images/RTB-AKS-Nodes.png)
![Route Table Database](./images/RTB-Database.png)
</details>

<details>
<summary><b>2. Strict Network Security Groups (NSGs)</b></summary>
<br>
Giao diện portal thể hiện các rule chặn/thả tự động được tạo ra chuẩn xác.
<br><br>
![NSG Database](./images/NSG-Database.png)
![NSG AKS](./images/NSG-AKS-Nodes.png)
</details>

<details>
<summary><b>3. AKS Horizontal Pod Autoscaler (HPA)</b></summary>
<br>
Trạng thái các Pod tự động co giãn dựa trên mức tiêu thụ CPU/RAM.
<br><br>
![HPA Status](./images/Horizontal-Pod-Autoscaler.png)
</details>
