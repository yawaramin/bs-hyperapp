(**
Helper module for the user's `update` function. Helps to manage
returning old or new states for synchronous or async apps.
*)
module State : sig
  (**
  [oldSync] returns a value indicating that we didn't run any effects or
  change state.
  *)
  val oldSync : 'a option

  (**
  [newSync a] returns a value indicating that we didn't run any effects
  but did change the state to [a].
  *)
  val newSync : 'a -> 'a option

  (**
  [oldAsync u] runs the action [u] inside a JS promise and then returns
  a value indicating we didn't change state.
  *)
  val oldAsync : unit -> 'a Js.Promise.t option

  (**
  [newAsync a] runs the action [a] inside a JS promise and then returns
  a value indicating that we {e did} change state.
  *)
  val newAsync : 'a -> 'a Js.Promise.t option
end

(**
https://github.com/hyperapp/hyperapp/blob/master/docs/api.md#vnode
*)
type 'msg vnode

(** TEA-style view function for Hyperapp. *)
type ('model, 'msg) view = 'model -> ('msg -> unit) -> 'msg vnode

type domElt = Bs_webapi.Dom.Element.t

(**
Hyperapp's currently-recognised lifecycle events as per
https://github.com/hyperapp/hyperapp/blob/master/docs/events.md
*)
type ('model, 'msg, 'events) event =
  [> `load of domElt
  (* TODO: figure out how to handle these events. *)
  (*
  | `action of < name : string; data : 'actionData > Js.t
  | `resolve of unit Js.Promise.t
  | `custom of string * 'data
  *)
  | `update of 'model
  | `render of ('model, 'msg) view ] as 'events

(** Takes a list of node children. See also `h_`. *)
val h : string -> ?a:'attrs -> 'msg vnode list -> 'msg vnode

(** Takes a single text node. See also `h`. *)
val h_ : string -> ?a:'attrs -> string -> 'msg vnode
val valueOfEvent : 'event -> string

(**
TEA-style app runner function. This is the synchronous version (no
async effects). See also `asyncApp`.
*)
val app :
  model:'model ->
  view:('model, 'msg) view ->
  update:('model -> 'msg -> 'model) ->
  string ->
  unit

(**
Async version of `app`. Can take an `update` function that runs async
effects with JavaScript promises. Correct ordering of effects is
guaranteed (?) as long as all effects are captured in the promise
returned from the `update` function.
*)
val asyncApp :
  model:'model ->
  view:('model, 'msg) view ->
  update:('model -> 'msg -> 'model Js.Promise.t option) ->
  ?events:('model -> ('model, 'msg, 'events) event -> 'msg) ->
  string ->
  unit
