module NeighborhoodsHelper
  def percent_change_from(from, to)
    direction = nil
    
    change = "%.1f" % (100 - ([from, to].min / [from, to].max * 100.0) rescue 0)
    klass = ""
    glyph = "_"
    
    if change != '0.0'
      if change != 'NaN'
        if to < from 
          klass = 'rise'
          glyph = '{'
        elsif change != '0.0'
          klass = 'fall'
          glyph = '}'
        end
      else
        change = 0.0
      end
    end
  
    span = content_tag(:span, glyph, :class => "#{klass} glyph")
    span + ' ' + content_tag(:span, "#{direction}#{change}%", :class => "#{klass} percent")
  end
end
