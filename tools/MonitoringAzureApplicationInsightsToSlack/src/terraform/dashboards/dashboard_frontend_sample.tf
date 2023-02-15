# here a full example of the dashboard exported from Versilia FE

resource "azurerm_dashboard" "webapp_dashboard" {
  name                = "Nexus-WebApp-dashboard-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  tags = {
    source = "terraform",
    environment= var.environment
  }
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
                "colSpan": 18,
                "rowSpan": 1
                },
                "metadata": {
                "inputs": [],
                "type": "Extension/HubsExtension/PartType/MarkdownPart",
                "settings": {
                    "content": {
                    "settings": {
                        "content": "",
                        "title": "WebApp",
                        "subtitle": "Traffic healthcheck",
                        "markdownSource": 1,
                        "markdownUri": null
                    }
                    }
                }
                }
            },
            "1": {
                "position": {
                "x": 0,
                "y": 1,
                "colSpan": 6,
                "rowSpan": 4
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
                            "name": "browserTimings/totalDuration",
                            "aggregationType": 4,
                            "namespace": "microsoft.insights/components",
                            "metricVisualization": {
                                "displayName": "Browser page load time",
                                "resourceDisplayName": "nexus-webapp-${var.environment}"
                            }
                            }
                        ],
                        "title": "WebApp - Browser loadtime",
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
            },
            "2": {
                "position": {
                "x": 6,
                "y": 1,
                "colSpan": 6,
                "rowSpan": 4
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
                            "name": "requests/failed",
                            "aggregationType": 7,
                            "namespace": "microsoft.insights/components",
                            "metricVisualization": {
                                "displayName": "Failed requests",
                                "resourceDisplayName": "nexus-webapp-${var.environment}"
                            }
                            }
                        ],
                        "title": "WebApp - Failed HTTP requests",
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
            },
            "3": {
                "position": {
                "x": 12,
                "y": 1,
                "colSpan": 6,
                "rowSpan": 4
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
                            "name": "sessions/count",
                            "aggregationType": 5,
                            "namespace": "microsoft.insights/components/kusto",
                            "metricVisualization": {
                                "displayName": "Sessions",
                                "resourceDisplayName": "nexus-webapp-${var.environment}"
                            }
                            }
                        ],
                        "title": "WebApp - Current sessions",
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
            },
            "4": {
                "position": {
                "x": 0,
                "y": 5,
                "colSpan": 6,
                "rowSpan": 4
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
                            "name": "performanceCounters/requestsPerSecond",
                            "aggregationType": 4,
                            "namespace": "microsoft.insights/components",
                            "metricVisualization": {
                                "displayName": "HTTP request rate",
                                "resourceDisplayName": "nexus-webapp-${var.environment}"
                            }
                            }
                        ],
                        "title": "WebApp - HTTP requests per second",
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
            },
            "5": {
                "position": {
                "x": 6,
                "y": 5,
                "colSpan": 6,
                "rowSpan": 4
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
                            "name": "performanceCounters/requestsInQueue",
                            "aggregationType": 4,
                            "namespace": "microsoft.insights/components",
                            "metricVisualization": {
                                "displayName": "HTTP requests in application queue",
                                "resourceDisplayName": "nexus-webapp-${var.environment}"
                            }
                            }
                        ],
                        "title": "WebApp - Queued HTTP requests",
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
            },
            "6": {
                "position": {
                "x": 12,
                "y": 5,
                "colSpan": 6,
                "rowSpan": 4
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
                            "name": "users/authenticated",
                            "aggregationType": 5,
                            "namespace": "microsoft.insights/components/kusto",
                            "metricVisualization": {
                                "displayName": "Users, authenticated",
                                "resourceDisplayName": "nexus-webapp-${var.environment}"
                            }
                            }
                        ],
                        "title": "WebApp - Current users authenticated",
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
                    "StartboardPart-MonitorChartPart-77d12073-8897-45de-8093-a3b1b7113548",
                    "StartboardPart-MonitorChartPart-77d12073-8897-45de-8093-a3b1b711354a",
                    "StartboardPart-MonitorChartPart-77d12073-8897-45de-8093-a3b1b711354c",
                    "StartboardPart-MonitorChartPart-77d12073-8897-45de-8093-a3b1b711354e",
                    "StartboardPart-MonitorChartPart-77d12073-8897-45de-8093-a3b1b7113550",
                    "StartboardPart-MonitorChartPart-77d12073-8897-45de-8093-a3b1b7113552"
                ]
                }
            }
            }
        }
        }
}


  DASH
}
