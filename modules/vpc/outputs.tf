output "vpc_id" {
   value = aws_vpc.main.id
}
output "privatesubnet1_id" {
   value = aws_subnet.privatesubnet[0].id
}
output "privatesubnet2_id" {
   value = aws_subnet.privatesubnet[1].id
}
output "privatesubnet3_id" {
   value = aws_subnet.privatesubnet[2].id
}
output "publicsubnet1_id" {
   value = aws_subnet.publicsubnet[0].id
}
output "publicsubnet2_id" {
   value = aws_subnet.publicsubnet[1].id
}
output "publicsubnet3_id" {
   value = aws_subnet.publicsubnet[2].id
}
output "prefix" {
   value = "${var.prefix}"
}
