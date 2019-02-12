$LOAD_PATH << '.'

require 'fox16'
require 'BrushPanel.rb'

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
    BrushPanel.new(editor_window,LAYOUT_FIX_WIDTH | LAYOUT_FIX_HEIGHT,0,0,69,196)
    FXToolTip.new(app)
    app.create
    app.run
  end
end
