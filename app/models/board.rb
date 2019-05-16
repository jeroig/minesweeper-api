require 'matrix'
require 'singleton'

class Board
  include Singleton
  attr_reader :panel
  attr_reader :state
  attr_reader :rows
  attr_reader :columns
  attr_reader :mines

  class Matrix < Matrix
    def []=(row, col, value)
      @rows[row][col] = value
    end
  end

  def initialize(rows = 7, columns = 5, mines = 3 )
    self.reset(rows,columns,mines)
  end

  def prettyP
    @panel.to_a.each do |row|
      p row.map(&:value)
    end
  end

  def reset(rows = 7, columns = 5, mines = 3)
    @panel = Matrix.build(rows, columns){ Cell.new }
    @state = 'playing'
    @rows  = rows
    @columns = columns
    @mines = mines
    #randomize mines position
    index_mines = (0..((@rows * @columns)-1)).to_a.sample(@mines).sort
    index_mines.each do |i|
      tmp = self.coordenate(i)
      @panel[tmp[:row],tmp[:col]].value = -1
    end
    setValues()
    {message: 'ok', board: {rows: @rows, columns: @columns, mines: @mines, state: @state}}
  end

  def index(row, col)
    col + self.columns * row
  end

  def coordenate(index)
    {
      row:  index / self.columns,
      col:  index % self.columns
    }
  end

  def click(row,col)
   cell = @panel[row,col]
   cell.question = false
   cell.mark = false
   cell.click = true
   if cell.mine?
     @state = 'looser'
   else
     @state = 'winner' if self.winner?
   end
   @panel[row,col] = cell
   {
     value: @panel.element(row,col),
     neighbors: neighbors(row, col),
     state: @state
   }
  end

  def to_click(row,col)
    @panel[row,col].click = false
    @panel[row,col].question = false
    @panel[row,col].mark = false
    @state = 'playing'
    {value: @panel.element(row,col), state: @state}
  end

  def up_left(row, col)
    return nil if row-1 < 0 || col-1 < 0
    return nil if @panel.element(row-1,col-1).value == -1
    @panel.element(row-1,col-1)
  end

  def up(row, col)
    return nil if row-1 < 0
    return nil if @panel.element(row-1,col).value == -1
    @panel.element(row-1,col)
  end

  def up_right(row, col)
    return nil if row-1 < 0 || col+1 >= @panel.column_count
    return nil if @panel.element(row-1,col+1).value == -1
    @panel.element(row-1,col+1)
  end

  def left(row, col)
    return nil if col-1 < 0
    return nil if @panel.element(row,col-1).value == -1
    @panel.element(row,col-1)
  end

  def right(row, col)
    return nil if col+1 >= @panel.column_count
    return nil if @panel.element(row,col+1).value == -1
    @panel.element(row,col+1)
  end

  def down_left(row, col)
    return nil if row+1 >= @panel.row_count || col-1 < 0
    return nil if @panel.element(row+1,col-1).value == -1
    @panel.element(row+1,col-1)
  end

  def down(row, col)
    return nil if row+1 >= @panel.row_count
    return nil if @panel.element(row+1,col).value == -1
    @panel.element(row+1,col)
  end

  def down_right(row, col)
    return nil if row+1 >= @panel.row_count || col+1  >= @panel.column_count
    return nil if @panel.element(row+1,col+1).value == -1
    @panel.element(row+1,col+1)
  end

  def question(row, col)
    @panel[row,col].question = true
    @panel[row,col].mark = false
    @panel[row,col].click = false
    @state = 'playing'
    {value: @panel.element(row,col), state: @state}
  end

  def mark(row, col)
    @panel[row,col].mark = true
    @panel[row,col].question = false
    @panel[row,col].click = false
    @state = 'winner' if self.winner?
    {value: @panel.element(row,col), state: @state}
  end

  def winner?
    #return true if all marks are in -1 value
    return false if @state == 'looser'
    @panel.map {|cell|
      return false if cell.question
      return false if !cell.click && cell.value != -1
      return false if cell.value != -1 && cell.mark
      return false if cell.value == -1 && !cell.mark
    }
    return true
  end

  private
    def setValues
      @panel.each_with_index {|cell, row, col|
        next unless cell.value == -1
        neighbors(row,col).values.each do |ncell|
          ncell.value += 1 unless ncell.value == -1
        end
      }
    end

    def neighbors(row, col)
      {
        key('up_left', row, col) => up_left(row,col),
        key('up', row, col) => up(row,col),
        key('up_right', row, col) => up_right(row,col),
        key('left', row, col) => left(row,col),
        key('right', row, col) => right(row,col),
        key('down_left', row, col) => down_left(row,col),
        key('down', row, col) => down(row,col),
        key('down_right', row, col) => down_right(row,col),
      }.compact
    end

    def key(position, row, col)
      case position
        when 'up_left'
          !self.up_left(row, col).nil? ? "#{row-1}_#{col-1}".to_sym : nil
        when 'up'
          !self.up(row, col).nil? ? "#{row-1}_#{col}".to_sym : nil
        when 'up_right'
          !self.up_right(row, col).nil? ? "#{row-1}_#{col+1}".to_sym : nil
        when 'left'
          !self.left(row, col).nil? ? "#{row}_#{col-1}".to_sym : nil
        when 'right'
          !self.right(row, col).nil? ? "#{row}_#{col+1}".to_sym : nil
        when 'down_left'
          !self.down_left(row, col).nil? ? "#{row+1}_#{col-1}".to_sym : nil
        when 'down'
          !self.down(row, col).nil? ? "#{row+1}_#{col}".to_sym : nil
        when 'down_right'
          !self.down_right(row, col).nil? ? "#{row+1}_#{col+1}".to_sym : nil
        else
          nil
      end
    end
end
