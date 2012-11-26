#
# Cookbook Name:: major-tom
# Recipe:: default
#
# Copyright 2012, Krishna Srihari
#
# All rights reserved - Do Not Redistribute
#


remote_file "#{Chef::Config[:file_cache_path]}/background.png" do
	source 'http://placehold.it/1440x900'
	notifies :run, 'execute[set Desktop background]', :immediately
end

execute 'set Desktop background' do
	command "gconftool-2 -t string -s /desktop/gnome/background/picture_filename #{Chef::Config[:file_cache_path]}/background.png"
	user 'krishna'
	action :nothing
end
