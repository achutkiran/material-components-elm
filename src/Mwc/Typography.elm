module Mwc.Typography exposing (body1, body2, button, caption, headline1, headline2, headline3, headline4, headline5, headline6, overline, subtitle1, subtitle2)

{-| Material Typography

@docs body1, body2, button, caption, headline1, headline2, headline3, headline4, headline5, headline6, overline, subtitle1, subtitle2

-}

import Css exposing (..)


{-| h1 heading1
-}
headline1 : Style
headline1 =
    Css.batch
        [ fontFamilies [ "Roboto", "sans-serif" ]
        , property "-moz-osx-font-smoothing" "grayscale"
        , property "-webkit-font-smoothing" "antialiased"
        , fontSize (Css.rem 6)
        , lineHeight (Css.rem 6)
        , fontWeight (int 300)
        , letterSpacing (em -0.015625)
        , textDecoration inherit
        , textTransform inherit
        ]


{-| h2 heading2
-}
headline2 : Style
headline2 =
    Css.batch
        [ fontFamilies [ "Roboto", "sans-serif" ]
        , property "-moz-osx-font-smoothing" "grayscale"
        , property "-webkit-font-smoothing" "antialiased"
        , fontSize (Css.rem 3.75)
        , lineHeight (Css.rem 3.75)
        , fontWeight (int 300)
        , letterSpacing (em -0.0083333333)
        , textDecoration inherit
        , textTransform inherit
        ]


{-| h3 heading3
-}
headline3 : Style
headline3 =
    Css.batch
        [ fontFamilies [ "Roboto", "sans-serif" ]
        , property "-moz-osx-font-smoothing" "grayscale"
        , property "-webkit-font-smoothing" "antialiased"
        , fontSize (Css.rem 3)
        , lineHeight (Css.rem 3.125)
        , fontWeight (int 400)
        , textDecoration inherit
        , textTransform inherit
        ]


{-| h4 heading4
-}
headline4 : Style
headline4 =
    Css.batch
        [ fontFamilies [ "Roboto", "sans-serif" ]
        , property "-moz-osx-font-smoothing" "grayscale"
        , property "-webkit-font-smoothing" "antialiased"
        , fontSize (Css.rem 2.125)
        , lineHeight (Css.rem 2.5)
        , fontWeight (int 400)
        , letterSpacing (em 0.0073529412)
        , textDecoration inherit
        , textTransform inherit
        ]


{-| h5 heading5
-}
headline5 : Style
headline5 =
    Css.batch
        [ fontFamilies [ "Roboto", "sans-serif" ]
        , property "-moz-osx-font-smoothing" "grayscale"
        , property "-webkit-font-smoothing" "antialiased"
        , fontSize (Css.rem 1.5)
        , lineHeight (Css.rem 2)
        , fontWeight (int 400)
        , textDecoration inherit
        , textTransform inherit
        ]


{-| h6 heading6
-}
headline6 : Style
headline6 =
    Css.batch
        [ fontFamilies [ "Roboto", "sans-serif" ]
        , property "-moz-osx-font-smoothing" "grayscale"
        , property "-webkit-font-smoothing" "antialiased"
        , fontSize (Css.rem 1.25)
        , lineHeight (Css.rem 2)
        , fontWeight (int 500)
        , letterSpacing (em 0.0125)
        , textDecoration inherit
        , textTransform inherit
        ]


{-| subtitle1
-}
subtitle1 : Style
subtitle1 =
    Css.batch
        [ fontFamilies [ "Roboto", "sans-serif" ]
        , property "-moz-osx-font-smoothing" "grayscale"
        , property "-webkit-font-smoothing" "antialiased"
        , fontSize (Css.rem 1)
        , lineHeight (Css.rem 1.75)
        , fontWeight (int 400)
        , letterSpacing (em 0.009375)
        , textDecoration inherit
        , textTransform inherit
        ]


{-| subtitle2
-}
subtitle2 : Style
subtitle2 =
    Css.batch
        [ fontFamilies [ "Roboto", "sans-serif" ]
        , property "-moz-osx-font-smoothing" "grayscale"
        , property "-webkit-font-smoothing" "antialiased"
        , fontSize (Css.rem 0.875)
        , lineHeight (Css.rem 1.375)
        , fontWeight (int 500)
        , letterSpacing (em 0.0071428571)
        , textDecoration inherit
        , textTransform inherit
        ]


{-| body1
-}
body1 : Style
body1 =
    Css.batch
        [ fontFamilies [ "Roboto", "sans-serif" ]
        , property "-moz-osx-font-smoothing" "grayscale"
        , property "-webkit-font-smoothing" "antialiased"
        , fontSize (Css.rem 1)
        , lineHeight (Css.rem 1.5)
        , fontWeight (int 400)
        , letterSpacing (em 0.03125)
        , textDecoration inherit
        , textTransform inherit
        ]


{-| body2
-}
body2 : Style
body2 =
    Css.batch
        [ fontFamilies [ "Roboto", "sans-serif" ]
        , property "-moz-osx-font-smoothing" "grayscale"
        , property "-webkit-font-smoothing" "antialiased"
        , fontSize (Css.rem 0.875)
        , lineHeight (Css.rem 1.25)
        , fontWeight (int 400)
        , letterSpacing (em 0.0178571429)
        , textDecoration inherit
        , textTransform inherit
        ]


{-| caption
-}
caption : Style
caption =
    Css.batch
        [ fontFamilies [ "Roboto", "sans-serif" ]
        , property "-moz-osx-font-smoothing" "grayscale"
        , property "-webkit-font-smoothing" "antialiased"
        , fontSize (Css.rem 0.75)
        , lineHeight (Css.rem 1.25)
        , fontWeight (int 400)
        , letterSpacing (em 0.0333333333)
        , textDecoration inherit
        , textTransform inherit
        ]


{-| button
-}
button : Style
button =
    Css.batch
        [ fontFamilies [ "Roboto", "sans-serif" ]
        , property "-moz-osx-font-smoothing" "grayscale"
        , property "-webkit-font-smoothing" "antialiased"
        , fontSize (Css.rem 0.875)
        , lineHeight (Css.rem 2.25)
        , fontWeight (int 500)
        , letterSpacing (em 0.0892857143)
        , textDecoration none
        , textTransform uppercase
        ]


{-| overline
-}
overline : Style
overline =
    Css.batch
        [ fontFamilies [ "Roboto", "sans-serif" ]
        , property "-moz-osx-font-smoothing" "grayscale"
        , property "-webkit-font-smoothing" "antialiased"
        , fontSize (Css.rem 0.75)
        , lineHeight (Css.rem 2)
        , fontWeight (int 500)
        , letterSpacing (em 0.1666666667)
        , textDecoration none
        , textTransform uppercase
        ]
