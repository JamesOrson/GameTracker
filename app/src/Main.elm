module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Page exposing (..)
import Page.Book as Book
import Page.Cat as Cat
import Page.Clock as Clock
import Page.Dice as Dice
import Page.Home as Home
import Html exposing (..)
import Html.Attributes exposing (..)
import Url
import Sidenav
import Html


-- MAIN
main : Program () Model Message
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
  = BookModel Book.Model
  | CatModel Cat.Model
  | ClockModel Clock.Model
  | DiceModel Dice.Model
  | HomeModel Home.Model

type alias Session =
  { navKey : Nav.Key
  , sidenavModel : Sidenav.Model
  }

init : () -> Url.Url -> Nav.Key -> (Model, Cmd Message)
init _ url navKey =
  Home.init
    |> convertUpdate HomeModel HomeMessage



-- UPDATE
type Message
  = UrlChanged Url.Url
  | LinkClicked Browser.UrlRequest
  | BookMessage Book.Message
  | CatMessage Cat.Message
  | ClockMessage Clock.Message
  | DiceMessage Dice.Message
  | HomeMessage Home.Message


update : Message -> Model -> (Model, Cmd Message)
update message model =
  case (message, model) of
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
    
    (HomeMessage innerMessage, HomeModel innerModel) ->
      Home.update innerMessage innerModel
        |> convertUpdate HomeModel HomeMessage

    (BookMessage bookMessage, BookModel innerModel) ->
      Book.update bookMessage innerModel
        |> convertUpdate BookModel BookMessage
    
    (CatMessage innerMessage, CatModel innerModel) ->
      Cat.update innerMessage innerModel
        |> convertUpdate CatModel CatMessage

    (ClockMessage innerMessage, ClockModel innerModel) ->
      Clock.update innerMessage innerModel
        |> convertUpdate ClockModel ClockMessage
    
    (DiceMessage innerMessage, DiceModel innerModel) ->
      Dice.update innerMessage innerModel
        |> convertUpdate DiceModel DiceMessage
    
    
    (_, _) ->
      (model, Cmd.none)


convertSubscription : (inMessage -> Message) -> Sub inMessage -> Sub Message
convertSubscription toMessage inMessage =
  Sub.map toMessage inMessage

convertUpdate : (inModel -> Model) -> (inMessage -> Message) -> (inModel, Cmd inMessage) -> (Model, Cmd Message)
convertUpdate toModel toMessage (subModel, subCommand) =
  ( toModel subModel
  , Cmd.map toMessage subCommand
  )

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Message
subscriptions model =
  case model of
    HomeModel innerModel ->
      Home.subscriptions innerModel
        |> convertSubscription HomeMessage
    
    BookModel innerModel ->
      Book.subscriptions innerModel
        |> convertSubscription BookMessage
    
    CatModel innerModel ->
      Cat.subscriptions innerModel
        |> convertSubscription CatMessage
    
    ClockModel innerModel ->
      Clock.subscriptions innerModel
        |> convertSubscription ClockMessage
    
    DiceModel innerModel ->
      Dice.subscriptions innerModel
        |> convertSubscription DiceMessage



-- VIEW
view : Model -> Browser.Document Message
view model =
  case model of
    HomeModel innerModel ->
      Page.view (Home.view innerModel) HomeMessage
    
    BookModel innerModel ->
      Page.view (Book.view innerModel) BookMessage
    
    CatModel innerModel ->
      Page.view (Cat.view innerModel) CatMessage
    
    ClockModel innerModel ->
      Page.view (Clock.view innerModel) ClockMessage
    
    DiceModel innerModel ->
      Page.view (Dice.view innerModel) DiceMessage
    
