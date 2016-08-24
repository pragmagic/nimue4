# Copyright 2016 Xored Software, Inc.

wclass(EVisibility, header: "SlateCore.h"):
  ## Is an entity visible?
  proc initEVisibility(): EVisibility {.constructor.}
    ## Default constructor.
    ##
    ## The default visibility is 'visible'.

  proc `==`(other: EVisibility): bool {.noSideEffect.}

  proc `!=`(other: EVisibility)

  proc areChildrenHitTestVisible(): bool {.noSideEffect.}

  proc isHitTestVisible(): bool {.noSideEffect.}

  proc isVisible(): bool {.noSideEffect.}

  proc toString(): FString {.noSideEffect.}

# Default widget visibility - visible and can interactive with the cursor
var VisibilityVisible* {.importcpp: "EVisibility::Visible", header: "SlateCore.h".}: EVisibility

# Not visible and takes up no space in the layout; can never be clicked on because it takes up no space.
var VisibilityCollapsed* {.importcpp: "EVisibility::Visible", header: "SlateCore.h".}: EVisibility

# Not visible, but occupies layout space. Not interactive for obvious reasons.
var VisibilityHidden* {.importcpp: "EVisibility::Hidden", header: "SlateCore.h".}: EVisibility

# Visible to the user, but only as art. The cursors hit tests will never see this widget.
var VisibilityHitTestInvisible* {.importcpp: "EVisibility::HitTestInvisible", header: "SlateCore.h".}: EVisibility

# Same as HitTestInvisible, but doesn't apply to child widgets.
var VisibilitySelfHitTestInvisible* {.importcpp: "EVisibility::SelfHitTestInvisible", header: "SlateCore.h".}: EVisibility

# Any visibility will do
var VisibilityAll* {.importcpp: "EVisibility::All", header: "SlateCore.h".}: EVisibility
