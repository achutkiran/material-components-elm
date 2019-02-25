module Mwc.Button exposing (normal, raised, unelevated, outlined, dense, disabled, extraAttributes, icon, label, onClick, view)

{-| Material Button. It is elm wrapper for Material Web components button
Used Elm-css for Styling

@docs normal, raised, unelevated, outlined, dense, disabled, extraAttributes, icon, label, onClick, view

-}

import Html.Styled exposing (Attribute, Html, node, text)
import Html.Styled.Attributes as Attr
import Html.Styled.Events as HtmlEvents
import Json.Encode as Encode


{-| Button Type
-}
type ButtonType
    = Normal
    | Raised
    | Unelevated
    | Outlined


type Property msg
    = Type ButtonType
    | Dense Bool
    | Disabled Bool
    | Icon String
    | Label String
    | OtherAttr (List (Attribute msg))
    | OnCLick msg



---- CONFIG ----


type alias Config msg =
    { type_ : ButtonType
    , dense : Bool
    , disabled : Bool
    , icon : String
    , label : String
    , otherAttr : List (Attribute msg)
    , onClick : Maybe msg
    }


defaultConfig : Config msg
defaultConfig =
    { type_ = Normal
    , dense = False
    , disabled = False
    , icon = ""
    , label = ""
    , otherAttr = []
    , onClick = Nothing
    }



---- Property functions ----


{-| Normal Button Type
-}
normal : Property msg
normal =
    Type Normal


{-| Raised Button Type
-}
raised : Property msg
raised =
    Type Raised


{-| unelevated Button Type
-}
unelevated : Property msg
unelevated =
    Type Unelevated


{-| outlined Button Type
-}
outlined : Property msg
outlined =
    Type Outlined


{-| Makes button dense
-}
dense : Property msg
dense =
    Dense True


{-| Set icon to Button
-}
icon : String -> Property msg
icon name =
    Icon name


{-| Sets Label to button
-}
label : String -> Property msg
label name =
    Label name


{-| Makes Button disabled
-}
disabled : Bool -> Property msg
disabled val =
    Disabled val


{-| Additional properties like css
-}
extraAttributes : List (Attribute msg) -> Property msg
extraAttributes otherAttr =
    OtherAttr otherAttr


{-| Onclick Handler
-}
onClick : msg -> Property msg
onClick click =
    OnCLick click



---- View ----


{-| Renders a button
-}
view : List (Property msg) -> Html msg
view properties =
    let
        config =
            fetchConfig properties
    in
    node "mwc-button" (fetchProperties config) []


fetchConfig : List (Property msg) -> Config msg
fetchConfig properties =
    List.foldl propToConfig defaultConfig properties


propToConfig : Property msg -> Config msg -> Config msg
propToConfig prop config =
    case prop of
        Type bType ->
            { config | type_ = bType }

        Dense val ->
            { config | dense = val }

        Disabled val ->
            { config | disabled = val }

        Icon name ->
            { config | icon = name }

        Label name ->
            { config | label = name }

        OtherAttr attr ->
            { config | otherAttr = attr }

        OnCLick click ->
            { config | onClick = Just click }


fetchProperties : Config msg -> List (Attribute msg)
fetchProperties config =
    [ fetchBType config
    , Attr.property "dense" (Encode.bool config.dense)
    , Attr.property "disabled" (Encode.bool config.disabled)
    , Attr.property "icon" (Encode.string config.icon)
    , Attr.property "label" (Encode.string config.label)
    , fetchOnClick config
    ]
        ++ config.otherAttr


fetchBType : Config msg -> Attribute msg
fetchBType config =
    case config.type_ of
        Normal ->
            Attr.class ""

        Raised ->
            Attr.property "raised" (Encode.bool True)

        Unelevated ->
            Attr.property "unelevated" (Encode.bool True)

        Outlined ->
            Attr.property "outlined" (Encode.bool True)


fetchOnClick : Config msg -> Attribute msg
fetchOnClick config =
    case config.onClick of
        Just msg ->
            if config.disabled then
                Attr.class ""

            else
                HtmlEvents.onClick msg

        Nothing ->
            Attr.class ""
