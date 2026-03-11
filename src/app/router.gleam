import app/request
import app/ring
import app/web.{type Context, middleware}
import gleam/list
import gleam/result
import lustre/attribute
import lustre/element
import lustre/element/html
import wisp.{type Request, type Response}

fn to_href(domain) {
  "https://" <> domain
}

fn link_item(str) {
  html.li([], [
    html.a([attribute.href(str |> to_href)], [
      html.text(str),
    ]),
  ])
}

fn index(ctx: Context) {
  let links =
    ctx.domains
    |> list.map(link_item)
    |> html.ul([], _)

  html.main([], [
    html.h1([], [html.text("Welcome to Nabeel's Webring")]),
    html.p([], [
      html.a([attribute.href("/random")], [html.text("Random Link")]),
    ]),
    links,
  ])
  |> element.to_document_string
  |> wisp.html_response(200)
}

fn previous(req: Request, ctx: Context) {
  let ref =
    request.referer(req)
    |> result.try(ring.prev(ctx.ring, _))

  case ref {
    Ok(from) -> wisp.redirect(from |> to_href)
    _ -> random(ctx)
  }
}

fn next(req: Request, ctx: Context) {
  let ref =
    request.referer(req)
    |> result.try(ring.next(ctx.ring, _))

  case ref {
    Ok(from) -> wisp.redirect(from |> to_href)
    _ -> random(ctx)
  }
}

fn random(ctx: Context) {
  let assert Ok(random) = ctx.domains |> list.shuffle |> list.first
  wisp.redirect(random |> to_href)
}

pub fn handle_request(req: Request, ctx: Context) -> Response {
  use _ <- middleware(req)

  case wisp.path_segments(req) {
    [] -> index(ctx)
    ["previous"] -> previous(req, ctx)
    ["next"] -> next(req, ctx)
    ["random"] -> random(ctx)
    _ -> wisp.not_found()
  }
}
