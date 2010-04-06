# formatter.rb

def form(str, mode)
  str.gsub!('<', '&lt;')

  str << "\n# CWoS v0.5a (#{RUBY_PLATFORM})\n"
  "[code #{mode}]\n" << str << "[/code]\n"
end
