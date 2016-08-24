# Copyright 2016 Xored Software, Inc.

wclass(FSlateControlledConstruction, header: "SlateCore.h"):
  proc initFSlateControlledConstruction(): FSlateControlledConstruction {.constructor.}
  proc delete(mem: pointer)

type
  EInvalidateWidget {.importcpp, pure.} = enum
    ## The different types of invalidation that are possible for a widget.
    Layout,
      ## Use Layout invalidation if you're changing a normal property involving painting or sizing.
    LayoutAndVolatility
      ## Use Layout invalidation if you're changing a normal property involving painting or sizing.
      ## Additionally if the property that was changed affects Volatility in anyway, it's important
      ## that you invalidate volatility so that it can be recalculated and cached.

wclass(ILayoutCache, header: "SlateCore.h"):
  ## An ILayoutCache implementor is responsible for caching a the hierarchy of widgets it is drawing.
  ## The shipped implementation of this is SInvalidationPanel.
  method invalidateWidget(invalidateWidget: ptr SWidget)
  method createCacheNode(): ptr FCachedWidgetNode

wclass(FPopupLayer of TSharedFromThis[FPopupLayer], header: "SlateCore.h"):
  ## An FPopupLayer hosts the pop-up content which could be anything you want to appear on top of a widget.
  ## The widget must understand how to host pop-ups to make use of this.
  proc initFPopupLayer(initHostWidget: TSharedRef[SWidget], initPopupContent: TSharedRef[SWidget]): FPopupLayer {.constructor.}

  method getHost(): TSharedRef[SWidget]
  method getContent(): TSharedRef[SWidget]

  method remove()

type FActiveTimerHandle {.importcpp, nodecl.} = object

wclass(SWidget, header: "SlateCore.h", notypedef):
  ## Abstract base class for Slate widgets.
  ##
  ## STOP. DO NOT INHERIT DIRECTLY FROM WIDGET!
  ##
  ## Inheritance:
  ##   Widget is not meant to be directly inherited. Instead consider inheriting from LeafWidget or Panel,
  ##   which represent intended use cases and provide a succinct set of methods which to override.
  ##
  ##   SWidget is the base class for all interactive Slate entities. SWidget's public interface describes
  ##   everything that a Widget can do and is fairly complex as a result.
  ##
  ## Events:
  ##   Events in Slate are implemented as virtual functions that the Slate system will call
  ##   on a Widget in order to notify the Widget about an important occurrence (e.g. a key press)
  ##   or querying the Widget regarding some information (e.g. what mouse cursor should be displayed).
  ##
  ##   Widget provides a default implementation for most events; the default implementation does nothing
  ##   and does not handle the event.
  ##
  ##   Some events are able to reply to the system by returning an FReply, FCursorReply, or similar
  ##   object.
#
# GENERAL EVENTS
#
  proc paint(args: FPaintArgs; allottedGeometry: FGeometry; myClippingRect: FSlateRect;
             outDrawElements: var FSlateWindowElementList; layerId: int32;
             inWidgetStyle: FWidgetStyle; bParentEnabled: bool): int32 {.noSideEffect.}
    ## Called to tell a widget to paint itself (and it's children).
    ##
    ## The widget should respond by populating the OutDrawElements array with FDrawElements
    ## that represent it and any of its children.
    ##
    ## @param Args              All the arguments necessary to paint this widget (@todo umg: move all params into this struct)
    ## @param AllottedGeometry  The FGeometry that describes an area in which the widget should appear.
    ## @param MyClippingRect    The clipping rectangle allocated for this widget and its children.
    ## @param OutDrawElements   A list of FDrawElements to populate with the output.
    ## @param LayerId           The Layer onto which this widget should be rendered.
    ## @param InColorAndOpacity Color and Opacity to be applied to all the descendants of the widget being painted
    ## @param bParentEnabled	True if the parent of this widget is enabled.
    ## @return The maximum layer ID attained by this widget or any of its children.

  method tick(allottedGeometry: FGeometry; inCurrentTime: cdouble; inDeltaTime: cfloat)
    ## Ticks this widget with Geometry.  Override in derived classes, but always call the parent implementation.
    ##
    ## @param  AllottedGeometry The space allotted for this widget
    ## @param  InCurrentTime  Current absolute real time
    ## @param  InDeltaTime  Real time passed since last tick
