type msg =
  Increment | Decrement | Reset | Edit of int | Set | Disable of bool
  [@@bs.deriving {accessors}]

type model = {value : int; newValue : int; quote : string option}

let initModel = {value = 0; newValue = 0; quote = None}

let onchange msg e =
  let m = try e |> Hyperapp.valueOfEvent |> int_of_string |> edit with
  | _ -> disable true in
  msg m

let button msg m ?(disabled=false) title = Hyperapp.h_
  "button" ~a:[%obj {disabled; onclick = fun _ -> msg m}] title

let view {value; newValue; quote} msg =
  let open Hyperapp in
  (* If the edited new value is not a proper number and thus the 'set'
     button is disabled, display the quote of the day. Otherwise display
     nothing. *)

  let disabled, quoteText =
    match quote with Some text -> true, text | _ -> false, "" in

  h "div" ~a:[%obj {_class = "main"}] [
    h_ "p" {j|Current value is: $value|j};
    button msg increment "Increment";
    button msg decrement "Decrement";
    button msg reset "Reset";
    h "input" ~a:[%obj { value = newValue; onchange = onchange msg }] [];
    button msg set ~disabled "Set";
    h_ "p" quoteText ]

let update model = let open Js.Promise in function
| Increment -> resolve {model with value = model.value + 1}
| Decrement -> resolve {model with value = model.value - 1}
| Reset -> resolve initModel
| Edit newValue -> resolve {model with newValue; quote = None}
| Set -> resolve {model with value = model.newValue}
| Disable disabled ->
  if disabled then Index_Quote.get () |> then_ (fun quote ->
    resolve {model with quote})
  else resolve { model with quote = None }

let () = Hyperapp.app ~model:initModel ~view ~update "root"
