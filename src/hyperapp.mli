(**
https://github.com/hyperapp/hyperapp/blob/master/docs/api.md#vnode
*)
type 'msg vnode

(** TEA-style view function for Hyperapp. *)
type ('model, 'msg) view = 'model -> ('msg -> unit) -> 'msg vnode

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
  update:('model -> 'msg -> 'model Js.Promise.t) ->
  string ->
  unit
