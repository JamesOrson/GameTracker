module Sidenav exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Routes



view : String -> Html msg
view activePage =
  ul []
    [ navLink "/" "Home"
    , navLink "cat" "Cat"
    ]

navLink : String -> String -> Html msg
navLink path name =
  li []
    [ a
      [ href path
      , style "text-decoration" "none"
      , style "color" "blue"
      ]
      [ text name ]
    ]