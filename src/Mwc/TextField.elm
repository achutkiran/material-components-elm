module Mwc.TextField exposing
    ( autoValidate, disabled, errorText, extraAttributes, icon, iconButton, iconClick, textArea
    , iconTrailing, inputType, invalid, label, onInput, pattern, placeHolder, readonly, required, value, view, noOp, Property
    )

{-| Material TextField. It is elm wrapper for polymer Web components paper text field
Used Elm-css for Styling

@docs autoValidate, disabled, errorText, extraAttributes, icon, iconButton, iconClick, textArea
@docs iconTrailing, inputType, invalid, label, onInput, pattern, placeHolder, readonly, required, value, view, noOp, Property

-}

import Html.Styled exposing (Attribute, Html, node, text)
import Html.Styled.Attributes as Attr
import Html.Styled.Events as HtmlEvents
import Json.Encode as Encode


{-| TextField Properties
-}
type Property msg
    = Value String
    | Label String
    | Icon String
    | IconButton String
    | IconSlot String
    | Invalid Bool
    | Disabled Bool
    | Required Bool
    | ReadOnly Bool
    | Pattern String
    | ErrorText String
    | PlaceHolder String
    | TextArea Bool
    | InputType String
    | OtherAttr (List (Attribute msg))
    | OnInput (Maybe (String -> msg))
    | IconClick (Maybe msg)
    | AutoValidate Bool
    | None



---- CONFIG ----


type alias Config msg =
    { value : String
    , label : String
    , invalid : Bool
    , icon : String
    , iconButton : String
    , iconSlot : String
    , textArea : Bool
    , disabled : Bool
    , readonly : Bool
    , required : Bool
    , pattern : String
    , errorText : String
    , placeHolder : String
    , inputType : String
    , onInput : Maybe (String -> msg)
    , iconClick : Maybe msg
    , autoValidate : Bool
    , otherAttr : List (Attribute msg)
    }


defaultConfig : Config msg
defaultConfig =
    { value = ""
    , label = ""
    , icon = ""
    , invalid = False
    , iconButton = ""
    , iconSlot = "prefix"
    , textArea = False
    , disabled = False
    , readonly = False
    , required = False
    , pattern = ".*"
    , errorText = ""
    , placeHolder = ""
    , inputType = "text"
    , otherAttr = []
    , onInput = Nothing
    , autoValidate = False
    , iconClick = Nothing
    }



---- Property Functions ----


{-| Initial value
-}
value : String -> Property msg
value val =
    Value val


{-| Label
-}
label : String -> Property msg
label val =
    Label val


{-| Textfield icon name
-}
icon : String -> Property msg
icon name =
    Icon name


{-| Textfield IconButton
-}
iconButton : String -> Property msg
iconButton name =
    IconButton name


{-| TextField IconButton click event
-}
iconClick : msg -> Property msg
iconClick val =
    IconClick (Just val)


{-| Makes icon as trailing icon
-}
iconTrailing : Property msg
iconTrailing =
    IconSlot "suffix"


{-| Disables text field
-}
disabled : Bool -> Property msg
disabled val =
    Disabled val


{-| Sets textfield as required
-}
required : Property msg
required =
    Required True


{-| Makes textfield as readonly
-}
readonly : Bool -> Property msg
readonly val =
    ReadOnly val


{-| Input pattern
-}
pattern : String -> Property msg
pattern val =
    Pattern val


{-| Error Text
-}
errorText : String -> Property msg
errorText val =
    ErrorText val


{-| Placeholder
-}
placeHolder : String -> Property msg
placeHolder val =
    PlaceHolder val


{-| Input Type
-}
inputType : String -> Property msg
inputType val =
    InputType val


{-| OnInput Event
-}
onInput : (String -> msg) -> Property msg
onInput val =
    OnInput (Just val)


{-| Set text field to auto validate
-}
autoValidate : Property msg
autoValidate =
    AutoValidate True


{-| TextArea
-}
textArea : Property msg
textArea =
    TextArea True


{-| Displays error message
-}
invalid : Property msg
invalid =
    Invalid True


{-| Additional properties like css
-}
extraAttributes : List (Attribute msg) -> Property msg
extraAttributes otherAttr =
    OtherAttr otherAttr


{-| No operation for TextField
-}
noOp : Property msg
noOp =
    None



---- View ----


{-| renders TextField
-}
view : List (Property msg) -> Html msg
view properties =
    let
        config =
            fetchConfig properties
    in
    if config.textArea then
        node "paper-textarea"
            (fetchProperties config)
            [ checkIcon config ]

    else
        node "paper-input"
            (fetchProperties config)
            [ checkIcon config ]


fetchConfig : List (Property msg) -> Config msg
fetchConfig properties =
    List.foldl propToConfig defaultConfig properties


propToConfig : Property msg -> Config msg -> Config msg
propToConfig prop config =
    case prop of
        Value val ->
            { config | value = val }

        Label val ->
            { config | label = val }

        Icon name ->
            { config | icon = name }

        IconButton name ->
            { config | iconButton = name }

        IconClick click ->
            { config | iconClick = click }

        Invalid val ->
            { config | invalid = True }

        IconSlot val ->
            { config | iconSlot = val }

        Disabled val ->
            { config | disabled = val }

        Required val ->
            { config | required = val }

        ReadOnly val ->
            { config | readonly = val }

        Pattern val ->
            { config | pattern = val }

        ErrorText val ->
            { config | errorText = val }

        PlaceHolder val ->
            { config | placeHolder = val }

        InputType val ->
            { config | inputType = val }

        AutoValidate val ->
            { config | autoValidate = val }

        OtherAttr val ->
            { config | otherAttr = val }

        OnInput input ->
            { config | onInput = input }

        TextArea val ->
            { config | textArea = val }

        None ->
            config


fetchProperties : Config msg -> List (Attribute msg)
fetchProperties config =
    [ Attr.property "value" (Encode.string config.value)
    , Attr.property "label" (Encode.string config.label)
    , Attr.property "disabled" (Encode.bool config.disabled)
    , Attr.property "readonly" (Encode.bool config.readonly)
    , Attr.property "required" (Encode.bool config.required)
    , Attr.property "pattern" (Encode.string config.pattern)
    , Attr.property "errorMessage" (Encode.string config.errorText)
    , Attr.property "placeholder" (Encode.string config.placeHolder)
    , Attr.property "type" (Encode.string config.inputType)
    , Attr.property "autoValidate" (Encode.bool config.autoValidate)
    , Attr.property "invalid" (Encode.bool config.invalid)
    , fetchOnInput config.onInput
    ]
        ++ config.otherAttr


fetchOnInput : Maybe (String -> msg) -> Attribute msg
fetchOnInput input =
    case input of
        Nothing ->
            Attr.class ""

        Just msg ->
            HtmlEvents.onInput msg


checkIcon : Config msg -> Html msg
checkIcon config =
    if config.icon /= "" then
        node "iron-icon"
            [ Attr.property "slot" (Encode.string config.iconSlot)
            , Attr.property "icon" (Encode.string config.icon)
            ]
            []

    else if config.iconButton /= "" then
        node "paper-icon-button"
            [ Attr.property "slot" (Encode.string config.iconSlot)
            , Attr.property "icon" (Encode.string config.iconButton)
            , checkIconClick config.iconClick
            ]
            []

    else
        text ""


checkIconClick : Maybe msg -> Attribute msg
checkIconClick click =
    case click of
        Nothing ->
            Attr.class ""

        Just msg ->
            HtmlEvents.onClick msg
