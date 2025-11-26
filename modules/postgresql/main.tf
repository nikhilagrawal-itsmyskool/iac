# DB Subnet Group - requires at least 2 subnets in different AZs
resource "aws_db_subnet_group" "postgresql" {
  name = "${var.identifier}-subnet-group"
  subnet_ids = var.use_public_subnet ? [
    var.public_subnet_id_1,
    var.public_subnet_id_2
  ] : [
    var.private_subnet_id_1,
    var.private_subnet_id_2
  ]

  tags = {
    for key, value in var.tags : key => "${value}-subnet-group"
  }
}

# RDS PostgreSQL Instance
resource "aws_db_instance" "postgresql" {
  identifier = var.identifier

  # Engine configuration
  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  # Database configuration
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  # Storage configuration
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true

  # Network configuration
  db_subnet_group_name   = aws_db_subnet_group.postgresql.name
  vpc_security_group_ids = var.security_group_ids
  publicly_accessible    = var.use_public_subnet
  multi_az               = false

  # Backup configuration
  backup_retention_period = var.backup_retention_period
  backup_window          = "20:30-21:30"
  maintenance_window     = "sun:21:30-sun:22:30"

  # Performance Insights
  performance_insights_enabled = false

  # Monitoring
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  monitoring_interval             = 0 # Disable enhanced monitoring for smallest instance
  monitoring_role_arn             = null

  # Deletion protection (set to false for dev environment)
  deletion_protection = false
  skip_final_snapshot = true

  # Tags
  tags = {
    for key, value in var.tags : key => "${value}"
  }

  depends_on = [aws_db_subnet_group.postgresql]
}

