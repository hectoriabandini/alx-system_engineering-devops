#!/usr/bin/env bash
# configures an Nginx server so that /redirect_me redirects to another page.
# The redirection is configured as a "301 Moved Permanently"
# Includes a custom 404 page containing "Ceci n'est pas une page".

#  updates the package lists for available software packages.
apt-get update
# installs the Nginx web server.
apt-get install -y nginx

# Creates the /etc/nginx/html directory, which will serve as the document root directory for Nginx.
mkdir /etc/nginx/html
#  creates an empty index.html file inside the /etc/nginx/html directory.
touch /etc/nginx/html/index.html
#  sets the content of the index.html file to "Hello World!" using the echo command.
echo "Hello World!" > /etc/nginx/html/index.html
# Sets Nginx to listen on port 80 and serve files from the /etc/nginx/html directory.
printf %s "server {
     listen      80 default_server;
     listen      [::]:80 default_server;
     root        /etc/nginx/html;
     index       index.html index.htm;
}
" > /etc/nginx/sites-available/default

#  creates an empty file named 404.html inside the /etc/nginx/html directory.
touch /etc/nginx/html/404.html

# Paste a 404 response in the 404.html file
echo "Ceci n'est pas une page" | sudo tee /etc/nginx/html/404.html

# Display script completion message
echo "Nginx installation and configuration completed."

# Create a configuration file for the redirection
echo "server {
    listen      80;
    listen      [::]:80;
    root        /etc/nginx/html;
    index       index.html index.htm;

    # Add index.php to the list if you are using PHP
    index index.html index.htm index.nginx-debian.html;

    location /redirect_me {
        return 301 https://www.youtube.com/watch?v=QH2-TGUlwu4;
    }

    error_page 404 /404.html;
    location /404 {
      root /etc/nginx/html;
      internal;
    }

}" | sudo tee /etc/nginx/sites-available/default

# Enable the new site configuration
sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

# Test nginx configuration and reload
sudo nginx -t
sudo service nginx reload


7-puppet_install_nginx_web_server.pp

#!/usr/bin/env bash
# Configure server using puppet

# defines a Puppet class called nginx_server that 
#  encapsulates the configuration for the Nginx server.
class nginx_server {
  package { 'nginx':
    ensure => installed,
  }

#  manages the Nginx service.
  service { 'nginx':
    ensure => running,
    enable => true,
    require => Package['nginx'],
  }
# manages the Nginx configuration file located at /etc/nginx/sites-available/default.
  file { '/etc/nginx/sites-available/default':
    ensure  => present,
    content => "
      server {
        listen      80 default_server;
        listen      [::]:80 default_server;
        root        /var/www/html;
        index       index.html index.htm;

        location / {
          return 200 'Hello World!';
        }

        location /redirect_me {
          return 301 http://cuberule.com/;
        }
      }
    ",
    notify => Service['nginx'],
  }
}
#  includes the nginx_server class, ensuring that it gets applied.
include nginx_server
