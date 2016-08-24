# Copyright 2016 Xored Software, Inc.

wclass(UContentWidget of UPanelWidget, header: "UMG.h"):
  proc getContentSlot(): ptr UPanelSlot {.noSideEffect.}
    ## UFUNCTION(BlueprintCallable, Category="Widget|Panel")