#
# KEY INPUT
#

  method onFocusReceived(myGeometry: FGeometry; inFocusEvent: FFocusEvent): FReply
    ## Called when focus is given to this widget.  This event does not bubble.
    ##
    ## @param MyGeometry The Geometry of the widget receiving the event
    ## @param  InFocusEvent  The FocusEvent
    ## @return  Returns whether the event was handled, along with other possible actions

  method onFocusLost(inFocusEvent: FFocusEvent)
    ## Called when this widget loses focus.  This event does not bubble.
    ##
    ## @param InFocusEvent The FocusEvent

  method onFocusChanging(previousFocusPath: FWeakWidgetPath; newWidgetPath: FWidgetPath)
    ## Called whenever a focus path is changing on all the widgets within the old and new focus paths

  method onKeyChar(myGeometry: FGeometry; inCharacterEvent: FCharacterEvent): FReply
    ## Called after a character is entered while this widget has keyboard focus
    ##
    ## @param MyGeometry The Geometry of the widget receiving the event
    ## @param  InCharacterEvent  Character event
    ## @return  Returns whether the event was handled, along with other possible actions

  method onPreviewKeyDown(myGeometry: FGeometry; inKeyEvent: FKeyEvent): FReply
    ## Called after a key is pressed when this widget or a child of this widget has focus
    ## If a widget handles this event, OnKeyDown will *not* be passed to the focused widget.
    ##
    ## This event is primarily to allow parent widgets to consume an event before a child widget processes
    ## it and it should be used only when there is no better design alternative.
    ##
    ## @param MyGeometry The Geometry of the widget receiving the event
    ## @param InKeyEvent  Key event
    ## @return Returns whether the event was handled, along with other possible actions

  method onKeyDown(myGeometry: FGeometry; inKeyEvent: FKeyEvent): FReply
    ## Called after a key is pressed when this widget has focus (this event bubbles if not handled)
    ##
    ## @param MyGeometry The Geometry of the widget receiving the event
    ## @param InKeyEvent  Key event
    ## @return Returns whether the event was handled, along with other possible actions

  method onKeyUp(myGeometry: FGeometry; inKeyEvent: FKeyEvent): FReply
    ## Called after a key is released when this widget has focus
    ##
    ## @param MyGeometry The Geometry of the widget receiving the event
    ## @param InKeyEvent  Key event
    ## @return Returns whether the event was handled, along with other possible actions

  method onAnalogValueChanged(myGeometry: FGeometry;
                            inAnalogInputEvent: FAnalogInputEvent): FReply
    ## Called when an analog value changes on a button that supports analog
    ##
    ## @param MyGeometry The Geometry of the widget receiving the event
    ## @param InAnalogInputEvent Analog input event
    ## @return Returns whether the event was handled, along with other possible actions

