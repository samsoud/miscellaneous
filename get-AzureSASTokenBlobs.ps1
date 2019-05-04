  # Set target variables
    $subscriptionName = 'GUIDES-F-DEV'
    $resourceGroupName = 'ggcrmbincne'
    $storAcctName = 'teststor43899009'
    $blobContainerName = 'blobContainerName234'
	SubscriptionName='Pay-as-you-go'
	$username="sam.soud@gmail.com"
	Login-AzureRmAccount -SubscriptionName $SubscriptionName
	Get-AzureRmSubscription -SubscriptionName $SubscriptionName | Select-AzureRmSubscription
	Select-AzureRmSubscription -SubscriptionName $SubscriptionName | Set-AzureRmContext


function Get-AzureSASTokenDynamicsChinaBlobs {

    [CmdletBinding()]
    param()

  

    Write-Verbose "ASM - Checking credentials and setting subscription to: $subscriptionName"
    try {

        Select-AzureSubscription -SubscriptionName $subscriptionName -Current -ErrorAction Stop > $null
    
    } catch {

        Add-AzureAccount -Environment azurechinacloud > $null
        Select-AzureSubscription -SubscriptionName $subscriptionName -Current > $null
    }
    
    Write-Verbose "ARM - Checking credentials and setting subscription to: $subscriptionName"
    try {

        Set-AzureRmContext -SubscriptionName $subscriptionName -ErrorAction Stop | Out-Null
    
    } catch {
        
       Login-AzureRmAccount -EnvironmentName azurechinacloud | Out-Null
       Set-AzureRmContext -SubscriptionName $subscriptionName | Out-Null        
        
    }

    Write-Verbose "Getting ARM Storage Account Key for $storAcctName"
    $storAcct = (Get-AzureRmStorageAccount -ResourceGroupName $resourceGroupName).where({$PSITEM.StorageAccountName -eq $storAcctName})
    $storKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $storAcct.ResourceGroupName -Name $storAcct.StorageAccountName).where({$PSItem.KeyName -eq 'key1'})

    Write-Verbose "Creating new ASM storage context"
    $storContext = New-AzureStorageContext -StorageAccountName $storAcct.StorageAccountName -StorageAccountKey $storKey.Value

    Write-Verbose "Getting list of blobs in $blobContainerName"
    $blobContainer = Get-AzureStorageContainer -Name $blobContainerName -Context $storContext
    $blobNames = $blobContainer.CloudBlobContainer.ListBlobs().Name 

    Write-Verbose "Blobs are: $blobNames"

    foreach ($blobName in $blobNames) {

        Write-Verbose "Generating new SAS token for blob: $blobName"
        $SASTokenBlob = New-AzureStorageBlobSASToken -Context $storContext -Container $blobContainer.Name -Blob $blobName -StartTime (Get-Date).AddMinutes(-15) -ExpiryTime (Get-Date).AddDays(1) -Permission rwd
    
        # create URIs for the blob
        $baseURI = "https://$storAcctName.blob.core.chinacloudapi.cn/$blobContainerName"
        $blobURI = $baseURI + '/' + $blobName + $SASTokenBlob
    
             
        switch -Wildcard ($blobName) {
    
            '*MMASetup*' {$Name = 'mmaTokenURI'}
            '*SQL_Svr*'  {$Name = 'sqlTokenURI'}
            '*Dyn_CRM*'  {$Name = 'dynTokenURI'}
            'NDP452*'    {$Name = 'sdkTokenURI'}
            'SEPv12*'    {$Name = 'sepTokenURI'}
             default     {$Name = ''}

        }

        # test token embedded blob URI
        #Invoke-WebRequest -Uri $blobURI -OutFile C:\Scripts-C\downloads\$blobName

        if ($Name) { 
        
            [PSCUSTOMOBJECT] @{
            
            'Name' = $Name;
            'FileName' = $blobName ;
            'URI' = $blobURI
            
            }

        }#if

    }#foreach

}#function