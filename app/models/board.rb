#require 'matrix'

class Board < ApplicationRecord
  enum state: { playing: 0, winner: 1, loser: 2 }

  belongs_to :user
  has_many   :cells, dependent: :destroy

  validates_numericality_of [:rows,:columns],
                            greater_than_or_equal_to: 1,
                            less_than_or_equal_to: 10,
                            message: 'Rows & Columns must be greater than 0 and less than 11'

  validates_numericality_of :mines, less_than: ->(board) { board.rows * board.columns },  message: 'Mines overflow'

  before_create :createCells


  def cellsByRows
    0.upto(self.rows-1).map do |row|
      self.cells.where(row: row).select(:id, :value, :row, :col, :state).order(col: :asc)
    end
  end

  def getCell(row, col)
    if self.new_record?
      # Not exist in DB yet so we can't use "where" clause
      self.cells.each do |cell| return cell if cell.row == row && cell.col == col end
      return nil
    else
      self.cells.where(row: row).where(col: col).first
    end
  end

  def getCellByIndex(index)
    coordinates = indexToCoordinate(index)
    self.getCell(coordinates[:row], coordinates[:col])
  end

  private
    def createCells
      0.upto(self.rows-1).each do |row|
         0.upto(self.columns-1).each do |col|
           self.cells << Cell.new(row: row, col: col, value: 0, state: :unclicked)
         end
      end
      #randomize mines position
      index_mines = (0..((self.rows * self.columns)-1)).to_a.sample(self.mines).sort
      index_mines.each { |i|
        self.getCellByIndex(i).value = -1
      }
      setCellValues
    end

    def indexToCoordinate(index)
      {row: index / self.columns, col: index % self.columns}
    end

    def setCellValues
      0.upto(self.rows-1).each do |row|
         0.upto(self.columns-1).each do |col|
           cell = self.getCell(row, col)
           next unless cell.value == -1
           cell.neighbors.each do |ncell|
             ncell.value += 1 unless ncell.value == -1
           end
         end
      end
    end
end
