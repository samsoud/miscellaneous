$SubscriptionName="FreeTrial12345"
$username="samos.soudos@gmail.com"
#Bradp@ca.ibm.com brad 
#mharder@ca.ibm.com   Mark Harder
# @Qwerty321@1
#ADSync.samisousaorg.onmicrosoft.com
#Xumu7705
#samisousaorg
#VM111234
#samossoudos
#@N0rtheast@123
# Connect to your account
## Use Add-AzureAccount instead of Connect-AzureRmAccount 




Add-AzureAccount 
$Subscription=Get-AzureRmSubscription -SubscriptionName $SubscriptionName 
$SubscriptionID=$Subscription.Id
# Specify the subscription that you want to use.
Select-AzureRmSubscription -SubscriptionName $SubscriptionName 
# Create Storage accout
$location ="US East"
$resourceGroupName = "teststoragerg"
New-AzureRmresourceGroupName -Name $resourceGroupName -Location $location 

# Set the name of the storage account and the SKU name. 

$skuName = "Standard_LRS"

# Create the storage account.
$StorageAccountName = "zyabc01zy65tu615" 
$storageAccount = New-AzureRmStorageAccount -resourceGroupName $resourceGroupName `
  -Name $storageAccountName `
  -Location $location `
  -SkuName $skuName

Get-AzureRMStorageAccount -StorageAccountName $StorageAccountName -resourceGroupName $resourceGroupName

$StorageAccountKey = Get-AzureRmStorageAccountKey -StorageAccountName  $StorageAccountName -resourceGroupName $resourceGroupName
$ContainerName = "samcontainer01"
$sourceFileRootDirectory = "C:\Azure\ARMtemplates-masterHOME" # i.e. D:\Docs
$LocalFileDirectory=$sourceFileRootDirectory
$StorageAccountKey = (Get-AzureRmStorageAccountKey -StorageAccountName $StorageAccountName -resourceGroupName $resourceGroupName)[0].Value
$ctx = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey
 ###########################################################################

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
        [String] $SubscriptionName,

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
            If([string]::IsNullOrEmpty($SubscriptionName))
            {
                $SubscriptionName = Read-Host -Prompt "Enter Subscription Name"
            }
            Set-AzureRmContext -SubscriptionName $SubscriptionName
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
Get-BlobFromAzureStorageAccount -SubscriptionName $SubscriptionName -resourceGroupName $resourceGroupName -StorageAccountName $StorageAccountName -ContainerName $ContainerName -LocalFileDirectory $LocalFileDirectory -AzureEnvironment AzureCloud -FileName $FileName  
##############################################################################

Function Get-LatestReleaseFromGitHubRep {
    <#
    .Synopsis
        Downloads the zip file for the latest release from the indicated GitHub repository.
    .Description
        Connects to indicated GitHub repository via REST calls and downloads the zip file for the latest release.
    .Parameter Repository
        GitHub repository name. Includes owner with slash (e.g. CloudEng\myrep).
    .Parameter GitHubToken
        GitHub personal access token (created under user profile). Syntax is owner:token (e.g. cdsid:123456789).
    .Parameter OutputPath
        The directory path to download the zip file to.
    .Ref ZipPath
        Returns the full path of the downloaded zip file.
    .Example
        Get-LatestReleaseFromGitHubRep -Repository "CloudEng\myrep" -GitHubToken "mycdsid:123456789" -OutputPath "C:\Users\mycdsid\Downloads"
    #>
    
    Param (
        [Parameter(Mandatory = $true)]
        [String] $Repository,

        [Parameter(Mandatory = $true)]
        [String] $GitHubToken,

        [Parameter(Mandatory = $true)]
        [String] $OutputPath,

        [Parameter()]
        [ref] $ZipPath
        )

    # Get short repository name to name the zip file with
    $RepositoryName = ($Repository.Split("/"))[1]
    
    # Build REST API call to get latest GitHub release
    $URI = "https://github.ford.com/api/v3/repos/$Repository/releases/latest"

    # Build authorization token to pass to GitHub
    $Base64Token = [System.Convert]::ToBase64String([char[]]$GitHubToken)
    $Headers = @{
        Authorization = 'Basic {0}' -f $Base64Token;
    };

    # Get information on the latest release from the specified GitHub repository via REST call
    $Response = Invoke-RestMethod -Method Get -Uri $URI -Headers $Headers

    # Extract the URL for the latest release's zip file and the Release Tag name
    $ZipUrl = $Response.zipball_url
    $Tag = $Response.tag_name

    # Download the latest release's zip file to the indicated location with name as <Repository Name>_<Release Tag>.zip
    $Zip = $OutputPath + "\${RepositoryName}_$Tag.zip"
    $ZipPath.Value = $Zip
    Invoke-RestMethod -Method Get -Uri $ZipUrl -OutFile $Zip -Headers $Headers

}

Function Get-ReleaseZipFromGitHubRep {
    <#
    .Synopsis
        Downloads the zip file from the provide GitHub zipball URL.
    .Description
        Connects to indicated GitHub repository via REST calls and downloads the zip file from the URL provided.
    .Parameter ZipURL
        URL to GitHub release zip file.
    .Parameter GitHubToken
        GitHub personal access token (created under user profile). Syntax is owner:token (e.g. cdsid:123456789).
    .Parameter OutputPath
        The directory path to download the zip file to.
    .Ref ZipPath
        Returns the full path of the downloaded zip file.
    .Example
        Get-ReleaseZipFromGitHubRep -ZipURL "https://github.ford.com/api/v3/repos/CloudEng/IanTestGit/zipball/v16" -GitHubToken "mycdsid:123456789" -OutputPath "C:\Users\mycdsid\Downloads"
    #>
    
    Param (
        [Parameter(Mandatory = $true)]
        [String] $ZipURL,

        [Parameter(Mandatory = $true)]
        [String] $GitHubToken,

        [Parameter(Mandatory = $true)]
        [String] $OutputPath,

        [Parameter()]
        [ref] $ZipPath
        )

    # Build authorization token to pass to GitHub
    $Base64Token = [System.Convert]::ToBase64String([char[]]$GitHubToken)
    $Headers = @{
        Authorization = 'Basic {0}' -f $Base64Token;
    };

    # Extract the URL for the latest release's zip file and the Release Tag name
    $ZipSplit = $ZipURL -split "repos/"
    $RepoSplit = $ZipSplit[1] -split "/"
    $TagSplit = $ZipURL -split "zipball/"
    $RepositoryName = $RepoSplit[1]
    $Tag = $TagSplit[1]

    # Download the latest release's zip file to the indicated location with name as <Repository Name>_<Release Tag>.zip
    $Zip = $OutputPath + "\${RepositoryName}_$Tag.zip"
    $ZipPath.Value = $Zip
    Invoke-RestMethod -Method Get -Uri $ZipUrl -OutFile $Zip -Headers $Headers

}

Function Expand-Zip {
    <#
    .Synopsis
        Unzips a zip file to the indicated directory.
    .Description
        Unzips a zip file to the indicated directory.
    .Parameter ZipPath
        Path to zip file including zip file name.
    .Ref ExtractPath
        Optional. Path to directory to extract the zip file to. Will be created if it doesn't already exist. If not specified, will extract to a directory with the same name as the zip in the same path as the zip.
    .Switch Force
        Optional. Will delete the extract-to directory if it already exists.
    .Example
        Unzip-Archive -ZipPath "C:\MyZip.zip"
    .Example
        Unzip-Archive -ZipPath "C:\MyZip.zip" -Force
    #>
    
    Param (
        [Parameter(Mandatory = $true)]
        [String] $ZipPath,

        [Parameter()]
        [ref] $ExtractPath,

        [Parameter()]
        [Switch] $Force

        )

    # If ExtractPath not specified, create it from ZipName in same directory as the zip
    If([string]::IsNullOrEmpty($ExtractPath.Value))
    {
        $ZipRoot = (Get-Item $ZipPath).Directory.FullName
        $ZipShortName = (Get-Item $ZipPath).BaseName
        $ExtractPath.Value = $ZipRoot + "\" + $ZipShortName
    }

    # If forcing, then delete existing directory if it already exists
    If($Force -and (Test-Path -Path $ExtractPath.Value))
    {
        Remove-Item -Path $ExtractPath.Value -Recurse -Force
    }

    # Unzip the file
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($ZipPath, $ExtractPath.Value)

}
#############################################################################################################################################################
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
        Add-FilesToAzureStorageAccountBlob -SubscriptionName 'FORD-CLOUDENG-AUTO-F-POC' -ResourceGroupName 'myresourcegroup' -StorageAccountName 'mystorageaccount' -ContainerName 'mycontainer' -FilePath 'C:\MyUploadDir'
    #>
    
    Param (
        [Parameter()]
        [ValidateSet('AzureCloud','AzureChinaCloud')]
        [String] $AzureEnvironment = 'AzureCloud',

        [Parameter()]
        [String] $SubscriptionName,

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
            If([string]::IsNullOrEmpty($SubscriptionName))
            {
                $SubscriptionName = Read-Host -Prompt "Enter Subscription Name"
            }
            Set-AzureRmContext -SubscriptionName $SubscriptionName
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
    

5aac31a4-69de-485c-88ca-782c255dd5bd


    $StorageAccountName="zyabc01zy65tu615"
    $FilePath="C:\Azure\ARMtemplates-masterHOME"
    $resourceGroupName="teststoragerg"
    $ContainerName="samcontainer01"
    $resourceGroupName1="teststoragerg1"
    $StorageAccountName1="zyabc01zy65tu616"
    $skuName1 = "Standard_LRS"

$storageAccount = New-AzureRmStorageAccount -resourceGroupName $resourceGroupName1 `
  -Name $storageAccountName1 `
  -Location $location `
  -SkuName $skuName1
