node[:deploy].each do |app_name, deploy|
  cookbook_file '/tmp/mediawiki.sql.gz' do
    source 'mediawiki.sql.gz'
    mode '0400'
    action :create
  end

  execute "mysql-setup" do
    command "cat /tmp/mediawiki.sql.gz | gzip -d | /usr/bin/mysql -h#{deploy[:database][:host]} -u#{deploy[:database][:username]} -p#{deploy[:database][:password]} #{deploy[:database][:database]}"
    not_if "/usr/bin/mysql -h#{deploy[:database][:host]} -u#{deploy[:database][:username]} -p#{deploy[:database][:password]} #{deploy[:database][:database]} -e'SHOW TABLES' | grep #{node[:mediawiki][:checktable]}"
    action :run
  end
end
