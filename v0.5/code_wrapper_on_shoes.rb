# Code Wrapper on Shoes v0.5
Revision = 'Code Wrapper on Shoes v0.5'
CopyRight =<<EOS
#{Revision}
contains code by
Satoshi Asakawa, Victor Goff,
Mareike Hybsier, Paul Lutus,
Michael Uplawski and Michael Kohl.

Creature named 'Cy' created by Anita Kuno.

(c)2008-2009, RubyLearning (www.rubylearning.org)
(c)2008, Paul Lutus (www.arachnoid.com)
EOS

HELP = ["Use or not use Ruby\nSyntax Highlight.",
        "Use or not use RBeautify\nwritten by Paul Lutus.",
        "Click the green creature\nto wrap the Ruby code.\nHis name is Cy.", 
        "Open dialog window\nwhich shows clipboard data.", 
        "Open copyright window.", 
        "Alt+o: select a file which data is copied straight to the clipboard"]

Shoes.app :title => 'CWoS', :width => 155, :height => 80, :resizable => false do
  require 'formatter'
  require 'code_beautifier'

  @txt = ''

  style Para, :size => 8
  style LinkHover, :fill => nil
  
  r1 = rect :left => 0, :top => 63, :width => 20, :height => 15
  r2 = rect :left => 30, :top => 63, :width => 20, :height => 15
  
  background greenyellow..salmon
  msg = para strong Revision

  opt1 = para 'Ruby', :left => 0, :top => 60, :stroke => blue
  r1.click{opt1.text = opt1.text == 'Ruby' ? 'Text' : 'Ruby'}
  
  opt2 = para 'off', :left => 30, :top => 60, :stroke => red
  r2.click{opt2.text = opt2.text == 'on' ? 'off' : 'on'}
  
  para (l1 = link('OW', :stroke => white){
    @win = dialog(:title => 'clipboard'){} unless Shoes.APPS.to_s.include? 'clipboard'
    @win.clear
    @win.edit_box @txt, :width => 1.0, :height => 1.0
  }), :left => 100, :top => 60
  
  para (l2 = link('CR', :stroke => white){alert(CopyRight)}), :left => 130, :top => 60
  img = image('cy.png', :left => 50, :top => 18).click do
    txt = opt2.text == 'on' ? RBeautify.beautify_string(self.clipboard ||= '') : self.clipboard
    self.clipboard = @txt = form(txt, opt1.text.downcase!)
    msg.text = strong(['Hi, enjoy? :-D', 'Yes, sir!', 'Hip, hip, hurray!'][rand(3)])
    img.transform :center
    a = animate(24) do |i|
      img.rotate -15
      (a.stop; msg.text = strong(Revision)) if i > 22
    end
  end

  keypress do |k|
    if k == :alt_o
      filename = ask_open_file 
      self.clipboard = File.read(filename)
    end
  end
  
  @help = flow do
    rect 0, 0, 140, 55, :fill => rgb(50, 205, 50, 0.5), :stroke => rgb(50, 205, 50, 0.5), :curve => 10
    @msg = para '', :stroke => white, :weight => 'bold'
  end.hide
  @help.move 10, 10
  
  [r1, r2, img, l1, l2].each_with_index do |e, i|
    e.hover do
      @msg.text = HELP[i]
      @help.show
      timer(10){@help.hide}
    end
    e.leave{@help.hide}
  end
end

