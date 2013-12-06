{%extends 'wordpress/base.sh' %}

{% block install %}
# install some basic stuff
DEBIAN_FRONTEND='noninteractive' \
apt-get -q -y -o Dpkg::Options::='--force-confnew' install \
        mysql-server

# Install NFS server
{% include "_nfs-server.sh" %}

# MySQL configuration

# Comment out the bind-address config so MySQL will accept outside connections
sed "s/^bind-address/# bind-address/g" /etc/mysql/my.cnf >/etc/mysql/my.cnf.new
mv /etc/mysql/my.cnf.new /etc/mysql/my.cnf
#service mysql reload

# setup users for mysql
{% if ROOT_DB_PASSWORD -%}
echo "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' IDENTIFIED BY '{{ROOT_DB_PASSWORD}}' WITH GRANT OPTION;" |mysql

# set db root password
mysqladmin -u root password '{{ROOT_DB_PASSWORD}}'
{% else -%}
echo "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;" |mysql
{% endif -%}

{% endblock %}

