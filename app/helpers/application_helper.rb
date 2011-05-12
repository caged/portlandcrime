module ApplicationHelper
  def title(str)
    @title ||= "#{str} | Portland Crime"
  end
  
  def keywords(*str)
    @keywords = str.join(' ')
  end
  
  # Determines selected nav.  I kind of hate this.
  # 
  # Examples:
  # selected_class(:crimes)
  # selected_class(:crimes, :show)
  # selected_class([:crimes, :offenses])
  # selected_class([[:crimes, :show], [:offenses, :index]])
  def selected_class(nav)
    return ' selected' if nav == :home && request.path == '/'
    
    klass = nil  
    begin
      mappings = {
        :home   => [:crimes, [:offenses, :show]],
        :trends => [[:trends, :index]],
        :neighborhoods => [[:neighborhoods, :index], [:neighborhoods, :show]],
        :transit => [[:routes, :index]],
        :about  => [[:site, :about]]
      }
    
      mappings[nav].each do |val|
        if val.is_a?(Array)
          c = val[0] 
          a = val[1]
        else
          c = val
          a = nil
        end

        opts = {:controller => c}
        opts.merge!(:action => a) unless a.nil?
        
        if current_page?(opts) 
          klass = ' selected'
          break
        end
      end
    rescue 
    end
        
    klass
  end
end
