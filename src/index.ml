open Hyperapp

type msg =
  Increment | Decrement | Reset | Edit of int | Set | Disable of bool
  [@@bs.deriving { accessors }]

type model = { value : int; newValue : int; disabled : bool }

let initModel = { value = 0; newValue = 0; disabled = false }

let view { value; newValue; disabled } msg =
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

let update model = function
  | Increment -> { model with value = model.value + 1 }
  | Decrement -> { model with value = model.value - 1 }
  | Reset -> initModel
  | Edit newValue -> { model with newValue; disabled = false }
  | Set -> { model with value = model.newValue }
  | Disable disabled -> { model with disabled }

let () = app ~model:initModel ~view ~update "root"

