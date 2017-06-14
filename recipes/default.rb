#
# Cookbook:: tuleap
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
package_url = 'http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm'
package_name = ::File.basename(package_url)
package_local_path = "#{Chef::Config[:file_cache_path]}/#{package_name}"

remote_file package_local_path do
  source package_url
end

template '/etc/yum.repos.d/Tuleap.repo' do
  source 'Tuleap.repo.erb'
end

package package_name do
  source package_local_path
  provider Chef::Provider::Package::Rpm
  notifies :run, 'execute[install-tuleap]', :immediately
  notifies :run, 'execute[install-im-plugin]', :immediately
  notifies :run, 'execute[save-ip]', :immediately
  notifies :run, 'execute[tuleap-setup]', :immediately
end

execute 'install-tuleap' do
  command 'sudo yum install -y tuleap-all tuleap-plugin-git-gitolite3'
  action :nothing
end

execute 'install-im-plugin' do
  command 'sudo yum install -y tuleap-plugin-im'
  action :nothing
end

execute 'save-ip' do
  command 'ip="$(ifconfig | grep -A 1 'eth0' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1)"'
  action :nothing
end

execute 'tuleap-setup' do
  command ./setup.sh --sys-default-domain=$ip --sys-org-name='oracle fedex day'
  action :nothing
end
