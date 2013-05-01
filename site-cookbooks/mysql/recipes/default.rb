#
# Cookbook Name:: mysql
# Recipe:: default
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

service "mysqld" do
  supports :status => true, :restart => true
  action [:enable, :start]
end

template "my.cnf" do
  path "/etc/my.cnf"
  source "my.cnf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, 'service[mysqld]'
end
