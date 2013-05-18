#
# Cookbook Name:: zabbix-server
# Recipe:: default
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
  code <<-EOC
    dirname=`ls /usr/share/doc | grep zabbix-server`
    /usr/bin/mysql -uroot zabbix < /usr/share/doc/${dirname}/create/schema.sql
    /usr/bin/mysql -uroot zabbix < /usr/share/doc/${dirname}/create/images.sql
    /usr/bin/mysql -uroot zabbix < /usr/share/doc/${dirname}/create/data.sql
  EOC
  action :nothing
end

execute "createuser" do
  command "/usr/bin/mysql -uroot -e \"grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';\""
  action :nothing
  notifies :run, resources( :bash => "importdb")
end

execute "createdb" do
  not_if "/usr/bin/mysql -uroot -e 'show databases;' | grep zabbix"
  command "/usr/bin/mysql -uroot -e 'create database zabbix character set utf8;'"
  notifies :run, resources( :execute => "createuser")
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
