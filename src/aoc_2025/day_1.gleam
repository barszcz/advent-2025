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
  list.fold(input, #(50, 0), fn(acc, rotation) {
    let #(position, zeros) = acc
    let Rotation(direction, magnitude) = rotation
    let d = case direction {
      Left -> -1
      Right -> 1
    }
    let assert Ok(new_position) = int.modulo({ position + d * magnitude }, 100)
    case new_position == 0 {
      True -> #(new_position, zeros + 1)
      False -> #(new_position, zeros)
    }
  })
  |> pair.second
}

pub fn pt_2(input: List(Rotation)) {
  list.fold(input, #(50, 0), fn(acc, rotation) {
    let #(position, zeros) = acc
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
    let new_zeros = case position != 0 && new_position_unmodded <= 0 {
      True -> num_turns + 1
      False -> num_turns
    }
    #(new_position, zeros + new_zeros)
  })
  |> pair.second
}
