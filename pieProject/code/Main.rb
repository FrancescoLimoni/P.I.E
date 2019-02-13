$LOAD_PATH << '.'

require 'Canvas.rb'
require 'BrushPanel.rb'
require 'Menu'
require 'fox16'
require 'ColorPanel.rb'

include Fox

class EditorWindow < FXMainWindow
  def initialize(app)
    super(app, "Pixel Image Editor", :width => 500, :height => 500)
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
    brush_window = BrushPanel.new(editor_window, LAYOUT_FIX_WIDTH | LAYOUT_FIX_HEIGHT, 0, 0, 69,196)
    color_window = ColorPanel.new(editor_window, LAYOUT_FIX_WIDTH | LAYOUT_FIX_HEIGHT | LAYOUT_CENTER_X , 0, 0, 176, 55)
    FXToolTip.new(app)
    app.create
    app.run
  end
end
