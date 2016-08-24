# Copyright 2016 Xored Software, Inc.

type
  EWidgetDesignFlags {.importcpp: "EWidgetDesignFlags::Type", header: "UMG.h", pure.} = enum
    ## Flags used by the widget designer.
    None        = 0,
    Designing   = 1,
    ShowOutline = 2

# Common Bindings - If you add any new common binding, you must provide a UPropertyBinder for it.
#                   all primitive binding in UMG goes through native binding evaluators to prevent
#                   thunking through the VM.

declareBuiltinDelegateWithNs(FGetBool, dkDynamicRetVal, "UMG.h", "UWidget", bool)
declareBuiltinDelegateWithNs(FGetFloat, dkDynamicRetVal, "UMG.h", "UWidget", float)
declareBuiltinDelegateWithNs(FGetInt32, dkDynamicRetVal, "UMG.h", "UWidget", int32)
declareBuiltinDelegateWithNs(FGetText, dkDynamicRetVal, "UMG.h", "UWidget", FText)
declareBuiltinDelegateWithNs(FGetSlateColor, dkDynamicRetVal, "UMG.h", "UWidget", FSlateColor)
declareBuiltinDelegateWithNs(FGetLinearColor, dkDynamicRetVal, "UMG.h", "UWidget", FLinearColor)
declareBuiltinDelegateWithNs(FGetSlateBrush, dkDynamicRetVal, "UMG.h", "UWidget", FSlateBrush)
declareBuiltinDelegateWithNs(FGetSlateVisibility, dkDynamicRetVal, "UMG.h", "UWidget", ESlateVisibility)
declareBuiltinDelegateWithNs(FGetMouseCursor, dkDynamicRetVal, "UMG.h", "UWidget", EMouseCursor)
declareBuiltinDelegateWithNs(FGetCheckBoxState, dkDynamicRetVal, "UMG.h", "UWidget", ECheckBoxState)
declareBuiltinDelegateWithNs(FGetWidget, dkDynamicRetVal, "UMG.h", "UWidget", UWidget)


declareBuiltinDelegateWithNs(FGenerateWidgetForString, dkDynamicRetVal, "UMG.h", "UWidget", ptr UWidget, item: ptr FString)
declareBuiltinDelegateWithNs(FGenerateWidgetForObject, dkDynamicRetVal, "UMG.h", "UWidget", ptr UWidget, item: ptr UObject)

declareBuiltinDelegateWithNs(FOnReply, dkDynamicRetVal, "UMG.h", "UWidget", FEventReply)
declareBuiltinDelegateWithNs(FOnPointerEvent, dkDynamicRetVal, "UMG.h", "UWidget", FEventReply,
                             myGeometry: FGeometry, mouseEvent: FPointerEvent)

wclass(UWidget of UVisual, header: "UMG.h", notypedef):
  var bIsVariable: bool
    ## Allows controls to be exposed as variables in a blueprint.  Not all controls need to be exposed
    ## as variables, so this allows only the most useful ones to end up being exposed.
    ##
    ## UPROPERTY()

  var bCreatedByConstructionScript: bool
    ## Flag if the Widget was created from a blueprint
    ## UPROPERTY(Transient)

  var slot: ptr UPanelSlot
    ## The parent slot of the UWidget.  Allows us to easily inline edit the layout controlling this widget.
    ##
    ## UPROPERTY(Instanced, EditAnywhere, BlueprintReadOnly, Category=Layout, meta=(ShowOnlyInnerProperties))

  var bIsEnabled: bool
    ## Sets whether this widget can be modified interactively by the user
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="Behavior")

  var bIsEnabledDelegate: FGetBool
    ## A bindable delegate for bIsEnabled
    ## UPROPERTY()

  var toolTipText: FText
    ## Tooltip text to show when the user hovers over the widget with the mouse
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="Behavior", meta=(MultiLine=true))

  var toolTipTextDelegate: FGetText
    ## A bindable delegate for ToolTipText
    ## UPROPERTY()

  var toolTipWidget: ptr UWidget
    ## Tooltip widget to show when the user hovers over the widget with the mouse
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="Behavior", AdvancedDisplay)

  var visibility: ESlateVisibility
    ## The visibility of the widget
    ## UPROPERTY(EditAnywhere, Category="Behavior")

  var visibilityDelegate: FGetSlateVisibility
    ## A bindable delegate for Visibility
    ## UPROPERTY()

  var bOverride_Cursor: bool
    ##
    ## UPROPERTY(EditAnywhere, Category="Behavior", meta=(InlineEditConditionToggle))

  var cursor: TEnumAsByte[EMouseCursor]
    ## The cursor to show when the mouse is over the widget
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="Behavior", AdvancedDisplay, meta=( editcondition="bOverride_Cursor" ))

  var cursorDelegate: FGetMouseCursor
    ## A bindable delegate for Cursor
    ## UPROPERTY()
