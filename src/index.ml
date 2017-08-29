let () =
  let state = [%bs.obj { value = 0 }] in

  let view = fun [@bs] state _ ->
    let text = "Current value is: " ^ string_of_int state##value in
    Hyperapp.h "p" [%bs.obj { className = "main" }] (`text text) in

  match Bs_webapi.Dom.(Document.getElementById "root" document) with
    | Some root -> Hyperapp.app ~state ~view root
    | None -> ()

