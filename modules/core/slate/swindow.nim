# Copyright 2016 Xored Software, Inc.

# Notification that a window has been activated
declareBuiltinDelegate(FOnWindowActivated, dkSimple, "SlateCore.h")
declareBuiltinDelegate(FOnWindowActivatedEvent, dkMulticast, "SlateCore.h")

# Notification that a window has been deactivated
declareBuiltinDelegate(FOnWindowDeactivated, dkSimple, "SlateCore.h")
declareBuiltinDelegate(FOnWindowDeactivatedEvent, dkMulticast, "SlateCore.h")

# Notification that a window is about to be closed
declareBuiltinDelegate(FOnWindowClosed, dkSimple, "SlateCore.h", window: TSharedRef[SWindow])

# Notification that a window has been moved
declareBuiltinDelegate(FOnWindowMoved, dkSimple, "SlateCore.h", window: TSharedRef[SWindow])

# Override delegate for RequestDestroyWindow
declareBuiltinDelegate(FRequestDestroyWindowOverride, dkSimple, "SlateCore.h", window: TSharedRef[SWindow])

# Called when we need to switch game worlds for a window
declareBuiltinDelegate(FOnSwitchWorldHack, dkSimpleRetVal, "SlateCore.h", int32, a: int32)

type
  EAutoCenter* {.importcpp: "EAutoCenter::Type", header: "SlateCore.h", pure.} = enum
    ## Enum to describe how to auto-center an SWindow
    None,
      ## Don't auto-center the window
    PrimaryWorkArea,
      ## Auto-center the window on the primary work area
    PreferredWorkArea,
      ## Auto-center the window on the preferred work area, determined using GetPreferredWorkArea()
  ESizingRule* {.importcpp: "ESizingRule::Type", header: "SlateCore.h", pure.} = enum
    ## Enum to describe how windows are sized
    FixedSize,
      ## The windows size fixed and cannot be resized
    Autosized,
      ## The window size is computed from its content and cannot be resized by users
    UserSized,
      ## The window can be resized by users

wclass(FWindowTransparency, header: "SlateCore.h"):
  var value: EWindowTransparency
  proc initFWindowTransparency(inTransparency: EWindowTransparency): FWindowTransparency

wclass(FOverlayPopupLayer of FPopupLayer, header: "SlateCore.h"):
  ## Simple overlay layer to allow content to be laid out on a Window or similar widget.
  proc initFOverlayPopupLayer(initHostWidget: TSharedRef[SWidget], initPopupContent: TSharedRef[SWidget], initOverlay: TSharedPtr[SOverlay])

type
  FMorpher* {.importcpp: "SWindow::FMorpher", header: "SlateCore.h".} = object
    startingOpacity {.importcpp: "StartingOpacity".}: cfloat   ## Initial window opacity
    targetOpacity {.importcpp: "TargetOpacity".}: cfloat      ## Desired opacity of the window
    startingMorphShape {.importcpp: "StartingMorphShape".}: FSlateRect ## Initial size of the window (i.e. at the start of animation)
    targetMorphShape {.importcpp: "TargetMorphShape".}: FSlateRect ## Desired size of the window (i.e. at the end of the animation)
    sequence {.importcpp: "Sequence".}: FCurveSequence   ## Animation sequence to hold on to the Handle
    bIsActive: bool            ## True if this morph is currently active
    bIsAnimatingWindowSize: bool ## True if we're morphing size as well as position.  False if we're just morphing position

  SPopupLayer* {.importcpp, header: "SlateCore.h".} = object of SPanel

proc initFMorpher*(): FMorpher {.importcpp: "FMorpher(@)", header: "SlateCore.h", constructor, noSideEffect.}

