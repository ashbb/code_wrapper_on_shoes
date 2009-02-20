# formatter.rb

def form(str, mode)
  str.gsub!('<', '&lt;')

  str << "\n# CWoS v0.4c (#{PLATFORM})\n"
  "[code #{mode}]\n" << str << "[/code]\n"
end

