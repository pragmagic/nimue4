# Copyright 2016 Xored Software, Inc.

type
  EButtonClickMethod* {.importcpp: "EButtonClickMethod::Type", header: "SlateCore.h", pure.} = enum
    ## Enumerates different methods that a button click can be triggered. Normally, DownAndUp is appropriate.
    DownAndUp,
      ## User must press the button, then release while over the button to trigger the click.
      ## This is the most common type of button.

    MouseDown,
      ## Click will be triggered immediately on mouse down, and mouse will not be captured.

    MouseUp,
      ## Click will always be triggered when mouse button is released over the button,
      ## even if the button wasn't pressed down over it.

    PreciseClick
      ## Inside a list, buttons can only be clicked with precise tap.
      ## Moving the pointer will scroll the list, also allows drag-droppable buttons.

  EButtonTouchMethod* {.importcpp: "EButtonTouchMethod::Type", header: "SlateCore.h", pure.} = enum
    ## Ways in which touch interactions trigger a "Clicked" event.
    DownAndUp,
      ## Most buttons behave this way.
    PreciseTap
      ## Inside a list, buttons can only be clicked with precise tap.
      ## Moving the pointer will scroll the list.

  EButtonPressMethod* {.importcpp: "EButtonPressMethod::Type", header: "SlateCore.h", pure.} = enum
    ## Enumerates different methods that a button can be triggered with keyboard/controller. Normally, DownAndUp is appropriate.
    DownAndUp,
      ## User must press the button, then release while the button has focus to trigger the click.
      ## This is the most common type of button.
    ButtonPress,
      ## Click will be triggered immediately on button press.
    ButtonRelease,
      ## Click will always be triggered when a button release occurs on the focused button,
      ## even if the button wasn't pressed while focused.

  EUINavigation* {.importcpp: "EUINavigation", header: "SlateCore.h", pure, size: sizeof(uint8).} = enum
    ## Navigation context for event
    # Four cardinal directions
    Left,
    Right,
    Up,
    Down,
    # Conceptual next and previous
    Next,
    Previous,
    Num, ## Number of navigation types
    Invalid
      ## Denotes an invalid navigation, more important used to denote no specified navigation

  EHorizontalAlignment* {.importcpp: "EHorizontalAlignment", header: "SlateCore.h".} = enum
    ## Enumerates horizontal alignment options, i.e. for widget slots.
    HAlign_Fill,
      ## Fill the entire width.
    HAlign_Left,
      ## Left-align.
    HAlign_Center,
      ## Center-align.
    HAlign_Right,
      ## Right-align.

  EVerticalAlignment* {.importcpp: "EVerticalAlignment", header: "SlateCore.h".} = enum
    ## Enumerates vertical alignment options, i.e. for widget slots.
    VAlign_Fill,
      ## Fill the entire height.
    VAlign_Top,
      ## Top-align.
    VAlign_Center,
      ## Center-align.
    VAlign_Bottom,
      ## Bottom-align.

  EMenuPlacement* {.importcpp: "EMenuPlacement", header: "SlateCore.h".} = enum
    ## Enumerates possible placements for pop-up menus.
    MenuPlacement_BelowAnchor,
      ## Place the menu immediately below the anchor
    MenuPlacement_CenteredBelowAnchor,
      ## Place the menu immediately centered below the anchor
    MenuPlacement_BelowRightAnchor,
      ## Place the menu immediately below the anchor aligned to the right of the content
    MenuPlacement_ComboBox,
      ## Place the menu immediately below the anchor and match is width to the anchor's content
    MenuPlacement_ComboBoxRight,
      ## Place the menu immediately below the anchor and match is width to the anchor's content. If the width overflows, align with the right edge of the anchor.
    MenuPlacement_MenuRight,
      ## Place the menu to the right of the anchor
    MenuPlacement_AboveAnchor,
      ## Place the menu immediately above the anchor, no transition effect
    MenuPlacement_CenteredAboveAnchor,
      ## Place the menu immediately centered above the anchor, no transition effect
    MenuPlacement_AboveRightAnchor,
      ## Place the menu immediately above the anchor aligned to the right of the content
    MenuPlacement_MenuLeft,
      ## Place the menu to the left of the anchor
    MenuPlacement_Center,
      ## Place the menu's center on top of the menu anchor's center point

  EOrientation* {.importcpp: "EOrientation", header: "SlateCore.h".} = enum
    ## Enumerates widget orientations.
    Orient_Horizontal,
      ## Orient horizontally, i.e. left to right.
    Orient_Vertical,
      ## Orient vertically, i.e. top to bottom.

  EScrollDirection*  {.importcpp: "EScrollDirection", header: "SlateCore.h".} = enum
    ## Enumerates scroll directions.
    Scroll_Down,
      ## Scroll down.
    Scroll_Up,
      ## Scroll up.

  ETextCommitType* {.importcpp: "ETextCommit::Type", header: "SlateCore.h", pure.} = enum
    ## Additional information about a text committal
    Default,
      ## Losing focus or similar event caused implicit commit
    OnEnter,
      ## User committed via the enter key
    OnUserMovedFocus,
      ## User committed via tabbing away or moving focus explicitly away
    OnCleared
      ## Keyboard focus was explicitly cleared via the escape key or other similar action

  ESelectInfo* {.importcpp: "ESelectInfo::Type", header: "SlateCore.h", pure.} = enum
    ## Additional information about a selection event
    OnKeyPress, ## User selected via a key press
    OnNavigation, ## User selected by navigating to the item
    OnMouseClick, ## User selected by clicking on the item
    Direct ## Selection was directly set in code

  EActiveTimerReturnType* {.importcpp: "EActiveTimerReturnType", header: "SlateCore.h", pure, size: sizeof(uint8).} = enum
    ## Return type for FWidgetActiveTimerDelegate.
    ## Don't expose to blueprints.
    Stop,
      ## If this value is returned, the widget's active timer will be unregistered automatically.
      ## No need to call UnRegisterActiveTimer.
    Continue,
      ## If this value is returned, the widget will continue to have its timer delegate called on it.
