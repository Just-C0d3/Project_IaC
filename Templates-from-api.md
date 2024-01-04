# Manage templates from API.
To deploy a template from api you must take in consideratio that said template must be specified in the body section of postman fe: 
```
{
 "properties": {
   "templateLink": {
     "uri": "heregoesyourtemplateurl",
     "contentVersion": "1.0.0.0"
   },
   "parametersLink": {
     "uri": "heregoesyourparameterurl",
     "contentVersion": "1.0.0.0"
   },
   "mode": "Incremental"
 }
}
```
To deploy your template once you have specified its location you may use the following command: 
```
PUT {{resource}}/subscriptions/{{subscriptionId}}/resourcegroups/{{resourceGroup}}/providers/Microsoft.Resources/deployments/deployfromapi?api-version=2020-10-01
```
Being the variables: 
- {{resource}} = https://management.azure.com
- {{subscriptionID}} = your az sub id
- {{resourceGroup}} = The rg where you want to deploy the template.

To delete a deployment you may use the following command: 
```
DELETE {{resource}}/subscriptions/{{subscriptionId}}/resourceGroups/{{resourceGroup}}/providers/Microsoft.Consumption/budgets/sample-budge?api-version=2023-11-01
```
Being the variables: 
- {{resource}} = https://management.azure.com
- {{subscriptionID}} = your az sub id
- {{resourceGroup}} = The rg where you want to deploy the template.