https://zyabc01zy65tu615.blob.core.windows.net/samcontainer01
    
    Add-FilesToAzureStorageAccountBlob -resourceGroupName $resourceGroupName -StorageAccountName $StorageAccountName -ContainerName $ContainerName -FilePath $FilePath
   
    $TemplateUri="https://zyabc01zy65tu615.blob.core.windows.net/templates/nested/network.json"
    $TemplateUri="https://zyabc01zy65tu615.blob.core.windows.net/templates/nested/storage.json"
    $TemplateUri="https://zyabc01zy65tu615.blob.core.windows.net/templates/WindowsVMs.json"
    $TemplateUri="https://zyabc01zy65tu615.blob.core.windows.net/templates/WindowsVMs.json"
    $TemplateUri="https://zyabc01zy65tu615.blob.core.windows.net/templates/catalog/SQLDeployment.json"
    $TemplateUri="https://zyabc01zy65tu615.blob.core.windows.net/templates/nested/loadBalancer.json"
    $TemplateUri="https://zyabc01zy65tu615.blob.core.windows.net/templates/WindowsVMs.json"
    $TemplateUri="https://zyabc01zy65tu615.blob.core.windows.net/templates/LinuxVMs.json"
$TemplateUri="https://zyabc01zy65tu615.blob.core.windows.net/templates/LinuxVMs.json"
    LinuxVMs.json
    $location ="West Europe"
    
    $err[0]

    teststoragerg1

    #New-AzureRmResourceGroup -Name $resourceGroupName1 -Location $location 
    New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName1 -TemplateUri $TemplateUri -storageAccountName $storageAccountName1 -AdminPassword "@We4566hT78tr" -environment Prod 
    New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName1 -TemplateUri $TemplateUri -storageAccountName $storageAccountName1
    test-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName1 -TemplateUri $TemplateUri  -storageAccountName $storageAccountName1 -AdminPassword "@We4566hT78tr" -environment Prod 
    #New-AzureRmResourceGroupDeployment -ResourceGroupName $ResGrp.ResourceGroupName -TemplateFile $TemplateLoc -TemplateParameterObject $Params -Verbose
      New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName1 -TemplateUri $TemplateUri
    ###############################################################################################################################################
    # Get storage account key and context
    $StorageAccountKey = (Get-AzureRmStorageAccountKey -StorageAccountName $StorageAccountName -resourceGroupName $resourceGroupName)[0].Value
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




