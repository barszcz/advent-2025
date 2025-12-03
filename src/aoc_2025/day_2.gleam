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

fn is_invalid_p1(n: Int) -> Bool {
  let n_chars = n |> int.to_string |> string.to_graphemes
  let len = list.length(n_chars)
  use <- bool.guard(len % 2 != 0, False)
  let midpoint = len / 2
  case list.split(n_chars, midpoint) {
    #(xs, ys) if xs == ys -> True
    _ -> False
  }
}

fn is_invalid_p2(n: Int) -> Bool {
  let n_chars = n |> int.to_string |> string.to_graphemes
  let len = list.length(n_chars)
  use <- bool.guard(len == 1, False)
  let window_sizes = list.range(1, len / 2)
  use size <- list.any(window_sizes)
  use <- bool.guard(len % size != 0, False)
  n_chars |> list.sized_chunk(size) |> list.unique |> list.length == 1
}

fn run(input: List(#(Int, Int)), is_invalid: fn(Int) -> Bool) -> Int {
  use count, range <- list.fold(input, 0)
  let range = list.range(range.0, range.1)
  use inner_count, n <- list.fold(range, count)
  case is_invalid(n) {
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
