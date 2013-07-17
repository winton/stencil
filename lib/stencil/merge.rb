class Stencil
  class Merge
    class <<self
      
      def template(path, push)
        Cmd.run(path, "git fetch --all")

        Branches.grouped(path).each do |merger, mergees|
          progressive_merge(path, merger, mergees, push)
        end
        
        Cmd.run(path, "git checkout master")
      end
      
      private
      
      def progressive_merge(path, merger, mergees, push)
        unless mergees.empty?
          Cmd.run(path, "git checkout #{merger}")
          Cmd.run(path, "git pull origin #{merger}")
        end

        mergees.each do |mergee, mergee_mergees|
          mergee = "#{merger}-#{mergee}" unless merger == 'master'
          Cmd.run(path, "git checkout #{mergee}")
          Cmd.run(path, "git merge #{merger}")
          Cmd.run(path, "git push origin #{mergee}") if push
          progressive_merge(path, mergee, mergee_mergees, push)
        end
      end
    end
  end
end