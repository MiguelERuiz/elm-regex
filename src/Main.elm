module Main exposing (..)

import Browser
import Html.Attributes exposing (placeholder, type_)
import Regex
import Html exposing (Html, br, div, input, text)
import Html.Events exposing (onInput)

main =
    Browser.sandbox { init = init, update = update, view = view }

type alias Model =
    { text_string : String,
        regex_regex : Regex.Regex
    }

type Msg
    = ReadRegex String
    | ReadText String

init : Model
init =
    { text_string = "", regex_regex = Regex.never }

update : Msg -> Model -> Model
update msg model =
    case msg of
        ReadText content ->
            { model | text_string = content }
        ReadRegex str ->
            { model | regex_regex = Maybe.withDefault Regex.never <| Regex.fromString str }

view : Model -> Html Msg
view model =
    div []
    [
        div []
        [ input [ type_ "text", placeholder "Your regex", onInput ReadRegex  ] [],
            br [] [],
            input [ type_ "text", placeholder "Your text", onInput ReadText  ] [],
            br [] [],
            text "Matches",
            viewMatches model
        ]
    ]

viewMatches : Model -> Html Msg
viewMatches model =
    let
        matches =
            Regex.split model.regex_regex model.text_string
    in
    div []
        (List.map (\match -> div [] [ text match ]) <| matches)

