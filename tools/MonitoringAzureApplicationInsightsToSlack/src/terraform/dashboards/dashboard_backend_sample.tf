# here a full example of the dashboard exported from Versilia BE and DB

resource "azurerm_dashboard" "be_db_dashboard" {
  name                = "Nexus-BE-DB-dashboard-${var.environment}"
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
                                    "title": "Backend ",
                                    "subtitle": "Resources consumption",
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
                                    "title": "Database - Nexus",
                                    "subtitle": "Resources cnsumption",
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
                                                "name": "performanceCounters/processCpuPercentage",
                                                "aggregationType": 4,
                                                "namespace": "microsoft.insights/components",
                                                "metricVisualization": {
                                                    "displayName": "Process CPU",
                                                    "resourceDisplayName": "nexus-backend-${var.environment}"
                                                }
                                            }
                                        ],
                                        "title": "BE - CPU usage",
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
                        "x": 5,
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
                                                "name": "performanceCounters/processPrivateBytes",
                                                "aggregationType": 4,
                                                "namespace": "microsoft.insights/components",
                                                "metricVisualization": {
                                                    "displayName": "Process private bytes",
                                                    "color": "#0078d4",
                                                    "resourceDisplayName": "nexus-backend-${var.environment}"
                                                }
                                            }
                                        ],
                                        "title": "BE - Memory in use",
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
                        "x": 10,
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
                                                    "id": "${var.database_backend_id}"
                                                },
                                                "name": "cpu_percent",
                                                "aggregationType": 4,
                                                "namespace": "microsoft.sql/servers/databases",
                                                "metricVisualization": {
                                                    "displayName": "CPU percentage",
                                                    "resourceDisplayName": "versilia-nexus-${var.environment}/versilia-nexus-backend-${var.environment}"
                                                }
                                            }
                                        ],
                                        "title": "Nexus DB - CPU usage",
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
                                        },
                                        "grouping": {
                                            "dimension": "Microsoft.ResourceId"
                                        }
                                    }
                                }
                            }
                        }
                    }
                },
                "5": {
                    "position": {
                        "x": 15,
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
                                                    "id": "${var.database_backend_id}"
                                                },
                                                "name": "dtu_consumption_percent",
                                                "aggregationType": 3,
                                                "namespace": "microsoft.sql/servers/databases",
                                                "metricVisualization": {
                                                    "displayName": "DTU Percentage",
                                                    "resourceDisplayName": "versilia-nexus-${var.environment}/versilia-nexus-backend-${var.environment}"
                                                }
                                            }
                                        ],
                                        "title": "Nexus DB - DTU consumption",
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
                        "x": 0,
                        "y": 4,
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
                                                "name": "performanceCounters/processIOBytesPerSecond",
                                                "aggregationType": 4,
                                                "namespace": "microsoft.insights/components",
                                                "metricVisualization": {
                                                    "displayName": "Process IO rate",
                                                    "resourceDisplayName": "nexus-backend-${var.environment}"
                                                }
                                            }
                                        ],
                                        "title": "BE - IOPS rate",
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
                "7": {
                    "position": {
                        "x": 10,
                        "y": 4,
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
                                                    "id": "${var.database_backend_id}"
                                                },
                                                "name": "storage",
                                                "aggregationType": 4,
                                                "namespace": "microsoft.sql/servers/databases",
                                                "metricVisualization": {
                                                    "displayName": "Data space used",
                                                    "resourceDisplayName": "versilia-nexus-${var.environment}/versilia-nexus-backend-${var.environment}"
                                                }
                                            }
                                        ],
                                        "title": "Nexus DB - Disk usage",
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
                "8": {
                    "position": {
                        "x": 15,
                        "y": 4,
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
                                                    "id": "${var.database_backend_id}"
                                                },
                                                "name": "sessions_percent",
                                                "aggregationType": 4,
                                                "namespace": "microsoft.sql/servers/databases",
                                                "metricVisualization": {
                                                    "displayName": "Sessions percentage",
                                                    "resourceDisplayName": "versilia-nexus-${var.environment}/versilia-nexus-backend-${var.environment}"
                                                }
                                            }
                                        ],
                                        "title": "Nexus DB - Current sessions",
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
                "9": {
                    "position": {
                        "x": 10,
                        "y": 7,
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
                                    "title": "Database - Keycloak",
                                    "subtitle": "Resources consumption",
                                    "markdownSource": 1,
                                    "markdownUri": null
                                }
                            }
                        }
                    }
                },
                "10": {
                    "position": {
                        "x": 10,
                        "y": 8,
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
                                                    "id": "${var.database_keycloak_id}"
                                                },
                                                "name": "cpu_percent",
                                                "aggregationType": 4,
                                                "namespace": "microsoft.sql/servers/databases",
                                                "metricVisualization": {
                                                    "displayName": "CPU percentage",
                                                    "resourceDisplayName": "versilia-nexus-${var.environment}/versilia-nexus-keycloak-${var.environment}"
                                                }
                                            }
                                        ],
                                        "title": "Keycloak DB - CPU utilization",
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
                "11": {
                    "position": {
                        "x": 15,
                        "y": 8,
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
                                                    "id": "${var.database_keycloak_id}"
                                                },
                                                "name": "dtu_consumption_percent",
                                                "aggregationType": 3,
                                                "namespace": "microsoft.sql/servers/databases",
                                                "metricVisualization": {
                                                    "displayName": "DTU Percentage",
                                                    "resourceDisplayName": "versilia-nexus-${var.environment}/versilia-nexus-keycloak-${var.environment}"
                                                }
                                            }
                                        ],
                                        "title": "Keycloak DB - DTU consumption",
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
                "12": {
                    "position": {
                        "x": 10,
                        "y": 11,
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
                                                    "id": "${var.database_keycloak_id}"
                                                },
                                                "name": "storage",
                                                "aggregationType": 4,
                                                "namespace": "microsoft.sql/servers/databases",
                                                "metricVisualization": {
                                                    "displayName": "Data space used",
                                                    "resourceDisplayName": "versilia-nexus-${var.environment}/versilia-nexus-keycloak-${var.environment}"
                                                }
                                            }
                                        ],
                                        "title": "Keycloak DB - Disk usage",
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
                "13": {
                    "position": {
                        "x": 15,
                        "y": 11,
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
                                                    "id": "${var.database_keycloak_id}"
                                                },
                                                "name": "sessions_percent",
                                                "aggregationType": 4,
                                                "namespace": "microsoft.sql/servers/databases",
                                                "metricVisualization": {
                                                    "displayName": "Sessions percentage",
                                                    "resourceDisplayName": "versilia-nexus-${var.environment}/versilia-nexus-keycloak-${var.environment}"
                                                }
                                            }
                                        ],
                                        "title": "Keycloak DB - Current sessions",
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
                "14": {
                    "position": {
                        "x": 0,
                        "y": 8,
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
                                                "name": "requests/count",
                                                "aggregationType": 7,
                                                "namespace": "microsoft.insights/components",
                                                "metricVisualization": {
                                                    "displayName": "Server requests",
                                                    "resourceDisplayName": "nexus-backend-${var.environment}"
                                                }
                                            }
                                        ],
                                        "title": "Server requests",
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
                "15": {
                    "position": {
                        "x": 5,
                        "y": 8,
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
                                                "name": "requests/failed",
                                                "aggregationType": 7,
                                                "namespace": "microsoft.insights/components",
                                                "metricVisualization": {
                                                    "displayName": "Failed requests",
                                                    "resourceDisplayName": "nexus-backend-${var.environment}"
                                                }
                                            }
                                        ],
                                        "title": "Failed requests",
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
                "16": {
                    "position": {
                        "x": 0,
                        "y": 11,
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
                                                "name": "requests/duration",
                                                "aggregationType": 4,
                                                "namespace": "microsoft.insights/components",
                                                "metricVisualization": {
                                                    "displayName": "Server response time",
                                                    "resourceDisplayName": "nexus-backend-${var.environment}"
                                                }
                                            }
                                        ],
                                        "title": "Server Response",
                                        "titleKind": 1,
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
