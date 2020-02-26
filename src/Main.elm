module Main exposing (..)

import Browser
import Html.Attributes exposing (placeholder, type_)
import Regex
import Html exposing (Html, br, div, h2, input, text)
import Html.Events exposing (onInput)
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Textarea as Textarea

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
            { model | regex_regex = parseRegex str }

view : Model -> Html Msg
view model =
    div []
    [
        Form.form []
        [ h2 [] [ text "Elm Regex: Try your RegExs in Elm" ]
        , Form.group []
            [
                Input.text [ Input.attrs [ placeholder "Your regex" ], Input.onInput ReadRegex ]
            ]
        , br [] []
        , Form.group []
            [ Textarea.textarea
                [ Textarea.id "myarea"
                , Textarea.rows 3
                , Textarea.onInput ReadText
                ]
            ]
        ]
        , text "Matches: "
        , br [] []
        , viewMatches model
    ]

viewMatches : Model -> Html Msg
viewMatches model =
    let
        matches =
            Regex.split model.regex_regex model.text_string
    in
    div []
        (List.map (\match -> div [] [ text match, br [] [] ]) <| matches)

parseRegex : String -> Regex.Regex
parseRegex str =
    case str of
        "" ->
            Regex.never
        _ ->
            Maybe.withDefault Regex.never <| Regex.fromString str

