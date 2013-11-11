require File.dirname(__FILE__) + "/cmd"

class Stencil
  class Branches
    class <<self
      
      @@branches = {}

      def read(path, type=:all)
        key = "#{type}:#{path}"

        if type == :all
          (read(path, :remote) + read(path, :local)).uniq
        elsif type == :remote && !@@branches[key]
          branches = Cmd.run path, 'git branch -a'
          @@branches[key] = branches.scan(/origin\/([\w-]+\b$)/).flatten.uniq
        elsif type == :remote
          @@branches[key]
        elsif !@@branches[key]
          branches = Cmd.run path, 'git branch'
          branches = branches.split(/[\s\*]+/)
          branches.delete ''
          branches.sort!
          @@branches[key] = branches
        else
          @@branches[key]
        end
      end
      
      def grouped(path)
        branches = (read(path) - [ 'master' ]).inject({}) do |hash, branch|
          branch.split('-').inject(hash) do |h, b|
            h[b] ||= {}
          end
          hash
        end
        { 'master' => branches }
      end
    end
  end
end