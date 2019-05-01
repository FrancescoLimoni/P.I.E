#Edited Feb 12, 2019 by Jacob Watters

require 'fox16'
require 'fox16/colors'
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
    hFrame2 = FXHorizontalFrame.new(groupBoxColorPanel, :opts => LAYOUT_CENTER_X)
    hFrame3 = FXHorizontalFrame.new(groupBoxColorPanel, :opts => LAYOUT_CENTER_X)
    
    groupBoxColorPanel.backColor  =
    groupBoxPreset.backColor      =
    groupBoxCustom.backColor      =
    matrix.backColor              = 
    hFrame.backColor              = 
    hFrame2.backColor             = 
    hFrame3.backColor             = "Gray69"
  
    createButtons(hFrame, matrix) #Draws Buttons for color selection
  end
  
  #creates button matrix for custom pallete and applies a random color.
  def createButtons(framing, groupStyle)
    #Load icons
    red     = loadIcon("RedIcon.png") 
    green   = loadIcon("GreenIcon.png")
    blue    = loadIcon("BlueIcon.png")
    black   = loadIcon("BlackIcon.png")
    white   = loadIcon("WhiteIcon.png")
    
    
    #Create button frame with Icon
    redBtn      = FXButton.new(framing, "\tRed Preset",   red,    :opts => LAYOUT_CENTER_X|FRAME_SUNKEN)
    greenBtn    = FXButton.new(framing, "\tGreen Preset", green,  :opts => LAYOUT_CENTER_X|FRAME_SUNKEN)
    blueBtn     = FXButton.new(framing, "\tBlue Preset",  blue,   :opts => LAYOUT_CENTER_X|FRAME_SUNKEN)
    blackBtn    = FXButton.new(framing, "\tBlack Preset", black,  :opts => LAYOUT_CENTER_X|FRAME_SUNKEN)
    whiteBtn    = FXButton.new(framing, "\tWhite Preset", white,  :opts => LAYOUT_CENTER_X|FRAME_SUNKEN)
    
    customColorArray = Array.new(12)
    buttonFrameArray = Array.new(12)
    colorWellArray = Array.new(12)
    
    #Creates 5X3 Button matrix
    1.upto(12) do |i| 
      buttonFrameArray.insert(i-1, FXVerticalFrame.new(groupStyle))
      buttonFrameArray[i-1].backColor = "Gray69"
      colorWellArray.insert(i-1, FXColorWell.new(buttonFrameArray[i-1], FXColor::White))
      colorWellArray[i-1].backColor = "Gray69"
      customColorArray.insert(i-1, Fox.FXRGB(255, 255, 255))
    end
    
    colorWellArray[0].connect(SEL_COMMAND) do |sender, sel, clr|
        customColorArray[0] = clr
        @canvas_window.setDrawColorViaRGBObject(customColorArray[0])
    end
    colorWellArray[1].connect(SEL_COMMAND) do |sender, sel, clr|
        customColorArray[1] = clr
        @canvas_window.setDrawColorViaRGBObject(customColorArray[1])
    end
    colorWellArray[2].connect(SEL_COMMAND) do |sender, sel, clr|
        customColorArray[2] = clr
        @canvas_window.setDrawColorViaRGBObject(customColorArray[1])
    end
    colorWellArray[3].connect(SEL_COMMAND) do |sender, sel, clr|
        customColorArray[3] = clr
        @canvas_window.setDrawColorViaRGBObject(customColorArray[3])
    end
    colorWellArray[4].connect(SEL_COMMAND) do |sender, sel, clr|
        customColorArray[4] = clr
        @canvas_window.setDrawColorViaRGBObject(customColorArray[4])
    end
    colorWellArray[5].connect(SEL_COMMAND) do |sender, sel, clr|
        customColorArray[5] = clr
        @canvas_window.setDrawColorViaRGBObject(customColorArray[5])
    end
    colorWellArray[6].connect(SEL_COMMAND) do |sender, sel, clr|
        customColorArray[6] = clr
        @canvas_window.setDrawColorViaRGBObject(customColorArray[6])
    end
    colorWellArray[7].connect(SEL_COMMAND) do |sender, sel, clr|
        customColorArray[7] = clr
        @canvas_window.setDrawColorViaRGBObject(customColorArray[7])
    end
    colorWellArray[8].connect(SEL_COMMAND) do |sender, sel, clr|
        customColorArray[8] = clr
        @canvas_window.setDrawColorViaRGBObject(customColorArray[8])
    end
    colorWellArray[9].connect(SEL_COMMAND) do |sender, sel, clr|
        customColorArray[9] = clr
        @canvas_window.setDrawColorViaRGBObject(customColorArray[9])
    end
    colorWellArray[10].connect(SEL_COMMAND) do |sender, sel, clr|
        customColorArray[10] = clr
        @canvas_window.setDrawColorViaRGBObject(customColorArray[10])
    end
    colorWellArray[11].connect(SEL_COMMAND) do |sender, sel, clr|
        customColorArray[11] = clr
        @canvas_window.setDrawColorViaRGBObject(customColorArray[11])
    end
    
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
