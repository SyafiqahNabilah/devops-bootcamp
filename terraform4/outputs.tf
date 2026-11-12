output "rackula_url" {
  description = "URL for the Rackula web UI"
  value       = "http://${module.my_server.public_ip}:8080"
}

output "server_ip_public" {
  description = "Public IP address of the EC2 instance"
  value       = module.my_server.public_ip
}

output "server_id" {
  description = "EC2 instance ID"
  value       = module.my_server.id
}

output "ssm_command" {
  description = "AWS Systems Manager Session Manager command"
  value       = "aws ssm start-session --target ${module.my_server.id}"
}
