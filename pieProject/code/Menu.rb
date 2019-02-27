class MenuBar
    def initialize(x,y,z)
        puts "creating menu bar"
  
        # set up menu LayerPanel properties ======================================

        menuBar = FXMenuBar.new(x, y | z)  
        menuBar.backColor = "Gray69"
            # create pointers (to link new 'FXMenuPane' wutg a new 'FXMenuTitle')
        fileMenu = FXMenuPane.new(x)  #self refers to the TextEditor window
        about = FXMenuPane.new(x)  #self refers to the TextEditor window

        #create main menu Items ================================================

        fileTab = FXMenuTitle.new(menuBar, "File", :popupMenu => fileMenu)  
        fileTab.backColor = "Gray69"
    
        aboutTab = FXMenuTitle.new(menuBar, "About", :popupMenu => about) 
        aboutTab.backColor = "Gray69"

        #create sub menue Items=================================================

            #under 'File' tab 
        newCmd = FXMenuCommand.new(fileMenu, "New")
        loadCmd = FXMenuCommand.new(fileMenu, "Load")
        saveCmd = FXMenuCommand.new(fileMenu, "Save") 
        exitCmd = FXMenuCommand.new(fileMenu, "Exit")

            #under 'About' tab
        aboutCmd = FXMenuCommand.new(about, "contact us") 
        
        #connect sub menue Items to functions =====================================

        newCmd.connect(SEL_COMMAND) do
            #@txt.text = ""
        end
        #**************************************************************************
        loadCmd.connect(SEL_COMMAND) do  
            dialog = FXFileDialog.new(x, "Load a File") 
            dialog.selectMode = SELECTFILE_EXISTING 
            dialog.patternList = ["All Files (*)"]  
            if dialog.execute != 0  
            load_file(dialog.filename)  
            end   
        end  
        #**************************************************************************
        saveCmd.connect(SEL_COMMAND) do
            dialog = FXFileDialog.new(x, "Save a File")  
            dialog.selectMode = SELECTFILE_EXISTING  
            dialog.patternList = ["All Files (*)"]  
            if dialog.execute != 0  
                save_file(dialog.filename)  
            end
        end
        #**************************************************************************
        exitCmd.connect(SEL_COMMAND) do
            puts "exiting program"
            exit
        end
        #**************************************************************************
        aboutCmd.connect(SEL_COMMAND) do
            # ...
        end
    
    end 

end
