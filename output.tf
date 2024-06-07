output "backend_pool_id" {
  description = "The ID of the backend address pool."
  value       = azurerm_lb_backend_address_pool.backend_pool.id
}
