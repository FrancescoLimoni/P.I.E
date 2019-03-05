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

    splashIcon = loadIcon("pie.png")

    vframe = FXGroupBox.new(self, "ready to bake", GROUPBOX_TITLE_CENTER|FRAME_RIDGE|LAYOUT_FILL)
    vframe.backColor = "Gray69"

    btn = FXButton.new(vframe, "\t click to begin", splashIcon, :opts => LAYOUT_CENTER_X)
    btn.buttonStyle |= BUTTON_TOOLBAR
    btn.frameStyle = FRAME_RAISED
    btn.backColor = "Gray69"

    def getStatus
      return @status
    end

    #add UI objects to an array and hide them
    def addHideElement(element,window)

      @resizeHack = window
      @hideElements.push(element)

      hideElements

    end

    def showElements 
      @hideElements.each do |element|
        element.show
      end
      @resizeHack.resize(800,500)
    end

    def hideElements 
      @hideElements.each do |element|
        element.hide
      end
    end

    btn.connect(SEL_COMMAND) do

      @status = false
      self.hide

      showElements

  end

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