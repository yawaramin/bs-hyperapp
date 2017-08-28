let () =
  Hyperapp.(app (fun _ _ ->
    h "p" [%bs.obj { className = "main" }] (`text "Hello, Hyperapp!")))

