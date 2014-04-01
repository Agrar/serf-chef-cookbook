
include_recipe "logrotate"

logrotate_app "serf" do
  cookbook  "logrotate"
  path      "/var/log/upstart/serf.log"
  options   ["missingok", "delaycompress", "notifempty"]
  frequency "daily"
  rotate    7
  create    "644 root root"
end

template "/etc/init/serf.conf" do
  source "serf.conf.erb"
  mode 0444
  owner "root"
  group "root"
end

service "serf" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true, :status => true
  action [:enable, :start]
end
