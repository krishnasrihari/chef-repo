#
# Cookbook Name:: hello_world
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# recipes/default.rb
template "#{ENV['HOME']}/hello-world.txt" do
  source 'hello-world.txt.erb'
  mode '0644'
end