require 'fox16'

include Fox

class BrushPanel < FXScrollWindow
  def initialize(parent,opts,x,y,width,height)
    super
    
    b1 = loadIcon("BrushIcon1.png")
    b2 = loadIcon("BrushIcon2.png")
    b3 = loadIcon("BrushIcon3.png")

    vframe = FXGroupBox.new(self, "Brush Size", GROUPBOX_TITLE_CENTER|FRAME_RIDGE)
    brush1 = FXButton.new(vframe, "\t1 x 1", b1, :opts => LAYOUT_CENTER_X)
      brush1.buttonStyle |= BUTTON_TOOLBAR
      brush1.frameStyle = FRAME_RAISED
    brush2 = FXButton.new(vframe, "\t2 x 2", b2, :opts => LAYOUT_CENTER_X)
      brush2.buttonStyle |= BUTTON_TOOLBAR
      brush2.frameStyle = FRAME_RAISED
    brush3 = FXButton.new(vframe, "\t3 x 3", b3, :opts => LAYOUT_CENTER_X)
      brush3.buttonStyle |= BUTTON_TOOLBAR
      brush3.frameStyle = FRAME_RAISED
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
