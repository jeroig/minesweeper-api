Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    # Add routes according to need
    get 'game/click/row/:row/col/:col', to: 'game#click'
  end
end
