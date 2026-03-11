import gleam/dict
import gleam/option
import gleam/result
import gleam/uri
import wisp.{type Request}

pub fn referer_domain(req: Request) {
  req.headers
  |> dict.from_list
  |> dict.get("referer")
  |> result.try(uri.parse)
  |> result.try(fn(u) { option.to_result(u.host, Nil) })
}
