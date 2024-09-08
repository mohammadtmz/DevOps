# Specifies the provider as AWS and sets the region to "us-east-1"
provider "aws" {
    region = "us-east-1"
}

# Defines a Virtual Private Cloud (VPC) resource with a CIDR block of 10.0.0.0/16
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

# Defines an Internet Gateway resource to allow traffic to and from the internet for the VPC
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id  # Associates the internet gateway with the VPC
}

# Defines a Route Table resource for managing traffic routing in the VPC
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id  # Associates the route table with the VPC

  # Adds a route to send all traffic (0.0.0.0/0) through the Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"  # Route for all traffic
    gateway_id = aws_internet_gateway.example.id  # The internet gateway ID for this route
  }
}

# Associates the Route Table with a specific subnet
resource "aws_route_table_association" "example" {
  subnet_id = aws_subnet.example.id  # The ID of the subnet to associate the route table with
  route_table_id = aws_route_table.example.id  # The ID of the route table to be associated
}

# Defines a Key Pair resource for SSH access to EC2 instances, using a public key
resource "aws_key_pair" "my_key" {
  key_name = "my_key"  # Name of the key pair
  public_key = file("/home/ec2-user/.ssh/id_rsa.pub")  # Path to the public key file
}

# Defines a Subnet resource within the VPC with a CIDR block and availability zone
resource "aws_subnet" "example" {
  vpc_id = aws_vpc.example.id  # The VPC ID to which the subnet belongs
  cidr_block = "10.0.1.0/24"  # CIDR block for the subnet
  availability_zone = "us-east-1f"  # The availability zone for the subnet
}

# Defines a Launch Configuration resource for creating EC2 instances with a specific AMI and instance type
resource "aws_launch_configuration" "app" {
  image_id = "ami-0182f373e66f89c85"  # The ID of the AMI to use for EC2 instances
  instance_type = "t2.micro"  # The instance type for EC2 instances
  key_name = aws_key_pair.my_key.key_name  # SSH key to use for instances

  # Ensures the launch configuration is replaced before being destroyed
  lifecycle {
    create_before_destroy = true  # Creates a new launch configuration before destroying the old one
  }
}

# Defines an Auto Scaling Group to manage EC2 instances with a specified capacity and load balancer
resource "aws_autoscaling_group" "app" {
  desired_capacity = 2  # The desired number of instances in the Auto Scaling group
  max_size = 3  # The maximum number of instances in the Auto Scaling group
  min_size = 1  # The minimum number of instances in the Auto Scaling group
  launch_configuration = aws_launch_configuration.app.id  # The launch configuration used by the Auto Scaling group
  vpc_zone_identifier = [ aws_subnet.example.id ]  # Specifies the VPC subnets for the Auto Scaling group

  load_balancers = [ aws_elb.app.id ]  # Attaches the Auto Scaling group to the specified load balancer

  # Tags instances in the Auto Scaling group with a name at launch
  tag {
    key = "Name"  # Key of the tag
    value = "AutoScalingGroupInstance"  # Value of the tag
    propagate_at_launch = true  # Ensures the tag is applied at instance launch
  }
}

# Defines an Elastic Load Balancer (ELB) resource that distributes traffic across EC2 instances
resource "aws_elb" "app" {
  subnets = [ aws_subnet.example.id ]  # Subnets in which to place the load balancer

  # Configures a listener to handle HTTP traffic on port 80
  listener {
    instance_port = 80  # The port on which the EC2 instances listen
    instance_protocol = "HTTP"  # The protocol for communication with instances
    lb_port = 80  # The load balancer port for incoming traffic
    lb_protocol = "HTTP"  # The protocol for communication between clients and the load balancer
  }

  # Configures a health check to monitor the status of instances
  health_check {
    target = "HTTP:80/"  # The health check target, checking HTTP on port 80
    interval = 30  # Time between health checks (in seconds)
    timeout = 5  # The time to wait for a health check response before marking it as failed
    healthy_threshold = 2  # The number of successful health checks before considering the instance healthy
    unhealthy_threshold = 2  # The number of failed health checks before considering the instance unhealthy
  }
}
