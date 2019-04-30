$LOAD_PATH << '.'

require 'Canvas.rb'
require 'BrushPanel.rb'
require 'Menu'
require 'fox16'
require 'ColorPanel.rb'
require 'FloatingToolBar.rb'
require 'layerPanel.rb'
require 'SplashScreen.rb'
require 'Color.rb'
require 'launchy'

include Fox

class EditorWindow < FXMainWindow
  def initialize(app,logo,w,h)
    super(app, "PIE", logo, logo, :width => w, :height => h)
    #addMenuBar
    floating_menu_bar = FloatingToolBar.new(self,LAYOUT_SIDE_TOP|LAYOUT_FILL_X)
    @menuBar = MenuBar.new(app, floating_menu_bar.getToolBar, LAYOUT_SIDE_TOP , LAYOUT_FILL_X)
  end
  
  def create
    super
    show(PLACEMENT_SCREEN)
  end

  #add friend funtion from splashscreen to menuBar
  def editMenuBar(splashScreen)
    puts 'creating new project'
    @menuBar.splashScreenFriendfunction(splashScreen)
  end
  def canvaFriend(canvas)
    @menuBar.canvasSaveFriendfunction(canvas)
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

    #call editor_window constructor
    editor_window = EditorWindow.new(app,icon,400,400)
    editor_window.backColor = "Gray20"
    
    #groupBoxV = FXGroupBox.new(packer, nil, :opts => FRAME_RIDGE | GROUPBOX_NORMAL)
    #rightVFrame = FXHorizontalFrame.new(groupBoxV) 
    
    #create a splash screen object with editor_window as its scope
    splash_screen = SplashScreen.new(editor_window, LAYOUT_CENTER_X | LAYOUT_CENTER_Y)
    #add friend funtion from splashscreen to menuBar via editor_window
    editor_window.editMenuBar(splash_screen)
    
    #adding floating ui to this brush_tool_bar
    brush_tool_bar = FloatingToolBar.new(editor_window, LAYOUT_SIDE_LEFT)
    splash_screen.addHideElement(brush_tool_bar.getToolBar,editor_window)

    #make layer panel and color panel on top of each other
    frameV = FXVerticalFrame.new(editor_window, :opts => LAYOUT_SIDE_RIGHT)
    splash_screen.addHideElement(frameV,editor_window)

    #adding floating ui to color_window
    color_tool_bar = FloatingToolBar.new(frameV, LAYOUT_SIDE_RIGHT)
    #adding empty dock for all toolbar objects
    color_tool_bar.addDock(LAYOUT_SIDE_RIGHT)
    splash_screen.addHideElement(color_tool_bar.getToolBar,editor_window)
    
    #adding floating ui to layerPanel
    layer_tool_bar = FloatingToolBar.new(frameV,LAYOUT_SIDE_BOTTOM|LAYOUT_CENTER_X)
    splash_screen.addHideElement(layer_tool_bar.getToolBar,editor_window)

    canvasPacker = FXPacker.new(editor_window,LAYOUT_FILL_X|LAYOUT_FILL_Y)
    canvas_window = Canvas.new(canvasPacker, LAYOUT_SIDE_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y, 0, 0, 800, 400, 0, 0, 0, 0, app)
    canvasPacker.backColor = "Gray69"
    splash_screen.addHideElement(canvasPacker,editor_window)
    #add friend function to canvas and editor_window
    editor_window.canvaFriend(canvas_window)
    
    brush_window = BrushPanel.new(brush_tool_bar.getToolBar,LAYOUT_FIX_WIDTH | LAYOUT_FIX_HEIGHT,0,0,69,340, canvas_window)
    brush_window.backColor = "Gray69"
    splash_screen.addHideElement(brush_window,editor_window)
    
    color_window = ColorPanel.new(color_tool_bar.getToolBar, LAYOUT_FIX_WIDTH | LAYOUT_FIX_HEIGHT | LAYOUT_CENTER_X , 0, 0, 150, 280, canvas_window)
    color_window.backColor = "Gray69"
    splash_screen.addHideElement(color_window,editor_window)

    layerPanel = LayerPanel.new(layer_tool_bar.getToolBar, LAYOUT_FIX_WIDTH | LAYOUT_FILL_Y | LAYOUT_SIDE_BOTTOM | LAYOUT_RIGHT, 0,0, 161, 120)
    layerPanel.backColor = "Gray69"
    splash_screen.addHideElement(layerPanel,editor_window)

  FXToolTip.new(app)
  app.create
  app.run
  end
end

