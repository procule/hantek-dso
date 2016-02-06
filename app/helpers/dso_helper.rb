module DsoHelper
  def safe_html h
    #coder = HTMLEntities.new
    s = ActiveSupport::SafeBuffer.new h
    #coder.decode(s.squeeze.gsub(/\e\[(\d+)(;\d+)*m/, ''))
  end

end
