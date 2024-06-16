variable "vpc_cidr_block" {
    type = string 
    description = "describes the cidr of the vpc"
    default = "10.1.0.0/16"
}

variable "availability_zones" {
    type = list(string)
    description = "tells the az of the first and second subnet belongs"
    default = ["us-east-1a", "us-east-1b"]
}

variable "subnet_cidr_block" {
    type = list(string)
    description = "defines the cidr block for all the available subnets"
    default = [ "10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24", "10.1.4.0/24" ]
}

variable "route_table_cidr" {
    description = "defines the CIDR BLOCK for the route table"
    default = "0.0.0.0/0" 
}

