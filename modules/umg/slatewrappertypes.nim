# Copyright 2016 Xored Software, Inc.

type
  ESlateVisibility* {.importcpp, header: "UMG.h", pure, size: sizeof(uint8).} = enum
    ## Is an entity visible?
    Visible,
      ## Default widget visibility - visible and can interactive with the cursor
    Collapsed,
      ## Not visible and takes up no space in the layout; can never be clicked on because it takes up no space.
    Hidden,
      ## Not visible, but occupies layout space. Not interactive for obvious reasons.
    HitTestInvisible,
      ## Visible to the user, but only as art. The cursors hit tests will never see this widget.
    SelfHitTestInvisible
      ## Same as HitTestInvisible, but doesn't apply to child widgets.

  ESlateSizeRule* {.importcpp: "ESlateSizeRule::Type", header: "UMG.h", pure.} = enum
    ## The sizing options of UWidgets
    Automatic,
      ## Only requests as much room as it needs based on the widgets desired size.
    Fill
      ## Greedily attempts to fill all available room based on the percentage value 0..1

  EVirtualKeyboardType* {.importcpp: "EVirtualKeyboardType::Type", header: "UMG.h", pure.} = enum
    Default,
    Number,
    Web,
    Email,
    Password,
    AlphaNumeric

proc asKeyboardType*(inType: EVirtualKeyboardType): EKeyboardType {.importcpp: "EVirtualKeyboardType::AsKeyboardType(@)", header: "UMG.h".}

wclass(FEventReply, header: "UMG.h", bycopy):
  ## Allows users to handle events and return information to the underlying UI layer.

  proc initFEventReply(isHandled: bool = false): FEventReply {.constructor.}
  var nativeReply: FReply

wclass(FSlateChildSize, header: "UMG.h"):
  ## A struct exposing size param related properties to UMG.

  var value: float32
    ## The parameter of the size rule.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Appearance, meta=( UIMin="0", UIMax="1" ))

  var sizeRule: TEnumAsByte[ESlateSizeRule]
    ## The sizing rule of the content.
    ## UPROPERTY(EditAnywhere, BlueprintReadWrite, Category=Appearance)

  proc initFSlateChildSize(): FSlateChildSize {.constructor.}
  proc initFSlateChildSize(InSizeRule: ESlateSizeRule): FSlateChildSize {.constructor.}
