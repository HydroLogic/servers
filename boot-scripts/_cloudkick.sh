# Include file to setup cloudkick monitoring

# Add the cloudkick repository
curl http://packages.cloudkick.com/cloudkick.packages.key | apt-key add -
echo 'deb http://packages.cloudkick.com/ubuntu lucid main' > /etc/apt/sources.list.d/cloudkick.list
apt-get update

# Create the config file
echo "oauth_key {{CLOUDKICK_OAUTH_KEY}}
oauth_secret {{CLOUDKICK_OAUTH_SECRET}}
tags {{CLOUDKICK_TAGS}}
name {{SERVER_NAME}}" > /etc/cloudkick.conf

# Install the common files
apt-get install cloudkick-config

# Download and install the deb
wget http://packages.cloudkick.com/releases/cloudkick-agent/binaries/cloudkick-agent-ubuntu11.10-0.9.21_amd64.deb
dpkg -i cloudkick-agent-ubuntu11.10-0.9.21_amd64.deb

# Install plugins
mkdir /usr/lib/cloudkick-agent
git clone https://github.com/newsapps/agent-plugins.git /usr/lib/cloudkick-agent/plugins
