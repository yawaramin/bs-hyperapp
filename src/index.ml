module Promise = Js.Promise

type 'a msg =
  | NoOp
  | Log of 'a
  | Increment
  | Decrement
  | Reset
  | Edit of int
  | Set
  | Disable of bool
  [@@bs.deriving { accessors }]

type model = { value : int; newValue : int; quote : string option }

let initModel = { value = 0; newValue = 0; quote = None }

let view { value; newValue; quote } msg =
  let open Hyperapp in
  let text = "Current value is: " ^ string_of_int value in
  (*
  If the edited new value is not a proper number and thus the 'set'
  button is disabled, display the quote of the day. Otherwise display
  nothing.
  *)
  let disabled, quoteText =
    match quote with Some text -> true, text | _ -> false, "" in

  let onchange e =
    let m = try e |> valueOfEvent |> int_of_string |> edit with
      | _ -> disable true in

    msg m in

  let button ?(disabled=false) title m =
    h_ "button" ~a:[%obj { disabled; onclick = fun _ -> msg m }] title in

  h "div" ~a:[%obj { _class = "main" }] [
    h_ "p" text;
    button "Increment" Increment;
    button "Decrement" Decrement;
    button "Reset" Reset;
    h "input" ~a:[%obj { value = newValue; onchange }] [];
    button ~disabled "Set" Set;
    h_ "p" quoteText ]

let update model =
  let open Hyperapp.State in
  let open Promise in

  function
    | NoOp -> oldAsync ()
    | Log string -> string |> Js.log |> oldAsync
    | Increment -> { model with value = model.value + 1 } |> newAsync
    | Decrement -> { model with value = model.value - 1 } |> newAsync
    | Reset -> initModel |> newAsync
    | Edit newValue -> { model with newValue; quote = None } |> newAsync
    | Set -> newAsync { model with value = model.newValue }
    | Disable disabled ->
      Some begin
        if disabled then () |> Index_Quote.get |> then_ (fun quote ->
          resolve { model with quote })

        else resolve { model with quote = None }
      end

let events _ = function
  | `load _ -> Edit 5
  | `update { value; newValue } ->
    Log begin
      Printf.sprintf "New model: value=%d newValue=%d" value newValue
    end

  | _ -> NoOp

let () = Hyperapp.asyncApp ~model:initModel ~view ~update ~events "root"
