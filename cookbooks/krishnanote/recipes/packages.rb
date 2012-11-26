#
# Cookbook Name:: Krishnanote
# Recipe:: packages
#
# Copyright 2012, Krishna Srihari
#
# All rights reserved - Do Not Redistribute
#
# Configures and installs the following packages using apt:
#   - aspell
#   - bash-completion
#   - elasticsearch
#   - erlang
#   - ghostscript
#   - git
#   - imagemagick
#   - jasper
#   - mongodb
#   - mysql
#   - node
#   - postgresql
#   - qt
#   - rabbitmq
#   - readline
#   - redis
#   - solr
#   - wget
#

# Include homebrew as the default package manager.
# (default is MacPorts)
include_recipe 'apt'

# Install each of the packages using the `package` resource
%w(aspell bash-completion elasticsearch erlang ghostscript git imagemagick jasper mongodb mysql node postgresql qt rabbitmq readline redis solr wget).each do |package|
  package package
end