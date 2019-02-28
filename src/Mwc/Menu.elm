module Mwc.Menu exposing (Model, Msg, disabled, extraAttributes, icon, model, update, view, zIndex)

{-| Material design menu

@docs Model, Msg, disabled, extraAttributes, icon, model, update, view, zIndex

-}

import Css exposing (..)
import Dict exposing (Dict)
import Html.Styled as Html exposing (Attribute, Html, div, node, span)
import Html.Styled.Attributes as Attr
import Html.Styled.Events exposing (onClick)
import Json.Encode as Encode
import Mwc.IconButton as IconButton


type Property msg
    = Disabled Bool
    | ZIndex Int
    | Icon String
    | OtherAttr (List (Attribute msg))



---- CONFIG ----


type alias Config msg =
    { disabled : Bool
    , icon : String
    , zIndex : Int
    , otherAttr : List (Attribute msg)
    }


defaultConfig : Config msg
defaultConfig =
    { disabled = False
    , icon = ""
    , zIndex = -1
    , otherAttr = []
    }



---- Property Functions ----


{-| icon property of menu
-}
icon : String -> Property msg
icon val =
    Icon val


{-| disabled property of menu
-}
disabled : Bool -> Property msg
disabled val =
    Disabled val


{-| zIndex property of menu
-}
zIndex : Int -> Property msg
zIndex val =
    ZIndex val


{-| extraAttributes property of menu
-}
extraAttributes : List (Attribute msg) -> Property msg
extraAttributes otherAttr =
    OtherAttr otherAttr



---- MODEL ----


{-| Menu Model
-}
type alias Model =
    { menuOpen : Dict String Bool
    }



-- default model


{-| Initial model of menu
-}
model : Model
model =
    { menuOpen = Dict.empty
    }



---- UPDATE ----


{-| Menu Msg
-}
type Msg
    = ToggleMenu String
    | NoOp


{-| update function of menu
-}
update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ToggleMenu id ->
            ( { model
                | menuOpen = Dict.insert id (not (checkMenuOpen id model)) model.menuOpen
              }
            , Cmd.none
            )


{-| view function of menu
-}
view : List (Property msg) -> List (Html msg) -> String -> Model -> (Msg -> msg) -> Html msg
view properties html id model toMsg =
    let
        config =
            fetchConfig properties
    in
    span
        config.otherAttr
        [ div
            [ Attr.css
                (if config.zIndex == -1 then
                    [ display inlineBlock
                    , position relative
                    , overflow visible
                    ]

                 else
                    [ display inlineBlock
                    , position relative
                    , overflow visible
                    , Css.zIndex (int (config.zIndex + 1))
                    ]
                )
            ]
            [ IconButton.view
                [ IconButton.icon config.icon
                , IconButton.onClick (toMsg (ToggleMenu id))
                , IconButton.disable config.disabled
                ]
            , node "mwc-menu"
                [ Attr.property "noWrapFocus" (Encode.bool True)
                , Attr.property "open" (Encode.bool (checkMenuOpen id model))
                , Attr.property "autofocus" (Encode.bool True)
                ]
                (List.map (fetchMenuItem toMsg id) html)
            ]
        , if checkMenuOpen id model then
            div
                [ Attr.css
                    (if config.zIndex == -1 then
                        [ position fixed
                        , width (pct 100)
                        , height (pct 100)
                        , backgroundColor transparent
                        , top (px 0)
                        , left (px 0)
                        ]

                     else
                        [ position fixed
                        , width (pct 100)
                        , height (pct 100)
                        , backgroundColor transparent
                        , top (px 0)
                        , left (px 0)
                        , Css.zIndex (int config.zIndex)
                        ]
                    )
                , onClick (toMsg (ToggleMenu id))
                ]
                []

          else
            Html.text ""
        ]


fetchMenuItem : (Msg -> msg) -> String -> Html msg -> Html msg
fetchMenuItem toMsg id html =
    node "mwc-list-item"
        [ onClick (toMsg (ToggleMenu id)) ]
        [ html ]


fetchConfig : List (Property msg) -> Config msg
fetchConfig properties =
    List.foldl propToConfig defaultConfig properties


propToConfig : Property msg -> Config msg -> Config msg
propToConfig prop config =
    case prop of
        Disabled val ->
            { config | disabled = val }

        ZIndex val ->
            { config | zIndex = val }

        Icon val ->
            { config | icon = val }

        OtherAttr val ->
            { config | otherAttr = val }


checkMenuOpen : String -> Model -> Bool
checkMenuOpen id model =
    case Dict.get id model.menuOpen of
        Just val ->
            val

        Nothing ->
            False
