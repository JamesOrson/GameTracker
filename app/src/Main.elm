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
  ( Home Home.init
  , Cmd.none)



-- UPDATE
type Msg
  = UrlChanged Url.Url
  | LinkClicked Browser.UrlRequest
  | HomeMsg Home.Msg
  | CatMsg Cat.Msg


update : Msg -> Model -> (MainModel, Cmd Msg)
update msg model =
  case msg of
    UrlChanged url ->
      let
        newRoute = Routes.fromUrl url
        sidenavModel = model.sidenavModel
      in
      ( { model | route = newRoute
        , sidenavModel = {sidenavModel | activeRoute = newRoute}
        }
      , Cmd.none
      )

    LinkClicked request ->
      case request of 
        Browser.Internal url ->
          (model, Nav.pushUrl model.navKey (Url.toString url))
        Browser.External href ->
          (model, Nav.load href)
    
    HomeMsg message ->
      Home.update message 
        |> passUpdateTo Cat CatMsg model

    CatMsg message ->
      Cat.update message model.catModel
        |> passUpdateTo Cat CatMsg model


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
  { title = model.title
  , body =
    [ div []
      [ Sidenav.view model.sidenavModel
      , viewRoute model
      ]
    ]
  }


viewRoute : Model -> Html msg
viewRoute model =
  case model of
    Home home ->
      Home.view home
    
    Cat cat ->
      Cat.view cat
