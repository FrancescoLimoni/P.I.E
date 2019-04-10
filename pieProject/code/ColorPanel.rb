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
    hFrame2 = FXHorizontalFrame.new(groupBoxColorPanel, :opts => LAYOUT_CENTER_X)
    hFrame3 = FXHorizontalFrame.new(groupBoxColorPanel, :opts => LAYOUT_CENTER_X)
    
    groupBoxColorPanel.backColor  =
    groupBoxPreset.backColor      =
    groupBoxCustom.backColor      =
    matrix.backColor              = 
    hFrame.backColor              = 
    hFrame2.backColor             = "Gray69"

    redTextField = FXTextField.new(hFrame2, 4)
    greenTextField = FXTextField.new(hFrame2, 4)
    blueTextField = FXTextField.new(hFrame2, 4)
    
    generateButton = FXButton.new(hFrame3, "Set Color")
    
    generateButton.connect(SEL_COMMAND) do
       redValue = [0, redTextField.text.to_i].max
       #puts ("redValue set to " + redValue.to_s)
       greenValue = [0, greenTextField.text.to_i].max
       #puts ("greenValue set to " + greenValue.to_s)
       blueValue = [0, blueTextField.text.to_i].max
       #puts ("blueValue set to " + blueValue.to_s)
       @canvas_window.setDrawColorViaRGB(redValue, greenValue, blueValue)
    end
    
    createButtons(hFrame, matrix) #Draws Buttons for color selection
  end
  
  #creates button matrix for custom pallete and applies a random color.
  def createButtons(framing, groupStyle)
    randColor = Color.new()
    randColorArray = Array.new(15)
    
    #Creates 5X3 Button matrix
    1.upto(15) do |i|
      randColorArray.insert(i-1, randColor.getRandColor)
      rand = FXButton.new(groupStyle, "-").backColor = randColorArray[i-1]
      #rand.connect(SEL_COMMAND) do | sender, sel, data|
            #@canvas_window.setDrawColor(color)
      #end
    end
    
    customColor1 = groupStyle.childAtRowCol(0, 0)
    customColor2 = groupStyle.childAtRowCol(1, 0)
    customColor3 = groupStyle.childAtRowCol(2, 0)
    customColor4 = groupStyle.childAtRowCol(0, 1)
    customColor5 = groupStyle.childAtRowCol(1, 1)
    customColor6 = groupStyle.childAtRowCol(2, 1)
    customColor7 = groupStyle.childAtRowCol(0, 2)
    customColor8 = groupStyle.childAtRowCol(1, 2)
    customColor9 = groupStyle.childAtRowCol(2, 2)
    customColor10 = groupStyle.childAtRowCol(0, 3)
    customColor11 = groupStyle.childAtRowCol(1, 3)
    customColor12 = groupStyle.childAtRowCol(2, 3)
    customColor13 = groupStyle.childAtRowCol(0, 4)
    customColor14 = groupStyle.childAtRowCol(1, 4)
    customColor15 = groupStyle.childAtRowCol(2, 4)
    
    customColor1.connect(SEL_COMMAND) do | sender, sel, data|
           @canvas_window.setDrawColor(randColorArray[0])
    end
    customColor2.connect(SEL_COMMAND) do | sender, sel, data|
           @canvas_window.setDrawColor(randColorArray[1])
    end
    customColor3.connect(SEL_COMMAND) do | sender, sel, data|
           @canvas_window.setDrawColor(randColorArray[2])
    end
    customColor4.connect(SEL_COMMAND) do | sender, sel, data|
           @canvas_window.setDrawColor(randColorArray[3])
    end
    customColor5.connect(SEL_COMMAND) do | sender, sel, data|
           @canvas_window.setDrawColor(randColorArray[4])
    end
    customColor6.connect(SEL_COMMAND) do | sender, sel, data|
           @canvas_window.setDrawColor(randColorArray[5])
    end
    customColor7.connect(SEL_COMMAND) do | sender, sel, data|
           @canvas_window.setDrawColor(randColorArray[6])
    end
    customColor8.connect(SEL_COMMAND) do | sender, sel, data|
           @canvas_window.setDrawColor(randColorArray[7])
    end
    customColor9.connect(SEL_COMMAND) do | sender, sel, data|
           @canvas_window.setDrawColor(randColorArray[8])
    end
    customColor10.connect(SEL_COMMAND) do | sender, sel, data|
           @canvas_window.setDrawColor(randColorArray[9])
    end
    customColor11.connect(SEL_COMMAND) do | sender, sel, data|
           @canvas_window.setDrawColor(randColorArray[10])
    end
    customColor12.connect(SEL_COMMAND) do | sender, sel, data|
           @canvas_window.setDrawColor(randColorArray[11])
    end
    customColor13.connect(SEL_COMMAND) do | sender, sel, data|
           @canvas_window.setDrawColor(randColorArray[12])
    end
    customColor14.connect(SEL_COMMAND) do | sender, sel, data|
           @canvas_window.setDrawColor(randColorArray[13])
    end
    customColor15.connect(SEL_COMMAND) do | sender, sel, data|
           @canvas_window.setDrawColor(randColorArray[14])
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
