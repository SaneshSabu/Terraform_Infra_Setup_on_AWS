output "Bastion_Pubic_IP" {
    value = aws_instance.Bastion.public_ip
}

output "Bastion_Private_IP" {
    value = aws_instance.Bastion.private_ip
}

output "Frontend_Public_ip" {
    value = aws_instance.webserver.public_ip
}

output "Frontend_Private_ip" {
    value = aws_instance.webserver.private_ip
}


output "Backend-Private_ip" {
    value = aws_instance.dbserver.private_ip
}
