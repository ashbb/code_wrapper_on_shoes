# Code Wrapper on Shoes v0.4b
Revision = 'Code Wrapper on Shoes v0.4b'
CopyRight =<<EOS
#{Revision}
contains code by
Satoshi Asakawa, Victor Goff,
Paul Lutus, Michael Uplawski.
Creature named 'Cy' created by Anita Kuno.
(c)2008, www.rubylearning.org
(c)2008, Paul Lutus (www.arachnoid.com)
EOS

$txt = ''

Shoes.app :title => 'CWoS', :width => 150, :height => 80 do
  require 'formatter'
  require 'code_beautifier'
  style Para, :size => 8
  
  r1 = rect :left => 0, :top => 63, :width => 20, :height => 15
  r2 = rect :left => 30, :top => 63, :width => 20, :height => 15
	background greenyellow..salmon
	msg = para strong Revision

  opt1 = para 'on', :left => 0, :top => 60, :stroke => blue
  r1.click{opt1.text = opt1.text == 'on' ? 'off' : 'on'}
  
  opt2 = para 'off', :left => 30, :top => 60, :stroke => red
  r2.click{opt2.text = opt2.text == 'on' ? 'off' : 'on'}
  
  para link('OW', :stroke => white){
      @win = dialog(:title => 'clipboard'){} unless Shoes.APPS.to_s.include? 'clipboard'
      @win.clear
      @win.edit_box $txt, :width => 1.0, :height => 1.0
    }, :left => 100, :top => 60
  
	para link('CR', :stroke => white){alert(CopyRight)}, :left => 130, :top => 60
  
	img = image('cy.png', :left => 50, :top => 18).click do
    txt = opt2.text == 'on' ? RBeautify.beautify_string(self.clipboard ||= '') : self.clipboard
		self.clipboard = $txt = opt1.text == 'on' ? form1(txt) : form2(txt)
    msg.text = strong(['Hi, Enjoy? :-D', 'Yes,sir!', 'Hip, hip, hurray!'][rand(3)])
		img.transform :center
		a = animate(24) do |i|
			img.rotate -15
			(a.stop; msg.text = strong(Revision)) if i > 22
		end
	end
end
