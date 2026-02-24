# Enterprise-Grade Secure Azure Hub-and-Spoke Architecture

## 📖 Overview
This repository contains the complete Infrastructure as Code (Azure CLI / PowerShell) to deploy a highly secure, production-ready environment on Microsoft Azure. It implements a **Hub-and-Spoke** network topology, emphasizing strict traffic isolation, centralized firewall inspection, and Zero Trust principles for both IaaS and PaaS services.

This architecture is designed to host containerized microservices via Azure Kubernetes Service (AKS) with an Azure SQL backend, simulating a real-world hybrid enterprise environment.

## 🎯 Key Architectural Highlights

* **Hub-and-Spoke Topology:** Centralized shared services (Firewall, Bastion, App Gateway, VPN) in the Hub, isolating production workloads in the Spoke.
* **Centralized Egress & Forced Tunneling:** All outbound traffic from the AKS nodes and subnets is strictly routed through **Azure Firewall** via custom Route Tables (UDRs), preventing data exfiltration.
* **Zero Public Access for PaaS:** Azure SQL Database is completely hidden from the internet using **Azure Private Link (Private Endpoints)**, receiving a private IP within the Spoke VNet.
* **Advanced Hybrid DNS Resolution:** Utilizes Azure DNS Private Resolver (Inbound/Outbound Endpoints) paired with Private DNS Zones to enable seamless, bidirectional name resolution between On-Premises datacenters and Azure Private Endpoints.
* **Application Gateway Ingress Controller (AGIC):** Layer 7 load balancing directly integrated with AKS pods, leveraging Azure Application Gateway.
* **Automated TLS/SSL Management:** Integrated `cert-manager` for automatic Let's Encrypt certificate provisioning via HTTP-01 challenges.
* **Secure Container Registry & Autoscaling:** AKS securely pulls images from Azure Container Registry (ACR) over managed identities, coupled with Horizontal Pod Autoscaler (HPA) for dynamic workload scaling.
* **Hybrid Cloud Ready:** Includes a fully configured Site-to-Site VPN Gateway to simulate On-Premises connectivity to the Azure environment.
* **Secure Administration:** Azure Bastion deployed for secure, agentless RDP/SSH access to internal management jumpboxes without exposing public IPs.

## 🗺️ Architecture Diagram
![Enterprise Hub-and-Spoke Architecture](Images/Architecture-Diagram.svg)

### ⚙️ Deployment Phases

The deployment script is categorized into the following logical phases:

**Phase 1: Core Networking & Routing**
* Provision Hub and Spoke Virtual Networks (VNets).
* Establish bidirectional VNet Peering.
* Configure User-Defined Routes (UDRs) to enforce traffic flow through the Hub.
* Enable DNS Proxy on both Hub and Spoke VNets, routing all DNS queries through the Azure Firewall for inspection.

