# Copyright 2016 Xored Software, Inc.

wclass(UPanelSlot of UVisual, header: "UMG.h"):
  ## The base class for all Slots in UMG.
  var parent: ptr UPanelWidget
  var content: ptr UWidget

  proc isDesignTime(): bool {.noSideEffect.}

  method synchronizeProperties()
    ## Applies all properties to the live slot if possible.
