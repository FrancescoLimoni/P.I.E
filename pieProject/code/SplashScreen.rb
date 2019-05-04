require 'fox16'

include Fox

class SplashScreen < FXPacker
  def initialize(parent,opts)
    super
    #visible or not status
    @status = true
    @hideElements = Array.new
    #in order to make the elments re-apear, the window must be resized as well as invoking .show method
    @resizeHack = nil
    #default canvas size
    @intTargetX = FXDataTarget.new(900)
    @intTargetY = FXDataTarget.new(850)
    @canvasRefrance = nil

    splashIcon = loadIcon("pie.png",0)

    #layout for btn1
    vframe = FXGroupBox.new(self, "ready to bake", GROUPBOX_TITLE_CENTER|FRAME_RIDGE|LAYOUT_FILL)
    vframe.backColor = "Gray69"
    #vframe.hide
    #layout for btn2
    vframe2 = FXHorizontalFrame.new(vframe, LAYOUT_CENTER_X)
    vframe2.backColor = "Gray69"
    
    #start btn
    btn = FXButton.new(vframe, "\t click to begin", splashIcon, :opts => LAYOUT_CENTER_X)
    btn.buttonStyle |= BUTTON_TOOLBAR
    btn.frameStyle = FRAME_RAISED
    btn.backColor = "Gray69"
    #btn.hide
    #resize btn 
    resizeBtn = FXButton.new(vframe2, "\t click to begin", loadIcon("scaling.png",25), :opts => LAYOUT_CENTER_Y|LAYOUT_CENTER_X|LAYOUT_FILL_ROW)
    resizeBtn.buttonStyle |= BUTTON_TOOLBAR
    resizeBtn.frameStyle = FRAME_RAISED
    resizeBtn.backColor = "Gray69"
    #resizeBtn.hide
    #input tedt field
    FXLabel.new(vframe2, "&Width", nil,LAYOUT_CENTER_Y)
    FXTextField.new(vframe2, 4, @intTargetX, FXDataTarget::ID_VALUE,LAYOUT_CENTER_Y|FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL_ROW)
    FXLabel.new(vframe2, "&Height", nil,LAYOUT_CENTER_Y)
    FXTextField.new(vframe2, 4, @intTargetY, FXDataTarget::ID_VALUE,LAYOUT_CENTER_Y|FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL_ROW)


    def getStatus
      return @status
    end

    #get access for canvas class
    def canvasFreindFunction(canvasRef)
      @canvasRefrance = canvasRef
      #setDimensions
    end

    #get defult height and width that is defined in canvas constructor
    def setDimensions
      @intTargetX = @canvasRefrance.getCanvasWidth
      @intTargetY = @canvasRefrance.getCanvasHeight
    end

    #call resize method from canvas cllass
    def setCanvasSize
      if @intTargetX.to_s.to_i > @canvasRefrance.getCanvasWidth.to_s.to_i and @intTargetY.to_s.to_i > @canvasRefrance.getCanvasHeight.to_s.to_i
        puts('setting new dimetions')
        @canvasRefrance.resizeCanvas(@intTargetX.to_s.to_i,@intTargetY.to_s.to_i)
      else 
        puts('setting defult dimentions')
      end
    end

    #add UI objects to an array and hide them
    def addHideElement(element,window)

      @resizeHack = window
      @hideElements.push(element)

      hideElements

    end

    #show all elements of the app
    def showElements 
      @hideElements.each do |element|
        element.show
      end
      @resizeHack.resize(800,500)
    end

    #hide all elements of app except of splashscreen elements
    def hideElements 
      @hideElements.each do |element|
        element.hide
      end
    end

    #this object is when onther function calls this method
    #it will do what btn.connect does
    def forFriendfunctions
      @status = false
      self.hide
      showElements
    end

    btn.connect(SEL_COMMAND) do
      toggleShowSplashScreen
    end

  def toggleShowSplashScreen
    if @status == false
      @status = true
      self.show
      #setCanvasSize
      hideElements
      @resizeHack.resize(400,400)
    else 
      @status = false
      self.hide
      setCanvasSize
      showElements
    end
  end

  resizeBtn.connect(SEL_COMMAND) do
    puts('resizeBtn clicked')
  end

  end
  
  def loadIcon(filename,size)
    begin
      filename = File.join("icons", filename)
      icon = nil
      File.open(File.expand_path(File.dirname(__FILE__)).tap {|pwd| $LOAD_PATH.unshift(pwd) unless $LOAD_PATH.include?(pwd)}+"/"+filename, "rb") do |f|
        icon = FXPNGIcon.new(getApp(), f.read)
        if size != 0
          icon.scale(size,size)
        end
      end
      icon
    rescue
      raise RuntimeError, "Couldn't load icon: #{filename}"
    end
  end
 end