wclass(FPopupLayerSlot of TSlotBase[FPopupLayerSlot], header: "SlateCore.h"):
  ## Popups, tooltips, drag and drop decorators all can be executed without creating a new window.
  ## This slot along with the SWindow::AddPopupLayerSlot() API enabled it.

  proc initFPopupLayerSlot(): FPopupLayerSlot {.constructor.}

  proc desktopPosition(inDesktopPosition: TAttribute[FVector2D]): var FPopupLayerSlot {.discardable.}
    ## Pixel position in desktop space
  proc widthOverride(inWidthOverride: TAttribute[float32]): var FPopupLayerSlot {.discardable.}
    ## Width override in pixels
  proc heightOverride(inHeightOverride: TAttribute[float32]): var FPopupLayerSlot {.discardable.}
    ## Width override in pixels

  proc scale(inScale: TAttribute[float32]): var FPopupLayerSlot {.discardable.}
    ## DPI scaling to be applied to the contents of this slot

  proc clampToWindow(inClamp_Attribute: TAttribute[bool]): var FPopupLayerSlot {.discardable.}
    ## Should this slot be kept within the parent window

  proc clampBuffer(inClampBuffer_Attribute: TAttribute[FVector2D]): var FPopupLayerSlot {.discardable.}
    ## If this slot is kept within the parent window, how far from the edges should we clamp it

  proc `[]`(inChildWidget: TSharedRef[SWidget]): var FPopupLayerSlot