#
# MOUSE INPUT
#

  method onMouseButtonDown(myGeometry: FGeometry; mouseEvent: FPointerEvent): FReply
    ## The system calls this method to notify the widget that a mouse button was pressed within it. This event is bubbled.
    ##
    ## @param MyGeometry The Geometry of the widget receiving the event
    ## @param MouseEvent Information about the input event
    ## @return Whether the event was handled along with possible requests for the system to take action.

  method onPreviewMouseButtonDown(myGeometry: FGeometry; mouseEvent: FPointerEvent): FReply
    ## Just like OnMouseButtonDown, but tunnels instead of bubbling.
    ## If this even is handled, OnMouseButtonDown will not be sent.
    ##
    ## Use this event sparingly as preview events generally make UIs more
    ## difficult to reason about.

  method onMouseButtonUp(myGeometry: FGeometry; mouseEvent: FPointerEvent): FReply
    ## The system calls this method to notify the widget that a mouse button was release within it. This event is bubbled.
    ##
    ## @param MyGeometry The Geometry of the widget receiving the event
    ## @param MouseEvent Information about the input event
    ## @return Whether the event was handled along with possible requests for the system to take action.

  method onMouseMove(myGeometry: FGeometry; mouseEvent: FPointerEvent): FReply
    ## The system calls this method to notify the widget that a mouse moved within it. This event is bubbled.
    ##
    ## @param MyGeometry The Geometry of the widget receiving the event
    ## @param MouseEvent Information about the input event
    ## @return Whether the event was handled along with possible requests for the system to take action.

  method onMouseEnter(myGeometry: FGeometry; mouseEvent: FPointerEvent)
    ## The system will use this event to notify a widget that the cursor has entered it. This event is uses a custom bubble strategy.
    ##
    ## @param MyGeometry The Geometry of the widget receiving the event
    ## @param MouseEvent Information about the input event

  method onMouseLeave(mouseEvent: FPointerEvent)
    ## The system will use this event to notify a widget that the cursor has left it. This event is uses a custom bubble strategy.
    ##
    ## @param MouseEvent Information about the input event

  method onMouseWheel(myGeometry: FGeometry; mouseEvent: FPointerEvent): FReply
    ## Called when the mouse wheel is spun. This event is bubbled.
    ##
    ## @param  MouseEvent  Mouse event
    ## @return  Returns whether the event was handled, along with other possible actions

  method onCursorQuery(myGeometry: FGeometry; cursorEvent: FPointerEvent): FCursorReply {.
      noSideEffect.}
    ## The system asks each widget under the mouse to provide a cursor. This event is bubbled.
    ##
    ## @return FCursorReply::Unhandled() if the event is not handled; return FCursorReply::Cursor() otherwise.

  method onMapCursor(cursorReply: FCursorReply): TOptional[TSharedRef[SWidget]] {.
      noSideEffect.}
    ## After OnCursorQuery has specified a cursor type the system asks each widget under the mouse to map that cursor to a widget. This event is bubbled.
    ##
    ## @return TOptional<TSharedRef<SWidget>>() if you don't have a mapping otherwise return the Widget to show.

  method onMouseButtonDoubleClick(inMyGeometry: FGeometry; inMouseEvent: FPointerEvent): FReply
    ## Called when a mouse button is double clicked.  Override this in derived classes.
    ##
    ## @param  InMyGeometry  Widget geometry
    ## @param  InMouseEvent  Mouse button event
    ## @return  Returns whether the event was handled, along with other possible actions

  method onVisualizeTooltip(tooltipContent: TSharedPtr[SWidget]): bool
    ## Called when Slate wants to visualize tooltip.
    ## If nobody handles this event, Slate will use default tooltip visualization.
    ## If you override this event, you should probably return true.
    ##
    ## @param  TooltipContent    The TooltipContent that I may want to visualize.
    ## @return true if this widget visualized the tooltip content; i.e., the event is handled.

  method onVisualizePopup(popupContent: TSharedRef[SWidget]): TSharedPtr[FPopupLayer]
    ## Visualize a new pop-up if possible.  If it's not possible for this widget to host the pop-up
    ## content you'll get back an invalid pointer to the layer.  The returned FPopupLayer allows you
    ## to remove the pop-up when you're done with it
    ##
    ## @param PopupContent The widget to try and host overlaid on top of the widget.
    ##
    ## @return a valid FPopupLayer if this widget supported hosting it.  You can call Remove() on this to destroy the pop-up.

  method onDragDetected(myGeometry: FGeometry; mouseEvent: FPointerEvent): FReply
    ## Called when Slate detects that a widget started to be dragged.
    ## Usage:
    ## A widget can ask Slate to detect a drag.
    ## OnMouseDown() reply with FReply::Handled().DetectDrag( SharedThis(this) ).
    ## Slate will either send an OnDragDetected() event or do nothing.
    ## If the user releases a mouse button or leaves the widget before
    ## a drag is triggered (maybe user started at the very edge) then no event will be
    ## sent.
    ##
    ## @param  InMyGeometry  Widget geometry
    ## @param  InMouseEvent  MouseMove that triggered the drag
