provider "azurerm" {
  features {}
}

 
resource "azurerm_application_insights_workbook" "fromtf" {
  name                = "yoursamplename"
  resource_group_name = "exprg"
  location            = "northeurope"
  display_name        = "RgDisplayedName"
  data_json = jsonencode({
    "version": "Notebook/1.0",
  "items": [
    {
      "type": 1,
      "content": {
        "json": "## Sing in location\n---\n\nThis workbook contains the user logins and displays the information in a map"
      },
      "name": "text - 2"
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "SigninLogs\n| summarize count() by UserDisplayName, Location, AuthenticationMethodsUsed, IPAddress, Id\n| order by count_ desc",
        "size": 0,
        "timeContext": {
          "durationMs": 2592000000
        },
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces",
        "visualization": "map",
        "mapSettings": {
          "locInfo": "CountryRegion",
          "locInfoColumn": "Location",
          "sizeSettings": "Location",
          "sizeAggregation": "Count",
          "labelSettings": "Location",
          "legendMetric": "count_",
          "legendAggregation": "Sum",
          "itemColorSettings": {
            "nodeColorField": "count_",
            "colorAggregation": "Sum",
            "type": "heatmap",
            "heatmapPalette": "greenRed"
          }
        }
      },
      "name": "query - 2"
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "SigninLogs\r\n| summarize count() by UserDisplayName, Location, AuthenticationMethodsUsed, IPAddress, Id, AppDisplayName\r\n| order by count_ desc",
        "size": 0,
        "timeContext": {
          "durationMs": 2592000000
        },
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces"
      },
      "name": "query - 2"
    }
  ],
  "fallbackResourceIds": [
    "/subscriptions/yoursub/resourcegroups/yourrg/providers/microsoft.operationalinsights/workspaces/yourworkspace"
  ],
  "dataSources": [
    {
      "kind": "AzureMonitorInsights",
      "name": "ApplicationInsights",
      "workspaceResourceId": "/subscriptions/yoursub/resourcegroups/yourrg/providers/microsoft.operationalinsights/workspaces/yourworkspace"
    }
  ],
  "$schema": "https://github.com/Microsoft/Application-Insights-Workbooks/blob/master/schema/workbook.json"
  })

  tags = {
    ENV = "Test"
  }
}
resource "azurerm_application_insights_workbook" "fromtf2" {
  name                = "rgname2"
  resource_group_name = "exprg"
  location            = "northeurope"
  display_name        = "RgDisplayedName2"
  data_json = jsonencode({
    "version": "Notebook/1.0",
  "items": [
    {
      "type": 9,
      "content": {
        "version": "KqlParameterItem/1.0",
        "crossComponentResources": [
          "value::all"
        ],
        "parameters": [
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "DefaultWorkspace",
            "type": 5,
            "isRequired": true,
            "value": "value::1",
            "isHiddenWhenLocked": true,
            "typeSettings": {
              "resourceTypeFilter": {
                "microsoft.operationalinsights/workspaces": true
              },
              "additionalResourceOptions": [
                "value::1"
              ]
            }
          },
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "ContextFree",
            "type": 1,
            "query": "{\"version\":\"1.0.0\",\"content\":\"\\\"{DefaultWorkspace}\\\"\"}",
            "isHiddenWhenLocked": true,
            "queryType": 8
          },
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "Selection",
            "type": 1,
            "query": "where type =~ 'microsoft.operationalinsights/workspaces'\r\n| extend match = strcat(\"'\", id, \"'\") =~ \"{DefaultWorkspace:value}\"\r\n| order by match desc, name asc\r\n| take 1\r\n| project value = tostring(pack('sub', subscriptionId, 'rg', resourceGroup, 'ws', id))",
            "crossComponentResources": [
              "value::all"
            ],
            "isHiddenWhenLocked": true,
            "queryType": 1,
            "resourceType": "microsoft.resourcegraph/resources"
          }
        ],
        "style": "formVertical",
        "queryType": 1,
        "resourceType": "microsoft.resourcegraph/resources"
      },
      "conditionalVisibility": {
        "parameterName": "_",
        "comparison": "isEqualTo",
        "value": "_"
      },
      "name": "parameters - 0"
    },
    {
      "type": 1,
      "content": {
        "json": "# Performance Analysis"
      },
      "conditionalVisibility": {
        "parameterName": "ContextFree",
        "comparison": "isEqualTo",
        "value": "value::1"
      },
      "name": "text - 1"
    },
    {
      "type": 9,
      "content": {
        "version": "KqlParameterItem/1.0",
        "crossComponentResources": [
          "{Workspaces}"
        ],
        "parameters": [
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "Subscriptions",
            "type": 6,
            "isRequired": true,
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "query": "summarize by subscriptionId\r\n| project value = strcat('/subscriptions/', subscriptionId), label = subscriptionId, selected = iff(subscriptionId =~ todynamic('{Selection}').sub, true, false)",
            "crossComponentResources": [
              "value::all"
            ],
            "typeSettings": {
              "additionalResourceOptions": []
            },
            "queryType": 1,
            "resourceType": "microsoft.resourcegraph/resources"
          },
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "Workspaces",
            "type": 5,
            "isRequired": true,
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "query": "where type =~ 'microsoft.operationalinsights/workspaces'\r\n| summarize by id, name\r\n| project id, selected = iff(id =~ todynamic('{Selection}').ws, true, false)",
            "crossComponentResources": [
              "{Subscriptions}"
            ],
            "typeSettings": {
              "resourceTypeFilter": {
                "microsoft.operationalinsights/workspaces": true
              },
              "additionalResourceOptions": []
            },
            "queryType": 1,
            "resourceType": "microsoft.resourcegraph/resources",
            "value": [
              "/subscriptions/yoursub/resourceGroups/DefaultResourceGroup-EUS/providers/Microsoft.OperationalInsights/workspaces/DefaultWorkspace-yoursub-EUS"
            ]
          },
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "TimeRange",
            "type": 4,
            "value": {
              "durationMs": 2592000000
            },
            "typeSettings": {
              "selectableValues": [
                {
                  "durationMs": 300000,
                  "createdTime": "2018-10-04T22:01:18.372Z",
                  "isInitialTime": false,
                  "grain": 1,
                  "useDashboardTimeRange": false
                },
                {
                  "durationMs": 900000,
                  "createdTime": "2018-10-04T22:01:18.372Z",
                  "isInitialTime": false,
                  "grain": 1,
                  "useDashboardTimeRange": false
                },
                {
                  "durationMs": 1800000,
                  "createdTime": "2018-10-04T22:01:18.372Z",
                  "isInitialTime": false,
                  "grain": 1,
                  "useDashboardTimeRange": false
                },
                {
                  "durationMs": 3600000,
                  "createdTime": "2018-10-04T22:01:18.372Z",
                  "isInitialTime": false,
                  "grain": 1,
                  "useDashboardTimeRange": false
                },
                {
                  "durationMs": 14400000,
                  "createdTime": "2018-10-04T22:01:18.374Z",
                  "isInitialTime": false,
                  "grain": 1,
                  "useDashboardTimeRange": false
                },
                {
                  "durationMs": 43200000,
                  "createdTime": "2018-10-04T22:01:18.374Z",
                  "isInitialTime": false,
                  "grain": 1,
                  "useDashboardTimeRange": false
                },
                {
                  "durationMs": 86400000,
                  "createdTime": "2018-10-04T22:01:18.374Z",
                  "isInitialTime": false,
                  "grain": 1,
                  "useDashboardTimeRange": false
                },
                {
                  "durationMs": 172800000,
                  "createdTime": "2018-10-04T22:01:18.374Z",
                  "isInitialTime": false,
                  "grain": 1,
                  "useDashboardTimeRange": false
                },
                {
                  "durationMs": 259200000,
                  "createdTime": "2018-10-04T22:01:18.375Z",
                  "isInitialTime": false,
                  "grain": 1,
                  "useDashboardTimeRange": false
                },
                {
                  "durationMs": 604800000,
                  "createdTime": "2018-10-04T22:01:18.375Z",
                  "isInitialTime": false,
                  "grain": 1,
                  "useDashboardTimeRange": false
                },
                {
                  "durationMs": 1209600000,
                  "createdTime": "2018-10-04T22:01:18.375Z",
                  "isInitialTime": false,
                  "grain": 1,
                  "useDashboardTimeRange": false
                },
                {
                  "durationMs": 2592000000,
                  "createdTime": "2018-10-04T22:01:18.375Z",
                  "isInitialTime": false,
                  "grain": 1,
                  "useDashboardTimeRange": false
                },
                {
                  "durationMs": 5184000000,
                  "createdTime": "2018-10-04T22:01:18.375Z",
                  "isInitialTime": false,
                  "grain": 1,
                  "useDashboardTimeRange": false
                },
                {
                  "durationMs": 7776000000,
                  "createdTime": "2018-10-04T22:01:18.375Z",
                  "isInitialTime": false,
                  "grain": 1,
                  "useDashboardTimeRange": false
                }
              ],
              "allowCustom": true
            },
            "label": "Time Range"
          },
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "Test",
            "label": "Not Onboarded",
            "type": 1,
            "query": "let sm = VMComputer | extend ResourceId=strcat('machines/', Machine) | extend Bitness=columnifexists('Bitness', '')\r\n| where TimeGenerated {TimeRange}\r\n| take 1;\r\nInsightsMetrics\r\n| where TimeGenerated {TimeRange}\r\n| take 1\r\n| union sm\r\n| summarize count()",
            "crossComponentResources": [
              "{Workspaces}"
            ],
            "isHiddenWhenLocked": true,
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces"
          }
        ],
        "style": "above",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces"
      },
      "name": "parameters - 2"
    },
    {
      "type": 1,
      "content": {
        "json": "⚠ A subscription has not yet been selected. Select a subscription under the `Subscriptions` dropdown or refresh the workbook."
      },
      "conditionalVisibility": {
        "parameterName": "Subscriptions",
        "comparison": "isEqualTo",
        "value": null
      },
      "name": "text - 29"
    },
    {
      "type": 1,
      "content": {
        "json": "⚠ Your workspace `{Workspaces:label}` does not have the necessary information for the specified time period (`{TimeRange:label}`) to show performance metrics. Try a broader time range, select a different workspace, or onboard virtual machines to the selected workspace.\r\n\r\nIf you choose to onboard virtual machines to workspace `{Workspaces:label}`, follow the instruction in the following link: [Azure Monitor for VMs (preview)](https://docs.microsoft.com/en-us/azure/azure-monitor/insights/vminsights-overview)."
      },
      "conditionalVisibility": {
        "parameterName": "Test",
        "comparison": "isEqualTo",
        "value": null
      },
      "name": "text - 3"
    },
    {
      "type": 11,
      "content": {
        "version": "LinkItem/1.0",
        "style": "tabs",
        "links": [
          {
            "id": "yourid",
            "cellValue": "tab",
            "linkTarget": "parameter",
            "linkLabel": "Top 100 Machines",
            "subTarget": "top100",
            "style": "link"
          },
          {
            "id": "yourid",
            "cellValue": "tab",
            "linkTarget": "parameter",
            "linkLabel": "Top 10 Machines",
            "subTarget": "top10",
            "style": "link"
          }
        ]
      },
      "name": "links - 28"
    },
    {
      "type": 9,
      "content": {
        "version": "KqlParameterItem/1.0",
        "crossComponentResources": [
          "{Workspaces}"
        ],
        "parameters": [
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "ComputerNameContains",
            "label": "Computer Name Contains",
            "type": 1,
            "description": "This will filter the computers whose name contains the keyword. This will query all the machines in the workspace.",
            "value": ""
          },
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "ComputerFilter",
            "type": 1,
            "query": "{\"version\":\"1.0.0\",\"content\":\"{\\\"snippet\\\": \\\"| where Computer contains '{ComputerNameContains}'\\\"}\"}",
            "crossComponentResources": [
              "{Workspaces}"
            ],
            "isHiddenWhenLocked": true,
            "queryType": 8
          },
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "Counter",
            "type": 2,
            "description": "Select a VM performance counter for the table below",
            "query": "InsightsMetrics\r\n| where TimeGenerated {TimeRange}\r\n| summarize by Namespace, Name, CounterText = Name\r\n| order by Name asc, Namespace asc\r\n| project Counter = pack('counter', Name, 'object', Namespace), CounterText, group = Namespace",
            "crossComponentResources": [
              "{Workspaces}"
            ],
            "typeSettings": {
              "additionalResourceOptions": []
            },
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces",
            "value": null
          },
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "CounterText",
            "type": 1,
            "query": "let metric = dynamic({Counter});\r\nrange Steps from 1 to 1 step 1\r\n| project strcat(metric.object, \" > \", metric.counter)",
            "crossComponentResources": [
              "{Workspaces}"
            ],
            "isHiddenWhenLocked": true,
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces",
            "value": null
          },
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "Aggregators",
            "type": 2,
            "description": "Select one or more different aggregates to display in the table below",
            "isRequired": true,
            "multiSelect": true,
            "quote": "",
            "delimiter": ",",
            "typeSettings": {
              "additionalResourceOptions": []
            },
            "jsonData": "[\r\n    { \"value\":\"Average\", \"label\":\"Average\", \"selected\": true },\r\n    { \"value\":\"P5th\", \"label\":\"P5th\", \"selected\": false },\r\n    { \"value\":\"P10th\", \"label\":\"P10th\", \"selected\": false },\r\n    { \"value\":\"P50th\", \"label\":\"P50th\", \"selected\": false },\r\n    { \"value\":\"P80th\", \"label\":\"P80th\", \"selected\": false },\r\n    { \"value\":\"P90th\", \"label\":\"P90th\", \"selected\": false },\r\n    { \"value\":\"P95th\", \"label\":\"P95th\", \"selected\": true },\r\n    { \"value\":\"Min\", \"label\":\"Min\", \"selected\": false },\r\n    { \"value\":\"Max\", \"label\":\"Max\", \"selected\": true }\r\n]",
            "value": [
              "Average",
              "P95th",
              "Max"
            ]
          },
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "TableTrend",
            "type": 2,
            "description": "Select a percentile to display in the Trend column in the table below",
            "isRequired": true,
            "typeSettings": {
              "additionalResourceOptions": []
            },
            "jsonData": "[\r\n    { \"value\":\"Average = round(avg(Val), 2)\", \"label\":\"Average\", \"selected\": true },\r\n    { \"value\":\"P5th = round(percentile(Val, 5), 2)\", \"label\":\"P5th\", \"selected\": false },\r\n    { \"value\":\"P10th = round(percentile(Val, 10), 2)\", \"label\":\"P10th\", \"selected\": false },\r\n    { \"value\":\"P50th = round(percentile(Val, 50), 2)\", \"label\":\"P50th\", \"selected\": false },\r\n    { \"value\":\"P80th = round(percentile(Val, 80), 2)\", \"label\":\"P80th\", \"selected\": false },\r\n    { \"value\":\"P90th = round(percentile(Val, 90), 2)\", \"label\":\"P90th\", \"selected\": false },\r\n    { \"value\":\"P95th = round(percentile(Val, 95), 2)\", \"label\":\"P95th\", \"selected\": false }\r\n]"
          },
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "tableTrendOrder",
            "type": 1,
            "query": "range Steps from 1 to 1 step 1\r\n| project value = iff('{TableTrend}' contains 'P5th'  or '{TableTrend}' contains 'P10th', 'asc', 'desc')",
            "crossComponentResources": [
              "{Workspaces}"
            ],
            "isHiddenWhenLocked": true,
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces"
          },
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "mergedAggregators",
            "type": 1,
            "query": "let aggregators = iff('{Aggregators}' contains '{TableTrend:label}', '{Aggregators}', '{Aggregators},{TableTrend:label}');\r\nrange Steps from 1 to 1 step 1\r\n| project aggregators",
            "crossComponentResources": [
              "{Workspaces}"
            ],
            "isHiddenWhenLocked": true,
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces"
          },
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "ShowTable",
            "type": 1,
            "query": "print iff(\"{Test:value}\" == \"\", \"False\", \"True\")",
            "crossComponentResources": [
              "{Workspaces}"
            ],
            "isHiddenWhenLocked": true,
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces"
          },
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "CounterTest",
            "type": 1,
            "query": "InsightsMetrics\r\n| take 1",
            "crossComponentResources": [
              "{Workspaces}"
            ],
            "isHiddenWhenLocked": true,
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces"
          }
        ],
        "style": "above",
        "queryType": 0,
        "resourceType": "microsoft.insights/components"
      },
      "conditionalVisibilities": [
        {
          "parameterName": "Test",
          "comparison": "isNotEqualTo",
          "value": null
        },
        {
          "parameterName": "tab",
          "comparison": "isEqualTo",
          "value": "top100"
        }
      ],
      "name": "parameters - 6"
    },
    {
      "type": 1,
      "content": {
        "json": "There are no performance counters, either onboard machines to this workspace or enable performance counters."
      },
      "conditionalVisibilities": [
        {
          "parameterName": "CounterTest",
          "comparison": "isEqualTo",
          "value": ""
        },
        {
          "parameterName": "tab",
          "comparison": "isEqualTo",
          "value": "top100"
        }
      ],
      "name": "text - 7"
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "let maxResultCount = 100; let metric = dynamic({Counter}); let summaryPerComputer = totable(InsightsMetrics      | where TimeGenerated {TimeRange}   {ComputerFilter}    | where Namespace == metric.object and Name == metric.counter     | summarize hint.shufflekey = Computer Average = avg(Val), Max = max(Val), Min = min(Val), percentiles(Val, 5, 10, 50, 80, 90, 95) by Computer      | project Computer, Average, Max, Min, P5th = percentile_Val_5, P10th = percentile_Val_10, P50th = percentile_Val_50, P80th = percentile_Val_80, P90th = percentile_Val_90, P95th = percentile_Val_95      | order by {TableTrend:label} {tableTrendOrder}, Computer      | limit maxResultCount);  let computerList = summaryPerComputer      | project Computer;  let MachineSummary = VMComputer | extend ResourceId=strcat('machines/', Machine) | extend Bitness=columnifexists('Bitness', '')     | where TimeGenerated {TimeRange}     | where Computer in (computerList)     | summarize arg_max(TimeGenerated, *) by Computer     | project Computer, MachineSummary = pack('Fully Qualified Domain Name', Computer, 'OS Type', OperatingSystemFamily, 'Operating System', OperatingSystemFullName, 'Ipv4 Addresses', Ipv4Addresses,         'Ipv6 Addresses', Ipv6Addresses, 'Mac Addresses', MacAddresses, 'DNS Names', DnsNames, 'CPUs', strcat(Cpus, ' @ ', CpuSpeed, ' MHz'), 'Bitness', Bitness,         'Physcial Memory', strcat(PhysicalMemoryMB, ' MB'), 'Virtualization State', VirtualizationState, 'VM Type', VirtualMachineType, 'OMS Agent', split(Machine, 'm-')[1]); let EmptyNodeIdentityAndProps = datatable(Computer:string, NodeId:string, NodeProps:dynamic, Priority: long) []; let OmsNodeIdentityAndProps = computerList     | extend NodeId = Computer     | extend Priority = 1     | extend NodeProps = pack('type', 'StandAloneNode', 'name', Computer); let ServiceMapNodeIdentityAndProps = VMComputer | extend ResourceId=strcat('machines/', Machine) | extend Bitness=columnifexists('Bitness', '')     | where TimeGenerated {TimeRange}     | where Computer in (computerList)     | summarize arg_max(TimeGenerated, *) by Computer     | extend AzureCloudServiceNodeIdentity = iif(isnotempty(AzureCloudServiceName), strcat(AzureCloudServiceInstanceId, '|',                     AzureCloudServiceDeployment), ''),          AzureScaleSetNodeIdentity = iif(isnotempty(AzureVmScaleSetName),              strcat(AzureVmScaleSetInstanceId, '|',                     AzureVmScaleSetDeployment), ''),          ComputerProps =              pack('type', 'StandAloneNode',                   'name', Computer,                   'mappingResourceId', ResourceId,                   'subscriptionId', AzureSubscriptionId,                   'resourceGroup', AzureResourceGroup,                   'azureResourceId', columnifexists('_ResourceId', '')),          AzureCloudServiceNodeProps =              pack('type', 'AzureCloudServiceNode',                   'cloudServiceInstanceId', AzureCloudServiceInstanceId,                   'cloudServiceRoleName', columnifexists('AzureCloudServiceRoleName', ''),                   'cloudServiceDeploymentId', AzureCloudServiceDeployment,                   'cloudServiceName', AzureCloudServiceName,                   'mappingResourceId', ResourceId),          AzureScaleSetNodeProps =               pack('type', 'AzureScaleSetNode',                   'scaleSetInstanceId', columnifexists('Computer', ''),                   'vmScaleSetDeploymentId', AzureVmScaleSetDeployment,                   'vmScaleSetName', AzureVmScaleSetName,                   'serviceFabricClusterName', AzureServiceFabricClusterName,                   'vmScaleSetResourceId', AzureVmScaleSetResourceId,                   'resourceGroupName', columnifexists('AzureResourceGroup', ''),                   'subscriptionId', columnifexists('AzureSubscriptionId', ''),                   'mappingResourceId', ResourceId)| project   Computer,            NodeId = case(isnotempty(AzureCloudServiceNodeIdentity), AzureCloudServiceNodeIdentity,                       isnotempty(AzureScaleSetNodeIdentity), AzureScaleSetNodeIdentity, Computer),            NodeProps = case(isnotempty(AzureCloudServiceNodeIdentity), AzureCloudServiceNodeProps,                          isnotempty(AzureScaleSetNodeIdentity), AzureScaleSetNodeProps, ComputerProps),            Priority = 2; let NodeIdentityAndProps = union kind=inner isfuzzy = true                                  EmptyNodeIdentityAndProps, OmsNodeIdentityAndProps, ServiceMapNodeIdentityAndProps                                 | summarize arg_max(Priority, *) by Computer;  let NodeIdentityAndPropsMin = NodeIdentityAndProps     | extend Type = iff(NodeProps.type == 'StandAloneNode', iff(NodeProps.azureResourceId == '', 'Non-Azure Virtual Machine', 'Azure Virtual Machine'), NodeProps.type),      ResourceId = iff(NodeProps.type == 'AzureScaleSetNode', NodeProps.vmScaleSetResourceId,          iff(NodeProps.type == 'AzureCloudServiceNode', NodeProps.cloudServiceDeploymentId, Computer)),     ResourceName = iff(NodeProps.type == 'AzureScaleSetNode', strcat(NodeProps.vmScaleSetName, ' | ', NodeProps.scaleSetInstanceId),          iff(NodeProps.type == 'AzureCloudServiceNode', strcat(NodeProps.cloudServiceRoleName, ' | ', NodeProps.cloudServiceInstanceId), Computer))     | project Computer, Type, ResourceId, ResourceName; let trend = InsightsMetrics          | where TimeGenerated {TimeRange}         | where Computer in (computerList)          | where Namespace == metric.object and Name == metric.counter        | make-series {TableTrend} default = 0 on TimeGenerated from {TimeRange:start} to {TimeRange:end} step {TimeRange:grain} by Computer     | project Computer, ['Trend ({TableTrend:label})'] = {TableTrend:label}; summaryPerComputer     | join kind=leftouter (trend) on Computer     | join kind=leftouter (NodeIdentityAndProps) on Computer     | join kind=leftouter (NodeIdentityAndPropsMin) on Computer     | join kind=leftouter (MachineSummary) on Computer     | project ResourceName, Type, {mergedAggregators}, ['Trend ({TableTrend:label})'], Properties = MachineSummary     | sort by {TableTrend:label} {tableTrendOrder}\r\n",
        "size": 0,
        "noDataMessage": "There is no data for this counter, either enable the counter or onboard machines to this workspace",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces",
        "crossComponentResources": [
          "{Workspaces}"
        ],
        "visualization": "table",
        "gridSettings": {
          "formatters": [
            {
              "columnMatch": "Type",
              "formatter": 1,
              "formatOptions": {}
            },
            {
              "columnMatch": "Average",
              "formatter": 8,
              "formatOptions": {
                "palette": "blue"
              },
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal"
                }
              }
            },
            {
              "columnMatch": "P50th",
              "formatter": 8,
              "formatOptions": {
                "palette": "blue"
              },
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal"
                }
              }
            },
            {
              "columnMatch": "Trend (Average)",
              "formatter": 10,
              "formatOptions": {
                "palette": "blue"
              }
            },
            {
              "columnMatch": "Properties",
              "formatter": 7,
              "formatOptions": {
                "linkTarget": "CellDetails",
                "linkLabel": "ℹ️ Info"
              }
            },
            {
              "columnMatch": "P95th",
              "formatter": 8,
              "formatOptions": {
                "palette": "blue"
              },
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal"
                }
              }
            },
            {
              "columnMatch": "P5th",
              "formatter": 8,
              "formatOptions": {
                "palette": "blue"
              },
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal"
                }
              }
            },
            {
              "columnMatch": "P10th",
              "formatter": 8,
              "formatOptions": {
                "palette": "blue"
              },
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal"
                }
              }
            },
            {
              "columnMatch": "P80th",
              "formatter": 8,
              "formatOptions": {
                "palette": "blue"
              },
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal"
                }
              }
            },
            {
              "columnMatch": "P90th",
              "formatter": 8,
              "formatOptions": {
                "palette": "blue"
              },
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal"
                }
              }
            },
            {
              "columnMatch": "Min",
              "formatter": 8,
              "formatOptions": {
                "palette": "blue"
              },
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal"
                }
              }
            },
            {
              "columnMatch": "Max",
              "formatter": 8,
              "formatOptions": {
                "palette": "blue"
              },
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal"
                }
              }
            },
            {
              "columnMatch": "Trend (P95th)",
              "formatter": 10,
              "formatOptions": {
                "palette": "blue"
              }
            },
            {
              "columnMatch": "Trend (P5th)",
              "formatter": 10,
              "formatOptions": {
                "palette": "blue"
              }
            },
            {
              "columnMatch": "Trend (P90th)",
              "formatter": 10,
              "formatOptions": {
                "palette": "blue"
              }
            },
            {
              "columnMatch": "Trend (P80th)",
              "formatter": 10,
              "formatOptions": {
                "palette": "blue"
              }
            },
            {
              "columnMatch": "Trend (P50th)",
              "formatter": 10,
              "formatOptions": {
                "palette": "blue"
              }
            },
            {
              "columnMatch": "Trend (P10th)",
              "formatter": 10,
              "formatOptions": {
                "palette": "blue"
              }
            }
          ]
        }
      },
      "conditionalVisibilities": [
        {
          "parameterName": "ShowTable",
          "comparison": "isEqualTo",
          "value": "True"
        },
        {
          "parameterName": "tab",
          "comparison": "isEqualTo",
          "value": "top100"
        }
      ],
      "name": "query - 8"
    },
    {
      "type": 1,
      "content": {
        "json": "### CPU Utilization %"
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "top10"
      },
      "customWidth": "50",
      "name": "text - 12"
    },
    {
      "type": 1,
      "content": {
        "json": "### Available Memory"
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "top10"
      },
      "customWidth": "50",
      "name": "text - 13"
    },
    {
      "type": 9,
      "content": {
        "version": "KqlParameterItem/1.0",
        "parameters": [
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "Aggregate",
            "type": 2,
            "isRequired": true,
            "value": "Average = round(avg(Val), 2)",
            "typeSettings": {
              "additionalResourceOptions": []
            },
            "jsonData": "[\r\n    { \"value\":\"Average = round(avg(Val), 2)\", \"label\":\"Average\"},\r\n    { \"value\":\"P5th = round(percentile(Val, 5), 2)\", \"label\":\"P5th\"},\r\n    { \"value\":\"P10th = round(percentile(Val, 10), 2)\", \"label\":\"P10th\"},\r\n    { \"value\":\"P50th = round(percentile(Val, 50), 2)\", \"label\":\"P50th\"},\r\n    { \"value\":\"P80th = round(percentile(Val, 80), 2)\", \"label\":\"P80th\"},\r\n    { \"value\":\"P90th = round(percentile(Val, 90), 2)\", \"label\":\"P90th\"},\r\n    { \"value\":\"P95th = round(percentile(Val, 95), 2)\", \"label\":\"P95th\"}\r\n]"
          },
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "aggregateOrderLeft",
            "type": 1,
            "query": "range Steps from 1 to 1 step 1\r\n| project value = iff('{Aggregate}' contains 'P5th'  or '{Aggregate}' contains 'P10th', 'asc', 'desc')",
            "crossComponentResources": [
              "{Workspaces}"
            ],
            "isHiddenWhenLocked": true,
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces"
          },
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "aggregateLeftValue",
            "type": 1,
            "isRequired": true,
            "query": "print \"{Aggregate:value}\"",
            "crossComponentResources": [
              "{Workspaces}"
            ],
            "isHiddenWhenLocked": true,
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces"
          },
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "aggregateLeftLabel",
            "type": 1,
            "isRequired": true,
            "query": "print \"{Aggregate:label}\"",
            "crossComponentResources": [
              "{Workspaces}"
            ],
            "isHiddenWhenLocked": true,
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces"
          }
        ],
        "style": "above",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces"
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "top10"
      },
      "customWidth": "50",
      "name": "parameters - 14"
    },
    {
      "type": 9,
      "content": {
        "version": "KqlParameterItem/1.0",
        "parameters": [
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "Aggregate",
            "type": 2,
            "isRequired": true,
            "value": "Average = round(avg(Val), 2)",
            "typeSettings": {
              "additionalResourceOptions": []
            },
            "jsonData": "[\r\n    { \"value\":\"Average = round(avg(Val), 2)\", \"label\":\"Average\"},\r\n    { \"value\":\"P5th = round(percentile(Val, 5), 2)\", \"label\":\"P5th\"},\r\n    { \"value\":\"P10th = round(percentile(Val, 10), 2)\", \"label\":\"P10th\"},\r\n    { \"value\":\"P50th = round(percentile(Val, 50), 2)\", \"label\":\"P50th\"},\r\n    { \"value\":\"P80th = round(percentile(Val, 80), 2)\", \"label\":\"P80th\"},\r\n    { \"value\":\"P90th = round(percentile(Val, 90), 2)\", \"label\":\"P90th\"},\r\n    { \"value\":\"P95th = round(percentile(Val, 95), 2)\", \"label\":\"P95th\"}\r\n]"
          },
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "aggregateOrderRight",
            "type": 1,
            "query": "range Steps from 1 to 1 step 1\r\n| project value = iff('{Aggregate}' contains 'P5th'  or '{Aggregate}' contains 'P10th', 'asc', 'desc')",
            "crossComponentResources": [
              "{Workspaces}"
            ],
            "isHiddenWhenLocked": true,
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces"
          },
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "aggregateRightValue",
            "type": 1,
            "isRequired": true,
            "query": "print \"{Aggregate:value}\"",
            "crossComponentResources": [
              "{Workspaces}"
            ],
            "isHiddenWhenLocked": true,
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces"
          },
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "aggregateRightLabel",
            "type": 1,
            "isRequired": true,
            "query": "print \"{Aggregate:label}\"",
            "crossComponentResources": [
              "{Workspaces}"
            ],
            "isHiddenWhenLocked": true,
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces"
          }
        ],
        "style": "above",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces"
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "top10"
      },
      "customWidth": "50",
      "name": "parameters - 15"
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "let cpuSummary=totable(InsightsMetrics\r\n    | where TimeGenerated {TimeRange} \r\n    | where (Namespace == 'Processor' and Name == 'UtilizationPercentage')\r\n    | summarize hint.shufflekey=Computer {aggregateLeftValue} by Computer, Name\r\n    | top 10 by {aggregateLeftLabel} {aggregateOrderLeft});\r\nlet computerList=(cpuSummary \r\n    | project Computer);\r\nlet EmptyNodeIdentityAndProps = datatable(Computer:string, NodeId:string, NodeProps:dynamic, Priority: long) [];\r\nlet OmsNodeIdentityAndProps = computerList\r\n    | extend NodeId = Computer\r\n    | extend Priority = 1\r\n    | extend NodeProps = pack('type', 'StandAloneNode', 'name', Computer);\r\nlet ServiceMapNodeIdentityAndProps = VMComputer | extend ResourceId=strcat('machines/', Machine) | extend Bitness=columnifexists('Bitness', '')\r\n    | where TimeGenerated {TimeRange}\r\n    | where Computer in (computerList)\r\n    | summarize arg_max(TimeGenerated, *) by Computer\r\n    | extend AzureCloudServiceNodeIdentity = iif(isnotempty(AzureCloudServiceName), strcat(AzureCloudServiceInstanceId, '|',                     AzureCloudServiceDeployment), ''),          AzureScaleSetNodeIdentity = iif(isnotempty(AzureVmScaleSetName),              strcat(AzureVmScaleSetInstanceId, '|',                     AzureVmScaleSetDeployment), ''),          ComputerProps =              pack('type', 'StandAloneNode',                   'name', Computer,                   'mappingResourceId', ResourceId,                   'subscriptionId', AzureSubscriptionId,                   'resourceGroup', AzureResourceGroup,                   'azureResourceId', columnifexists('_ResourceId', '')),          AzureCloudServiceNodeProps =              pack('type', 'AzureCloudServiceNode',                   'cloudServiceInstanceId', AzureCloudServiceInstanceId,                   'cloudServiceRoleName', columnifexists('AzureCloudServiceRoleName', ''),                   'cloudServiceDeploymentId', AzureCloudServiceDeployment,                   'cloudServiceName', AzureCloudServiceName,                   'mappingResourceId', ResourceId),          AzureScaleSetNodeProps =               pack('type', 'AzureScaleSetNode',                   'scaleSetInstanceId', columnifexists('Computer', ''),                   'vmScaleSetDeploymentId', AzureVmScaleSetDeployment,                   'vmScaleSetName', AzureVmScaleSetName,                   'serviceFabricClusterName', AzureServiceFabricClusterName,                   'vmScaleSetResourceId', AzureVmScaleSetResourceId,                   'resourceGroupName', columnifexists('AzureResourceGroup', ''),                   'subscriptionId', columnifexists('AzureSubscriptionId', ''),                   'mappingResourceId', ResourceId)| project   Computer,            NodeId = case(isnotempty(AzureCloudServiceNodeIdentity), AzureCloudServiceNodeIdentity,                       isnotempty(AzureScaleSetNodeIdentity), AzureScaleSetNodeIdentity, Computer),            NodeProps = case(isnotempty(AzureCloudServiceNodeIdentity), AzureCloudServiceNodeProps,                          isnotempty(AzureScaleSetNodeIdentity), AzureScaleSetNodeProps, ComputerProps),            Priority = 2;\r\nlet NodeIdentityAndProps = union kind=inner isfuzzy = true                                  EmptyNodeIdentityAndProps, OmsNodeIdentityAndProps, ServiceMapNodeIdentityAndProps                            \r\n    | summarize arg_max(Priority, *) by Computer; \r\nlet NodeIdentityAndPropsMin = NodeIdentityAndProps\r\n    | extend Kind = iff(NodeProps.type == \"StandAloneNode\", iff(NodeProps.azureResourceId == \"\", \"Non-Azure Virtual Machine\", \"Azure Virtual Machine\"), NodeProps.type), \r\n    ResourceId = iff(NodeProps.type == \"AzureScaleSetNode\", NodeProps.vmScaleSetResourceId, \r\n        iff(NodeProps.type == \"AzureCloudServiceNode\", NodeProps.cloudServiceDeploymentId, Computer)),\r\n    ResourceName = iff(NodeProps.type == \"AzureScaleSetNode\", NodeProps.scaleSetInstanceId, \r\n        iff(NodeProps.type == \"AzureCloudServiceNode\", NodeProps.cloudServiceInstanceId, Computer))\r\n    | project Computer, Kind, ResourceId, ResourceName;\r\nInsightsMetrics\r\n    | where TimeGenerated {TimeRange}\r\n    | where (Namespace == 'Processor' and Name == 'UtilizationPercentage')\r\n    | where Computer in (computerList)\r\n    | join kind=leftouter (NodeIdentityAndPropsMin) on Computer\r\n    | summarize {aggregateLeftValue} by bin(TimeGenerated, ({TimeRange:end} - {TimeRange:start})/100), ResourceName",
        "size": 0,
        "aggregation": 3,
        "showAnnotations": true,
        "noDataMessage": "There is no data for this counter, either enable the counter or onboard machines to this workspace",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces",
        "crossComponentResources": [
          "{Workspaces}"
        ],
        "visualization": "linechart",
        "tileSettings": {
          "showBorder": false,
          "titleContent": {
            "columnMatch": "Computer",
            "formatter": 1
          },
          "leftContent": {
            "columnMatch": "value",
            "formatter": 12,
            "formatOptions": {
              "palette": "auto"
            },
            "numberFormat": {
              "unit": 17,
              "options": {
                "maximumSignificantDigits": 3,
                "maximumFractionDigits": 2
              }
            }
          }
        },
        "chartSettings": {
          "ySettings": {
            "unit": 1,
            "min": 0,
            "max": 100
          }
        }
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "top10"
      },
      "customWidth": "50",
      "name": "query - 16"
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "let memorySummary=totable(InsightsMetrics\r\n    | where TimeGenerated {TimeRange} \r\n    | where Namespace == 'Memory' and Name == 'AvailableMB'\r\n    | summarize hint.shufflekey=Computer {aggregateRightValue} by Computer, Name\r\n    | top 10 by {aggregateRightLabel} {aggregateOrderRight});\r\nlet computerList=(memorySummary \r\n    | project Computer);\r\nlet EmptyNodeIdentityAndProps = datatable(Computer:string, NodeId:string, NodeProps:dynamic, Priority: long) [];\r\nlet OmsNodeIdentityAndProps = computerList\r\n    | extend NodeId = Computer\r\n    | extend Priority = 1\r\n    | extend NodeProps = pack('type', 'StandAloneNode', 'name', Computer);\r\nlet ServiceMapNodeIdentityAndProps = VMComputer | extend ResourceId=strcat('machines/', Machine) | extend Bitness=columnifexists('Bitness', '')\r\n    | where TimeGenerated {TimeRange}\r\n    | where Computer in (computerList)\r\n    | summarize arg_max(TimeGenerated, *) by Computer\r\n    | extend AzureCloudServiceNodeIdentity = iif(isnotempty(AzureCloudServiceName), strcat(AzureCloudServiceInstanceId, '|',                     AzureCloudServiceDeployment), ''),          AzureScaleSetNodeIdentity = iif(isnotempty(AzureVmScaleSetName),              strcat(AzureVmScaleSetInstanceId, '|',                     AzureVmScaleSetDeployment), ''),          ComputerProps =              pack('type', 'StandAloneNode',                   'name', Computer,                   'mappingResourceId', ResourceId,                   'subscriptionId', AzureSubscriptionId,                   'resourceGroup', AzureResourceGroup,                   'azureResourceId', columnifexists('_ResourceId', '')),          AzureCloudServiceNodeProps =              pack('type', 'AzureCloudServiceNode',                   'cloudServiceInstanceId', AzureCloudServiceInstanceId,                   'cloudServiceRoleName', columnifexists('AzureCloudServiceRoleName', ''),                   'cloudServiceDeploymentId', AzureCloudServiceDeployment,                   'cloudServiceName', AzureCloudServiceName,                   'mappingResourceId', ResourceId),          AzureScaleSetNodeProps =               pack('type', 'AzureScaleSetNode',                   'scaleSetInstanceId', columnifexists('Computer', ''),                   'vmScaleSetDeploymentId', AzureVmScaleSetDeployment,                   'vmScaleSetName', AzureVmScaleSetName,                   'serviceFabricClusterName', AzureServiceFabricClusterName,                   'vmScaleSetResourceId', AzureVmScaleSetResourceId,                   'resourceGroupName', columnifexists('AzureResourceGroup', ''),                   'subscriptionId', columnifexists('AzureSubscriptionId', ''),                   'mappingResourceId', ResourceId)| project   Computer,            NodeId = case(isnotempty(AzureCloudServiceNodeIdentity), AzureCloudServiceNodeIdentity,                       isnotempty(AzureScaleSetNodeIdentity), AzureScaleSetNodeIdentity, Computer),            NodeProps = case(isnotempty(AzureCloudServiceNodeIdentity), AzureCloudServiceNodeProps,                          isnotempty(AzureScaleSetNodeIdentity), AzureScaleSetNodeProps, ComputerProps),            Priority = 2;\r\nlet NodeIdentityAndProps = union kind=inner isfuzzy = true                                  EmptyNodeIdentityAndProps, OmsNodeIdentityAndProps, ServiceMapNodeIdentityAndProps                            \r\n    | summarize arg_max(Priority, *) by Computer; \r\nlet NodeIdentityAndPropsMin = NodeIdentityAndProps\r\n    | extend Kind = iff(NodeProps.type == \"StandAloneNode\", iff(NodeProps.azureResourceId == \"\", \"Non-Azure Virtual Machine\", \"Azure Virtual Machine\"), NodeProps.type), \r\n    ResourceId = iff(NodeProps.type == \"AzureScaleSetNode\", NodeProps.vmScaleSetResourceId, \r\n        iff(NodeProps.type == \"AzureCloudServiceNode\", NodeProps.cloudServiceDeploymentId, Computer)),\r\n    ResourceName = iff(NodeProps.type == \"AzureScaleSetNode\", NodeProps.scaleSetInstanceId, \r\n        iff(NodeProps.type == \"AzureCloudServiceNode\", NodeProps.cloudServiceInstanceId, Computer))\r\n    | project Computer, Kind, ResourceId, ResourceName;\r\nInsightsMetrics\r\n    | where TimeGenerated {TimeRange}\r\n    | where Namespace == 'Memory' and Name == 'AvailableMB'\r\n    | where Computer in (computerList)\r\n    | join kind=leftouter (NodeIdentityAndPropsMin) on Computer\r\n    | summarize {aggregateRightValue} by bin(TimeGenerated, ({TimeRange:end} - {TimeRange:start})/100), ResourceName",
        "size": 0,
        "aggregation": 3,
        "showAnnotations": true,
        "noDataMessage": "There is no data for this counter, either enable the counter or onboard machines to this workspace",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces",
        "crossComponentResources": [
          "{Workspaces}"
        ],
        "visualization": "linechart",
        "tileSettings": {
          "showBorder": false,
          "titleContent": {
            "columnMatch": "Computer",
            "formatter": 1
          },
          "leftContent": {
            "columnMatch": "value",
            "formatter": 12,
            "formatOptions": {
              "palette": "auto"
            },
            "numberFormat": {
              "unit": 17,
              "options": {
                "maximumSignificantDigits": 3,
                "maximumFractionDigits": 2
              }
            }
          }
        },
        "chartSettings": {
          "ySettings": {
            "unit": 4,
            "min": 0,
            "max": null
          }
        }
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "top10"
      },
      "customWidth": "50",
      "name": "query - 17"
    },
    {
      "type": 1,
      "content": {
        "json": "### Bytes Sent Rate"
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "top10"
      },
      "customWidth": "50",
      "name": "text - 18"
    },
    {
      "type": 1,
      "content": {
        "json": "### Bytes Received Rate"
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "top10"
      },
      "customWidth": "50",
      "name": "text - 19"
    },
    {
      "type": 9,
      "content": {
        "version": "KqlParameterItem/1.0",
        "parameters": [
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "Aggregate",
            "type": 2,
            "isRequired": true,
            "value": "Average = round(avg(Val), 2)",
            "typeSettings": {
              "additionalResourceOptions": []
            },
            "jsonData": "[\r\n    { \"value\":\"Average = round(avg(Val), 2)\", \"label\":\"Average\"},\r\n    { \"value\":\"P5th = round(percentile(Val, 5), 2)\", \"label\":\"P5th\"},\r\n    { \"value\":\"P10th = round(percentile(Val, 10), 2)\", \"label\":\"P10th\"},\r\n    { \"value\":\"P50th = round(percentile(Val, 50), 2)\", \"label\":\"P50th\"},\r\n    { \"value\":\"P80th = round(percentile(Val, 80), 2)\", \"label\":\"P80th\"},\r\n    { \"value\":\"P90th = round(percentile(Val, 90), 2)\", \"label\":\"P90th\"},\r\n    { \"value\":\"P95th = round(percentile(Val, 95), 2)\", \"label\":\"P95th\"}\r\n]"
          },
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "aggregateOrderLeft",
            "type": 1,
            "query": "range Steps from 1 to 1 step 1\r\n| project value = iff('{Aggregate}' contains 'P5th'  or '{Aggregate}' contains 'P10th', 'asc', 'desc')",
            "crossComponentResources": [
              "{Workspaces}"
            ],
            "isHiddenWhenLocked": true,
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces"
          },
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "aggregateLeftValue",
            "type": 1,
            "isRequired": true,
            "query": "print \"{Aggregate:value}\"",
            "crossComponentResources": [
              "{Workspaces}"
            ],
            "isHiddenWhenLocked": true,
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces"
          },
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "aggregateLeftLabel",
            "type": 1,
            "isRequired": true,
            "query": "print \"{Aggregate:label}\"",
            "crossComponentResources": [
              "{Workspaces}"
            ],
            "isHiddenWhenLocked": true,
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces"
          }
        ],
        "style": "above",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces"
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "top10"
      },
      "customWidth": "50",
      "name": "parameters - 20"
    },
    {
      "type": 9,
      "content": {
        "version": "KqlParameterItem/1.0",
        "parameters": [
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "Aggregate",
            "type": 2,
            "isRequired": true,
            "value": "Average = round(avg(Val), 2)",
            "typeSettings": {
              "additionalResourceOptions": []
            },
            "jsonData": "[\r\n    { \"value\":\"Average = round(avg(Val), 2)\", \"label\":\"Average\"},\r\n    { \"value\":\"P5th = round(percentile(Val, 5), 2)\", \"label\":\"P5th\"},\r\n    { \"value\":\"P10th = round(percentile(Val, 10), 2)\", \"label\":\"P10th\"},\r\n    { \"value\":\"P50th = round(percentile(Val, 50), 2)\", \"label\":\"P50th\"},\r\n    { \"value\":\"P80th = round(percentile(Val, 80), 2)\", \"label\":\"P80th\"},\r\n    { \"value\":\"P90th = round(percentile(Val, 90), 2)\", \"label\":\"P90th\"},\r\n    { \"value\":\"P95th = round(percentile(Val, 95), 2)\", \"label\":\"P95th\"}\r\n]"
          },
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "aggregateOrderRight",
            "type": 1,
            "query": "range Steps from 1 to 1 step 1\r\n| project value = iff('{Aggregate}' contains 'P5th'  or '{Aggregate}' contains 'P10th', 'asc', 'desc')",
            "crossComponentResources": [
              "{Workspaces}"
            ],
            "isHiddenWhenLocked": true,
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces"
          },
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "aggregateRightValue",
            "type": 1,
            "isRequired": true,
            "query": "print \"{Aggregate:value}\"",
            "crossComponentResources": [
              "{Workspaces}"
            ],
            "isHiddenWhenLocked": true,
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces"
          },
          {
            "id": "yourid",
            "version": "KqlParameterItem/1.0",
            "name": "aggregateRightLabel",
            "type": 1,
            "isRequired": true,
            "query": "print \"{Aggregate:label}\"",
            "crossComponentResources": [
              "{Workspaces}"
            ],
            "isHiddenWhenLocked": true,
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces"
          }
        ],
        "style": "above",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces"
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "top10"
      },
      "customWidth": "50",
      "name": "parameters - 21"
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "let memorySummary=totable(InsightsMetrics\r\n    | where TimeGenerated {TimeRange} \r\n    | where Namespace == 'Network' and Name == 'WriteBytesPerSecond'\r\n    | summarize hint.shufflekey=Computer {aggregateLeftValue} by Computer, Name\r\n    | top 10 by {aggregateLeftLabel} {aggregateOrderLeft});\r\nlet computerList=(memorySummary \r\n    | project Computer);\r\nlet EmptyNodeIdentityAndProps = datatable(Computer:string, NodeId:string, NodeProps:dynamic, Priority: long) [];\r\nlet OmsNodeIdentityAndProps = computerList\r\n    | extend NodeId = Computer\r\n    | extend Priority = 1\r\n    | extend NodeProps = pack('type', 'StandAloneNode', 'name', Computer);\r\nlet ServiceMapNodeIdentityAndProps = VMComputer | extend ResourceId=strcat('machines/', Machine) | extend Bitness=columnifexists('Bitness', '')\r\n    | where TimeGenerated {TimeRange}\r\n    | where Computer in (computerList)\r\n    | summarize arg_max(TimeGenerated, *) by Computer\r\n    | extend AzureCloudServiceNodeIdentity = iif(isnotempty(AzureCloudServiceName), strcat(AzureCloudServiceInstanceId, '|',                     AzureCloudServiceDeployment), ''),          AzureScaleSetNodeIdentity = iif(isnotempty(AzureVmScaleSetName),              strcat(AzureVmScaleSetInstanceId, '|',                     AzureVmScaleSetDeployment), ''),          ComputerProps =              pack('type', 'StandAloneNode',                   'name', Computer,                   'mappingResourceId', ResourceId,                   'subscriptionId', AzureSubscriptionId,                   'resourceGroup', AzureResourceGroup,                   'azureResourceId', columnifexists('_ResourceId', '')),          AzureCloudServiceNodeProps =              pack('type', 'AzureCloudServiceNode',                   'cloudServiceInstanceId', AzureCloudServiceInstanceId,                   'cloudServiceRoleName', columnifexists('AzureCloudServiceRoleName', ''),                   'cloudServiceDeploymentId', AzureCloudServiceDeployment,                   'cloudServiceName', AzureCloudServiceName,                   'mappingResourceId', ResourceId),          AzureScaleSetNodeProps =               pack('type', 'AzureScaleSetNode',                   'scaleSetInstanceId', columnifexists('Computer', ''),                   'vmScaleSetDeploymentId', AzureVmScaleSetDeployment,                   'vmScaleSetName', AzureVmScaleSetName,                   'serviceFabricClusterName', AzureServiceFabricClusterName,                   'vmScaleSetResourceId', AzureVmScaleSetResourceId,                   'resourceGroupName', columnifexists('AzureResourceGroup', ''),                   'subscriptionId', columnifexists('AzureSubscriptionId', ''),                   'mappingResourceId', ResourceId)| project   Computer,            NodeId = case(isnotempty(AzureCloudServiceNodeIdentity), AzureCloudServiceNodeIdentity,                       isnotempty(AzureScaleSetNodeIdentity), AzureScaleSetNodeIdentity, Computer),            NodeProps = case(isnotempty(AzureCloudServiceNodeIdentity), AzureCloudServiceNodeProps,                          isnotempty(AzureScaleSetNodeIdentity), AzureScaleSetNodeProps, ComputerProps),            Priority = 2;\r\nlet NodeIdentityAndProps = union kind=inner isfuzzy = true                                  EmptyNodeIdentityAndProps, OmsNodeIdentityAndProps, ServiceMapNodeIdentityAndProps                            \r\n    | summarize arg_max(Priority, *) by Computer; \r\nlet NodeIdentityAndPropsMin = NodeIdentityAndProps\r\n    | extend Kind = iff(NodeProps.type == \"StandAloneNode\", iff(NodeProps.azureResourceId == \"\", \"Non-Azure Virtual Machine\", \"Azure Virtual Machine\"), NodeProps.type), \r\n    ResourceId = iff(NodeProps.type == \"AzureScaleSetNode\", NodeProps.vmScaleSetResourceId, \r\n        iff(NodeProps.type == \"AzureCloudServiceNode\", NodeProps.cloudServiceDeploymentId, Computer)),\r\n    ResourceName = iff(NodeProps.type == \"AzureScaleSetNode\", NodeProps.scaleSetInstanceId, \r\n        iff(NodeProps.type == \"AzureCloudServiceNode\", NodeProps.cloudServiceInstanceId, Computer))\r\n    | project Computer, Kind, ResourceId, ResourceName;\r\nInsightsMetrics\r\n    | where TimeGenerated {TimeRange}\r\n    | where Namespace == 'Network' and Name == 'WriteBytesPerSecond'\r\n    | where Computer in (computerList)\r\n    | join kind=leftouter (NodeIdentityAndPropsMin) on Computer\r\n    | summarize {aggregateLeftValue} by bin(TimeGenerated, ({TimeRange:end} - {TimeRange:start})/100), ResourceName",
        "size": 0,
        "showAnnotations": true,
        "noDataMessage": "There is no data for this counter, either enable the counter or onboard machines to this workspace",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces",
        "crossComponentResources": [
          "{Workspaces}"
        ],
        "visualization": "linechart",
        "tileSettings": {
          "showBorder": false,
          "titleContent": {
            "columnMatch": "Computer",
            "formatter": 1
          },
          "leftContent": {
            "columnMatch": "value",
            "formatter": 12,
            "formatOptions": {
              "palette": "auto"
            },
            "numberFormat": {
              "unit": 17,
              "options": {
                "maximumSignificantDigits": 3,
                "maximumFractionDigits": 2
              }
            }
          }
        },
        "chartSettings": {
          "ySettings": {
            "unit": 2,
            "min": 0,
            "max": null
          }
        }
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "top10"
      },
      "customWidth": "50",
      "name": "query - 22"
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "let memorySummary=totable(InsightsMetrics\r\n    | where TimeGenerated {TimeRange} \r\n    | where Namespace == 'Network' and Name == 'ReadBytesPerSecond'\r\n    | summarize hint.shufflekey=Computer {aggregateRightValue} by Computer, Name\r\n    | top 10 by {aggregateRightLabel} {aggregateOrderRight});\r\nlet computerList=(memorySummary \r\n    | project Computer);\r\nlet EmptyNodeIdentityAndProps = datatable(Computer:string, NodeId:string, NodeProps:dynamic, Priority: long) [];\r\nlet OmsNodeIdentityAndProps = computerList\r\n    | extend NodeId = Computer\r\n    | extend Priority = 1\r\n    | extend NodeProps = pack('type', 'StandAloneNode', 'name', Computer);\r\nlet ServiceMapNodeIdentityAndProps = VMComputer | extend ResourceId=strcat('machines/', Machine) | extend Bitness=columnifexists('Bitness', '')\r\n    | where TimeGenerated {TimeRange}\r\n    | where Computer in (computerList)\r\n    | summarize arg_max(TimeGenerated, *) by Computer\r\n    | extend AzureCloudServiceNodeIdentity = iif(isnotempty(AzureCloudServiceName), strcat(AzureCloudServiceInstanceId, '|',                     AzureCloudServiceDeployment), ''),          AzureScaleSetNodeIdentity = iif(isnotempty(AzureVmScaleSetName),              strcat(AzureVmScaleSetInstanceId, '|',                     AzureVmScaleSetDeployment), ''),          ComputerProps =              pack('type', 'StandAloneNode',                   'name', Computer,                   'mappingResourceId', ResourceId,                   'subscriptionId', AzureSubscriptionId,                   'resourceGroup', AzureResourceGroup,                   'azureResourceId', columnifexists('_ResourceId', '')),          AzureCloudServiceNodeProps =              pack('type', 'AzureCloudServiceNode',                   'cloudServiceInstanceId', AzureCloudServiceInstanceId,                   'cloudServiceRoleName', columnifexists('AzureCloudServiceRoleName', ''),                   'cloudServiceDeploymentId', AzureCloudServiceDeployment,                   'cloudServiceName', AzureCloudServiceName,                   'mappingResourceId', ResourceId),          AzureScaleSetNodeProps =               pack('type', 'AzureScaleSetNode',                   'scaleSetInstanceId', columnifexists('Computer', ''),                   'vmScaleSetDeploymentId', AzureVmScaleSetDeployment,                   'vmScaleSetName', AzureVmScaleSetName,                   'serviceFabricClusterName', AzureServiceFabricClusterName,                   'vmScaleSetResourceId', AzureVmScaleSetResourceId,                   'resourceGroupName', columnifexists('AzureResourceGroup', ''),                   'subscriptionId', columnifexists('AzureSubscriptionId', ''),                   'mappingResourceId', ResourceId)| project   Computer,            NodeId = case(isnotempty(AzureCloudServiceNodeIdentity), AzureCloudServiceNodeIdentity,                       isnotempty(AzureScaleSetNodeIdentity), AzureScaleSetNodeIdentity, Computer),            NodeProps = case(isnotempty(AzureCloudServiceNodeIdentity), AzureCloudServiceNodeProps,                          isnotempty(AzureScaleSetNodeIdentity), AzureScaleSetNodeProps, ComputerProps),            Priority = 2;\r\nlet NodeIdentityAndProps = union kind=inner isfuzzy = true                                  EmptyNodeIdentityAndProps, OmsNodeIdentityAndProps, ServiceMapNodeIdentityAndProps                            \r\n    | summarize arg_max(Priority, *) by Computer; \r\nlet NodeIdentityAndPropsMin = NodeIdentityAndProps\r\n    | extend Kind = iff(NodeProps.type == \"StandAloneNode\", iff(NodeProps.azureResourceId == \"\", \"Non-Azure Virtual Machine\", \"Azure Virtual Machine\"), NodeProps.type), \r\n    ResourceId = iff(NodeProps.type == \"AzureScaleSetNode\", NodeProps.vmScaleSetResourceId, \r\n        iff(NodeProps.type == \"AzureCloudServiceNode\", NodeProps.cloudServiceDeploymentId, Computer)),\r\n    ResourceName = iff(NodeProps.type == \"AzureScaleSetNode\", NodeProps.scaleSetInstanceId, \r\n        iff(NodeProps.type == \"AzureCloudServiceNode\", NodeProps.cloudServiceInstanceId, Computer))\r\n    | project Computer, Kind, ResourceId, ResourceName;\r\nInsightsMetrics\r\n    | where TimeGenerated {TimeRange}\r\n    | where Namespace == 'Network' and Name == 'ReadBytesPerSecond'\r\n    | where Computer in (computerList)\r\n    | join kind=leftouter (NodeIdentityAndPropsMin) on Computer\r\n    | summarize {aggregateRightValue} by bin(TimeGenerated, ({TimeRange:end} - {TimeRange:start})/100), ResourceName",
        "size": 0,
        "showAnnotations": true,
        "noDataMessage": "There is no data for this counter, either enable the counter or onboard machines to this workspace",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces",
        "crossComponentResources": [
          "{Workspaces}"
        ],
        "visualization": "linechart",
        "tileSettings": {
          "showBorder": false,
          "titleContent": {
            "columnMatch": "Computer",
            "formatter": 1
          },
          "leftContent": {
            "columnMatch": "value",
            "formatter": 12,
            "formatOptions": {
              "palette": "auto"
            },
            "numberFormat": {
              "unit": 17,
              "options": {
                "maximumSignificantDigits": 3,
                "maximumFractionDigits": 2
              }
            }
          }
        },
        "chartSettings": {
          "ySettings": {
            "unit": 2,
            "min": 0,
            "max": null
          }
        }
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "top10"
      },
      "customWidth": "50",
      "name": "query - 23"
    },
    {
      "type": 1,
      "content": {
        "json": "### Logical Disk Space Used %"
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "top10"
      },
      "customWidth": "50",
      "name": "text - 24"
    },
    {
      "type": 1,
      "content": {
        "json": ""
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "top10"
      },
      "customWidth": "50",
      "name": "text - 25"
    },
    {
      "type": 9,
      "content": {
        "version": "KqlParameterItem/1.0",
        "parameters": [
          {
            "id": "id",
            "version": "KqlParameterItem/1.0",
            "name": "Aggregate",
            "type": 2,
            "isRequired": true,
            "value": "Average = round(avg(Val), 2)",
            "typeSettings": {
              "additionalResourceOptions": []
            },
            "jsonData": "[\r\n    { \"value\":\"Average = round(avg(Val), 2)\", \"label\":\"Average\"},\r\n    { \"value\":\"P5th = round(percentile(Val, 5), 2)\", \"label\":\"P5th\"},\r\n    { \"value\":\"P10th = round(percentile(Val, 10), 2)\", \"label\":\"P10th\"},\r\n    { \"value\":\"P50th = round(percentile(Val, 50), 2)\", \"label\":\"P50th\"},\r\n    { \"value\":\"P80th = round(percentile(Val, 80), 2)\", \"label\":\"P80th\"},\r\n    { \"value\":\"P90th = round(percentile(Val, 90), 2)\", \"label\":\"P90th\"},\r\n    { \"value\":\"P95th = round(percentile(Val, 95), 2)\", \"label\":\"P95th\"}\r\n]"
          },
          {
            "id": "id",
            "version": "KqlParameterItem/1.0",
            "name": "aggregateOrder",
            "type": 1,
            "query": "range Steps from 1 to 1 step 1\r\n| project value = iff('{Aggregate}' contains 'P5th'  or '{Aggregate}' contains 'P10th', 'asc', 'desc')",
            "crossComponentResources": [
              "{Workspaces}"
            ],
            "isHiddenWhenLocked": true,
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces"
          }
        ],
        "style": "above",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces"
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "top10"
      },
      "customWidth": "50",
      "name": "parameters - 26"
    },
    {
      "type": 1,
      "content": {
        "json": ""
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "top10"
      },
      "customWidth": "50",
      "name": "text - 27"
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "let memorySummary=totable(InsightsMetrics\r\n    | where TimeGenerated {TimeRange} \r\n    | where Namespace == 'LogicalDisk' and Name == 'FreeSpacePercentage'\r\n\t| extend Val = 100 - Val\r\n    | summarize hint.shufflekey=Computer {aggregateLeftValue} by Computer, Name\r\n    | top 10 by {aggregateLeftLabel} {aggregateOrderLeft});\r\nlet computerList=(memorySummary \r\n    | project Computer);\r\nlet EmptyNodeIdentityAndProps = datatable(Computer:string, NodeId:string, NodeProps:dynamic, Priority: long) [];\r\nlet OmsNodeIdentityAndProps = computerList\r\n    | extend NodeId = Computer\r\n    | extend Priority = 1\r\n    | extend NodeProps = pack('type', 'StandAloneNode', 'name', Computer);\r\nlet ServiceMapNodeIdentityAndProps = VMComputer | extend ResourceId=strcat('machines/', Machine) | extend Bitness=columnifexists('Bitness', '')\r\n    | where TimeGenerated {TimeRange}\r\n    | where Computer in (computerList)\r\n    | summarize arg_max(TimeGenerated, *) by Computer\r\n    | extend AzureCloudServiceNodeIdentity = iif(isnotempty(AzureCloudServiceName), strcat(AzureCloudServiceInstanceId, '|',                     AzureCloudServiceDeployment), ''),          AzureScaleSetNodeIdentity = iif(isnotempty(AzureVmScaleSetName),              strcat(AzureVmScaleSetInstanceId, '|',                     AzureVmScaleSetDeployment), ''),          ComputerProps =              pack('type', 'StandAloneNode',                   'name', Computer,                   'mappingResourceId', ResourceId,                   'subscriptionId', AzureSubscriptionId,                   'resourceGroup', AzureResourceGroup,                   'azureResourceId', columnifexists('_ResourceId', '')),          AzureCloudServiceNodeProps =              pack('type', 'AzureCloudServiceNode',                   'cloudServiceInstanceId', AzureCloudServiceInstanceId,                   'cloudServiceRoleName', columnifexists('AzureCloudServiceRoleName', ''),                   'cloudServiceDeploymentId', AzureCloudServiceDeployment,                   'cloudServiceName', AzureCloudServiceName,                   'mappingResourceId', ResourceId),          AzureScaleSetNodeProps =               pack('type', 'AzureScaleSetNode',                   'scaleSetInstanceId', columnifexists('Computer', ''),                   'vmScaleSetDeploymentId', AzureVmScaleSetDeployment,                   'vmScaleSetName', AzureVmScaleSetName,                   'serviceFabricClusterName', AzureServiceFabricClusterName,                   'vmScaleSetResourceId', AzureVmScaleSetResourceId,                   'resourceGroupName', columnifexists('AzureResourceGroup', ''),                   'subscriptionId', columnifexists('AzureSubscriptionId', ''),                   'mappingResourceId', ResourceId)| project   Computer,            NodeId = case(isnotempty(AzureCloudServiceNodeIdentity), AzureCloudServiceNodeIdentity,                       isnotempty(AzureScaleSetNodeIdentity), AzureScaleSetNodeIdentity, Computer),            NodeProps = case(isnotempty(AzureCloudServiceNodeIdentity), AzureCloudServiceNodeProps,                          isnotempty(AzureScaleSetNodeIdentity), AzureScaleSetNodeProps, ComputerProps),            Priority = 2;\r\nlet NodeIdentityAndProps = union kind=inner isfuzzy = true                                  EmptyNodeIdentityAndProps, OmsNodeIdentityAndProps, ServiceMapNodeIdentityAndProps                            \r\n    | summarize arg_max(Priority, *) by Computer; \r\nlet NodeIdentityAndPropsMin = NodeIdentityAndProps\r\n    | extend Kind = iff(NodeProps.type == \"StandAloneNode\", iff(NodeProps.azureResourceId == \"\", \"Non-Azure Virtual Machine\", \"Azure Virtual Machine\"), NodeProps.type), \r\n    ResourceId = iff(NodeProps.type == \"AzureScaleSetNode\", NodeProps.vmScaleSetResourceId, \r\n        iff(NodeProps.type == \"AzureCloudServiceNode\", NodeProps.cloudServiceDeploymentId, Computer)),\r\n    ResourceName = iff(NodeProps.type == \"AzureScaleSetNode\", NodeProps.scaleSetInstanceId, \r\n        iff(NodeProps.type == \"AzureCloudServiceNode\", NodeProps.cloudServiceInstanceId, Computer))\r\n    | project Computer, Kind, ResourceId, ResourceName;\r\nInsightsMetrics\r\n    | where TimeGenerated {TimeRange}\r\n    | where Namespace == 'LogicalDisk' and Name == 'FreeSpacePercentage'\r\n\t| extend Val = 100 - Val\r\n    | where Computer in (computerList)\r\n    | join kind=leftouter (NodeIdentityAndPropsMin) on Computer\r\n    | summarize {aggregateLeftValue} by bin(TimeGenerated, ({TimeRange:end} - {TimeRange:start})/100), ResourceName",
        "size": 0,
        "aggregation": 3,
        "showAnnotations": true,
        "noDataMessage": "There is no data for this counter, either enable the counter or onboard machines to this workspace",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces",
        "crossComponentResources": [
          "{Workspaces}"
        ],
        "visualization": "linechart",
        "tileSettings": {
          "showBorder": false,
          "titleContent": {
            "columnMatch": "Computer",
            "formatter": 1
          },
          "leftContent": {
            "columnMatch": "value",
            "formatter": 12,
            "formatOptions": {
              "palette": "auto"
            },
            "numberFormat": {
              "unit": 17,
              "options": {
                "maximumSignificantDigits": 3,
                "maximumFractionDigits": 2
              }
            }
          }
        },
        "chartSettings": {
          "ySettings": {
            "unit": 1,
            "min": 0,
            "max": 100
          }
        }
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "top10"
      },
      "customWidth": "50",
      "name": "query - 28"
    }
  ],
  "fallbackResourceIds": [
    "azure monitor"
  ],
  "fromTemplateId": "community-Workbooks/Virtual Machines - Performance Analysis/Performance Analysis for a Group of VMs",
  "$schema": "https://github.com/Microsoft/Application-Insights-Workbooks/blob/master/schema/workbook.json"

  })

  tags = {
    ENV = "Test"
  }
}
resource "azurerm_application_insights_workbook" "fromtf3" {
  name                = "rgname3"
  resource_group_name = "exprg"
  location            = "northeurope"
  display_name        = "RgDisplayedName3"
  data_json = jsonencode({
    "version": "Notebook/1.0",
  "items": [
    {
      "type": 1,
      "content": {
        "json": "## Sing in location\n---\n\nThis workbook contains the user logins and displays the information in a map"
      },
      "name": "text - 2"
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "SigninLogs\n| summarize count() by UserDisplayName, Location, AuthenticationMethodsUsed, IPAddress, Id\n| order by count_ desc",
        "size": 0,
        "timeContext": {
          "durationMs": 2592000000
        },
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces",
        "visualization": "map",
        "mapSettings": {
          "locInfo": "CountryRegion",
          "locInfoColumn": "Location",
          "sizeSettings": "Location",
          "sizeAggregation": "Count",
          "labelSettings": "Location",
          "legendMetric": "count_",
          "legendAggregation": "Sum",
          "itemColorSettings": {
            "nodeColorField": "count_",
            "colorAggregation": "Sum",
            "type": "heatmap",
            "heatmapPalette": "greenRed"
          }
        }
      },
      "name": "query - 2"
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "SigninLogs\r\n| summarize count() by UserDisplayName, Location, AuthenticationMethodsUsed, IPAddress, Id, AppDisplayName\r\n| order by count_ desc",
        "size": 0,
        "timeContext": {
          "durationMs": 2592000000
        },
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces"
      },
      "name": "query - 2"
    }
  ],
  "fallbackResourceIds": [
    "/subscriptions/yoursub/resourcegroups/rgbicep/providers/microsoft.operationalinsights/workspaces/experiment"
  ],
  "$schema": "https://github.com/Microsoft/Application-Insights-Workbooks/blob/master/schema/workbook.json"
  })

  tags = {
    ENV = "Test"
  }
}
resource "azurerm_application_insights_workbook" "fromtf4" {
  name                = "rgname4"
  resource_group_name = "exprg"
  location            = "northeurope"
  display_name        = "RgDisplayedName4"
  data_json = jsonencode({
    "version": "Notebook/1.0",
  "items": [
    {
      "type": 1,
      "content": {
        "json": "## Credential Change tracker.\n---\n\nThis workbook tracks the credential changes and displays them."
      },
      "name": "text - 2"
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "AuditLogs   \n| where OperationName == \"Change user password\"  \n| extend Actor= InitiatedBy.user.userPrincipalName  \n| project Actor, TimeGenerated  ",
        "size": 1,
        "timeContext": {
          "durationMs": 86400000
        },
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces"
      },
      "name": "query - 2"
    }
  ],
  "fallbackResourceIds": [
    "/subscriptions/yoursub/resourcegroups/rgbicep/providers/microsoft.operationalinsights/workspaces/experiment"
  ],
  "$schema": "https://github.com/Microsoft/Application-Insights-Workbooks/blob/master/schema/workbook.json"
  })

  tags = {
    ENV = "Test"
  }
}
