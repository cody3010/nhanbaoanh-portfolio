# ====================================================
# 1. KHAI BAO BIEN (Mo hinh Hub-and-Spoke)
# ====================================================

$Location = "KoreaCentral"
$HubRG = "RG-Hub-Share-Services"
$HubVNetName = "VNet-Hub-Shared-Services"
$HubAppGwName = "Hub-AppGw-KR"
$HubDNSResolverName = "Hub-DNS-Resolver"
$HubAppGwPublicIpName = "Hub-AppGw-PIP"
$HubAzureFirewallPublicIpName = "Hub-Firewall-PIP"
$HubACRName = "codyregistry2026"
$HubDomainName = "codyaws.cloud"
$HubSubnetAppGwName = "Subnet-AppGw"
$HubSubnetShareDataName = "Subnet-Share-Data"
$HubSubnetDNSResolverInboundName = "Subnet-DNS-Resolver-Inbound"
$HubSubnetDNSResolverOutboundName = "Subnet-DNS-Resolver-Outbound"
$HubSubnetMgmtName = "Subnet-Management"
$VmName = "VM-Jumpbox-Win"
$AdminUser = "codyadmin"
$AdminPass = "CodyP@ssw0rd2026!"


$SpokeProdRG = "RG-Spoke-Production"
$SpokeProdNodeRG = "RG-AKS-Nodes"
$SpokeProdClusterName = "Spoke-AKS-Prod-KR-01" 
$SpokeProdVNetName = "Spoke-Production-VNet"
$SpokeProdSubnetAKSNodesName = "Subnet-AKS-Nodes"
$SpokeProdSubnetVirtualNodesName = "Subnet-Virtual-Nodes"
$SpokeProdSubnetDatabaseName = "Subnet-Database"
$SpokeProdSubnetPaaSServiceName = "Subnet-PaaS-Service"


$DomainName = "codyaws.cloud"
$PrivateDomainName = "private.codyaws.cloud"
$HubDNSResolverInboundEndpointName = "Inbound-Endpoint-Listener"


$NsgBastionName = "NSG-Bastion"
$NsgAppGwName = "NSG-AppGw"
$NsgMgmtName = "NSG-Management"
$NsgDatabaseName = "NSG-Database"
$NsgAksName = "NSG-AKS-Nodes"
$NsgVirtualName = "NSG-Virtual-Nodes"
$NsgDnsResolverInboundName = "NSG-DNS-Resolver-Inbound"


$HubRouteTableMgmtName = "HubRouteTableManagement"
$HubRouteTableGatewayName = "HubRouteTableGatewaySubnet"
$SpokeRouteTableAKSNodesName = "SpokeRouteTableAKSNodes"
$SpokeRouteTableVirtualNodesName = "SpokeRouteTableVirtualNodes"
$SpokeRouteTableDatabaseName = "SpokeRouteTableDatabase"


$HubAzureFirewallSubnetPrefix = "10.0.1.0/24"
$HubGatewaySubnetPrefix = "10.0.2.0/24"
$HubSubnetBastionPrefix = "10.0.3.0/24"
$HubSubnetDNSResolverInboundPrefix = "10.0.4.0/24"
$HubSubnetMgmtPrefix = "10.0.10.0/24"   
$HubSubnetAppGwPrefix = "10.0.16.0/24"
$HubSubnetShareDataPrefix = "10.0.50.0/24"


$SpokeSubnetAKSPrefix = "10.1.0.0/20" 
$SpokeSubnetDatabasePrefix = "10.1.16.0/24"
$SpokeSubnetPaaSServicePrefix =  "10.1.17.0/24"
$SpokeSubnetVirtualPrefix = "10.1.18.0/24"


$OnPremRG = "RG-Simulated-OnPrem"
$OnPremLocation = "SoutheastAsia"
$OnPremVNetName = "VNet-OnPrem-Datacenter"
$OnPremVNetPrefix = "172.16.0.0/16"
$OnPremGatewaySubnetPrefix = "172.16.255.0/27"
$OnPremWorkloadSubnetPrefix = "172.16.1.0/24"
$OnPremPipName = "OnPrem-VPN-PIP"
$OnPremGwName = "OnPrem-VPN-Gateway"


$AzureFirewall  = "Hub-Azure-Firewall"
$RouteTableName = "Spoke-RouteTable-To-Hub-Firewall"
$SourceSpokes = "10.1.0.0/16 10.2.0.0/16"


$InboundEndpointName = "Inbound-EP"
$OutboundEndpointName = "Outbound-EP"


# ====================================================
# 2. TAO RESOURCE GROUP & VNET (Hub - Spoke)
# ====================================================

az group create `
--name $HubRG `
--location $Location

az network vnet create `
  --resource-group $HubRG `
  --name $HubVNetName `
  --address-prefix 10.0.0.0/16 `
  --location $Location


az group create `
--name $SpokeProdRG `
--location $Location

az network vnet create `
  --resource-group $SpokeProdRG `
  --name $SpokeProdVNetName `
  --address-prefix 10.1.0.0/16 `
  --location $Location



# ====================================================
# 3. Tao cac SUBNET tai HUB
# ====================================================

# Tao AzureFirewallSubnet
az network vnet subnet create `
  --resource-group $HubRG `
  --vnet-name $HubVNetName `
  --name "AzureFirewallSubnet" `
  --address-prefix "10.0.1.0/24"
 
 

# Tao GatewaySubnet 
az network vnet subnet create `
  --resource-group $HubRG `
  --vnet-name $HubVNetName `
  --name "GatewaySubnet" `
  --address-prefix "10.0.2.0/24"



# Tao Subnet Azure Bastion 
az network vnet subnet create `
  --resource-group $HubRG `
  --vnet-name $HubVNetName `
  --name "AzureBastionSubnet" `
  --address-prefix "10.0.3.0/24"
  
  
  
# Tao Subnet Management
az network vnet subnet create `
  --resource-group $HubRG `
  --vnet-name $HubVNetName `
  --name $HubSubnetMgmtName `
  --address-prefix $HubSubnetMgmtPrefix
  
  
  
# Tao Subnet Application-Gateway 
 az network vnet subnet create `
  --resource-group $HubRG `
  --vnet-name $HubVNetName `
  --name $HubSubnetAppGwName `
  --address-prefix "10.0.16.0/24"



# Tao Subnet Share-Data 
 az network vnet subnet create `
  --resource-group $HubRG `
  --vnet-name $HubVNetName `
  --name $HubSubnetShareDataName `
  --address-prefix "10.0.50.0/24"




# ====================================================
# 4. Tao cac SUBNET tai SPOKE
# ====================================================

 # Tao Subnet "Subnet-AKS-Nodes"
az network vnet subnet create `
  --resource-group $SpokeProdRG `
  --vnet-name $SpokeProdVNetName `
  --name $SpokeProdSubnetAKSNodesName `
  --address-prefix "10.1.0.0/20"


 # Tao Subnet "Subnet-Database"
az network vnet subnet create `
  --resource-group $SpokeProdRG `
  --vnet-name $SpokeProdVNetName `
  --name $SpokeProdSubnetDatabaseName `
  --address-prefix "10.1.16.0/24"


 # Tao Subnet "Subnet-PaaS-Service"
az network vnet subnet create `
  --resource-group $SpokeProdRG `
  --vnet-name $SpokeProdVNetName `
  --name $SpokeProdSubnetPaaSServiceName `
  --address-prefix "10.1.17.0/24"


 # Tao Subnet "Subnet-Virtual-Nodes"
az network vnet subnet create `
  --resource-group $SpokeProdRG `
  --vnet-name $SpokeProdVNetName `
  --name $SpokeProdSubnetVirtualNodesName `
  --address-prefix "10.1.18.0/24"




# ==================================================================================
# 5. Tao VNET PEERING giua "Hub-Share-Services" & "Spoke-Production"
# ==================================================================================

# Lấy ID của 2 VNet
$HubVNetId = $(az network vnet show `
--resource-group $HubRG `
--name $HubVNetName `
--query id `
--output tsv)



$SpokeVNetId = $(az network vnet show `
--resource-group $SpokeProdRG `
--name $SpokeProdVNetName `
--query id `
--output tsv)



# Peering từ Hub sang Spoke
az network vnet peering create `
  --resource-group $HubRG `
  --vnet-name $HubVNetName `
  --name "Hub-to-Spoke" `
  --remote-vnet $SpokeVNetId `
  --allow-vnet-access `
  --allow-forwarded-traffic



