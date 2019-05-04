
#$SubscriptionName='CN-GOTD-OMCC-PRE'
#$SubscriptionName='AZ-MKTSALES-FORDMATCH-PREPROD'

$SubscriptionName='Pay-as-you-go'
$username="sam.soud@gmail.com"

Login-AzureRmAccount -SubscriptionName $SubscriptionName
#Login-AzureRmAccount -SubscriptionName $SubscriptionName
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
"sshKeyData"= "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEAuw034LU9i2ht50zbT0Apdzms5p6gGRpO49ZKtaQ/kmTm6gvmnLeENJNyjkUQ2hTX0Fxg58eJVe1TDSzMrkd/OGfwX9zWk0YMo32Xks3KJP/eEhJs2BEytoU6giaONoyBKcx+gDHn2ne1t0oxoQA1XOlrHbD79LAVM5xq0Z0zJptFJ0XCLe6zeCaSK5fIEJVGx4uqnZvDnGJ9LlE86B3MzUR7Vhs3w5tjowNbpPPOuCaA2tmI/qPZM3nmlkDmXIDRIrNe+8fwgrXlV+9JoM4hnEfs5Ot/JQSM5GlTaOCdlTbQGKe3YBN0v/yNGeb/yOl/0IHinSdTxjFXci0Dg66bcZIrssnoigiW8hlo8KCkEcuGKLSfNGA3P7SvU0o/INvzAXIzVCoMr/jPKcZgdIXvCNv5DgFCbpTYx5ke1FHLtDBrfDctAg5ksGxJGmQbpj/wbMQAin9dT9xZmINnWEfVPsYtDSmsJ5Ij+YbIxoy2q/aZxbu3sDL2yh95h9Z/pVoPdGnfOWP85v4vx0GSig+xqmlpui3VlZZYm5+oJ+Sa0uH5fbXhb0PR0MOS6PftDUBqcfQ2vCBqJg2rvaI+vtI9fEKFyD1YsYNIJriK1U4sKUJgVMCfZ9w8cO36fvtEkDUtOW+w/+ruVhqJr+t4NAIV5Cu1JFLG8P+nkVx/T+sERzs="
$location= "East US"
$BaseName = "test1"
$Template= "C:\AAA\test\FordMatch-master\FordMatch-master\QA.json"
Fordmatch_v01.json
$Template= "C:\arm\ubunto\ubunto-key2.json"
$RgName = "test1"
$ResGrp = New-AzureRmResourceGroup -Name $BaseName -Location $Location -verbose
$RgName= $ResGrp.ResourceGroupName
Test-AzureRmResourceGroupDeployment -ResourceGroupName $RgName -TemplateFile $Template -TemplateParameterObject $Params -Verbose
New-AzureRmResourceGroupDeployment -ResourceGroupName $RgName -TemplateFile $Template -TemplateParameterObject $Params -Verbose


Get-AzureRmLog -ResourceId "/subscriptions/623d50f1-4fa8-4e46-a967-a9214aed43ab/ResourceGroups/Contoso-Web-CentralUS/providers/Microsoft.Web/ServerFarms/Contoso1"


Get-AzureRmLog -MaxEvents 100
Get-AzureRmLog -StartTime 2017-06-01T10:30

Get-AzureRmLog -StartTime 2017-04-01T10:30 -EndTime 2017-04-14T11:30
Get-AzureRmLog -CorrelationId "60c694d0-e46f-4c12-bed1-9b7aef541c23"
Get-AzureRmLog -CorrelationId "60c694d0-e46f-4c12-bed1-9b7aef541c23" -MaxEvents 100
Get-AzureRmLog -CorrelationId "60c694d0-e46f-4c12-bed1-9b7aef541c23" -StartTime 2017-05-22T04:30:00
Get-AzureRmLog -CorrelationId "60c694d0-e46f-4c12-bed1-9b7aef541c23" -StartTime 2017-04-15T04:30:00 -EndTime 2017-04-25T12:30:00
Get-AzureRmLog -ResourceGroup "Contoso-Web-CentralUS" -MaxEvents 100

Get-AzureRmLog -ResourceGroup "Contoso-Web-CentralUS" -StartTime 2017-04-15T04:30 -EndTime 2017-04-25T12:30
Get-AzureRmLog -ResourceId "/subscriptions/623d50f1-4fa8-4e46-a967-a9214aed43ab/ResourceGroups/Contoso-Web-CentralUS/providers/Microsoft.Web/ServerFarms/Contoso1" -MaxEvents 100
Get-AzureRmLog -ResourceProvider "Microsoft.Web"
Get-AzureRmLog -ResourceProvider "Microsoft.Web" -MaxEvents 100
Get-AzureRmLog -ResourceProvider "Microsoft.Web" -StartTime 2017-05-22T04:30
Get-AzureRmLog -ResourceProvider "Microsoft.Web" -StartTime 2017-04-15T04:30 -EndTime 2017-04-25T12:30





