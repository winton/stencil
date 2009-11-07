require File.dirname(__FILE__) + "/cmd"

class Stencil
  class Branches
    class <<self
      
      def read(path)
        branches = Cmd.run path, 'git branch'
        branches = branches.split(/\s+/)
        branches.delete '*'
        branches.delete 'master'
        branches
      end
      
      def grouped(path)
        groups, ignore = [], []
        branches = read(path).sort { |a, b| a.length <=> b.length }
        branches.each do |branch|
          next if ignore.include?(branch)
          groups << [ branch ] + group(branches, branch)
          ignore += groups.last
        end
        groups
      end
      
      private
      
      def group(branches, branch)
        branches.select do |b|
          b != branch && b[0..branch.length-1] == branch
        end
      end
    end
  end
end