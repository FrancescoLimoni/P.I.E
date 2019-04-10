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
   0, 0, 0, 0, 0, 0, 0, 0) 
    
    @canvas = FXCanvas.new(@canvas_frame, nil, 0, LAYOUT_FILL_X|LAYOUT_FILL_Y|LAYOUT_TOP|LAYOUT_LEFT, 0, 0, 0, 0,) 
  
  
  
    @drawColor = FXRGB(255, 0, 0)
    @mouseDown = false
    @dirty = false
    @brushWidth = 10
    @brushHeight = 1     
    
    @canvas.connect(SEL_PAINT) do |sender, sel, event|
      FXDCWindow.new(@canvas,event) do |dc|
        dc.foreground = @canvas.backColor
        dc.fillRectangle(event.rect.x, event.rect.y, event.rect.w,  event.rect.h)
      end
    end
    @canvas.connect(SEL_LEFTBUTTONPRESS) do
      @canvas.grab
      @mouseDown = true
      if @mousedown
        dc = FXDCWindow.new(@canvas)
        dc.foreground = @drawcolor
        dc.drawPoint(event.last_x, event.last_y)
        @dirty = true
        dc.end
      end
    end
    @canvas.connect(SEL_MOTION) do |sender, sel, event|
      if @mouseDown
        # Get device context for the canvas
        dc = FXDCWindow.new(@canvas)

        # Set the foreground color for drawing
        dc.foreground = @drawColor
        
        #dc.fillRectangle(event.win_x, event.win_y, 2, 2)
        dc.drawLine(event.last_x, event.last_y, event.win_x, event.win_y)

        # We have drawn something, so now the canvas is dirty
        @dirty = true

        # Release the DC immediately
        dc.end
      end
    end
    
    @canvas.connect(SEL_LEFTBUTTONRELEASE) do |sender, sel, event|
      @canvas.ungrab
      if @mouseDown
        dc = FXDCWindow.new(@canvas)
        dc.foreground = @drawColor
        dc.drawPoint(event.last_x, event.last_y)
        # Mouse no longer down
        @mouseDown = false
        dc.end
      end
    end
   end
      def setDrawColor(color)
      puts("draw color set to " + color)
      @drawColor = color
   end

    def setDrawColorViaRGB(r, g, b)
      while r > 255
          r -= 255
      end
      while g > 255
          g -= 255
      end
      while b > 255
          b -= 255
      end
      puts("draw color set to RGB values: (" + r.to_s + ", " + g.to_s + ", " + b.to_s + ")")
         @drawColor = FXRGB(r, g, b)
    end
  self.instance_variables
#self.connect(SEL_PAINT) do |sender, sel, event|
end
