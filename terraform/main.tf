module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "ecommerce-vpc"
  cidr = var.vpc_cidr

  azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.28"

  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      desired_size = var.desired_capacity
      max_size     = var.max_capacity
      min_size     = var.min_capacity

      instance_types = [var.instance_type]
      capacity_type  = "ON_DEMAND"
    }
  }

  

  access_entries = {
  admin = {
        principal_arn = "arn:aws:iam::967990099109:user/eks-admin"
        policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
        access_scope  = {
          type = "cluster"
        }
      }
  }

  cluster_endpoint_public_access       = true
  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access_cidrs = ["197.210.54.243/32"] # Your IP

  tags = {
      Terraform   = "true"
      Environment = "dev"
    }
}
