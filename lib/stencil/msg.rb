class Stencil
  class Msg
    class <<self
      
      def is_template_or_project?(name)
        puts "Is \"#{name}\" a template or a project?"
      end
      
      def merge_remote_branch(branch)
        puts "Merging remote branch \"#{branch}\""
      end
      
      def specify_template
        puts "Please tell stencil what template you want to receive updates from:"
        puts "  stencil TEMPLATE [BRANCH BRANCH ...]"
      end
      
      def template_not_found(template)
        puts "Template \"#{template}\" not found."
      end
      
      def template_url(url)
        puts "Found template URL: #{url}"
      end
    end
  end
end