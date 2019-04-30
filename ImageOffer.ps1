


$SubscriptionName='Pay-as-you-go'
$username="sam.soud@gmail.com"

Login-AzureRmAccount -SubscriptionName $SubscriptionName
Get-AzureRmSubscription -SubscriptionName $SubscriptionName | Select-AzureRmSubscription
Select-AzureRmSubscription -SubscriptionName $SubscriptionName | Set-AzureRmContext

Get-AzureRMVMImageOffer –location ‘centralus’ –PublisherName ‘Canonical’
Get-AzureRMVMImageSKU –location ‘eastus’ –PublisherName ‘Canonical’ –offer ‘UbuntuServer’
$Version=(Get-AzureRMVMImage –location ‘eastus’ –PublisherName ‘Canonical’ –Offer ‘UbuntuServer’ –skus ’14.04.4-LTS’ | Sort-object Version)[-1].Version

Get-AzureRMVMImageOffer -Location $location -Publisher $publisher | Select Offer
$pubName="Canonical"
Get-AzureRMVMImageOffer -Location ‘eastus’ -PublisherName $pubName | Select Offer
Get-AzureRMVMImageOffer -Location ‘eastus’ -PublisherName $pubName


$offerName="UbuntuServer"
Get-AzureRMVMImageSku -Location "eastus" -PublisherName $pubName -Offer $offerName | Select Skus

