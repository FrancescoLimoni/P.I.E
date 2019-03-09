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

  def initialize(frameV, layers)
    isHidden = false
    #hideBI = loadIcon("hideIcon20.png")
    #binBI = loadIcon("binIcon24.png")

    frameH = FXHorizontalFrame.new(frameV, :opts => LAYOUT_SIDE_BOTTOM|LAYOUT_RIGHT|FRAME_LINE)
    hideB = FXButton.new(frameH, "H", nil, :opts => BUTTON_NORMAL|LAYOUT_SIDE_BOTTOM|LAYOUT_LEFT|LAYOUT_CENTER_Y)
    buttonCustomization(hideB, true, false)
    label = FXLabel.new(frameH, 'Layer ' + (layers.size + 1).to_s, :opts => LAYOUT_SIDE_BOTTOM|LAYOUT_CENTER_X|LAYOUT_CENTER_Y)
    binB = FXButton.new(frameH, "D", nil, :opts => BUTTON_NORMAL|LAYOUT_SIDE_BOTTOM|LAYOUT_RIGHT|LAYOUT_CENTER_Y)
    buttonCustomization(binB, true, false)

    #BUTTON ACTION SECTION
    hideB.connect(SEL_COMMAND) do|sender, sel, data|
      isHidden = hideSection(frameH, hideB, label, binB, isHidden)
    end
    binB.connect(SEL_COMMAND) do|sender, sel, data|
      index = label.getText[-1]
      frameV.removeChild(frameH)
      layers.delete_at((index.to_i)-1)
    end
  end

  #METHODS SECTION
  def loadIcon(iconName)
    begin
      iconName = File.join("icons", iconName)
      icon = nil
      File.open(iconName, "rb") do |f|
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
end

class LayerPanel < FXPacker
  def initialize(p, opts, x, y, width, height)
    super(p,  opts, x, y, width, height)

    #images for layer buttons
    plusB = loadIcon("plusIcon20.png")
    @layers = Array.new

    packer = FXPacker.new(self, opts =  LAYOUT_SIDE_BOTTOM|LAYOUT_RIGHT)
    packerCustomization(packer)

    groupBox = FXGroupBox.new(packer, "Layer", :opts => GROUPBOX_TITLE_CENTER|FRAME_RIDGE|LAYOUT_CENTER_X|LAYOUT_CENTER_Y)
    groupBox.backColor = "Gray69"

    frameV = FXVerticalFrame.new(groupBox, :opts => LAYOUT_SIDE_BOTTOM)
    frameV.backColor = "Gray69"

    plusB = FXButton.new(frameV, nil, plusB, :opts => LAYOUT_RIGHT)
    buttonCustomization(plusB, false, true)

    layerFields = LPFields.new(frameV, @layers)
    @layers.push(layerFields)
    layerFields = LPFields.new(frameV, @layers)
    @layers.push(layerFields)

    #BUTTON ACTION SECTION
    plusB.connect(SEL_COMMAND) do | seler, sel, data|
      layerFields = LPFields.new(frameV, @layers)
      @layers.push(layerFields)
    end


  end

  #METHODS SECTION
  def loadIcon(iconName)
    begin
      iconName = File.join("icons", iconName)
      icon = nil
      File.open(iconName, "rb") do |f|
        icon = FXPNGIcon.new(getApp(), f.read)
      end
      icon
    rescue
      raise RuntimeError, "Couldn't load icon: #{iconName}"
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

end