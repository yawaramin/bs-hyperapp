let () =
  let view _ _ =
    Hyperapp.h
      "p" [%bs.obj { className = "main" }] (`text "Hello, Hyperapp!") in

  match Bs_webapi.Dom.(Document.getElementById "root" document) with
    | Some root -> Hyperapp.app ~view root
    | None -> ()

