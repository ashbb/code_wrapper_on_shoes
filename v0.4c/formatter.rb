# formatter.rb

# form(txt) => [code ruby]
# form(txt, false) => [code text]
def form str = '', ruby_code = true
  str.gsub!('<', '&lt;')

  str << "\n# CWoS v0.4c (#{PLATFORM})\n"
  "[code #{ruby_code ? 'ruby' : 'text'}]\n" << str << "[/code]\n"
end

