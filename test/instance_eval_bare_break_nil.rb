class Box
  def initialize; @v = 10; end
end
events = []
result = Box.new.instance_eval do
  begin
    raise "inner"
  rescue
    begin
      break
    ensure
      events << :ensure
    end
  end
  @v
end
p [result, events]

