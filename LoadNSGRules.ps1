Login-AzureRmAccount -EnvironmentName AzureCloud

Set-AzureRmContext -SubscriptionName AZ-MKTSALES-FORDMATCH-PREPROD

Update-AzureRmCustomNetworkSecurityGroup -CSVPath "C:\Users\iyoumans\Documents\GitHub\FordMatch\QA\RulesDatastaxEast.csv" -ResourceGroupName az-use-mss-fordmatch-dse-qa -NetworkSecurityGroupName azusefmdseqa01-nsg
Update-AzureRmCustomNetworkSecurityGroup -CSVPath "C:\Users\iyoumans\Documents\GitHub\FordMatch\QA\RulesDatastaxWest.csv" -ResourceGroupName az-usw-mss-fordmatch-dse-qa -NetworkSecurityGroupName azuswfmdseqa01-nsg
Update-AzureRmCustomNetworkSecurityGroup -CSVPath "C:\Users\iyoumans\Documents\GitHub\FordMatch\QA\RulesJumpboxWest.csv" -ResourceGroupName az-usw-mss-fordmatch-dse-qa -NetworkSecurityGroupName azuswfmqa01-nsg
