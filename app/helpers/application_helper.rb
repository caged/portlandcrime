module ApplicationHelper
  def title(str)
    @title ||= "#{str} | Portland Crime"
  end
end
