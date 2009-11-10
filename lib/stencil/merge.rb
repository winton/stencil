class Stencil
  class Merge
    class <<self
      
      def project(name, path)
        template = Config.read[:projects][name][:template]
        branches = Config.read[:projects][name][:branches]
        Msg.error_specify_template unless template
        template = Config.read[:templates][template.intern]
        if template && File.exists?(template[:path])
          
          # Add remote template to project
          origin = get_origin template[:path]
          Msg.template_url origin
          add_remote 'template', path, origin
          
          # Pull template into master if no branches specified
          branches = %w(master) if branches.empty?
          
          # Pull template into each branch
          branches.each do |branch|
            Msg.merge_remote_branch branch
            Cmd.run path, "git pull template #{branch}"
          end
        else
          Msg.template_not_found template
          Msg.error_specify_template
        end
      end
      
      def template(path, push)
        Branches.grouped(path).each do |branches|
          branches.unshift('master')
          progressive(path, branches, push)
        end
        Cmd.run path, "git checkout master"
      end
      
      def upstream(name, commit=nil, branches=[])
        # Project variables
        project = Config.read[:projects][name]
        branch = Cmd.run(project[:path], "git branch").split
        branch = branch[branch.index('*') + 1]
        
        # Template variables
        template = Config.read[:templates][project[:template].intern]
        path = template[:path]
        
        # Add remote project to template and fetch
        origin = get_origin project[:path]
        Msg.project_url origin
        add_remote 'project', path, origin
        Cmd.run path, "git fetch project"
        
        # Get last commit if none specified
        unless commit
          cmd = "git log HEAD~1..HEAD --pretty=format:'%H'"
          commit = Cmd.run(template[:path], cmd).strip
        end
        
        # Cherry pick into master if no branches specified
        branches = %w(master) if branches.empty?
        
        # Cherry pick commit into branches
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
      
      def progressive(path, branches, push)
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
          progressive(path, branches, push)
        end
      end
    end
  end
end