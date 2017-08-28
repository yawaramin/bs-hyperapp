(*
type vnode
type event
type data
type emit = event -> data -> data [@bs]
type ('s, 'a) view = 's -> 'a Js.t Js.undefined -> vnode [@bs]
type ('s, 'a) app_props =
  < state : 's;
    view : ('s, 'a) view;
    actions : 'a Js.t Js.undefined;
    events :
      < loaded :
          ('s -> 'a Js.t -> unit -> emit [@bs]) array Js.undefined;

        action :
          ('s -> 'a Js.t -> data -> emit [@bs]) array Js.undefined;

        update :
          ('s -> 'a Js.t -> data -> emit [@bs]) array Js.undefined;

        render :
          ('s -> 'a Js.t -> ('s, 'a) view -> emit [@bs]) array > Js.t Js.undefined;

    plugins : (('s, 'a) app_props -> ('s, 'a) app_props [@bs]) Js.undefined;
    root : Web.Element.t Js.undefined > Js.t

external h : string -> 'a Js.t -> 'c array -> vnode =
  "" [@@bs.module "hyperapp"]

external empty_obj : 'a Js.t = "" [@@bs.obj]

let hc tag ?(a=empty_obj) ?(c=[||]) () = h tag a c
let ht tag ?(a=empty_obj) text = h tag a [|text|]
*)

type vnode

type ('state, 'actions) app_params =
  < state : 'state Js.t Js.undefined;
    view : 'state -> 'actions -> vnode;
    actions : 'actions Js.t Js.undefined > Js.t

external h :
  string ->
  'attributes Js.t ->
  ([ `text of string | `children of vnode array ] [@bs.unwrap]) ->
  vnode =
  "" [@@bs.module "hyperapp"]

external _app : ('state, 'actions) app_params -> unit =
  "app" [@@bs.module "hyperapp"]

let app ?state ?actions view = _app [%bs.obj {
    state = Js.Undefined.from_opt state;
    view;
    actions = Js.Undefined.from_opt actions
  }]

