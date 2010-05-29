require 'rubygems'
gem 'require'
require 'require'

Require do
  gem :require, '=0.2.7'
  gem(:rake, '=0.8.7') { require 'rake' }
  gem :rspec, '=1.3.0'
  
  gemspec do
    author 'Winton Welsh'
    email 'mail@wintoni.us'
    name 'stencil'
    homepage "http://github.com/winton/#{name}"
    summary "Project template manager"
    version '0.1.4'
  end
  
  rakefile do
    gem(:rake) { require 'rake/gempackagetask' }
    gem(:rspec) { require 'spec/rake/spectask' }
    require 'require/tasks'
  end
  
  spec_helper do
    require 'require/spec_helper'
    require 'lib/gem_template'
    require 'pp'
  end
end