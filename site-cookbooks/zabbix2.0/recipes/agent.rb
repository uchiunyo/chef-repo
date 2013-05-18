#
# Cookbook Name:: zabbix2.0
# Recipe:: agent
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{zabbix-agent zabbix-get}.each do |pkg|
  package pkg do
    action :install
  end
end

template "zabbix_agentd.conf" do
  path "/etc/zabbix/zabbix_agentd.conf"
  source "zabbix_agentd.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, 'service[zabbix-agent]'
end

service "zabbix-agent" do
  supports :status => true, :restart => true
  action [:enable, :start]
end

