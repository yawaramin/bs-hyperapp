module Promise = Js.Promise

module State = struct
  let oldSync = None
  let newSync a = Some a
  let oldAsync u = u |> Promise.resolve |> ignore; None
  let newAsync a = Some (Promise.resolve a)
end

type 'msg vnode
type ('model, 'msg) view = 'model -> ('msg -> unit) -> 'msg vnode
type domElt = Bs_webapi.Dom.Element.t

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

external _h :
  string ->
  ?a:'attrs ->
  ([ `children of 'msg vnode array | `text of string ] [@bs.unwrap]) ->
  'msg vnode =
  "h" [@@bs.module "hyperapp"]

let h tagName ?a children =
  _h tagName ?a (`children (Array.of_list children))

let h_ tagName ?a text = _h tagName ?a (`text text)
external targetOfEvent : 'event -> domElt = "target" [@@bs.get]
external valueOfTarget : domElt -> string = "value" [@@bs.get]
let valueOfEvent e = e |> targetOfEvent |> valueOfTarget

type 'model state = < model : 'model > Js.t

type ('model, 'msg) actions =
  < update :
    'model state ->
    (*
    We don't really need to model this parameter exactly, since we only
    have one action function (`update`) and it's not going to call
    itself in our design, but it's easier to keep it than introduce a
    new type.
    *)
    ('model, 'msg) actions ->
    'msg ->
    'model state [@bs] > Js.t

type 'msg viewActions = < update : 'msg -> unit > Js.t

type ('model, 'msg) _view =
  'model state -> 'msg viewActions -> 'msg vnode [@bs]

external _app :
  < state : 'model state;
    view : ('model, 'msg) _view;
    actions : ('model, 'msg) actions;
    root : domElt > Js.t ->
    unit =
  "app" [@@bs.module "hyperapp"]

type ('model, 'msg) asyncActions =
  < update :
    'model state ->
    ('model, 'msg) asyncActions ->
    'msg ->
    (('model state -> unit Js.Promise.t) -> unit Js.Promise.t Js.undefined [@bs]) [@bs] > Js.t

external _asyncApp :
  < state : 'model state;
    view : ('model, 'msg) _view;
    actions : ('model, 'msg) asyncActions;
    events :
      < load : 'model state -> 'msg viewActions -> domElt -> unit [@bs];
        update : 'model state -> 'msg viewActions -> 'model state -> unit [@bs] > Js.t Js.undefined;

    root : domElt > Js.t ->
    unit =
  "app" [@@bs.module "hyperapp"]

let viewOf view = fun [@bs] state actions ->
  view state##model actions##update

let rootOf root =
  Js.Option.getExn Bs_webapi.Dom.(Document.getElementById root document)

let app ~model ~view ~update root =
  _app [%obj {
    state = [%obj { model }];
    view = viewOf view;

    actions =
      [%obj { update = fun [@bs] state _ payload ->
        [%obj { model = update state##model payload }] }];

    root = rootOf root }]

let asyncApp ~model ~view ~update ?events root =
  _asyncApp [%obj {
    state = [%obj { model }];
    view = viewOf view;

    actions =
      [%obj { update = fun [@bs] state _ payload -> fun [@bs] update' ->
        match update state##model payload with
          | Some promise ->
            promise
              |> Promise.then_ (fun model -> update' [%obj { model }])
              |> Js.Undefined.return

          | None -> Js.undefined }];

    events =
      events
        |> Js.Option.map (fun [@bs] events ->
          let sendEvent state actions event =
            event |> events state##model |> actions##update in

          let load = fun [@bs] state actions elt ->
            sendEvent state actions (`load elt) in

          let update = fun [@bs] state actions nextState ->
            sendEvent state actions (`update nextState##model) in

          [%obj { load; update }])

        |> Js.Undefined.from_opt;

    root = rootOf root }]
