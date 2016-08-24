# Copyright 2016 Xored Software, Inc.

wclass(FWidgetNavigationData, header: "UMG.h", bycopy):
  var rule: EUINavigationRule
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="Navigation")

  var widgetToFocus: FName
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="Navigation")

  var widget: TWeakObjectPtr[UWidget]

wclass(UWidgetNavigation of UObject, header: "UMG.h"):
  var up: FWidgetNavigationData
    ## Happens when the user presses up arrow, joystick, d-pad.
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="Navigation")

  var down: FWidgetNavigationData
    ## Happens when the user presses down arrow, joystick, d-pad.
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="Navigation")

  var left: FWidgetNavigationData
    ## Happens when the user presses left arrow, joystick, d-pad.
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="Navigation")

  var right: FWidgetNavigationData
    ## Happens when the user presses right arrow, joystick, d-pad.
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="Navigation")

  var next: FWidgetNavigationData
    ## Happens when the user presses Tab.
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="Navigation")

  var previous: FWidgetNavigationData
    ## Happens when the user presses Shift+Tab.
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="Navigation")

#if WITH_EDITOR
  proc getNavigationData(nav: EUINavigation): var FWidgetNavigationData
  proc getNavigationRule(nav:EUINavigation): EUINavigationRule
#endif

  proc resolveExplictRules(widgetTree: ptr UWidgetTree)
    ## Resolve widget names

  proc updateMetaData(metaData: TSharedRef[FNavigationMetaData])
    ## Updates a slate metadata object to match this configured navigation ruleset.

  proc isDefault(): bool {.noSideEffect.}
    ## @return true if the configured navigation object is the same as an un-customized navigation rule set.
