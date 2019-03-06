require 'fox16'
include Fox

class LayerPanel < FXPacker
  def initialize(p, opts, x, y, width, height)
    super(p,  opts, x, y, width, height)

    #images for layer buttons
    icon1 = loadIcon("plusIcon20.png")
    @icon2 = loadIcon("binIcon24.png")
    @icon3 = loadIcon("hideIcon20.png")
    @layers = Array.new()

    packer = FXPacker.new(self, opts =  LAYOUT_SIDE_BOTTOM|LAYOUT_RIGHT)
    packerCustomization(packer)

    gruopBox = FXGroupBox.new(packer, "Layer", :opts => GROUPBOX_TITLE_CENTER|FRAME_RIDGE)
    gruopBox.backColor = "Gray69"

    frameV = FXVerticalFrame.new(gruopBox, :opts => LAYOUT_SIDE_BOTTOM)
    frameV.backColor = "Gray69"

    plusB = FXButton.new(frameV, nil, icon1, :opts => LAYOUT_RIGHT)
    buttonCustomization(plusB, false, true)

    addLayer(@layers, frameV)

    plusB.connect(SEL_COMMAND) do | sender, sel, data|
      addLayer(@layers, frameV)
      puts('Array size:' + @layers.size.to_s)
    end
  end

  #METHODS SECTION
  # loading button icone
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

  #button style
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

  #create space from the packer's borders
  def packerCustomization(packer)
    packer.padLeft = 10
    packer.padRight = 10
    packer.padTop = 10
    packer.padBottom = 10
    packer.backColor = "Gray69"
  end

  #create a new layer
  def addLayer(layers, frameV)
    index = layers.size
    index += 1
    frameH = FXHorizontalFrame.new(frameV, :opts => LAYOUT_SIDE_BOTTOM|LAYOUT_RIGHT|FRAME_LINE)
    binB = FXButton.new(frameH, nil, @icon2, :opts => BUTTON_NORMAL|LAYOUT_SIDE_BOTTOM|LAYOUT_RIGHT|LAYOUT_CENTER_Y)
    buttonCustomization(binB, true, false)
    hideB = FXButton.new(frameH, nil, @icon3, :opts => BUTTON_NORMAL|LAYOUT_SIDE_BOTTOM|LAYOUT_LEFT|LAYOUT_CENTER_Y)
    buttonCustomization(hideB, true, false)
    FXLabel.new(frameH, 'LAYER ' + index.to_s, :opts => LAYOUT_SIDE_BOTTOM|LAYOUT_CENTER_X|LAYOUT_CENTER_Y)

    layers.push(frameH)
  end
end