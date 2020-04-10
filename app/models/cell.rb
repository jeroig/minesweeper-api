class Cell < ApplicationRecord
  belongs_to :board
  enum state: { unclicked: 0, clicked: 1, disputed: 2, marked: 3 }

  def show?
    return true if !self.mine? && self.unclicked?
    return false
  end

  def mine?
    return (self.value == -1) ? true : false
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

end
