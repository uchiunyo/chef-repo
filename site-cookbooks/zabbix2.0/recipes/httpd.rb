#
# Cookbook Name:: zabbix2.0
# Recipe:: httpd
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
template "zabbix.conf" do
  path "/etc/httpd/conf.d/zabbix.conf"
  source "zabbix.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, 'service[httpd]'
end

service "httpd" do
  supports :status => true, :restart => true
  action [:enable, :start]
end
