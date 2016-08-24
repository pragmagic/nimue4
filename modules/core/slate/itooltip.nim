# Copyright 2016 Xored Software, Inc.

wclass(IToolTip, header: "SlateCore.h"):
  ## Interface for tool tips.
  method asWidget(): TSharedRef[SWidget]
    ## Gets the widget that this tool tip represents.
    ##
    ## @return The tool tip widget.

  method getContentWidget(): TSharedRef[SWidget]
    ## Gets the tool tip's content widget.
    ##
    ## @return The content widget.

  method setContentWidget(inContentWidget: TSharedRef[SWidget])
    ## Sets the tool tip's content widget.
    ##
    ## @param InContentWidget The new content widget to set.

  method isEmpty(): bool
    ## Checks whether this tool tip has no content to display right now.
    ##
    ## @return true if the tool tip has no content to display, false otherwise.

  method isInteractive()
    ## Checks whether this tool tip can be made interactive by the user (by holding Ctrl).
    ##
    ## @return true if it is an interactive tool tip, false otherwise.

  method onOpening()
    ## Called when the tooltip widget is about to be requested for opening.

  method onClosed()
    ## Called when the tooltip widget is closed and the tooltip is no longer needed.
