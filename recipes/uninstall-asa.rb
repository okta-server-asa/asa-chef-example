#
# Cookbook:: asa-chef-example
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

case node['platform_family']
when 'rhel', 'suse'
  # CONTENT
  log 'RedHat or Suse distros'
  file "#{Chef::Config['file_cache_path']}/scaleft-server-tools-latest.x86_64.rpm" do
    action :delete
  end
  rpm_package 'scaleft-server-tools' do
    action :remove
  end
when 'debian'
  # CONTENT
  log 'Debian'
  file "#{Chef::Config['file_cache_path']}/scaleft-server-tools_latest_amd64.deb" do
    action :delete
  end
  dpkg_package 'scaleft-server-tools' do
    action :purge
  end
else
  log 'This recipe does not work on ' + node['platform_family'] + ' based Operating Systems.'
  return
end

directory '/etc/sft' do
  action :delete
  recursive true
end

directory '/var/lib/sftd' do
  action :delete
  recursive true
end
