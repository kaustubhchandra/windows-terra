provider "aws" { 
access_key = "AKIATHAGUO2PSPMINDHN"
secret_key = "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"
region = "us-east-1" 
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
#chocolaty installation
Get-ExecutionPolicy
Set-ExecutionPolicy AllSigned
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString(‘https://chocolatey.org/install.ps1’))
#chrom
Choco install GoogleChrome -y
#winscp
choco install winscp -y
#Matlab
choco install mcr-r2015b -y
#sftp
choco install openssh -y
</powershell>
<persist>true</persist>
EOF
}

#####forsftp###

data "template_file" "userdata_win-2" {
  template = <<EOF
<powershell>
Initialize-Disk -Number 1
New-Partition –DiskNumber 1 -DriveLetter E –UseMaximumSize
Set-Partition -DriveLetter E -IsActive $true
#chocolaty installation
Get-ExecutionPolicy
Set-ExecutionPolicy AllSigned
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString(‘https://chocolatey.org/install.ps1’))
#sftp
choco install openssh -y
</powershell>
<persist>true</persist>
EOF
}

resource "aws_ebs_volume" "vol-5" {
  availability_zone = "us-east-1b"
  size              = 30
}

#volume-attachment

resource "aws_volume_attachment" "ebs_att-5" {
  device_name = "/dev/xvdd"
  volume_id   = aws_ebs_volume.vol-5.id
  instance_id = aws_instance.win-example3.id
}

############end###


# private windows insatnce

resource "aws_instance" "win-example" {
  ami           = "ami-033594f8862b03bb2"
  instance_type = "t2.micro"
  key_name      = "aazadi"
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

#resource  "aws_ami_from_instance" "test-wordpress-ami" {
  #  name               = "test-wordpress-ami"
  #  source_instance_id = "${aws_instance.win-example.id}"

 # depends_on = [
   #   aws_instance.win-example,
  #    ]

 # tags = {
  #    Name = "test-wordpress-ami"
 # }

#}


resource "aws_instance" "win-example-4" {
  ami           = "ami-033594f8862b03bb2"
  instance_type = "t2.micro"
  key_name      = "aazadi"
  associate_public_ip_address = false
#  user_data = data.template_file.userdata_win.rendered
  subnet_id = "${aws_subnet.privatesubnets-2.id}"
  vpc_security_group_ids = [
        aws_security_group.kk-ssh-allowed.id
        ]
  tags = {
    Name = "Windows_Server-2"
  }

}

output "ip4" {

value="${aws_instance.win-example-4.public_ip}"

}

resource "aws_instance" "win-example-5" {
  ami           = "ami-0cad0b3ad9250ed85"
  instance_type = "m4.large"
  key_name      = "aazadi"
  associate_public_ip_address = false
  user_data = data.template_file.userdata_win.rendered
  subnet_id = "${aws_subnet.privatesubnets-3.id}"
  vpc_security_group_ids = [
        aws_security_group.kk-ssh-allowed.id
        ]
  tags = {
    Name = "Windows_Server-sql"
  }

}

output "ip5" {

value="${aws_instance.win-example-5.public_ip}"

}


#adding volume

resource "aws_ebs_volume" "vol-1" {
  availability_zone = "us-east-1b"
  size              = 30
}

resource "aws_ebs_volume" "vol-2" {
  availability_zone = "us-east-1b"
  size              = 30
}

resource "aws_ebs_volume" "vol-3" {
  availability_zone = "us-east-1b"
  size              = 30
}

resource "aws_ebs_volume" "vol-4" {
  availability_zone = "us-east-1b"
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

#windows Jump servers

resource "aws_instance" "win-example2" {
  ami           = "ami-033594f8862b03bb2"
  instance_type = "t2.micro"
  key_name      = "aazadi"
  associate_public_ip_address = true
 # user_data = data.template_file.userdata_win.rendered
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

resource "aws_instance" "win-example3" {
  ami           = "ami-033594f8862b03bb2"
  instance_type = "t2.micro"
  key_name      = "aazadi"
  associate_public_ip_address = true
  user_data = data.template_file.userdata_win-2.rendered
  subnet_id = "${aws_subnet.publicsubnets-2.id}"
  vpc_security_group_ids = [
        aws_security_group.kk-ssh-allowed.id
        ]
  tags = {
    Name = "Windows_jump_Server-SFTP"
  }

}

output "ip3" {

value="${aws_instance.win-example3.public_ip}"

}
