# formatter.rb
def form1 str
  str ||= ''
  str.gsub!('<', '&lt;')
  str << "\n# CWoS v0.4 (#{PLATFORM})\n"
  "[code ruby]\n" << str << "[/code]\n"
end

def form2 str
  str ||= ''
  str.gsub!('<', '&lt;')
  flag = true
  formatted_line = ''
  str.each do |line|
    flag = false  if line.chomp == '[code ruby]'
    flag = true  if line.chomp == '[/code]'
    formatted_line << line
    ((formatted_line = formatted_line.chomp) << "<br>\n")  if flag
  end
  return formatted_line << "<br>\n<span style=\"color: rgb(51, 153, 51); font-style: italic;\"># CWoS v0.4 (#{PLATFORM})</span><br>\n"
end



