$LOAD_PATH << '.'
require 'fox16'

include Fox

class Canvas < FXBitmapFrame #Bitmap class that acts as a container for the bitmap.
  
  def initialize(p, app, opt, x, y, width, height, padLeft, padRight, padTop, padBottom)
    map = RastorMap.new(app, width, height) #Creates a temporary rastor(Bitmap) object that is used to initizalize the Bitmap Frame.
    super(p, map, opt, x, y, width, height, padLeft, padRight, padTop, padBottom)
  end
end

class RastorMap < FXBitmap #Creates and initializes a bitmap that stores the pixel values for the drawn canvas.
  
  def initialize(app, w, h)
    super(app, nil, 0, w, h)
    self.fill(Fox.FXRGB(248, 248, 255))
  end  
end
