module Mwc.Snackbar exposing (Model, Msg, actionClick, add, buttonText, message, model, payload, timeout, update, view)

{-| Material Snackbar. It was designed following material design principles

@docs Model, Msg, actionClick, add, buttonText, message, model, payload, timeout, update, view

-}

import Css exposing (..)
import Css.Transitions exposing (cubicBezier, transition)
import Html.Styled exposing (Html, div, span, text)
import Html.Styled.Attributes as Attr
import Mwc.Button as Button
import Mwc.IconButton as IconButton
import Process
import Task


type Property msg a
    = Message String
    | ButtonText String
    | Timeout Float
    | ButtonClick (Maybe (Maybe a -> msg))
    | Payload (Maybe a)



---- CONFIG ----


type alias Config msg a =
    { message : String
    , buttonText : String
    , timeout : Float
    , buttonClick : Maybe (Maybe a -> msg)
    , id : Int
    , toMsg : Msg msg a -> msg
    , payload : Maybe a
    }


defaultConfig : Int -> (Msg msg a -> msg) -> Config msg a
defaultConfig id toMsg =
    { message = ""
    , buttonText = ""
    , timeout = 3000
    , buttonClick = Nothing
    , id = id
    , toMsg = toMsg
    , payload = Nothing
    }



---- State ----


type State msg a
    = Active (Config msg a)
    | Closed



---- MODEL ----


{-| SnackBar model
-}
type alias Model msg a =
    { queue : List (Config msg a)
    , state : State msg a
    , index : Int
    }



-- default model


{-| default model for snackbar
-}
model : Model msg a
model =
    { queue = []
    , state = Closed
    , index = 0
    }



---- Property Functions ----


{-| Sets message to be displayed
-}
message : String -> Property msg a
message val =
    Message val


{-| Sets Action button text
-}
buttonText : String -> Property msg a
buttonText val =
    ButtonText val


{-| Amount of time (in ms) the snackbar should be displayed default is 3000ms
-}
timeout : Float -> Property msg a
timeout val =
    Timeout val


{-| Sets click functionality to action button
-}
actionClick : (Maybe a -> msg) -> Property msg a
actionClick val =
    ButtonClick (Just val)


{-| payload which is returned when action button is clicked
-}
payload : a -> Property msg a
payload load =
    Payload (Just load)



---- UPDATE ----


{-| SnackBar Messages
-}
type Msg msg a
    = CloseSnackBar Int
    | ActionClick (Config msg a)
    | NoOp


{-| Snackbar update functions
-}
update : Msg msg a -> Model msg a -> ( Model msg a, Cmd msg )
update msg snackbarModel =
    case msg of
        NoOp ->
            ( snackbarModel, Cmd.none )

        ActionClick config ->
            tryDequeue { snackbarModel | state = Closed }
                |> (\( m, c ) ->
                        case config.buttonClick of
                            Just actionMsg ->
                                ( m, Cmd.batch [ c, msgToCmd (actionMsg config.payload) ] )

                            Nothing ->
                                ( m, c )
                   )

        CloseSnackBar id ->
            case snackbarModel.state of
                Active config ->
                    if config.id == id then
                        tryDequeue { snackbarModel | state = Closed }

                    else
                        ( snackbarModel, Cmd.none )

                Closed ->
                    tryDequeue snackbarModel


msgToCmd : msg -> Cmd msg
msgToCmd val =
    Task.succeed val
        |> Task.perform identity


{-| used to add snackbar or toast
-}
add : List (Property msg a) -> Model msg a -> (Msg msg a -> msg) -> ( Model msg a, Cmd msg )
add properties snackbarModel toMsg =
    let
        config =
            fetchConfig snackbarModel.index toMsg properties
    in
    enqueue config snackbarModel
        |> tryDequeue


fetchConfig : Int -> (Msg msg a -> msg) -> List (Property msg a) -> Config msg a
fetchConfig id toMsg properties =
    let
        config =
            defaultConfig id toMsg
    in
    List.foldl propToConfig config properties


propToConfig : Property msg a -> Config msg a -> Config msg a
propToConfig prop config =
    case prop of
        Message val ->
            { config | message = val }

        ButtonText val ->
            { config | buttonText = val }

        Timeout val ->
            { config | timeout = val }

        ButtonClick val ->
            { config | buttonClick = val }

        Payload val ->
            { config | payload = val }


