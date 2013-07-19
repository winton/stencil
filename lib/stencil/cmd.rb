class Stencil
  class Cmd
    class <<self
      
      def run(path, cmd=nil)
        if cmd.nil?
          cmd, path = path, cmd
        else
          path = "cd #{path} && "
        end
        
        output = `#{[ path, cmd ].compact.join} 2>&1`

        unless $?.success?
          Msg.error "#{cmd}\n\n#{output}"
        end

        output
      end
    end
  end
end