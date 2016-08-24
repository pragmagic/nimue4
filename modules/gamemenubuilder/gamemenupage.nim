declareBuiltinDelegate(FOnMenuGoBack, dkSimple, "GameMenuBuilder.h")
declareBuiltinDelegate(FOnMenuHidden, dkSimple, "GameMenuBuilder.h")
declareBuiltinDelegate(FOnMenuOpening, dkSimple, "GameMenuBuilder.h")

# Copyright 2016 Xored Software, Inc.

type
  EGameMenuItemType* {.importcpp: "EGameMenuItemType::Type", header: "GameMenuBuilder.h", pure, size: sizeof(cint).} = enum
    Root,
    Standard,
    MultiChoice,
    CustomWidget,

  FGameMenuPage* {.header: "GameMenuBuilder.h", importcpp, bycopy, inheritable.} = object
  SGameMenuItemWidget* {.header: "GameMenuBuilder.h", importcpp, bycopy, inheritable.} = object
  SWeakWidget* {.header: "GameMenuBuilder.h", importcpp, inheritable.} = object

declareBuiltinDelegate(FOnConfirmMenuItem, dkSimple, "GameMenuBuilder.h")
# multi-choice option changed, parameters are menu item itself and new multi-choice index


wclass(FGameMenuItem, header: "GameMenuBuilder.h", bycopy):
  var onConfirmMenuItem: FOnConfirmMenuItem
    ## delegate, which is executed by SSimpleMenuWidget if user confirms this menu item

  var menuItemType: EGameMenuItemType
    ## menu item type
  var text: FText
    ## menu item text
  var subMenu: TSharedPtr[FGameMenuPage]
    ## sub menu if present
  var widget: TSharedPtr[SGameMenuItemWidget]
    ## shared pointer to actual slate widget representing the menu item
  var customWidget: TSharedPtr[SGameMenuItemWidget]
    ## shared pointer to actual slate widget representing the custom menu item, ie whole options screen
  var multiChoice: TArray[FText]
    ## texts for multiple choice menu item (like INF AMMO ON/OFF or difficulty/resolution etc)
  var minMultiChoiceIndex: int32
    ## set to other value than -1 to limit the options range
  var maxMultiChoiceIndex: int32
    ## set to other value than -1 to limit the options range
  var selectedMultiChoice: int32
    ## selected multi-choice index for this menu item
  var bInactive: bool
    ## true if this item is active

  proc initFGameMenuItem(text: FText ): FGameMenuItem {.constructor.}
    ## constructor accepting menu item text

  proc initFGameMenuItem(inWidget: TSharedPtr[SGameMenuItemWidget]): FGameMenuItem
    ## custom widgets cannot contain sub menus, all functionality must be handled by custom widget itself

  proc initFGameMenuItem(inText: FText, inOptions: TArray[FText], inDefaultIndex: int32 =0)
    ## constructor for multi-choice item

  proc confirmPressed(): bool


declareBuiltinDelegate(FOnOptionChanged, dkSimple, "GameMenuBuilder.h",
                       item: TSharedPtr[FGameMenuItem], idx: int32)

wclass(FGameMenuItem, header: "GameMenuBuilder.h", notypedef):
  var onOptionChanged: FOnOptionChanged
    ## multi-choice option changed, parameters are menu item itself and new multi-choice index

proc createRootGameMenuItem*(): TSharedPtr[FGameMenuItem] {.
  importcpp: "FGameMenuItem::CreateRoot", header: "GameMenuBuilder.h".}
  ## create special root item

wclass(FGameMenuPage, header: "GameMenuBuilder.h", bycopy, notypedef):
  proc initialiseRootMenu(inPCOwner: ptr APlayerController, inStyleName: FString, inGameViewport: ptr UGameViewportClient): bool
    ## Initialize the menu page widget and set this menu as root.
    ## @param	InPCOwner		Player controller that owns this menu.
    ## @param	InStyleName		Name of the menu style to use.
    ## @param	InGameViewport	Gameviewport on which to place the menu.
    ## @returns true on success. (Will fail if viewport invalid)

  proc asShared(): TSharedPtr[FGameMenuPage]

  proc destroyRootMenu()

  proc numItems(): int32 {.noSideEffect.}
    ## Return the number of items in menu item list.

  proc getItem(index: int32): TSharedPtr[FGameMenuItem] {.noSideEffect.}
    ## Get the specified item in the menu item list. Will assert if the value is out of range.

  proc isValidMenuEntryIndex(index: int32): bool {.noSideEffect.}
    ## Is the supplied index with the valid range of menu items. Returns false if it is not.

  var pcOwner {.cppname: "PCOwner".}: TWeakObjectPtr[APlayerController]
    ## Weak pointer to Owning player controller.

  proc showRootMenu()
    ## Builds the menu widget and shows the menu.

  var selectedIndex: int32
    ## Current selection in this menu.

  var menuTitle: FText
    ## The menu title.

  proc addMenuItem(text: FText, inSubMenu = initTSharedPtr[FGameMenuPage]()): TSharedPtr[FGameMenuItem]
    ## Add a menu item.
    ##
    ## @param	Text		The string for the item (EG START GAME)
    ## @param	InSubMenu	Any submenu associated with the item
    ## @returns A shared reference to the created item

  proc lockControls(bLockState: bool)
    ## Lock/Unlock the menu and prevent user interaction.
    ##
    ## @param		bLockState	true to lock

  var rootMenuPageWidget: TSharedPtr[SGameMenuPageWidget]
    ## The widget that is the menu.

  proc menuGoBack()
    ## Executed when user want's to go back to previous menu.

  proc menuGoBackCancel()
    ## Called when user want's to CANCEL and go back to previous menu.

  proc menuHidden()
    ## Called when the menu has finished hiding.

  proc menuOpening()
    ## Called when the menu is about to be opened.

  proc hideMenu()
    ## Hide the menu.

  proc removeAllItems()
    ## Remove all the items from the item array.

