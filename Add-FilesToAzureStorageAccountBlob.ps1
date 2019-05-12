
$username="sam.soud@gmail.com"
$SubscriptionID="81a9ea66-6119-4aa3-8322-fd4abfd5faae"
Connect-AzureRmAccount -SubscriptionID $SubscriptionID
#Login-AzureRmAccount -SubscriptionName $SubscriptionName
$Subscription = Get-AzureRmSubscription -SubscriptionID $SubscriptionID | Select-AzureRmSubscription
Select-AzureRmSubscription -SubscriptionID $SubscriptionID | Set-AzureRmContext
#Install-Module Azurerm.ServiceBus
Get-AzurermContext

$resourceGroupName = "test1"
$location="centralus"
#Add-AzureAccount 
# Create Storage acconut
# Set the name of the storage account and the SKU name. 
# Create the storage account.
$StorageAccountName = "cloudengartifacts1" 

$SubscriptionID
 $StorageAccountName = "cloudengartifacts1" 
 $StorageAccountKey = Get-AzureRmStorageAccountKey -StorageAccountName  $StorageAccountName -resourceGroupName $resourceGroupName
 $ContainerName = "templates"
$sourceFileRootDirectory="C:\Interview\ARM-templates-master"



Function Add-FilesToAzureStorageAccountBlob {
    <#
    .Synopsis
        Uploads the specified file or directory of file to a blob storage account in Azure.
    .Description
        Connects to indicated Azure Storage Account Container and uploads the indicated file(s). User will be prompted to log into Azure if not already.
    .Parameter AzureEnvironment
        AzureCloud for ROW (defaulted), AzureChinaCloud for China
    .Parameter SubscriptionName
        Subscription containing the storage account - not required if already logged into Azure prior to calling method
    .Parameter ResourceGroupName
        Resource Group containing the storage account
    .Parameter StorageAccountName
        Storage account containing the file
    .Parameter ContainerName
        Container containing the file
    .Parameter FilePath
        Path to the file or directory to upload
    .Example
        Add-FilesToAzureStorageAccountBlob -SubscriptionID $SubscriptionID -ResourceGroupName $ResourceGroupName -StorageAccountName $StorageAccountName -ContainerName $ContainerName -FilePath $sourceFileRootDirectory
    #>
    
    Param (
        [Parameter()]
        [ValidateSet('AzureCloud','AzureChinaCloud')]
        [String] $AzureEnvironment = 'AzureCloud',

        [Parameter()]
        [String] $SubscriptionID,

        [Parameter(Mandatory = $true)]
        [String] $ResourceGroupName,

        [Parameter(Mandatory = $true)]
        [String] $StorageAccountName,

        [Parameter(Mandatory = $true)]
        [String] $ContainerName,
        
        [Parameter(Mandatory = $true)]
        [String] $FilePath
        )

    #Log into Azure if not already
    Try
    {
        Get-AzureRmContext
    }
    Catch
    {
        If($_ -like "*Login-AzureRmAccount to login*") {
            Login-AzureRmAccount -EnvironmentName $AzureEnvironment
            If([string]::IsNullOrEmpty($SubscriptionID))
            {
                $SubscriptionID = Read-Host -Prompt "Enter Subscription Name"
            }
            Set-AzureRmContext -SubscriptionID $SubscriptionID
        }
    }

    # Get storage account key and context
    $StorageAccountKey = (Get-AzureRmStorageAccountKey -StorageAccountName $StorageAccountName -ResourceGroupName $ResourceGroupName)[0].Value
    $ctx = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey
    $Container = Get-AzureStorageContainer -Name $ContainerName -Context $ctx
    $Container.CloudBlobContainer.Uri.AbsoluteUri

    # Add each file in the path to the storage account container (or just one file if the path points to a file).
    if ($Container) {
        $FilesToUpload = Get-ChildItem $FilePath -Recurse -File

        foreach ($File in $FilesToUpload) {
            $TargetPath = ($File.fullname.Substring($FilePath.Length + 1)).Replace("\", "/")
            Set-AzureStorageBlobContent -File $File.fullname -Container $Container.Name -Blob $TargetPath -Context $ctx -Force:$true | Out-Null
        }
    }

}
    

#############################################################################################################################################################

Get-AzureStorageContainer -Name "templates" | Get-AzureStorageBlob -IncludeDeleted -Context $storage_Context