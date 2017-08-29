let () =
  let open Hyperapp in
  let state = [%bs.obj { value = 0 }] in

  let view = fun [@bs] state actions ->
    let text = "Current value is: " ^ string_of_int state##value in

    h "div" [|
      h_ "p" ~attrs:[%bs.obj { _class = "main" }] text;
      h_ "button" ~attrs:[%bs.obj { onclick = actions##increment }] "Increment";
      h_ "button" ~attrs:[%bs.obj { onclick = actions##decrement }] "Decrement" |] in

  let actions = object
    method increment state = [%bs.obj { value = state##value + 1 }]
    method decrement state = [%bs.obj { value = state##value - 1 }]
  end [@bs] in

  match Bs_webapi.Dom.(Document.getElementById "root" document) with
    | Some root -> app ~state ~view ~actions root
    | None -> ()

