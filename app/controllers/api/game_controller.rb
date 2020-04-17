class Api::GameController < ApplicationController
  before_action :set_board, except: [:reset, :history]

  def to_click
    render json: @board.to_click(@row, @col)
  end

  def click
    render json: @board.click(@row, @col)
  end

  def mark
    render json: @board.mark(@row, @col)
  end

  def question
    render json: @board.question(@row, @col)
  end

  def history
    @boards = Board.where(user: @user).order(id: :desc).limit(30)
    render json: (@boards.map do |board|
                    {
                      id: board.id,
                      date: board.created_at.strftime('%d/%m/%Y'),
                      duration: board.timer.to_s + ' sec.',
                      status: board.state,
                      board: { rows: board.rows, columns: board.columns, mines: board.mines }
                    }
                  end)
  end

  def reset
    @board = Board.new(user_id: @user.id, rows: params[:rows].to_i, columns: params[:columns].to_i, mines: params[:mines].to_i, state: 'playing')
    if @board.save
      render json: {
                      message: 'ok',
                      game: {
                        id:    @board.id,
                        timer: @board.timer,
                        state: @board.state,
                        board: {
                          rows:    @board.rows,
                          columns: @board.columns,
                          mines:   @board.mines,
                          cells:   @board.cells.map { |cell| cell.as_json(only: [:row, :col, :value, :state]) }
                        }
                      }
                    }, status: :created
    else
      render json: @board.errors, status: :unprocessable_entity
    end
  end

  private
    def set_board
      @board = Board.find(params[:id])
      @row   = params[:row].to_i
      @col   = params[:col].to_i
    end
end
