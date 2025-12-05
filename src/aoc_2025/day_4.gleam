import gleam/bool
import gleam/dict
import gleam/list
import util/grid.{type Grid, type Pos, get_8_neighbors}

pub opaque type Tile {
  Roll
  Empty
  Removed
}

pub fn parse(input: String) -> Grid(Tile) {
  grid.parse_grid(input, fn(c) {
    case c {
      "@" -> Roll
      "." -> Empty
      _ -> panic
    }
  })
}

fn maybe_remove_roll(grid: Grid(Tile), pos: Pos, tile: Tile) {
  use <- bool.guard(tile != Roll, tile)
  let neighbors = get_8_neighbors(grid, pos)
  let num_roll_neighbors =
    list.count(neighbors, fn(neighbor) { neighbor == Roll })
  case num_roll_neighbors < 4 {
    True -> Removed
    False -> Roll
  }
}

fn remove_rolls(grid: Grid(Tile)) {
  dict.map_values(grid, fn(pos, tile) { maybe_remove_roll(grid, pos, tile) })
}

fn count_removed(grid: Grid(Tile)) {
  dict.values(grid) |> list.count(fn(tile) { tile == Removed })
}

fn remove_rolls_recursive(grid: Grid(Tile)) {
  let current_removed_count = count_removed(grid)
  let removed_grid = remove_rolls(grid)
  let new_removed_count = count_removed(removed_grid)
  case new_removed_count == current_removed_count {
    True -> removed_grid
    False -> remove_rolls_recursive(removed_grid)
  }
}

pub fn pt_1(input: Grid(Tile)) {
  input
  |> remove_rolls
  |> count_removed
}

pub fn pt_2(input: Grid(Tile)) {
  input
  |> remove_rolls_recursive
  |> count_removed
}
