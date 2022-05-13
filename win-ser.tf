provider "aws" { 
access_key = "AKIATHAGUO2PSPMINDHN"
secret_key = "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"
region = "ap-south-1" 
}

data "template_file" "userdata_win" {
  template = <<EOF
<powershell>
Initialize-Disk -Number 1
New-Partition –DiskNumber 1 -DriveLetter E –UseMaximumSize
Set-Partition -DriveLetter E -IsActive $true
Initialize-Disk -Number 2
New-Partition –DiskNumber 2 -DriveLetter F –UseMaximumSize
Set-Partition -DriveLetter F -IsActive $true
Initialize-Disk -Number 3
New-Partition –DiskNumber 3 -DriveLetter G –UseMaximumSize
Set-Partition -DriveLetter G -IsActive $true
Initialize-Disk -Number 4
New-Partition –DiskNumber 4 -DriveLetter H –UseMaximumSize
Set-Partition -DriveLetter H -IsActive $true
</powershell>
<persist>true</persist>
EOF
}


resource "aws_instance" "win-example" {
  ami           = "ami-09ed03e97033b6d21"
  instance_type = "t2.micro"
  key_name      = "aazad"
  associate_public_ip_address = false
  user_data = data.template_file.userdata_win.rendered
  subnet_id = "${aws_subnet.privatesubnets.id}"
  vpc_security_group_ids = [
        aws_security_group.kk-ssh-allowed.id
        ]
  tags = {
    Name = "Windows_Server"
  }

}

output "ip" {

value="${aws_instance.win-example.public_ip}"

}

#adding volume

resource "aws_ebs_volume" "vol-1" {
  availability_zone = "ap-south-1b"
  size              = 30
}

resource "aws_ebs_volume" "vol-2" {
  availability_zone = "ap-south-1b"
  size              = 30
}

resource "aws_ebs_volume" "vol-3" {
  availability_zone = "ap-south-1b"
  size              = 30
}

resource "aws_ebs_volume" "vol-4" {
  availability_zone = "ap-south-1b"
  size              = 30
}

#volume-attachment

resource "aws_volume_attachment" "ebs_att-1" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.vol-1.id
  instance_id = aws_instance.win-example.id
}


resource "aws_volume_attachment" "ebs_att-2" {
  device_name = "/dev/xvda"
  volume_id   = aws_ebs_volume.vol-2.id
  instance_id = aws_instance.win-example.id
}

resource "aws_volume_attachment" "ebs_att-3" {
  device_name = "/dev/xvdb"
  volume_id   = aws_ebs_volume.vol-3.id
  instance_id = aws_instance.win-example.id
}

resource "aws_volume_attachment" "ebs_att-4" {
  device_name = "/dev/xvdc"
  volume_id   = aws_ebs_volume.vol-4.id
  instance_id = aws_instance.win-example.id
}


resource "aws_instance" "win-example2" {
  ami           = "ami-09ed03e97033b6d21"
  instance_type = "t2.micro"
  key_name      = "aazad"
  associate_public_ip_address = true
  user_data = data.template_file.userdata_win.rendered
  subnet_id = "${aws_subnet.publicsubnets.id}"
  vpc_security_group_ids = [
        aws_security_group.kk-ssh-allowed.id
        ]
  tags = {
    Name = "Windows_jump_Server"
  }

}

output "ip2" {

value="${aws_instance.win-example2.public_ip}"

}
