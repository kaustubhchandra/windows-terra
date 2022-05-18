resource "aws_ebs_volume" "vol-6" {
  availability_zone = "us-east-1c"
  size              = 30
}

#volume-attachment

resource "aws_volume_attachment" "ebs_att-6" {
  device_name = "/dev/xvde"
  volume_id   = aws_ebs_volume.vol-6.id
  instance_id = aws_instance.win-example-5.id
}

resource "aws_ebs_volume" "vol-7" {
  availability_zone = "us-east-1c"
  size              = 30
}

#volume-attachment

resource "aws_volume_attachment" "ebs_att-7" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.vol-7.id
  instance_id = aws_instance.win-example-5.id
}

resource "aws_ebs_volume" "vol-8" {
  availability_zone = "us-east-1c"
  size              = 30
}

#volume-attachment

resource "aws_volume_attachment" "ebs_att-8" {
  device_name = "/dev/xvdg"
  volume_id   = aws_ebs_volume.vol-8.id
  instance_id = aws_instance.win-example-5.id
}

resource "aws_ebs_volume" "vol-9" {
  availability_zone = "us-east-1c"
  size              = 30
}

#volume-attachment

resource "aws_volume_attachment" "ebs_att-9" {
  device_name = "/dev/xvdi"
  volume_id   = aws_ebs_volume.vol-9.id
  instance_id = aws_instance.win-example-5.id
}
