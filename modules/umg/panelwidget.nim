# Copyright 2016 Xored Software, Inc.

wclass(UPanelWidget of UWidget, header: "UMG.h", notypedef):
  ## The base class for all UMG panel widgets.  Panel widgets layout a collection of child widgets.
# protected:

  var slots: TArray[ptr UPanelSlot]
    ## The slots in the widget holding the child widgets of this panel.

# public:
  proc getChildrenCount(): int32 {.noSideEffect.}
    ## Gets number of child widgets in the container.

  proc getChildAt(index: int32): ptr UWidget {.noSideEffect.}
    ## Gets the widget at an index.
    ## @param Index The index of the widget.
    ## @return The widget at the given index, or nothing if there is no widget there.
    ## UFUNCTION(BlueprintCallable, Category="Widget|Panel")

  proc getChildIndex(content: ptr UWidget): int32 {.noSideEffect.}
    ## Gets the index of a specific child widget
    ## UFUNCTION(BlueprintCallable, Category="Widget|Panel")

  proc hasChild(content: ptr UWidget): bool {.noSideEffect.}
    ## @return true if panel contains this widget
    ## UFUNCTION(BlueprintCallable, Category="Widget|Panel")

  proc removeChildAt(index: int32): bool
    ## Removes a child by it's index.
    ## UFUNCTION(BlueprintCallable, Category="Widget|Panel")

  proc addChild(content: ptr UWidget): ptr UPanelSlot
    ## Adds a new child widget to the container.  Returns the base slot type,
    ## requires casting to turn it into the type specific to the container.
    ## UFUNCTION(BlueprintCallable, Category="Widget|Panel")

  proc replaceChildAt(index: int32, content: ptr UWidget): bool
    ## Swaps the widget out of the slot at the given index, replacing it with a different widget.
    ##
    ## @param Index the index at which to replace the child content with this new Content.
    ## @param Content The content to replace the child with.
    ## @return true if the index existed and the child could be replaced.

  #if WITH_EDITOR

  method replaceChild(currentChild, newChild: ptr UWidget): bool
    ## Swaps the child widget out of the slot, and replaces it with the new child widget.
    ## @param CurrentChild The existing child widget being removed.
    ## @param NewChild The new child widget being inserted.
    ## @return true if the CurrentChild was found and the swap occurred, otherwise false.

  proc insertChildAt(index: int32, content: ptr UWidget): ptr UPanelSlot
    ## Inserts a widget at a specific index.  This does not update the live slate version, it requires
    ## a rebuild of the whole UI to see a change.

  proc shiftChild(index: int32, child: ptr UWidget)
    ## Moves the child widget from its current index to the new index provided.

  proc setDesignerFlags(newFlags: EWidgetDesignFlags)
#endif

  proc removeChild(content: ptr UWidget): bool
    ## Removes a specific widget from the container.
    ## @return true if the widget was found and removed.
    ## UFUNCTION(BlueprintCallable, Category="Widget|Panel")

  proc hasAnyChildren(): bool {.noSideEffect.}
    ## @return true if there are any child widgets in the panel
    ## UFUNCTION(BlueprintCallable, Category="Widget|Panel")

  proc clearChildren()
    ## Remove all child widgets from the panel widget.
    ## UFUNCTION(BlueprintCallable, Category="Widget|Panel")

  proc getSlots(): TArray[ptr UPanelSlot] {.noSideEffect.}
    ## The slots in the widget holding the child widgets of this panel.

  proc canHaveMultipleChildren(): bool {.noSideEffect.}
    ## @returns true if the panel supports more than one child.

  proc canAddMoreChildren(): bool {.noSideEffect.}
    ## @returns true if the panel can accept another child widget.

#if WITH_EDITOR
  method lockToPanelOnDrag(): bool {.noSideEffect.}
#endif

# protected:

  method getSlotClass(): ptr UClass {.noSideEffect.}

  method onSlotAdded(slot: ptr UPanelSlot)

  method onSlotRemoved(slot: ptr UPanelSlot)

  var bCanHaveMultipleChildren: bool
    ## Can this panel allow for multiple children?
