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

      def checkout(path, branch)
        locals  = Branches.read(path, :local) + [ 'master' ]
        remotes = Branches.read(path, :remote)

        if locals.include?(branch)
          Cmd.run(path, "git checkout #{branch}")
        elsif remotes.include?(branch)
          Cmd.run(path, "git checkout -t origin/#{branch}")
        end
      end
      
      def progressive_merge(path, merger, mergees, push)
        branches = Branches.read(path)
        return unless branches.include?(merger) || merger == 'master'

        unless mergees.empty?
          checkout(path, merger)
          Cmd.run(path, "git pull origin #{merger}")
        end

        mergees = mergees.sort_by { |k, v| k }
        mergees.each do |(mergee, mergee_mergees)|
          mergee = "#{merger}-#{mergee}" unless merger == 'master'

          next unless branches.include?(mergee)

          checkout(path, mergee)
          Cmd.run(path, "git merge #{merger}")
          Cmd.run(path, "git push origin #{mergee}") if push
          
          progressive_merge(path, mergee, mergee_mergees, push)
        end
      end
    end
  end
end