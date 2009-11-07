class Stencil
  class Cmd
    class <<self
      
      def run(path, cmd=nil)
        if cmd.nil?
          cmd, path = path, cmd
        else
          path = "cd #{path} && "
        end
        `#{[ path, cmd ].compact.join}`
      end
    end
  end
end