######################################################################################
 $Params= @{
"SuseVMNamePrefix"="fmdse"
'AzurePrefix' ="az"
'EnvironmentType' = "qa"
"adminUserName" = "azuser01"
"location"= "usw"
"sshKeyData"= "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEAuw034LU9i2ht50zbT0Apdzms5p6gGRpO49ZKtaQ/kmTm6gvmnLeENJNyjkUQ2hTX0Fxg58eJVe1TDSzMrkd/OGfwX9zWk0YMo32Xks3KJP/eEhJs2BEytoU6giaONoyBKcx+gDHn2ne1t0oxoQA1XOlrHbD79LAVM5xq0Z0zJptFJ0XCLe6zeCaSK5fIEJVGx4uqnZvDnGJ9LlE86B3MzUR7Vhs3w5tjowNbpPPOuCaA2tmI/qPZM3nmlkDmXIDRIrNe+8fwgrXlV+9JoM4hnEfs5Ot/JQSM5GlTaOCdlTbQGKe3YBN0v/yNGeb/yOl/0IHinSdTxjFXci0Dg66bcZIrssnoigiW8hlo8KCkEcuGKLSfNGA3P7SvU0o/INvzAXIzVCoMr/jPKcZgdIXvCNv5DgFCbpTYx5ke1FHLtDBrfDctAg5ksGxJGmQbpj/wbMQAin9dT9xZmINnWEfVPsYtDSmsJ5Ij+YbIxoy2q/aZxbu3sDL2yh95h9Z/pVoPdGnfOWP85v4vx0GSig+xqmlpui3VlZZYm5+oJ+Sa0uH5fbXhb0PR0MOS6PftDUBqcfQ2vCBqJg2rvaI+vtI9fEKFyD1YsYNIJriK1U4sKUJgVMCfZ9w8cO36fvtEkDUtOW+w/+ruVhqJr+t4NAIV5Cu1JFLG8P+nkVx/T+sERzs="
 }

$location= "West US"
$BaseName ="az-usw-mss-fordmatch-dse-qa"
$Template="C:\AAA\test\FordMatch-master\FordMatch-master\QA\Fordmatch_v12_SP2-East2.json"
$RgName ="az-usw-mss-fordmatch-dse-qa"
$ResGrp = New-AzureRmResourceGroup -Name $BaseName -Location $Location -verbose
$RgName= $ResGrp.ResourceGroupName

Test-AzureRmResourceGroupDeployment -ResourceGroupName $RgName -TemplateFile $Template -TemplateParameterObject $Params -Verbose
New-AzureRmResourceGroupDeployment -ResourceGroupName $RgName -TemplateFile $Template -TemplateParameterObject $Params -Verbose


#################################################################################################################################
$Params= @{
"SuseVMNamePrefix"="fm22"
'AzurePrefix' ="az"
'EnvironmentType' = "qa"
"adminUserName" = "azuser01"
"location"= "usw"
"sshKeyData"= "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEAuw034LU9i2ht50zbT0Apdzms5p6gGRpO49ZKtaQ/kmTm6gvmnLeENJNyjkUQ2hTX0Fxg58eJVe1TDSzMrkd/OGfwX9zWk0YMo32Xks3KJP/eEhJs2BEytoU6giaONoyBKcx+gDHn2ne1t0oxoQA1XOlrHbD79LAVM5xq0Z0zJptFJ0XCLe6zeCaSK5fIEJVGx4uqnZvDnGJ9LlE86B3MzUR7Vhs3w5tjowNbpPPOuCaA2tmI/qPZM3nmlkDmXIDRIrNe+8fwgrXlV+9JoM4hnEfs5Ot/JQSM5GlTaOCdlTbQGKe3YBN0v/yNGeb/yOl/0IHinSdTxjFXci0Dg66bcZIrssnoigiW8hlo8KCkEcuGKLSfNGA3P7SvU0o/INvzAXIzVCoMr/jPKcZgdIXvCNv5DgFCbpTYx5ke1FHLtDBrfDctAg5ksGxJGmQbpj/wbMQAin9dT9xZmINnWEfVPsYtDSmsJ5Ij+YbIxoy2q/aZxbu3sDL2yh95h9Z/pVoPdGnfOWP85v4vx0GSig+xqmlpui3VlZZYm5+oJ+Sa0uH5fbXhb0PR0MOS6PftDUBqcfQ2vCBqJg2rvaI+vtI9fEKFyD1YsYNIJriK1U4sKUJgVMCfZ9w8cO36fvtEkDUtOW+w/+ruVhqJr+t4NAIV5Cu1JFLG8P+nkVx/T+sERzs="
 }

