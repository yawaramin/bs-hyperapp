open Hyperapp

type msg =
  Increment | Decrement | Reset | Edit of int | Set | Disable of bool
  [@@bs.deriving { accessors }]

(** Current value, new value, whether 'set' button disabled *)
let initModel = 0, 0, false

let view (value, newValue, disabled) msg =
  let text = "Current value is: " ^ string_of_int value in
  let onchange e =
    let m = try e |> valueOfEvent |> int_of_string |> edit with
      | _ -> disable true in

    msg m in

  let button ?(disabled=false) title m =
    h_ "button" ~a:[%obj { disabled; onclick = fun _ -> msg m }] title in

  h "div" ~a:[%obj { _class = "main" }] [
    h_ "p" text;
    button "Increment" increment;
    button "Decrement" decrement;
    button "Reset" reset;
    h "input" ~a:[%obj { value = newValue; onchange }] [];
    button ~disabled "Set" set ]

let update (value, newValue, disabled) = function
  | Increment -> value + 1, newValue, disabled
  | Decrement -> value - 1, newValue, disabled
  | Reset -> initModel
  | Edit newValue -> value, newValue, false
  | Set -> newValue, newValue, disabled
  | Disable bool -> value, newValue, bool

let () = app ~model:initModel ~view ~update "root"
