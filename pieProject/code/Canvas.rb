$LOAD_PATH << '.'
require 'fox16'
require 'BrushPanel.rb'

include Fox

class Canvas
  
  attr_reader :contents, :canvas_frame, :drawColor, :mouseDown, :dirty, :canvas, :dc
  attr_writer :drawColor, :mouseDown, :dirty
  
  def initialize(p, opts, x, y, width, height, padLeft, padRight, padTop, padBottom)
    @contents = FXHorizontalFrame.new(p, opts, x, y, width, height,
     padLeft, padRight, padTop, padBottom)
    
    @canvas_frame = FXVerticalFrame.new(@contents,FRAME_SUNKEN|LAYOUT_FILL_X|LAYOUT_FILL_Y|LAYOUT_TOP|LAYOUT_LEFT, 
   0, 0, 0, 0, 0, 0, 0, 0) 
    
    @canvas = FXCanvas.new(@canvas_frame, nil, 0, LAYOUT_FILL_X|LAYOUT_FILL_Y|LAYOUT_TOP|LAYOUT_LEFT, 0, 0, 0, 0)
  
    @drawColor = FXRGB(0, 0, 0) #Set initial draw color to black
    @mouseDown = false
    @dirty = false
    @brushWidth = 10
    @brushHeight = 1
    @brushSize = 1  
    
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
        
        
        if @brushSize == 1 || @brushSize == 2 || @brushSize == 3
          dc.drawLine(event.last_x, event.last_y, event.win_x, event.win_y)
        end
        if @brushSize == 2
          
          i=0
          while i < 10
              dc.drawLine(event.last_x+i, event.last_y, event.win_x+i, event.win_y)
              dc.drawLine(event.last_x, event.last_y+i, event.win_x, event.win_y+i)
              dc.drawLine(event.last_x+i, event.last_y+i, event.win_x+i, event.win_y+i)
              dc.drawLine(event.last_x+i, event.last_y+i, event.win_x, event.win_y)
              dc.drawLine(event.last_x, event.last_y, event.win_x+i, event.win_y+i)
              dc.drawLine(event.last_x+i, event.last_y, event.win_x, event.win_y+i)
              dc.drawLine(event.last_x, event.last_y+i, event.win_x+i, event.win_y)
              dc.drawLine(event.last_x, event.last_y+i, event.win_x+i, event.win_y+i)
              dc.drawLine(event.last_x+i, event.last_y+i, event.win_x+i, event.win_y)
              i += 1
           end
        end
        if @brushSize == 3 || @brushSize == 5
            i=0
            while i < 30
               dc.drawLine(event.last_x+i, event.last_y, event.win_x+i, event.win_y)
               dc.drawLine(event.last_x, event.last_y+i, event.win_x, event.win_y+i)
               dc.drawLine(event.last_x+i, event.last_y+i, event.win_x+i, event.win_y+i)
               dc.drawLine(event.last_x+i, event.last_y+i, event.win_x, event.win_y)
               dc.drawLine(event.last_x, event.last_y, event.win_x+i, event.win_y+i)
               dc.drawLine(event.last_x+i, event.last_y, event.win_x, event.win_y+i)
               dc.drawLine(event.last_x, event.last_y+i, event.win_x+i, event.win_y)
               dc.drawLine(event.last_x, event.last_y+i, event.win_x+i, event.win_y+i)
               dc.drawLine(event.last_x+i, event.last_y+i, event.win_x+i, event.win_y)
               i += 1
             end
        end
        if @brushSize == 4
          dc.foreground = @drawColor
          dc.fillRectangle(event.rect.x, event.rect.y, event.rect.w + @canvas.width,  event.rect.h + @canvas.height)
        end
        if @brushSize == 6
            i=0
            while i < 10
                dc.drawLine(event.last_x+i, event.last_y+i, event.win_x+i, event.win_y+i)
                 i += 1
            end
        end

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
   
   def setBrushSize(size)
        puts("Brush size updated")
        @brushSize = size
   end
   
   def setDrawColor(color)
      puts("draw color set to " + color)
      @drawColor = color
   end

   def getDrawColor()
     return @drawColor
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
   
   def setDrawColorViaRGBObject(color)
     @drawColor = color
   end
  self.instance_variables
#self.connect(SEL_PAINT) do |sender, sel, event|
end
