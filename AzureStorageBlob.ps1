$container_name = 'cloudengartifacts'
$AnonContext = New-AzureStorageContext -StorageAccountName $StorageAccountName -Anonymous;
Get-AzureStorageBlob -Context $AnonContext -Container $ContainerName;
$container_name"https://cloudengartifacts.blob.core.windows.net/templates"
$destination_path = 'C:\Azure\Test'
$connection_string = 'DefaultEndpointsProtocol=https;AccountName=[REPLACEWITHACCOUNTNAME];AccountKey=[REPLACEWITHACCOUNTKEY]'
$storage_account = New-AzureStorageContext -ConnectionString $connection_string
$blobs = Get-AzureStorageBlob -Container $container_name -Context $storage_account

foreach ($blob in $blobs)
    {
		New-Item -ItemType Directory -Force -Path $destination_path
  
        Get-AzureStorageBlobContent `
        -Container $container_name -Blob $blob.Name -Destination $destination_path `
		-Context $storage_account
      
    }