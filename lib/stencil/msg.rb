class Stencil
  class Msg
    class <<self
      
      def error(output)
        space
        puts "Oops: #{output}"
        exit
      end

      def merging_x_into_y(x, y)
        puts "Merging \"#{x}\" into \"#{y}\""
      end

      def space
        puts ''
      end
    end
  end
end