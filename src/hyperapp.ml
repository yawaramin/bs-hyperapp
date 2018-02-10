type 'msg vnode
type ('model, 'msg) view = 'model -> ('msg -> unit) -> 'msg vnode
type 'model state = < model : 'model > Js.t

type ('model, 'msg) _view =
  'model state -> < update : 'msg -> unit > Js.t -> 'msg vnode [@bs]

type ('model, 'msg) actions =
  < update :
    'model state ->
    ('model, 'msg) actions ->
    'msg ->
    (('model state -> unit Js.Promise.t) -> unit Js.Promise.t [@bs]) [@bs] > Js.t

external _h :
  string ->
  ?a:'attrs ->
  ([ `children of 'msg vnode array | `text of string ] [@bs.unwrap]) ->
  'msg vnode =
  "h" [@@bs.module "hyperapp"]

let h tagName ?a children =
  _h tagName ?a (`children (Array.of_list children))

let h_ tagName ?a text = _h tagName ?a (`text text)

external targetOfEvent : 'event -> Bs_webapi.Dom.Element.t =
  "target" [@@bs.get]

external valueOfTarget : Bs_webapi.Dom.Element.t -> string =
  "value" [@@bs.get]

let valueOfEvent e = e |> targetOfEvent |> valueOfTarget

external app :
  < state : 'model state;
    view : ('model, 'msg) _view;
    actions : ('model, 'msg) actions;
    root : Bs_webapi.Dom.Element.t > Js.t -> unit =
  "" [@@bs.module "hyperapp"]

let viewOf view = fun [@bs] state actions ->
  view state##model actions##update

let rootOf root =
  Js.Option.getExn Bs_webapi.Dom.(Document.getElementById root document)

let app ~model ~view ~update root = app [%obj {
  state = {model};
  view = viewOf view;

  actions = {update = fun [@bs] state _ payload -> fun [@bs] update' ->
    payload |> update state##model |> Js.Promise.then_ (fun model' ->
    update' {model = model'})};

  root = rootOf root
}]
