#
# Cookbook Name:: krishnanote
# Recipe:: default
#
# Copyright 2012, Krishna Srihari
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'krishnanote::packages'
include_recipe 'krishnanote::gits'
include_recipe 'krishnanote::dotfiles'