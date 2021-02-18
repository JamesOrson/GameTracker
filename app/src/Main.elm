module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Example.Cat as Cat
import Html exposing (..)
import Html.Attributes exposing (..)
import Url
import Routes
import Routes exposing (Route(..))
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
type alias Model = 
  { route : Routes.Route
  , navKey : Nav.Key
  , title : String
  , catModel : Cat.Model
  }


init : () -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init _ url navKey =
  ( Model (Routes.fromUrl url) navKey "Game Tracker" Cat.Loading
  , Cmd.none)



-- UPDATE
type Msg
  = UrlChanged Url.Url
  | LinkClicked Browser.UrlRequest


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    UrlChanged url ->
      let
        newRoute = Routes.fromUrl url
      in
      ({model | route = newRoute}, Cmd.none)
    
    LinkClicked request ->
      case request of 
        Browser.Internal url ->
          (model, Nav.pushUrl model.navKey (Url.toString url))
        Browser.External href ->
          (model, Nav.load href)



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
      [ Sidenav.view ""
      , viewRoute model
      ]
    ]
  }


viewRoute : Model -> Html msg
viewRoute model =
  case model.route of
    Routes.Home ->
      div [] [text "Home"]
    
    Routes.Cat ->
      Cat.view model.catModel
    
    Routes.NotFound ->
      div [] [text "Not found"]