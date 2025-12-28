resource "aws_db_subnet_group" "wandb" {
  name       = "wandb-db-subnets"
  subnet_ids = data.terraform_remote_state.platform.outputs.private_subnet_ids

  tags = {
    Application = "wandb"
  }
}

resource "aws_security_group" "wandb_db" {
  name        = "wandb-db-sg"
  description = "Allow Postgres access from EKS"
  vpc_id      = data.terraform_remote_state.platform.outputs.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [
      data.terraform_remote_state.platform.outputs.eks_cluster_security_group_id
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "wandb" {
  identifier = "wandb-mysql"

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
}