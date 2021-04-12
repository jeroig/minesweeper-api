Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    # Add routes according to need
    get 'game/history', to: 'game#history'
    get 'game/reset/:rows/:columns/:mines', to: 'game#reset'
    get 'game/:id/click/row/:row/col/:col', to: 'game#click'
    get 'game/:id/to_click/row/:row/col/:col', to: 'game#to_click'
    get 'game/:id/mark/row/:row/col/:col', to: 'game#mark' # It's a red flag
    get 'game/:id/question/row/:row/col/:col', to: 'game#question'

    #Register
    post 'user/register', to: 'user#register'
    #Login
    post 'user/login'   , to: 'user#login'
  end
end