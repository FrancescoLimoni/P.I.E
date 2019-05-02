
$LOAD_PATH << '.'
require 'fox16'
require 'BrushPanel.rb'
require 'layerPanel.rb'
include Fox

class Canvas
  
  attr_reader :contents, :canvas_frame, :drawColor, :mouseDown, :dirty, :canvas, :dc
  attr_writer :drawColor, :mouseDown, :dirty
  
  def initialize(p, opts, x, y, width, height, padLeft, padRight, padTop, padBottom, app)
  
    @parentApp = app
    
    @drawColor = FXRGB(255, 0, 0) #variable that stores the active draw color
    @mouseDown = false            #checks if mouse is depressed
    #@dirty = false                #Checks if canvas has data in it
    @brushSize = 1                #stores the active brush size
    @parent = p                   #stores the parent app for object initialization
    @canvasWidth = width          #stores the current canvas width
    @canvasHeight = height        #stores the current canvas height
    
    @layerArray = Array.new       #stores hide/show state of each layer.
    @imageArray = Array.new       #stores the image data of each layer.
    @dirtyArray = Array.new       #stores the dirty status of each layer.
    @activeIndex = 0
    
    @saved = false
    @savePath = ""

    #The frame that stores teh verticle frame. 
    @parentFrame = FXHorizontalFrame.new(p, opts, x, y, width, height,     
     padLeft, padRight, padTop, padBottom)
    #Canvas Frame is the vertical frame that stores the canvas.
    @canvas_frame = FXVerticalFrame.new(@parentFrame,FRAME_SUNKEN|LAYOUT_FILL_X|LAYOUT_FILL_Y|LAYOUT_TOP|LAYOUT_LEFT, 
    0, 0, 0, 0, 0, 0, 0, 0) 
    
    #Image stores the image data that is saved.
    @exportImage = FXPNGImage.new(app, nil, width, height)
    @exportImage.create                 #initializes the image object.
    @exportImage.resize(@canvasWidth, @canvasHeight)  #Sets the image to match canvas width and height
    
    #Stores the image that is in the active layer.
    createImage()
    @activeImage = @imageArray[@activeIndex]
    
    
    #canvas stores the canvas object that is draw on.
    @canvas = FXCanvas.new(@canvas_frame, nil, 0, LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT|LAYOUT_TOP|LAYOUT_LEFT, 0, 0, width, height) 
   
    #On creation, connect to the SEL_Paint handler. Every time the canvas changes, the canvas is repainted.
    @canvas.connect(SEL_PAINT, method(:onCanvasRepaint))
    
    @canvas.resize(@canvasWidth, @canvasHeight)  #Sets the canvas to the default width and height.
    
    #Event handler that checks for left mouse button depression. 
    @canvas.connect(SEL_LEFTBUTTONPRESS) do |sender, sel, event|
      
      @canvas.grab                  #grabs the canvas. Windows stores mouse data when mouse is inside canvas.
      @mouseDown = true             #The mouse is depressed. Set mouseDown to true.
      
      # Get device context for the canvas
        dc = FXDCWindow.new(@activeImage)

        # Set the foreground color for drawing
        dc.foreground = @drawColor
        #dc.fillRectangle(event.win_x, event.win_y, 2, 2)
      
      if @mouseDown                 #make sure mouse is down.
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
        @dirtyArray[@activeIndex] = true
        @canvas.update
        # Release the DC immediately
        dc.end
      end
    end
    
    @canvas.connect(SEL_MOTION) do |sender, sel, event|
      if @mouseDown
        # Get device context for the canvas
        dc = FXDCWindow.new(@activeImage)

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
        @dirtyArray[@activeIndex] = true
        @canvas.update
        # Release the DC immediately
        dc.end
      end
    end
    
    @canvas.connect(SEL_LEFTBUTTONRELEASE) do |sender, sel, event|
      @canvas.ungrab
      @mouseDown = false
      @canvas.update
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
   
   def onCanvasRepaint(sender, sel, event)
      sdc = FXDCWindow.new(@canvas, event)
      sdc.foreground = FXRGB(255, 255, 255)
      sdc.fillRectangle(0, 0, @canvas.width, @canvas.height)
      if !@dirtyArray[@activeIndex]
        dc = FXDCWindow.new(@activeImage)
        dc.fillRectangle(0, 0, @canvas.width, @canvas.height)
        dc.end   
      end
      index = @layerArray.length()
      while index >= 0
        if @layerArray[index] == false
          if @dirtyArray[index] == true
            sdc.drawImage(@imageArray[index], 0, 0)
          end
        end
        index = index - 1

      end
      dc.end
    end
      
    def createImage()
      i = 0
      while (i < 5) do
        newImage = FXPNGImage.new(@parentApp, nil, @canvasWidth, @canvasHeight)
        newImage.create                 #initializes the image object.
        newImage.resize(@canvasWidth, @canvasHeight)  #Sets the image to match canvas width and height
        dc = FXDCWindow.new(newImage)
        dc.foreground = FXRGB(255,255,255)
        dc.fillRectangle(0,0, @canvasWidth, @canvasHeight)
        dc.end
        @imageArray.push(newImage)      #push the image into the imageArray for storage.
        @layerArray.push(false)
        @dirtyArray.push(false)
        puts("Create image")
        i = i + 1

      end
      dc.end
    end
    
    def resizeCanvas(w,h)
      
      @canvasHeight = h             #Set the canvas height
      @canvasWidth = w              #Set the canvas width
      
      @layerArray = Array.new       #Reset the layer array
      @imageArray = Array.new       #Reset the image array
      @dirtyArray = Array.new       #Reset the dirty array
      @activeIndex = 0              #Reset the active index
      createImage()                 #Push a blank image data.
      @activeImage = @imageArray[@activeIndex]  #Update active index to default.
      @canvas.update                #Update the draw canvas to reflect changes.
    end
    
    def newCanvas
      @layerArray = Array.new       #Reset the layer array
      @imageArray = Array.new       #Reset the image array
      @dirtyArray = Array.new       #Reset the dirty array
      @activeIndex = 0              #Reset the active index
      createImage()                 #Push a blank image data.
      @activeImage = @imageArray[@activeIndex]  #Update active index to default.
      @canvas.update                #Update the draw canvas to reflect changes.
    end
    

    def clear(i)
      newImage = FXPNGImage.new(@parentApp, nil, @canvasWidth, @canvasHeight)
      newImage.create                 #initializes the image object.
      newImage.resize(@canvasWidth, @canvasHeight)  #Sets the image to match canvas width and height
      dc = FXDCWindow.new(newImage)
      dc.foreground = FXRGB(255,255,255)
      dc.fillRectangle(0,0, @canvasWidth, @canvasHeight)
      dc.end
      @imageArray[i] = newImage
    end
    
    def setActiveIndex(i)
      @activeIndex = i;
      @activeImage = @imageArray[@activeIndex]
    end
    
    def load
      loadDialog = FXFileDialog.new(@parent, "Load PNG Image")
      if loadDialog != 0
        FXFileStream.open(loadDialog.filename, FXStreamLoad) do |infile|
          @imageArray[@activeIndex].loadPixels(infile)
        end
      end
    end
    
    def quickSave
      sdc = FXDCWindow.new(@exportImage)
      sdc.foreground = FXRGB(255, 255, 255)
      sdc.fillRectangle(0, 0, @canvas.width, @canvas.height)
      
      index = @layerArray.length()
      while index >= 0
        if @dirtyArray[index] == true
          sdc.drawImage(@imageArray[index], 0, 0)
        end
        index = index - 1
      end
      sdc.end
      
      if @saved
        File.open(@savePath, "PIE Image") do |io|
          @exportImage.restore
          @exportImage.savePixels(io)
        end
      end
      return 1
    end
    
    def save
      

      sdc = FXDCWindow.new(@exportImage)
      sdc.foreground = FXRGB(255, 255, 255)
      sdc.fillRectangle(0, 0, @canvas.width, @canvas.height)
      
      index = @layerArray.length()
      while index >= 0
        if @dirtyArray[index] == true
          sdc.drawImage(@imageArray[index], 0, 0)
        end
        index = index - 1
      end
      sdc.end
      
      saveDialog = FXFileDialog.new(@parent, "Save as PNG")
      if saveDialog.execute != 0
        FXFileStream.open(saveDialog.filename, FXStreamSave) do |outfile|
          @exportImage.restore
          @exportImage.savePixels(outfile)
          @savePath = saveDialog.directory

        end
      end
      return 1
    end
  
  self.instance_variables
end
