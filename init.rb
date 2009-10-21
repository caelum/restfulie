require File.join(File.dirname(__FILE__), 'lib', 'restfulie')
ActiveRecord::Base.send(:include, Restfulie)