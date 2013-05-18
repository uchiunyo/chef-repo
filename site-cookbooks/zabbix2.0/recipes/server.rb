#
# Cookbook Name:: zabbix2.0
# Recipe:: server
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{httpd zabbix-server-mysql zabbix-web-mysql}.each do |pkg|
  package pkg do
    action :install
  end
end

bash "importdb" do
  not_if "/usr/bin/mysql -u#{node["zabbix"]["server"]["DBName"]} -p#{node["zabbix"]["server"]["DBPassword"]} -h #{node["zabbix"]["server"]["DBHost"]} -e 'show tables from zabbix;' | grep hosts"
  code <<-EOC
    dirname=`ls /usr/share/doc | grep zabbix-server`
    /usr/bin/mysql -u#{node["zabbix"]["server"]["DBName"]} -p#{node["zabbix"]["server"]["DBPassword"]} -h #{node["zabbix"]["server"]["DBHost"]} zabbix < /usr/share/doc/${dirname}/create/schema.sql
    /usr/bin/mysql -u#{node["zabbix"]["server"]["DBName"]} -p#{node["zabbix"]["server"]["DBPassword"]} -h #{node["zabbix"]["server"]["DBHost"]} zabbix < /usr/share/doc/${dirname}/create/images.sql
    /usr/bin/mysql -u#{node["zabbix"]["server"]["DBName"]} -p#{node["zabbix"]["server"]["DBPassword"]} -h #{node["zabbix"]["server"]["DBHost"]} zabbix < /usr/share/doc/${dirname}/create/data.sql
  EOC
end

link "/etc/zabbix/alertscripts" do
  to "/usr/lib/zabbix/alertscripts"
  link_type :symbolic
end

link "/etc/zabbix/externalscripts" do
  to "/usr/lib/zabbix/externalscripts"
  link_type :symbolic
end

template "zabbix_server.conf" do
  path "/etc/zabbix/zabbix_server.conf"
  source "zabbix_server.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, 'service[zabbix-server]'
end

service "zabbix-server" do
  supports :status => true, :restart => true
  action [:enable, :start]
end

case node['platform']
when "centos"
  package "ipa-pgothic-fonts" do
    action :install
  end
  link "/usr/share/zabbix/fonts/graphfont.ttf" do
    to "/usr/share/fonts/ipa-pgothic/ipagp.ttf"
    link_type :symbolic
  end
when "amazon"
  package "ipa-gothic-fonts" do
    action :install
  end
  link "/usr/share/zabbix/fonts/graphfont.ttf" do
    to "/usr/share/fonts/ipa-gothic/ipag.ttf"
    link_type :symbolic
  end
end
