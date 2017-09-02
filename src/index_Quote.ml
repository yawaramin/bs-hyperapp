external responseOfJson :
  Js.Json.t ->
  < contents : < quotes : < quote : string > Js.t array > Js.t > Js.t =
  "%identity"

let get () =
  let open Bs_fetch in
  let module Promise = Js.Promise in

  fetch "http://quotes.rest/qod.json"
    |> Promise.then_ Response.json
    |> Promise.then_ (fun json ->
      let quote =
        try Some ((responseOfJson json)##contents##quotes).(0)##quote with
          | _ -> None in

      Promise.resolve quote)