wclass(SWindow of SCompoundWidget, header: "SlateCore.h", notypedef):
  proc getType(): EWindowType {.noSideEffect.}
    ## Grabs the window type
    ##
    ## @return The window's type

  proc getTitle(): FText {.noSideEffect.}
    ## Grabs the current window title
    ##
    ## @return The window's title

  proc setTitle(inTitle: FText)
    ## Sets the current window title
    ##
    ## @param InTitle	The new title of the window

  proc paintWindow(args: FPaintArgs; allottedGeometry: FGeometry;
                   myClippingRect: FSlateRect;
                   outDrawElements: var FSlateWindowElementList; layerId: int32;
                   inWidgetStyle: FWidgetStyle; bParentEnabled: bool): int32 {.noSideEffect.}
    ## Paint the window and all of its contents. Not the same as Paint().

  proc getTitleBarSize(): FOptionalSize {.noSideEffect.}
    ## Returns the size of the title bar as a Slate size parameter.  Does not take into account application scale!
    ##
    ## @return  Title bar size

  proc getInitialDesiredSizeInScreen(): FVector2D {.noSideEffect.}
    ##	@return The initially desired screen position of the slate window

  proc getInitialDesiredPositionInScreen(): FVector2D {.noSideEffect.}
    ##	@return The initially desired size of the slate window

  proc getWindowGeometryInScreen(): FGeometry {.noSideEffect.}
    ## Get the Geometry that describes this window. Windows in Slate are unique in that they know their own geometry.

  proc getWindowGeometryInWindow(): FGeometry {.noSideEffect.}
    ## @return The geometry of the window in window space (i.e. position and AbsolutePosition are 0)

  proc getLocalToScreenTransform(): FSlateLayoutTransform {.noSideEffect.}
    ## @return the transform from local space to screen space (desktop space).

  proc getLocalToWindowTransform(): FSlateLayoutTransform {.noSideEffect.}
    ## @return the transform from local space to window space, which is basically desktop space without the offset. Essentially contains the DPI scale.

  proc getPositionInScreen(): FVector2D {.noSideEffect.}
    ## @return The position of the window in screen space

  proc getSizeInScreen(): FVector2D {.noSideEffect.}
    ## @return the size of the window in screen pixels

  proc getNonMaximizedRectInScreen(): FSlateRect {.noSideEffect.}
    ## @return the rectangle of the window for its non-maximized state

  proc getRectInScreen(): FSlateRect {.noSideEffect.}
    ## @return Rectangle that this window occupies in screen space

  proc getClientRectInScreen(): FSlateRect {.noSideEffect.}
    ## @return Rectangle of the window's usable client area in screen space.

  proc getClientSizeInScreen(): FVector2D {.noSideEffect.}
    ## @return the size of the window's usable client area.

  proc getClippingRectangleInWindow(): FSlateRect {.noSideEffect.}
    ## @return a clipping rectangle that represents this window in Window Space (i.e. always starts at 0,0)

  proc getWindowBorderSize(bIncTitleBar: bool = false): FMargin {.noSideEffect.}
    ## Returns the margins used for the window border. This varies based on whether it's maximized or not.

  proc moveWindowTo(newPosition: FVector2D)
    ## Relocate the window to a screenspace position specified by NewPosition

  proc reshapeWindow(newPosition: FVector2D; newSize: FVector2D)
    ## Relocate the window to a screenspace position specified by NewPosition and resize it to NewSize
  proc reshapeWindow(inNewShape: FSlateRect)

  proc resize(newSize: FVector2D)
    ## Resize the window to be NewSize immediately

  proc getFullScreenInfo(): FSlateRect {.noSideEffect.}
    ## Returns the rectangle of the screen the window is associated with

  proc isMorphing(): bool {.noSideEffect.}
    ## @return Returns true if the window is currently morphing to a new position, shape and/or opacity

  proc isMorphingSize(): bool {.noSideEffect.}
    ## @return Returns true if the window is currently morphing and is morphing by size

  proc morphToPosition(sequence: FCurveSequence; targetOpacity: cfloat;
                       targetPosition: FVector2D)
    ## Animate the window to TargetOpacity and TargetPosition over a short period of time

  proc morphToShape(sequence: FCurveSequence; targetOpacity: cfloat;
                    targetShape: FSlateRect)
    ## Animate the window to TargetOpacity and TargetShape over a short period of time

  proc updateMorphTargetShape(targetShape: FSlateRect)
    ## Set a new morph shape and force the morph to run for at least one frame in order to reach that target

  proc updateMorphTargetPosition(targetPosition: FVector2D)
    ## Set a new morph position and force the morph to run for at least one frame in order to reach that target

  proc getMorphTargetPosition(): FVector2D {.noSideEffect.}
    ## @return Returns the currently set morph target position

  proc getMorphTargetShape(): FSlateRect {.noSideEffect.}
    ## @return Returns the currently set morph target shape

  proc flashWindow()
    ## Flashed the window, used for drawing attention to modal dialogs

  proc bringToFront(bForce: bool = false)
    ## Bring the window to the front
    ##
    ## @param bForce	Forces the window to the top of the Z order, even if that means stealing focus from other windows
    ##  					In general do not pass force in.  It can be useful for some window types, like game windows where not forcing it to the front
    ##  					would cause mouse capture and mouse lock to happen but without the window visible

  proc HACK_ForceToFront()
    ## @hack Force a window to front even if a different application is in front.

  proc setCachedScreenPosition(newPosition: FVector2D)
    ## Sets the actual screen position of the window. THIS SHOULD ONLY BE CALLED BY THE OS

  proc setCachedSize(newSize: FVector2D)
    ##	Sets the actual size of the window. THIS SHOULD ONLY BE CALLED BY THE OS
  proc getNativeWindow(): TSharedPtr[FGenericWindow] {.noSideEffect.}

  proc isDescendantOf(parentWindow: TSharedPtr[SWindow]): bool {.noSideEffect.}
    ## Returns whether or not this window is a descendant of the specfied parent window
    ##
    ## @param ParentWindow	The window to check
    ## @return true if the window is a child of ParentWindow, false otherwise.

  proc setNativeWindow(inNativeWindow: TSharedRef[FGenericWindow])
    ## Sets the native OS window associated with this SWindow
    ##
    ## @param InNativeWindow	The native window

  proc setContent(inContent: TSharedRef[SWidget])
    ## Sets the widget content for this window
    ##
    ## @param	InContent	The widget to use as content for this window

  proc getContent(): TSharedRef[SWidget] {.noSideEffect.}
    ## Gets the widget content for this window
    ##
    ## @return	The widget content for this window

  proc hasOverlay(): bool {.noSideEffect.}
    ## Check whether we have a full window overlay, used to draw content over the entire window.
    ##
    ## @return true if the window has an overlay

  proc addOverlaySlot(ZOrder: int32 = INDEX_NONE): var FOverlaySlot
    ## Adds content to draw on top of the entire window
    ##
    ## @param	InZOrder	Z-order to use for this widget
    ## @return The added overlay slot so that it can be configured and populated

  proc removeOverlaySlot(inContent: TSharedRef[SWidget])
    ## Removes a widget that is being drawn over the entire window
    ##
    ## @param	InContent	The widget to remove

  proc onVisualizePopup(popupContent: TSharedRef[SWidget]): TSharedPtr[FPopupLayer]
    ## Visualize a new pop-up if possible.  If it's not possible for this widget to host the pop-up
    ## content you'll get back an invalid pointer to the layer.  The returned FPopupLayer allows you
    ## to remove the pop-up when you're done with it
    ##
    ## @param PopupContent The widget to try and host overlaid on top of the widget.
    ##
    ## @return a valid FPopupLayer if this widget supported hosting it.  You can call Remove() on this to destroy the pop-up.

  proc addPopupLayerSlot(): var FPopupLayerSlot
    ## Return a new slot in the popup layer. Assumes that the window has a popup layer.

  proc removePopupLayerSlot(widgetToRemove: TSharedRef[SWidget])
    ## Counterpart to AddPopupLayerSlot

  proc setFullWindowOverlayContent(inContent: TSharedPtr[SWidget])
    ## Sets a widget to use as a full window overlay, or clears an existing widget if set.  When set, this widget will be drawn on top of all other window content.
    ##
    ## @param	InContent	The widget to use for full window overlay content, or nullptr for no overlay

  proc beginFullWindowOverlayTransition()
    ## Begins a transition from showing regular window content to overlay content
    ## During the transition we show both sets of content

  proc endFullWindowOverlayTransition()
    ## Ends a transition from showing regular window content to overlay content
    ## When this is called content occluded by the full window overlay(if there is one) will be physically hidden

  proc hasFullWindowOverlayContent(): bool {.noSideEffect.}
    ## Checks to see if there is content assigned as a full window overlay
    ##
    ## @return	True if there is an overlay widget assigned

  proc appearsInTaskbar(): bool {.noSideEffect.}
    ## @return should this window show up in the taskbar

  proc getOnWindowActivatedEvent(): var FOnWindowActivatedEvent
    ## Gets the multicast delegate executed when the window is deactivated

  proc getOnWindowDeactivatedEvent(): var FOnWindowDeactivatedEvent
    ## Gets the multicast delegate executed when the window is deactivated

  proc setOnWindowClosed(inDelegate: FOnWindowClosed)
    ## Sets the delegate to execute right before the window is closed

  proc setOnWindowMoved(inDelegate: FOnWindowMoved)
    ## Sets the delegate to execute right after the window has been moved

  proc setRequestDestroyWindowOverride(inDelegate: FRequestDestroyWindowOverride)
    ## Sets the delegate to override RequestDestroyWindow

  proc requestDestroyWindow()
    ## Request that this window be destroyed. The window is not destroyed immediately. Instead it is placed in a queue for destruction on next Tick

  proc destroyWindowImmediately()
    ## Warning: use Request Destroy Window whenever possible!  This method destroys the window immediately!

  proc notifyWindowBeingDestroyed()
    ## Calls the OnWindowClosed delegate when this window is about to be closed

  proc showWindow()
    ## Make the window visible

  proc hideWindow()
    ## Make the window invisible

  proc enableWindow(bEnable: bool)
    ## Enables or disables this window and all of its children
    ##
    ## @param bEnable	true to enable this window and its children false to diable this window and its children

  proc setWindowMode(windowMode: EWindowMode)
    ## Toggle window between window modes (fullscreen, windowed, etc)

  proc getWindowMode(): EWindowMode {.noSideEffect.}
    ## @return The current window mode (fullscreen, windowed, etc)

  proc isVisible(): bool {.noSideEffect.}
    ## @return true if the window is visible, false otherwise

  proc isWindowMaximized(): bool {.noSideEffect.}
    ## @return true if the window is maximized, false otherwise

  proc isWindowMinimized(): bool {.noSideEffect.}
    ## @return true of the window is minimized (iconic), false otherwise

  proc initialMaximize()
    ## Maximize the window if bInitiallyMaximized is set

  proc initialMinimize()
    ## Maximize the window if bInitiallyMinimized is set

  proc setOpacity(inOpacity: cfloat)
    ## Sets the opacity of this window
    ##
    ## @param	InOpacity	The new window opacity represented as a floating point scalar

  proc getOpacity(): cfloat {.noSideEffect.}
    ## @return the window's current opacity

  proc getTransparencySupport(): EWindowTransparency {.noSideEffect.}
    ## @return the level of transparency supported by this window

  proc toString(): FString {.noSideEffect.}
    ## @return A String representation of the widget

  proc setWidgetToFocusOnActivate(inWidget: TSharedPtr[SWidget])
    ## Sets a widget that should become focused when this window is next activated
    ##
    ## @param	InWidget	The widget to set focus to when this window is activated

  proc activateWhenFirstShown(): bool {.noSideEffect.}
    ## @return true if the window should be activated when first shown

  proc acceptsInput(): bool {.noSideEffect.}
    ## @return true if the window accepts input; false if the window is non-interactive

  proc isUserSized(): bool {.noSideEffect.}
    ## @return true if the user decides the size of the window

  proc isAutosized(): bool {.noSideEffect.}
    ## @return true if the window is sized by the windows content

  proc setSizingRule(inSizingRule: ESizingRule)
    ## Should this window automatically derive its size based on its content or be user-drive?

  proc isRegularWindow(): bool {.noSideEffect.}
    ## @return true if this is a vanilla window, or one being used for some special purpose: e.g. tooltip or menu

  proc isTopmostWindow(): bool {.noSideEffect.}
    ## @return true if the window should be on top of all other windows; false otherwise

  proc sizeWillChangeOften(): bool {.noSideEffect.}
    ## @return True if we expect the window size to change frequently. See description of bSizeWillChangeOften member variable.

  proc getExpectedMaxWidth(): int32 {.noSideEffect.}
    ## @return Returns the configured expected maximum width of the window, or INDEX_NONE if not specified.  Can be used to optimize performance for window size animation

  proc getExpectedMaxHeight(): int32 {.noSideEffect.}
    ## @return Returns the configured expected maximum height of the window, or INDEX_NONE if not specified.  Can be used to optimize performance for window size animation

  proc hasOSWindowBorder(): bool {.noSideEffect.}
    ## @return true if the window is using the os window border instead of a slate created one

  proc isScreenspaceMouseWithin(screenspaceMouseCoordinate: FVector2D): bool {.noSideEffect.}
    ## @return true if mouse coordinates is within this window

  proc hasSizingFrame(): bool {.noSideEffect.}
    ## @return true if this is a user-sized window with a thick edge

  proc hasCloseBox(): bool {.noSideEffect.}
    ## @return true if this window has a close button/box on the titlebar area

  proc hasMaximizeBox(): bool {.noSideEffect.}
    ## @return true if this window has a maximize button/box on the titlebar area

  proc hasMinimizeBox(): bool {.noSideEffect.}
    ## @return true if this window has a minimize button/box on the titlebar area

  proc setAsModalWindow()
    ## Set modal window related flags - called by Slate app code during FSlateApplication::AddModalWindow()
  proc isModalWindow(): bool

  proc setMirrorWindow(bSetMirrorWindow: bool)
    ## Set mirror window flag
  proc isMirrorWindow(): bool
  proc setTitleBar(inTitleBar: TSharedPtr[IWindowTitleBar])

