$resoureGcroupName = "test1"
$SubscriptionName='Pay-as-you-go'
$StorageAccountName="armtemplatesstg"
$resourceGroup= "test1"
$ContainerName="armtemplates"

$username="sam.Soud@gmail.com"
$location= "eastus"

$FilePath="C:\ARM\ARMtemplates-master"

[String] $AzureEnvironment = 'AzureCloud'    

Login-AzureRmaccount -SubscriptionName $SubscriptionName
Select-AzureRmSubscription -SubscriptionName $SubscriptionName | Set-AzureRmContext
Get-AzureRmSubscription –SubscriptionName $SubscriptionName | Select-AzureRmSubscription

#to deallocate:

$vmname = 'sshvm'
$ShutdownState = (Stop-AzureRmVM -ResourceGroupName $resoureGcroupName -Name $vmname -Force -ErrorAction $ErrorActionPreference -WarningAction $WarningPreference).IsSuccessStatusCode
$vm=Get-AzureRmVM -ResourceGroupName $resoureGcroupName -Name $vmname
$status=((Get-AzureRmVM -ResourceGroupName $resoureGcroupName  -Name  $vmname -Status).Statuses[1] ).Code

if ($status.Contains("PowerState/deallocated"))
{
echo "$vmname is deallocated"
}
else
{Stop-AzureRmVM -Id $vm[0].Id -Name $vm[0].Name -Force}

# to start the VM 
Start-AzureRmVM -ResourceGroupName $resoureGcroupName -Name $vmname 
# if you forget the user name or password:


# Go to serial consol
#Change root password 
passwd root
#add /change password for user
useradd bassamsoud
sudo usermod -a -G sudo bassamsoud
passwd bassamsoud
#passwd @N0rtheast@123123