# Peering từ Spoke sang Hub
az network vnet peering create `
  --resource-group $SpokeProdRG `
  --vnet-name $SpokeProdVNetName `
  --name "Spoke-to-Hub" `
  --remote-vnet $HubVNetId `
  --allow-vnet-access `
  --allow-forwarded-traffic





# ====================================================
# 6. TAO PUBLIC IP & AZURE FIREWALL
# ====================================================

$HubAzureFirewallPublicIpName = "Hub-Firewall-PIP"

# Tao Public IP cho Firewall
az network public-ip create `
  --resource-group $HubRG `
  --name $HubAzureFirewallPublicIpName `
  --sku Standard `
  --allocation-method Static `
  --location $Location



# Tao Azure Firewall
az extension add --name azure-firewall -y
az network firewall create `
  --resource-group $HubRG `
  --name $AzureFirewall `
  --location $Location `
  --sku AZFW_VNet `
  --enable-dns-proxy true `
  --dns-servers "" `
  --tier Standard



# Gan Public IP vao Firewall
az network firewall ip-config create `
  --resource-group $HubRG `
  --firewall-name $AzureFirewall `
  --name "FW-IpConfig" `
  --public-ip-address $HubAzureFirewallPublicIpName `
  --vnet-name $HubVNetName



# Kiem tra trang thai AzureFirewall
az network firewall show `
  --resource-group $HubRG `
  --name $AzureFirewall `
  --query provisioningState `
  --output tsv



# Lay Private IP Firewall
$FirewallPrivateIP = $(az network firewall show `
  --resource-group $HubRG `
  --name $AzureFirewall `
  --query "ipConfigurations[0].privateIPAddress" `
  -o tsv)




# ====================================================
# 7. CAU HINH RULE AZURE FIREWALL (NETWORK RULES)
# ====================================================

# Cho phep On-Prem ket noi toi Database
az network firewall network-rule create `
  --resource-group $HubRG `
  --firewall-name $AzureFirewall `
  --collection-name "OnPrem-To-Database" `
  --name "Allow-OnPrem-SQL" `
  --protocols TCP `
  --source-addresses "172.16.0.0/16" `
  --destination-addresses $SpokeSubnetDatabasePrefix `
  --destination-ports 1433 `
  --action Allow `
  --priority 100



# Cho phep Remote tu Jumpbox xuong On-Prem
az network firewall network-rule create `
  --resource-group $HubRG `
  --firewall-name $AzureFirewall `
  --collection-name "Mgmt-To-OnPrem-Remote" `
  --name "Allow-Jumpbox-Remote" `
  --protocols TCP `
  --source-addresses $HubSubnetMgmtPrefix `
  --destination-addresses "172.16.0.0/16" `
  --destination-ports 3389 22 `
  --action Allow `
  --priority 150



# Cho phep Ping (ICMP) tu Jumpbox xuong On-Prem
az network firewall network-rule create `
  --resource-group $HubRG `
  --firewall-name $AzureFirewall `
  --collection-name "Mgmt-To-OnPrem-Ping" `
  --name "Allow-Jumpbox-Ping" `
  --protocols ICMP `
  --source-addresses $HubSubnetMgmtPrefix `
  --destination-addresses "172.16.0.0/16" `
  --destination-ports "*" `
  --action Allow `
  --priority 155



# Cho phep dong bo thoi gian (NTP)
az network firewall network-rule create `
  --resource-group $HubRG `
  --firewall-name $AzureFirewall `
  --collection-name "NTP-Time-Sync" `
  --name "Allow-NTP" `
  --protocols UDP `
  --source-addresses $SpokeSubnetAKSPrefix $SpokeSubnetVirtualPrefix $HubSubnetMgmtPrefix `
  --destination-addresses "*" `
  --destination-ports 123 `
  --action Allow `
  --priority 200  




# =========================================================
# 8. CAU HINH RULE AZURE FIREWALL (APPLICATION RULES)
# =========================================================

# Cho phep Nodes giao tiep voi Core Azure (tag: AzureKubernetesService)
az network firewall application-rule create `
  --resource-group $HubRG `
  --firewall-name $AzureFirewall `
  --collection-name "Nodes-Core-Services" `
  --name "Allow-Nodes-Tag" `
  --protocols "http=80" "https=443" `
  --source-addresses $SpokeSubnetAKSPrefix $SpokeSubnetVirtualPrefix `
  --fqdn-tags "AzureKubernetesService" `
  --action Allow `
  --priority 200
  
  
  
# Cho phep update OS Linux (Ubuntu)
  az network firewall application-rule create `
  --resource-group $HubRG `
  --firewall-name $AzureFirewall `
  --collection-name "Linux-OS-Update" `
  --name "Allow-Ubuntu-Update" `
  --protocols "http=80" "https=443" `
  --source-addresses $SpokeSubnetAKSPrefix $SpokeSubnetVirtualPrefix $HubSubnetMgmtPrefix `
  --target-fqdns "azure.archive.ubuntu.com" "security.ubuntu.com" "packages.microsoft.com" `
  --action Allow `
  --priority 205
  
  
  
# Cho phep update OS Windows
az network firewall application-rule create `
  --resource-group $HubRG `
  --firewall-name $AzureFirewall `
  --collection-name "Windows-OS-Update" `
  --name "Allow-Windows-Update" `
  --protocols "http=80" "https=443" `
  --source-addresses $SpokeSubnetAKSPrefix $SpokeSubnetVirtualPrefix $HubSubnetMgmtPrefix `
  --fqdn-tags "WindowsUpdate" `
  --action Allow `
  --priority 210

  
   
# Cho phep AKS & Virtual Nodes pull image tu ACR
az network firewall application-rule create `
  --resource-group $HubRG `
  --firewall-name $AzureFirewall `
  --collection-name "Nodes-To-ACR" `
  --name "Allow-ACR" `
  --protocols "https=443" `
  --source-addresses $SpokeSubnetAKSPrefix $SpokeSubnetVirtualPrefix `
  --target-fqdns "*.azurecr.io" "mcr.microsoft.com" "*.data.mcr.microsoft.com" `
  --action Allow `
  --priority 215



# Cho phep ACR truy cap vao Blob Storage
az network firewall application-rule create `
   --resource-group $HubRG `
   --firewall-name $AzureFirewall `
   --collection-name "Nodes-To-ACR" `
   --name "Allow-ACR-Blob" `
   --protocols "https=443" `
   --source-addresses $SpokeSubnetAKSPrefix $SpokeSubnetVirtualPrefix `
   --target-fqdns "*.blob.core.windows.net"



# Cho phep ACR truy cap vao cac Public Registry pho bien
az network firewall application-rule create `
  --resource-group $HubRG `
  --firewall-name $AzureFirewall `
  --collection-name "Public-Container-Registries" `
  --name "Allow-Public-Registries" `
  --protocols "https=443" `
  --source-addresses $SpokeSubnetAKSPrefix $SpokeSubnetVirtualPrefix `
  --target-fqdns "quay.io" "*.quay.io" "ghcr.io" "registry.k8s.io" "*.docker.io" "docker.io" `
  --action Allow `
  --priority 220



# Cho phep cac Pod ben trong AKS giap tiep voi Kubernetes API Server
az network firewall network-rule create `
  --resource-group $HubRG `
  --firewall-name $AzureFirewall `
  --collection-name "AKS-API-HTTPS" `
  --name "Allow-API-443" `
  --protocols TCP `
  --source-addresses $SpokeSubnetAKSPrefix $SpokeSubnetVirtualPrefix `
  --destination-addresses "AzureCloud.KoreaCentral" `
  --destination-ports 443 `
  --action Allow `
  --priority 240



# Cho phep AKS goi API Let's Encrypt
az network firewall application-rule create `
  --resource-group $HubRG `
  --firewall-name $AzureFirewall `
  --collection-name "CertManager-LetsEncrypt" `
  --name "Allow-LetsEncrypt-API" `
  --protocols "https=443" "http=80" `
  --source-addresses $SpokeSubnetAKSPrefix $SpokeSubnetVirtualPrefix `
  --target-fqdns "acme-v02.api.letsencrypt.org" "acme-staging-v02.api.letsencrypt.org" `
  --action Allow `
  --priority 255
  
  

