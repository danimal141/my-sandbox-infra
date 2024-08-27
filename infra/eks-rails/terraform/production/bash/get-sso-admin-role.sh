#!/bin/bash
aws iam list-roles --query 'Roles[*].{RoleName:RoleName,Arn:Arn}' --path-prefix /aws-reserved/sso.amazonaws.com/ | jq '.[] | select(.RoleName |test("AWSReservedSSO_AdministratorAccess_*"))'
