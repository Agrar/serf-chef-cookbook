#
# Cookbook Name:: serf
# Recipe:: agent
#
# Copyright (C) 2014 Agrar <contact@agrar.io>
# 
# This project and its contents are open source under the MIT license.
#

include_recipe "apt"

user "serf" do
  username "serf"
  action :remove
  action :create
  system true
end

group "serf" do
  members "serf"
  action :remove
  action :create
end

remote_file "#{Chef::Config[:file_cache_path]}/serf-#{node[:serf][:version]}.zip" do
  source node[:serf][:package_source]
end

package "unzip"

bash "extract_app" do
  code <<-EOH
    unzip #{Chef::Config[:file_cache_path]}/serf-#{node[:serf][:version]}.zip -d /usr/local/bin/
    EOH
  not_if { ::File.exists?("/usr/local/bin/serf") }
end

file "/usr/local/bin/serf" do
  mode 00777
  owner "serf"
  group "serf"
end

# /etc/serf/

directory "/etc/serf" do
  owner "serf"
  group "serf"
  recursive true
  action :create
end

directory "/etc/serf/config.d/" do
  owner "serf"
  group "serf"
  recursive true
  action :create
end

template "/etc/serf/agent.config" do
  source "serf_agent.json.erb"
  group "serf"
  owner "serf"
  mode 00664
  variables(:agent_json => JSON.pretty_generate(node[:serf][:agent].to_hash))
  backup false
end

# /var/serf/

directory "/var/serf" do
  owner "serf"
  group "serf"
  recursive true
  action :create
end
