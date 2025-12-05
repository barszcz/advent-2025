import gleam/dict
import gleam/list
import gleam/result
import gleam/string

pub opaque type Tile {
  Roll
  Empty
}

pub fn parse(input: String) -> #(dict.Dict(#(Int, Int), Tile), Int) {
  let lines = input |> string.split("\n")
  let len = list.length(lines)
  let grid =
    list.index_fold(lines, dict.new(), fn(grid, line, y) {
      line
      |> string.split("")
      |> list.index_fold(grid, fn(grid, c, x) {
        let tile = case c {
          "@" -> Roll
          "." -> Empty
          _ -> panic
        }
        dict.insert(grid, #(x, y), tile)
      })
    })
  #(grid, len)
}

const neighbor_deltas = [
  #(-1, -1),
  #(-1, 0),
  #(-1, 1),
  #(0, -1),
  #(0, 1),
  #(1, -1),
  #(1, -0),
  #(1, 1),
]

pub fn pt_1(input: #(dict.Dict(#(Int, Int), Tile), Int)) {
  let #(grid, _len) = input
  grid
  |> dict.filter(fn(_pos, tile) { tile == Roll })
  |> dict.map_values(fn(pos, _tile) {
    let #(x, y) = pos
    neighbor_deltas
    |> list.count(fn(delta) {
      let #(dx, dy) = delta
      let neighbor_tile = dict.get(grid, #(x + dx, y + dy))
      case neighbor_tile {
        Ok(Roll) -> True
        _ -> False
      }
    })
  })
  |> dict.filter(fn(pos, num_roll_neighbors) { num_roll_neighbors < 4 })
  |> dict.size
  // |> list.count(fn(num_roll_neighbors) { num_roll_neighbors < 4 })
}

pub fn pt_2(input: #(dict.Dict(#(Int, Int), Tile), Int)) {
  todo as "part 2 not implemented"
}
