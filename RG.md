# GET_RESOURCE_GROUPS 
## Pre-requisites
In order to connect to the api you require an access token that can be generated with
```
 POST https://login.microsoftonline.com/{{tenantID}}/oauth2/token
```
Once you have setted an access token you can list available resource groups with the following line
```
{{resource}}/subscriptions/{{subscriptionID}}/resourcegroups?api-version=2019-10-01
```
 Being the variables: 
- {{resource}} = https://management.azure.com
- {{subscriptionID}} = your az sub id
- {{tenantID}} = your az tenant id

If you want to check your data, you can use the following commands on cli: 
```
az account subscription list
```
