resource "azurerm_public_ip" "lb_public_ip" {
  name                = "${var.load_balancer_name}_lb_public_ip"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

resource "azurerm_lb" "loadbalancer" {
  name                = "${var.load_balancer_name}_lb"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = "${var.load_balancer_name}_lb_frontend"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name                = "${var.load_balancer_name}_backend_pool"
  loadbalancer_id     = azurerm_lb.loadbalancer.id
  # resource_group_name = var.resource_group_name
}

resource "azurerm_lb_probe" "http_probe" {
  name                = "${var.load_balancer_name}_http_probe"
  # resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.loadbalancer.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "lb_rule" {
  name                           = "${var.load_balancer_name}_lb_rule"
  # resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.loadbalancer.id
  frontend_ip_configuration_name = azurerm_lb.loadbalancer.frontend_ip_configuration[0].name
  # backend_address_pool_id        = azurerm_lb_backend_address_pool.backend_pool.id
  probe_id                       = azurerm_lb_probe.http_probe.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  idle_timeout_in_minutes        = 4
}