# Events

  proc onCursorQuery(myGeometry: FGeometry; cursorEvent: FPointerEvent): FCursorReply {.noSideEffect.}

  proc onIsActiveChanged(activateEvent: FWindowActivateEvent): bool
    ## The system will call this method to notify the window that it has been places in the foreground or background.

# Windows functions

  proc maximize()
  proc restore()
  proc minimize()

  proc getCurrentWindowZone(localMousePosition: FVector2D): EWindowZone
    ## Gets the current Window Zone that mouse position is over.

  var moveResizeZone: EWindowZone
    ## Used to store the zone where the mouse down event occurred during move / drag

  var moveResizeStart: FVector2D

  var moveResizeRect: FSlateRect

  proc getCornerRadius(): int32
    ## @return Gets the radius of the corner rounding of the window.
  proc supportsKeyboardFocus(): bool {.noSideEffect.}

  proc isFocusedInitially(): bool {.noSideEffect.}
    ## @return true if this window will be focused when it is first shown

  proc getChildWindows(): var TArray[TSharedRef[SWindow]]
    ## @return the list of this window's child windows

  proc addChildWindow(childWindow: TSharedRef[SWindow])
    ## Add ChildWindow as this window's child

  proc getParentWindow(): TSharedPtr[SWindow] {.noSideEffect.}
    ## @return the parent of this window; Invalid shared pointer if this window is not a child

  proc getTopmostAncestor(): TSharedPtr[SWindow]
    ## Look up the parent chain until we find the top-level window that owns this window

  proc removeDescendantWindow(descendantToRemove: TSharedRef[SWindow]): bool
    ## Remove DescendantToRemove from this window's children or their children.

  proc setOnWorldSwitchHack(inOnWorldSwitchHack: var FOnSwitchWorldHack)
    ## Sets the delegate to call when switching worlds in before ticking,drawing, or sending messages to widgets in this window

  proc switchWorlds(worldId: int32): int32 {.noSideEffect.}
    ## Hack to switch worlds
    ##
    ## @param WorldId: User ID for a world that should be restored or -1 if no restore
    ## @param The ID of the world restore later

  proc hasActiveChildren(): bool {.noSideEffect.}
    ## Are any of our child windows active?

  proc setViewportSizeDrivenByWindow(bDrivenByWindow: bool)
    ## Sets whether or not the viewport size should be driven by the window's size.  If true, the two will be the same.  If false, an independent viewport size can be specified with SetIndependentViewportSize

  proc isViewportSizeDrivenByWindow(): bool {.noSideEffect.}
    ## Returns whether or not the viewport and window size should be linked together.  If false, the two can be independent in cases where it is needed (e.g. mirror mode window drawing)

  proc getViewportSize(): FVector2D {.noSideEffect.}
    ## Returns the viewport size, taking into consideration if the window size should drive the viewport size

  proc setIndependentViewportSize(vp: FVector2D)
    ## Sets the viewport size independently of the window size, if non-zero.
  proc setViewport(viewportRef: TSharedRef[ISlateViewport])
  proc getViewport(): TSharedPtr[ISlateViewport]

  proc getHittestGrid(): TSharedRef[FHittestGrid]
    ## Access the hittest acceleration data structure for this window.
    ## The grid is filled out every time the window is painted.
    ##
    ## @see FHittestGrid for more details.

  proc getSizeLimits(): FWindowSizeLimits {.noSideEffect.}
    ## Optional constraints on min and max sizes that this window can be.

