#
# Author:: Noah Kantrowitz <noah@opscode.com>
# Cookbook Name:: application_python
# Resource:: django
#
# Copyright:: 2011, Opscode, Inc <legal@opscode.com>
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

include Chef::Resource::ApplicationBase

attribute :database_master_role, :kind_of => [String, NilClass], :default => nil
attribute :packages, :kind_of => [Array, Hash], :default => []
attribute :requirements, :kind_of => [NilClass, String, FalseClass], :default => nil
attribute :legacy_database_settings, :kind_of => [TrueClass, FalseClass], :default => false
attribute :settings, :kind_of => Hash, :default => {}
# Actually defaults to "settings.py.erb", but nil means it wasn't set by the user
attribute :settings_template, :kind_of => [String, NilClass], :default => nil
attribute :local_settings_file, :kind_of => String, :default => 'local_settings.py'
attribute :debug, :kind_of => [TrueClass, FalseClass], :default => false
attribute :collectstatic, :kind_of => [TrueClass, FalseClass, String], :default => false
attribute :use_south, :kind_of => [TrueClass, FalseClass], :default => false

def local_settings_base
  ::File.basename(local_settings_file)
end

def virtualenv
  "#{path}/shared/env"
end

def database(db_name='default', &block)
  # add a new db to django settings
  # block args are passed through to settings.py.erb
  @databases ||= {}
  db ||= Mash.new
  db.update(options_block(&block))
  @databases[db_name] = db
  db
end

def databases
  @databases
end