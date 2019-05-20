
class Cell
  attr_accessor :value
  attr_accessor :question
  attr_accessor :mark
  attr_accessor :click
  attr_reader   :row
  attr_reader   :col

  def initialize(row, col, value = 0, question = false, mark = false, click = false)
      @value    = value
      @question = question
      @mark     = mark
      @click    = click
      @row      = row
      @col      = col
   end

   def mine?
     return (self.value == -1) ? true : false
   end

end
