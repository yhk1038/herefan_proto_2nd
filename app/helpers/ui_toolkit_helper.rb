module UiToolkitHelper
    
    def hex_to_rgb input
        a = ( input.match /#(..?)(..?)(..?)/ )[1..3]
        a.map!{ |x| x + x } if input.size == 4
        "rgb(#{a[0].hex},#{a[1].hex},#{a[2].hex})"
    end

    def hex_to_rgba(input, opacity)
        a = ( input.match /#(..?)(..?)(..?)/ )[1..3]
        a.map!{ |x| x + x } if input.size == 4
        "rgba(#{a[0].hex},#{a[1].hex},#{a[2].hex}, #{opacity})"
    end
end
