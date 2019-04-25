class Api::GameController < ApplicationController

  def click
    render json: {col: params[:row], row: params[:row]}
  end

end
