data "aws_iam_role" "i_am_role"{
  name = "ofori-samuel-container-registry"
}

data "aws_subnet" "tedsearch" {
  id = "subnet-03d23ca08b77a0f40"
}

data "aws_security_group" "tedsearch" {
  id = "sg-0582d0be695a190da"
}
