# Copyright 2016 Xored Software, Inc.

type
  UVisual* {.header: "Components/Visual.h", importcpp.} = object of UObject
  UWidget* {.header: "Components/Widget.h", importcpp.} = object of UVisual

wclass(FAnchors, header: "Widgets/Layout/Anchors.h", bycopy):
  ## Describes how a widget is anchored.

  var minimum: FVector2D
    ##Holds the minimum anchors, left + top.

  var maximum: FVector2D
    ## Holds the maximum anchors, right + bottom.

  proc initFAnchors(): FAnchors {.constructor.}
    ## Default constructor.
    ##
    ## The default margin size is zero on all four sides..

  proc initFAnchors(unifromAnchors: float32): FAnchors {.constructor.}
    ## Construct a Anchors with uniform space on all sides

  proc initFAnchors(horizontal, vertical: float32): FAnchors {.constructor.}
    ## Construct a Anchors where Horizontal describes Left and Right spacing while Vertical describes Top and Bottom spacing

  proc initFAnchors(minX, minY, maxX, maxY: float32): FAnchors {.constructor.}
    ## Construct Anchors where the spacing on each side is individually specified.

  proc isStretchedVertical(): bool {.noSideEffect.}
    ## Returns true if the anchors represent a stretch along the vertical axis

  proc isStretchedHorizontal(): bool {.noSideEffect.}
    ## Returns true if the anchors represent a stretch along the horizontal axis

wclass(UUserWidget of UWidget, header: "Blueprint/UserWidget.h"):
  proc addToViewport(zOrder: int32 = 0)
    ## Adds it to the game's viewport and fills the entire screen, unless SetDesiredSizeInViewport is called
    ## to explicitly set the size.
    ##
    ## @param ZOrder The higher the number, the more on top this widget will be.

  proc addToPlayerScreen(zOrder: int32 = 0): bool {.discardable.}
    ## Adds the widget to the game's viewport in a section dedicated to the player.  This is valuable in a split screen
    ## game where you need to only show a widget over a player's portion of the viewport.
    ##
    ## @param ZOrder The higher the number, the more on top this widget will be.

  proc removeFromViewport()
    ## Removes the widget from the viewport.

  method removeFromParent()
    ## Removes the widget from its parent widget.  If this widget was added to the player's screen or the viewport
    ## it will also be removed from those containers.

  proc setPositionInViewport(position: FVector2D, bRemoveDPIScale: bool = true)
    ## Sets the widgets position in the viewport.
    ## @param Position The 2D position to set the widget to in the viewport.
    ## @param bRemoveDPIScale If you've already calculated inverse DPI, set this to false.
    ## Otherwise inverse DPI is applied to the position so that when the location is scaled
    ## by DPI, it ends up in the expected position.

  proc setDesiredSizeInViewport(size: FVector2D)

  proc setAnchorsInViewport(anchors: FAnchors)

  proc setAlignmentInViewport(alignment: FVector2D)

  proc getIsVisible(): bool {.noSideEffect.}

  proc isInViewport(): bool {.noSideEffect.}
    ## @return true if the widget was added to the viewport using AddToViewport.

proc createWidget*[T: UUserWidget](world: ptr UWorld): ptr T {.importcpp: "CreateWidget<'*0>(@)", header: "Blueprint/UserWidget.h".}
proc createWidget*[T: UUserWidget](world: ptr UWorld, class: ptr UClass): ptr T {.importcpp: "CreateWidget<'*0>(@)", header: "Blueprint/UserWidget.h".}
proc createWidget*[T: UUserWidget](owningPlayer: ptr APlayerController): ptr T {.importcpp: "CreateWidget<'*0>(@)", header: "Blueprint/UserWidget.h".}
proc createWidget*[T: UUserWidget](owningPlayer: ptr APlayerController, class: ptr UClass): ptr T {.importcpp: "CreateWidget<'*0>(@)", header: "Blueprint/UserWidget.h".}
proc createWidget*[T: UUserWidget](owningGame: ptr UGameInstance): ptr T {.importcpp: "CreateWidget<'*0>(@)", header: "Blueprint/UserWidget.h".}
proc createWidget*[T: UUserWidget](owningGame: ptr UGameInstance, class: ptr UClass): ptr T {.importcpp: "CreateWidget<'*0>(@)", header: "Blueprint/UserWidget.h".}