# protected:

  var bIsVolatile: bool
    ## If true prevents the widget or its child's geometry or layout information from being cached.  If this widget
    ## changes every frame, but you want it to still be in an invalidation panel you should make it as volatile
    ## instead of invalidating it every frame, which would prevent the invalidation panel from actually
    ## ever caching anything.
    ##
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="Performance")

# public:
  var renderTransform: FWidgetTransform
    ## The render transform of the widget allows for arbitrary 2D transforms to be applied to the widget.
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="Render Transform", meta=( DisplayName="Transform" ))

  var renderTransformPivot: FVector2D
    ## The render transform pivot controls the location about which transforms are applied.
    ## This value is a normalized coordinate about which things like rotations will occur.
    ##
    ## UPROPERTY(EditAnywhere, BlueprintReadOnly, Category="Render Transform", meta=( DisplayName="Pivot" ))

  var navigation: ptr UWidgetNavigation
    ## The navigation object for this widget is optionally created if the user has configured custom
    ## navigation rules for this widget in the widget designer.  Those rules determine how navigation transitions
    ## can occur between widgets.
    ##
    ## UPROPERTY(Instanced, EditAnywhere, BlueprintReadOnly, Category="Navigation")

#if WITH_EDITORONLY_DATA
  var bHiddenInDesigner: bool
    ## Stores the design time flag setting if the widget is hidden inside the designer
    ## UPROPERTY()

  var bExpandedInDesigner: bool
    ## Stores the design time flag setting if the widget is expanded inside the designer
    ## UPROPERTY()

  var widgetGeneratedBy: TWeakObjectPtr[UObject]
    ## Stores a reference to the asset responsible for this widgets construction.

