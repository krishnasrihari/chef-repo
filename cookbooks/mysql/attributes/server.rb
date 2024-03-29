#
# Cookbook Name:: mysql
# Attributes:: server
#
# Copyright 2008-2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['mysql']['bind_address']               = attribute?('cloud') ? cloud['local_ipv4'] : ipaddress
default['mysql']['port']                       = 3306

case node["platform_family"]
when "debian"
  default['mysql']['server']['packages']      = %w{mysql-server}
  default['mysql']['service_name']            = "mysql"
  default['mysql']['basedir']                 = "/usr"
  default['mysql']['data_dir']                = "/var/lib/mysql"
  default['mysql']['root_group']              = "root"
  default['mysql']['mysqladmin_bin']          = "/usr/bin/mysqladmin"
  default['mysql']['mysql_bin']               = "/usr/bin/mysql"

  set['mysql']['conf_dir']                    = '/etc/mysql'
  set['mysql']['confd_dir']                   = '/etc/mysql/conf.d'
  set['mysql']['socket']                      = "/var/run/mysqld/mysqld.sock"
  set['mysql']['pid_file']                    = "/var/run/mysqld/mysqld.pid"
  set['mysql']['old_passwords']               = 0
  set['mysql']['grants_path']                 = "/etc/mysql/grants.sql"
when "rhel", "fedora", "suse",
  default['mysql']['server']['packages']      = %w{mysql-server}
  default['mysql']['service_name']            = "mysqld"
  default['mysql']['basedir']                 = "/usr"
  default['mysql']['data_dir']                = "/var/lib/mysql"
  default['mysql']['root_group']              = "root"
  default['mysql']['mysqladmin_bin']          = "/usr/bin/mysqladmin"
  default['mysql']['mysql_bin']               = "/usr/bin/mysql"

  set['mysql']['conf_dir']                    = '/etc'
  set['mysql']['confd_dir']                   = '/etc/mysql/conf.d'
  set['mysql']['socket']                      = "/var/lib/mysql/mysql.sock"
  set['mysql']['pid_file']                    = "/var/run/mysqld/mysqld.pid"
  set['mysql']['old_passwords']               = 1
  set['mysql']['grants_path']                 = "/etc/mysql_grants.sql"
  # RHEL/CentOS mysql package does not support this option.
  set['mysql']['tunable']['innodb_adaptive_flushing'] = false
when "freebsd"
  default['mysql']['server']['packages']      = %w{mysql55-server}
  default['mysql']['service_name']            = "mysql-server"
  default['mysql']['basedir']                 = "/usr/local"
  default['mysql']['data_dir']                = "/var/db/mysql"
  default['mysql']['root_group']              = "wheel"
  default['mysql']['mysqladmin_bin']          = "/usr/local/bin/mysqladmin"
  default['mysql']['mysql_bin']               = "/usr/local/bin/mysql"

  set['mysql']['conf_dir']                    = '/usr/local/etc'
  set['mysql']['confd_dir']                   = '/usr/local/etc/mysql/conf.d'
  set['mysql']['socket']                      = "/tmp/mysqld.sock"
  set['mysql']['pid_file']                    = "/var/run/mysqld/mysqld.pid"
  set['mysql']['old_passwords']               = 0
  set['mysql']['grants_path']                 = "/var/db/mysql/grants.sql"
when "windows"
  default['mysql']['server']['packages']      = ["MySQL Server 5.5"]
  default['mysql']['version']                 = '5.5.21'
  default['mysql']['arch']                    = 'win32'
  default['mysql']['package_file']            = "mysql-#{mysql['version']}-#{mysql['arch']}.msi"
  default['mysql']['url']                     = "http://www.mysql.com/get/Downloads/MySQL-5.5/#{mysql['package_file']}/from/http://mysql.mirrors.pair.com/"

  default['mysql']['service_name']            = "mysql"
  default['mysql']['basedir']                 = "#{ENV['SYSTEMDRIVE']}\\Program Files (x86)\\MySQL\\#{mysql['server']['packages'].first}"
  default['mysql']['data_dir']                = "#{mysql['basedir']}\\Data"
  default['mysql']['bin_dir']                 = "#{mysql['basedir']}\\bin"
  default['mysql']['mysqladmin_bin']          = "#{mysql['bin_dir']}\\mysqladmin"
  default['mysql']['mysql_bin']               = "#{mysql['bin_dir']}\\mysql"

  default['mysql']['conf_dir']                = "#{mysql['basedir']}"
  default['mysql']['old_passwords']           = 0
  default['mysql']['grants_path']             = "#{mysql['conf_dir']}\\grants.sql"