#
# DRAG AND DROP (DragDrop)
#

  method onDragEnter(myGeometry: FGeometry; dragDropEvent: FDragDropEvent)
    ## Called during drag and drop when the drag enters a widget.
    ##
    ## Enter/Leave events in slate are meant as lightweight notifications.
    ## So we do not want to capture mouse or set focus in response to these.
    ## However, OnDragEnter must also support external APIs (e.g. OLE Drag/Drop)
    ## Those require that we let them know whether we can handle the content
    ## being dragged OnDragEnter.
    ##
    ## The concession is to return a can_handled/cannot_handle
    ## boolean rather than a full FReply.
    ##
    ## @param MyGeometry      The geometry of the widget receiving the event.
    ## @param DragDropEvent   The drag and drop event.
    ##
    ## @return A reply that indicated whether the contents of the DragDropEvent can potentially be processed by this widget.

  method onDragLeave(dragDropEvent: FDragDropEvent)
    ## Called during drag and drop when the drag leaves a widget.
    ##
    ## @param DragDropEvent   The drag and drop event.

  method onDragOver(myGeometry: FGeometry; dragDropEvent: FDragDropEvent): FReply
    ## Called during drag and drop when the the mouse is being dragged over a widget.
    ##
    ## @param MyGeometry      The geometry of the widget receiving the event.
    ## @param DragDropEvent   The drag and drop event.
    ## @return A reply that indicated whether this event was handled.

  method onDrop(myGeometry: FGeometry; dragDropEvent: FDragDropEvent): FReply
    ## Called when the user is dropping something onto a widget; terminates drag and drop.
    ##
    ## @param MyGeometry      The geometry of the widget receiving the event.
    ## @param DragDropEvent   The drag and drop event.
    ## @return A reply that indicated whether this event was handled.
#
# TOUCH and GESTURES
#

  method onTouchGesture(myGeometry: FGeometry; gestureEvent: FPointerEvent): FReply
    ## Called when the user performs a gesture on trackpad. This event is bubbled.
    ##
    ## @param  GestureEvent  gesture event
    ## @return  Returns whether the event was handled, along with other possible actions

  method onTouchStarted(myGeometry: FGeometry; inTouchEvent: FPointerEvent): FReply
    ## Called when a touchpad touch is started (finger down)
    ##
    ## @param InTouchEvent	The touch event generated

  method onTouchMoved(myGeometry: FGeometry; inTouchEvent: FPointerEvent): FReply
    ## Called when a touchpad touch is moved  (finger moved)
    ##
    ## @param InTouchEvent	The touch event generated

  method onTouchEnded(myGeometry: FGeometry; inTouchEvent: FPointerEvent): FReply
    ## Called when a touchpad touch is ended (finger lifted)
    ##
    ## @param InTouchEvent	The touch event generated

  method onMotionDetected(myGeometry: FGeometry; inMotionEvent: FMotionEvent): FReply
    ## Called when motion is detected (controller or device)
    ## e.g. Someone tilts or shakes their controller.
    ##
    ## @param InMotionEvent	The motion event generated

  method onQueryShowFocus(inFocusCause: EFocusCause): TOptional[bool] {.noSideEffect.}
    ## Called to determine if we should render the focus brush.
    ##
    ## @param InFocusCause	The cause of focus

  method onQueryPopupMethod(): FPopupMethodReply {.noSideEffect.}
    ## Popups can manifest in a NEW OS WINDOW or via an OVERLAY in an existing window.
    ## This can be set explicitly on SMenuAnchor, or can be determined by a scoping widget.
    ## A scoping widget can reply to OnQueryPopupMethod() to drive all its descendants'
    ## poup methods.
    ##
    ## e.g. Fullscreen games cannot summon a new window, so game SViewports will reply with
    ##      EPopupMethod::UserCurrentWindow. This makes all the menu anchors within them
    ##      use the current window.
  method translateMouseCoordinateFor3DChild(childWidget: TSharedRef[SWidget];
                                        myGeometry: FGeometry;
                                        screenSpaceMouseCoordinate: FVector2D;
      lastScreenSpaceMouseCoordinate: FVector2D): TSharedPtr[FVirtualPointerPosition] {.
      noSideEffect.}

  method onFinishedPointerInput()
    ## All the pointer (mouse, touch, stylus, etc.) events from this frame have been routed.
    ## This is a widget's chance to act on any accumulated data.

  method onFinishedKeyInput()
    ## All the key (keyboard, gamepay, joystick, etc.) input from this frame has been routed.
    ## This is a widget's chance to act on any accumulated data.

  method onNavigation(myGeometry: FGeometry; inNavigationEvent: FNavigationEvent): FNavigationReply
    ## Called when navigation is requested
    ## e.g. Left Joystick, Direction Pad, Arrow Keys can generate navigation events.
    ##
    ## @param InNavigationEvent	The navigation event generated

  method getWindowZoneOverride(): EWindowZone {.noSideEffect.}
    ## Called when the mouse is moved over the widget's window, to determine if we should report whether
    ## OS-specific features should be active at this location (such as a title bar grip, system menu, etc.)
    ## Usually you should not need to override this function.
    ##
    ## @return	The window "zone" the cursor is over, or EWindowZone::Unspecified if no special behavior is needed
