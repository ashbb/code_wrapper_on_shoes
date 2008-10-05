# Code Wrapper on Shoes v0.2s
require Dir.pwd + '/formatter'

Shoes.app :title => 'CWoS', :width => 150, :height => 80 do
  extend Formatter
  
  background gradient bisque, sandybrown
  @msg = para strong('Code Wrapper on Shoes v0.2s'), :size => 8
  
  @img = image(Dir.pwd + '/cy.png', :left => 50, :top => 18).click do
    @msg.text = strong 'Yes, sir!'
    self.clipboard = replace(self.clipboard)
    @img.transform :center
    @a = animate(24) do |i|
      @img.rotate -15
      (@a.stop; @msg.text = strong('Code Wrapper on Shoes v0.2s')) if i > 22
    end
  end
end