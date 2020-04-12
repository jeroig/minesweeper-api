class Api::GameController < ApplicationController
  before_action :set_board, except: :reset

  def to_click
    render json: @board.to_click(@row, @col)
    #render json: Board2.instance.to_click(params[:row].to_i, params[:col].to_i)
  end

  def click
    render json: @board.click(@row, @col)
    #render json: Board2.instance.click(params[:row].to_i, params[:col].to_i)
  end

  def mark
    render json: @board.mark(@row, @col)
    #render json: Board2.instance.mark(params[:row].to_i, params[:col].to_i)
  end

  def question
    render json: @board.question(@row, @col)
    #render json: Board2.instance.question(params[:row].to_i, params[:col].to_i)
  end

  def reset
    #render json: Board2.instance.reset(params[:rows].to_i, params[:columns].to_i, params[:mines].to_i)
    @board = Board.new(user_id: @user.id, rows: params[:rows].to_i, columns: params[:columns].to_i, mines: params[:mines].to_i, timer: 0, state: 'playing')
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
                          cells:   @board.cellsByRows
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
