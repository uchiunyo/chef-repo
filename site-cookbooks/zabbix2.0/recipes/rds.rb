#
# Cookbook zabbix2.0
# Recipe:: rds
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "mysql" do
  action :install
end

bash "createdb" do
  code <<-EOC
    /usr/bin/mysql -u#{node["zabbix"]["rds"]["MasterUsername"]} -p#{node["zabbix"]["rds"]["MasterPassword"]} -h #{node["zabbix"]["rds"]["Endpoint"]} -e 'create database #{node["zabbix"]["server"]["DBName"]} character set utf8;'
    /usr/bin/mysql -u#{node["zabbix"]["rds"]["MasterUsername"]} -p#{node["zabbix"]["rds"]["MasterPassword"]} -h #{node["zabbix"]["rds"]["Endpoint"]} -e "grant all privileges on #{node["zabbix"]["server"]["DBName"]}.* to #{node["zabbix"]["server"]["DBUser"]}@'%' identified by '#{node["zabbix"]["server"]["DBPassword"]}';"
  EOC
  not_if "/usr/bin/mysql -u#{node["zabbix"]["rds"]["MasterUsername"]} -p#{node["zabbix"]["rds"]["MasterPassword"]} -h #{node["zabbix"]["rds"]["Endpoint"]} -e 'show databases;' | grep #{node["zabbix"]["server"]["DBName"]}"
end