#
# LAYOUT
#
# public:

  proc slatePrepass(layoutScaleMultiplier: cfloat)
    ## Descends to leafmost widgets in the hierarchy and gathers desired sizes on the way up.
    ## i.e. Caches the desired size of all of this widget's children recursively, then caches desired size for itself.

  proc getDesiredSize(): var FVector2D {.noSideEffect.}
    ## @return the DesiredSize that was computed the last time CacheDesiredSize() was called.

  method cacheDesiredSize(a2: cfloat)
    ## The system calls this method. It performs a breadth-first traversal of every visible widget and asks
    ## each widget to cache how big it needs to be in order to present all of its content.

  proc advanced_SetDesiredSize(inDesiredSize: FVector2D)
    ## Explicitly set the desired size. This is highly advanced functionality that is meant
    ## to be used in conjunction with overriding CacheDesiredSize. Use ComputeDesiredSize() instead.

  method getRelativeLayoutScale(child: FSlotBase): cfloat {.noSideEffect.}
    ## What is the Child's scale relative to this widget.

  proc arrangeChildren(allottedGeometry: FGeometry;
                       arrangedChildren: var FArrangedChildren) {.noSideEffect.}
    ## Non-virtual entry point for arrange children. ensures common work is executed before calling the virtual
    ## ArrangeChildren function.
    ## Compute the Geometry of all the children and add populate the ArrangedChildren list with their values.
    ## Each type of Layout panel should arrange children based on desired behavior.
    ##
    ## @param AllottedGeometry    The geometry allotted for this widget by its parent.
    ## @param ArrangedChildren    The array to which to add the WidgetGeometries that represent the arranged children.

  method getChildren(): ptr FChildren
    ## Every widget that has children must implement this method. This allows for iteration over the Widget's
    ## children regardless of how they are actually stored.
    ##
    ## @todo Slate: Consider renaming to GetVisibleChildren  (not ALL children will be returned in all cases)

  method supportsKeyboardFocus(): bool {.noSideEffect.}
    ## Checks to see if this widget supports keyboard focus.  Override this in derived classes.
    ##
    ## @return  True if this widget can take keyboard focus

  method hasKeyboardFocus(): bool {.noSideEffect.}
    ## Checks to see if this widget currently has the keyboard focus
    ##
    ## @return  True if this widget has keyboard focus

  proc hasUserFocus(userIndex: int32): TOptional[EFocusCause] {.noSideEffect.}
    ## Gets whether or not the specified users has this widget focused, and if so the type of focus.
    ##
    ## @return The optional will be set with the focus cause, if unset this widget doesn't have focus.

  proc hasAnyUserFocus(): TOptional[EFocusCause] {.noSideEffect.}
    ## Gets whether or not any users have this widget focused, and if so the type of focus (first one found).
    ##
    ## @return The optional will be set with the focus cause, if unset this widget doesn't have focus.

  proc hasUserFocusedDescendants(userIndex: int32): bool {.noSideEffect.}
    ## Gets whether or not the specified users has this widget or any descendant focused.
    ##
    ## @return The optional will be set with the focus cause, if unset this widget doesn't have focus.

  proc hasFocusedDescendants(): bool {.noSideEffect.}
    ## @return Whether this widget has any descendants with keyboard focus

  proc hasAnyUserFocusOrFocusedDescendants(): bool {.noSideEffect.}
    ## @return whether or not any users have this widget focused, or any descendant focused.

  proc hasMouseCapture(): bool {.noSideEffect.}
    ## Checks to see if this widget is the current mouse captor
    ##
    ## @return  True if this widget has captured the mouse

  method onMouseCaptureLost()
    ## Called when this widget had captured the mouse, but that capture has been revoked for some reason.

  proc tickWidgetsRecursively(allottedGeometry: FGeometry; inCurrentTime: cdouble;
                              inDeltaTime: cfloat)
    ## Ticks this widget and all of it's child widgets.  Should not be called directly.
    ##
    ## @param  AllottedGeometry The space allotted for this widget
    ## @param  InCurrentTime  Current absolute real time
    ## @param  InDeltaTime  Real time passed since last tick

  proc setEnabled(inEnabledState: TAttribute[bool])
    ## Sets the enabled state of this widget
    ##
    ## @param InEnabledState	An attribute containing the enabled state or a delegate to call to get the enabled state.

  proc isEnabled(): bool {.noSideEffect.}
    ## @return Whether or not this widget is enabled

  method isInteractable(): bool {.noSideEffect.}
    ## @return Is this widget interactable or not? Defaults to false

  method getToolTip(): TSharedPtr[IToolTip]
    ## @return The tool tip associated with this widget; Invalid reference if there is not one

  method onToolTipClosing()
    ## Called when a tooltip displayed from this widget is being closed

  proc enableToolTipForceField(bEnableForceField: bool)
    ## Sets whether this widget is a "tool tip force field".  That is, tool-tips should never spawn over the area
    ## occupied by this widget, and will instead be repelled to an outside edge
    ##
    ## @param	bEnableForceField	True to enable tool tip force field for this widget

  proc hasToolTipForceField(): bool {.noSideEffect.}
    ## @return True if a tool tip force field is active on this widget

  method isHovered(): bool {.noSideEffect.}
    ## @return True if this widget hovered

  method isDirectlyHovered(): bool {.noSideEffect.}
    ## @return True if this widget is directly hovered

  method getVisibility(): EVisibility {.noSideEffect.}
    ## @return is this widget visible, hidden or collapsed

  proc setVisibility(inVisibility: TAttribute[EVisibility])
    ## @param InVisibility  should this widget be

  proc isVolatile(): bool {.noSideEffect.}
    ## When performing a caching pass, volatile widgets are not cached as part of everything
    ## else, instead they and their children are drawn as normal standard widgets and excluded
    ## from the cache.  This is extremely useful for things like timers and text that change
    ## every frame.

  proc isVolatileIndirectly(): bool {.noSideEffect.}
    ## Was this widget painted as part of a volatile pass previously.  This may mean it was the
    ## widget directly responsible for making a hierarchy volatile, or it may mean it was simply
    ## a child of a volatile panel.

  proc forceVolatile(bForce: bool)
    ## Should this widget always appear as volatile for any layout caching host widget.  A volatile
    ## widget's geometry and layout data will never be cached, and neither will any children.
    ## @param bForce should we force the widget to be volatile?

  proc invalidate(invalidate: EInvalidateWidget)
    ## Invalidates the widget from the view of a layout caching widget that may own this widget.
    ## will force the owning widget to redraw and cache children on the next paint pass.

  proc cacheVolatility()
    ## Recalculates volatility of the widget and caches the result.  Should be called any time
    ## anything examined by your implementation of ComputeVolatility is changed.

