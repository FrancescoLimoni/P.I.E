class FloatingToolBar 
  #param scope: class of main window
  #param x,y,z,r LayerPanel of toolbar
  def initialize(scope,x,y,z,r)

    tool_bar_shell = FXToolBarShell.new(scope)

    #scope for where to place FloatingToolBar object
    @Scope = scope

    # dock sites that provide places for the toolbar to land when it’s ready to come back home
    # The user can drag the floating toolbar to either of these positions on
    # the main window, and it will reattach itself (dock) there.
    defult_dock_site = FXDockSite.new(scope,      
      :opts => x|y|z|r)

    # creating the tool bar
    @tool_bar = FXToolBar.new(defult_dock_site, tool_bar_shell,
      :opts => PACK_UNIFORM_WIDTH|FRAME_RAISED|LAYOUT_FILL_X)

    #a “grip,” a handle that the user can grab to tear the toolbar away from the dock site
    FXToolBarGrip.new(@tool_bar,
      :target => @tool_bar, :selector => FXToolBar::ID_TOOLBARGRIP,
      :opts => TOOLBARGRIP_DOUBLE)

      return @tool_bar
  end

  def addDock(x,y,z,r)
    new_dock_site = FXDockSite.new(@Scope, :opts => x|y|z|r)
  end

  def hideMe
    @tool_bar.hide
  end

  def showMe
    @tool_bar.show
  end
  
  #returns the floating tool bar settings
  #return it as param in FXButton to make button float
  def getToolBar
    return @tool_bar
  end
  
end