enqueue : Config msg a -> Model msg a -> Model msg a
enqueue config snackbarModel =
    { snackbarModel
        | queue = config :: snackbarModel.queue
        , index = snackbarModel.index + 1
    }


tryDequeue : Model msg a -> ( Model msg a, Cmd msg )
tryDequeue snackbarModel =
    case snackbarModel.state of
        Active val ->
            ( snackbarModel, Cmd.none )

        Closed ->
            dequeue snackbarModel


dequeue : Model msg a -> ( Model msg a, Cmd msg )
dequeue snackbarModel =
    case snackbarModel.queue of
        x :: xs ->
            ( { snackbarModel
                | state = Active x
                , queue = xs
              }
            , setTimeOut x
            )

        _ ->
            ( snackbarModel, Cmd.none )


setTimeOut : Config msg a -> Cmd msg
setTimeOut config =
    Process.sleep config.timeout
        |> Task.perform (\_ -> config.toMsg (CloseSnackBar config.id))


{-| Snackbar view
-}
view : Model msg a -> (Msg msg a -> msg) -> Html msg
view snackbarModel toMsg =
    let
        ( config, isActive ) =
            case snackbarModel.state of
                Active c ->
                    ( c, True )

                Closed ->
                    ( defaultConfig -1 toMsg, False )
    in
    div
        [ Attr.css
            [ displayFlex
            , zIndex (int 8)
            , justifyContent center
            , alignItems center
            , position fixed
            , right (px 0)
            , left (px 0)
            , bottom (px 0)
            , margin (px 0)
            , if isActive then
                pointerEvents auto

              else
                pointerEvents none
            ]
        ]
        [ snackbarContainer config isActive toMsg ]


snackbarContainer : Config msg a -> Bool -> (Msg msg a -> msg) -> Html msg
snackbarContainer config isActive toMsg =
    div
        [ Attr.css
            [ backgroundColor (rgba 0 0 0 0.87)
            , color (rgba 255 255 255 0.87)
            , borderRadius (px 4)
            , property "box-shadow"
                "0px 3px 5px -1px rgba(0, 0, 0, 0.2), 0px 6px 10px 0px rgba(0, 0, 0, 0.14), 0px 1px 18px 0px rgba(0, 0, 0, 0.12)"
            , minHeight (px 48)
            , displayFlex
            , flexWrap wrap
            , justifyContent flexStart
            , alignItems center
            , flexBasis (px 344)
            , if isActive then
                transition
                    [ Css.Transitions.opacity 150
                    , Css.Transitions.transform3 150 0 (cubicBezier 0 0 0.2 1)
                    ]

              else
                Css.batch
                    [ opacity (int 0)
                    , pointerEvents none
                    ]
            ]
        ]
        [ div
            [ Attr.css
                [ paddingLeft (px 16)
                , fontSize (px 14)
                , fontFamilies [ "Roboto" ]
                , flexGrow (int 1)
                , textAlign start
                ]
            ]
            [ text config.message ]
        , actionButton config
        ]


actionButton : Config msg a -> Html msg
actionButton config =
    div
        [ Attr.css
            [ padding2 (px 6) (px 8)
            , flexShrink (int 0)
            ]
        ]
        (if config.buttonText == "" then
            [ IconButton.view
                [ IconButton.icon "clear"
                , IconButton.onClick (config.toMsg (CloseSnackBar config.id))
                , IconButton.extraAttributes
                    [ Attr.css
                        [ width (px 36)
                        , height (px 36)
                        , fontSize (px 18)
                        ]
                    ]
                ]
            ]

         else
            [ Button.view
                [ Button.label config.buttonText
                , Button.onClick (config.toMsg (ActionClick config))
                , Button.extraAttributes
                    [ Attr.css
                        [ property "--mdc-theme-primary" "#bb86fc" ]
                    ]
                ]
            , IconButton.view
                [ IconButton.icon "clear"
                , IconButton.onClick (config.toMsg (CloseSnackBar config.id))
                , IconButton.extraAttributes
                    [ Attr.css
                        [ width (px 36)
                        , height (px 36)
                        , fontSize (px 18)
                        ]
                    ]
                ]
            ]
        )
