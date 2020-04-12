class Cell < ApplicationRecord
  belongs_to :board
  enum state: { unclicked: 0, clicked: 1, disputed: 2, marked: 3 }

  after_update :updateBoardState, if: Proc.new {|obj|
      obj.saved_change_to_state?(from: 'unclicked', to: 'clicked') ||
      obj.saved_change_to_state?(to: 'marked')
  }


  def stateTo(new_state)
    data = (new_state == 'clicked') ? {neighbors: self.neighbors, was_clicked: self.clicked? } : {}
    self.update(state: new_state)
    data.merge(cell: self.as_json(only: [:row, :col, :value, :state]))
  end

  def show?
    (!self.mine? && self.unclicked?) ? true : false
  end

  def mine?
    (self.value == -1) ? true : false
  end

  def up_left
    return nil if self.row-1 < 0 || self.col-1 < 0
    return nil unless self.board.getCell(self.row-1, self.col-1).show?
    self.board.getCell(self.row-1, self.col-1)
  end

  def up
    return nil if self.row-1 < 0
    return nil unless self.board.getCell(self.row-1, self.col).show?
    self.board.getCell(self.row-1, self.col)
  end

  def up_right
    return nil if self.row-1 < 0 || self.col+1 >= self.board.columns
    return nil unless self.board.getCell(self.row-1, self.col+1).show?
    self.board.getCell(self.row-1, self.col+1)
  end

  def left
    return nil if self.col-1 < 0
    return nil unless self.board.getCell(self.row,self.col-1).show?
    self.board.getCell(self.row,self.col-1)
  end

  def right
    return nil if self.col+1 >= self.board.columns
    return nil unless self.board.getCell(self.row,self.col+1).show?
    self.board.getCell(self.row,self.col+1)
  end

  def down_left
    return nil if self.row+1 >= self.board.rows || self.col-1 < 0
    return nil unless self.board.getCell(self.row+1,self.col-1).show?
    self.board.getCell(self.row+1,self.col-1)
  end

  def down
    return nil if self.row+1 >= self.board.rows
    return nil unless self.board.getCell(self.row+1,self.col).show?
    self.board.getCell(self.row+1,self.col)
  end

  def down_right
    return nil if self.row+1 >= self.board.rows || self.col+1  >= self.board.columns
    return nil unless self.board.getCell(self.row+1,self.col+1).show?
    self.board.getCell(self.row+1,self.col+1)
  end


  def neighbors
    [
      self.up_left,
      self.up,
      self.up_right,
      self.left,
      self.right,
      self.down_left,
      self.down,
      self.down_right
    ].compact
  end

  private
    def updateBoardState
      self.board.update(state: :loser)  if self.board.playing? && self.mine? && self.saved_change_to_state?(from: 'unclicked', to: 'clicked')
      self.board.update(state: :winner) if self.board.playing? && self.board.winner?
    end

end
