Dir["#{File.dirname(__FILE__)}/stencil/*.rb"].each do |path|
  require path
end

class Stencil
  
  def initialize(args)
    path = Dir.pwd
    name = File.basename(path).intern
    
    # If template, do a template merge
    if Config.exists?(:templates, path)
      Merge.template(path)
    
    # If project
    elsif Config.exists?(:projects, path)
      
      # If upstream commit, merge upstream
      if args.first == '^'
        Merge.upstream *args[1..-1].unshift(name) and return
      
      # If template specified, update config
      elsif args.first
        Config.update(:projects => {
          name => {
            :template => args.shift,
            :branches => args
          }
        })
        
      end
      
      # Do a project merge
      Merge.project(name, path)
    
    # If not configured
    else
      
      # Update config
      Msg.is_template_or_project?(name)
      Config.update((STDIN.gets[0..0].downcase == 't' ? :templates : :projects) => {
        name => { :path => path }
      })

      # Re-run
      initialize args
      
    end
  end
end