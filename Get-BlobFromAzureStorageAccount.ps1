
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
##############################################################################
Function Get-BlobFromAzureStorageAccount {
    <#
    .Synopsis
        Downloads the specified file from a blob storage account in Azure.
    .Description
        Connects to indicated Azure Storage Account Container and downloads the indicated file. User will be prompted to log into Azure if not already.
    .Parameter AzureEnvironment
        AzureCloud for ROW (defaulted), AzureChinaCloud for China
    .Parameter SubscriptionName
        Subscription containing the storage account - not required if already logged into Azure prior to calling method
    .Parameter resourceGroupName
        Resource Group containing the storage account
    .Parameter StorageAccountName
        Storage account containing the file
    .Parameter ContainerName
        Container containing the file
    .Parameter LocalFileDirectory
        Local directory on PC to download the file to
    .Parameter FileName
        Optional. Name of file to download. If not specified, the entire contents of the container are downloaded.
    .Example
        Get-BlobFromAzureStorageAccount -SubscriptionName 'FORD-CLOUDENG-AUTO-F-POC' -resourceGroupName 'myresourceGroupName' -StorageAccountName 'mystorageaccount' -ContainerName 'mycontainer' -LocalFileDirectory "C:\MyDir" -FileName 'myfile.txt'
    #>
    
    Param (
        [Parameter()]
        [ValidateSet('AzureCloud','AzureChinaCloud')]
        [String] $AzureEnvironment = 'AzureCloud',

        [Parameter()]
        [String] $SubscriptionID,

        [Parameter(Mandatory = $true)]
        [String] $resourceGroupName,

        [Parameter(Mandatory = $true)]
        [String] $StorageAccountName,

        [Parameter(Mandatory = $true)]
        [String] $ContainerName,
                
        [Parameter(Mandatory = $true)]
        [String] $LocalFileDirectory,
        
        [Parameter()]
        [String] $FileName
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
    $StorageAccountKey = (Get-AzureRmStorageAccountKey -StorageAccountName $StorageAccountName -resourceGroupName $resourceGroupName)[0].Value
    $ctx = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey

    # If file not specified, download the entire container
    If([string]::IsNullOrEmpty($FileName))
    {
        $Blobs = Get-AzureStorageBlob -Container $ContainerName -Context $ctx
        ForEach($Blob in $Blobs)
        {
            #echo $Blob.Name
            Get-AzureStorageBlobContent -Blob $Blob.Name -Container $ContainerName -Destination $LocalFileDirectory -Context $ctx
            #Get-AzureStorageBlobContent -Blob $Blob.Name -Container $ContainerName 

        }
    }
    Else
    {
        # Download file blob
        Get-AzureStorageBlobContent -Blob $FileName -Container $ContainerName -Destination $LocalFileDirectory -Context $ctx
    }

}
#$FileName = "network.json"
Get-BlobFromAzureStorageAccount -SubscriptionID $SubscriptionID -resourceGroupName $resourceGroupName -StorageAccountName $StorageAccountName -ContainerName $ContainerName -LocalFileDirectory $LocalFileDirectory -AzureEnvironment AzureCloud -FileName $FileName  
##############################################################################
