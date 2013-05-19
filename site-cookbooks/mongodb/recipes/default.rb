#
# Cookbook Name:: mongodb
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
case node['platform']
when "centos", "amazon"
  yum_repository "10gen" do
    description "10gen Repository"
    if /i386|i686/ =~ node['kernel']['machine']
      url "http://downloads-distro.mongodb.org/repo/redhat/os/i686"
    else
      url "http://downloads-distro.mongodb.org/repo/redhat/os/x86_64"
    end
    action :add
  end
end

%w{mongo-10gen mongo-10gen-server}.each do |pkg|
  package pkg do
    action :install
  end
end

service "mongod" do
  supports :status => true, :restart => true
  action [:enable, :start]
end

