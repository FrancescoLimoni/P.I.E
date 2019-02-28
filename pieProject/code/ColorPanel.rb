#Edited Feb 12, 2019 by Jacob Watters

require 'fox16'
include Fox

class ColorPanel < FXPacker
  def initialize(p, opts, x, y, width, height)
    super(p, opts, x, y, width, height)
    
    #Create 'Color Picker' box to hold buttons
    groupBoxH = FXGroupBox.new(self, "Color Picker", GROUPBOX_TITLE_CENTER | FRAME_RIDGE) 
    groupBoxH.backColor = "Gray69"
    hFrame = FXHorizontalFrame.new(groupBoxH)
    hFrame.backColor = "Gray69"

    createButtons(hFrame) #Draws Buttons for color selection
  end
  
  def createButtons(framing)
    
    #Load icons
    red     = loadIcon("RedIcon.png") 
    green   = loadIcon("GreenIcon.png")
    blue    = loadIcon("BlueIcon.png")
    black   = loadIcon("BlackIcon.png")
    white   = loadIcon("WhiteIcon.png")
    custom  = loadIcon("CustomColorIcon.png")
    
    #Create button frame with Icon
    redBtn      = FXButton.new(framing, "\tRed Preset",   red,    :opts => LAYOUT_CENTER_X)
    greenBtn    = FXButton.new(framing, "\tGreen Preset", green,  :opts => LAYOUT_CENTER_X)
    blueBtn     = FXButton.new(framing, "\tBlue Preset",  blue,   :opts => LAYOUT_CENTER_X)
    blackBtn    = FXButton.new(framing, "\tBlack Preset", black,  :opts => LAYOUT_CENTER_X)
    whiteBtn    = FXButton.new(framing, "\tWhite Preset", white,  :opts => LAYOUT_CENTER_X)
    customBtn   = FXButton.new(framing, "\tCustom Color", custom, :opts => LAYOUT_CENTER_X)
    
    #Stylize buttons
    redBtn.frameStyle     = FRAME_RAISED
    greenBtn.frameStyle   = FRAME_RAISED
    blueBtn.frameStyle    = FRAME_RAISED
    blackBtn.frameStyle   = FRAME_RAISED
    whiteBtn.frameStyle   = FRAME_RAISED
    customBtn.frameStyle  = FRAME_RAISED
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