**Phase 2: Network Security & Firewall Protection**
* Deploy Azure Firewall with strict Network and Application Rules (allowing only specific FQDNs like ACR, Microsoft Updates, Let's Encrypt APIs, and essential NTP/DNS traffic).
* Create and attach granular Network Security Groups (NSGs) for Bastion, App Gateway, Management, AKS Nodes, Virtual Nodes, and Database subnets.

**Phase 3: Hybrid Connectivity & Management**
* Deploy Azure Bastion and a Windows Jumpbox for secure administration.
* Provision Azure VPN Gateway and establish a Site-to-Site connection with a simulated On-Premises environment.
* Provision simulated On-Premises infrastructure, including a Linux workload VM and a Windows Server acting as the On-Premises DNS Server.

**Phase 4: Container Orchestration (AKS & ACR)**
* Deploy Azure Container Registry (ACR) and securely import backend/frontend application images from public registries (Docker Hub).
* Provision a private Azure Kubernetes Service (AKS) cluster integrated with Azure CNI and Managed Identities.
* Implement Horizontal Pod Autoscaling (HPA) for dynamic workload management.

**Phase 5: Ingress & Certificate Automation**
* Deploy Azure Application Gateway and enable the AGIC add-on for the AKS cluster.
* Configure Azure DNS Zones and map custom domain records.
* Deploy `cert-manager` and `ClusterIssuer` to secure ingress traffic with Let's Encrypt SSL/TLS certificates.

**Phase 6: Secure Data Tier & Hybrid DNS Resolution**
* Deploy Azure SQL logical server with Public Network Access completely disabled.
* Provision a Private Endpoint and link it with Azure Private DNS Zones to resolve the database connection privately from the AKS cluster and Jumpbox.
* Deploy Azure DNS Private Resolver with Inbound and Outbound Endpoints in the Hub VNet.
* Configure the On-Premises Windows DNS Server with Conditional Forwarders targeting the Inbound Endpoint, allowing On-Premises workloads to natively resolve Azure Private Endpoints across the VPN tunnel.

## 🛠️ Prerequisites to Run the Script
Before executing the deployment scripts, ensure you have the following ready:
1.  **Azure Subscription:** With sufficient Quota (especially vCPUs for `Standard_B2s` or similar instances).
2.  **Azure CLI:** Installed and authenticated (`az login`).
3.  **Kubernetes CLI** (kubectl) installed for AKS management.
4.  **Registered Providers:** Ensure `Microsoft.Sql` and other necessary resource providers are registered in your subscription.
5.  **Domain Name:** A custom domain managed via Azure DNS for the Ingress/SSL configuration.

## 📝 Usage
1. Review the variables in **Step 1** of the script and update them to match your naming conventions, passwords, and custom domain (`$DomainName`).
2. Execute the script sequentially block by block using PowerShell or Bash.
3. Allow approximately 60-100 minutes for the full deployment (Firewall Azure, VPN Gateways and AKS clusters take the most time).


## 📸 Deployment Validation (Proof of Work)
*Below are the actual results and live tests from the Azure Portal and CLI after running the infrastructure scripts, proving the operational status of the architecture.*

<details>
<summary><b>1. Hybrid Cloud Connectivity (Site-to-Site VPN & Peering)</b></summary>
<br>
Demonstrates successful VNet peering between Hub and Spoke, the active Site-to-Site VPN Gateways, and a successful ICMP ping test from the Azure Jumpbox (10.0.10.4) strictly routed to the Simulated On-Premises server (172.16.1.4). It also verifies a secure SSH session established from Azure down to the On-Premises workload.
<br><br>

![VPN Gateways](Images/VPN-Site-to-Site.png)

![VNet Peering](Images/VNet-Peering.png)

![Ping Test On-Prem](Images/Test-VPN-Connection.png)

![SSH Azure to On-Prem](Images/SSH-Azure-to-On-Prem.png)

</details>

<details>
<summary><b>2. Network Routing & Forced Tunneling (UDRs & Firewall)</b></summary>
<br>
Demonstrates that all outbound traffic from the VNets is forcefully routed through the Hub Azure Firewall's private IP (10.0.1.4) for centralized inspection. Includes an outbound connectivity test verifying that the Jumpbox correctly routes traffic through the Firewall for Windows Updates.
<br><br>
  
![Route Table AKS](Images/RTB-AKS-Nodes.png)

![Route Table Database](Images/RTB-Database.png)

![Route Table Management](Images/RTB-Management.png)

![Route Table VPN_Gateway](Images/RTB-VPN-Gateway.png)

![Route Table Virtual Nodes](Images/RTB-Virtual-Nodes.png)

![Firewall Outbound Test](Images/Jumpbox-WindowUpdate-via-Firewall.png)

</details>

<details>
<summary><b>3. Strict Network Security Groups (NSGs)</b></summary>
<br>
Portal interface showcasing the precise configuration of automated Allow/Deny security rules, ensuring Zero Trust network access across all subnets.
<br><br>
  
![NSG AKS](Images/NSG-AKS-Nodes.png)

![NSG AppGw](Images/NSG-AppGw.png)

![NSG Bastion](Images/NSG-Bastion.png)

![NSG Database](Images/NSG-Database.png)

![NSG Management](Images/NSG-Management.png)

![NSG Virtual-Nodes](Images/NSG-Virtual-Nodes.png)

</details>

<details>
<summary><b>4. Advanced Hybrid DNS Resolution (Azure DNS Private Resolver)</b></summary>
<br>
Showcases the deployment of Azure DNS Private Resolver endpoints within the Hub VNet. It includes the On-Premises Windows DNS Server configuration, utilizing Conditional Forwarders to send queries to the Inbound Endpoint, enabling native cross-premises name resolution.
<br><br>
  
![Inbound Endpoint](Images/Inbound-Endpoint-at-Subnet-DNS-Resolver-Inbound.png)

![Outbound Endpoint](Images/Outbound-Endpoint-at-Subnet-DNS-Resolver-Outbound.png)

![On-Prem DNS Config](Images/Add-Inbound-Endpoint-IP-to-DNS-Server.png)

</details>

<details>
<summary><b>5. Secure PaaS Data Tier (Azure Private Link & SQL)</b></summary>
<br>
Confirms that the Azure SQL Server is completely hidden from the public internet. Evidences include the Private DNS Zone mappings and successful DNS resolution & TCP connectivity tests (port 1433) originating from both the Azure Jumpbox and the On-Premises Linux VM through the Azure Firewall.
<br><br>
  
![Link DNS to VNets](Images/Link-Private-DNS-Zone-to-Hub&Spoke-Vnet.png)

![DNS Record SQL](Images/Record-Private-DNS-Zone.png)

![Jumpbox to SQL](Images/Jumpbox-to-SQL-Server.png)

![DNS Resolution SQL from On-Prem](Images/DNS-Resolution-OnPrem-to-SQL-PrivateEndpoint.png)

![Test Traffic On-Prem to SQL](Images/Test-Traffic-On-Prem-to-SQL-Server-via-Firewall.png)

</details>

<details>
<summary><b>6. Secure Container Registry Authentication (ACR)</b></summary>
<br>
Validation that the Spoke Azure Kubernetes Service (AKS) cluster possesses the correct managed identity permissions to successfully resolve and pull container images from the centralized Azure Container Registry (ACR).
<br><br>
  
![AKS Connect ACR](Images/AKS-connect-ACR.png)

</details>

<details>
<summary><b>7. Application Delivery & Automated SSL/TLS</b></summary>
<br>
Proves the successful deployment of the microservices via AGIC. It shows the valid Let's Encrypt SSL certificates dynamically provisioned by cert-manager, and the live web interfaces of the Frontend and Backend pods accessed via the custom public domain.
<br><br>
  
![SSL Certificate Ready](Images/SSL.png)

![Frontend Live](Images/cody-frontend.png)

![Vietnam Live](Images/cody-vietnam.png)

![Backend Live](Images/cody-backend.png)

</details>

<details>
<summary><b>8. Kubernetes Workload Auto-scaling (HPA)</b></summary>
<br>
Live CLI output confirming that the Horizontal Pod Autoscaler (HPA) is actively monitoring CPU/Memory metrics and scaling the microservice replicas dynamically to handle load changes.
<br><br>
  
![HPA Status](Images/Horizontal-Pod-Autoscaler.png)

</details>
