

$LOAD_PATH << '.'

require 'Canvas.rb'
require 'BrushPanel.rb'
require 'Menu'
require 'fox16'
require 'ColorPanel.rb'
require 'FloatingToolBar.rb'
require 'layerPanel.rb'

include Fox

class EditorWindow < FXMainWindow
  def initialize(app,logo)
    super(app, "LayerPanel", logo, logo, :width => 700, :height => 700)
    #addMenuBar
    floating_menu_bar = FloatingToolBar.new(self,LAYOUT_SIDE_TOP,LAYOUT_FILL_X,0,0)
    menuBar = MenuBar.new(app, floating_menu_bar.getToolBar, LAYOUT_SIDE_TOP , LAYOUT_FILL_X)
  end
  
  def create
    super
    show(PLACEMENT_SCREEN)
  end

end


if __FILE__ == $0
  FXApp.new do |app|

    #load pie icon
    icon = nil
    File.open("icons/pie.png", "rb") do |io|
      icon = FXPNGIcon.new(app, io.read)
    end
    icon

     #load pie icon as a splash
     iconSplash = nil
     File.open("icons/pie.png", "rb") do |io|
       iconSplash = FXPNGImage.new(app, io.read)
     end
     iconSplash

     

    #call editor_window constructor
    editor_window = EditorWindow.new(app,icon)
    editor_window.backColor = "Gray20"

    #adding floating ui to this brush_tool_bar
    brush_tool_bar = FloatingToolBar.new(editor_window,LAYOUT_SIDE_LEFT,0,0,0)

   #adding floating ui to layerPanel
    layer_tool_bar = FloatingToolBar.new(editor_window,LAYOUT_SIDE_RIGHT,0,0,0)

    #adding floating ui to color_window
    color_tool_bar = FloatingToolBar.new(editor_window,LAYOUT_SIDE_BOTTOM,LAYOUT_CENTER_X,0,0)
    #adding empty dock for all toolbar objects
    color_tool_bar.addDock(LAYOUT_SIDE_RIGHT,0,0,0)

    brush_window = BrushPanel.new(brush_tool_bar.getToolBar,LAYOUT_FIX_WIDTH | LAYOUT_FIX_HEIGHT,0,0,69,196)
    brush_window.backColor = "Gray69"
    canvas_window = Canvas.new(editor_window, LAYOUT_SIDE_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y, 0, 0, 0, 0, 0, 0, 0, 0)

    color_window = ColorPanel.new(color_tool_bar.getToolBar, LAYOUT_FIX_WIDTH | LAYOUT_FIX_HEIGHT | LAYOUT_CENTER_X , 0, 0, 176, 55)
    color_window.backColor = "Gray69"
    
    layerPanel = LayerPanel.new(layer_tool_bar.getToolBar, LAYOUT_FIX_WIDTH | LAYOUT_FIX_HEIGHT | LAYOUT_SIDE_BOTTOM | LAYOUT_RIGHT, 0,0, 161, 120)
    layerPanel.backColor = "Gray69"

    FXToolTip.new(app)
    app.create
    app.run
  end
end