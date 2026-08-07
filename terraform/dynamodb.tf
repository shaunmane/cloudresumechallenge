resource "aws_dynamodb_table" "counter_table" {
  name           = var.db_table
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"

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
    "id": {
      "S": "1"
    },
    "item1": {
      "S": "1"
    }
  }
  ITEM
}