require 'matrix'
require 'singleton'

class Board
  include Singleton
  attr_reader :panel

  def initialize
    #Hard-Code Matrix
    #value = 0        ==> empty cell
    #value = Integer  ==> adjacent squares contain mines
    #value = -1       ==> a BOMB!
    @panel = Matrix.rows([
        [ 0 , 1 , 1 , 1 , 0 ],
        [ 0 , 1 ,-1 , 1 , 0 ],
        [ 0 , 1 , 1 , 1 , 0 ],
        [ 1 , 1 , 1 , 0 , 0 ],
        [ 1 ,-1 , 2 , 1 , 1 ],
        [ 1 , 1 , 2 ,-1 , 1 ],
        [ 0 , 0 , 1 , 1 , 1 ]
    ])
  end

  def click(row, col)
    {
      value: @panel.element(row,col),
      neighbors: neighbors(row, col)
    }
  end

  def up_left(row, col)
    return nil if row-1 < 0 || col-1 < 0
    @panel.element(row-1,col-1)
  end

  def up(row, col)
    return nil if row-1 < 0
    @panel.element(row-1,col)
  end

  def up_right(row, col)
    return nil if row-1 < 0 || col+1 >= @panel.column_count
    @panel.element(row-1,col+1)
  end

  def left(row, col)
    return nil if col-1 < 0
    @panel.element(row,col-1)
  end

  def right(row, col)
    return nil if col+1 >= @panel.column_count
    @panel.element(row,col+1)
  end

  def down_left(row, col)
    return nil if row+1 >= @panel.row_count || col-1 < 0
    @panel.element(row+1,col-1)
  end

  def down(row, col)
    return nil if row+1 >= @panel.row_count
    @panel.element(row+1,col)
  end

  def down_right(row, col)
    return nil if row+1 >= @panel.row_count || col+1  >= @panel.column_count
    @panel.element(row+1,col+1)
  end


  private
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
