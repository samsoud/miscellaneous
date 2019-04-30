

Express route 

https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-vnet-vnet-rm-ps

$RG1 = "TestRG1"
$Location1 = "East US"
$VNetName1 = "TestVNet1"
$FESubName1 = "FrontEnd"
$BESubName1 = "Backend"
$GWSubName1 = "GatewaySubnet"
$VNetPrefix11 = "10.11.0.0/16"
$VNetPrefix12 = "10.12.0.0/16"
$FESubPrefix1 = "10.11.0.0/24"
$BESubPrefix1 = "10.12.0.0/24"
$GWSubPrefix1 = "10.12.255.0/27"
$GWName1 = "VNet1GW"
$GWIPName1 = "VNet1GWIP"
$GWIPconfName1 = "gwipconf1"
$Connection14 = "VNet1toVNet4"
$Connection15 = "VNet1toVNet5"

New-AzResourceGroup -Name $RG1 -Location $Location1


$fesub1 = New-AzVirtualNetworkSubnetConfig -Name $FESubName1 -AddressPrefix $FESubPrefix1
$besub1 = New-AzVirtualNetworkSubnetConfig -Name $BESubName1 -AddressPrefix $BESubPrefix1
$gwsub1 = New-AzVirtualNetworkSubnetConfig -Name $GWSubName1 -AddressPrefix $GWSubPrefix1

# Create TestVNet1.
New-AzVirtualNetwork -Name $VNetName1 -ResourceGroupName $RG1 `
-Location $Location1 -AddressPrefix $VNetPrefix11,$VNetPrefix12 -Subnet $fesub1,$besub1,$gwsub1

## Request a public IP address to be allocated to the gateway you will create for your VNet. Notice that the AllocationMethod is Dynamic. You cannot specify the IP address that you want to use. It's dynamically allocated to your gateway.

$gwpip1 = New-AzPublicIpAddress -Name $GWIPName1 -ResourceGroupName $RG1 `
-Location $Location1 -AllocationMethod Dynamic

## Create the gateway configuration.

$vnet1 = Get-AzVirtualNetwork -Name $VNetName1 -ResourceGroupName $RG1
$subnet1 = Get-AzVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $vnet1


