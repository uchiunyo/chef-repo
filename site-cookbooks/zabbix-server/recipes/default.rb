#
# Cookbook Name:: zabbix-server
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
case node['platform']
when "centos"
  yum_repository "zabbix" do
    if /i386|i686/ =~ node['kernel']['machine']
      url "http://repo.zabbix.com/zabbix/2.0/rhel/6/i386/"
    else
      url "http://repo.zabbix.com/zabbix/2.0/rhel/6/x86_64/"
    end
    action :add
  end
end

%w{zabbix-server-mysql zabbix-web-mysql}.each do |pkg|
  package pkg do
    action :install
  end
end

bash "importdb" do
  version_tmp = `/usr/sbin/zabbix_server --version`
  exp = Regexp.new('([0-9]+\.[0-9]+\.[0-9]+)')
  version = exp.match(version_tmp)[0]

  code <<-EOC
    /usr/bin/mysql -uroot zabbix < /usr/share/doc/zabbix-server-mysql-#{version}/create/schema.sql
    /usr/bin/mysql -uroot zabbix < /usr/share/doc/zabbix-server-mysql-#{version}/create/images.sql
    /usr/bin/mysql -uroot zabbix < /usr/share/doc/zabbix-server-mysql-#{version}/create/data.sql
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