#endif
  var widgetGeneratedByClass: TWeakObjectPtr[UClass]
    ## Stores a reference to the class responsible for this widgets construction.

  proc setRenderTransform(inTransform: FWidgetTransform)
    ## UFUNCTION(BlueprintCallable, Category="Widget|Transform")

  proc setRenderScale(scale: FVector2D)
    ## UFUNCTION(BlueprintCallable, Category="Widget|Transform")

  proc setRenderShear(shear: FVector2D)
    ## UFUNCTION(BlueprintCallable, Category="Widget|Transform")

  proc setRenderAngle(angle: cfloat)
    ## UFUNCTION(BlueprintCallable, Category="Widget|Transform")

  proc setRenderTranslation(translation: FVector2D)
    ## UFUNCTION(BlueprintCallable, Category="Widget|Transform")

  proc setRenderTransformPivot(pivot: FVector2D)
    ## UFUNCTION(BlueprintCallable, Category="Widget|Transform")

  proc getIsEnabled(): bool {.noSideEffect.}
    ## Gets the current enabled status of the widget
    ## UFUNCTION(BlueprintCallable, Category="Widget")

  proc setIsEnabled(bInIsEnabled: bool)
    ## Sets the current enabled status of the widget
    ## UFUNCTION(BlueprintCallable, Category="Widget")

  proc setToolTipText(inToolTipText: FText)
    ## Sets the tooltip text for the widget.
    ## UFUNCTION(BlueprintCallable, Category="Widget")

  proc setToolTip(widget: ptr UWidget)
    ## Sets a custom widget as the tooltip of the widget.
    ## UFUNCTION(BlueprintCallable, Category="Widget")

  proc setCursor(inCursor: EMouseCursor)
    ## Sets the cursor to show over the widget.
    ## UFUNCTION(BlueprintCallable, Category="Widget")

  proc resetCursor()
    ## Resets the cursor to use on the widget, removing any customization for it.
    ## UFUNCTION(BlueprintCallable, Category="Widget")

  proc isVisible(): bool {.noSideEffect.}
    ## @return true if the widget is Visible, HitTestInvisible or SelfHitTestInvisible.
    ## UFUNCTION(BlueprintCallable, Category="Widget")

  proc getVisibility(): ESlateVisibility {.noSideEffect.}
    ## Gets the current visibility of the widget.
    ## UFUNCTION(BlueprintCallable, Category="Widget")

  proc setVisibility(inVisibility: ESlateVisibility)
    ## Sets the visibility of the widget.
    ## UFUNCTION(BlueprintCallable, Category="Widget")

  proc forceVolatile(bForce: bool)
    ## Sets the forced volatility of the widget.
    ## UFUNCTION(BlueprintCallable, Category="Widget")

  proc isHovered(): bool {.noSideEffect.}
    ## @return true if the widget is currently being hovered by a pointer device
    ## UFUNCTION(BlueprintCallable, Category="Widget")

  proc hasKeyboardFocus(): bool {.noSideEffect.}
    ## Checks to see if this widget currently has the keyboard focus
    ##
    ## @return  True if this widget has keyboard focus
    ##
    ## UFUNCTION(BlueprintCallable, Category="Widget")

  proc hasMouseCapture(): bool {.noSideEffect.}
    ## Checks to see if this widget is the current mouse captor
    ## @return  True if this widget has captured the mouse
    ##
    ## UFUNCTION(BlueprintCallable, Category="Widget")

  proc setKeyboardFocus()
    ## Sets the focus to this widget.
    ## UFUNCTION(BlueprintCallable, Category="Widget")

  proc hasUserFocus(playerController: ptr APlayerController): bool {.noSideEffect.}
    ## @return true if this widget is focused by a specific user.
    ## UFUNCTION(BlueprintCallable, Category="Widget")

  proc hasAnyUserFocus(): bool {.noSideEffect.}
    ## @return true if this widget is focused by any user.
    ## UFUNCTION(BlueprintCallable, Category="Widget")

  proc hasFocusedDescendants(): bool {.noSideEffect.}
    ## @return true if any descendant widget is focused by any user.
    ## UFUNCTION(BlueprintCallable, Category="Widget", meta=(DisplayName="HasAnyUserFocusedDescendants"))

  proc hasUserFocusedDescendants(playerController: ptr APlayerController): bool {.
      noSideEffect.}
    ## @return true if any descendant widget is focused by a specific user.
    ## UFUNCTION(BlueprintCallable, Category="Widget")

  proc setUserFocus(playerController: ptr APlayerController)
    ## Sets the focus to this widget for a specific user
    ## UFUNCTION(BlueprintCallable, Category="Widget")

  proc forceLayoutPrepass()
    ## Forces a pre-pass.  A pre-pass caches the desired size of the widget hierarchy owned by this widget.
    ## One pre-pass is already happens for every widget before Tick occurs.  You only need to perform another
    ## pre-pass if you are adding child widgets this frame and want them to immediately be visible this frame.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Widget")

  proc invalidateLayoutAndVolatility()
    ## Invalidates the widget from the view of a layout caching widget that may own this widget.
    ## will force the owning widget to redraw and cache children on the next paint pass.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Widget")

  proc getDesiredSize(): FVector2D {.noSideEffect.}
    ## Gets the widgets desired size.
    ## NOTE: The underlying Slate widget must exist and be valid, also at least one pre-pass must
    ##       have occurred before this value will be of any use.
    ##
    ## @return The widget's desired size
    ##
    ## UFUNCTION(BlueprintCallable, Category="Widget")

  proc getParent(): ptr UPanelWidget {.noSideEffect.}
    ## Gets the parent widget
    ## UFUNCTION(BlueprintCallable, Category="Widget")

  method removeFromParent()
    ## Removes the widget from its parent widget.  If this widget was added to the player's screen or the viewport
    ## it will also be removed from those containers.
    ##
    ## UFUNCTION(BlueprintCallable, Category="Widget")

  proc takeWidget(): TSharedRef[SWidget]
    ## Gets the underlying slate widget or constructs it if it doesn't exist.  This function is
    ## virtual however, you should not inherit this function unless you're very aware of what you're
    ## doing.  Normal derived versions should only ever override RebuildWidget.

  # proc takeDerivedWidget[T: SWidget](constructMethod: constructMethodType): TSharedRef[T]
  #  ## Gets the underlying slate widget or constructs it if it doesn't exist.
  #  ##
  #  ## @param ConstructMethod allows the caller to specify a custom constructor that will be provided the
  #  ##  						  default parameters we use to construct the slate widget, this allows the caller
  #  ##  						  to construct derived types of SObjectWidget in cases where additional
  #  ##  						  functionality at the slate level is desirable.
  #  ## @example
  #  ##  		class SObjectWidgetCustom : public SObjectWidget, public IMixinBehavior
  #  ##      { }
  #  ##
  #  ##      Widget->TakeDerivedWidget<SObjectWidgetCustom>( []( UUserWidget* Widget, TSharedRef<SWidget> Content ) {
  #  ##  			return SNew( SObjectWidgetCustom, Widget )
  #  ##  					[
  #  ##  						Content
  #  ##  					];
  #  ##  		});

  proc getCachedWidget(): TSharedPtr[SWidget] {.noSideEffect.}
    ## Gets the last created widget does not recreate the gc container for the widget if one is needed.

  method synchronizeProperties()
    ## Applies all properties to the native widget if possible.  This is called after a widget is constructed.
    ## It can also be called by the editor to update modified state, so ensure all initialization to a widgets
    ## properties are performed here, or the property and visual state may become unsynced.

  proc buildNavigation()
    ## Called by the owning user widget after the slate widget has been created.  After the entire widget tree
    ## has been initialized, any widget reference that was needed to support navigating to another widget will
    ## now be initialized and ready for usage.

  proc isDesignTime(): bool {.noSideEffect.}
    ## Returns if the widget is currently being displayed in the designer, it may want to display different data.
