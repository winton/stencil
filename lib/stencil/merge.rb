class Stencil
  class Merge
    class <<self
      
      def template(path, push)
        Branches.grouped(path).each do |branches|
          branches.unshift('master')
          progressive_merge(path, branches, push)
        end
        
        Cmd.run(path, "git checkout master")
      end
      
      private
      
      def progressive_merge(path, branches, push)
        merger = branches.shift
        mergee = branches.first

        if merger && mergee
          unless merger.empty? || mergee.empty?
            output = Cmd.run path, "git checkout #{mergee}"
            
            Msg.error(output) if output.downcase.include?('error')
            Msg.merging_x_into_y merger, mergee
            
            output = Cmd.run path, "git merge #{merger}"
            
            Msg.error(output) if output.downcase.include?('conflict')
            Cmd.run(path, "git push origin #{mergee}") if push
          end
          
          progressive_merge(path, branches, push)
        end
      end
    end
  end
end