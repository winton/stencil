class Stencil
  class Msg
    class <<self
      
      def error(output)
        space
        puts "Oops: #{output}"
        exit
      end

      def space
        puts ''
      end
    end
  end
end