# Cho phep cac Nodes co quyen truy cap nguoc vao domain (self-check)   
az network firewall application-rule create `
  --resource-group $HubRG `
  --firewall-name $AzureFirewall `
  --collection-name "Self-Check-Domains" `
  --name "Allow-App-Domains" `
  --protocols "http=80" "https=443" `
  --source-addresses $SpokeSubnetAKSPrefix $SpokeSubnetVirtualPrefix `
  --target-fqdns "codyaws.cloud" "*.codyaws.cloud" `
  --action Allow `
  --priority 260





# ====================================
# 9. Tao NSG-Bastion va add rule
# ====================================

$NsgBastionName = "NSG-Bastion"

az network nsg create `
--resource-group $HubRG `
--name $NsgBastionName `
--location $Location



# Cho phep ngoai INTERNET di vao
az network nsg rule create `
--resource-group $HubRG `
--nsg-name $NsgBastionName `
--name Allow_Https_Inbound `
--priority 120 `
--source-address-prefixes Internet `
--destination-port-ranges 443 `
--access Allow `
--protocol Tcp `
--direction Inbound



# Cho phep Gateway Manager di vao, de Azure quan ly
az network nsg rule create `
--resource-group $HubRG `
--nsg-name $NsgBastionName `
--name Allow_GatewayManager_Inbound `
--priority 130 `
--source-address-prefixes GatewayManager `
--destination-port-ranges 443 `
--access Allow `
--protocol Tcp `
--direction Inbound



# Cho phep Azure Health Probe kiem tra Bastion
az network nsg rule create `
--resource-group $HubRG `
--nsg-name $NsgBastionName `
--name Allow_LoadBalancer_Inbound `
--priority 140 `
--source-address-prefixes AzureLoadBalancer `
--destination-port-ranges 443 `
--access Allow `
--protocol Tcp `
--direction Inbound



# Cho phep cac dich vu noi bo cua Bastion noi chuyen voi nhau
az network nsg rule create `
--resource-group $HubRG `
--nsg-name $NsgBastionName `
--name Allow_Bastion_Host_Communication `
--priority 150 `
--source-address-prefixes VirtualNetwork `
--destination-port-ranges 8080 5701 `
--access Allow `
--protocol Tcp `
--direction Inbound



# Cho phep Remote / SSH
az network nsg rule create `
--resource-group $HubRG `
--nsg-name $NsgBastionName `
--name Allow_Ssh_Rdp_Outbound `
--priority 100 `
--source-address-prefixes "*" `
--destination-address-prefixes VirtualNetwork `
--destination-port-ranges 22 3389 `
--access Allow `
--protocol Tcp `
--direction Outbound



# Cho phep Bastion ket noi voi Azure Cloud Microsoft
az network nsg rule create `
--resource-group $HubRG `
--nsg-name $NsgBastionName `
--name Allow_AzureCloud_Outbound `
--priority 110 `
--source-address-prefixes "*" `
--destination-address-prefixes AzureCloud `
--destination-port-ranges 443 `
--access Allow `
--protocol Tcp `
--direction Outbound



# Cho phep cac Node cua Bastion lien lac voi nhau
az network nsg rule create `
--resource-group $HubRG `
--nsg-name $NsgBastionName `
--name Allow_Bastion_Communication_Out `
--priority 120 `
--source-address-prefixes VirtualNetwork `
--destination-address-prefixes VirtualNetwork `
--destination-port-ranges 8080 5701 `
--access Allow `
--protocol Tcp `
--direction Outbound



# Cho phep Bastion đi ra Internet
az network nsg rule create `
--resource-group $HubRG `
--nsg-name $NsgBastionName `
--name Allow_Get_Session_Information `
--priority 130 `
--source-address-prefixes "*" `
--destination-address-prefixes Internet `
--destination-port-ranges 80 `
--access Allow `
--protocol Tcp `
--direction Outbound



# Add NSG-Bastion vao Subnet Bastion
az network vnet subnet update `
--resource-group $HubRG `
--vnet-name $HubVNetName `
--name "AzureBastionSubnet" `
--network-security-group $NsgBastionName




# ====================================
# 10. Tao NSG-AppGw va add rule
# ====================================

az network nsg create `
--resource-group $HubRG `
--name $NsgAppGwName `
--location $Location


# Cho phep User truy cap Web
az network nsg rule create `
--resource-group $HubRG `
--nsg-name $NsgAppGwName `
--name Allow_Internet_Inbound `
--priority 120 `
--source-address-prefixes Internet `
--destination-port-ranges 80 443 `
--access Allow `
--protocol Tcp `
--direction Inbound



# Cho phep Azure Health Probe kiem tra AppGw
az network nsg rule create `
--resource-group $HubRG `
--nsg-name $NsgAppGwName `
--name Allow_LoadBalancer_Inbound `
--priority 130 `
--source-address-prefixes AzureLoadBalancer `
--destination-port-ranges "*" `
--access Allow `
--protocol "*" `
--direction Inbound



# Cho phep Microsoft quan tri Instance (GatewayManager)
az network nsg rule create `
--resource-group $HubRG `
--nsg-name $NsgAppGwName `
--name Allow_GatewayManager_Inbound `
--priority 140 `
--source-address-prefixes GatewayManager `
--destination-port-ranges 65200-65535 `
--access Allow `
--protocol Tcp `
--direction Inbound



# Cho phep AppGw goi xuong AKS de lay du lieu Web
az network nsg rule create `
  --resource-group $HubRG `
  --nsg-name $NsgAppGwName `
  --name Allow_AppGw_to_AKS `
  --priority 200 `
  --source-address-prefixes $HubSubnetAppGwPrefix `
  --destination-address-prefixes $SpokeSubnetAKSPrefix `
  --destination-port-ranges 80 443 8080 `
  --access Allow `
  --protocol Tcp `
  --direction Outbound



# Cho phep AppGw phan giai DNS (UDP 53)
az network nsg rule create `
  --resource-group $HubRG `
  --nsg-name $NsgAppGwName `
  --name Allow_DNS_Outbound `
  --priority 210 `
  --source-address-prefixes $HubSubnetAppGwPrefix `
  --destination-address-prefixes "*" `
  --destination-port-ranges 53 `
  --access Allow `
  --protocol Udp `
  --direction Outbound



# Cho phep AppGw di ra Internet (Management/CRL/KeyVault)
az network nsg rule create `
  --resource-group $HubRG `
  --nsg-name $NsgAppGwName `
  --name Allow_AppGw_Management_Outbound `
  --priority 220 `
  --source-address-prefixes $HubSubnetAppGwPrefix `
  --destination-address-prefixes "Internet" `
  --destination-port-ranges "*" `
  --access Allow `
  --protocol "*" `
  --direction Outbound



# CAM tat ca ngoai Internet
az network nsg rule create `
  --resource-group $HubRG `
  --nsg-name $NsgAppGwName `
  --name Deny_All_Inbound `
  --priority 4000 `
  --source-address-prefixes "*" `
  --destination-address-prefixes $HubSubnetAppGwPrefix `
  --destination-port-ranges "*" `
  --access Deny `
  --protocol "*" `
  --direction Inbound



# Add NSG-AppGw vao Subnet-AppGw
az network vnet subnet update `
--resource-group $HubRG `
--vnet-name $HubVNetName `
--name $HubSubnetAppGwName `
--network-security-group $NsgAppGwName




# ====================================
# 11. Tao NSG-Management va add rule
# ====================================

