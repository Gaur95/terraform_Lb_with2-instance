resource "aws_lb" "my_lb" {
  name               = "my-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-04e781f606c492eb6"]

  subnets = [
    "subnet-0327e65b68de0edf0","subnet-0b94ee00d1b6e99b2","subnet-065c2af6c1ea5f9c1"
  ]
}

resource "aws_lb_target_group" "mytargetgroup" {
  name = "mytargetgroup"
  target_type = "instance"
  port = "80"
  protocol = "HTTP"
  vpc_id = "vpc-0230f45668682f34a"

}
resource "aws_lb_target_group_attachment" "akash" {
    target_group_arn = aws_lb_target_group.mytargetgroup.arn
    target_id        = aws_instance.myinst.id
    port             = 80
  
}
resource "aws_lb_target_group_attachment" "akash1" {
    target_group_arn = aws_lb_target_group.mytargetgroup.arn
    target_id        = aws_instance.myinst1.id
    port             = 80
}
resource "aws_lb_listener" "mylistner" {
    load_balancer_arn = aws_lb.my_lb.arn
    port              = "80"
    default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mytargetgroup.arn
  }
  
}

resource "aws_instance" "myinst" {
    ami = "ami-007020fd9c84e18c7"
    instance_type = "t2.micro"
    #key_name = "myterrakey" or
    key_name = aws_key_pair.myawskey.key_name
    tags =  {
        "Name" = "myterraform_ec2" 
    } 
    depends_on = [ aws_key_pair.myawskey ]
    security_groups = [ "launch-wizard-1" ] #security group name
    user_data = file("apache.sh")
}
resource "aws_instance" "myinst1" {
    ami = "ami-007020fd9c84e18c7"
    instance_type = "t2.micro"
    #key_name = "myterrakey" or
    key_name = aws_key_pair.myawskey.key_name
    tags =  {
        "Name" = "myterraform_ec21" 
    } 
    depends_on = [ aws_key_pair.myawskey ]
    security_groups = [ "launch-wizard-1" ] #security group name
    user_data = file("apache1.sh")
}
resource "aws_key_pair" "myawskey" {
  #public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDLbUtOW5r53ggxdqTniRCVpg81Mtg33UmiVrO39NAp0u/MM1nor3+Ya1dYNoi3tBaqPF4j/qe4IpMavNJjAcy5pd2KOsN1oEqmbxz10qNyNKglKZIgYUJBDcA3qUh5IKG1jSXEk3/C3yc2pmC4cdJu5FQcre56J0exja1+XBL1kXihP7UyiKzF9aiUpvVRDlQwDo1u8R2RJPN1tKWmRqDGX3N0671oStfGM8CVP7kqFQj4PUJQeY8Yj22cgq+IHWSeTkW1bnuUhMuilK1it8MmSthWFtreAIsX0weBlYSaeHjGOuARmfE3uOOp+jR925nUo7cXN5bhR8cxDYJuGJZqx+1DyfluZuy+M/6nItmLsPQZiTHXoDmL3Y8dyIusr2axYKEJpsKH16XCu9mfxe2rE7+FX8azvDhMUm36mbIu1aLBbNjhnnAPrTl1IZCz4ubHT3zrhmr1pW/5rAuKyyysHEVTdwIP4pEpiWaF81CapA7agmbgxCwnrMIyjxJphmM= akash@sky"
  public_key = file("/home/akash/.ssh/id_rsa.pub")
  key_name = "myterrakey"
}
output "link" {
    value = aws_lb.my_lb.dns_name
}