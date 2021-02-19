module Page.Home exposing (..)

import Browser
import Browser.Navigation as Nav
import Example.Cat as Cat
import Html exposing (..)
import Html.Attributes exposing (..)
import Url
import Routes
import Sidenav



-- MODEL
type alias Model =
  { title : String }

init : (Model, Cmd Msg)
init =
  ( Model
      "Game Tracker Home" 
  , Cmd.none
  )



-- UPDATE
type Msg
  = None


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    None ->
      ( model
      , Cmd.none
      )



-- VIEW
view : Model -> Html msg
view model =
  div [] [ text "Home page"]
