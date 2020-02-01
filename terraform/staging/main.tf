variable path {}
variable memory_size {}
variable timeout {}
variable priority {}
variable listener_arn {}
variable name {}
variable environment {}

provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket = "eat20-terraform"
    key    = "staging/tpl-2020-function.tfstate"
    region = "eu-west-1"
  }
}

/*******************************************************************************
********** Lambda
*******************************************************************************/

resource "aws_lambda_function" "lambda" {
  filename = "payload.zip"
  function_name = "${var.environment}-${var.name}"
  role          = data.aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"
  source_code_hash = filebase64sha256("payload.zip")
  runtime = "nodejs12.x"

  memory_size = var.memory_size
  timeout = var.timeout
  publish = true
}

/*******************************************************************************
********** Load balancer
*******************************************************************************/

resource "aws_lambda_permission" "permission" {
  statement_id  = "AllowExecutionFromlb"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.arn
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.blue.arn
}

resource "aws_lb_target_group" "blue" {
  name        = "tg${substr(var.environment, 0, 1)}-${replace(var.name, "_", "-")}"
  target_type = "lambda"
}

resource "aws_lb_target_group_attachment" "attachment" {
  target_group_arn = aws_lb_target_group.blue.arn
  target_id        = aws_lambda_function.lambda.arn
  depends_on       = [aws_lambda_permission.permission]
}

resource "aws_lb_listener_rule" "path" {
  listener_arn = var.listener_arn
  priority = var.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }

  condition {
    path_pattern {
      values = ["/lambda/${var.path}"]
    }
  }
}

/*******************************************************************************
********** Roles
*******************************************************************************/

data "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
}