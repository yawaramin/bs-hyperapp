open Hyperapp

type msg =
  Increment | Decrement | Reset | Edit of int | Set | Disable of bool

(** Current value, edited value, 'set' button disabled or not *)
let initModel = 0, 0, false

let view (value, edit, disabled) msg =
  let text = "Current value is: " ^ string_of_int value in
  let onchange e =
    let m = try Edit (int_of_string (valueOfEvent e))
      with _ -> Disable true in

    msg m in

  let button ?(disabled=false) title m =
    h_ "button" ~a:[%obj { disabled; onclick = fun _ -> msg m }] title in

  h "div" [
    h_ "p" ~a:[%obj { _class = "main" }] text;
    button "Increment" Increment;
    button "Decrement" Decrement;
    button "Reset" Reset;
    h "input" ~a:[%obj { value = edit; onchange }] [];
    button ~disabled "Set" Set ]

let update (value, edit, disabled) = function
  | Increment -> value + 1, edit, disabled
  | Decrement -> value - 1, edit, disabled
  | Reset -> initModel
  | Edit edit -> value, edit, false
  | Set -> edit, edit, disabled
  | Disable bool -> value, edit, bool

let () = app ~model:initModel ~view ~update "root"
