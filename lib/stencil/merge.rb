class Stencil
  class Merge
    class <<self
      
      def project(name, path)
        template = Config.read[:projects][name][:template]
        branches = Config.read[:projects][name][:branches]
        if template
          template = Config.read[:templates][template.intern]
          if template && File.exists?(template[:path])
            origin = Cmd.run template[:path], "git remote show origin"
            origin = origin.match(/URL:\s+(\S+)/)[1]
            Msg.template_url origin
            Cmd.run path, "git remote rm template"
            Cmd.run path, "git remote add template #{origin}"
            branches = %w(master) if branches.empty?
            branches.each do |branch|
              Msg.merge_remote_branch branch
              Cmd.run path, "git pull template #{branch}"
            end
          else
            Msg.template_not_found template
            Msg.specify_template
          end
        else
          Msg.specify_template
        end
      end
      
      def template(path)
        Branches.grouped(path).each do |branches|
          branches.unshift('master')
          progressive(path, branches)
        end
        Cmd.run path, "git checkout master"
      end
      
      private
      
      def progressive(path, branches)
        merger = branches.shift
        mergee = branches.first
        if merger && mergee
          puts "Merging \"#{merger}\" into \"#{mergee}\""
          output = Cmd.run(path, "git checkout #{mergee} && git merge #{merger}")
          if output.downcase.include?('conflict')
            puts output
          else
            progressive(path, branches)
          end
        end
      end
    end
  end
end