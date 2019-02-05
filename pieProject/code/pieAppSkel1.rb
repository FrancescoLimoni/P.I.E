# Edited 2/2/2019 by Omar Bitar
#toturial: http://rubylearning.com/satishtalim/fxruby.html

require 'fox16'
include Fox

class PIEskel1 < FXMainWindow
    
  def initialize(app, title, w, h)
    super(app, title, :width => w, :height => h) 

      #create box effect
      packer = FXPacker.new(self, :opts => LAYOUT_FILL) #layout parent
      groupBoxH = FXGroupBox.new(packer, nil, :opts => FRAME_RIDGE | LAYOUT_FILL_X)
      groupBoxV = FXGroupBox.new(packer, nil, :opts => FRAME_RIDGE | GROUPBOX_NORMAL)
   
      
      #layout setup  
      hFrame1 = FXHorizontalFrame.new(groupBoxH)
      vFrame1 = FXVerticalFrame.new(groupBoxV)

      #method calls
      addMenuBar(hFrame1)
      addBtns(vFrame1)
      add_text_area(packer)
  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end

  #brushBtns 
  def addBtns(layout) 
     brushAbtn = FXButton.new(layout, "BrushA")
     brushAbtn = FXButton.new(layout, "BrushB")
     brushAbtn = FXButton.new(layout, "BrushC")
  end

  # text area
  def add_text_area(layout)  
    vFrame1 = FXVerticalFrame.new(layout , :opts => LAYOUT_FILL)
    @txt = FXText.new(vFrame1, :opts => LAYOUT_FILL)  
    @txt.text = "hello world"  
  end  

  # menu system (with pull-down menus)
  def addMenuBar(layout)  
    # set up menu layout properties
    menuBar = FXMenuBar.new(layout, LAYOUT_SIDE_TOP | LAYOUT_FILL_X)  
        # create pointers (to link new 'FXMenuPane' wutg a new 'FXMenuTitle')
    fileMenu = FXMenuPane.new(layout)  #self refers to the TextEditor window
    about = FXMenuPane.new(layout)  #self refers to the TextEditor window

    #create main menu Items
    FXMenuTitle.new(menuBar, "File", :popupMenu => fileMenu)  
    FXMenuTitle.new(menuBar, "About", :popupMenu => about) 

    #create sub menue Items
        #under 'File' tab 
    newCmd = FXMenuCommand.new(fileMenu, "new")
    loadCmd = FXMenuCommand.new(fileMenu, "Load")
    saveCmd = FXMenuCommand.new(fileMenu, "save") 
    exitCmd = FXMenuCommand.new(fileMenu, "Exit")
        #under 'About' tab
    aboutCmd = FXMenuCommand.new(about, "contact us") 
    
    #connect sub menue Items to functions
    newCmd.connect(SEL_COMMAND) do
        @txt.text = ""
    end

    loadCmd.connect(SEL_COMMAND) do  
        dialog = FXFileDialog.new(self, "Load a File") 
        dialog.selectMode = SELECTFILE_EXISTING 
        dialog.patternList = ["All Files (*)"]  
        if dialog.execute != 0  
         load_file(dialog.filename)  
        end   
    end  

    saveCmd.connect(SEL_COMMAND) do
        dialog = FXFileDialog.new(self, "Save a File")  
        dialog.selectMode = SELECTFILE_EXISTING  
        dialog.patternList = ["All Files (*)"]  
        if dialog.execute != 0  
          save_file(dialog.filename)  
        end
    end

    exitCmd.connect(SEL_COMMAND) do
        exit
    end

    aboutCmd.connect(SEL_COMMAND) do
        # ...
    end
    
  end 

end

def load_file(filename)  
    contents = ""  
    File.open(filename, 'r') do |f1|  
      while line = f1.gets  
        contents += line  
      end  
    end  
    @txt.text = contents  
  end  

# recomended way to start fxRuby app
if __FILE__ == $0
    FXApp.new do |app|
        PIEskel1.new(app, "PIEapp", 600, 400)  
      app.create
      app.run
    end
  end