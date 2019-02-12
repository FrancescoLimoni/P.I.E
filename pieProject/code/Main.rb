$LOAD_PATH << '.'

require 'fox16'
require 'Canvas.rb'

require 'fox16'
 master

include Fox

class EditorWindow < FXMainWindow
  def initialize(app)
    super(app, "Pixel Image Editor", :width => 1080, :height => 720)
  end
  
  def create
    super
    show(PLACEMENT_SCREEN)
  end
end


if __FILE__ == $0
  FXApp.new do |app|
    editor_window = EditorWindow.new(app)
    draw = Canvas.new(editor_window, app, FRAME_THICK, 1000, 500, 100, 100, 0, 0, 0, 0)
    app.create
    app.run
  end
end
