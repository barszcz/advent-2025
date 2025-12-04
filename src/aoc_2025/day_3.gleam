import gleam/int
import gleam/list
import gleam/pair
import gleam/string
import util/parsing

pub fn parse(input: String) -> List(List(Int)) {
  use line <- parsing.parse_lines(input)
  line |> string.split("") |> list.map(parsing.parse_int)
}

fn find_joltage_p1(batteries: List(Int)) -> Int {
  let len = list.length(batteries)
  let #(first_digit, first_digit_idx) =
    batteries
    |> list.take(len - 1)
    |> list.index_fold(#(0, 0), fn(acc, battery, idx) {
      let #(max, _) = acc
      case battery > max {
        True -> #(battery, idx)
        False -> acc
      }
    })
  let last_digit =
    batteries
    |> list.drop(first_digit_idx + 1)
    |> list.reduce(int.max)
    |> parsing.must
  10 * first_digit + last_digit
}

fn find_joltage_p2(batteries: List(Int)) -> Int {
  let len = list.length(batteries)
  list.range(11, 0)
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
  input |> list.map(find_joltage_p1) |> int.sum
}

pub fn pt_2(input: List(List(Int))) {
  input |> list.map(find_joltage_p2) |> int.sum
}
