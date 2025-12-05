import gleam/dict
import gleam/list
import gleam/string

pub type Pos =
  #(Int, Int)

pub type Grid(a) =
  dict.Dict(Pos, a)

pub fn parse_grid(input: String, f: fn(String) -> a) -> Grid(a) {
  let lines = input |> string.split("\n")
  list.index_fold(lines, dict.new(), fn(grid, line, y) {
    line
    |> string.split("")
    |> list.index_fold(grid, fn(grid, c, x) {
      let val = f(c)
      dict.insert(grid, #(x, y), val)
    })
  })
}

const neighbor_deltas_8 = [
  #(-1, -1),
  #(-1, 0),
  #(-1, 1),
  #(0, -1),
  #(0, 1),
  #(1, -1),
  #(1, -0),
  #(1, 1),
]

const neighbor_deltas_4 = [
  #(-1, 0),
  #(0, -1),
  #(0, 1),
  #(1, -0),
]

fn get_neighbors(grid: Grid(a), pos: Pos, neighbor_deltas: List(Pos)) -> List(a) {
  let #(x, y) = pos
  use delta <- list.filter_map(neighbor_deltas)
  let #(dx, dy) = delta
  dict.get(grid, #(x + dx, y + dy))
}

pub fn get_4_neighbors(grid: Grid(a), pos: Pos) -> List(a) {
  get_neighbors(grid, pos, neighbor_deltas_4)
}

pub fn get_8_neighbors(grid: Grid(a), pos: Pos) -> List(a) {
  get_neighbors(grid, pos, neighbor_deltas_8)
}
