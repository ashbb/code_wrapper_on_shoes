# formatter.rb
def form1 str = ''
  str.gsub!('<', '&lt;')
  str << "\n# CWoS v0.4b (#{PLATFORM})\n"
  "[code ruby]\n" << str << "[/code]\n"
end

def form2 str = ''
  str.gsub!('<', '&lt;')
  str << "\n# CWoS v0.4b (#{PLATFORM})\n"
  "[code text]\n" << str << "[/code]\n"
end



