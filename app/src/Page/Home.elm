module Page.Home exposing ( Model
                          , Message
                          , init
                          , view
                          , update
                          , subscriptions
                          )

import Html exposing (..)
import Html.Attributes exposing (..)



-- MODEL
type alias Model = String

init : (Model, Cmd Message)
init =
  ( "Game Tracker Home" 
  , Cmd.none
  )



-- UPDATE
type Message
  = None


update : Message -> Model -> (Model, Cmd Message)
update message model =
  case message of
    None ->
      ( model
      , Cmd.none
      )



-- SUBSCRIPTIONS
subscriptions : Model -> Sub Message
subscriptions _ =
  Sub.none



-- VIEW
view : Model -> { title : String, body : Html Message }
view model =
  { title = model
  , body = div []
    [ h2 [] [ text "Home page" ]
    ]
  }