let dictGet_exn key dict = Js.Dict.unsafeGet dict key

let get () =
  let open Bs_fetch in
  let module Json = Js.Json in
  let module Option = Js.Option in
  let module Promise = Js.Promise in

  fetch "http://quotes.rest/qod.json"
    |> Promise.then_ Response.json
    |> Promise.then_ (fun json ->
      json
        |> Json.decodeObject
    |> Option.getExn
    |> dictGet_exn "contents"
    |> Json.decodeObject
    |> Option.getExn
    |> dictGet_exn "quotes"
    |> Json.decodeArray
    |> Option.getExn
    |> (fun ary -> ary.(0))
    |> Json.decodeObject
    |> Option.getExn
    |> dictGet_exn "quote"
    |> Json.decodeString
    |> Promise.resolve)
