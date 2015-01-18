include_recipe "apt::default"

apt_package "vim"
apt_package "graphite-web"
apt_package "graphite-carbon"
apt_package "postgresql"
apt_package "postgresql-contrib"
apt_package "libpq-dev"
apt_package "python-psycopg2"
apt_package "apache2"
apt_package "libapache2-mod-wsgi"

template "/tmp/setupGraphiteDB.sql" do
    source "setupGraphiteDB.sql.erb"
end

execute "psql -f /tmp/setupGraphiteDB.sql" do
    user "postgres"
end

template "/etc/graphite/local_settings.py" do
    source "local_settings.py.erb"
end

template "/etc/graphite/initial_data.json" do
  source "initial_data.json.erb"
end

execute "syncdb" do
  cwd "/etc/graphite"
  command "graphite-manage syncdb --noinput -v 3"
end

template "/etc/default/graphite-carbon" do
    source "graphite-carbon.erb"
end

template "/etc/carbon/carbon.conf" do
    source "carbon.conf.erb"
end

template "/etc/carbon/storage-aggregation.conf" do
    source "storage-aggregation.conf.erb"
end

service "carbon-cache" do
    action :start
end

execute "a2dissite 000-default"

template "/etc/apache2/sites-available/apache2-graphite.conf" do
    source "apache2-graphite.conf.erb"
end

execute "a2ensite apache2-graphite"

service "apache2" do
    action :restart
end
