require 'matrix'
require 'singleton'

class Board
  include Singleton
  attr_reader :panel
  attr_reader :state

  class Matrix < Matrix
    def []=(row, col, value)
      @rows[row][col] = value
    end
  end

  def initialize
    @panel = Matrix.rows([
      [default_struct(0), default_struct(1), default_struct(1), default_struct(1), default_struct(0)],
      [default_struct(0), default_struct(1), default_struct(-1), default_struct(1), default_struct(0)],
      [default_struct(0), default_struct(1), default_struct(1), default_struct(1), default_struct(0)],
      [default_struct(1), default_struct(1), default_struct(1), default_struct(0), default_struct(0)],
      [default_struct(1), default_struct(-1), default_struct(2), default_struct(1), default_struct(1)],
      [default_struct(1), default_struct(1), default_struct(2), default_struct(-1), default_struct(1)],
      [default_struct(0), default_struct(0), default_struct(1), default_struct(1), default_struct(1)]
    ])
    @state = 'playing'
  end

  #def initialize
  #  #Hard-Code Matrix
  #  #value = 0        ==> empty cell
  #  #value = Integer  ==> adjacent squares contain mines
  #  #value = -1       ==> a BOMB!
  #  @panel = Matrix.rows([
  #      [ 0 , 1 , 1 , 1 , 0 ],
  #      [ 0 , 1 ,-1 , 1 , 0 ],
  #      [ 0 , 1 , 1 , 1 , 0 ],
  #      [ 1 , 1 , 1 , 0 , 0 ],
  #      [ 1 ,-1 , 2 , 1 , 1 ],
  #      [ 1 , 1 , 2 ,-1 , 1 ],
  #      [ 0 , 0 , 1 , 1 , 1 ]
  #  ])
  #end

  #def click(row, col)
  #  {
  #    value: @panel.element(row,col),
  #    neighbors: neighbors(row, col)
  #  }
  #end

  def click(row,col)
   @panel[row,col][:click] = true
   @panel[row,col][:question] = false
   @panel[row,col][:mark] = false
   if @panel[row,col][:value] == -1
     @state = 'looser'
   else
     @state = 'winner' if self.winner?
   end
   {
     value: @panel.element(row,col),
     neighbors: neighbors(row, col),
     state: @state
   }
  end

  def up_left(row, col)
    return nil if row-1 < 0 || col-1 < 0
    virtual_click(row-1,col-1)
    @panel.element(row-1,col-1)
  end

  def up(row, col)
    return nil if row-1 < 0
    virtual_click(row-1,col)
    @panel.element(row-1,col)
  end

  def up_right(row, col)
    return nil if row-1 < 0 || col+1 >= @panel.column_count
    virtual_click(row-1,col+1)
    @panel.element(row-1,col+1)
  end

  def left(row, col)
    return nil if col-1 < 0
    virtual_click(row,col-1)
    @panel.element(row,col-1)
  end

  def right(row, col)
    return nil if col+1 >= @panel.column_count
    virtual_click(row,col+1)
    @panel.element(row,col+1)
  end

  def down_left(row, col)
    return nil if row+1 >= @panel.row_count || col-1 < 0
    virtual_click(row+1,col-1)
    @panel.element(row+1,col-1)
  end

  def down(row, col)
    return nil if row+1 >= @panel.row_count
    virtual_click(row+1,col)
    @panel.element(row+1,col)
  end

  def down_right(row, col)
    return nil if row+1 >= @panel.row_count || col+1  >= @panel.column_count
    virtual_click(row+1,col+1)
    @panel.element(row+1,col+1)
  end

  def question(row, col)
    @panel[row,col][:question] = true
    @panel[row,col][:mark] = false
    @panel[row,col][:click] = false
    @state = 'playing'
    {value: @panel.element(row,col), state: @state}
  end

  def mark(row, col)
    @panel[row,col][:mark] = true
    @panel[row,col][:question] = false
    @panel[row,col][:click] = false
    @state = 'winner' if self.winner?
    {value: @panel.element(row,col), state: @state}
  end

  def winner?
    #return true if all marks are in -1 value
    return false if @state == 'looser'
    @panel.map {|cell|
      return false if cell[:question]
      return false if !cell[:click] && cell[:value] != -1
      return false if cell[:value] != -1 && cell[:mark]
      return false if cell[:value] == -1 && !cell[:mark]
    }
    return true
  end

  def reset
    @state = 'playing'
    @panel.each_with_index do |cell, row, col|
      @panel[row,col] = default_struct(cell[:value])
    end
    {message: 'ok'}
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

    def default_struct(value)
      {value: value, question: false, mark: false, click: false }
    end

    def virtual_click(row, col)
      if @panel[row,col][:value] > 0 && !@panel[row,col][:question] && !@panel[row,col][:mark]
        @panel[row,col][:click] = true
      end
    end
end
