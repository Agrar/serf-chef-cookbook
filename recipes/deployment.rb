
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
