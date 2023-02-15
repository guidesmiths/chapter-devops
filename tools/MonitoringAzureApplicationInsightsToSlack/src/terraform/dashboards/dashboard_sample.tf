locals {
    # These variables are meant for the first part of the shared dashboard, a markdown displaying the name and description of the dashboard
    h1_title = "your_title"
    h1_insert_here = "your subtitle"
    # These are for the different subsections in the dashboard
    h2_title = "your h2 title"
    h2_insert_here = "your h2 description"
    # you can add as much as the different subsections to be displayed in your dashboard
    
    # The following variables will be for the metrics boards
    metric_name = "e.g. performanceCounters/processPrivateBytes" # you can find more of this in the Azure documentation

    # This variable will be used for the scope of our metrics. In this case we will use for app insights, but other resources (e.g. might have a different scope display name)
    # See readme.md section 2.1 for more info
    scope_display_name = "e.g. app_insights_displayname-${var.environment}"
}
resource "azurerm_dashboard" "be_db_dashboard" {
  name                = "Dashboard-resource-name-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  tags = {
    source = "terraform",
    environment= var.environment
  }
  # lenses are the total of parts that your dashboard will have. lenses is currently a List<Objects>
  dashboard_properties = <<DASH
{    
    "lenses": {
        "0": {
            "order": 0,
            "parts": {
                "0": {
                    "position": {
                        "x": 0,
                        "y": 0,
                        "colSpan": 10,
                        "rowSpan": 1
                    },
                    "metadata": {
                        "inputs": [],
                        "type": "Extension/HubsExtension/PartType/MarkdownPart",
                        "settings": {
                            "content": {
                                "settings": {
                                    "content": "",
                                    "title": "${local.h1_title} ",
                                    "subtitle": "${local.h1_insert_here}",
                                    "markdownSource": 1,
                                    "markdownUri": null
                                }
                            }
                        }
                    }
                },
                "1": {
                    "position": {
                        "x": 10,
                        "y": 0,
                        "colSpan": 10,
                        "rowSpan": 1
                    },
                    "metadata": {
                        "inputs": [],
                        "type": "Extension/HubsExtension/PartType/MarkdownPart",
                        "settings": {
                            "content": {
                                "settings": {
                                    "content": "",
                                    "title": "${local.h2_title}",
                                    "subtitle": "${local.h2_insert_here}",
                                    "markdownSource": 1,
                                    "markdownUri": null
                                }
                            }
                        }
                    }
                },
                "2": {
                    "position": {
                        "x": 0,
                        "y": 1,
                        "colSpan": 5,
                        "rowSpan": 3
                    },
                    "metadata": {
                        "inputs": [
                            {
                                "name": "options",
                                "isOptional": true
                            },
                            {
                                "name": "sharedTimeRange",
                                "isOptional": true
                            }
                        ],
                        "type": "Extension/HubsExtension/PartType/MonitorChartPart",
                        "settings": {
                            "content": {
                                "options": {
                                    "chart": {
                                        "metrics": [
                                            {
                                                "resourceMetadata": {
                                                    "id": "${var.app_insights_be_id}"
                                                },
                                                "name": "performanceCounters/processCpuPercentage ${local.metric_name}",
                                                "aggregationType": 4,
                                                "namespace": "microsoft.insights/components ${local.namespace_name}",
                                                "metricVisualization": {
                                                    "displayName": "Process CPU",
                                                    "resourceDisplayName": "${local.scope_display_name}"
                                                }
                                            }
                                        ],
                                        "title": "Insert your title here",
                                        "titleKind": 2,
                                        "visualization": {
                                            "chartType": 2,
                                            "legendVisualization": {
                                                "isVisible": true,
                                                "position": 2,
                                                "hideSubtitle": false
                                            },
                                            "axisVisualization": {
                                                "x": {
                                                    "isVisible": true,
                                                    "axisType": 2
                                                },
                                                "y": {
                                                    "isVisible": true,
                                                    "axisType": 1
                                                }
                                            },
                                            "disablePinning": true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            },
            "metadata": {
                "model": {
                    "timeRange": {
                        "value": {
                            "relative": {
                                "duration": 24,
                                "timeUnit": 1
                            }
                        },
                        "type": "MsPortalFx.Composition.Configuration.ValueTypes.TimeRange"
                    },
                    "filterLocale": {
                        "value": "en-us"
                    },
                    "filters": {
                        "value": {
                            "MsPortalFx_TimeRange": {
                                "model": {
                                    "format": "utc",
                                    "granularity": "auto",
                                    "relative": "24h"
                                },
                                "displayCache": {
                                    "name": "UTC Time",
                                    "value": "Past 24 hours"
                                },
                                "filteredPartIds": [
                                    "StartboardPart-MonitorChartPart-77d12073-8897-45de-8093-a3b1b71131a9",
                                    "StartboardPart-MonitorChartPart-77d12073-8897-45de-8093-a3b1b71131ab",
                                    "StartboardPart-MonitorChartPart-77d12073-8897-45de-8093-a3b1b71131ad",
                                    "StartboardPart-MonitorChartPart-77d12073-8897-45de-8093-a3b1b71131af",
                                    "StartboardPart-MonitorChartPart-77d12073-8897-45de-8093-a3b1b71131b1",
                                    "StartboardPart-MonitorChartPart-77d12073-8897-45de-8093-a3b1b71131b3",
                                    "StartboardPart-MonitorChartPart-77d12073-8897-45de-8093-a3b1b71131b5",
                                    "StartboardPart-MonitorChartPart-77d12073-8897-45de-8093-a3b1b71131b9",
                                    "StartboardPart-MonitorChartPart-77d12073-8897-45de-8093-a3b1b71131bb",
                                    "StartboardPart-MonitorChartPart-77d12073-8897-45de-8093-a3b1b71131bd",
                                    "StartboardPart-MonitorChartPart-77d12073-8897-45de-8093-a3b1b71131bf"
                                ]
                            }
                        }
                    }
                }
            }
        }

    }
}
DASH
}
