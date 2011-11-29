# NFS server setup
# Setup apps directories, export them through NFS

# Install packages
install_pkg portmap nfs-common nfs-kernel-server

# setup a log, temp and site directory in ephemeral storage
mkdir /mnt/localapps
mkdir /mnt/localapps/logs
mkdir /mnt/localapps/sites
mkdir /mnt/localapps/nginx
mkdir /mnt/localapps/apache
mkdir /mnt/localapps/varnish
mkdir /mnt/localapps/media
mkdir /mnt/tmp
chmod ugo+rwx -r /mnt/tmp /mnt/localapps

# shortcuts in the home directory
ln -s /mnt/localapps/logs /home/$USERNAME/logs
ln -s /mnt/localapps/sites /home/$USERNAME/sites
ln -s /mnt/localapps/apache /home/$USERNAME/apache
ln -s /mnt/localapps/varnish /home/$USERNAME/varnish
ln -s /mnt/localapps/nginx /home/$USERNAME/nginx
ln -s /mnt/localapps/media /home/$USERNAME/media

# setup our apps share. You probably want to create, attach and mount an ebs here.
mkdir /mnt/apps

# Add our share to NFS exports
echo '/mnt/apps 10.0.0.0/8(rw,sync,no_subtree_check,no_root_squash)' >> /etc/exports

# Fix for NFSv4 that's sometimes needed for proper permissions
sed s/^NEED_IDMAPD=$/NEED_IDMAPD=yes/g /etc/default/nfs-common >/etc/default/nfs-common.new
mv /etc/default/nfs-common.new /etc/default/nfs-common
service nfs-kernel-server reload

# make sure idmapd starts
service idmapd start

