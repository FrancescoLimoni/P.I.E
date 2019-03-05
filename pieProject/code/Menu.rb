class MenuBar
    def initialize(app,x,y,z)
        puts "creating menu bar"
  
        # set up menu LayerPanel properties ======================================

        menuBar = FXMenuBar.new(x, y | z)  
        menuBar.backColor = "Gray69"
            # create pointers (to link new 'FXMenuPane' wutg a new 'FXMenuTitle')
        fileMenu = FXMenuPane.new(x)  #self refers to the TextEditor window
        about = FXMenuPane.new(x)  #self refers to the TextEditor window

        #load icons functions ==================================================
        def readIcon(scope,path)
            icon = nil
            File.open(path, "rb") do |io|
            icon = FXPNGIcon.new(scope, io.read)
            icon.scale(25,25)
            end
            icon
        end

        #create main menu Items ================================================
        
        fileTab = FXMenuTitle.new(menuBar, nil, readIcon(app,"icons/pie.png"), :popupMenu => fileMenu)  
        fileTab.backColor = "Gray69"

        fileNew = FXMenuTitle.new(menuBar, nil, readIcon(app,"icons/filenew.png"), :popupMenu => nil)  
        fileNew.backColor = "Gray69"

        fileLoad = FXMenuTitle.new(menuBar, nil, readIcon(app,"icons/fileopen.png"), :popupMenu => nil)  
        fileLoad.backColor = "Gray69"

        fileSave = FXMenuTitle.new(menuBar, nil, readIcon(app,"icons/filesave.png"), :popupMenu => nil)  
        fileSave.backColor = "Gray69"

        fileSave_s = FXMenuTitle.new(menuBar, nil, readIcon(app,"icons/filesaves.png"), :popupMenu => nil)  
        fileSave_s.backColor = "Gray69"

        aboutTab = FXMenuTitle.new(menuBar, "About", :popupMenu => about, :opts => LAYOUT_CENTER_Y) 
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