# Copyright 2016 Xored Software, Inc.

type
  EConsumeMouseWheel* {.importcpp, header: "SlateCore.h", pure.} = enum
    ## Used to determine how we should handle mouse wheel input events when someone scrolls.
    WhenScrollingPossible,
      ## Only consume the mouse wheel event when we actually scroll some amount.
    Always,
      ## Always consume mouse wheel event even if we don't scroll at all.
    Never,
      ## Never consume the mouse wheel

  ESlateCheckBoxType* {.importcpp: "ESlateCheckBoxType::Type", header: "SlateCore.h", pure.} = enum
    ## Type of check box
    CheckBox,
      ## Traditional check box with check button and label (or other content)
    ToggleButton,
      ## Toggle button.  You provide button content (such as an image), and the user can press to toggle it.

  ECheckBoxState* {.importcpp, header: "SlateCore.h", pure, size: sizeof(uint8).} = enum
    ## Current state of the check box
    Unchecked,
      ## Unchecked
    Checked,
      ## Checked
    Undetermined
      ## Neither checked nor unchecked

wclass(FButtonStyle of FSlateWidgetStyle, header: "SlateCore.h", bycopy):
  var normal: FSlateBrush
    ## Button appearance when the button is not hovered or pressed

  var hovered: FSlateBrush
    ## Button appearance when hovered

  var pressed: FSlateBrush
    ## Button appearance when pressed

  var disabled: FSlateBrush
    ## Button appearance when disabled, by default this is set to an invalid resource when that is the case default disabled drawing is used.

  var normalPadding: FMargin
    ## Padding that accounts for the border in the button's background image.
    ## When this is applied, the content of the button should appear flush
    ## with the button's border. Use this padding when the button is not pressed.

  var pressedPadding: FMargin
    ## Same as NormalPadding but used when the button is pressed. Allows for moving the content to match
    ## any "movement" in the button's border image.

  var pressedSlateSound: FSlateSound
    ## The sound the button should play when pressed

  var hoveredSlateSound: FSlateSound
    ## The sound the button should play when initially hovered over

# TODO: most not wrapped
