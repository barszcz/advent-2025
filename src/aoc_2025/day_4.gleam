import gleam/bool
import gleam/dict
import gleam/list
import gleam/result
import gleam/string

pub opaque type Tile {
  Roll
  Empty
  Removed
}

type Pos =
  #(Int, Int)

type Grid =
  dict.Dict(Pos, Tile)

pub fn parse(input: String) -> Grid {
  let lines = input |> string.split("\n")
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

// more direct to count the roll neighbords here
// but might pull this shit out into utils
fn get_neighbors(grid: Grid, pos: Pos) {
  let #(x, y) = pos
  use delta <- list.filter_map(neighbor_deltas)
  let #(dx, dy) = delta
  dict.get(grid, #(x + dx, y + dy))
}

fn maybe_remove_roll(grid: Grid, pos: Pos, tile: Tile) {
  use <- bool.guard(tile != Roll, tile)
  let neighbors = get_neighbors(grid, pos)
  let num_roll_neighbors =
    list.count(neighbors, fn(neighbor) { neighbor == Roll })
  case num_roll_neighbors < 4 {
    True -> Removed
    False -> Roll
  }
}

fn remove_rolls(grid: Grid) {
  dict.map_values(grid, fn(pos, tile) { maybe_remove_roll(grid, pos, tile) })
}

fn count_removed(grid: Grid) {
  dict.values(grid) |> list.count(fn(tile) { tile == Removed })
}

fn remove_rolls_recursive(grid: Grid) {
  let current_removed_count = count_removed(grid)
  let removed_grid = remove_rolls(grid)
  let new_removed_count = count_removed(removed_grid)
  case new_removed_count == current_removed_count {
    True -> removed_grid
    False -> remove_rolls_recursive(removed_grid)
  }
}

pub fn pt_1(input: Grid) {
  input
  |> remove_rolls
  |> count_removed
}

pub fn pt_2(input: Grid) {
  input
  |> remove_rolls_recursive
  |> count_removed
}
