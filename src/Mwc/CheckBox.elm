module Mwc.CheckBox exposing
    ( checked
    , disabled
    , extraAttributes
    , indeterminate
    , onToggle
    , value
    , view
    )

import Html.Styled exposing (Attribute, Html, node, text)
import Html.Styled.Attributes as Attr
import Html.Styled.Events as HtmlEvents
import Json.Encode as Encode


type Property msg
    = Checked Bool
    | Indeterminate Bool
    | Disabled Bool
    | Value String
    | OnToggle msg
    | OtherAttr (List (Attribute msg))



---- CONFIG ----


type alias Config msg =
    { checked : Bool
    , indeterminate : Bool
    , disabled : Bool
    , value : String
    , otherAttr : List (Attribute msg)
    , onToggle : Maybe msg
    }


defaultConfig : Config msg
defaultConfig =
    { checked = False
    , indeterminate = False
    , disabled = False
    , value = ""
    , otherAttr = []
    , onToggle = Nothing
    }



---- Property Functions ----


{-| Checks the checkbox
-}
checked : Bool -> Property msg
checked val =
    Checked val


{-| makes checkbox in indeterminate state
-}
indeterminate : Bool -> Property msg
indeterminate val =
    Indeterminate val


{-| Disables checkbox
-}
disabled : Bool -> Property msg
disabled val =
    Disabled val


{-| sets value to checkbox
-}
value : String -> Property msg
value val =
    Value val


{-| Additional properties like css
-}
extraAttributes : List (Attribute msg) -> Property msg
extraAttributes otherAttr =
    OtherAttr otherAttr


{-| OnToggle event
-}
onToggle : msg -> Property msg
onToggle toggle =
    OnToggle toggle



---- View ---


{-| renders checkbox
-}
view : List (Property msg) -> Html msg
view properties =
    let
        config =
            fetchConfig properties
    in
    node "mwc-checkbox" (fetchProperties config) []


fetchConfig : List (Property msg) -> Config msg
fetchConfig properties =
    List.foldl propToConfig defaultConfig properties


propToConfig : Property msg -> Config msg -> Config msg
propToConfig prop config =
    case prop of
        Checked val ->
            { config | checked = val }

        Indeterminate val ->
            { config | indeterminate = val }

        Disabled val ->
            { config | disabled = val }

        Value val ->
            { config | value = val }

        OtherAttr val ->
            { config | otherAttr = val }

        OnToggle toggle ->
            { config | onToggle = Just toggle }


fetchProperties : Config msg -> List (Attribute msg)
fetchProperties config =
    [ Attr.property "checked" (Encode.bool config.checked)
    , Attr.property "indeterminate" (Encode.bool config.indeterminate)
    , Attr.property "disabled" (Encode.bool config.disabled)
    , Attr.property "value" (Encode.string config.value)
    , fetchOnToggle config
    ]
        ++ config.otherAttr


fetchOnToggle : Config msg -> Attribute msg
fetchOnToggle config =
    case config.onToggle of
        Just msg ->
            if config.disabled then
                Attr.class ""

            else
                HtmlEvents.onClick msg

        Nothing ->
            Attr.class ""
