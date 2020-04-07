Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    # Add routes according to need
    get 'game/click/row/:row/col/:col', to: 'game#click'
    get 'game/to_click/row/:row/col/:col', to: 'game#to_click'
    get 'game/mark/row/:row/col/:col', to: 'game#mark' # It's a red flag
    get 'game/question/row/:row/col/:col', to: 'game#question'
    get 'game/reset(/:rows/:columns/:mines)', to: 'game#reset'

    #Register
    post 'user/register', to: 'user#register'
    #Login
    post 'user/login'   , to: 'user#login'
  end
end