# protected:

  proc advanced_InvalidateVolatility(): bool
    ## Recalculates and caches volatility and returns 'true' if the volatility changed.

  proc advanced_ForceInvalidateLayout()
    ## Forces invalidation, doesn't check volatility.

# public:
  proc getRenderTransform(): var TOptional[FSlateRenderTransform] {.noSideEffect.}
    ## @return the render transform of the widget.

  proc setRenderTransform(inTransform: TAttribute[TOptional[FSlateRenderTransform]])
    ## @param InTransform the render transform to set for the widget (transforms from widget's local space).
    ## TOptional<> to allow code to skip expensive overhead if there is no render transform applied.

  proc getRenderTransformPivot(): var FVector2D {.noSideEffect.}
    ## @return the pivot point of the render transform.

  proc setRenderTransformPivot(inTransformPivot: TAttribute[FVector2D])
    ## @param InTransformPivot Sets the pivot point of the widget's render transform (in normalized local space).

  proc setToolTipText(toolTipText: TAttribute[FText])
    ## Set the tool tip that should appear when this widget is hovered.
    ##
    ## @param InToolTipText  the text that should appear in the tool tip
  proc setToolTipText(inToolTipText: FText)

  proc setToolTip(inToolTip: TSharedPtr[IToolTip])
    ## Set the tool tip that should appear when this widget is hovered.
    ##
    ## @param InToolTip  the widget that should appear in the tool tip

  proc setCursor(inCursor: TAttribute[TOptional[EMouseCursor]])
    ## Set the cursor that should appear when this widget is hovered

  proc setDebugInfo(inType: cstring; inFile: cstring; onLine: int32)
    ## Used by Slate to set the runtime debug info about this widget.

  proc getMetaData[metaDataType](): TSharedPtr[metaDataType] {.noSideEffect.}
    ## Get the metadata of the type provided.

  proc getAllMetaData[metaDataType](): TArray[TSharedRef[metaDataType]] {.
      noSideEffect.}
    ## @return the first metadata of the type supplied that we encounter
    ##
    ## Get all metadata of the type provided.
    ## @return all the metadata found of the specified type.

  proc addMetadata[metaDataType](addMe: TSharedRef[metaDataType])
    ## Add metadata to this widget.
    ## @param AddMe the metadata to add to the widget.

