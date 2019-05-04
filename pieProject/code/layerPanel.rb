#
# Version 0.3
# made on 03/09/2019
# upgrade: I created a new LPFields class and I stored the instances into an array of object. delete button action integrated and functioning
# downgrade: the loadIcon function doesn't load the icon buttons
# persistent issues: unable to see the new horizontal frame after has been created
#

require 'fox16'
include Fox

class LPFields
  attr_accessor :frameH, :hideB, :label, :binB

  def initialize(frameV, layers, canvas)
    isHidden = false

    @index = 0
    @activeIndex = 0
    @parentLayer = nil

    frameH = FXHorizontalFrame.new(frameV, :opts => LAYOUT_SIDE_BOTTOM|LAYOUT_RIGHT|FRAME_LINE)
    
    hideB = FXButton.new(frameH, "H", nil, :opts => BUTTON_NORMAL|LAYOUT_SIDE_BOTTOM|LAYOUT_LEFT|LAYOUT_CENTER_Y)
    buttonCustomization(hideB, true, false)
    
    selectB = FXButton.new(frameH, "S", nil, :opts => BUTTON_NORMAL|LAYOUT_SIDE_BOTTOM|LAYOUT_LEFT|LAYOUT_CENTER_Y)
    buttonCustomization(selectB, true, false)
    
    label = FXLabel.new(frameH, 'Layer ' + (layers.size + 1).to_s, :opts => LAYOUT_SIDE_BOTTOM|LAYOUT_CENTER_X|LAYOUT_CENTER_Y)
    
    binB = FXButton.new(frameH, "C", nil, :opts => BUTTON_NORMAL|LAYOUT_SIDE_BOTTOM|LAYOUT_RIGHT|LAYOUT_CENTER_Y)
    buttonCustomization(binB, true, false)
   
    @friendRef = canvas
    
    #BUTTON ACTION SECTION
    hideB.connect(SEL_COMMAND) do|sender, sel, data|
      isHidden = hideSection(frameH, hideB, label, binB, isHidden)
      @friendRef.setHidden(@index)
    end
    binB.connect(SEL_COMMAND) do|sender, sel, data|

      if @index == @activeIndex
        @friendRef.clear(@index)
      end
    end
    selectB.connect(SEL_COMMAND) do |sender, sel, data|
    i = 0
    while i < 5
      @parentLayer[i].setActiveIndex(@index)
      i = i + 1
    end
    @friendRef.setActiveIndex(@index)

    end
  end

  #METHODS SECTION
  def loadIcon(iconName)
    begin
      iconName = File.join("icons", iconName)
      icon = nil
      File.open(File.expand_path(File.dirname(__FILE__)).tap {|pwd| $LOAD_PATH.unshift(pwd) unless $LOAD_PATH.include?(pwd)}+"/"+iconName, "rb") do |f|
        icon = FXPNGIcon.new(getApp(), f.read)
      end
      icon
    rescue
      raise RuntimeError, "Couldn't load icon: #{iconName}"
    end
  end

  #button custamization
  def buttonCustomization(button, inner, outside)
    if outside
      button.buttonStyle |= BUTTON_TOOLBAR
      button.frameStyle = FRAME_RAISED
      button.backColor = "Gray69"
    elsif inner
      button.buttonStyle |= BUTTON_TOOLBAR
      button.frameStyle = FRAME_RAISED
      button.backColor = FXRGB(212, 208, 200)
    end
  end

  #change the color of layer section
  def hideSection(frameH, hideB, label, binB, isHidden)
    if !isHidden
      frameH.backColor = FXRGB(176, 176, 176)
      frameH.borderColor = FXRGB(106, 106, 106)
      label.backColor = FXRGB(176, 176, 176)
      label.textColor = FXRGB(56, 56, 56)
      binB.backColor = FXRGB(176, 176, 176)
      hideB.backColor = FXRGB(176, 176, 176)
      isHidden = true
    else
      frameH.backColor = FXRGB(212, 208, 200)
      frameH.borderColor = FXRGB(0, 0, 0)
      label.backColor = FXRGB(212, 208, 200)
      label.textColor = FXRGB(0, 0, 0)
      binB.backColor = FXRGB(212, 208, 200)
      hideB.backColor = FXRGB(212, 208, 200)
      isHidden = false
    end

    return isHidden
  end
  
  def setIndex(i)
    @index = i
  end
  
  def setActiveIndex(index)
    @activeIndex = index
  end
  
  def parentLayer(layer)
    @parentLayer = layer
  end
end

class LayerPanel < FXPacker

  def initialize(p, opts, x, y, width, height, canvas)
    super(p,opts, x, y, width, height)

    @layers = Array.new
    @isActiveLayer = [true, false, false]
    @activeIndex = 0

    @friendref = canvas

    packer = FXPacker.new(self, opts =  LAYOUT_SIDE_BOTTOM|LAYOUT_RIGHT)
    packerCustomization(packer)

    groupBox = FXGroupBox.new(packer, "Layer", :opts => GROUPBOX_TITLE_CENTER|FRAME_RIDGE|LAYOUT_CENTER_X|LAYOUT_CENTER_Y)
    groupBox.backColor = "Gray69"

    frameV = FXVerticalFrame.new(groupBox, :opts => LAYOUT_SIDE_BOTTOM)
    frameV.backColor = "Gray69"


    layerFields1 = LPFields.new(frameV, @layers, @friendref)
    layerFields1.setIndex(0)
    #layerFields1.classRef(@friendref)
    @layers.push(layerFields1)
    
    layerFields2 = LPFields.new(frameV, @layers, @friendref)
    layerFields2.setIndex(1)
   # layerFields2.classRef(@friendref)
    @layers.push(layerFields2)
    
    layerFields3 = LPFields.new(frameV, @layers, @friendref)
    layerFields3.setIndex(2)
    #layerFields3.classRef(@friendref)
    @layers.push(layerFields3)
    
    layerFields4 = LPFields.new(frameV, @layers, @friendref)
    layerFields4.setIndex(3)
    #layerFields4.classRef(@friendref)
    @layers.push(layerFields4)
    
    layerFields5 = LPFields.new(frameV, @layers, @friendref)
    layerFields5.setIndex(4)
    #layerFields5.classRef(@friendref)
    @layers.push(layerFields5)

    hideLabels
    
    i = 0
    while i < 5
     @layers[i].setActiveIndex(0)
     @layers[i].parentLayer(@layers)
     i = i + 1
    end

  end

  #METHODS SECTION
  def hideLabels()

    for item in @isActiveLayer
      #puts(item)
      if item == true
        puts("true")
      else
        puts("false")
      end
    end
  end

  #create space from the packer's borders
  def packerCustomization(packer)
    packer.padLeft = 10
    packer.padRight = 10
    packer.padTop = 10
    packer.padBottom = 10
    packer.backColor = "Gray69"
  end

  #button custamization
  def buttonCustomization(button, inner, outside)
    if outside
      button.buttonStyle |= BUTTON_TOOLBAR
      button.frameStyle = FRAME_RAISED
      button.backColor = "Gray69"
    elsif inner
      button.buttonStyle |= BUTTON_TOOLBAR
      button.frameStyle = FRAME_RAISED
      button.backColor = FXRGB(212, 208, 200)
    end
  end

  def setActiveIndex(index)
    @activeIndex = index
    i = 0
    while i < 5
      @layers[i].setActiveIndex(index)
      i = i + 1
    end

  end
end