resource "aws_dynamodb_table" "counter_table" {
  name         = var.db_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "first_one" {
  table_name = aws_dynamodb_table.counter_table.name
  hash_key   = aws_dynamodb_table.counter_table.hash_key

  item = <<ITEM
  {
    "id": {"S": "site_hits"},
    "views": {"N": "0"}
  }
  ITEM
}