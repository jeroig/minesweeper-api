class Api::GameController < ApplicationController

  def click
    render json: Board.instance.click(params[:row].to_i, params[:col].to_i)
  end

end
