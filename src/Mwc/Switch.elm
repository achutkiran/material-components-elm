module Mwc.Switch exposing
    ( check
    , disable
    , extraAttributes
    , onClick
    , view
    )

import Html.Styled exposing (Attribute, Html, node)
import Html.Styled.Attributes as Attr
import Html.Styled.Events as HtmlEvents
import Json.Decode as Decode
import Json.Encode as Encode


type Property msg
    = Disabled Bool
    | Checked Bool
    | OnClick (Maybe msg)
    | OtherAttr (List (Attribute msg))



---- CONFIG ----


type alias Config msg =
    { disabled : Bool
    , checked : Bool
    , onClick : Maybe msg
    , otherAttr : List (Attribute msg)
    }


defaultConfig : Config msg
defaultConfig =
    { disabled = False
    , checked = False
    , onClick = Nothing
    , otherAttr = []
    }



---- Property Functions ----


{-| Disables switch
-}
disable : Bool -> Property msg
disable val =
    Disabled val


{-| Sets Swotch to true
-}
check : Bool -> Property msg
check val =
    Checked val


{-| OnClick Event
-}
onClick : msg -> Property msg
onClick val =
    OnClick (Just val)


{-| Additional properties like css
-}
extraAttributes : List (Attribute msg) -> Property msg
extraAttributes otherAttr =
    OtherAttr otherAttr



---- View ----


{-| Renders switch
-}
view : List (Property msg) -> Html msg
view properties =
    let
        config =
            fetchConfig properties
    in
    node "mwc-switch"
        ([ Attr.property "disabled" (Encode.bool config.disabled)
         , Attr.property "checked" (Encode.bool config.checked)
         , case config.onClick of
            Nothing ->
                Attr.class ""

            Just message ->
                if config.disabled then
                    Attr.class ""

                else
                    HtmlEvents.onClick message
         ]
            ++ config.otherAttr
        )
        []


fetchConfig : List (Property msg) -> Config msg
fetchConfig properties =
    List.foldl propToConfig defaultConfig properties


propToConfig : Property msg -> Config msg -> Config msg
propToConfig prop config =
    case prop of
        Disabled val ->
            { config | disabled = val }

        Checked val ->
            { config | checked = val }

        OnClick val ->
            { config | onClick = val }

        OtherAttr val ->
            { config | otherAttr = val }
