open Hyperapp

type msg = Increment | Decrement | Reset | Set of int

let initModel = 0

let view model msg =
  let text = "Current value is: " ^ string_of_int model in

  h "div" [
    h_ "p" ~a:[%obj { _class = "main" }] text;
    h_ "button" ~a:[%obj { onclick = fun _ -> msg Increment }] "Increment";
    h_ "button" ~a:[%obj { onclick = fun _ -> msg Decrement }] "Decrement" ]

let update model = function
  | Increment -> model + 1
  | Decrement -> model - 1
  | Reset -> initModel
  | Set int -> int

let () = app ~model:initModel ~view ~update "root"
