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

package package_name do
  source package_local_path
  provider Chef::Provider::Package::Rpm
end

template '/etc/yum.repos.d/Tuleap.repo' do
  source 'Tuleap.repo.erb'
end

execute 'install-tuleap' do
  command 'sudo yum install -y tuleap-all tuleap-plugin-git-gitolite3'
end

execute 'install-im-plugin' do
  command 'sudo yum install -y tuleap-plugin-im'
end
