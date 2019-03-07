require 'fox16'
include Fox

class LayerPanel < FXPacker
  def initialize(p, opts, x, y, width, height)
    super(p,  opts, x, y, width, height)

    #images for layer buttons
    icon1 = loadIcon("plusIcon20.png")
    @icon2 = loadIcon("binIcon24.png")
    @icon3 = loadIcon("hideIcon20.png")
    @layerSections = Array.new()
    @hideB
    @deleteB

    packer = FXPacker.new(self, opts =  LAYOUT_SIDE_BOTTOM|LAYOUT_RIGHT)
    packerCustomization(packer)

    gruopBox = FXGroupBox.new(packer, "Layer", :opts => GROUPBOX_TITLE_CENTER|FRAME_RIDGE)
    gruopBox.backColor = "Gray69"

    frameV = FXVerticalFrame.new(gruopBox, :opts => LAYOUT_SIDE_BOTTOM)
    frameV.backColor = "Gray69"

    plusB = FXButton.new(frameV, nil, icon1, :opts => LAYOUT_RIGHT)
    buttonCustomization(plusB, false, true)

    addLayerSections(@layerSections, frameV)

    #botton action
    plusB.connect(SEL_COMMAND) do | sender, sel, data|
      addLayerSections(@layerSections, frameV)
      puts('Array size:' + @layerSections.size.to_s)
    end
  end

  #METHODS SECTION
  # loading button icon
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

  #create space from the packer's borders
  def packerCustomization(packer)
    packer.padLeft = 10
    packer.padRight = 10
    packer.padTop = 10
    packer.padBottom = 10
    packer.backColor = "Gray69"
  end

  #create a new layer sections
  def addLayerSections(layerSections, frameV)
    @isHidden = false
    index = layerSections.size
    index += 1
    frameH = FXHorizontalFrame.new(frameV, :opts => LAYOUT_SIDE_BOTTOM|LAYOUT_RIGHT|FRAME_LINE)
    binB = FXButton.new(frameH, nil, @icon2, :opts => BUTTON_NORMAL|LAYOUT_SIDE_BOTTOM|LAYOUT_RIGHT|LAYOUT_CENTER_Y)
    buttonCustomization(binB, true, false)
    hideB = FXButton.new(frameH, nil, @icon3, :opts => BUTTON_NORMAL|LAYOUT_SIDE_BOTTOM|LAYOUT_LEFT|LAYOUT_CENTER_Y)
    buttonCustomization(hideB, true, false)
    label = FXLabel.new(frameH, 'LAYER ' + index.to_s, :opts => LAYOUT_SIDE_BOTTOM|LAYOUT_CENTER_X|LAYOUT_CENTER_Y)

    layerSections.push(frameH)

    #botton Action
    binB.connect(SEL_COMMAND) do | sender, sel, data |
      deleteLayer(layerSections)
      puts("deleting process")
    end
    hideB.connect(SEL_COMMAND) do|sender, sel, data|
      @isHidden = hideSectionCustomization(frameH, label, binB, hideB, @isHidden)
      puts("isHidden (outside): " + @isHidden.to_s)
    end
  end

  #hide a layer section
  def hideLayerSections()

  end

  #layer customization
  def hideSectionCustomization(frameH, label, binB, hideB, isHidden)

    puts("\nisHidden (inside up): " + isHidden.to_s)

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

    puts("isHidden (inside down): " + isHidden.to_s)
    return isHidden
  end

  #delete a layer section
  def deleteLayer(layerSections)
    index = layerSections.size

    if index == 1
      FXMessageBox.warning(self, MBOX_OK, "WARNING MESSAGE", "You cannot delete this layer")
    elsif index > 1
      layerSections.pop
      puts("array: " + layerSections.size.to_s)
    end
  end

end