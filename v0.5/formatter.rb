# formatter.rb

def form(str, mode)
  str.gsub!('<', '&lt;')

  str << "\n# CWoS v0.5 (#{PLATFORM})\n"
  "[code #{mode}]\n" << str << "[/code]\n"
end
