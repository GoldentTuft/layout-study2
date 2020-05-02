module Main exposing (main)

import Browser
import Browser.Dom
import Html exposing (Html)
import Html.Attributes
import Html.Attributes.Classname exposing (classMixinWith)
import Html.Events
import Mixin exposing (Mixin)
import Mixin.Html as Mixin
import Neat exposing (NoGap, Protected, Renderer, View, defaultRenderer, fromNoGap, setAttribute, setBoundary, setLayout, setMixin, setMixins)
import Neat.Layout as Layout
import Neat.Layout.Column as Column exposing (Column, defaultColumn)
import Neat.Layout.Row as Row exposing (defaultRow)
import Task



-- App


main : Program () Model Msg
main =
    Neat.element
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , renderer = \_ -> defaultRenderer
        }


type alias Model =
    { dropDown1Open : Bool
    , modalOpen : Bool
    , hoverOpen : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( { dropDown1Open = False
      , modalOpen = False
      , hoverOpen = False
      }
    , Cmd.none
    )


type Msg
    = NoOp
    | ToggleDropDown1
    | OpenDropDown1
    | ToggleModal
    | SelectItem String
    | OpenHover
    | CloseHover


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ToggleDropDown1 ->
            ( { model | dropDown1Open = not model.dropDown1Open }, Cmd.none )

        OpenDropDown1 ->
            ( { model | dropDown1Open = True }, Cmd.none )

        ToggleModal ->
            ( { model | modalOpen = not model.modalOpen }, Cmd.none )

        SelectItem str ->
            ( { model | modalOpen = False, hoverOpen = False }, Cmd.none )

        OpenHover ->
            ( { model | hoverOpen = True }, Cmd.none )

        CloseHover ->
            ( { model | hoverOpen = False }, Cmd.none )



--Task.attempt (\_ -> NoOp) (Browser.Dom.focus "Brand") )


type MenuGap
    = MenuGap


menuGap : Neat.IsGap MenuGap
menuGap =
    Neat.IsGap
        { width = 0.8
        , height = 0.8
        }


modal : Float -> View NoGap Msg
modal alpha =
    Neat.empty
        |> setStyle "background-color"
            ("rgba(0, 0, 0, "
                ++ String.fromFloat alpha
                ++ ")"
            )
        |> setStyle "position" "fixed"
        |> setStyle "z-index" "1000"
        |> setStyle "top" "0"
        |> setStyle "left" "0"
        |> setStyle "width" "100vw"
        |> setStyle "height" "100vh"
        |> setStyle "cursor" "default"
        |> setAttribute (Html.Events.onClick ToggleModal)


hoverMenuItem : String -> View NoGap Msg
hoverMenuItem label =
    Neat.textBlock label
        |> setAttribute (Html.Events.onMouseDown (SelectItem label))
        |> setAttribute (Html.Attributes.tabindex -1)
        |> setClass "dropDown_item"


hoverMenu1 : Column.Horizontal -> String -> Bool -> View NoGap Msg
hoverMenu1 dir1 dir2 open =
    Layout.column
        [ Neat.textBlock "hoverMenu1"
        , Layout.columnWith { defaultColumn | horizontal = dir1 }
            [ Layout.column
                [ hoverMenuItem "hoverItem1"
                , hoverMenuItem "hoverItem2aaaaaaaaaaaaaaa"
                ]
            ]
            |> setClass "dropDown_items"
            |> setClass dir2
            |> Neat.when open
        ]
        |> setClass "dropDown"
        |> setAttribute (Html.Events.onMouseEnter OpenHover)
        |> setAttribute (Html.Events.onMouseLeave CloseHover)


hoverMenu2 : Column.Horizontal -> String -> Bool -> View NoGap Msg
hoverMenu2 dir1 dir2 open =
    Layout.column
        [ Neat.textBlock "hoverMenu2"
        , Layout.columnWith { defaultColumn | horizontal = dir1 }
            [ Layout.column
                [ hoverMenuItem "hoverItem1"
                , hoverMenuItem "hoverItem2aaaaaaaaaaaaaaa"
                ]
            ]
            |> setClass "dropDown_items"
            |> setClass dir2
            |> Neat.when open
        ]
        |> setClass "dropDown"
        |> setAttribute (Html.Events.onMouseEnter OpenHover)
        |> setAttribute (Html.Events.onMouseLeave CloseHover)


pon : Bool -> (View NoGap Msg -> View NoGap Msg) -> (View NoGap Msg -> View NoGap Msg)
pon flag v =
    \a ->
        if flag then
            a |> v

        else
            a


dropDownItem : String -> View NoGap Msg
dropDownItem label =
    Neat.textBlock label
        |> setAttribute (Html.Events.onMouseDown (SelectItem label))
        |> setAttribute (Html.Attributes.tabindex -1)
        |> setClass "dropDownToggle_item"


dropDown1 : Model -> View NoGap Msg
dropDown1 model =
    Layout.column
        [ Layout.column
            [ Neat.textBlock "dropDownMenu1"
            , Layout.columnWith
                { defaultColumn | horizontal = Column.Left }
                [ Layout.column
                    [ dropDownItem "menu5"
                    , dropDownItem "menu22222222222222222"
                    , hoverMenu1 Column.Left "childRight" model.hoverOpen
                    ]
                    |> setClass "dropDownToggle_items"
                ]
            ]
            |> pon (not model.modalOpen) (setAttribute (Html.Events.onMouseDown ToggleModal))
            |> setAttribute (Html.Attributes.tabindex -1)
            |> setClass "dropDownToggle"
        , modal 0.5
            |> Neat.when model.modalOpen
        ]