# protected:
  proc getWindowTitleContentColor(): FSlateColor {.noSideEffect.}
    ## Get the desired color of titlebar items. These change during flashing.

  proc startMorph()
    ## Kick off a morph to whatever the target shape happens to be.

  proc getWindowBackground(): ptr FSlateBrush {.noSideEffect.}
    ## Get the brush used to draw the window background

  proc getWindowOutline(): ptr FSlateBrush {.noSideEffect.}
    ## Get the brush used to draw the window outline

  proc getWindowOutlineColor(): FSlateColor {.noSideEffect.}
    ## Get the color used to tint the window outline

  proc getWindowVisibility(): EVisibility {.noSideEffect.}
    ## Windows that are not hittestable should not show up in the hittest grid.

  var typ {.cppname: "Type".}: EWindowType
    ## Type of the window

  var title: TAttribute[FText]
    ## Title of the window, displayed in the title bar as well as potentially in the task bar (Windows platform)

  var bDragAnywhere: bool
    ## When true, grabbing anywhere on the window will allow it to be dragged.

  var opacity: cfloat
    ## Current opacity of the window

  var sizingRule: ESizingRule
    ## How to size the window

  var autoCenterRule: EAutoCenter
    ## How to auto center the window

  var transparencySupport: EWindowTransparency
    ## Transparency setting for this window

  var bCreateTitleBar: bool
    ## True if this window has a title bar

  var bIsPopupWindow: bool
    ## True if this is a pop up window

  var bIsTopmostWindow: bool
    ## True if this is a topmost window

  var bSizeWillChangeOften: bool
    ## True if we expect the size of this window to change often, such as if its animated, or if it recycled for tool-tips,
    ##  and we'd like to avoid costly GPU buffer resizes when that happens.  Enabling this may incur memory overhead or
    ##  other platform-specific side effects

  var bInitiallyMaximized: bool
    ## true if this window is maximized when its created

  var bInitiallyMinimized: bool
    ## true if this window is minimized when its created

  var bHasEverBeenShown: bool
    ## True if this window has been shown yet

  var bFocusWhenFirstShown: bool
    ## Focus this window immediately as it is shown

  var bActivateWhenFirstShown: bool
    ## Activate this window immediately as it is shown

  var bHasOSWindowBorder: bool
    ## True if this window displays the os window border instead of drawing one in slate

  var bVirtualWindow: bool
    ## True if this window is virtual and not directly rendered by slate application or the OS.

  var bHasCloseButton: bool
    ## True if this window displays an enabled close button on the toolbar area

  var bHasMinimizeButton: bool
    ## True if this window displays an enabled minimize button on the toolbar area

  var bHasMaximizeButton: bool
    ## True if this window displays an enabled maximize button on the toolbar area

  var bHasSizingFrame: bool
    ## True if this window displays thick edge that can be used to resize the window

  var bIsModalWindow: bool
    ## True if the window is modal

  var bIsMirrorWindow: bool
    ## True if the window is a mirror window for HMD content

  var initialDesiredScreenPosition: FVector2D
    ## Initial desired position of the window's content in screen space

  var initialDesiredSize: FVector2D
    ## Initial desired size of the window's content in screen space

  var screenPosition: FVector2D
    ## Position of the window's content in screen space

  var preFullscreenPosition: FVector2D
    ## The position of the window before entering fullscreen

  var size: FVector2D
    ## Size of the window's content area in screen space

  var viewportSize: FVector2D
    ## Size of the viewport. If (0,0) then it is equal to Size

  var viewport: TWeakPtr[ISlateViewport]
    ## Pointer to the viewport registered with this window if any

  var titleBarSize: cfloat
    ## Size of this window's title bar.  Can be zero.  Set at construction and should not be changed afterwards.

  ## Utility for animating the window size.

  var morpher: FMorpher

  var windowZone: EWindowZone
    ## Cached "zone" the cursor was over in the window the last time that someone called GetCurrentWindowZone()

  var titleArea: TSharedPtr[SWidget]

  var contentSlot: ptr FVerticalBoxSlot

  var widgetToFocusOnActivate: TWeakPtr[SWidget]
    ## Widget to transfer keyboard focus to when this window becomes active, if any.  This is used to
    ##  restore focus to a widget after a popup has been dismissed.

  var style: ptr FWindowStyle
    ## Style used to draw this window

  var windowBackground: ptr FSlateBrush

