resource "aws_ecr_repository" "this" {
  name = var.ecr_name
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy = jsonencode({
    rules = concat([
      {
        rulePriority = 1
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["latest", "development", "dev", "production", "staging", "prod", "stg"]
          countType     = "imageCountMoreThan"
          countNumber   = 10
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 20
        },
        action = {
          type = "expire"
        }
      }
    ])
  })
}
