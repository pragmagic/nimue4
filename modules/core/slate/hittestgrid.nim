# Copyright 2016 Xored Software, Inc.

wclass(ICustomHitTestPath, header: "Input/HittestGrid.h"):
  method getBubblePathAndVirtualCursors(inGeometry: FGeometry, desktopSpaceCoordinate: FVector2D, bIgnoreEnabledStatus: bool): TArray[FWidgetAndPointer]

  method arrangeChildren(arrangedChildren: FArrangedChildren)

  method translateMouseCoordinateFor3DChild(childWidget: TSharedRef[SWidget], viewportGeometry: FGeometry,
                                            screenSpaceMouseCoordinate: FVector2D, lastScreenSpaceMouseCoordinate: FVector2D): TSharedPtr[FVirtualPointerPosition]

wclass(FHittestGrid, header: "Input/HittestGrid.h", bycopy):
  proc initFHittestGrid(): FHittestGrid

  proc getBubblePath(desktopSpaceCoordinate: FVector2D, cursorRadius: float32, bIgnoreEnabledStatus: bool): TArray[FWidgetAndPointer]
    ## Given a Slate Units coordinate in virtual desktop space, perform a hittest
    ## and return the path along which the corresponding event would be bubbled.

  proc clearGridForNewFrame(hittestArea: FSlateRect)
    ## Clear the hittesting area and prepare to execute a new frame.
    ## Depending on monitor arrangement, the area to be hittested could begin
    ## in the negative coordinates.
    ##
    ## @param HittestArea       Size in Slate Units of the area we are considering for hittesting.

  proc insertWidget(parentHittestIndex: int32, visibility: EVisibility, widget: FArrangedWidget,
                    inWindowOffset: FVector2D, inClippingRect: FSlateRect): int32
    ## Add Widget into the hittest data structure so that we can later make queries about it.

  proc insertCustomHitTestPath(customHitTestPath: TSharedRef[ICustomHitTestPath], widgetIndex: int32)

  proc findNextFocusableWidget(startingWidget: FArrangedWidget, direction: EUINavigation,
                               navigationReply: FNavigationReply, ruleWidget: FArrangedWidget): TSharedPtr[SWidget]
    ## Finds the next focusable widget by searching through the hit test grid
    ##
    ## @param StartingWidget  This is the widget we are starting at, and navigating from.
    ## @param Direction       The direction we should search in.
    ## @param NavigationReply The Navigation Reply to specify a boundary rule for the search.
    ## @param RuleWidget      The Widget that is applying the boundary rule, used to get the bounds of the Rule.
