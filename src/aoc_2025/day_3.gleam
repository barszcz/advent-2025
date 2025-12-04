import gleam/int
import gleam/list
import gleam/pair
import gleam/string
import util/parsing

pub fn parse(input: String) -> List(List(Int)) {
  use line <- parsing.parse_lines(input)
  line |> string.split("") |> list.map(parsing.parse_int)
}

// 1. find max battery within array, ignoring last (n - 1) batteries
// 2. take index of that max, find max battery from that point forward in array, ignoring last (n - 2) batteries
// 3. Repeat until we've filled up our digit list, then convert to a number
fn find_joltage(batteries: List(Int), num_digits: Int) -> Int {
  let len = list.length(batteries)
  list.range(num_digits - 1, 0)
  |> list.map_fold(0, fn(cutoff_left, cutoff_right) {
    let #(digit, idx) =
      batteries
      |> list.take(len - cutoff_right)
      |> list.drop(cutoff_left)
      |> list.index_fold(#(0, 0), fn(acc, battery, idx) {
        let #(max, _) = acc
        case battery > max {
          True -> #(battery, idx)
          False -> acc
        }
      })
    #(idx + cutoff_left + 1, digit)
  })
  |> pair.second
  |> int.undigits(10)
  |> parsing.must
}

pub fn pt_1(input: List(List(Int))) {
  input |> list.map(find_joltage(_, 2)) |> int.sum
}

pub fn pt_2(input: List(List(Int))) {
  input |> list.map(find_joltage(_, 12)) |> int.sum
}
