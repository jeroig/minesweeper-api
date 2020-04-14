# minesweeper-api

Design and implement RESTful API for the game

## Functionality
As API we defined support routes to be called

### For User
```post 'api/user/register'``` mandatory data {email: string, password: string}
```post 'api/user/login'```    mandatory data {email: string, password: string}

It is recommended to encrypt the password.
In any of this API call, the server response with a Token (JWS)[https://jwt.io/]
that will be used in any GAMEs api request.

### For Game

For any request below it's necessary to set in HEADER 'Authorization'
the token obtained in previous User request

```
headers.common['Authorization'] = `Bearer ${token}`
```

```
get 'api/game/reset/:rows/:columns/:mines'
get 'api/game/:id/click/row/:row/col/:col'
get 'api/game/:id/to_click/row/:row/col/:col'
get 'api/game/:id/mark/row/:row/col/:col'
get 'api/game/:id/question/row/:row/col/:col'
```

When reset a game the API return data related to the new Game
```
{
  message: ok,
  game:{
        id: GAME_ID,
        timer: TIMER in seg.,
        state: playing|loser|winner,
        board:{
               rows: number_of_rows,
               columns: number_of_columns,
               mines: number_of_mines,
               cells:[
                        {
                          row: row_value,
                          col: col_value,
                          value: number of mine around the cell or -1 if a mine,
                          state: click|unclicked|disputed|marked
                        },
                        ....
                        ....
                     ]
```

For actions like *to_click* *mark* & *question* the API return
```
{
 cell:{
        row: row_value,
        col: col_value,
        value: number of mine around the cell or -1 if a mine,
        state: click|unclicked|disputed|marked
      }
 state: playing|loser|winner
}
```

For each *click* action de API return a JSON with
```
{
  cell:{
         row: row_value,
         col: col_value,
         value: number of mine around the cell or -1 if a mine,
         state: click|unclicked|disputed|marked
       },
  was_clicked: boolean (if the cell already 'clicked')
  neighbors: {list_cell_neighbors to discover}
  state: playing|looser|winner
}
```

## TODO
 * Time tracking
 * ~~Ability to start a new game and preserve the old ones~~
 * Ability to resume an old game
 * Ability to select the game parameters: number of rows, columns, and mines
 * ~~Ability to support multiple users/accounts~~
