# Output the instance's public IP
output "instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.test.public_ip
}

# Output the instance's ID
output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.test.id
}
