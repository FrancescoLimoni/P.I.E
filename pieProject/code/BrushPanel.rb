require 'fox16'
require 'Canvas.rb'

include Fox

class BrushPanel < FXPacker
  def initialize(parent,opts,x,y,width,height, c)
    super(parent, opts, x, y, width, height)
    
    @canvas_window = c
    @eraserSelect = false

    #Upload PNG images to be used# 
    @lastDrawColor = @canvas_window.getDrawColor()
    
    #Upload PNG images to be used#
    b1 = loadIcon("BrushIcon1.png")
    b2 = loadIcon("BrushIcon2.png")
    b3 = loadIcon("BrushIcon3.png")
    b4 = loadIcon("BrushIcon4.png")
    b5 = loadIcon("EraserIcon.png")
    b6 = loadIcon("InkPenIcon.png")
    


    #Display images as clickable buttons#

    vframe = FXGroupBox.new(self, "Brush", GROUPBOX_TITLE_CENTER|FRAME_RIDGE|LAYOUT_FILL)
    vframe.backColor = "Gray69"

    brush1 = FXButton.new(vframe, "\t1 x 1", b1, :opts => LAYOUT_CENTER_X)
      brush1.buttonStyle |= BUTTON_TOOLBAR
      brush1.frameStyle = FRAME_RAISED
      brush1.backColor = "Gray69"
    brush2 = FXButton.new(vframe, "\t2 x 2", b2, :opts => LAYOUT_CENTER_X)
      brush2.buttonStyle |= BUTTON_TOOLBAR
      brush2.frameStyle = FRAME_RAISED
      brush2.backColor = "Gray69"
    brush3 = FXButton.new(vframe, "\t3 x 3", b3, :opts => LAYOUT_CENTER_X)
      brush3.buttonStyle |= BUTTON_TOOLBAR
      brush3.frameStyle = FRAME_RAISED
      brush3.backColor = "Gray69"
    brush6 = FXButton.new(vframe, "\tInk Pen", b6, :opts => LAYOUT_CENTER_X)
      brush6.buttonStyle |= BUTTON_TOOLBAR
      brush6.frameStyle = FRAME_RAISED
      brush6.backColor = "Gray69"
    brush4 = FXButton.new(vframe, "\tFill", b4, :opts => LAYOUT_CENTER_X)
      brush4.buttonStyle |= BUTTON_TOOLBAR
      brush4.frameStyle = FRAME_RAISED
      brush4.backColor = "Gray69"
    brush5 = FXButton.new(vframe, "\tEraser", b5, :opts => LAYOUT_CENTER_X)
          brush5.buttonStyle |= BUTTON_TOOLBAR
          brush5.frameStyle = FRAME_RAISED
          brush5.backColor = "Gray69"
      
    brush1.connect(SEL_COMMAND) do
      if @eraserSelect == true
        @canvas_window.setDrawColorViaRGBObject(@lastDrawColor)
        @eraserSelect = false
      end
      @canvas_window.setBrushSize(1)
      puts ("Set brush to type 1 (1x1)")
    end
    brush2.connect(SEL_COMMAND) do
      if @eraserSelect == true
            @canvas_window.setDrawColorViaRGBObject(@lastDrawColor)
            @eraserSelect = false
      end
      @canvas_window.setBrushSize(2)
      puts ("Set brush to type 2 (10x10)")
    end
    brush3.connect(SEL_COMMAND) do
      if @eraserSelect == true
            @canvas_window.setDrawColorViaRGBObject(@lastDrawColor)
            @eraserSelect = false
      end
      @canvas_window.setBrushSize(3)
      puts ("Set brush to type 3 (30x30)")
    end
    brush4.connect(SEL_COMMAND) do
      if @eraserSelect == true
            @canvas_window.setDrawColorViaRGBObject(@lastDrawColor)
            @eraserSelect = false
      end
      @canvas_window.setBrushSize(4)
          puts ("Set brush to type 4 (fill)")
    end
    brush5.connect(SEL_COMMAND) do
        @eraserSelect = true
        @canvas_window.setBrushSize(5)
        @lastDrawColor = @canvas_window.getDrawColor()
        @canvas_window.setDrawColor("White")
        puts ("Set brush to type 5 (eraser)")
    end
  brush6.connect(SEL_COMMAND) do
     if @eraserSelect == true
          @canvas_window.setDrawColorViaRGBObject(@lastDrawColor)
          @eraserSelect = false
     end
     @canvas_window.setBrushSize(6)
  end
end
           
  
  def loadIcon(filename)
    begin
      filename = File.join("icons", filename)
      icon = nil
      File.open(File.expand_path(File.dirname(__FILE__)).tap {|pwd| $LOAD_PATH.unshift(pwd) unless $LOAD_PATH.include?(pwd)}+"/"+filename, "rb") do |f|
        icon = FXPNGIcon.new(getApp(), f.read)
      end
      icon
    rescue
      raise RuntimeError, "Couldn't load icon: #{filename}"
    end
  end
  
 end