Function Get-AzureVaultSecrets {

    [CmdletBinding()]

    Param(
    
        [Parameter(Mandatory)][string]$VaultName,
        [Parameter(Mandatory)][String[]]$SecretsNames

    )

    $SecretsValues = @()

    ForEach ($secretKey in $SecretsNames)
    {
        try
        {
            $secretObj = Get-AzureKeyVaultSecret -VaultName $VaultName -Name $secretKey
            $secret = New-Object System.Object
            $secret | Add-Member -type NoteProperty -name SecretKey -value $secretKey
            $secret | Add-Member -type NoteProperty -name SecretValue -value $secretObj.SecretValueText
            $SecretsValues += $secret
        }#try
        catch
        {
            Write-Verbose -Message "Unable to read value for secret '$secretKey', with error " + $_.Exception.GetType().FullName + " " + $_.Exception.Message
        }#catch
    }#foreach

    return $SecretsValues
}#function
 #############################################################################

function Upload-FileToAzureStorageContainer {
    [cmdletbinding()]
    param(
        $StorageAccountName,
        $StorageAccountKey,
        $ContainerName,
        $sourceFileRootDirectory,
        $Force
    )

    $ctx = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey
    $container = Get-AzureStorageContainer -Name $ContainerName -Context $ctx

    $container.CloudBlobContainer.Uri.AbsoluteUri
    if ($container) {
        $filesToUpload = Get-ChildItem $sourceFileRootDirectory -Recurse -File

        foreach ($x in $filesToUpload) {
            $targetPath = ($x.fullname.Substring($sourceFileRootDirectory.Length + 1)).Replace("\", "/")

            Write-Verbose "Uploading $("\" + $x.fullname.Substring($sourceFileRootDirectory.Length + 1)) to $($container.CloudBlobContainer.Uri.AbsoluteUri + "/" + $targetPath)"
            Set-AzureStorageBlobContent -File $x.fullname -Container $container.Name -Blob $targetPath -Context $ctx -Force:$Force | Out-Null
        }
    }
}



Upload-FileToAzureStorageContainer -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey -ContainerName $ContainerName -sourceFileRootDirectory  C:\AAA\Azure\ARMtemplates-masterHOME -Force $Force

"https://$StorageAccountName.blob.core.windows.net/armcontainer/nested/apiManager.json"
"https://$StorageAccountName.blob.core.windows.net/armcontainer'
 
############################################

$fesub1 = New-AzureRmVirtualNetworkSubnetConfig -Name $FESubName1 -AddressPrefix $FESubPrefix1
$besub1 = New-AzureRmVirtualNetworkSubnetConfig -Name $BESubName1 -AddressPrefix $BESubPrefix1
$gwsub1 = New-AzureRmVirtualNetworkSubnetConfig -Name $GWSubName1 -AddressPrefix $GWSubPrefix1

New-AzureRmVirtualNetwork -Name $VNetName1 -resourceGroupName $RG1 `
-Location $Location1 -AddressPrefix $VNetPrefix11,$VNetPrefix12 -Subnet $fesub1,$besub1,$gwsub1

$gwpip1 = New-AzureRmPublicIpAddress -Name $GWIPName1 -resourceGroupName $RG1 `
-Location $Location1 -AllocationMethod Dynamic

$vnet1 = Get-AzureRmVirtualNetwork -Name $VNetName1 -resourceGroupName $RG1
$subnet1 = Get-AzureRmVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $vnet1
$gwipconf1 = New-AzureRmVirtualNetworkGatewayIpConfig -Name $GWIPconfName1 `
-Subnet $subnet1 -PublicIpAddress $gwpip1

#############################

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

New-AzureRmresourceGroupName -Name $RG4 -Location $Location4
$fesub4 = New-AzureRmVirtualNetworkSubnetConfig -Name $FESubName4 -AddressPrefix $FESubPrefix4
$besub4 = New-AzureRmVirtualNetworkSubnetConfig -Name $BESubName4 -AddressPrefix $BESubPrefix4
$gwsub4 = New-AzureRmVirtualNetworkSubnetConfig -Name $GWSubName4 -AddressPrefix $GWSubPrefix4\

New-AzureRmVirtualNetwork -Name $VnetName4 -resourceGroupName $RG4 `
-Location $Location4 -AddressPrefix $VnetPrefix41,$VnetPrefix42 -Subnet $fesub4,$besub4,$gwsub4

$gwpip4 = New-AzureRmPublicIpAddress -Name $GWIPName4 -resourceGroupName $RG4 `
-Location $Location4 -AllocationMethod Dynamic

$vnet4 = Get-AzureRmVirtualNetwork -Name $VnetName4 -resourceGroupName $RG4
$subnet4 = Get-AzureRmVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $vnet4
$gwipconf4 = New-AzureRmVirtualNetworkGatewayIpConfig -Name $GWIPconfName4 -Subnet $subnet4 -PublicIpAddress $gwpip4

New-AzureRmVirtualNetworkGateway -Name $GWName4 -resourceGroupName $RG4 `
-Location $Location4 -IpConfigurations $gwipconf4 -GatewayType Vpn `
-VpnType RouteBased -GatewaySku VpnGw1

#Create the connections
$vnet1gw = Get-AzureRmVirtualNetworkGateway -Name $GWName1 -resourceGroupName $RG1
$vnet4gw = Get-AzureRmVirtualNetworkGateway -Name $GWName4 -resourceGroupName $RG4

# Create the TestVNet1 to TestVNet4 connection
New-AzureRmVirtualNetworkGatewayConnection -Name $Connection14 -resourceGroupName $RG1 `
-VirtualNetworkGateway1 $vnet1gw -VirtualNetworkGateway2 $vnet4gw -Location $Location1 `
-ConnectionType Vnet2Vnet -SharedKey 'AzureA1b2C3'

# Create the TestVNet4 to TestVNet1 connection.

New-AzureRmVirtualNetworkGatewayConnection -Name $Connection41 -resourceGroupName $RG4 `
-VirtualNetworkGateway1 $vnet4gw -VirtualNetworkGateway2 $vnet1gw -Location $Location4 `
-ConnectionType Vnet2Vnet -SharedKey 'AzureA1b2C3' 
#########################################
$settingString='
"Exclusions": { "Exclusions": { "Exclusions": {
"Extensions": ".mdf;.ldf;.ndf;.bak;.trn;", "Extensions": ".mdf;.ldf;.ndf;.bak;.trn;", "Extensions": ".mdf;.ldf;.ndf;.bak;.trn;", "Extensions": ".mdf;.ldf;.ndf;.bak;.trn;", "Extensions": ".mdf;.ldf;.ndf;.bak;.trn;", "Extensions": ".mdf;.ldf;.ndf;.bak;.trn;", "Extensions": ".mdf;.ldf;.ndf;.bak;.trn;", "Extensions": ".mdf;.ldf;.ndf;.bak;.trn;", "Extensions": ".mdf;.ldf;.ndf;.bak;.trn;",
"Paths": D: "Paths": D: "Paths": D:
\
\
Logs;E: Logs;E:
\
\
Databases;C: Databases;C: Databases;C:
\
\
Program Files Program Files Program Files
\
\
Microsoft Microsoft
SQL Server SQL Server
\
\
MSSQL
\
\
FTDATA", FTDATA",
"Processes": "Processes": "Processes":
"SQLServr.exe;ReportingServicesService.MSMDSrv.exe" "SQLServr.exe;ReportingServicesService.MSMDSrv.exe" "SQLServr.exe;ReportingServicesService.MSMDSrv.exe" "SQLServr.exe;ReportingServicesService.MSMDSrv.exe" "SQLServr.exe;ReportingServicesService.MSMDSrv.exe" "SQLServr.exe;ReportingServicesService.MSMDSrv.exe" "SQLServr.exe;ReportingServicesService.MSMDSrv.exe" "SQLServr.exe;ReportingServicesService.MSMDSrv.exe" "SQLServr.exe;ReportingServicesService.MSMDSrv.exe" "SQLServr.exe;ReportingServicesService.MSMDSrv.exe" "SQLServr.exe;ReportingServicesService.MSMDSrv.exe"
}
}
'

$allVersions = (Get-AzureRmVMExtensionImage -Location $location -PublisherName "Microsoft.Azure.Security" -Type "IaaSAntimalware").Version

Set-AzureRmVMExtension -ResourceGroupName $resourceGroupName -VMName $vmName -Name "IaaSAntimalware" -Publisher "Microsoft.Azure.Security" -ExtensionType "IaaSAntimalware" -TypeHandlerVersion $versionString -SettingString $settingString -Location $location