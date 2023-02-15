resource "azurerm_monitor_metric_alert" "backend-cpu-usage" {
  #uncomment to restrict creation to prod
  #count = var.is_prod ? 1:0
  name                = "cpu-usage-backend-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [var.app_insights_be_id]
  description         = "Action will be triggered when CPUUsage max is greater than 70"

  criteria {
    metric_namespace = "microsoft.insights/components"
    metric_name      = "performanceCounters/processCpuPercentage"
    aggregation      = "Maximum"
    operator         = "GreaterThan"
    threshold        = 70
  }

  action {
    action_group_id =  var.action_group_id
  }
}