az network nsg create `
--resource-group $HubRG `
--name $NsgMgmtName `
--location $Location



# Cho phep Bastion RDP vao (Không cho Internet)
az network nsg rule create `
  --resource-group $HubRG `
  --nsg-name $NsgMgmtName `
  --name Allow_Bastion_Inbound `
  --priority 100 `
  --source-address-prefixes $HubSubnetBastionPrefix `
  --destination-address-prefixes $HubSubnetMgmtPrefix `
  --destination-port-ranges 3389 22 `
  --access Allow `
  --protocol Tcp `
  --direction Inbound



# Cho phep Bastion Developer RDP vao (Không cho Internet)
az network nsg rule create `
  --resource-group $HubRG `
  --nsg-name $NsgMgmtName `
  --name Allow_Bastion_Developer_Inbound `
  --priority 110 `
  --source-address-prefixes 168.63.129.16 `
  --destination-address-prefixes $HubSubnetMgmtPrefix `
  --destination-port-ranges 3389 22 `
  --access Allow `
  --protocol Tcp `
  --direction Inbound



# CAM tat ca traffic tu INTERNET vao Subnet-Management
az network nsg rule create `
  --resource-group $HubRG `
  --nsg-name $NsgMgmtName `
  --name Deny_Traffic_Internet `
  --priority 300 `
  --source-address-prefixes Internet `
  --destination-address-prefixes $HubSubnetMgmtPrefix `
  --destination-port-ranges "*" `
  --access Deny `
  --protocol "*" `
  --direction Inbound



# Cho phep all traffic di thong qua AZURE FIREWALL
az network nsg rule create `
  --resource-group $HubRG `
  --nsg-name $NsgMgmtName `
  --name Allow_Traffic_To_Firewall `
  --priority 200 `
  --source-address-prefixes $HubSubnetMgmtPrefix `
  --destination-address-prefixes "*" `
  --destination-port-ranges "*" `
  --access Allow `
  --protocol "*" `
  --direction Outbound



# Add NSG-Management vao Subnet-Management
az network vnet subnet update `
  --resource-group $HubRG `
  --vnet-name $HubVNetName `
  --name $HubSubnetMgmtName `
  --network-security-group $NsgMgmtName





# ===================================================
# 12. Cau hinh dinh tuyen Route Table Management
# ===================================================

# Tao RouteTable Management
az network route-table create `
  --resource-group $HubRG `
  --name $HubRouteTableMgmtName `
  --location $Location `
  --disable-bgp-route-propagation true


# Tao Routes cho phep di ra INTERNET thong qua Azure Firewall
az network route-table route create `
--resource-group $HubRG `
  --route-table-name $HubRouteTableMgmtName `
  --name "To_INTERNET_via_Firewall" `
  --address-prefix "0.0.0.0/0" `
  --next-hop-type VirtualAppliance `
  --next-hop-ip-address $FirewallPrivateIP


# Associate RouteTable vao Subnet-Management
az network vnet subnet update `
  --resource-group $HubRG `
  --vnet-name $HubVNetName `
  --name $HubSubnetMgmtName `
  --route-table $HubRouteTableMgmtName





# ===================================================
# 13. Cau hinh dinh tuyen Route Table GatewaySubnet
# ===================================================

# Tao RouteTable cho GatewaySubnet
az network route-table create `
  --resource-group $HubRG `
  --name $HubRouteTableGatewayName `
  --location $Location



# Tao Route cho phep On-Prem di toi Spoke thong qua Firewall
az network route-table route create `
  --resource-group $HubRG `
  --route-table-name $HubRouteTableGatewayName `
  --name "To_Spokes_via_FireWall" `
  --address-prefix "10.1.0.0/16" `
  --next-hop-type VirtualAppliance `
  --next-hop-ip-address $FirewallPrivateIP


# Tao Route On-Prem di toi Hub thong qua Firewall
az network route-table route create `
  --resource-group $HubRG `
  --route-table-name $HubRouteTableGatewayName `
  --name "To-Hub-via-Firewall" `
  --address-prefix "10.0.0.0/16" `
  --next-hop-type VirtualAppliance `
  --next-hop-ip-address $FirewallPrivateIP



# Associate RouteTable vao GatewaySubnet
az network vnet subnet update `
  --resource-group $HubRG `
  --vnet-name $HubVNetName `
  --name "GatewaySubnet" `
  --route-table $HubRouteTableGatewayName



# ====================================
# 14. Tao NSG-Database va add rule
# ====================================
az network nsg create `
--resource-group $SpokeProdRG `
--name $NsgDatabaseName `
--location $Location



# Cho phep AKS NODES di vao (App Backend)
az network nsg rule create `
  --resource-group $SpokeProdRG `
  --nsg-name $NsgDatabaseName `
  --name Allow_AKS_Nodes `
  --priority 100 `
  --source-address-prefixes $SpokeSubnetAKSPrefix `
  --destination-address-prefixes $SpokeSubnetDatabasePrefix `
  --destination-port-ranges 1433 5432 `
  --access Allow `
  --protocol Tcp `
  --direction Inbound



# Cho phep VIRTUAL NODES di vao (App Serverless)
az network nsg rule create `
  --resource-group $SpokeProdRG `
  --nsg-name $NsgDatabaseName `
  --name Allow_Virtual_Nodes `
  --priority 110 `
  --source-address-prefixes $SpokeSubnetVirtualPrefix `
  --destination-address-prefixes $SpokeSubnetDatabasePrefix `
  --destination-port-ranges 1433 5432 `
  --access Allow `
  --protocol Tcp `
  --direction Inbound



# Cho phep JUMPBOX di vao 
az network nsg rule create `
  --resource-group $SpokeProdRG `
  --nsg-name $NsgDatabaseName `
  --name Allow_Jumpbox_Admin `
  --priority 120 `
  --source-address-prefixes $HubSubnetMgmtPrefix `
  --destination-address-prefixes $SpokeSubnetDatabasePrefix `
  --destination-port-ranges 1433 5432 `
  --access Allow `
  --protocol Tcp `
  --direction Inbound



# Cho phep FIREWALL (On-premise Flow)
az network nsg rule create `
  --resource-group $SpokeProdRG `
  --nsg-name $NsgDatabaseName `
  --name Allow_Hub_Firewall `
  --priority 130 `
  --source-address-prefixes $FirewallPrivateIP `
  --destination-address-prefixes $SpokeSubnetDatabasePrefix `
  --destination-port-ranges 1433 5432 `
  --access Allow `
  --protocol Tcp `
  --direction Inbound



# Cho phep AzureLoadBalancer di vao de check Healh Probe 
az network nsg rule create `
  --resource-group $SpokeProdRG `
  --nsg-name $NsgDatabaseName `
  --name Allow_Azure_LoadBalancer `
  --priority 140 `
  --source-address-prefixes "AzureLoadBalancer" `
  --destination-address-prefixes "*" `
  --destination-port-ranges "*" `
  --access Allow `
  --protocol "*" `
  --direction Inbound



# Cho phep tat ca traffic di ra INTERNET thong qua Firewall
az network nsg rule create `
  --resource-group $SpokeProdRG `
  --nsg-name $NsgDatabaseName `
  --name Allow_All_Outbound `
  --priority 200 `
  --source-address-prefixes $SpokeSubnetDatabasePrefix `
  --destination-address-prefixes "*" `
  --destination-port-ranges "*" `
  --access Allow `
  --protocol "*" `
  --direction Outbound

  

# CAM Bastion truy cap truc tiep vao Database
az network nsg rule create `
  --resource-group $SpokeProdRG `
  --nsg-name $NsgDatabaseName `
  --name "Deny_Bastion_Inbound" `
  --priority 300 `
  --source-address-prefixes $HubSubnetBastionPrefix `
  --destination-address-prefixes $SpokeSubnetDatabasePrefix `
  --destination-port-ranges "*" `
  --protocol "*" `
  --access Deny `
  --direction Inbound



# CAM tat ca Traffic di vao Database
az network nsg rule create `
  --resource-group $SpokeProdRG `
  --nsg-name $NsgDatabaseName `
  --name Deny_All_Inbound `
  --priority 4000 `
  --source-address-prefixes "*" `
  --destination-address-prefixes $SpokeSubnetDatabasePrefix `
  --destination-port-ranges "*" `
  --access Deny `
  --protocol "*" `
  --direction Inbound



# Add NSG-Database vao Subnet-Database
az network vnet subnet update `
  --resource-group $SpokeProdRG `
  --vnet-name $SpokeProdVNetName `
  --name $SpokeProdSubnetDatabaseName `
  --network-security-group $NsgDatabaseName




# =================================================
# 15. Cau hinh dinh tuyen Route Table Database
# =================================================

# Tao RouteTable Database
az network route-table create `
  --resource-group $SpokeProdRG `
  --name $SpokeRouteTableDatabaseName `
  --location $Location `
  --disable-bgp-route-propagation true



# Tao Routes cho phep di ve On-Prem thong qua Azure Firewall
az network route-table route create `
  --resource-group $SpokeProdRG `
  --route-table-name $SpokeRouteTableDatabaseName `
  --name "To_OnPrems_via_Firewall" `
  --address-prefix "172.16.0.0/16" `
  --next-hop-type VirtualAppliance `
  --next-hop-ip-address $FirewallPrivateIP



# Associate RouteTable vao Subnet-Database
az network vnet subnet update `
  --resource-group $SpokeProdRG `
  --vnet-name $SpokeProdVNetName `
  --name $SpokeProdSubnetDatabaseName `
  --disable-private-endpoint-network-policies false `
  --route-table $SpokeRouteTableDatabaseName
  
  
  
  
