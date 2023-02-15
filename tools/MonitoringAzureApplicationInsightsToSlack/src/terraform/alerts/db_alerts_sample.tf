resource "azurerm_monitor_metric_alert" "backend-db-cpu-usage" {
  #uncomment to restrict creation to prod
  #count = var.is_prod ? 1:0
  name                = "cpu-usage-db-backend-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [var.database_backend_id]
  description         = "Action will be triggered when CPUUsage max is greater than 70"

  criteria {
    metric_namespace = "microsoft.sql/servers/databases"
    metric_name      = "cpu_percent"
    aggregation      = "Maximum"
    operator         = "GreaterThan"
    threshold        = 70
  }

  action {
    action_group_id =  var.action_group_id
  }
}

resource "azurerm_monitor_metric_alert" "backend-db-dtu-usage" {
  #uncomment to restrict creation to prod
  #count = var.is_prod ? 1:0
  name                = "dtu-usage-db-backend-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [var.database_backend_id]
  description         = "Action will be triggered when CPUUsage max is greater than 70"

  criteria {
    metric_namespace = "microsoft.sql/servers/databases"
    metric_name      = "dtu_consumption_percent"
    aggregation      = "Maximum"
    operator         = "GreaterThan"
    threshold        = 70
  }

  action {
    action_group_id =  var.action_group_id
  }
}
