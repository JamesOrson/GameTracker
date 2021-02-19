module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Example.Cat as Cat
import Html exposing (..)
import Html.Attributes exposing (..)
import Page.Home as Home
import Url
import Routes
import Sidenav



-- MAIN
main : Program () Model Msg
main =
  Browser.application
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
    }



-- MODEL
type Model
  = Home Home.Model
  | Cat Cat.Model

type alias Session =
  { navKey : Nav.Key
  , sidenavModel : Sidenav.Model
  }

init : () -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init _ url navKey =
  Home.init
    |> passUpdateTo Home HomeMsg



-- UPDATE
type Msg
  = UrlChanged Url.Url
  | LinkClicked Browser.UrlRequest
  | HomeMsg Home.Msg
  | CatMsg Cat.Msg


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case (msg, model) of
    (UrlChanged url, _) ->
      (model, Cmd.none)
      -- let
      --   newRoute = Routes.fromUrl url
      --   sidenavModel = model.sidenavModel
      -- in
      -- ( { model | route = newRoute
      --   , sidenavModel = {sidenavModel | activeRoute = newRoute}
      --   }
      -- , Cmd.none
      -- )

    (LinkClicked request, _) ->
      (model, Cmd.none)
      -- case request of 
      --   Browser.Internal url ->
      --     (model, Nav.pushUrl model.navKey (Url.toString url))
      --   Browser.External href ->
      --     (model, Nav.load href)
    
    (HomeMsg message, Home home) ->
      Home.update message home
        |> passUpdateTo Home HomeMsg

    (CatMsg message, _) ->
      (model, Cmd.none)
      -- Cat.update message model.catModel
      --   |> passUpdateTo Cat CatMsg
    (_, _) ->
      (model, Cmd.none)


passUpdateTo : (subModelType -> Model) -> (subMessageType -> Msg) -> (subModelType, Cmd subMessageType) -> (Model, Cmd Msg)
passUpdateTo toModel toMessage (subModel, subCommand) =
  ( toModel subModel
  , Cmd.map toMessage subCommand
  )

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none



-- VIEW
view : Model -> Browser.Document Msg
view model =
  { title = "Game Tracker"
  , body =
    [ div []
      -- [ Sidenav.view model.sidenavModel
      -- , viewRoute model
      -- ]
      [ viewRoute model ]
    ]
  }


viewRoute : Model -> Html msg
viewRoute model =
  case model of
    Home home ->
      Home.view home
    
    Cat cat ->
      div [] [text "Cat"]
      -- Cat.view cat
