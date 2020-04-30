module Main exposing (main)

import Browser
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
    { dropDown1Open : Bool }


init : ( Model, Cmd Msg )
init =
    ( { dropDown1Open = False }
    , Cmd.none
    )


type Msg
    = NoOp
    | ToggleDropDown1


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ToggleDropDown1 ->
            ( { model | dropDown1Open = not model.dropDown1Open }, Cmd.none )


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
        |> setStyle "width" "100%"
        |> setStyle "height" "100%"
        |> setStyle "cursor" "default"


menu : Model -> View NoGap Msg
menu model =
    Layout.row
        [ Neat.textBlock "Brand"
            |> setClass "menu_brand"
            |> fromNoGap menuGap
        , Layout.rowWith { defaultRow | horizontal = Row.Right, vertical = Row.VCenter, wrap = Row.Wrap }
            [ menuItem "Item2"
            , Layout.column
                [ Neat.textBlock "Item444444"
                , if model.dropDown1Open then
                    Layout.columnWith { defaultColumn | horizontal = Column.Right }
                        [ Layout.column
                            [ --Neat.empty
                              --|> setClass "modal"
                              Neat.textBlock "menu1"
                                |> setAttribute (Html.Events.onClick NoOp)
                                |> setClass "dropDownToggle_item"
                            , Neat.textBlock "menu22222222222222222"
                                |> setClass "dropDownToggle_item"
                            , Layout.column
                                [ Neat.textBlock "Item444444"
                                , Layout.columnWith { defaultColumn | horizontal = Column.Right }
                                    [ Layout.column
                                        [ --Neat.empty
                                          -- |> setClass "modal"
                                          Neat.textBlock "menu1"
                                            |> setClass "dropDown_item"
                                        , Neat.textBlock "menu22222222222222222"
                                            |> setClass "dropDown_item"
                                        ]
                                    ]
                                    |> setClass "dropDown_items"
                                    |> setClass "childRight"
                                ]
                                |> setClass "dropDown"
                                |> setClass "dropDown_item"
                            , modal 0

                            -- Neat.empty
                            --     |> setClass "modal"
                            ]
                        ]
                        |> setClass "dropDownToggle_items"

                  else
                    Neat.none
                ]
                -- |> setAttribute (Html.Attributes.tabindex 0)
                |> setAttribute (Html.Events.onClick ToggleDropDown1)
                |> setClass "dropDownToggle"
                |> fromNoGap menuGap
            , menuItem "Item3"
            , Layout.column
                [ Neat.textBlock "Item444444"
                , Layout.columnWith { defaultColumn | horizontal = Column.Right }
                    [ Layout.column
                        [ --Neat.empty
                          -- |> setClass "modal"
                          Neat.textBlock "menu1"
                            |> setClass "dropDown_item"
                        , Neat.textBlock "menu22222222222222222"
                            |> setClass "dropDown_item"
                        ]
                    ]
                    |> setClass "dropDown_items"
                ]
                |> setClass "dropDown"
                |> fromNoGap menuGap
            , menuItem "Item5"
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


box : View NoGap msg
box =
    Neat.textBlock """
        Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
        """


scrollAreaY : List (View NoGap msg) -> View NoGap msg
scrollAreaY contents =
    Layout.column
        [ Layout.rowWith { defaultRow | vertical = Row.Stretch }
            [ Layout.column
                contents
                |> setStyle "position" "absolute"
                |> setStyle "background-color" "rgb(0, 100, 100)"
                |> setStyle "height" "100%"
                |> setStyle "overflow-y" "auto"
            ]
            |> setStyle "position" "relative"
        ]


body : View NoGap msg
body =
    Layout.rowWith { defaultRow | wrap = Row.Wrap, vertical = Row.Top }
        [ Neat.textBlock "leftSide"
            |> fromNoGap bodyGap
            |> setBoundary bodyGap
            |> setLayout (Layout.fillBy 15)
            |> setClass "sidebar"
        , scrollAreaY
            [ Neat.textBlock "content"
            , Neat.textBlock "hoge"
            , Neat.textBlock "piyo"
            , Layout.column (List.repeat 100 box)
            ]
            |> setClass "content"
            |> fromNoGap bodyGap
            |> setBoundary bodyGap
            |> setLayout (Layout.fillBy 70)
        , Neat.textBlock "rightSide"
            |> fromNoGap bodyGap
            |> setBoundary bodyGap
            |> setLayout (Layout.fillBy 15)
            |> setClass "sidebar"
        ]
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
        , Neat.textBlock "footer"
            |> setClass "footer"
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
