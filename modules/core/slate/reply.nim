# Copyright 2016 Xored Software, Inc.

wclass(FReply of TReplyBase[FReply], header: "SlateCore.h"):
  ## A Reply is something that a Slate event returns to the system to notify it about certain aspect of how an event was handled.
  ## For example, a widget may handle an OnMouseDown event by asking the system to give mouse capture to a specific Widget.
  ## To do this, return FReply::CaptureMouse( NewMouseCapture ).

  proc captureMouse(inMouseCaptor: TSharedRef[SWidget]): var FReply {.discardable.}
    ## An event should return a FReply::Handled().CaptureMouse( SomeWidget ) as a means of asking the system to forward all mouse events to SomeWidget

  proc useHighPrecisionMouseMovement(inMouseCaptor: TSharedRef[SWidget]): var FReply {.discardable.}
    ## Enables the use of high precision (raw input) mouse movement, for more accurate mouse movement without mouse ballistics
    ## NOTE: This implies mouse capture and hidden mouse movement.  Releasing mouse capture deactivates this mode.

  proc setMousePos(newMousePos: FIntPoint): var FReply {.discardable.}
    ## An even should return FReply::Handled().SetMousePos to ask Slate to move the mouse cursor to a different location

  proc setUserFocus(giveMeFocus: TSharedRef[SWidget];
                  reasonFocusIsChanging: EFocusCause = EFocusCause.SetDirectly;
                  bInAllUsers: bool = false): var FReply {.discardable.}
    ## An event should return FReply::Handled().SetUserFocus( SomeWidget ) as a means of asking the system to set users focus to the provided widget

  proc clearUserFocus(bInAllUsers: bool = false): var FReply {.discardable.}
    ## An event should return a FReply::Handled().ClearUserFocus() to ask the system to clear user focus

  proc clearUserFocus(reasonFocusIsChanging: EFocusCause; bInAllUsers: bool = false): var FReply {.discardable.}
    ## An event should return a FReply::Handled().ClearUserFocus() to ask the system to clear user focus

  proc setNavigation(inNavigationType: EUINavigation): var FReply {.discardable.}
    ## An event should return FReply::Handled().SetNavigation( NavigationType ) as a means of asking the system to attempt a navigation

  proc lockMouseToWidget(inWidget: TSharedRef[SWidget]): var FReply {.discardable.}
    ## An event should return FReply::Handled().LockMouseToWidget( SomeWidget ) as a means of asking the system to
    ## Lock the mouse so it cannot move out of the bounds of the widget.

  proc releaseMouseLock(): var FReply {.discardable.}
    ## An event should return a FReply::Handled().ReleaseMouseLock() to ask the system to release mouse lock on a widget

  proc releaseMouseCapture(): var FReply {.discardable.}
    ## An event should return a FReply::Handled().ReleaseMouse() to ask the system to release mouse capture
    ## NOTE: Deactivates high precision mouse movement if activated.

  proc detectDrag(detectDragInMe: TSharedRef[SWidget]; mouseButton: FKey): var FReply {.discardable.}
    ## Ask Slate to detect if a user started dragging in this widget.
    ## If a drag is detected, Slate will send an OnDragDetected event.
    ## #
    ## @param DetectDragInMe  Detect dragging in this widget
    ## @param MouseButton     This button should be pressed to detect the drag

  proc beginDragDrop(inDragDropContent: TSharedRef[FDragDropOperation]): var FReply {.discardable.}
    ## An event should return FReply::Handled().BeginDragDrop( Content ) to initiate a drag and drop operation.
    ## #
    ## @param InDragDropContent  The content that is being dragged. This could be a widget, or some arbitrary data
    ## #
    ## @return reference back to the FReply so that this call can be chained.

  proc endDragDrop(): var FReply {.discardable.}
    ## An event should return FReply::Handled().EndDragDrop() to request that the current drag/drop operation be terminated.

  proc preventThrottling(): var FReply {.discardable.}
    ## Ensures throttling for Slate UI responsiveness is not done on mouse down

  proc shouldReleaseMouse(): bool {.noSideEffect.}
    ## True if this reply indicated that we should release mouse capture as a result of the event being handled

  proc shouldSetUserFocus(): bool {.noSideEffect.}
    ## true if this reply indicated that we should set focus as a result of the event being handled

  proc shouldReleaseUserFocus(): bool {.noSideEffect.}
    ## true if this reply indicated that we should release focus as a result of the event being handled

  proc affectsAllUsers(): bool {.noSideEffect.}
    ## If the event replied with a request to change the user focus whether it should do it for all users or just the current UserIndex

  proc shouldUseHighPrecisionMouse(): bool {.noSideEffect.}
    ## True if this reply indicated that we should use high precision mouse movement

  proc shouldReleaseMouseLock(): bool {.noSideEffect.}
    ## True if the reply indicated that we should release mouse lock

  proc shouldThrottle(): bool {.noSideEffect.}
    ## Whether or not we should throttle on mouse down

  proc getMouseLockWidget(): var TSharedPtr[SWidget] {.noSideEffect.}
    ## Returns the widget that the mouse should be locked to (if any)

  proc getUserFocusRecepient(): var TSharedPtr[SWidget] {.noSideEffect.}
    ## When not nullptr, user focus has been requested to be set on the FocusRecipient.

  proc getFocusCause(): EFocusCause {.noSideEffect.}
    ## Get the reason that a focus change is being requested.

  proc getMouseCaptor(): var TSharedPtr[SWidget] {.noSideEffect.}
    ## If the event replied with a request to capture the mouse, this returns the desired mouse captor. Otherwise returns an invalid pointer.

  proc getNavigationType(): EUINavigation {.noSideEffect.}
    ## Get the navigation type (Invalid if no navigation is requested).

  proc getDragDropContent(): var TSharedPtr[FDragDropOperation] {.noSideEffect.}
    ## @return the Content that we should use for the Drag and Drop operation; Invalid SharedPtr if a drag and drop operation is not requested

  proc shouldEndDragDrop(): bool {.noSideEffect.}
    ## @return true if the user has asked us to terminate the ongoing drag/drop operation

  proc getDetectDragRequest(): var TSharedPtr[SWidget] {.noSideEffect.}
    ## @return a widget for which to detect a drag; Invalid SharedPtr if no drag detection requested

  proc getDetectDragRequestButton(): FKey {.noSideEffect.}
    ## @return the mouse button for which we are detecting a drag

  proc getRequestedMousePos(): var TOptional[FIntPoint] {.noSideEffect.}
    ## @return The coordinates of the requested mouse position

proc handledFReply(): FReply {.importcpp: "FReply::Handled()", header: "SlateCore.h", noSideEffect.}
  ## An event should return a handledFReply() to let the system know that an event was handled.

proc unhandledFReply(): FReply {.importcpp: "FReply::Unhandled()", header: "SlateCore.h", noSideEffect.}
  ## An event should return a unhandledFReply() to let the system know that an event was unhandled.
