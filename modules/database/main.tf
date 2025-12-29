resource "aws_db_subnet_group" "wandb" {
  name       = "wandb-db-subnets-${var.environment}"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.common_tags, {
    Name = "wandb-db-subnet-group"
  })
}

resource "aws_security_group" "wandb_db" {
  name        = "wandb-db-sg-${var.environment}"
  description = "Allow MySQL access from EKS"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [
      var.eks_cluster_security_group_id,
      var.eks_node_security_group_id
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "wandb-db-sg"
  })
}

resource "aws_db_instance" "wandb" {
  identifier = "wandb-mysql-${var.environment}"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.medium"
  allocated_storage = 50

  db_name  = "wandb"
  username = "wandb"
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.wandb.name
  vpc_security_group_ids = [aws_security_group.wandb_db.id]

  storage_encrypted = true
  skip_final_snapshot = true

  publicly_accessible = false

  tags = merge(var.common_tags, {
    Name = "wandb-db"
  })
}
