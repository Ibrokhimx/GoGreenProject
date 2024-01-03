#cloud-boothook
#!/bin/bash -ex
{
# Update the system
yum -y update
# Install MySQL Community Server
yum -y install mysql-community-server
yum -y install https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
# Start and enable MySQL
systemctl start mysqld
systemctl enable mysqld
# Install Apache and PHP
yum -y install httpd php
# Start and enable Apache
systemctl start httpd
systemctl enable httpd
cd /var/www/html
wget https://aws-tc-largeobjects.s3-us-west-2.amazonaws.com/CUR-TF-200-ACACAD/studentdownload/lab-app.tgz
tar xvfz lab-app.tgz
chown apache:root /var/www/html/rds.conf.php
}
&> /var/log/user_data.log