$gwipconf1 = New-AzVirtualNetworkGatewayIpConfig -Name $GWIPconfName1 `
-Subnet $subnet1 -PublicIpAddress $gwpip1

## Create the gateway for TestVNet1

New-AzVirtualNetworkGateway -Name $GWName1 -ResourceGroupName $RG1 `
-Location $Location1 -IpConfigurations $gwipconf1 -GatewayType Vpn `
-VpnType RouteBased -GatewaySku VpnGw1


### Step 3 - Create and configure TestVNet4


$RG4 = "TestRG4"
$Location4 = "West US"
$VnetName4 = "TestVNet4"
$FESubName4 = "FrontEnd"
$BESubName4 = "Backend"
$GWSubName4 = "GatewaySubnet"
$VnetPrefix41 = "10.41.0.0/16"
$VnetPrefix42 = "10.42.0.0/16"
$FESubPrefix4 = "10.41.0.0/24"
$BESubPrefix4 = "10.42.0.0/24"
$GWSubPrefix4 = "10.42.255.0/27"
$GWName4 = "VNet4GW"
$GWIPName4 = "VNet4GWIP"
$GWIPconfName4 = "gwipconf4"
$Connection41 = "VNet4toVNet1"


## 2 Create a resource group.
New-AzResourceGroup -Name $RG4 -Location $Location4

## Create the subnet configurations for TestVNet4.
$fesub4 = New-AzVirtualNetworkSubnetConfig -Name $FESubName4 -AddressPrefix $FESubPrefix4
$besub4 = New-AzVirtualNetworkSubnetConfig -Name $BESubName4 -AddressPrefix $BESubPrefix4
$gwsub4 = New-AzVirtualNetworkSubnetConfig -Name $GWSubName4 -AddressPrefix $GWSubPrefix4


## Create TestVNet4.

New-AzVirtualNetwork -Name $VnetName4 -ResourceGroupName $RG4 `
-Location $Location4 -AddressPrefix $VnetPrefix41,$VnetPrefix42 -Subnet $fesub4,$besub4,$gwsub4
## Request a public IP address.
$gwpip4 = New-AzPublicIpAddress -Name $GWIPName4 -ResourceGroupName $RG4 `
-Location $Location4 -AllocationMethod Dynamic



#Create the gateway configuration.


$vnet4 = Get-AzVirtualNetwork -Name $VnetName4 -ResourceGroupName $RG4
$subnet4 = Get-AzVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $vnet4
$gwipconf4 = New-AzVirtualNetworkGatewayIpConfig -Name $GWIPconfName4 -Subnet $subnet4 -PublicIpAddress $gwpip4


## Create the TestVNet4 gateway. Creating a gateway can often take 45 minutes or more, depending on the selected gateway SKU.
New-AzVirtualNetworkGateway -Name $GWName4 -ResourceGroupName $RG4 `
-Location $Location4 -IpConfigurations $gwipconf4 -GatewayType Vpn `
-VpnType RouteBased -GatewaySku VpnGw1


## Step 4 - Create the connections
##Get both virtual network gateways.


$vnet1gw = Get-AzVirtualNetworkGateway -Name $GWName1 -ResourceGroupName $RG1
$vnet4gw = Get-AzVirtualNetworkGateway -Name $GWName4 -ResourceGroupName $RG4

##  Create the TestVNet1 to TestVNet4 connection. In this step, you create the connection from TestVNet1 to TestVNet4. You'll see a shared key referenced in the examples. You can use your own values for the shared key. The important thing is that the shared key must match for both connections. Creating a connection can take a short while to complete.

New-AzVirtualNetworkGatewayConnection -Name $Connection14 -ResourceGroupName $RG1 `
-VirtualNetworkGateway1 $vnet1gw -VirtualNetworkGateway2 $vnet4gw -Location $Location1 `
-ConnectionType Vnet2Vnet -SharedKey 'AzureA1b2C3'

## Create the TestVNet4 to TestVNet1 connection. This step is similar to the one above, except you are creating the connection from TestVNet4 to TestVNet1. Make sure the shared keys match. The connection will be established after a few minutes.

New-AzVirtualNetworkGatewayConnection -Name $Connection41 -ResourceGroupName $RG4 `
-VirtualNetworkGateway1 $vnet4gw -VirtualNetworkGateway2 $vnet1gw -Location $Location4 `
-ConnectionType Vnet2Vnet -SharedKey 'AzureA1b2C3'


## Verify your connection. See the section


Get-AzVirtualNetworkGatewayConnection -Name VNet1toSite1 -ResourceGroupName TestRG1

###################################################################################################################################

#Azure Queue storage is a service for storing large numbers of messages that can be accessed from anywhere in the world via authenticated calls using HTTP or HTTPS.
# A single queue message can be up to 64 KB in size, and a queue can contain millions of messages, up to the total capacity limit of a storage account.

#The service is a NoSQL datastore which accepts authenticated calls from inside and outside the Azure cloud.
# Azure tables are ideal for storing structured, non-relational data. Common uses of Table storage include: Storing TBs of structured data capable of serving web scale applications.
#Storing TBs of structured data capable of serving web scale applications
#Storing datasets that don't require complex joins, foreign keys, or stored procedures and can be denormalized for fast access
#Quickly querying data using a clustered index
#Accessing data using the OData protocol and LINQ queries with WCF Data Service .NET Libraries

##  File  "used smb"

## Blob  " rest-base" unstructured data

###################################################################################################################################



ISM Interviewed me two times for a position and got the job, The project manager of the project was not a part of interview  process

They brouth another person few days before starting the project, I relized that there  were no room for two specialists to work at that project.
so they let me go, ISM did pay me as per contract but that was the worst experience I have seen 

I have worked with other companies for years and never seen such a poor management such as this one.
 
I beleive these kind of ignorant behavier can ruin their repetation

you can acess them by using storage explorer

###################################################################################################################################

Message queing

Blobs 
Table ural  strucural dada base