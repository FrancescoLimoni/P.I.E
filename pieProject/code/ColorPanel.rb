#Edited Feb 12, 2019 by Jacob Watters

require 'fox16'
require 'Color.rb'
require 'Canvas.rb'
include Fox

class ColorPanel < FXPacker
  def initialize(p, opts, x, y, width, height, c)
    super(p, opts, x, y, width, height)
    @canvas_window = c
    #Create 'Color Picker' box to hold buttons
    groupBoxColorPanel = FXGroupBox.new(self, "Color Picker", GROUPBOX_TITLE_CENTER | FRAME_RIDGE | LAYOUT_CENTER_X)
    groupBoxPreset = FXGroupBox.new(groupBoxColorPanel, "Presets", GROUPBOX_TITLE_CENTER | FRAME_RIDGE | LAYOUT_CENTER_X) 
    groupBoxCustom = FXGroupBox.new(groupBoxColorPanel, "Custom Palette", GROUPBOX_TITLE_CENTER | FRAME_RIDGE | LAYOUT_CENTER_X)
    
    hFrame = FXHorizontalFrame.new(groupBoxPreset, :opts => LAYOUT_CENTER_X)
    matrix = FXMatrix.new(groupBoxCustom, 3, :opts => MATRIX_BY_ROWS | LAYOUT_CENTER_X)
    
    
    groupBoxColorPanel.backColor  =
    groupBoxPreset.backColor      =
    groupBoxCustom.backColor      =
    matrix.backColor              = 
    hFrame.backColor              = "Gray69"

    createButtons(hFrame, matrix) #Draws Buttons for color selection
  end
  
  def createButtons(framing, groupStyle)
    randColor = Color.new()
    #c = Canvas.new()
    
    #Creates 5X3 Button matrix
    1.upto(15) do |i|
          FXButton.new(groupStyle, "-").backColor = randColor.getRandColor
    end
    
    #Load icons
    red     = loadIcon("RedIcon.png") 
    green   = loadIcon("GreenIcon.png")
    blue    = loadIcon("BlueIcon.png")
    black   = loadIcon("BlackIcon.png")
    white   = loadIcon("WhiteIcon.png")
    
    #Create button frame with Icon
    redBtn      = FXButton.new(framing, "\tRed Preset",   red,    :opts => LAYOUT_CENTER_X)
    greenBtn    = FXButton.new(framing, "\tGreen Preset", green,  :opts => LAYOUT_CENTER_X)
    blueBtn     = FXButton.new(framing, "\tBlue Preset",  blue,   :opts => LAYOUT_CENTER_X)
    blackBtn    = FXButton.new(framing, "\tBlack Preset", black,  :opts => LAYOUT_CENTER_X)
    whiteBtn    = FXButton.new(framing, "\tWhite Preset", white,  :opts => LAYOUT_CENTER_X)
    
    redBtn.connect(SEL_COMMAND) do | sender, sel, data|
             @canvas_window.setDrawColor("red")
    end
    greenBtn.connect(SEL_COMMAND) do | sender, sel, data|
             @canvas_window.setDrawColor("green")
    end
    blueBtn.connect(SEL_COMMAND) do | sender, sel, data|
             @canvas_window.setDrawColor("blue")
    end
    blackBtn.connect(SEL_COMMAND) do | sender, sel, data|
             @canvas_window.setDrawColor("black")
    end
    whiteBtn.connect(SEL_COMMAND) do | sender, sel, data|
             @canvas_window.setDrawColor("white")
    end
    
    #Stylize buttons
    redBtn.frameStyle     = FRAME_RAISED
    greenBtn.frameStyle   = FRAME_RAISED
    blueBtn.frameStyle    = FRAME_RAISED
    blackBtn.frameStyle   = FRAME_RAISED
    whiteBtn.frameStyle   = FRAME_RAISED
  end
  
  
  
  def loadIcon(filename)
      begin
        filename = File.join("icons", filename)
        icon = nil
        File.open(filename, "rb") do |f|
          icon = FXPNGIcon.new(getApp(), f.read)
        end
        icon
      rescue
        raise RuntimeError, "Couldn't load icon: #{filename}"
      end
    end
end
