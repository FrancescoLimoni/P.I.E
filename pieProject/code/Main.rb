require 'fox16'

include Fox

class EditorWindow < FXMainWindow
  def initialize(app)
    super(app, "Pixel Image Editor", :width => 1080, :height => 720)
  end
  
  def create
    super
    show(PLACEMENT_SCREEN)
  end
end


if __FILE__ == $0
  FXApp.new do |app|
    EditorWindow.new(app)
    app.create
    app.run
  end
end
