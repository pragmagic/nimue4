# Copyright 2016 Xored Software, Inc.

type
  EKeyboardType* {.importcpp, header: "SlateBasics.h".} = enum
    Keyboard_Default,
    Keyboard_Number,
    Keyboard_Web,
    Keyboard_Email,
    Keyboard_Password,
    Keyboard_AlphaNumeric,

  ESetTextType* {.importcpp, header: "SlateBasics.h", pure, size: sizeof(uint8).} = enum
    Changed,
    Commited

wclass(IVirtualKeyboardEntry, header: "SlateBasics.h"):
  method setTextFromVirtualKeyboard(inNewText: FText, setTextType: ESetTextType, commitType: ETextCommitType)
    ## Sets the text to that entered by the virtual keyboard
    ##
    ## @param  InNewText  The new text
    ## @param SetTextType Set weather we want to send a TextChanged event after or a TextCommitted event
    ## @param CommitType If we are sending a TextCommitted event, what commit type is it

  method getText(): FText {.noSideEffect.}
    ## Returns the text.
    ##
    ## @return  Text

  method getHintText(): FText {.noSideEffect.}
    ## Returns the hint text.
    ##
    ## @return  HintText

  method getVirtualKeyboardType(): EKeyboardType {.noSideEffect.}
    ## Returns the virtual keyboard type.
    ##
    ## @return  VirtualKeyboardType

  method isMultilineEntry(): bool {.noSideEffect.}
    ## Returns whether the entry is multi-line
    ##
    ## @return Whether the entry is multi-line
