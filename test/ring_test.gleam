import app/ring
import gleam/dict

pub fn ring_navigation_test() {
  let links = ["a", "b", "c", "d"]
  let expected =
    dict.from_list([
      #("a", ring.Link("d", "b")),
      #("b", ring.Link("a", "c")),
      #("c", ring.Link("b", "d")),
      #("d", ring.Link("c", "a")),
    ])

  let result = ring.build_ring(links)

  assert result == expected
}