#when WITH_EDITOR:
  method setDesignerFlags(newFlags: EWidgetDesignFlags)
    ## Sets the designer flags on the widget.
  proc getDesignerFlags(): EWidgetDesignFlags {.noSideEffect.}
    ## Gets the designer flags currently set on the widget.
  proc hasAnyDesignerFlags(flagToCheck: EWidgetDesignFlags): bool {.noSideEffect.}
    ## Tests if any of the flags exist on this widget.
  proc getDisplayLabel(): var FString {.noSideEffect.}
    ## @return The friendly name of the widget to display in the editor
  proc setDisplayLabel(displayLabel: FString)
    ## Sets the friendly name of the widget to display in the editor
#endwhen

  proc isChildOf(possibleParent: ptr UWidget): bool
    ## Recurses up the list of parents and returns true if this widget is a descendant of the PossibleParent
    ## @return true if this widget is a child of the PossibleParent

  ## static TSubclassOf<UPropertyBinding> FindBinderClassForDestination(UProperty* Property);

  proc canSafelyRouteEvent(): bool

#if WITH_EDITOR
  proc isGeneratedName(): bool {.noSideEffect.}
    ## Is the label generated or provided by the user?

  method getLabelMetadata(): FString {.noSideEffect.}
    ## Get Label Metadata, which may be as simple as a bit of string data to help identify an anonymous text block.

  proc getLabelText(): FText {.noSideEffect.}
    ## Gets the label to display to the user for this widget.

  method getPaletteCategory(): FText
    ## Gets the palette category of the widget

  method onCreationFromPalette()
    ## Called by the palette after constructing a new widget, allows the widget to perform interesting
    ## default setup that we don't want to be UObject Defaults.

  method connectEditorData()
    ## Allows general fixups and connections only used at editor time.

  method getVisibilityInDesigner(): EVisibility {.noSideEffect.}
    ## Gets the visibility of the widget inside the designer.
# Begin Designer contextual events

  proc select()
  proc deselect()

  method onSelected()
  method onDeselected()
  method onDescendantSelected(descendantWidget: ptr UWidget)
  method onDescendantDeselected(descendantWidget: ptr UWidget)
  method onBeginEdit()
  method onEndEdit()
# End Designer contextual events
#endif

  ## Utility methods
  ##@TODO UMG: Should move elsewhere
  ## static EVisibility ConvertSerializedVisibilityToRuntime(ESlateVisibility Input);
  ## static ESlateVisibility ConvertRuntimeToSerializedVisibility(const EVisibility& Input);
  ## static FSizeParam ConvertSerializedSizeParamToRuntime(const FSlateChildSize& Input);
  ## static UWidget* FindChildContainingDescendant(UWidget* Root, UWidget* Descendant);

# protected:

  method onBindingChanged(property: FName)

  method rebuildWidget(): TSharedRef[SWidget]
    ## Function implemented by all subclasses of UWidget is called when the underlying SWidget needs to be constructed.

  method onWidgetRebuilt()
    ## Function called after the underlying SWidget is constructed.

  proc buildDesignTimeWidget[W: SWidget](wrapWidget: TSharedRef[W]): TSharedRef[SWidget]
    ## Utility method for building a design time wrapper widget.
  proc updateRenderTransform()

  proc getDisplayNameBase(): FText {.noSideEffect.}
    ## Gets the base name used to generate the display label/name of this widget.

# Conversion functions
  proc convertVisibility(serializedType: TAttribute[ESlateVisibility]): EVisibility {.
      noSideEffect.}
  proc convertFloatToOptionalFloat(inFloat: TAttribute[cfloat]): TOptional[cfloat] {.
      noSideEffect.}
  proc convertLinearColorToSlateColor(inLinearColor: TAttribute[FLinearColor]): FSlateColor {.
      noSideEffect.}

  var myWidget: TWeakPtr[SWidget]
    ## The underlying SWidget.
  var myGCWidget: TWeakPtr[SObjectWidget]
    ## The underlying SWidget contained in a SObjectWidget

  var nativeBindings: TArray[ptr UPropertyBinding]
    ## Native property bindings.
    ## UPROPERTY(Transient)
