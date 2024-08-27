resource "aws_ecr_repository" "this" {
  name = var.ecr_name
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy     = <<EOF
    {
      "rules": [
          {
              "rulePriority": 1,
              "description": "Holds up to 10 images tagged with the intent.",
              "selection": {
                  "tagStatus": "tagged",
                  "tagPrefixList": ["latest", "development", "dev", "production", "staging", "prod", "stg"],
                  "countType": "imageCountMoreThan",
                  "countNumber": 10
              },
              "action": {
                  "type": "expire"
              }
          },
          {
              "rulePriority": 2,
              "description": "Holds up to 30 images with the intent.",
              "selection": {
                  "tagStatus": "any",
                  "countType": "imageCountMoreThan",
                  "countNumber": 30
              },
              "action": {
                  "type": "expire"
              }
          }
      ]
    }
  EOF
}