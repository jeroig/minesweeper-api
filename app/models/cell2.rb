
class Cell2
  attr_accessor :value
  attr_reader   :row
  attr_reader   :col
  attr_accessor :state

  def initialize(row, col, value = 0)
      @value    = value
      @row      = row
      @col      = col
      @state    = 'unclicked' #['unclicked','clicked','disputed','marked']
   end

   def mine?
     return (self.value == -1) ? true : false
   end

   def show?
     return true if !self.mine? && self.state == 'unclicked'
     return false
   end

   def clicked?
     return self.state == 'clicked' ? true : false
   end

end
