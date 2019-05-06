# minesweeper-api

Design and implement RESTful API for the game

## Funtionality
As API we defined support routes to be called
```
api/game/click/row/:row/col/:col
api/game/mark/row/:row/col/:col
api/game/question/row:row/col/:col
api/game/reset  <-- is called when game is over
```

For each click de API return a JSON with
```
{
 value: value_clicked_cell,   
 neighbors: {list_values_cell_neighbors}
 state: playing|looser|winner
}
```

## TODO
 * Time tracking
 * Ability to start a new game and preserve/resume the old ones
 * Ability to select the game parameters: number of rows, columns, and mines
 * Ability to support multiple users/accounts
