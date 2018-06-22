#
# Cookbook:: belfast
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# Install Nginx
include_recipe 'nginx::default'

# Drop in a file that will be served by Nginx
cookbook_file '/usr/share/nginx/html/index.html' do
  source 'index.html'
end
