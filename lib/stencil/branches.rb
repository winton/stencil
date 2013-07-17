require File.dirname(__FILE__) + "/cmd"

class Stencil
  class Branches
    class <<self
      
      def read(path)
        branches = Cmd.run path, 'git branch'
        branches = branches.split(/[\s\*]+/)
        branches.delete 'master'
        branches.delete ''
        branches.sort
      end
      
      def grouped(path)
        branches = read(path).inject({}) do |hash, branch|
          branch.split('-').inject(hash) do |hash, branch|
            hash[branch] ||= {}
          end
          hash
        end
        { 'master' => branches }
      end
    end
  end
end