# protected:

  var sizeLimits: FWindowSizeLimits
    ## Min and Max values for Width and Height; all optional.

  var nativeWindow: TSharedPtr[FGenericWindow]
    ## The native window that is backing this Slate Window

  var hittestGrid: TSharedRef[FHittestGrid]
    ## Each window has its own hittest grid for accelerated widget picking.

  var onWindowActivated: FOnWindowActivated
    ## Invoked when the window has been activated.

  var windowActivatedEvent: FOnWindowActivatedEvent

  var onWindowDeactivated: FOnWindowDeactivated
    ## Invoked when the window has been deactivated.

  var windowDeactivatedEvent: FOnWindowDeactivatedEvent

  var onWindowClosed: FOnWindowClosed
    ## Invoked when the window is about to be closed.

  var onWindowMoved: FOnWindowMoved
    ## Invoked when the window is moved

  var requestDestroyWindowOverride: FRequestDestroyWindowOverride
    ## Invoked when the window is requested to be destroyed.

  var windowOverlay: TSharedPtr[SOverlay]
    ## Window overlay widget

  var popupLayer: TSharedPtr[SPopupLayer]
    ## This layer provides mechanism for tooltips, drag-drop
    ## decorators, and popups without creating a new window.

  var fullWindowOverlayWidget: TSharedPtr[SWidget]
    ## Full window overlay widget

  var parentWindowPtr: TWeakPtr[SWindow]
    ## When not null, this window will always appear on top of the parent and be closed when the parent is closed.

  var childWindows: TArray[TSharedRef[SWindow]]
    ## Child windows of this window

  var onWorldSwitchHack: FOnSwitchWorldHack
    ## World switch delegate

  var bShouldShowWindowContentDuringOverlay: bool
    ## Whether or not we should show content of the window which could be occluded by full screen window content.
    ## This is used to hide content when there is a full screen overlay occluding it

  var expectedMaxWidth: int32
    ## The expected maximum width of the window.  May be used for performance optimization when bSizeWillChangeOften is set.

  var expectedMaxHeight: int32
    ## The expected maximum height of the window.  May be used for performance optimization when bSizeWillChangeOften is set.

  var titleBar: TSharedPtr[IWindowTitleBar]
    ## The window title bar.

  var layoutBorder: FMargin
    ## The padding for between the edges of the window and it's content

  var userResizeBorder: FMargin
    ## The margin around the edges of the window that will be detected as places the user can grab to resize the window.

  proc constructWindowInternals()

proc makeToolTipWindow*(): TSharedRef[SWindow] {.importcpp: "SWindow::MakeTooltipWindow()", header: "SlateCore.h".}
  ## Make a tool tip window
  ## @return The new SWindow
proc makeCursorDecorator*(): TSharedRef[SWindow] {.importcpp: "SWindow::MakeCursorDecorator()", header: "SlateCore.h".}
  ## Make cursor decorator window
  ##
  ## @return The new SWindow
proc makeNotificationWindow*(): TSharedRef[SWindow] {.importcpp: "SWindow::MakeNotificationWindow()", header: "SlateCore.h".}
  ## Make a notification window
  ##
  ## @return The new SWindow
proc computeWindowSizeForContent*(contentSize: FVector2D): FVector2D {.importcpp: "SWindow::ComputeWindowSizeForContent(@)", header: "SlateCore.h".}
  ## @param ContentSize      The size of content that we want to accommodate
  ##
  ## @return The size of the window necessary to accommodate the given content */