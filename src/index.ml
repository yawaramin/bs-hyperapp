let () =
  let open Hyperapp in
  let state = [%obj { value = 0 }] in

  let actions = object
    method increment state = [%obj { value = state##value + 1 }]
    method decrement state = [%obj { value = state##value - 1 }]
  end [@bs] in

  let root =
    Js.Option.getExn
      Bs_webapi.Dom.(Document.getElementById "root" document) in

  app ~state ~actions ~root begin fun [@bs] state actions ->
    let text = "Current value is: " ^ string_of_int state##value in

    h "div" [|
      h_ "p" ~a:[%obj { _class = "main" }] text;
      h_ "button" ~a:[%obj { onclick = actions##increment }] "Increment";
      h_ "button" ~a:[%obj { onclick = actions##decrement }] "Decrement" |]
  end

