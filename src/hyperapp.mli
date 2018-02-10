(** https://github.com/hyperapp/hyperapp/blob/master/docs/api.md#vnode *)
type 'msg vnode

(** TEA-style view function for Hyperapp. *)
type ('model, 'msg) view = 'model -> ('msg -> unit) -> 'msg vnode

(** Takes a list of node children. See also `h_`. *)
val h : string -> ?a:'attrs -> 'msg vnode list -> 'msg vnode

(** Takes a single text node. See also `h`. *)
val h_ : string -> ?a:'attrs -> string -> 'msg vnode
val valueOfEvent : 'event -> string

(** [app model view update root] creates an app with state contained in
    [model], the view rendered by [view], state updater function in
    [update], and mounted on the DOM node with ID [root]. *)
val app :
  model:'model ->
  view:('model, 'msg) view ->
  update:('model -> 'msg -> 'model Js.Promise.t) ->
  string ->
  unit
