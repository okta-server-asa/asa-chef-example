#
# Cookbook:: asa-chef-example
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

asa_enrollment_token = node['asa_enrollment_token']

case node['platform_family']
when 'rhel', 'suse', 'linux'
  # CONTENT
  log 'RedHat, Suse, or RPM-based distros'
  remote_file "#{Chef::Config['file_cache_path']}/scaleft-server-tools-latest.x86_64.rpm" do
    source 'https://dist.scaleft.com/server-tools/linux/latest/scaleft-server-tools-latest.x86_64.rpm'
    action :create
  end
  rpm_package 'scaleft-server-tools' do
    action :install
    source "#{Chef::Config['file_cache_path']}/scaleft-server-tools-latest.x86_64.rpm"
  end
when 'debian'
  # CONTENT
  log 'Debian'
  remote_file "#{Chef::Config['file_cache_path']}/scaleft-server-tools_latest_amd64.deb" do
    source 'https://dist.scaleft.com/server-tools/linux/latest/scaleft-server-tools_latest_amd64.deb'
    action :create
  end
  dpkg_package 'scaleft-server-tools' do
    action :install
    source "#{Chef::Config['file_cache_path']}/scaleft-server-tools_latest_amd64.deb"
  end
else
  log 'This recipe does not work on ' + node['platform_family'] + ' based Operating Systems.'
  return
end

service 'sftd' do
  action :enable
end

service 'sftd' do
  action :start
end

# PROVIDE CANONICAL NAME AND ENROLL SERVER
directory '/etc/sft' do
  action :create
end

file '/etc/sft/sftd.yaml' do
  content "---\n# CanonicalName: Specifies the name clients should use/see when connecting to this host.\nCanonicalName: \"" + node['name'] + '"' + 
          "\n# AccessInterface: Specifies interface for integration.\nAccessInterface: eth1"
  action :create
end

directory '/var/lib/sftd' do
  action :create
end

# ENROLL SERVER AND RESTART SFTD AGENT

file '/var/lib/sftd/enrollment.token' do
  content asa_enrollment_token
  action :create
  notifies :restart, 'service[sftd]', :immediately
end
