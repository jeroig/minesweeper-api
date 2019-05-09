class Api::GameController < ApplicationController

  def to_click
    render json: Board.instance.to_click(params[:row].to_i, params[:col].to_i)
  end

  def click
    render json: Board.instance.click(params[:row].to_i, params[:col].to_i)
  end

  def mark
    render json: Board.instance.mark(params[:row].to_i, params[:col].to_i)
  end

  def question
    render json: Board.instance.question(params[:row].to_i, params[:col].to_i)
  end

  def reset
    render json: Board.instance.reset
  end
end
