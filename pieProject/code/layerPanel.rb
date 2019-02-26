require 'fox16'
include Fox

class LayerPanel < FXScrollWindow

  def initialize(p, opts, x, y, width, height)
    super(p,  opts, x, y, width, height)

    packer = FXPacker.new(self, opts =  LAYOUT_SIDE_BOTTOM|LAYOUT_RIGHT)
    packerCustomization(packer)
    gruopBox = FXGroupBox.new(packer, "Layer", :opts => GROUPBOX_TITLE_CENTER|FRAME_RIDGE)
    frameV = FXVerticalFrame.new(gruopBox, :opts => LAYOUT_SIDE_BOTTOM)
    button = FXButton.new(frameV, "+", :opts => BUTTON_NORMAL|LAYOUT_RIGHT)

    @layers = Array.new()
    addLayer(@layers, frameV)

    button.connect(SEL_COMMAND) do | sender, sel, data|
      addLayer(@layers, frameV)
      puts('Array size:' + @layers.size.to_s)
    end

  end

  #create space from the packer's borders
  def packerCustomization(packer)
    packer.padLeft = 10
    packer.padRight = 10
    packer.padTop = 10
    packer.padBottom = 10
  end

  #create a new layer
  def addLayer(layers, frameV)
    index = layers.size
    index += 1
    frameH = FXHorizontalFrame.new(frameV, :opts => LAYOUT_SIDE_BOTTOM|LAYOUT_RIGHT|FRAME_LINE)
    FXButton.new(frameH, "T", :opts => BUTTON_NORMAL|LAYOUT_SIDE_BOTTOM|LAYOUT_RIGHT)
    FXButton.new(frameH, "H", :opts => BUTTON_NORMAL|LAYOUT_SIDE_BOTTOM|LAYOUT_LEFT)
    FXLabel.new(frameH, 'LAYOUT ' + index.to_s, :opts => LAYOUT_SIDE_BOTTOM|LAYOUT_RIGHT)

    layers.push(frameH)
  end

end