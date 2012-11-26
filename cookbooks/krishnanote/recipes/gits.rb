#
# Cookbook Name:: Krishnanote
# Recipe:: git
#
# Copyright 2012, Krishna Srihari
#
# All rights reserved - Do Not Redistribute
#
# Creates the ~/Development directory and installs git repositories
# specified as attributes on the node.
#

node['etc']['passwd'].each do |user, userdata|
  # Create the ~/Development directory
  directory "#{userdata['dir']}/Development" do
    owner user
    group userdata['gid']
    mode '0755'
    not_if { userdata['dir'].nil? || userdata['dir'] == '/var/empty' }
  end

  # Clone each git repository from the node's attributes
  #
  # We are using the `checkout` action because it will only checkout the
  # repository if it is not already there. We don't want a Chef run overwriting
  # local changes, but we do want an initial clone, so this is the best option.
  node['krishnasrihari']['git'].each do |repository|
    git "#{userdata['dir']}/#{repository['name']}" do
      repository repository['url']
      reference repository['reference'] || 'master'
      revision repository['revision'] || 'HEAD'
      user user
      group userdata['gid']
      mode '0755'
      action :checkout
    end
  end
end