when "mac_os_x"
  default['mysql']['server']['packages']      = %w{mysql}
  default['mysql']['basedir']                 = "/usr/local/Cellar"
  default['mysql']['data_dir']                = "/usr/local/var/mysql"
  default['mysql']['root_group']              = "admin"
  default['mysql']['mysqladmin_bin']          = "/usr/local/bin/mysqladmin"
  default['mysql']['mysql_bin']               = "/usr/local/bin/mysql"
else
  default['mysql']['server']['packages']      = %w{mysql-server}
  default['mysql']['service_name']            = "mysql"
  default['mysql']['basedir']                 = "/usr"
  default['mysql']['data_dir']                = "/var/lib/mysql"
  default['mysql']['root_group']              = "root"
  default['mysql']['mysqladmin_bin']          = "/usr/bin/mysqladmin"
  default['mysql']['mysql_bin']               = "/usr/bin/mysql"

  set['mysql']['conf_dir']                    = '/etc/mysql'
  set['mysql']['confd_dir']                   = '/etc/mysql/conf.d'
  set['mysql']['socket']                      = "/var/run/mysqld/mysqld.sock"
  set['mysql']['pid_file']                    = "/var/run/mysqld/mysqld.pid"
  set['mysql']['old_passwords']               = 0
  set['mysql']['grants_path']                 = "/etc/mysql/grants.sql"
end

if attribute?('ec2')
  default['mysql']['ec2_path']    = "/mnt/mysql"
  default['mysql']['ebs_vol_dev'] = "/dev/sdi"
  default['mysql']['ebs_vol_size'] = 50
end

default['mysql']['reload_action'] = "restart" # or "reload" or "none"

default['mysql']['use_upstart'] = node.platform?("ubuntu") && node['platform_version'].to_f >= 10.04

default['mysql']['auto-increment-increment']        = 1
default['mysql']['auto-increment-offset']           = 1

default['mysql']['allow_remote_root']               = false
default['mysql']['tunable']['back_log']             = "128"
default['mysql']['tunable']['key_buffer']           = "256M"
default['mysql']['tunable']['max_allowed_packet']   = "16M"
default['mysql']['tunable']['max_connections']      = "800"
default['mysql']['tunable']['max_heap_table_size']  = "32M"
default['mysql']['tunable']['myisam_recover']       = "BACKUP"
default['mysql']['tunable']['net_read_timeout']     = "30"
default['mysql']['tunable']['net_write_timeout']    = "30"
default['mysql']['tunable']['table_cache']          = "128"
default['mysql']['tunable']['table_open_cache']     = "128"
default['mysql']['tunable']['thread_cache']         = "128"
default['mysql']['tunable']['thread_cache_size']    = 8
default['mysql']['tunable']['thread_concurrency']   = 10
default['mysql']['tunable']['thread_stack']         = "256K"
default['mysql']['tunable']['wait_timeout']         = "180"

default['mysql']['tunable']['log_bin']                         = nil
default['mysql']['tunable']['log_bin_trust_function_creators'] = false
default['mysql']['tunable']['relay_log']                       =  nil
default['mysql']['tunable']['log_slave_updates']               = false
default['mysql']['tunable']['sync_binlog']                     = 0
default['mysql']['tunable']['skip_slave_start']                = false

default['mysql']['tunable']['log_error']                       = nil
default['mysql']['tunable']['log_queries_not_using_index']     = true
default['mysql']['tunable']['log_bin_trust_function_creators'] = false

default['mysql']['tunable']['innodb_buffer_pool_size']         = "128M"
default['mysql']['tunable']['innodb_log_file_size']            = "5M"
default['mysql']['tunable']['innodb_additional_mem_pool_size'] = "8M"
default['mysql']['tunable']['innodb_data_file_path']           = "ibdata1:10M:autoextend"
default['mysql']['tunable']['innodb_flush_log_at_trx_commit']  = "1"
default['mysql']['tunable']['innodb_flush_method']             = false
default['mysql']['tunable']['innodb_log_buffer_size']          = "8M"

default['mysql']['tunable']['query_cache_limit']    = "1M"
default['mysql']['tunable']['query_cache_size']     = "16M"

default['mysql']['tunable']['log_slow_queries']     = "/var/log/mysql/slow.log"
default['mysql']['tunable']['long_query_time']      = 2

default['mysql']['tunable']['expire_logs_days']     = 10
default['mysql']['tunable']['max_binlog_size']      = "100M"
