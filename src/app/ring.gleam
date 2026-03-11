import gleam/dict.{type Dict}
import gleam/list
import gleam/result

pub type Link {
  Link(prev: String, next: String)
}

pub type Ring =
  Dict(String, Link)

pub fn build_ring(links: List(String)) {
  let padded = case links {
    [first] -> {
      [first, first, first]
    }
    [first, second, ..] -> list.append(links, [first, second])
    [] -> []
  }

  padded
  |> list.window(3)
  |> list.fold(from: dict.new(), with: fn(acc, win) {
    case win {
      [prev, curr, next] -> acc |> dict.insert(curr, Link(prev, next))
      _ -> acc
    }
  })
}

pub fn next(ring: Ring, key: String) {
  dict.get(ring, key) |> result.map(fn(v: Link) { v.next })
}

pub fn prev(ring: Ring, key: String) {
  dict.get(ring, key) |> result.map(fn(v: Link) { v.prev })
}
