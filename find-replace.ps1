$find = 'https://cloudengartifacts.blob.core.windows.net/templates'
$replace = 'https://cloudengartifacts.blob.core.windows.net/templates'
$match =  '*.json'
$preview = $true

foreach ($sc in dir -recurse -include $match | where { test-path $_.fullname -pathtype leaf} ) {
    select-string -path $sc -pattern $find
    if (!$preview) {
       (get-content $sc) | foreach-object { $_ -replace $find, $replace } | set-content $sc
    }
}


https://samsoudstorage123.blob.core.windows.net/container01