# ====================================
# 16. Tao NSG-AKS-Nodes va add rule
# ====================================

az network nsg create `
--resource-group $SpokeProdRG `
--name $NsgAKSName `
--location $Location



# Cho phep AGIC đi vao AKS-Nodes
az network nsg rule create `
  --resource-group $SpokeProdRG `
  --nsg-name $NsgAksName `
  --name Allow_AGIC_to_AKS-Nodes `
  --priority 100 `
  --source-address-prefixes $HubSubnetAppGwPrefix `
  --destination-address-prefixes $SpokeSubnetAKSPrefix `
  --destination-port-ranges "*" `
  --protocol Tcp `
  --access Allow `
  --direction Inbound



# Cho phep Azure Load Balancer check Health Probe
az network nsg rule create `
  --resource-group $SpokeProdRG `
  --nsg-name $NsgAksName `
  --name Allow_LoadBalancer_Inbound `
  --priority 110 `
  --source-address-prefixes "AzureLoadBalancer" `
  --destination-address-prefixes "*" `
  --destination-port-ranges "*" `
  --access Allow `
  --protocol "*" `
  --direction Inbound
  
  
  
# CAM tat ca Traffic di vao AKS-Nodes
az network nsg rule create `
  --resource-group $SpokeProdRG `
  --nsg-name $NsgAksName `
  --name Deny_All_Traffic_to_AKS_Inbound `
  --priority 4000 `
  --source-address-prefixes "*" `
  --destination-address-prefixes $SpokeSubnetAKSPrefix `
  --destination-port-ranges "*" `
  --access Deny `
  --protocol "*" `
  --direction Inbound



# Cho phep AKS-Nodes đi ra Internet thong qua Azure Firewall
  az network nsg rule create `
  --resource-group $SpokeProdRG `
  --nsg-name $NsgAksName `
  --name Allow_All_Outbound `
  --priority 120 `
  --source-address-prefixes $SpokeSubnetAKSPrefix `
  --destination-address-prefixes "*" `
  --destination-port-ranges "*" `
  --protocol "*" `
  --access Allow `
  --direction Outbound



# Add NSG-AKS-Nodes vao Subnet-AKS-Nodes
az network vnet subnet update `
  --resource-group $SpokeProdRG `
  --vnet-name $SpokeProdVNetName `
  --name $SpokeProdSubnetAKSNodesName `
  --network-security-group $NsgAKSName




# ==========================================
# 17. Cau hinh dinh tuyen Route Table AKS-Nodes
# ==========================================

# Tao RouteTable AKS-Nodes
az network route-table create `
  --resource-group $SpokeProdRG `
  --name $SpokeRouteTableAKSNodesName `
  --location $Location `
  --disable-bgp-route-propagation true



# Tao Routes cho phep di ra INTERNET thong qua Azure Firewall
az network route-table route create `
  --resource-group $SpokeProdRG `
  --route-table-name $SpokeRouteTableAKSNodesName `
  --name "To_INTERNET_via_Firewall" `
  --address-prefix "0.0.0.0/0" `
  --next-hop-type VirtualAppliance `
  --next-hop-ip-address $FirewallPrivateIP



# Associate RouteTable vao Subnet-AKS-Nodes
az network vnet subnet update `
  --resource-group $SpokeProdRG `
  --vnet-name $SpokeProdVNetName `
  --name $SpokeProdSubnetAKSNodesName `
  --route-table $SpokeRouteTableAKSNodesName




# ====================================
# 18. Tao NSG-Virtual-Nodes va add rule
# ====================================

az network nsg create `
--resource-group $SpokeProdRG `
--name $NsgVirtualName `
--location $Location



# Cho phep AGIC di vao
az network nsg rule create `
  --resource-group $SpokeProdRG `
  --nsg-name $NsgVirtualName `
  --name Allow_AGIC_to_Virtual-Nodes `
  --priority 100 `
  --source-address-prefixes $HubSubnetAppGwPrefix `
  --destination-address-prefixes $SpokeSubnetVirtualPrefix `
  --destination-port-ranges 80 443 8080 `
  --access Allow `
  --protocol Tcp `
  --direction Inbound



# Cho phep AKS-Nodes goi sang Virtual-Nodes
az network nsg rule create `
  --resource-group $SpokeProdRG `
  --nsg-name $NsgVirtualName `
  --name Allow_AKS-Nodes_to_Virtual-Nodes `
  --priority 110 `
  --source-address-prefixes $SpokeSubnetAKSPrefix `
  --destination-address-prefixes $SpokeSubnetVirtualPrefix `
  --destination-port-ranges "*" `
  --access Allow `
  --protocol Tcp `
  --direction Inbound



# Cho phep check Health Probe
az network nsg rule create `
  --resource-group $SpokeProdRG `
  --nsg-name $NsgVirtualName `
  --name Allow_LoadBalancer_Inbound `
  --priority 200 `
  --source-address-prefixes "AzureLoadBalancer" `
  --destination-address-prefixes $SpokeSubnetVirtualPrefix `
  --destination-port-ranges "*" `
  --access Allow `
  --protocol "*" `
  --direction Inbound



# Cho phep Virtual-Nodes đi ra, thong qua Azure Firewall
az network nsg rule create `
  --resource-group $SpokeProdRG `
  --nsg-name $NsgVirtualName `
  --name Allow_All_Outbound `
  --priority 200 `
  --source-address-prefixes $SpokeSubnetVirtualPrefix `
  --destination-address-prefixes "*" `
  --destination-port-ranges "*" `
  --access Allow `
  --protocol "*" `
  --direction Outbound



# CAM tat ca Traffic di vao Virtual-Nodes
az network nsg rule create `
  --resource-group $SpokeProdRG `
  --nsg-name $NsgVirtualName `
  --name Deny_All_Traffic_to_Virtual `
  --priority 4000 `
  --source-address-prefixes "*" `
  --destination-address-prefixes $SpokeSubnetVirtualPrefix `
  --destination-port-ranges "*" `
  --access Deny `
  --protocol "*" `
  --direction Inbound



# Add NSG-Virtual-Nodes vao Subnet-Virtual-Nodes
az network vnet subnet update `
  --resource-group $SpokeProdRG `
  --vnet-name $SpokeProdVNetName `
  --name $SpokeProdSubnetVirtualNodesName `
  --network-security-group $NsgVirtualName




# ====================================================
# 19. Cau hinh dinh tuyen Route Table Virtual-Nodes
# ====================================================

# Tao RouteTable Virtual-Nodes
az network route-table create `
  --resource-group $SpokeProdRG `
  --name $SpokeRouteTableVirtualNodesName `
  --location $Location `
  --disable-bgp-route-propagation true



# Tao Routes cho phep di ra INTERNET thong qua Azure Firewall
az network route-table route create `
  --resource-group $SpokeProdRG `
  --route-table-name $SpokeRouteTableVirtualNodesName `
  --name "To_INTERNET_via_Firewall" `
  --address-prefix "0.0.0.0/0" `
  --next-hop-type VirtualAppliance `
  --next-hop-ip-address $FirewallPrivateIP



# Associate RouteTable vao Subnet-Virtual-Nodes
az network vnet subnet update `
  --resource-group $SpokeProdRG `
  --vnet-name $SpokeProdVNetName `
  --name $SpokeProdSubnetVirtualNodesName `
  --route-table $SpokeRouteTableVirtualNodesName




# ============================================================
# 20. Enable DNS-Proxy cua Firewall tren Hub & Spoke Vnet 
# ============================================================


az network vnet update `
  --resource-group $HubRG `
  --name $HubVNetName `
  --dns-servers $FirewallPrivateIP
  
  
  
az network vnet update `
  --resource-group $SpokeProdRG `
  --name $SpokeProdVNetName `
  --dns-servers $FirewallPrivateIP



# ====================================================
# 21. Tao VPN Gateway va ket noi On-Prem  (CLOUD)
# ====================================================

