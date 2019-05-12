  # Set target variables
    $subscriptionName = 'Pay-As-You-Go Dev/Test'
    $username="sam.soud@gmail.com"
    $SubscriptionID="81a9ea66-6119-4aa3-8322-fd4abfd5faae"
    Connect-AzureRmAccount -SubscriptionID $SubscriptionID
    
    $Subscription = Get-AzureRmSubscription -SubscriptionID $SubscriptionID | Select-AzureRmSubscription
    Select-AzureRmSubscription -SubscriptionID $SubscriptionID | Set-AzureRmContext
    $resourceGroupName = 'test1'
    $storAcctName = 'storageaccount1235'
    $blobContainerName = 'container01'
	$username="sam.soud@gmail.com"
    
    
    #Login-AzureRmAccount -SubscriptionName $SubscriptionName
	#Login-AzureRmAccount -SubscriptionName $SubscriptionName
	#Get-AzureRmSubscription -SubscriptionName $SubscriptionName | Select-AzureRmSubscription
	#Select-AzureRmSubscription -SubscriptionName $SubscriptionName | Set-AzureRmContext


function Get-AzureSASTokenDynamicsBlobs {

    [CmdletBinding()]
    param()

  

    Write-Verbose "ASM - Checking credentials and setting subscription to: $subscriptionName"
    try {

        Select-AzureRmSubscription -SubscriptionID $SubscriptionID | Set-AzureRmContext
    
    } catch {

        #Add-AzureAccount -Environment azurechinacloud > $null
          Select-AzureRmSubscription -SubscriptionID $SubscriptionID | Set-AzureRmContext
    }
    
    Write-Verbose "ARM - Checking credentials and setting subscription to: $subscriptionName"
    try {

        Set-AzureRmContext -SubscriptionID $SubscriptionID -ErrorAction Stop | Out-Null
    
    } catch {
        
       Login-AzureRmAccount -EnvironmentName azurechinacloud | Out-Null
       Set-AzureRmContext -SubscriptionID $SubscriptionID | Out-Null        
        
    }

    Write-Verbose "Getting ARM Storage Account Key for $storAcctName"
    $storAcct = (Get-AzureRmStorageAccount -ResourceGroupName $resourceGroupName -AccountName $storAcctName)
    $storKey1 = (Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroupName -AccountName $storAcctName).Value[0]
    $storKey2 = (Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroupName -AccountName $storAcctName).Value[1]
    Write-Verbose "Creating new ASM storage context"
    #$storContext = New-AzureStorageContext -StorageAccountName  $storAcctName -StorageAccountKey $storKey1
    #$storContext = New-AzureStorageContext -StorageAccountName  $storAcctName -StorageAccountKey $storKey2
    Write-Verbose "Getting list of blobs in $blobContainerName"
    #$blobContainer = Get-AzureStorageContainer -Name $blobContainerName -Context $storContext
    $blobContainers = Get-AzureStorageContainer -Context $storContext
    $Containers=$blobContainer.CloudBlobContainer.Name

    ###

    Write-Verbose "Blobs are: $blobNames"

    foreach ($Container in $Containers) {

        Write-Verbose "Generating new SAS token for blob: $Container"
        $SASTokenBlob =New-AzureStorageBlobSASToken -Container $Container -Blob $blob -Permission rwd

        New-AzureStorageBlobSASToken -Container "ContainerName" -Blob "BlobName" -Permission rwd
    
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