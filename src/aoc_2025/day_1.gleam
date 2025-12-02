import gleam/int
import gleam/list
import gleam/pair
import gleam/string

pub opaque type Direction {
  Left
  Right
}

pub opaque type Rotation {
  Rotation(direction: Direction, magnitude: Int)
}

fn parse_line(line: String) -> Rotation {
  case line {
    "L" <> magnitude -> {
      let assert Ok(magnitude) = int.parse(magnitude)
      Rotation(Left, magnitude)
    }
    "R" <> magnitude -> {
      let assert Ok(magnitude) = int.parse(magnitude)
      Rotation(Right, magnitude)
    }
    _ -> panic
  }
}

pub fn parse(input: String) -> List(Rotation) {
  input |> string.split("\n") |> list.map(parse_line)
}

pub fn pt_1(input: List(Rotation)) {
  list.map_fold(input, 50, fn(position, rotation) {
    let Rotation(direction, magnitude) = rotation
    let d = case direction {
      Left -> -1
      Right -> 1
    }
    let assert Ok(new_position) = int.modulo({ position + d * magnitude }, 100)
    #(new_position, new_position)
  })
  |> pair.second
  |> list.count(fn(p) { p == 0 })
}

pub fn pt_2(input: List(Rotation)) {
  list.map_fold(input, 50, fn(position, rotation) {
    let Rotation(direction, magnitude) = rotation
    let d = case direction {
      Left -> -1
      Right -> 1
    }
    let new_position_unmodded = position + d * magnitude
    // % operator on a negative numerator gives a negative result
    // This still happens to work for part 1 but won't for part 2
    // int.modulo gives us what we want
    let assert Ok(new_position) = int.modulo(new_position_unmodded, 100)
    let num_turns = int.absolute_value(new_position_unmodded) / 100
    let num_zeros = case position != 0 && new_position_unmodded <= 0 {
      True -> num_turns + 1
      False -> num_turns
    }
    #(new_position, num_zeros)
  })
  |> pair.second
  |> int.sum
}
