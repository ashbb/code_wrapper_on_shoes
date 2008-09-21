module Formatter
  def replace str
    str ||= ''
    str.gsub!('<', '&lt;')
    str << "\n# CWoS v0.3f (#{PLATFORM})\n"
    "[code ruby]\n" << str << "[/code]\n"
  end
end
