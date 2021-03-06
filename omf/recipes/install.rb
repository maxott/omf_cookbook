
install_log = node[:omf][:install_log_file]
ruby_v = node[:omf][:ruby_version]

execute "Install rvm" do
  command "curl -L https://get.rvm.io | bash -s stable --ruby=#{ruby_v} > #{install_log}"
  not_if { ::File.exists?('/usr/local/rvm') }
end

execute "Create OMF gemset" do
  command "/usr/local/rvm/bin/rvm ruby-#{ruby_v} exec rvm gemset create omf >> #{install_log}"
end
r_exec = "/usr/local/rvm/bin/rvm ruby-#{ruby_v}@omf exec"

apt_package "libxml2-dev" do
  action :install
end

apt_package "libxslt-dev" do
  action :install
end

execute "Installing OMF RC gem" do
  command "#{r_exec} gem install omf_rc --no-ri --no-rdoc >> #{install_log}"
end

execute "Install upstart script" do
  command "find /usr/local/rvm/gems/*/bin -name install_omf_rc -exec #{r_exec} {} -i -c \; >> #{install_log}"
end