# public:

  method toString(): FString {.noSideEffect.}
    ## Widget Inspector and debugging methods
    ## @return A String representation of the widget

  proc getTypeAsString(): FString {.noSideEffect.}
    ## @return A String of the widget's type

  proc getType(): FName {.noSideEffect.}
    ## @return The widget's type as an FName ID

  method getReadableLocation(): FString {.noSideEffect.}
    ## @return A String of the widget's code location in readable format "BaseFileName(LineNumber)"

  proc getCreatedInLocation(): FName {.noSideEffect.}
    ## @return An FName of the widget's code location (full path with number == line number of the file)

  method getTag(): FName {.noSideEffect.}
    ## @return The name this widget was tagged with

  method getForegroundColor(): FSlateColor {.noSideEffect.}
    ## @return the Foreground color that this widget sets; unset options if the widget does not set a foreground color

# protected:

  proc findChildGeometries(myGeometry: FGeometry;
                          widgetsToFind: TSet[TSharedRef[SWidget]]; outResult: var TMap[
      TSharedRef[SWidget], FArrangedWidget]): bool {.noSideEffect.}
    ## Find the geometry of a descendant widget. This method assumes that WidgetsToFind are a descendants of this widget.
    ## Note that not all widgets are guaranteed to be found; OutResult will contain null entries for missing widgets.
    ##
    ## @param MyGeometry      The geometry of this widget.
    ## @param WidgetsToFind   The widgets whose geometries we wish to discover.
    ## @param OutResult       A map of widget references to their respective geometries.
    ## @return True if all the WidgetGeometries were found. False otherwise.

  proc findChildGeometries_Helper(myGeometry: FGeometry;
                                widgetsToFind: TSet[TSharedRef[SWidget]]; outResult: var TMap[
      TSharedRef[SWidget], FArrangedWidget]) {.noSideEffect.}
    ## Actual implementation of FindChildGeometries.
    ##
    ## @param MyGeometry      The geometry of this widget.
    ## @param WidgetsToFind   The widgets whose geometries we wish to discover.
    ## @param OutResult       A map of widget references to their respective geometries.

  proc findChildGeometry(myGeometry: FGeometry; widgetToFind: TSharedRef[SWidget]): FGeometry {.
      noSideEffect.}
    ## Find the geometry of a descendant widget. This method assumes that WidgetToFind is a descendant of this widget.
    ##
    ## @param MyGeometry   The geometry of this widget.
    ## @param WidgetToFind The widget whose geometry we wish to discover.
    ## @return the geometry of WidgetToFind.

  proc findChildUnderMouse(children: FArrangedChildren; mouseEvent: FPointerEvent): int32
    ## @return The index of the child that the mouse is currently hovering

  proc findChildUnderPosition(children: FArrangedChildren;
                              arrangedSpacePosition: FVector2D): int32
    ## @return The index of the child that is under the specified position

  proc shouldBeEnabled(inParentEnabled: bool): bool {.noSideEffect.}
    ## Determines if this widget should be enabled.
    ##
    ## @param InParentEnabled	true if the parent of this widget is enabled
    ## @return true if the widget is enabled

  method getFocusBrush(): ptr FSlateBrush {.noSideEffect.}
    ## @return a brush to draw focus, nullptr if no focus drawing is desired

  method computeVolatility(): bool {.noSideEffect.}
    ## Recomputes the volatility of the widget.  If you have additional state you automatically want to make
    ## the widget volatile, you should sample that information here.

  proc accessWidgetVisibilityAttribute(widget: TSharedRef[SWidget]): var TAttribute[
      EVisibility]
    ## Protected static helper to allow widgets to access the visibility attribute of other widgets directly
    ##
    ## @param Widget The widget to get the visibility attribute of