dropDown2 : Model -> View NoGap Msg
dropDown2 model =
    Layout.column
        [ Layout.column
            [ Neat.textBlock "dropDownMenu2"
            , Layout.columnWith
                { defaultColumn | horizontal = Column.Right }
                [ Layout.column
                    [ dropDownItem "menu5"
                    , dropDownItem "menu22222222222222222"
                    , hoverMenu1 Column.Right "childLeft" model.hoverOpen
                    ]
                    |> setClass "dropDownToggle_items"
                ]
            ]
            |> pon (not model.modalOpen) (setAttribute (Html.Events.onMouseDown ToggleModal))
            |> setAttribute (Html.Attributes.tabindex -1)
            |> setClass "dropDownToggle"
        , modal 0.5
            |> Neat.when model.modalOpen
        ]


menu : Model -> View NoGap Msg
menu model =
    Layout.rowWith { defaultRow | vertical = Row.VCenter }
        [ Neat.textBlock "Brand"
            |> setClass "menu_brand"
            |> fromNoGap menuGap
        , Layout.rowWith { defaultRow | horizontal = Row.Right, vertical = Row.VCenter, wrap = Row.Wrap }
            [ dropDown1 model
                |> fromNoGap menuGap
            , hoverMenu1 Column.Left "childBottom" model.hoverOpen
                |> fromNoGap menuGap
            , menuItem "Item2"
            , menuItem "Item3"
            , dropDown2 model
                |> fromNoGap menuGap
            , hoverMenu2 Column.Right "childBottom" model.hoverOpen
                |> fromNoGap menuGap
            ]
            |> setLayout Layout.fill
        ]
        |> setBoundary menuGap
        |> setClass "menu"


menuItem : String -> View MenuGap msg
menuItem m =
    Neat.textBlock
        m
        |> setClass "menu_item"
        |> fromNoGap menuGap


type BodyGap
    = BodyGap


bodyGap : Neat.IsGap BodyGap
bodyGap =
    Neat.IsGap
        { width = 0.8
        , height = 0.8
        }


messageBox1 : View NoGap msg
messageBox1 =
    Neat.textBlock
        """
        012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
    """


messageBox2 : View NoGap msg
messageBox2 =
    Neat.textBlock """
        Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
        """


scrollAreaY : List (View NoGap msg) -> View NoGap msg
scrollAreaY contents =
    Layout.column
        [ Layout.column
            contents
            |> setStyle "position" "absolute"
            |> setStyle "height" "100%"
            -- |> setStyle "height" "500px"
            |> setStyle "overflow-y" "auto"
        ]
        |> setStyle "position" "relative"


body : View NoGap msg
body =
    Layout.rowWith { defaultRow | wrap = Row.Wrap, vertical = Row.Stretch }
        [ Layout.column [ Neat.textBlock "leftSide" ]
            |> fromNoGap bodyGap
            |> setBoundary bodyGap
            |> setLayout (Layout.fillBy 20)
            |> setClass "sidebar"
        , Layout.column
            [ Neat.textBlock "content"
            , Neat.textBlock "hoge"
            , Neat.textBlock "piyo"
            , Layout.column (List.repeat 100 messageBox1 ++ [ messageBox2 ])
            ]
            |> fromNoGap bodyGap
            |> setBoundary bodyGap
            |> setLayout (Layout.fillBy 80)
            |> setClass "content"
            |> setClass "scrollAreaY"
        ]
        |> setLayout (Layout.fillBy 80)
        |> setClass "body"


type TabGap
    = TabGap


tabGap : Neat.IsGap TabGap
tabGap =
    Neat.IsGap
        { width = 0
        , height = 0.8
        }


tab =
    Layout.column
        [ Neat.empty
            |> fromNoGap tabGap
            |> setBoundary tabGap
        , Layout.rowWith { defaultRow | vertical = Row.Bottom }
            [ tabItem "tab123456789abcdefg" False
            , tabItem "tab2" True
            , tabItem "tab3" False
            , tabItem "tab4abcdefg" False
            , tabItem "tab5abcdefg" False
            ]
            |> setClass "tab"
        ]


tabItem : String -> Bool -> View NoGap msg
tabItem label sel =
    Neat.textBlock label
        |> (if sel then
                setClass "tab_item__sel"

            else
                setClass "tab_item"
           )


view : Model -> View NoGap Msg
view model =
    Layout.column
        [ menu model
        , tab
        , body |> setLayout Layout.fill

        -- , Neat.textBlock "footer"
        --     |> setClass "footer"
        ]
        |> setClass "main"


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- Helper functions


{-| A specialized version of `class` for this module.
It converts given class names into ones generated by CSS modules.
-}
class : String -> Mixin msg
class =
    classMixinWith <| \name -> "app__" ++ name


setClass : String -> View NoGap msg -> View NoGap msg
setClass =
    setMixin << class


setStyle : String -> String -> View NoGap msg -> View NoGap msg
setStyle key value =
    setAttribute (Html.Attributes.style key value)


setEvent : Html.Attribute msg -> View NoGap msg -> View NoGap msg
setEvent msg =
    setAttribute msg
