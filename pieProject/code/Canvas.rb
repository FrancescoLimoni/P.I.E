$LOAD_PATH << '.'
require 'fox16'

include Fox

class Canvas
  
  attr_reader :contents, :canvas_frame, :drawColor, :mouseDown, :dirty, :canvas, :dc
  attr_writer :drawColor, :mouseDown, :dirty
  
  def initialize(p, opts, x, y, width, height, padLeft, padRight, padTop, padBottom)
    @contents = FXHorizontalFrame.new(p, opts, x, y, width, height,
     padLeft, padRight, padTop, padBottom)
     
    @canvas_frame = FXVerticalFrame.new(@contents,FRAME_SUNKEN|LAYOUT_FILL_X|LAYOUT_FILL_Y|LAYOUT_TOP|LAYOUT_LEFT, 
   0, 0, 0, 0, 10, 10, 10, 10) 
    
    @canvas = FXCanvas.new(@canvas_frame, nil, 0, LAYOUT_FILL_X|LAYOUT_FILL_Y|LAYOUT_TOP|LAYOUT_LEFT, 0, 0, 0, 0,) 
  
  
  
    @drawColor = FXRGB(255, 0, 0)
    @mouseDown = false
    @dirty = false     
    
    @canvas.connect(SEL_PAINT) do |sender, sel, event|
      FXDCWindow.new(@canvas,event) do |dc|
        dc.foreground = @canvas.backColor
        dc.fillRectangle(event.rect.x, event.rect.y, event.rect.w,  event.rect.h)
      end
    end
   end
  self.instance_variables
#self.connect(SEL_PAINT) do |sender, sel, event|
end
