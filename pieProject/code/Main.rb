
$LOAD_PATH << '.'

require 'Canvas.rb'
require 'BrushPanel.rb'
require 'Menu'
require 'fox16'
require 'ColorPanel.rb'
require 'FloatingToolBar.rb'

include Fox

class EditorWindow < FXMainWindow
  def initialize(app)
    super(app, "Pixel Image Editor", :width => 700, :height => 700)
    #addMenuBar
    menuBar = MenuBar.new(self, LAYOUT_SIDE_TOP , LAYOUT_FILL_X)
  end
  
  def create
    super
    show(PLACEMENT_SCREEN)
  end
end


if __FILE__ == $0
  FXApp.new do |app|

    editor_window = EditorWindow.new(app)
    #adding floating ui to this Window
    tool_bar = FloatingToolBar.new(editor_window,LAYOUT_SIDE_LEFT,0,0,0)

    brush_window = BrushPanel.new(tool_bar.getToolBar,LAYOUT_FIX_WIDTH | LAYOUT_FIX_HEIGHT,0,0,69,196)
    draw = Canvas.new(editor_window, app, FRAME_THICK| LAYOUT_CENTER_X || LAYOUT_CENTER_Y, 1000, 200, 250, 250, 0, 0, 0, 0)
    color_window = ColorPanel.new(editor_window, LAYOUT_FIX_WIDTH | LAYOUT_FIX_HEIGHT | LAYOUT_CENTER_X , 0, 0, 176, 55)
    FXToolTip.new(app)
    app.create
    app.run
  end
end

