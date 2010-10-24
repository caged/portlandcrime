class Class
  def add_concerns(*args)
    args.each { |a| require_dependency "#{name.underscore}/#{a}" }
  end
end