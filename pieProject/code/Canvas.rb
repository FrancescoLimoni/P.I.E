#************************************************************************************
  #       Created by Dustin Shaver, Jacob Watters
  #
  #       Canvas Class for the Pixel Image Editor (P.I.E):
  #        
  #        Purpose: Stores image data, impliments the canvas object to be drawn on,
  #             and defines event handlers to connect the canvas to the color panel,
  #             menu panel, brush panel, splash screen, and Windows OS for draw motion,
  #             color select, and canvas editing/resizing.
  #       
  #       Contact us at :https://github.com/DustinShaver or at https://github.com/FrancescoLimoni/P.I.E
  #************************************************************************************
  
$LOAD_PATH << '.'
require 'fox16'                 #requires the FOX16(FXRuby package)
require 'BrushPanel.rb'         #Requires Brush Panel File in the local package
require 'layerPanel.rb'         #Requires layer Panel file in the local package
include Fox                     #Includes the Fox package

class Canvas      #Canvas class. See purpose above.
  
  attr_reader :contents, :canvas_frame, :drawColor, :mouseDown, :dirty, :canvas, :dc  #getter functions for instance variables
  attr_writer :drawColor, :mouseDown, :dirty                                          #setter functions for instance variables
  #************************************************************************************
  #       Description for intilization paramaters:
  #       
  #       p = parent packer, opts = options, x = x-coordinate, y = y coordinate, 
  #       width = canvasWidth, height = canvas height, 
  #       padLeft = left edge canvas distance from frame, 
  #       padRight = right edge of canvas distance from frame, 
  #       padTop = top most edge of canvas distance from frame, 
  #       padBottom = bottome most edge distance from frame, 
  #       app = parent application.
  #************************************************************************************
  def initialize(p, opts, x, y, width, height, padLeft, padRight, padTop, padBottom, app)
  
    @parentApp = app              #Stores the parent app for the initialization of image data later in the code.
    
    @drawColor = FXRGB(255, 0, 0) #variable that stores the active draw color
    @mouseDown = false            #checks if mouse is depressed
    #@dirty = false               #Checks if canvas has data in it
    @brushSize = 1                #stores the active brush size
    @parent = p                   #stores the parent app for object initialization
    @canvasWidth = width          #stores the current canvas width
    @canvasHeight = height        #stores the current canvas height
    
    @layerArray = Array.new       #stores hide/show state of each layer.
    @imageArray = Array.new       #stores the image data of each layer.
    @dirtyArray = Array.new       #stores the dirty status of each layer.
    @activeIndex = 0
    
    @saved = false                #Checks if the image has been saved.
    @savePath = ""                #Stores the image save path

    #The horitzontal frame that stores the verticle frame. 
    @parentFrame = FXHorizontalFrame.new(p, opts, x, y, width, height,     
     padLeft, padRight, padTop, padBottom)
     
    #Canvas Frame is the vertical frame that stores the canvas.
    @canvas_frame = FXVerticalFrame.new(@parentFrame,FRAME_SUNKEN|LAYOUT_FILL_X|LAYOUT_FILL_Y|LAYOUT_TOP|LAYOUT_LEFT, 
    0, 0, 0, 0, 0, 0, 0, 0) 
    
    #exportImage stores the image data that is saved.
    @exportImage = FXPNGImage.new(app, nil, @canvasWidth, @canvasHeight)
    
    @exportImage.create                               #initializes the image object.
    @exportImage.resize(@canvasWidth, @canvasHeight)  #Sizes the image to match canvas width and height
   
    #Stores the image that is in the active layer.
    createImage()                                     #Calls the createImage method. 
    @activeImage = @imageArray[@activeIndex]          #Sets the active image to the image stored in the first index of the imageArray
    
    
    #canvas stores the canvas object that is draw on.
    @canvas = FXCanvas.new(@canvas_frame, nil, 0, LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT|LAYOUT_TOP|LAYOUT_LEFT, 0, 0, width, height) 
   
    #On creation, connect to the SEL_Paint handler. Every time the canvas changes, the canvas is repainted.
    @canvas.connect(SEL_PAINT, method(:onCanvasRepaint))
 
    @canvas.resize(@canvasWidth, @canvasHeight)  #Sets the canvas to the default width and height.
    
    #Event handler that checks for left mouse button depression. 
    @canvas.connect(SEL_LEFTBUTTONPRESS) do |sender, sel, event|
      
    @canvas.grab                  #grabs the canvas. Windows stores mouse data when mouse is inside canvas.
    @mouseDown = true             #The mouse is depressed. Set mouseDown to true.
      
    #Get device context for the canvas
    dc = FXDCWindow.new(@activeImage)

    # Set the foreground color for drawing
    dc.foreground = @drawColor
    #dc.fillRectangle(event.win_x, event.win_y, 2, 2)
      
    #Defines draw alogrithms for a single click or "Point edit" on the canvas.  
    if @mouseDown                   #make sure mouse is down.
    if @brushSize == 1 || @brushSize == 2 || @brushSize == 3                  #If any of the square draw brushes 
      dc.drawLine(event.last_x, event.last_y, event.win_x, event.win_y)       #draw a line from the x,y coordinate of mouse depression to latest x,y coordinate.
    end
    if @brushSize == 2                                                        #If brush two...
          
    i=0
      while i < 10                                                            #Draw a series of lines within a 10X10 pixel square onto canvas.
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
     
     if @brushSize == 3 || @brushSize == 5                                  #Draw a series of lines within a 30X30 pixel square onto canvas.
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
      if @brushSize == 4                                                   #Paint bucket fills the entire canvas with current draw color.
        dc.foreground = @drawColor
        dc.fillRectangle(event.rect.x, event.rect.y, event.rect.w + @canvas.width,  event.rect.h + @canvas.height)
      end
      if @brushSize == 6                                                   #Draws a white line of size 10X10 over any draw data.(Eraser handler)
        i=0
        while i < 10
          dc.drawLine(event.last_x+i, event.last_y+i, event.win_x+i, event.win_y+i)
            i += 1
        end
      end

      
      @dirtyArray[@activeIndex] = true                                    # Since there is draw data in the active image, set the image's dirty value to true.
      @canvas.update                                                      #Redraw the canvas to display the image data changes onto the canvas.
      # Release the DC immediately
      dc.end
      end
    end
    
    @canvas.connect(SEL_MOTION) do |sender, sel, event|                   #On mouse motion.
      if @mouseDown
        # Get device context for the canvas
        dc = FXDCWindow.new(@activeImage)

        # Set the foreground color for drawing
        dc.foreground = @drawColor
        
        
        #While there is mouse motion, continue to repeat the same draw algorithms as for single points
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
    
    @canvas.connect(SEL_LEFTBUTTONRELEASE) do |sender, sel, event|            #On left mouse release
      @canvas.ungrab                                                          #Remove canvas device draw context
      @mouseDown = false                                                      #Set mouse down to false
      @canvas.update                                                          #Redraw the canvas to reflect changes in image data
    end
   end
   
   #Sets the brush size to the specified value.
   def setBrushSize(size)
        puts("Brush size updated")    
        @brushSize = size
   end
   
   #Sets draw color to an FXRGB value in "color" paramater
   def setDrawColor(color)
      puts("draw color set to " + color)
      @drawColor = color
   end

  #Getter for the active draw color. Needed to store color when the eraser brush is active.
   def getDrawColor()
     return @drawColor
   end
   
   #Sets the active draw color based on R,G,B vales.
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
   
   #Sets the draw color via and RGB Object.
   def setDrawColorViaRGBObject(color)
     @drawColor = color
   end

   #Getter for canvasWidth
   def getCanvasWidth
    return @canvasWidth
   end

  #Getter for canvasHegith
   def getCanvasHeight
    return @canvasHeight
   end
   
   #Determines what happens when the canvas needs to be redrawn.
   def onCanvasRepaint(sender, sel, event)
      sdc = FXDCWindow.new(@canvas, event)                      #dc object handles OS display to redraw monitor pixels on #drawable objects.
      if !@dirtyArray[@activeIndex]                             #Checks for pixel data in the active image.
        sdc.foreground = FXRGB(255, 255, 255)                   #Sets foreground color of the canvas to white.
        sdc.fillRectangle(0, 0, @canvas.width, @canvas.height)  #Populates the canvas with white data.

        dc = FXDCWindow.new(@activeImage)                       #Grab the active image.
        dc.fillRectangle(0, 0, @canvas.width, @canvas.height)   #Populates the active image with white pixel data.
        dc.end                                                  #closes the dc object to close thread and save resources.
      end
      
      index = @layerArray.length()                              #Create an index pointer that points to the last index of the layer array.
      
      while index >= 0                                          #Cycle through the layer array from back to front.
        if index == @layerArray.length()                        #Paint the canvas white before drawing images to the canvas. (Flushes the canvas)
          sdc.foreground = FXRGB(255, 255, 255)                 
          sdc.fillRectangle(0, 0, @canvas.width, @canvas.height)
        end
       
        if @layerArray[index] == false                          #If the layer is not hidden
          if @dirtyArray[index] == true                         #If the layer contains data
            sdc.drawImage(@imageArray[index], 0, 0)             #Draw the image onto the canvas.
          end
        end
        index = index - 1                                       #Decriment the index.

      end
      sdc.end
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
        newImage.restore
        @imageArray.push(newImage)      #push the image into the imageArray for storage.
        @layerArray.push(false)
        @dirtyArray.push(false)
        puts("Create image")
        i = i + 1

      end
      dc.end
      @activeImage = @imageArray[0]
    end
    
    #Resizes the canvas by clearing all previous user data and resizes image data and canvas data to match the new dimensions.
    def resizeCanvas(w,h)
      puts("resizing canvas")
      puts(w,h)
      @canvasHeight = h             #Set the canvas height
      @canvasWidth = w              #Set the canvas width
      @canvas.resize(w,h)
      @exportImage = FXPNGImage.new(@parentApp, nil, @canvasWidth, @canvasHeight)
      @exportImage.create                 #initializes the image object.
      @exportImage.resize(@canvasWidth, @canvasHeight)  #Sets the image to match canvas width and height
      @layerArray = Array.new       #Reset the layer array
      @imageArray = Array.new       #Reset the image array
      @dirtyArray = Array.new       #Reset the dirty array
      @activeIndex = 0              #Reset the active index
      createImage()                 #Push a blank image data.
      @activeImage = @imageArray[@activeIndex]  #Update active index to default.
      @canvas.update                #Update the draw canvas to reflect changes.
    end
    #Creates a new canvas by clearing all previous user data image data.
    def newCanvas
      @layerArray = Array.new       #Reset the layer array
      @imageArray = Array.new       #Reset the image array
      @dirtyArray = Array.new       #Reset the dirty array
      @activeIndex = 0              #Reset the active index
      @exportImage = FXPNGImage.new(@parentApp, nil, @canvasWidth, @canvasHeight)
      @exportImage.create                 #initializes the image object.
      @exportImage.resize(@canvasWidth, @canvasHeight)  #Sets the image to match canvas width and height
      createImage()                 #Push a blank image data.
      @activeImage = @imageArray[@activeIndex]  #Update active index to default.
      @canvas.update                #Update the draw canvas to reflect changes.
    end
    
    #Empties the selected layers image data.
    def clear(i)
      newImage = FXPNGImage.new(@parentApp, nil, @canvasWidth, @canvasHeight)   #Creates a new image object
      newImage.create                                                           #initializes the image object.
      newImage.resize(@canvasWidth, @canvasHeight)                              #Sizes the image to match canvas width and height
      dc = FXDCWindow.new(newImage)
      dc.foreground = FXRGB(255,255,255)
      dc.fillRectangle(0,0, @canvasWidth, @canvasHeight)                        #Populates the image with white pixels.
      dc.end
      @imageArray[i] = newImage                                                 #Push the cleared image onto the image array, overwriting the old image data.
      @canvas.update                                                            #Redraw the canvas to reflect changes to user data
      @activeImage = @imageArray[@activeIndex]                                  #Update active index to default.
    end
    
    #Setter for the active index.
    def setActiveIndex(i)
      @activeIndex = i;
      @activeImage = @imageArray[@activeIndex]
    end
    
    #Load image data into the canvas object
    def load              
      puts('loading PNG')                                     
      loadDialog = FXFileDialog.new(@parent, "Load PNG Image")                      #Creates a file dialog window
      if loadDialog.execute != 0                                                    #Checks integrity of the dialog 
        FXFileStream.open(loadDialog.filename, FXStreamLoad) do |infile|            #Creates a file stream
          tempImage = FXPNGImage.new(@parentApp,nil, @canvasWidth, @canvasHeight)   #Creates a temporary image file
          tempImage.loadPixels(infile)                                              #Loads pixel data from desired file into the temporary image file
          if tempImage.width != @canvasWidth || tempImage.height != @canvasheight   #Checks if image dimensions match the canvas dimensions
            tempImage.scale(@canvasWidth, @canvasHeight)                            #If no match, scale the image to attempt to match the canvas dimensions.
          end
          
          @activeImage.setPixels(tempImage.pixel_string())                          #Set the pixels in the active image to match the imported iamge.
          @activeImage.render                                                       #Create the neccessary client side image data.
          @canvas.update                                                            #Redraw the canvas to reflect changes to user data.
        end
      end
    end
    
    #Event handler for the quicksave button in the menu.
    def quickSave
      puts "quick save"
      sdc = FXDCWindow.new(@exportImage)                          #Select the exportImage object
      sdc.foreground = FXRGB(255, 255, 255)
      sdc.fillRectangle(0, 0, @canvas.width, @canvas.height)      #Paint the exportImage white("Flush the image")
      
      index = @layerArray.length()                                #Index is a pointer that starts at the end of the layer array
      while index >= 0
        if @dirtyArray[index] == true
          sdc.drawImage(@imageArray[index], 0, 0)                 #The while loop goes index by index in the image array and if data exists, it draws it onto the exportImage.
        end
        index = index - 1
      end
      sdc.end
        
      if @saved                                                   #Checks if the user has previously saved data using the file dialog save.
        
        FXFileStream.open(@savePath, FXStreamSave) do |outfile|   #Open a file stream
          @exportImage.restore                                    #Ensure exportImage data is allocated
          @exportImage.savePixels(outfile)                        #Save the image data to the stored savePath int the event that a long save has previously occured, overwriting the previous image.
        end
      end
      return 1
    end
    
    #Redraw the canvas object to reflect image changes.
    def updateCanvas
      canvas.update
    end
    
    #Sets the layer of the index selected from the layer panel to hidden or not hidden. False = not hidden. True = hidden.
    def setHidden(index)
      if @layerArray[index] == false
        @layerArray[index] = true
      else
        @layerArray[index] = false
      end
      @canvas.update
    end
    
    #Save method that defines the long save from the long save button for save from the drop down file menu.
    def save
      
      sdc = FXDCWindow.new(@exportImage)                      #Select the export Image
      sdc.foreground = FXRGB(255, 255, 255)
      sdc.fillRectangle(0, 0, @canvasWidth, @canvasHeight)    #Flush the export Image.
      
      index = @layerArray.length()                            #Pointer that starts at the end of the layer array.
      while index >= 0
        if @dirtyArray[index] == true
          sdc.drawImage(@imageArray[index], 0, 0)             #If the layer has image data, merge that image data with the export image.
        end
        index = index - 1
      end
      sdc.end
      
      saveDialog = FXFileDialog.new(@parent, "Save as PNG")               #Create a save dialog
      if saveDialog.execute != 0                                          #Check Save dialog Intregrity
        FXFileStream.open(saveDialog.filename, FXStreamSave) do |outfile|
          @exportImage.restore                                            #Ensure image data has been allocated
          @exportImage.savePixels(outfile)                                #Save the pixels in export Image to the specified loction in the file dialog.
          @saved = true                                                   #Since a long save has occured, quick save should now overwrite long save data
          temp = saveDialog.filename
          @savePath = File.basename(temp)                                 #Store the file name for the quicksave method.
          puts(@savePath)

        end
      end
      return 1
    end
  
  self.instance_variables                                                 #Creates getter and setter methods for chosen attr_read/Write Instance variable.s
end
