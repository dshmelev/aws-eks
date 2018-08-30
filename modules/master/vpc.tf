# This data source is included for ease of sample architecture deployment
# and can be swapped out as necessary.
data "aws_availability_zones" "available" {}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"

  tags = "${
    map(
     "Name", "${var.cluster-name}",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_subnet" "this" {
  count = 2

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = "${aws_vpc.this.id}"

  tags = "${
    map(
     "Name", "terraform-eks-demo-node",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "this" {
  vpc_id = "${aws_vpc.this.id}"

  tags {
    Name = "${var.cluster-name}"
  }
}

resource "aws_route_table" "this" {
  vpc_id = "${aws_vpc.this.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.this.id}"
  }
}

resource "aws_route_table_association" "this" {
  count = 2

  subnet_id      = "${aws_subnet.this.*.id[count.index]}"
  route_table_id = "${aws_route_table.this.id}"
}

resource "aws_security_group" "cluster" {
  name        = "${var.cluster-name}"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${aws_vpc.this.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.cluster-name}"
  }
}

# OPTIONAL: Allow inbound traffic from your local workstation external IP
#           to the Kubernetes. You will need to replace A.B.C.D below with
#           your real IP. Services like icanhazip.com can help you find this.
resource "aws_security_group_rule" "cluster-ingress-workstation-https" {
  cidr_blocks       = [
    "80.76.244.114/32",
    "81.3.129.2/32",
    "212.18.2.2/32",
    "217.111.48.242/32",
    "86.49.92.98/32",
    "144.121.2.66/32",
    "109.73.33.210/32",
    "95.170.151.130/32",
  ]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.cluster.id}"
  to_port           = 443
  type              = "ingress"
}