$HubVPNPublicIPName = "Hub-VPN-PIP"
$HubVPNGatewayName = "Hub-VPN-Gateway"
$HubRG = "RG-Hub-Share-Services"
$Location = "KoreaCentral"
$HubVNetName = "VNet-Hub-Shared-Services"



# Tao Public IP VPN Gateway
az network public-ip create `
  --resource-group $HubRG `
  --name $HubVPNPublicIPName `
  --location $Location `
  --sku Standard `
  --allocation-method Static



# Tao VPN Gateway
az network vnet-gateway create `
  --resource-group $HubRG `
  --name $HubVPNGatewayName `
  --public-ip-address $HubVPNPublicIPName `
  --vnet $HubVNetName `
  --gateway-type Vpn `
  --vpn-type RouteBased `
  --sku VpnGw1 `
  --no-wait




# ====================================================
# 22. Tao VPN Gateway va ket noi On-Prem   (GIA LAP ON-PREM)
# ====================================================

$OnPremRG = "RG-Simulated-OnPrem"
$OnPremLocation = "SoutheastAsia"
$OnPremVNetName = "VNet-OnPrem-Datacenter"
$OnPremVNetPrefix = "172.16.0.0/16"
$OnPremGatewaySubnetPrefix = "172.16.255.0/27"
$OnPremWorkloadSubnetPrefix = "172.16.1.0/24"
$OnPremPipName = "OnPrem-VPN-PIP"
$OnPremGwName = "OnPrem-VPN-Gateway"



# Tao Resource Group cho Site On-Prem
az group create `
  --name $OnPremRG `
  --location $OnPremLocation



# Tao VNet cho Site On-Prem
az network vnet create `
  --resource-group $OnPremRG `
  --name $OnPremVNetName `
  --address-prefix $OnPremVNetPrefix `
  --location $OnPremLocation



# Tao Subnet cho Site On-Prem
az network vnet subnet create `
  --resource-group $OnPremRG `
  --vnet-name $OnPremVNetName `
  --name "GatewaySubnet" `
  --address-prefix $OnPremGatewaySubnetPrefix



az network vnet subnet create `
  --resource-group $OnPremRG `
  --vnet-name $OnPremVNetName `
  --name $OnPremSubnetName `
  --address-prefix $OnPremWorkloadSubnetPrefix



# Tao Public IP cho VPN Gateway Site On-Prem
az network public-ip create `
  --resource-group $OnPremRG `
  --name $OnPremPipName `
  --sku Standard `
  --allocation-method Static `
  --location $OnPremLocation



# Tao VPN Gateway Site B 
az network vnet-gateway create `
  --resource-group $OnPremRG `
  --name $OnPremGwName `
  --public-ip-address $OnPremPipName `
  --vnet $OnPremVNetName `
  --gateway-type Vpn `
  --vpn-type RouteBased `
  --sku VpnGw1



# Kiem tra trang thai VPN (CLOUD)
az network vnet-gateway show `
  --resource-group $HubRG `
  --name $HubVPNGatewayName `
  --query provisioningState `
  -o tsv



# Kiem tra trang thai VPN (ON-PREM)
az network vnet-gateway show `
  --resource-group $OnPremRG `
  --name $OnPremGwName `
  --query provisioningState `
  -o tsv




# ====================================
# 23. Tao Connection giua 2 site 
# ====================================

$SharedKey = "CodyVpnSecretKey2026"

# Lay ID cua 2 Gateway
$HubGwId = $(az network vnet-gateway show `
  --resource-group $HubRG `
  --name $HubVPNGatewayName `
  --query id `
  -o tsv)
  
$OnPremGwId = $(az network vnet-gateway show `
  --resource-group $OnPremRG `
  --name $OnPremGwName `
  --query id `
  -o tsv)

# Chieu tu Hub -> OnPrem
az network vpn-connection create `
  --resource-group $HubRG `
  --name "Connection-Hub-to-OnPrem" `
  --vnet-gateway1 $HubGwId `
  --vnet-gateway2 $OnPremGwId `
  --shared-key $SharedKey


# Chieu tu OnPrem -> Hub
az network vpn-connection create `
  --resource-group $OnPremRG `
  --name "Connection-OnPrem-to-Hub" `
  --vnet-gateway1 $OnPremGwId `
  --vnet-gateway2 $HubGwId `
  --shared-key $SharedKey



 
# ====================================================
# 24. TAO VM LINUX DE TEST TAI SITE ON-PREM
# ====================================================

$OnPremRG = "RG-Simulated-OnPrem"
$OnPremVNetName = "VNet-OnPrem-Datacenter"
$VmOnPremName = "VM-OnPrem-Linux"
$OnPremSubnetName = "Subnet-Workload"
$AdminUser = "codyadmin"
$AdminPass = "CodyP@ssw0rd2026!"


# Tao VM Linux (Khong co Public IP)
az vm create `
  --resource-group $OnPremRG `
  --name $VmOnPremName `
  --image "Ubuntu2204" `
  --vnet-name $OnPremVNetName `
  --subnet $OnPremSubnetName `
  --admin-username $AdminUser `
  --admin-password $AdminPass `
  --size "Standard_B1s" `
  --public-ip-address "" `
  --nsg ""



# Lay Private IP cua may ao vua tao
$OnPremVmIP = $(az vm show `
  --resource-group $OnPremRG `
  --name $VmOnPremName `
  --show-details `
  --query privateIps `
  --output tsv)
 


# ====================================================
# 25. TAO AZURE BASTION HOST
# ====================================================

$BastionName = "Hub-Bastion-Host"
$BastionPipName = "Hub-Bastion-PIP"

# Tao Public IP cho Bastion 
az network public-ip create `
  --resource-group $HubRG `
  --name $BastionPipName `
  --location $Location `
  --sku Standard `
  --allocation-method Static



# Tao Azure Bastion 
az extension add --name bastion -y
az network bastion create `
  --resource-group $HubRG `
  --name $BastionName `
  --public-ip-address $BastionPipName `
  --vnet-name $HubVNetName `
  --location $Location `
  --no-wait



# Kiem tra trang thai Bastion
az network bastion show `
  --resource-group $HubRG `
  --name $BastionName `
  --query provisioningState `
  --output tsv



# ================================================
# 26. Tao Jumpbox VM tai Subnet-Management
# ================================================

$VmName = "VM-Jumpbox-Win"
$AdminUser = "codyadmin"
$AdminPass = "CodyP@ssw0rd2026!"

# Tao NIC
az network nic create `
  --resource-group $HubRG `
  --name "${VmName}-nic" `
  --vnet-name $HubVNetName `
  --subnet $HubSubnetMgmtName


# Tạo Jumpbox VM
az vm create `
  --resource-group $HubRG `
  --name $VmName `
  --nics "${VmName}-nic" `
  --image "Win2022Datacenter" `
  --admin-username $AdminUser `
  --admin-password $AdminPass `
  --size "Standard_B2s" `
  --public-ip-address "" `
  --nsg "" `
  --no-wait




# ====================================================
# 27. Tao Azure Container Registry tai HUB
# ====================================================

az acr create `
--resource-group $HubRG `
--name $HubACRName `
--sku Standard `
--admin-enable true



# Lấy Subnet ID (Chỉ định AKS ở tại Subnet-AKS-Nodes)
$SubnetId = (az network vnet subnet show `
  --resource-group $SpokeProdRG `
  --vnet-name $SpokeProdVNetName `
  --name $SpokeProdSubnetAKSNodesName `
  --query id --output tsv)




# ====================================================
# 28. Tao AKS Cluster tai SPOKE
# ====================================================

az aks create `
  --resource-group $SpokeProdRG `
  --name $SpokeProdClusterName `
  --node-resource-group $SpokeProdNodeRG `
  --node-count 2 `
  --node-vm-size "Standard_A2_v2" `
  --enable-cluster-autoscaler `
  --min-count 2 `
  --max-count 4 `
  --network-plugin azure `
  --vnet-subnet-id $SubnetId `
  --enable-managed-identity `
  --generate-ssh-keys `
  --attach-acr $HubACRName `
  --service-cidr 192.168.0.0/16 `
  --dns-service-ip 192.168.10.10 `
  --outbound-type userDefinedRouting    #Disable LoadBalancer đc tao ra cung voi AKS


# ====================================
# 29. Tao Application Gateway tai HUB    
# ====================================

# Tao Public IP cho App Gateway 
az network public-ip create `
  --resource-group $HubRG `
  --name $HubAppGwPublicIpName `
  --allocation-method Static `
  --sku Standard



# Tao App Gateway 
az network application-gateway create `
  --resource-group $HubRG `
  --name $HubAppGwName `
  --vnet-name $HubVNetName `
  --subnet $HubSubnetAppGwName `
  --public-ip-address $HubAppGwPublicIpName `
  --sku Standard_v2 `
  --http2 Enabled `
  --min-capacity 1 `
  --max-capacity 3 `
  --priority 100



# Lay Resource ID cua AppGateway
$AppGwId = $(az network application-gateway show `
--resource-group $HubRG `
--name $HubAppGwName `
--query id `
--output tsv)




# ====================================================
# 30. Bat Addon Application Gateway Ingress Control tren AKS  
# ====================================================

# Bat Addon AGIC tren AKS va tro vào App Gateway ID do
az aks enable-addons `
  --resource-group $SpokeProdRG `
  --name $SpokeProdClusterName `
  --addons ingress-appgw `
  --appgw-id $AppGwId



# Lay Object ID cua AGIC Identity
$AgicObjectId = $(az aks show `
  --resource-group $SpokeProdRG `
  --name $SpokeProdClusterName `
  --query "addonProfiles.ingressApplicationGateway.identity.objectId" `
  --output tsv)



# Gan quyen Contributor cho Identity nay tren App Gateway
az role assignment create `
  --role "Contributor" `
  --assignee-object-id $AgicObjectId `
  --scope $AppGwId
  
  
  
  
