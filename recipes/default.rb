include_recipe "apt::default"

apt_package "vim"
apt_package "graphite-web"
apt_package "graphite-carbon"
apt_package "postgresql"
apt_package "libpq-dev"
apt_package "python-psycopg2"

template "/tmp/setupGraphiteDB.sql" do
    source "setupGraphiteDB.sql.erb"
end

execute "psql -f /tmp/setupGraphiteDB.sql" do
    user "postgres"
end