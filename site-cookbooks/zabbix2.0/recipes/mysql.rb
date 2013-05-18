#
# Cookbook Name:: zabbix2.0
# Recipe:: mysql
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "mysql" do
  action :install
end

package "mysql-server" do
  action :install
end

template "my.cnf" do
  path "/etc/my.cnf"
  source "my.cnf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, 'service[mysqld]'
end

service "mysqld" do
  supports :status => true, :restart => true
  action [:enable, :start]
end

bash "createdb" do
  code <<-EOC
  /usr/bin/mysql -uroot -e 'create database #{node["zabbix"]["server"]["DBName"]} character set utf8;'
  /usr/bin/mysql -uroot -e "grant all privileges on #{node["zabbix"]["server"]["DBName"]}.* to #{node["zabbix"]["server"]["DBUser"]}@localhost identified by '#{node["zabbix"]["server"]["DBPassword"]}';"
  EOC
  not_if "/usr/bin/mysql -uroot -e 'show databases;' | grep #{node["zabbix"]["server"]["DBName"]}"
end