macro addMenuItem*[T](menu: ptr FGameMenuPage, inText: FText, objPtr: T, callback: proc(t: T)): untyped =
  ## Add a menu item.
  ##
  ## @param	Text		Label of the menu item
  ## @param	InObj		Menu page object
  ## @param	InMethod	Method to call when selection changes.
  ## @returns  SharedRef to the MenuItem that was created.
  let sym = genIdent(callback)
  result = quote do:
    var `sym`: TSharedPtr[FGameMenuItem]
    {.emit: "`$#` = $#->AddMenuItem(`$#`, `$#`, & $#::$#);".format(
              astToStr(`sym`), expandObjReference(astToStr(`menu`)), astToStr(`inText`),
              astToStr(`objPtr`), type(`objPtr`).name.split(" ")[^1], astToStr(`callback`).capitalize()).}
    `sym`

macro addMenuItemWithOptions*[T](menu: ptr FGameMenuPage, text: FText, optionsList: TArray[FText],
                                 objPtr: T, callback: proc(t: T, item: TSharedPtr[FGameMenuItem], idx: int32)): untyped =
  ## Add a menu entry with a variable number of selectable options
  ##
  ## @param	Text		Label of the menu item
  ## @param	OptionsList	List of selectable items
  ## @param	InObj		Menu page object
  ## @param	InMethod	Method to call when selection changes.
  ## @returns  SharedRef to the MenuItem that was created.
  let sym = genIdent(callback)
  result = quote do:
    var `sym`: TSharedPtr[FGameMenuItem]
    {.emit: "`$#` = $#->AddMenuItemWithOptions(`$#`, `$#`, `$#`, & $#::$#);".format(
              astToStr(`sym`), expandObjReference(astToStr(`menu`)), astToStr(`text`), astToStr(`optionsList`),
              astToStr(`objPtr`), type(`objPtr`).name.split(" ")[^1], astToStr(`callback`).capitalize()).}
    `sym`

macro addCustomMenuItem*[T](menu: ptr FGameMenuPage, text: FText, customWidget: TSharedPtr[SGameMenuItemWidget], objPtr: T, callback: proc(t: T)): untyped =
  ## Add a custom menu entry
  ##
  ## @param	Text		Label of the menu item
  ## @param
  ## @param
  ## @param
  ## @returns  SharedRef to the MenuItem that was created.
  let sym = genIdent(callback)
  result = quote do:
    var `sym`: TSharedPtr[FGameMenuItem]
    {.emit: "`$#` = $#->AddCustomMenuItem(`$#`, `$#`, `$#`, & $#::$#);".format(
              astToStr(`sym`), expandObjReference(astToStr(`menu`)), astToStr(`text`), astToStr(`customWidget`),
              astToStr(`objPtr`), type(`objPtr`).name.split(" ")[^1], astToStr(`callback`).capitalize()).}
    `sym`

template setCancelHandler*[T](menu: ptr FGameMenuPage, objPtr: T, callback: proc(t: T)) =
  ## Add a handler for the menu being canceled.
  ##
  ## @param	InObj		Menu page object
  ## @param	InMethod	Method to call when selection changes.
  {.emit: "$#->SetCancelHandler(`$#`, & $#::$#);".format(
          expandObjReference(astToStr(menu)),
          astToStr(objPtr), type(objPtr).name.split(" ")[^1], astToStr(callback).capitalize()).}

template setOnHiddenHandler*[T](menu: ptr FGameMenuPage, objPtr: T, callback: proc(t: T)) =
  ## Add a handler for the menu being canceled.
  ##
  ## @param	InObj		Menu page object
  ## @param	InMethod	Method to call when menu has been hidden.
  {.emit: "$#->SetOnHiddenHandler(`$#`, & $#::$#);".format(
          expandObjReference(astToStr(menu)),
          astToStr(objPtr), type(objPtr).name.split(" ")[^1], astToStr(callback).capitalize()).}

template setAcceptHandler*[T](menu: ptr FGameMenuPage, objPtr: T, callback: proc(t: T)) =
  ## Add a handler for the menu being accepted.
  ##
  ## @param	InObj		Menu page object
  ## @param	InMethod	Method to call when selection changes.
  {.emit: "$#->SetAcceptHandler(`$#`, & $#::$#);".format(
          expandObjReference(astToStr(menu)),
          astToStr(objPtr), type(objPtr).name.split(" ")[^1], astToStr(callback).capitalize()).}

template setOnOpenHandler*[T](menu: ptr FGameMenuPage, objPtr: T, callback: proc(t: T)) =
  ## Add a handler for the menu being opened.
  ##
  ## @param	InObj		Menu page object
  ## @param	InMethod	Method to call when menu is about to open.
  {.emit: "$#->SetAcceptHandler(`$#`, & $#::$#);".format(
    expandObjReference(astToStr(menu)),
    astToStr(objPtr), type(objPtr).name.split(" ")[^1], astToStr(callback).capitalize()).}
