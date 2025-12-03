import gleam/bool
import gleam/int
import gleam/list
import gleam/string
import util/pairs
import util/parsing

pub fn parse(input: String) -> List(#(Int, Int)) {
  input
  |> string.split(",")
  |> list.map(fn(x) {
    string.split_once(x, "-")
    |> parsing.must
    |> pairs.map_pair(parsing.parse_int)
  })
}

fn is_invalid(n: Int, get_window_sizes: fn(Int) -> List(Int)) -> Bool {
  let n_chars = n |> int.to_string |> string.to_graphemes
  let len = list.length(n_chars)
  use <- bool.guard(len == 1, False)
  let window_sizes = get_window_sizes(len)
  use size <- list.any(window_sizes)
  use <- bool.guard(len % size != 0, False)
  n_chars |> list.sized_chunk(size) |> list.unique |> list.length == 1
}

fn is_invalid_p1(n: Int) -> Bool {
  is_invalid(n, fn(len) {
    case len % 2 == 0 {
      True -> [len / 2]
      False -> []
    }
  })
}

fn is_invalid_p2(n: Int) -> Bool {
  is_invalid(n, fn(len) { list.range(1, len / 2) })
}

fn run(input: List(#(Int, Int)), is_invalid_fn: fn(Int) -> Bool) -> Int {
  use count, range <- list.fold(input, 0)
  let range = list.range(range.0, range.1)
  use inner_count, n <- list.fold(range, count)
  case is_invalid_fn(n) {
    True -> inner_count + n
    False -> inner_count
  }
}

pub fn pt_1(input: List(#(Int, Int))) -> Int {
  run(input, is_invalid_p1)
}

pub fn pt_2(input: List(#(Int, Int))) {
  run(input, is_invalid_p2)
}
