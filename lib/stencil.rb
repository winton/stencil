$:.unshift File.dirname(__FILE__)

require 'stencil/branches'
require 'stencil/cmd'
require 'stencil/merge'
require 'stencil/msg'

class Stencil
  
  def initialize(args=[])
    path = Dir.pwd
    Merge.template(path, args.include?('push'))
  end
end