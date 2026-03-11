import gleam/dict
import gleam/result
import gleam/uri
import wisp.{type Request}

pub fn referer(req: Request) {
  req.headers
  |> dict.from_list
  |> dict.get("referer")
  |> result.try(uri.parse)
  |> result.try(uri.origin)
}
