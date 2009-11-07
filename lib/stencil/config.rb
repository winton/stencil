require 'yaml'

class Stencil
  class Config
    class <<self
      
      @@cache = nil
      @@path = File.expand_path('~/.stencil.yml')
      
      def create
        write(:projects => {}, :templates => {})
      end
      
      def read
        if @@cache
          @@cache
        elsif File.exists?(@@path)
          File.open(@@path, 'r') do |f|
            @@cache = YAML::load f
          end
        else
          create
          @@cache = read
        end
      end
      
      def update(hash)
        write read.deep_merge(hash)
      end
      
      def delete
        @@cache = nil
        File.unlink @@path
      end
      
      def exists?(type, name)
        read[type] &&
        (
          read[type][name.intern] ||
          (
            read[type][File.basename(name).intern] &&
            read[type][File.basename(name).intern][:path] == name
          )
        )
      end
      
      private
      
      def write(hash)
        @@cache = nil
        File.open(@@path, 'w') do |f|
          f.write YAML::dump(hash)
        end
      end
    end
  end
end