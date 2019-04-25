# minesweeper-api

Design and implement RESTful API for the game

## Funtionality
As API we defined support routes to be called
```
api/game/new
api/game/click/row:row/col/:col
```

For each click de API return a JSON with
```
{
 value: value_clicked_cell,   
 neighbors: {list_values_cell_neighbors}
}
```

## TODO
 * Ability to 'flag' a cell with a question mark or red flag
 * Detect when game is over
 * Persistence
 * Time tracking
 * Ability to start a new game and preserve/resume the old ones
 * Ability to select the game parameters: number of rows, columns, and mines
 * Ability to support multiple users/accounts