# ======================================
# 31. Tai Credentials de ket noi vao AKS    
# ======================================

az aks get-credentials `
--resource-group $SpokeProdRG `
--name $SpokeProdClusterName `
--overwrite-existing



# Kiem tra ket noi giua AKS va ACR 
az aks check-acr `
--resource-group $SpokeProdRG `
--name $SpokeProdClusterName `
--acr $HubACRName




# ======================================
# 32. Tao Namespace "Cody-Apps"     
# ======================================

kubectl create namespace cody-apps



# ======================================================
# 33. Clone Images tu Docker Hub ve ACR (cody-frontend) 
# ======================================================

# Image nguon tren Docker Hub (cody-frontend)
$SOURCE_IMAGE_Frontend = "docker.io/cody3010/cody-portfolio:cody-frontend"


# Ten dich trong ACR
$TARGET_IMAGE_Frontend = "cody-frontend:v1"


# Import images tu Docker-Hub vao ACR
az acr import `
  --name $HubACRName `
  --source $SOURCE_IMAGE_Frontend `
  --image $TARGET_IMAGE_Frontend



# ======================================================
# 34. Clone Images tu Docker Hub ve ACR (cody-vietnam) 
# ======================================================

# Image nguon tren Docker Hub (cody-vietnam)
$SOURCE_IMAGE_Vietnam = "docker.io/cody3010/cody-portfolio:cody-vietnam"


# Ten dich trong ACR
$TARGET_IMAGE_Vietnam = "cody-vietnam:v1"


# Import images tu Docker-Hub vao ACR
az acr import `
  --name $HubACRName `
  --source $SOURCE_IMAGE_Vietnam `
  --image $TARGET_IMAGE_Vietnam





# ======================================================
# 35. Clone Images tu Docker Hub ve ACR (cody-backend) 
# ======================================================

# Image nguon tren Docker Hub (cody-backend)
$SOURCE_IMAGE_Backend = "docker.io/cody3010/cody-portfolio:cody-backend"


# Ten dich trong ACR
$TARGET_IMAGE_Backend = "cody-backend:v1"


# Import images tu Docker-Hub vao ACR
az acr import `
  --name $HubACRName `
  --source $SOURCE_IMAGE_Backend `
  --image $TARGET_IMAGE_Backend





# ================================================
# 36. Clone file Deployment tu Docker Hub ve ACR
# ================================================

git clone https://github.com/cody3010/Deployment.git



# =======================
# 37. Deploy file .yaml
# =======================

cd ./Deployment/
kubectl apply -f backend.yaml -n cody-apps
kubectl apply -f cody-vietnam.yaml -n cody-apps
kubectl apply -f cody-frontend.yaml -n cody-apps
kubectl apply -f ingress.yaml -n cody-apps

 
# Xem trang thai cac Pod
kubectl get pods -n cody-apps


# Xem trang thai Ingress
kubectl get ingress -n cody-apps


# Public IP cua App Gateway
$HubAppGwPublicIP = $(az network public-ip show --ids $(az network application-gateway show `
--resource-group $HubRG `
--name $HubAppGwName `
--query "frontendIPConfigurations[0].publicIPAddress.id" `
-o tsv) --query ipAddress -o tsv)




# ====================================
# 38. Kich hoat HPA.yaml (Auto Scaling)
# ====================================

kubectl apply -f hpa.yaml

# Hien thi thong tin HPA đang chay cho Frontend va Backend
kubectl get hpa -n cody-apps

# Hien thi thong tin CPU va RAM ma Pod đang su dung
kubectl top pods -n cody-apps




# =======================
# 39. Tao DNS Zone
# =======================

az network dns zone create `
--resource-group $HubRG `
--name $DomainName



# Lay thong tin NameServer tro ve Mat Bao
az network dns zone show `
--resource-group $HubRG `
--name $DomainName `
--query nameServers



# Tao ban ghi A (@ - Root domain) tro ve IP Ingress 
az network dns record-set a add-record `
 --resource-group $HubRG `
 --zone-name $DomainName `
 --record-set-name "@" `
 --ipv4-address $HubAppGwPublicIP



# Tao ban ghi www tro ve IP Ingress 
az network dns record-set a add-record `
 --resource-group $HubRG `
 --zone-name $DomainName `
 --record-set-name "www" `
 --ipv4-address $HubAppGwPublicIP




# ===============================
# 40. Xin cap chung chi SSL
# ===============================

# Install Cert-Manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.4/cert-manager.yaml


# Deploy Cluster-issuer
sleep 60
kubectl apply -f cluster-issuer.yaml -n cody-apps


# Kiem tra trang thai ClusterIssuer
sleep 60
kubectl get clusterissuer letsencrypt-prod


# Kiem tra trang thai Certificate
sleep 120
kubectl get certificate -n cody-apps


# Deploy Policy secury-frontend va backend
kubectl apply -f secure-frontend.yaml -n cody-apps
kubectl apply -f secure-backend.yaml -n cody-apps




# ========================================================
# 41. Tao Azure SQL Database voi Private Endpoint
# ========================================================

$SpokeSqlServerName = "cody-sqlserver-2026"
$SpokeSqlDatabaseName = "cody_db"
$SqlAdminUser = "codyadmin"
$SqlAdminPass = "P@ssw0rd2026!!!"


# Tao SQL Logical Server
az sql server create `
  --resource-group $SpokeProdRG `
  --name $SpokeSqlServerName `
  --location $Location `
  --admin-user $SqlAdminUser `
  --admin-password $SqlAdminPass `
  --enable-public-network false



# Tao SQL Database 
az sql db create `
  --resource-group $SpokeProdRG `
  --server $SpokeSqlServerName `
  --name $SpokeSqlDatabaseName `
  --edition Basic `
  --capacity 5



# Lay thong tin SQL Logical Server
$SqlServerId = az sql server show `
  --name $SpokeSqlServerName `
  --resource-group $SpokeProdRG `
  --query id `
  -o tsv



# Tao Private Endpoint cam vao Subnet Database
az network private-endpoint create `
  --resource-group $SpokeProdRG `
  --name "pe-cody-sql" `
  --vnet-name $SpokeProdVNetName `
  --subnet $SpokeProdSubnetDatabaseName `
  --private-connection-resource-id $SqlServerId `
  --group-id sqlServer `
  --connection-name "ple-cody-sql" `
  --location $Location



# Tao Private DNS Zone tai HubRG
az network private-dns zone create `
  --resource-group $HubRG `
  --name "privatelink.database.windows.net"



# Lay ID cua Spoke Vnet
$SpokeVNetId = az network vnet show `
  --resource-group $SpokeProdRG `
  --name $SpokeProdVNetName `
  --query id `
  -o tsv



# Link Private DNS Zone voi Spoke VNet (De AKS phan giai duoc IP)
az network private-dns link vnet create `
  --resource-group $HubRG `
  --zone-name "privatelink.database.windows.net" `
  --name "Link-To-SpokeVNet" `
  --virtual-network $SpokeVNetId `
  --registration-enabled false



