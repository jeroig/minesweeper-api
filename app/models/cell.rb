
class Cell
  attr_accessor :value
  attr_reader   :row
  attr_reader   :col
  attr_accessor :state

  def initialize(row, col, value = 0, question = false, mark = false, click = false)
      @value    = value
      @row      = row
      @col      = col
      @state    = 'unclicked' #['unclicked','clicked','disputed','marked']
   end

   def mine?
     return (self.value == -1) ? true : false
   end

end
