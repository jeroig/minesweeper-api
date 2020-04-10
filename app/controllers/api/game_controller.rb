class Api::GameController < ApplicationController

  def to_click
    render json: Board2.instance.to_click(params[:row].to_i, params[:col].to_i)
  end

  def click
    render json: Board2.instance.click(params[:row].to_i, params[:col].to_i)
  end

  def mark
    render json: Board2.instance.mark(params[:row].to_i, params[:col].to_i)
  end

  def question
    render json: Board2.instance.question(params[:row].to_i, params[:col].to_i)
  end

  def reset
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

end
