

$SubscriptionName='Pay-as-you-go'
$username="sam.soud@gmail.com"

Login-AzureRmAccount -SubscriptionName $SubscriptionName
Get-AzureRmSubscription -SubscriptionName $SubscriptionName | Select-AzureRmSubscription
Select-AzureRmSubscription -SubscriptionName $SubscriptionName | Set-AzureRmContext

 $Params= @{
"SuseVMNamePrefix"="dse"
'AzurePrefix' ="az"
'EnvironmentType' = "qa"
"adminUserName" = "azuser01"
"location"= "use"
"sshKeyData"= "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAlM196kDNsyWdtwp1lUU/GF1YjL6rNBMFav/+TeWdtj8nu9JAuDcg3IVGdlRSVZ77NfRZ/PcqD7bHu/1mdhUrzzHBdkYXW5TmWGZcfT4N/TACbNqLRaJHF+XZ6Y4QWoAZtkytakSFSpb5rhq/bii3cRQwoJKfTPEflZh4biPmt2h4FisH9SJ7AvVZcnAY6y1m4rukGsQDD8OJZOIuHc0aPFSLu361QQpODM4S+JO1mnRKAJT2PIrljXeqKH6ENYxD3klgPTipZ+TlkNgDJqMIhgMemmeFuUGWH3pIotmqia8wSVb5PkBqf+RbTWXaVyRvwSIN/s2lUVz/rFi/pXjqvw== rsa-key-20170523"
 }

$location= "EastUS"
$RgName = "test1"
$Template= "C:\AAA\test\QA.json"


$ResGrp = New-AzureRmResourceGroup -Name $RgName -Location $Location -verbose
$RgName= $ResGrp.ResourceGroupName
Test-AzureRmResourceGroupDeployment -ResourceGroupName $RgName -TemplateFile $Template -TemplateParameterObject $Params -Verbose
New-AzureRmResourceGroupDeployment -ResourceGroupName $RgName -TemplateFile $Template -TemplateParameterObject $Params -Verbose


Get-AzureRMVMImageOffer –location ‘centralus’ –PublisherName ‘Canonical’
Get-AzureRMVMImageSKU –location ‘eastus’ –PublisherName ‘Canonical’ –offer ‘UbuntuServer’
$Version=(Get-AzureRMVMImage –location ‘eastus’ –PublisherName ‘Canonical’ –Offer ‘UbuntuServer’ –skus ’14.04.4-LTS’ | Sort-object Version)[-1].Version

Get-AzureRMVMImageOffer -Location $location -Publisher $publisher | Select Offer
$pubName="Canonical"
Get-AzureRMVMImageOffer -Location ‘eastus’ -PublisherName $pubName | Select Offer
Get-AzureRMVMImageOffer -Location ‘eastus’ -PublisherName $pubName


$offerName="UbuntuServer"
Get-AzureRMVMImageSku -Location "eastus" -PublisherName $pubName -Offer $offerName | Select Skus

