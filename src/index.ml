open Hyperapp

type msg = Increment | Decrement | Reset | Edit of string | Set

let initModel = 0, "0"

let view (value, edit) msg =
  let text = "Current value is: " ^ string_of_int value in

  h "div" [
    h_ "p" ~a:[%obj { _class = "main" }] text;
    h_ "button" ~a:[%obj { onclick = fun _ -> msg Increment }] "Increment";
    h_ "button" ~a:[%obj { onclick = fun _ -> msg Decrement }] "Decrement";
    h_ "button" ~a:[%obj { onclick = fun _ -> msg Reset }] "Reset";
    h "input" ~a:[%obj { value = edit; onchange = fun e -> msg (Edit (valueOfEvent e)) }] [];
    h_ "button" ~a:[%obj { onclick = fun _ -> msg Set }] "Set" ]

let update ((value, edit) as model) = function
  | Increment -> value + 1, edit
  | Decrement -> value - 1, edit
  | Reset -> initModel
  | Edit edit -> value, edit
  | Set -> try int_of_string edit, edit with  _ -> model

let () = app ~model:initModel ~view ~update "root"