# protected:

  proc cachePrepass(layoutCache: ptr ILayoutCache)
    ## Don't call this directly unless you're a layout cache, this is used to recursively set the layout cache on
    ## on invisible children that never get the opportunity to paint and receive the layout cache through the normal
    ## means.  That way if an invisible widget becomes visible, we still properly invalidate the hierarchy.

# protected:

  proc registerActiveTimer(tickPeriod: cfloat;
                           tickFunction: FWidgetActiveTimerDelegate): TSharedRef[
      FActiveTimerHandle]
    ## Registers an "active timer" delegate that will execute at some regular interval. TickFunction will not be called until the specified interval has elapsed once.
    ## A widget can register as many delegates as it needs. Be careful when registering to avoid duplicate active timers.
    ##
    ## An active timer can be UnRegistered in one of three ways:
    ##   1. Call UnRegisterActiveTimer using the active timer handle that is returned here.
    ##   2. Have your delegate return EActiveTimerReturnType::Stop.
    ##   3. Destroying the widget
    ##
    ## Active Timers
    ## --------------
    ## Slate may go to sleep when there is no user interaction for some time to save power.
    ## However, some UI elements may need to "drive" the UI even when the user is not providing any input
    ## (ie, animations, viewport rendering, async polling, etc). A widget notifies Slate of this by
    ## registering an "Active Timer" that is executed at a specified frequency to drive the UI.
    ## In this way, slate can go to sleep when there is no input and no active timer needs to fire.
    ## When any active timer needs to fire, all of Slate will do a Tick and Paint pass.
    ##
    ## @param Period The time period to wait between each execution of the timer. Pass zero to fire the timer once per frame.
    ##                      If an interval is missed, the delegate is NOT called more than once.
    ## @param TimerFunction The active timer delegate to call every Period seconds.
    ## @return An active timer handle that can be used to UnRegister later.

  proc unRegisterActiveTimer(activeTimerHandle: TSharedRef[FActiveTimerHandle])
    ## Unregisters an active timer handle. This is optional, as the delegate can UnRegister itself by returning EActiveTimerReturnType::Stop.

# protected:
#	DEBUG INFORMATION
# @todo Slate: Should compile out in final release builds?

  var typeOfWidget: FName

  var createdInLocation: FName
    ## Full file path (and line) in which this widget was created

  var tag: FName
    ## Tag for this widget

  var metaData: TArray[TSharedRef[ISlateMetaData]]
    ## Metadata associated with this widget

  var cursor: TAttribute[TOptional[EMouseCursor]]
    ## The cursor to show when the mouse is hovering over this widget.

  var enabledState: TAttribute[bool]
    ## Whether or not this widget is enabled

  var visibility: TAttribute[EVisibility]
    ## Is this widget visible, hidden or collapsed

  var renderTransform: TAttribute[TOptional[FSlateRenderTransform]]
    ## Render transform of this widget. TOptional<> to allow code to skip expensive overhead if there is no render transform applied.

  var renderTransformPivot: TAttribute[FVector2D]
    ## Render transform pivot of this widget (in normalized local space)

# protected:
  var bIsHovered: bool
    ## Is this widget hovered?

  var bCanTick: bool
    ## Can the widget ever be ticked.

  var bCanSupportFocus: bool
    ## Can the widget ever support keyboard focus

  var bCanHaveChildren: bool
    ## Can the widget ever support children?  This will be false on SLeafWidgets,
    ## rather than setting this directly, you should probably inherit from SLeafWidget.
