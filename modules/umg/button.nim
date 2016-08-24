# Copyright 2016 Xored Software, Inc.

declareBuiltinDelegate(FOnButtonClickedEvent, dkDynamicMulticast, "UMG.h")
declareBuiltinDelegate(FOnButtonPressedEvent, dkDynamicMulticast, "UMG.h")
declareBuiltinDelegate(FOnButtonReleasedEvent, dkDynamicMulticast, "UMG.h")
declareBuiltinDelegate(FOnButtonHoverEvent, dkDynamicMulticast, "UMG.h")

wclass(UButton of UContentWidget, header: "UMG.h"):
  ## The button is a click-able primitive widget to enable basic interaction, you
  ## can place any other widget inside a button to make a more complex and
  ## interesting click-able element in your UI.
  ##
  ## * Single Child
  ## * Clickable

  var widgetStyle: FButtonStyle
    ## The button style used at runtime
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category="Appearance", meta=( DisplayName="Style" ))

  var colorAndOpacity: FLinearColor
    ## The color multiplier for the button content
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="Appearance", meta=( sRGB="true" ))

  var backgroundColor: FLinearColor
    ## The color multiplier for the button background
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="Appearance", meta=( sRGB="true" ))

  var clickMethod: TEnumAsByte[EButtonClickMethod]
    ## The type of mouse action required by the user to trigger the buttons 'Click'
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="Interaction", AdvancedDisplay)

  var touchMethod: TEnumAsByte[EButtonTouchMethod]
    ## The type of touch action required by the user to trigger the buttons 'Click'
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="Interaction", AdvancedDisplay)

  var isFocusable: bool
    ## Sometimes a button should only be mouse-clickable and never keyboard focusable.
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="Interaction")

  var onClicked: FOnButtonClickedEvent
    ## Called when the button is clicked
    ## UPROPERTY(BlueprintAssignable, Category="Button|Event")

  var onPressed: FOnButtonPressedEvent
    ## Called when the button is pressed
    ## UPROPERTY(BlueprintAssignable, Category="Button|Event")

  var onReleased: FOnButtonReleasedEvent
    ## Called when the button is released
    ## UPROPERTY(BlueprintAssignable, Category="Button|Event")

  var onHovered: FOnButtonHoverEvent
    ## UPROPERTY( BlueprintAssignable, Category = "Button|Event" )

  var onUnhovered: FOnButtonHoverEvent
    ## UPROPERTY( BlueprintAssignable, Category = "Button|Event" )

  proc setStyle(inStyle: FButtonStyle)
    ## Sets the color multiplier for the button background
    ## UFUNCTION(BlueprintCallable, Category="Button|Appearance")

  proc setColorAndOpacity(inColorAndOpacity: FLinearColor)
    ## Sets the color multiplier for the button content
    ## UFUNCTION(BlueprintCallable, Category="Button|Appearance")

  proc setBackgroundColor(inBackgroundColor: FLinearColor)
    ## Sets the color multiplier for the button background
    ## UFUNCTION(BlueprintCallable, Category="Button|Appearance")

  proc isPressed(): bool {.noSideEffect.}
    ## Returns true if the user is actively pressing the button.
    ## Do not use this for detecting 'Clicks', use the OnClicked event instead.
    ##
    ## @return true if the user is actively pressing the button otherwise false.
    ## UFUNCTION(BlueprintCallable, Category="Button")

wclass(UButtonSlot of UPanelSlot, header: "UMG.h"):
  ## The Slot for the UButtonSlot, contains the widget displayed in a button's single slot

  var padding: FMargin
    ## The padding area between the slot and the content it contains.
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="Layout|Button Slot")

  var horizontalAlignment: EHorizontalAlignment
    ## The alignment of the object horizontally.
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="Layout|Button Slot")

  var verticalAlignment: EVerticalAlignment
    ## The alignment of the object vertically.
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="Layout|Button Slot")

  proc setPadding(inPadding: FMargin)
    ## UFUNCTION(BlueprintCallable, Category="Layout|Button Slot")

  proc setHorizontalAlignment(inHorizontalAlignment: EHorizontalAlignment)
    ## UFUNCTION(BlueprintCallable, Category="Layout|Button Slot")

  proc setVerticalAlignment(inVerticalAlignment: EVerticalAlignment)
    ## UFUNCTION(BlueprintCallable, Category="Layout|Button Slot")
