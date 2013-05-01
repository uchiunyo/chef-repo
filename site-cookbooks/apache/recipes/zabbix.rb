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
