class Stencil
  class Msg
    class <<self
      
      def cherry_pick(branch, commit)
        space
        puts "Cherry picked #{commit} to \"#{branch}\""
      end
      
      def error(output)
        space
        puts "Oops:\n#{output}"
        exit
      end
      
      def is_template_or_project?(name)
        space
        puts "Is \"#{name}\" a template or a project?"
      end
      
      def merge_remote_branch(branch)
        space
        puts "Merging remote branch \"#{branch}\""
      end
      
      def project_url(url)
        space
        puts "Found project URL: #{url}"
      end
      
      def space
        puts ''
      end
      
      def specify_template
        space
        puts "Please tell stencil what template you want to receive updates from:"
        puts "  stencil TEMPLATE [BRANCH BRANCH ...]"
      end
      
      def template_not_found(template)
        space
        puts "Template \"#{template}\" not found."
      end
      
      def template_url(url)
        space
        puts "Found template URL: #{url}"
      end
    end
  end
end