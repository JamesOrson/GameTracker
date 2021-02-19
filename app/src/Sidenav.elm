module Sidenav exposing (Model, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Routes



type alias Model =
  { activeRoute : Routes.Route
  , routes : List Routes.Route
  }


view : Model -> Html msg
view model =
  ul []
    [ navLink Routes.Home "Home" model
    , navLink Routes.Cat "Cat" model
    ]

navLink : Routes.Route -> String -> Model -> Html msg
navLink route name model =
  li []
    [ a
      [ href (Routes.toRouteString route)
      , style "text-decoration" "none"
      , if route == model.activeRoute then (style "color" "green") else (style "color" "red")
      ]
      [ text name ]
    ]