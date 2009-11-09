class Stencil
  class Merge
    class <<self
      
      def project(name, path)
        template = Config.read[:projects][name][:template]
        branches = Config.read[:projects][name][:branches]
        if template
          template = Config.read[:templates][template.intern]
          if template && File.exists?(template[:path])
            origin = get_origin template[:path]
            Msg.template_url origin
            add_remote 'template', path, origin
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
      
      def upstream(name, commit, branches=[])
        project = Config.read[:projects][name]
        branch = Cmd.run(project[:path], "git branch").split
        branch = branch[branch.index('*') + 1]
        
        template = Config.read[:templates][project[:template].intern]
        path = template[:path]
        
        origin = get_origin project[:path]
        Msg.project_url origin
        add_remote 'project', path, origin
        Cmd.run path, "git fetch project"
        
        branches = %w(master) if branches.empty?
        branches.each do |branch|
          output = Cmd.run path, "git checkout #{branch}"
          Msg.error(output) if output.downcase.include?('error')
          Msg.cherry_pick branch, commit
          output = Cmd.run path, "git cherry-pick #{commit}"
          Msg.error(output) if output.downcase.include?('fatal')
        end
      end
      
      private
      
      def add_remote(name, path, url)
        if Cmd.run(path, "git remote").split.include?(name)
          Cmd.run path, "git remote rm #{name}"
        end
        Cmd.run path, "git remote add #{name} #{url}"
      end
      
      def get_origin(path)
        origin = Cmd.run path, "git remote show origin"
        origin.match(/URL:\s+(\S+)/)[1]
      end
      
      def progressive(path, branches)
        merger = branches.shift
        mergee = branches.first
        if merger && mergee
          puts "Merging \"#{merger}\" into \"#{mergee}\""
          output = Cmd.run path, "git checkout #{mergee}"
          Msg.error(output) if output.downcase.include?('error')
          output = Cmd.run path, "git merge #{merger}"
          Msg.error(output) if output.downcase.include?('conflict')
          progressive(path, branches)
        end
      end
    end
  end
end