$location= "West US"
$BaseName ="az-get-AzureRMLog usw-mss-fordmatch-dse-pre"
$Template="C:\aaa\test\JumbBox_Fordmatch_v12_SP2-west.json"
$RgName ="test1"
#$ResGrp = New-AzureRmResourceGroup -Name $BaseName -Location $Location -verbose
#$RgName= $ResGrp.ResourceGroupName

Test-AzureRmResourceGroupDeployment -ResourceGroupName $RgName -TemplateFile $Template -TemplateParameterObject $Params -Verbose
New-AzureRmResourceGroupDeployment -ResourceGroupName $RgName -TemplateFile $Template -TemplateParameterObject $Params -Verbose

get-AzureRMLog 
##################################################################################################

$Params= @{
"adminUserName" = "azuser01"

"sshKeyData"= "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEAuw034LU9i2ht50zbT0Apdzms5p6gGRpO49ZKtaQ/kmTm6gvmnLeENJNyjkUQ2hTX0Fxg58eJVe1TDSzMrkd/OGfwX9zWk0YMo32Xks3KJP/eEhJs2BEytoU6giaONoyBKcx+gDHn2ne1t0oxoQA1XOlrHbD79LAVM5xq0Z0zJptFJ0XCLe6zeCaSK5fIEJVGx4uqnZvDnGJ9LlE86B3MzUR7Vhs3w5tjowNbpPPOuCaA2tmI/qPZM3nmlkDmXIDRIrNe+8fwgrXlV+9JoM4hnEfs5Ot/JQSM5GlTaOCdlTbQGKe3YBN0v/yNGeb/yOl/0IHinSdTxjFXci0Dg66bcZIrssnoigiW8hlo8KCkEcuGKLSfNGA3P7SvU0o/INvzAXIzVCoMr/jPKcZgdIXvCNv5DgFCbpTYx5ke1FHLtDBrfDctAg5ksGxJGmQbpj/wbMQAin9dT9xZmINnWEfVPsYtDSmsJ5Ij+YbIxoy2q/aZxbu3sDL2yh95h9Z/pVoPdGnfOWP85v4vx0GSig+xqmlpui3VlZZYm5+oJ+Sa0uH5fbXhb0PR0MOS6PftDUBqcfQ2vCBqJg2rvaI+vtI9fEKFyD1YsYNIJriK1U4sKUJgVMCfZ9w8cO36fvtEkDUtOW+w/+ruVhqJr+t4NAIV5Cu1JFLG8P+nkVx/T+sERzs="
 }


  # "adminUserName" = "testssh1"
 # $passphrase= "azureuser"

$location= "eastus"
$RgName ="test1"


$ResGrp = New-AzureRmResourceGroup -Name $BaseName -Location $Location -verbose
#$ResGrp= get-AzureRmResourceGroup -Name $BaseName -Location $Location -verbose
$RgName= $ResGrp.ResourceGroupName 

$Template="C:\AAA\test\FordMatch-master\FordMatch-master\QA\Fordmatch_v12_SP2-East2.json"




Test-AzureRmResourceGroupDeployment -ResourceGroupName $RgName -TemplateFile $Template -TemplateParameterObject $Params -Verbose
New-AzureRmResourceGroupDeployment -ResourceGroupName $RgName -TemplateFile $Template -TemplateParameterObject $Params -Verbose
Get-AzureRmLog -CorrelationId "..........................."

Get-AzureRMLog -CorrelationId 'b9cf45e0-6cc5-4d84-be58-b86ce221b03a' -DetailedOutput
Get-AzureRMvm -ResourceGroupName $RgName -name 
Get-AzureRMVMImageOffer –location ‘centralus’ –PublisherName ‘Canonical’
Get-AzureRMVMImageSKU –location ‘eastus’ –PublisherName ‘Canonical’ –offer ‘UbuntuServer’
$Version=(Get-AzureRMVMImage –location ‘eastus’ –PublisherName ‘Canonical’ –Offer ‘UbuntuServer’ –skus ’14.04.4-LTS’ | Sort-object Version)[-1].Version

Get-AzureRMVMImageOffer -Location $location -Publisher $publisher | Select Offer
$pubName="Canonical"
Get-AzureRMVMImageOffer -Location ‘eastus’ -PublisherName $pubName | Select Offer
Get-AzureRMVMImageOffer -Location ‘eastus’ -PublisherName $pubName


$offerName="UbuntuServer"
Get-AzureRMVMImageSku -Location "eastus" -PublisherName $pubName -Offer $offerName | Select Skus
