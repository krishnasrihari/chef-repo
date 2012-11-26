#
# Cookbook Name:: krishnanote
# Recipe:: dotfiles
#
# Copyright 2012, Krishna Srihari
#
# All rights reserved - Do Not Redistribute
#

# Clone the remote dotfiles
#
# Again, only use :checkout because we don't want to clone on future attempts.
# We also don't plan on working with this repository, so we don't need the entire
# git history. Setting the depth to `1` makes a shallow clone. We use the git://
# url here because this computer (assuming it's new) does not have access to
# clone using its public key yet.
#
# Lastly, we only want to clone these if we haven't already installed our dotfiles.
# There are a few ways to do this, such as checking for the existence of a file,
# creating a file, checking the contents of a file, etc. Here we are just going to check
# and see if the `.gitconfig` file exists. That isn't created automatically with a new
# user, so it's a reasonable file to choose.
git "#{Chef::Config[:file_cache_path]}/dotfiles" do
  source 'git://github.com/krishnasrihari/dotfiles.git'
  user 'krishna'
  gid 'wheel'
  mode '0755'
  action :checkout
  depth 1
  not_if { ::File.exists?('/Users/krishna/.gitconfig') }
  notifies :run, 'execute[install dotfiles]'
end

# Run the dotfile rake task to install the files
gem 'rake'
execute 'install dotfiles' do
  cwd "#{Chef::Config[:file_cache_path]}/dotfiles"
  command 'rake install'
  action :nothing
end