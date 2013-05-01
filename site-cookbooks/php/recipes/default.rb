#
# Cookbook Name:: php
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
%w{php php-bcmath php-gd php-mbstring php-mysql php-xml ipa-pgothic-fonts}.each do |pkg|
  package pkg do
    action :install
  end
end
