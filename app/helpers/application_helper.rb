module ApplicationHelper
  def title(str)
    @title ||= "#{str} | Portland Crime"
  end
  
  # Determines selected nav
  # 
  # Examples:
  # selected_class(:crimes)
  # selected_class(:crimes, :show)
  # selected_class([:crimes, :offenses])
  # selected_class([[:crimes, :show], [:offenses, :index]])
  def selected_class(nav)
    klass = nil  
    begin
      mappings = {
        :home   => [:crimes, [:offenses, :show]],
        :trends => [:trends],
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
      
        logger.info "current_page?(#{opts})"
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
