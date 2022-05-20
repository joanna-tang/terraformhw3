resource "aws_autoscaling_group" "asg" {
  name                 = "${var.prefix}-asg"
  launch_configuration = "${var.launch_config_name}"
  min_size             = 1
  max_size             = 2
  vpc_zone_identifier  = "${var.subnet_ids}"


  lifecycle {
    create_before_destroy = true
  }

}
