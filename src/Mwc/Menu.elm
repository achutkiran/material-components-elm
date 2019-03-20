module Mwc.Menu exposing (Model, Msg, disabled, extraAttributes, icon, model, update, view, zIndex, item, onSelect, divider, menuStyle)

{-| Material design menu

@docs Model, Msg, disabled, extraAttributes, icon, model, update, view, zIndex, item, onSelect, divider, menuStyle

-}

import Css exposing (..)
import Dict exposing (Dict)
import Html.Styled as Html exposing (Attribute, Html, div, node, span)
import Html.Styled.Attributes as Attr
import Html.Styled.Events exposing (onClick)
import Json.Encode as Encode
import Mwc.IconButton as IconButton
import Task


type Property msg
    = Disabled Bool
    | ZIndex Int
    | Icon String
    | Divider
    | MenuStyle Style
    | OnSelect msg
    | OtherAttr (List (Attribute msg))



---- CONFIG ----


type alias Config msg =
    { disabled : Bool
    , icon : String
    , zIndex : Int
    , menuStyle : Style
    , otherAttr : List (Attribute msg)
    }


defaultConfig : Config msg
defaultConfig =
    { disabled = False
    , icon = ""
    , zIndex = -1
    , menuStyle = width (pct 100)
    , otherAttr = []
    }


type alias ItemConfig msg =
    { disabled : Bool
    , onSelect : Maybe msg
    , divider : Bool
    , html : List (Html msg)
    , otherAttr : List (Attribute msg)
    }


defaultItemConfig : List (Html msg) -> ItemConfig msg
defaultItemConfig html =
    { disabled = False
    , onSelect = Nothing
    , divider = False
    , html = html
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


{-| divider for menu item
-}
divider : Property msg
divider =
    Divider


{-| Style for menu items container
-}
menuStyle : Style -> Property msg
menuStyle val =
    MenuStyle val


{-| extraAttributes property of menu
-}
extraAttributes : List (Attribute msg) -> Property msg
extraAttributes otherAttr =
    OtherAttr otherAttr


{-| onSelect property of menuItem
-}
onSelect : msg -> Property msg
onSelect msg =
    OnSelect msg


{-| item in menu
-}
item : List (Property msg) -> List (Html msg) -> ItemConfig msg
item properties html =
    List.foldl propToMenuConfig (defaultItemConfig html) properties


propToMenuConfig : Property msg -> ItemConfig msg -> ItemConfig msg
propToMenuConfig prop itemConfig =
    case prop of
        Disabled val ->
            { itemConfig | disabled = val }

        OnSelect msg ->
            { itemConfig | onSelect = Just msg }

        OtherAttr val ->
            { itemConfig | otherAttr = val }

        Divider ->
            { itemConfig | divider = True }

        _ ->
            itemConfig



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
type Msg msg
    = ToggleMenu String
    | ToMain msg String
    | NoOp


{-| update function of menu
-}
update : Msg msg -> Model -> ( Model, Cmd msg )
update msg menuModel =
    case msg of
        NoOp ->
            ( menuModel, Cmd.none )

        ToMain mainMsg id ->
            ( { menuModel
                | menuOpen = Dict.insert id (not (checkMenuOpen id menuModel)) menuModel.menuOpen
              }
            , msgToCmd mainMsg
            )

        ToggleMenu id ->
            ( { menuModel
                | menuOpen = Dict.insert id (not (checkMenuOpen id menuModel)) menuModel.menuOpen
              }
            , Cmd.none
            )


msgToCmd : msg -> Cmd msg
msgToCmd val =
    Task.succeed val
        |> Task.perform identity


{-| view function of menu
-}
view : List (Property msg) -> List (ItemConfig msg) -> String -> Model -> (Msg msg -> msg) -> Html msg
view properties menuItems id menuModel toMsg =
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
                , Attr.property "open" (Encode.bool (checkMenuOpen id menuModel))
                , Attr.property "autofocus" (Encode.bool True)
                , Attr.css
                    [ position absolute
                    , right (px 0)
                    , config.menuStyle
                    ]
                ]
                (List.map (fetchMenuItem toMsg id) menuItems)
            ]
        , if checkMenuOpen id menuModel then
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


fetchMenuItem : (Msg msg -> msg) -> String -> ItemConfig msg -> Html msg
fetchMenuItem toMsg id menuItem =
    div
        ([ case menuItem.onSelect of
            Just msg ->
                onClick (toMsg (ToMain msg id))

            Nothing ->
                onClick (toMsg (ToggleMenu id))
         , Attr.css
            [ if menuItem.divider then
                borderBottom3 (px 1) solid (rgba 0 0 0 0.12)

              else
                borderBottomStyle none
            , width (pct 100)
            , height (px 48)
            , displayFlex
            , alignItems center
            , justifyContent flexStart
            , padding2 (px 0) (px 16)
            , overflow hidden
            , boxSizing borderBox
            , hover
                [ backgroundColor (rgba 0 0 0 0.08) ]
            , if menuItem.disabled then
                Css.batch
                    [ pointerEvents none
                    , color (rgba 0 0 0 0.38)
                    ]

              else
                pointerEvents auto
            ]
         ]
            ++ menuItem.otherAttr
        )
        (node "mwc-ripple"
            []
            []
            :: menuItem.html
        )


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

        MenuStyle val ->
            { config | menuStyle = val }

        _ ->
            config


checkMenuOpen : String -> Model -> Bool
checkMenuOpen id menuModel =
    case Dict.get id menuModel.menuOpen of
        Just val ->
            val

        Nothing ->
            False
