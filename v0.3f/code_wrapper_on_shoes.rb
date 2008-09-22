# Code Wrapper on Shoes v0.3f
require Dir.pwd + '/formatter'
require Dir.pwd + '/code_beautifier'

Shoes.app :title => 'CWoS', :width => 150, :height => 108 do
  extend Formatter
  
  App = "Code-Wrapper on Shoes"
  Version =  "v0.3f"
	background gradient bisque, sandybrown
	@msg = para strong("#{App} #{Version}"), :size => 8
  
	@img = image(Dir.pwd + '/cy.png', :left => 50, :top => 18).click do
		self.clipboard = replace(RBeautify.beautify_string(self.clipboard ||= ''))
    @msg.text = strong(['Hi, Enjoy? :-D', 'Uhhh spinning...', 'Hip, hip, hurray!'][rand(3)])
		@img.transform :center
		@a = animate(24) do |i|
			@img.rotate -15
			(@a.stop; @msg.text = strong("#{App} #{Version}")) if i > 22
		end
	end
	button("About", :left => 75, :top => 80) do
		a_s = "#{App}, #{Version}\n"
		a_s << "contains code by\nSatoshi Asakawa, Victor Goff, " 
		a_s << "Paul Lutus, Michael Uplawski.\n"
    a_s << "Creature named 'Cy' created by Anita Kuno.\n"
		a_s << "\n(c)2008, www.rubylearning.org\n"
		a_s << "(c)2008, Paul Lutus (www.arachnoid.com)\n"
    a_s << "\nSee license.txt\n"
		alert(a_s)
	end
end