# Link DNS Zone voi Hub VNet (De Jumpbox phan giai duoc IP)
az network private-dns link vnet create `
  --resource-group $HubRG `
  --zone-name "privatelink.database.windows.net" `
  --name "Link-To-HubVNet" `
  --virtual-network $HubVNetName `
  --registration-enabled false



# Lay ID cua Private DNS Zone
$DnsZoneId = az network private-dns zone show `
  --resource-group $HubRG `
  --name "privatelink.database.windows.net" `
  --query id `
  -o tsv



# Gan Private Endpoint vao Private DNS Zone (Tu dong map IP Private vao domain)
az network private-endpoint dns-zone-group create `
  --resource-group $SpokeProdRG `
  --endpoint-name "pe-cody-sql" `
  --name "default" `
  --private-dns-zone $DnsZoneId `
  --zone-name "privatelink.database.windows.net"







# ================================================
# 42. TAO Subnet DNS PRIVATE RESOLVER (IN & OUT)
# ================================================

$HubSubnetDNSResolverInboundName = "Subnet-DNS-Resolver-Inbound"
$HubSubnetDNSResolverOutboundName = "Subnet-DNS-Resolver-Outbound"

# Tao Subnet DNS-Resolver-Inbound 
az network vnet subnet create `
  --resource-group $HubRG `
  --vnet-name $HubVNetName `
  --name $HubSubnetDNSResolverInboundName `
  --address-prefix "10.0.4.0/24" `
  --delegations Microsoft.Network/dnsResolvers   #Cho phep DNS Resolver dc quyen tu do tao NIC va quan ly IP



# Tao Subnet DNS-Resolver-Outbound 
az network vnet subnet create `
  --resource-group $HubRG `
  --vnet-name $HubVNetName `
  --name $HubSubnetDNSResolverOutboundName `
  --address-prefix "10.0.5.0/24" `
  --delegations Microsoft.Network/dnsResolvers   #Cho phep DNS Resolver dc quyen tu do tao NIC va quan ly IP



# Lay ID Hub-Vnet
$HubVNetId = (az network vnet show `
  --resource-group $HubRG `
  --name $HubVNetName `
  --query id `
  -o tsv)
  
  
  
# Lay ID cua Subnet-DNS-Resolver-Inbound 
$InboundSubnetId = (az network vnet subnet show `
  --resource-group $HubRG `
  --vnet-name $HubVNetName `
  --name $HubSubnetDNSResolverInboundName `
  --query id `
  -o tsv)
  


# Lay ID cua Subnet-DNS-Resolver-Outbound  
$OutboundSubnetId = (az network vnet subnet show `
  --resource-group $HubRG `
  --vnet-name $HubVNetName `
  --name $HubSubnetDNSResolverOutboundName `
  --query id `
  -o tsv)
  
  


# ====================================================
# 43. Tao DNS-PRIVATE-RESOLVER va In-Out Endpoint
# ====================================================

$InboundEndpointName = "Inbound-EP"
$OutboundEndpointName = "Outbound-EP"


# Tao DNS Private Resolver gan vao Hub VNet
az extension add --name dns-resolver -y
az dns-resolver create `
  --resource-group $HubRG `
  --name $HubDNSResolverName `
  --location $Location `
  --id $HubVNetId



# Tao Inbound Endpoint nam trong Subnet-DNS-Resolver-Inbound (Nhan request di vao tu On-Prem)
az dns-resolver inbound-endpoint create `
  --resource-group $HubRG `
  --dns-resolver-name $HubDNSResolverName `
  --name $InboundEndpointName `
  --location $Location `
  --ip-configurations "[{private-ip-allocation-method:'Dynamic',id:'$InboundSubnetId'}]"  # He thong lay IP tu dong
  
  
  
# Tao Outbound Endpoint nam trong Subnet-DNS-Resolver-Outbound (Gui request ra ngoai / ve On-Prem)
az dns-resolver outbound-endpoint create `
  --resource-group $HubRG `
  --dns-resolver-name $HubDNSResolverName `
  --name $OutboundEndpointName `
  --location $Location `
  --id $OutboundSubnetId



# Lay dia chi IP cua Inbound Endpoint de gan cho cac dich vu duoi On-Prems
$InboundIP = (az dns-resolver inbound-endpoint show `
  --resource-group $HubRG `
  --dns-resolver-name $HubDNSResolverName `
  --name $InboundEndpointName `
  --query "ipConfigurations[0].privateIpAddress" -o tsv)





# ====================================================
# 44. Tao DNS SERVER tren DC tai site ON-PREM
# ====================================================

$OnPremRG = "RG-Simulated-OnPrem"
$OnPremVNetName = "VNet-OnPrem-Datacenter"
$OnPremSubnetName = "Subnet-Workload"
$VmDnsName = "VM-OnPrem-DNS"
$AdminUser = "codyadmin"
$AdminPass = "CodyP@ssw0rd2026!"

# Tao may ao Windows Server 2022
az vm create `
  --resource-group $OnPremRG `
  --name $VmDnsName `
  --image "win2022datacenter" `
  --vnet-name $OnPremVNetName `
  --subnet $OnPremSubnetName `
  --admin-username $AdminUser `
  --admin-password $AdminPass `
  --size "Standard_B2s" `
  --public-ip-address "" `
  --nsg ""



# Cai dat DNS Server
az vm run-command invoke `
  --resource-group $OnPremRG `
  --name $VmDnsName `
  --command-id RunPowerShellScript `
  --scripts "Install-WindowsFeature DNS -IncludeManagementTools"



# Lay Private IP cua may DNS vua tao de test
$OnPremDnsIP = $(az vm show `
  --resource-group $OnPremRG `
  --name $VmDnsName `
  --show-details `
  --query privateIps `
  --output tsv)



# Tao Conditional Forwarder tren Windows DNS
az vm run-command invoke `
  --resource-group $OnPremRG `
  --name $VmDnsName `
  --command-id RunPowerShellScript `
  --scripts "Add-DnsServerConditionalForwarderZone -Name 'database.windows.net' -MasterServers $InboundIP"




# ====================================================
# 45. CAU HINH RULE AZURE FIREWALL (NETWORK RULES)
# ====================================================

$HubRG = "RG-Hub-Share-Services"
$OnPremVNetPrefix = "172.16.0.0/16"


# Cho phep On-Prem truy van DNS len Inbound Endpoint qua port 53 (TCP & UDP)
az network firewall network-rule create `
  --resource-group $HubRG `
  --firewall-name $AzureFirewall `
  --collection-name "RuleCollection-DNS" `
  --name "Allow-OnPrem-to-InboundDNS" `
  --protocols UDP TCP `
  --source-addresses $OnPremVNetPrefix `
  --destination-addresses $InboundIP `
  --destination-ports 53 `
  --action Allow `
  --priority 250



# Cho phep On-Prem truy cap vao SQL
az network firewall network-rule create `
  --resource-group $HubRG `
  --firewall-name $AzureFirewall `
  --collection-name "RuleCollection-SQL" `
  --name "Allow-OnPrem-to-SQL" `
  --protocols TCP `
  --source-addresses "172.16.0.0/16" `
  --destination-addresses "10.1.16.4" `
  --destination-ports 1433 `
  --action Allow `
  --priority 260



# ===========================================================
# 46. Kiem tra On-Prem toi Database thong qua Firewall
# ===========================================================


# Test Rule: Jumpbox ra Windows Update
az vm run-command invoke `
  --resource-group $HubRG `
  --name $VmName `
  --command-id RunPowerShellScript `
  --scripts "Test-NetConnection update.microsoft.com -Port 443" `
  --query "value[0].message" `
  --output tsv


# Test Rule: VM-OnPrem-Linux phan giai Private Endpoint SQL thong qua DNS Server
az vm run-command invoke `
  --resource-group "RG-Simulated-OnPrem" `
  --name "VM-OnPrem-Linux" `
  --command-id RunShellScript `
  --scripts "nslookup cody-sqlserver-2026.database.windows.net $OnPremDnsIP" `
  -o tsv



