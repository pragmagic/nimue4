# Copyright 2016 Xored Software, Inc.

type
  ECastCheckedType* {.header: "UObject/UObject.h", importcpp: "ECastCheckedType::Type", nodecl, pure.} = enum
    NullAllowed,
    NullChecked

  EResourceSizeMode* {.header: "UObject/UObject.h", importcpp: "EResourceSizeMode::Type", nodecl, pure.} = enum
    ## Passed to GetResourceSize() to indicate which resource size should be returned.
    Exclusive, ## Only exclusive resource size
    Inclusive  ## Resource size of the object and all of its references

  EObjectFlags* {.size: sizeof(cint), importcpp: "EObjectFlags", header: "UObject/ObjectBase.h".} = enum
    ## Flags describing an object instance
    RF_NoFlags = 0x00000000, ## No flags, used to avoid a cast

    # This first group of flags mostly has to do with what kind of object it is. Other than transient, these are the persistent object flags.
    # The garbage collector also tends to look at these.
    RF_Public = 0x00000001,     ## Object is visible outside its package.
    RF_Standalone = 0x00000002, ## Keep object around for editing even if unreferenced.
    RF_Native = 0x00000004,     ## Native (UClass only).
    RF_Transactional = 0x00000008, ## Object is transactional.
    RF_ClassDefaultObject = 0x00000010, ## This object is its class's default object
    RF_ArchetypeObject = 0x00000020, ## This object is a template for another object - treat like a class default object
    RF_Transient = 0x00000040,  ## Don't save object.

    # This group of flags is primarily concerned with garbage collection.
    RF_RootSet = 0x00000080,    ## Object will not be garbage collected, even if unreferenced.
    RF_Unreachable = 0x00000100, ## Object is not reachable on the object graph.
    RF_TagGarbageTemp = 0x00000200, ## This is a temp user flag for various utilities that need to use the garbage collector. The garbage collector itself does not interpret it.

    # The group of flags tracks the stages of the lifetime of a uobject
    RF_NeedLoad = 0x00000400,   ## During load, indicates object needs loading.
    RF_AsyncLoading = 0x00000800, ## Object is being asynchronously loaded.
    RF_NeedPostLoad = 0x00001000, ## Object needs to be postloaded.
    RF_NeedPostLoadSubobjects = 0x00002000, ## During load, indicates that the object still needs to instance subobjects and fixup serialized component references
    RF_PendingKill = 0x00004000, ## Objects that are pending destruction (invalid for gameplay but valid objects)
    RF_BeginDestroyed = 0x00008000, ## BeginDestroy has been called on the object.
    RF_FinishDestroyed = 0x00010000, ## FinishDestroy has been called on the object.

    # Misc. Flags
    RF_BeingRegenerated = 0x00020000, ## Flagged on UObjects that are used to create UClasses (e.g. Blueprints) while they are regenerating their UClass on load (See FLinkerLoad::CreateExport())
    RF_DefaultSubObject = 0x00040000, ## Flagged on subobjects that are defaults
    RF_WasLoaded = 0x00080000,  ## Flagged on UObjects that were loaded
    RF_TextExportTransient = 0x00100000, ## Do not export object to text form (e.g. copy/paste). Generally used for sub-objects that can be regenerated from data in their parent object.
    RF_LoadCompleted = 0x00200000, ## Object has been completely serialized by linkerload at least once. DO NOT USE THIS FLAG, It should be replaced with RF_WasLoaded.
    RF_InheritableComponentTemplate = 0x00400000, ## Archetype of the object can be in its super class
    RF_Async = 0x00800000,      ## Object exists only on a different thread than the game thread.
    RF_StrongRefOnFrame = 0x01000000, ## References to this object from persistent function frame are handled as strong ones.
    RF_NoStrongReference = 0x02000000, ## The object is not referenced by any strong reference. The flag is used by GC.
    RF_AssetExport = 0x04000000 ## Object is the main asset in its package, used only by the linker

  ELoadConfigPropagationFlags* {.size: sizeof(cint),
                                 importcpp: "UE4::ELoadConfigPropagationFlags",
                                 header: "UObject/ObjectBase.h".} = enum
    LCPF_None = 0x0,
    LCPF_ReadParentSections = 0x1,
      ## Indicates that the object should read ini values from each section up its class's hierarchy chain;
      ## Useful when calling LoadConfig on an object after it has already been initialized against its archetype

    LCPF_PropagateToChildDefaultObjects = 0x2,
      ## Indicates that LoadConfig() should be also be called on the class default objects
      ## for all children of the original class.

    LCPF_PropagateToInstances = 0x4,
      ## Indicates that LoadConfig() should be called on all instances of the original class.

    LCPF_ReloadingConfigData = 0x8,
      ## Indicates that this object is reloading its config data

  ERenameFlags = uint32

  FObjectInstancingGraph* {.header: "UObject/Class.h", importcpp.} = object

converter toUInt32(flags: ELoadConfigPropagationFlags): uint32 =
  result = ord(flags)

const REN_None = 0x0000
const REN_ForceNoResetLoaders = 0x0001
  ## Rename won't call ResetLoaders - most likely you should never specify this option (unless you are renaming a UPackage possibly)
const REN_Test = 0x0002
  ## Just test to make sure that the rename is guaranteed to succeed if an non test rename immediately follows
const REN_DoNotDirty = 0x0004
  ## Indicates that the object (and new outer) should not be dirtied.
const REN_DontCreateRedirectors = 0x0010
  ## Don't create an object redirector, even if the class is marked RF_Public
const REN_NonTransactional = 0x0020
  ## Don't call Modify() on the objects, so they won't be stored in the transaction buffer
const REN_ForceGlobalUnique = 0x0040
  ## Force unique names across all packages not just while the scope of the new outer
const REN_SkipGeneratedClasses = 0x0080
  ## Prevent renaming of any child generated classes and CDO's in blueprints

wclass(FObjectInitializer, header: "UObject/UObjectGlobals.h", bycopy):
  proc initFObjectInitializer(): FObjectInitializer {.constructor.}
    ## Default Constructor, used when you are using the C++ "new" syntax. UObject::UObject will set the object pointer

  proc initFObjectInitializer(inObj: ptr UObject; inObjectArchetype: ptr UObject;
                              bInCopyTransientsFromClassDefaults: bool;
                              bInShouldIntializeProps: bool;
                              inInstanceGraph: ptr FObjectInstancingGraph = nil): FObjectInitializer {.constructor.}
    ## Constructor
    ## @param	InObj object to initialize, from static allocate object, after construction
    ## @param	InObjectArchetype object to initialize properties from
    ## @param	bInCopyTransientsFromClassDefaults - if true, copy transient from the class defaults instead of the pass in archetype ptr (often these are the same)
    ## @param	bInShouldIntializeProps false is a special case for changing base classes in UCCMake
    ## @param	InInstanceGraph passed instance graph

  proc getArchetype(): ptr UObject {.noSideEffect.}
    ## Return the archetype that this object will copy properties from later

  proc getObj(): ptr UObject {.noSideEffect.}
    ## Return the object that is being constructed

  proc getClass(): ptr UClass {.noSideEffect.}
    ## Return the class of the object that is being constructed

  proc createDefaultSubobject[TReturnType](outer: ptr UObject; subobjectName: FName;
                                           bTransient: bool = false): ptr TReturnType {.
      noSideEffect.}
    ## Create a component or subobject
    ## @param	TReturnType					class of return type, all overrides must be of this type
    ## @param	Outer						outer to construct the subobject in
    ## @param	SubobjectName				name of the new component
    ## @param bTransient		true if the component is being assigned to a transient property

  proc createOptionalDefaultSubobject[TReturnType](outer: ptr UObject;
      subobjectName: FName; bTransient: bool = false): ptr TReturnType {.noSideEffect.}
    ## Create optional component or subobject. Optional subobjects may not get created
    ## when a derived class specified DoNotCreateDefaultSubobject with the subobject's name.
    ## @param	TReturnType					class of return type, all overrides must be of this type
    ## @param	Outer						outer to construct the subobject in
    ## @param	SubobjectName				name of the new component
    ## @param bTransient		true if the component is being assigned to a transient property

  proc createAbstractDefaultSubobject[TReturnType](outer: ptr UObject;
      subobjectName: FName; bTransient: bool = false): ptr TReturnType {.noSideEffect.}
    ## Create optional component or subobject. Optional subobjects may not get created
    ## when a derived class specified DoNotCreateDefaultSubobject with the subobject's name.
    ## @param	TReturnType					class of return type, all overrides must be of this type
    ## @param	Outer						outer to construct the subobject in
    ## @param	SubobjectName				name of the new component
    ## @param bTransient		true if the component is being assigned to a transient property

  proc createEditorOnlyDefaultSubobject[TReturnType](outer: ptr UObject;
      subobjectName: FName; bTransient: bool = false): ptr TReturnType {.noSideEffect.}
    ## Create a component or subobject only to be used with the editor.
    ## @param	TReturnType					class of return type, all overrides must be of this type
    ## @param	Outer						outer to construct the subobject in
    ## @param	SubobjectName				name of the new component
    ## @param	bTransient					true if the component is being assigned to a transient property

  proc createEditorOnlyDefaultSubobject(outer: ptr UObject; subobjectName: FName;
                                      returnType: ptr UClass;
                                      bTransient: bool = false): ptr UObject {.
      noSideEffect.}
    ## Create a component or subobject only to be used with the editor.
    ## @param	TReturnType					class of return type, all overrides must be of this type
    ## @param	Outer						outer to construct the subobject in
    ## @param	ReturnType					type of the new component
    ## @param	SubobjectName				name of the new component
    ## @param	bTransient					true if the component is being assigned to a transient property

  proc createDefaultSubobject(outer: ptr UObject; subobjectFName: FName;
                            returnType: ptr UClass;
                            classToCreateByDefault: ptr UClass; bIsRequired: bool;
                            bAbstract: bool; bIsTransient: bool): ptr UObject {.
      noSideEffect.}
    ## Create a component or subobject
    ## @param	TReturnType					class of return type, all overrides must be of this type
    ## @param	TClassToConstructByDefault	if the derived class has not overridden, create a component of this type (default is TReturnType)
    ## @param	Outer						outer to construct the subobject in
    ## @param	SubobjectName				name of the new component
    ## @param bIsRequired			true if the component is required and will always be created even if DoNotCreateDefaultSubobject was sepcified.
    ## @param bIsTransient		true if the component is being assigned to a transient property

  proc doNotCreateDefaultSubobject(subobjectName: FName): var FObjectInitializer {.
      noSideEffect.}
    ## Indicates that a base class should not create a component
    ## @param	SubobjectName	name of the new component or subobject to not create

  proc doNotCreateDefaultSubobject(subobjectName: wstring): var FObjectInitializer {.
      noSideEffect.}
    ## Indicates that a base class should not create a component
    ## @param	ComponentName	name of the new component or subobject to not create

  proc isLegalOverride(inComponentName: FName; derivedComponentClass: ptr UClass;
                       baseComponentClass: ptr UClass): bool {.noSideEffect.}
    ## Internal use only, checks if the override is legal and if not deal with error messages

  proc assertIfInConstructor(outer: ptr UObject; errorMessage: wstring)
    ## Asserts with the specified message if code is executed inside UObject constructor
  proc finalizeSubobjectClassInitialization()

proc getObjectInitializer*(): var FObjectInitializer {.importcpp: "FObjectInitializer::Get", header: "UObject/UObjectGlobals.h".}
  ## Gets ObjectInitializer for the currently constructed object. Can only be used inside of a constructor of UObject-derived class.

wclass(UObjectBase, header: "UObject/UObjectBase.h", notypedef):
  proc getUniqueID(): uint32 {.noSideEffect.}
    ## Returns the unique ID of the object...these are reused so it is only unique while the object is alive.
    ## Useful as a tag.
  proc getClass(): ptr UClass {.noSideEffect.}
  proc getOuter(): ptr UObject {.noSideEffect.}
  proc getFName(): FName {.noSideEffect.}

wclass(UObjectBaseUtility of UObjectBase, header: "UObject/UObjectBaseUtility.h", notypedef):
  proc isPendingKill(): bool {.noSideEffect.}
  proc addToRoot()
    ## Add an object to the root set. This prevents the object and all
    ## its descendants from being deleted during garbage collection.

proc createDefaultSubobject*[T](obj: ptr UObject, subobjectName: FName; bTransient: bool = false): ptr T {.importcpp: "#.CreateDefaultSubobject<'*0>(@)", nodecl.}
proc createDefaultSubobject*[T](obj: ptr UObject, subobjectName: wstring; bTransient: bool = false): ptr T {.importcpp: "#.CreateDefaultSubobject<'*0>(@)", nodecl.}

proc createOptionalDefaultSubobject*[T](obj: ptr UObject, subobjectName: FName; bTransient: bool = false): ptr T {.importcpp: "#.CreateOptionalDefaultSubobject<'*0>(@)", nodecl.}
proc createOptionalDefaultSubobject*[T](obj: ptr UObject, subobjectName: wstring; bTransient: bool = false): ptr T {.importcpp: "#.CreateOptionalDefaultSubobject<'*0>(@)", nodecl.}

proc createAbstractDefaultSubobject*[T](obj: ptr UObject, subobjectName: FName; bTransient: bool = false): ptr T {.importcpp: "#.CreateAbstractDefaultSubobject<'*0>(@)", nodecl.}
proc createAbstractDefaultSubobject*[T](obj: ptr UObject, subobjectName: wstring; bTransient: bool = false): ptr T {.importcpp: "#.CreateAbstractDefaultSubobject<'*0>(@)", nodecl.}

wclass(UObject of UObjectBaseUtility, header: "UObject/UObject.h", notypedef):
  method postInitProperties()
    ## Called after the C++ constructor and after the properties have been initialized, including those loaded from config.
    ## mainly this is to emulate some behavior of when the constructor was called after the properties were intialized.

  method preSaveRoot(filename: wstring; additionalPackagesToCook: var TArray[FString]): bool
    ## Called from within SavePackage on the passed in base/ root. The return value of this function will be passed to
    ## PostSaveRoot. This is used to allow objects used as base to perform required actions before saving and cleanup
    ## afterwards.
    ## `filename`: Name of the file being saved to (includes path)
    ## `additionalPackagesToCook` [out]: Array of other packages the Root wants to make sure are cooked when this is cooked
    ##
    ## Returns whether PostSaveRoot needs to perform internal cleanup

  method postSaveRoot(bCleanupIsRequired: bool)
    ## Called from within SavePackage on the passed in base/ root. This function is being called after the package
    ## has been saved and can perform cleanup.
    ##
    ## `bCleanupIsRequired`: whether PreSaveRoot dirtied state that needs to be cleaned up

  method preSave()
    ## Presave function. Gets called once before an object gets serialized for saving. This function is necessary
    ## for save time computation as Serialize gets called three times per object from within SavePackage.
    ##
    ## **Warning:** Objects created from within PreSave will NOT have PreSave called on them!!!

  method modify(bAlwaysMarkDirty: bool = true): bool
    ## Note that the object will be modified.  If we are currently recording into the
    ## transaction buffer (undo/redo), save a copy of this object into the buffer and
    ## marks the package as needing to be saved.
    ##
    ## `bAlwaysMarkDirty`:  if true, marks the package dirty even if we aren't
    ##                      currently recording an active undo/redo transaction
    ## Returns true if the object was saved to the transaction buffer

  method loadedFromAnotherClass(oldClassName: FName) # WI
    ## Called when the object was loaded from another class via active class redirects.

  method postLoad()
    ## Do any object-specific cleanup required immediately after loading an object,
    ## and immediately after any undo/redo.

  # AWARE
  # method postLoadSubobjects(outerInstanceGraph: ptr FObjectInstancingGraph)
  #   ## Instances components for objects being loaded from disk, if necessary.  Ensures that component references
  #   ## between nested components are fixed up correctly.
  #   ##
  #   ## `outerInstanceGraph`: when calling this method on subobjects, specifies the instancing graph which contains all instanced
  #   ##                subobjects and components for a subobject root.

  method beginDestroy()
    ## Called before destroying the object.  This is called immediately upon deciding to destroy the object, to allow the object to begin an
    ## asynchronous cleanup process.

  method isReadyForFinishDestroy(): bool
    ## Called to check if the object is ready for FinishDestroy.  This is called after BeginDestroy to check the completion of the
    ## potentially asynchronous object cleanup.
    ## Returns *true* if the object's asynchronous cleanup has completed and it is ready for FinishDestroy to be called.

  method postLinkerChange() # WITH_EDITOR
    ## Called in response to the linker changing, this can only happen in the editor

  method finishDestroy()
    ## Called to finish destroying the object.  After UObject.FinishDestroy is called, the object's memory should no longer be accessed.
    ##
    ## Note: because properties are destroyed here, Super::FinishDestroy() should always be called at the end of your child class's
    ## FinishDestroy() method, rather than at the beginning.

  method serialize(ar: var FArchive)
    ## UObject serializer.

  method shutdownAfterError()

  method postInterpChange(propertyThatChanged: ptr UProperty)
    ## This is called when property is modified by InterpPropertyTracks

  method preEditChange(propertyAboutToChange: ptr UProperty) # WITH_EDITOR
    ## This is called when property is about to be modified by InterpPropertyTracks

  # AWARE
  # method preEditChange(propertyAboutToChange: var FEditPropertyChain) # WITH_EDITOR
  #   ## This alternate version of PreEditChange is called when properties inside structs are modified.  The property that was actually modified
  #   ## is located at the tail of the list.  The head of the list of the UStructProperty member variable that contains the property that was modified.

  method canEditChange(inProperty: ptr UProperty) # WITH_EDITOR
    ## Called by the editor to query whether a property of this object is allowed to be modified.
    ## The property editor uses this to disable controls for properties that should not be changed.
    ## When overriding this function you should always call the parent implementation first.
    ##
    ## Returns *true* if the property can be modified in the editor, otherwise false

  proc postEditChange() # WITH_EDITOR
    ##
    ## Intentionally non-virtual as it calls the FPropertyChangedEvent version
    ##

  # AWARE
  # method postEditChangeProperty(propertyChangedEvent: var FPropertyChangedEvent) # WITH_EDITOR
  #   ## Called when a property on this object has been modified externally

  # method postEditChangeChainProperty(propertyChangedEvent: var FPropertyChangedChainEvent) # WITH_EDITOR
  #   ## This alternate version of PostEditChange is called when properties inside structs are modified.  The property that was actually modified
  #   ## is located at the tail of the list.  The head of the list of the UStructProperty member variable that contains the property that was modified.

  method preEditUndo() # WITH_EDITOR
    ## Called before applying a transaction to the object.  Default implementation simply calls PreEditChange.

  method postEditUndo() # WITH_EDITOR
    ## Called after applying a transaction to the object.  Default implementation simply calls PostEditChange.

  # AWARE: uncomment when the depss are interfaced
  # method GetTransactionAnnotation(): TSharedPtr[ITransactionObjectAnnotation] {.noSideEffect.} # WITH_EDITOR
  #  ## Gathers external data required for applying an undo transaction
  # method PostEditUndo(TransactionAnnotation: TSharedPtr[ITransactionObjectAnnotation]) # WITH_EDITOR
  #  ## Called after applying a transaction to the object in cases where transaction annotation was provided. Default implementation simply calls PostEditChange.

  method postRename(oldOuter: ptr UObject; oldName: FName)

  method postDuplicate(bDuplicateForPIE: bool)
    ## Called after duplication & serialization and before PostLoad. Used to e.g. make sure UStaticMesh's UModel gets copied as well.
    ## Note: NOT called on components on actor duplication (alt-drag or copy-paste).  Use PostEditImport as well to cover that case.

  method needsLoadForClient(): bool {.noSideEffect.}
    ## Called during saving to determine the load flags to save with the object.
    ## Upon reload, this object will be discarded on clients
    ##
    ## Returns *true* if this object should not be loaded on clients

  method needsLoadForServer(): bool {.noSideEffect.}
    ## Called during saving to determine the load flags to save with the object.
    ## Upon reload, this object will be discarded on servers
    ##
    ## Returns *true* if this object should not be loaded on servers

  method needsLoadForEditorGame(): bool {.noSideEffect.}
    ## Called during saving to determine the load flags to save with the object.
    ##
    ## Returns *true* if this object should always be loaded for editor game

  method isPostLoadThreadSafe(): bool {.noSideEffect.}
    ## Called during async load to determine if PostLoad can be called on the loading thread.
    ##
    ## Returns *true* if this object's PostLoad is thread safe

  proc canCreateInCurrentContext(tmpl: ptr UObject): bool {.isStatic.}
    ##  Determines if you can create an object from the supplied template in the current context (editor, client only, dedicated server, game/listen)
    ##  This calls NeedsLoadForClient & NeedsLoadForServer

  # AWARE: uncomment when the deps are interfaced
  # method ExportCustomProperties(out: var FOutputDevice; indent: uint32)
  #  ## Exports the property values for the specified object as text to the output device. Required for Copy&Paste
  #  ## Most objects don't need this as unreal script can handle most cases.
  #  ##
  #  ## `out`: the output device to send the exported text to
  #  ## `indent`: number of spaces to prepend to each line of output
  #  ##
  #  ## see also: `ImportCustomProperties`

  # proc ImportCustomProperties(sourceText: ptr TCHAR; warn: ptr FFeedbackContext)
  #  ## Imports the property values for the specified object as text to the output device. Required for Copy&Paste
  #  ## Most objects don't need this as unreal script can handle most cases.
  #  ##
  #  ## `sourceText`: the input data (zero terminated), must not be 0
  #  ## `warn`:       for error reporting, must not be 0
  #  ##
  #  ## see also: `ExportCustomProperties`

  method postEditImport()
    ## Called after importing property values for this object (paste, duplicate or .t3d import)
    ## Allow the object to perform any cleanup for properties which shouldn't be duplicated or
    ## are unsupported by the script serialization

  method postReloadConfig(propertyThatWasLoaded: ptr UProperty)
    ## Called from ReloadConfig after the object has reloaded its configuration data.

  method rename(newName: wstring = nil; newOuter: ptr UObject = nil;
              flags: ERenameFlags = REN_None): bool
    ## Rename this object to a unique name.

  method getDesc(): FString
    ## Returns a one line description of an object for viewing in the thumbnail view of the generic browser

  method getWorld(): ptr UWorld {.noSideEffect.} # WITH_ENGINE

  proc getWorldChecked(bSupported: var bool): ptr UWorld {.noSideEffect.} # WITH_ENGINE

  proc implementsGetWorld(): bool {.noSideEffect.} # WITH_ENGINE

  method getNativePropertyValues(out_PropertyValues: var TMap[FString, FString];
                               ExportFlags: uint32 = 0): bool {.noSideEffect.}
    ## Callback for retrieving a textual representation of natively serialized properties.
    ## Child classes should implement this method if they wish to have natively serialized property values included in
    ## things like diffcommandlet output.
    ##
    ## `out_PropertyValues`:  receives the property names and values which should be reported for this object.  The map's key should be the name of
    ##                        the property and the map's value should be the textual representation of the property's value.  The property value should
    ##                        be formatted the same way that UProperty::ExportText formats property values (i.e. for arrays, wrap in quotes and use a comma
    ##                        as the delimiter between elements, etc.)
    ##
    ## `exportFlags`:         bitmask of EPropertyPortFlags used for modifying the format of the property values
    ##
    ## Returns *true* if property values were added to the map.

  method getResourceSize(Mode: EResourceSizeMode): csize
    ## Returns the size of the object/ resource for display to artists/ LDs in the Editor. The
    ## default behavior is to return 0 which indicates that the resource shouldn't
    ## display its size.
    ##
    ## `mode`: Indicates which resource size should be returned
    ## Returns size of resource as to be displayed to artists/ LDs in the Editor.

  method getExporterName(): FName
    ## Returns the name of the exporter factory used to export this object
    ## Used when multiple factories have the same extension

  method isLocalizedResource(): bool
    ## Returns whether this wave file is a localized resource.

  # AWARE
  # proc AddReferencedObjects(inThis: ptr UObject; collector: var FReferenceCollector) {.static.}
  #   ## Callback used to allow object register its direct object references that are not already covered by
  #   ## the token stream.
  #   ##
  #   ## `inThis`: Object to collect references from.
  #   ## `collector`: FReferenceCollector objects to be used to collect references.

  # proc CallAddReferencedObjects(collector: var FReferenceCollector)
  #   ## Helper function to call AddReferencedObjects for this object's class.
  #   ##
  #   ## `collector`: FReferenceCollector objects to be used to collect references.

  # method getRestoreForUObjectOverwrite(): ptr FRestoreForUObjectOverwrite
  #   ## Save information for StaticAllocateObject in the case of overwriting an existing object.
  #   ## StaticAllocateObject will call delete on the result after calling Restore()
  #   ##
  #   ## Returns an FRestoreForUObjectOverwrite that can restore the object or NULL if this is not necessary.

  method areNativePropertiesIdenticalTo(other: ptr UObject): bool {.noSideEffect.}
    ## Returns whether native properties are identical to the one of the passed in component.
    ##
    ## `other`: Other component to compare against
    ##
    ## Returns *true* if native properties are identical, false otherwise


  # AWARE: integrate properly if we ever need this:

  # type
  #   FAssetRegistryTag* {.importcpp: "FAssetRegistryTag", header: "uobject.h".} = object
  #     Name* {.importc: "Name".}: FName
  #     Type* {.importc: "Type".}: ETagType
  #     Value* {.importc: "Value".}: FString

  #   ETagType* {.size: sizeof(cint), importcpp: "FAssetRegistryTag::ETagType",
  #              header: "uobject.h".} = enum
  #     TT_Hidden, TT_Alphabetical, TT_Numerical, TT_Dimensional


  # proc constructFAssetRegistryTag(InName: FName; InValue: FString; InType: ETagType): FAssetRegistryTag

  # proc GetAssetRegistryTagsFromSearchableProperties(Object: ptr UObject;
  #     OutTags: var TArray[FAssetRegistryTag])

  # proc GetAssetRegistryTags(outTags: var TArray[FAssetRegistryTag])
  #  ##
  #  ## Gathers a list of asset registry searchable tags which are name/value pairs with some type information
  #  ## This only needs to be implemented for asset objects
  #  ##
  #  ## `outTags`: a list of key-value pairs associated with this object and their types
  #  ##

  proc sourceFileTagName(): FName {.isStatic, noSideEffect.}
    ## Get the common tag name used for all asset source file import paths

  # integrate properly if we ever need this:
  # when WITH_EDITOR:
  #   ##
  #   ## Additional data pertaining to asset registry tags used by the editor
  #   ##
  #   type
  #     FAssetRegistryTagMetadata* {.importcpp: "FAssetRegistryTagMetadata",
  #                                 header: "uobject.h".} = object
  #       DisplayName* {.importc: "DisplayName".}: FText
  #       TooltipText* {.importc: "TooltipText".}: FText
  #       Suffix* {.importc: "Suffix".}: FText
  #       ImportantValue* {.importc: "ImportantValue".}: FString ## Set override display name

  #   proc SetDisplayName(this: var FAssetRegistryTagMetadata; InDisplayName: FText): var FAssetRegistryTagMetadata {.
  #       importcpp: "SetDisplayName", header: "uobject.h".}
  #   proc SetTooltip(this: var FAssetRegistryTagMetadata; InTooltipText: FText): var FAssetRegistryTagMetadata {.
  #       importcpp: "SetTooltip", header: "uobject.h".}
  #   proc SetSuffix(this: var FAssetRegistryTagMetadata; InSuffix: FText): var FAssetRegistryTagMetadata {.
  #       importcpp: "SetSuffix", header: "uobject.h".}
  #   proc SetImportantValue(this: var FAssetRegistryTagMetadata;
  #                          InImportantValue: FString): var FAssetRegistryTagMetadata {.
  #       importcpp: "SetImportantValue", header: "uobject.h".}
  #   ## Gathers a collection of asset registry tag metadata
  #   proc GetAssetRegistryTagMetadata(OutMetadata: var TMap[FName,
  #       FAssetRegistryTagMetadata]) {.noSideEffect,
  #                                    importcpp: "GetAssetRegistryTagMetadata(@)",
  #                                    header: "uobject.h".}

  method isAsset(): bool {.noSideEffect.}
    ## Returns true if this object is considered an asset.

  method isSafeForRootSet(): bool {.noSideEffect.}
    ## Returns true if this object is safe to add to the root set.

  method tagSubobjects(newFlags: EObjectFlags)
    ##
    ## Tags objects that are part of the same asset with the specified object flag, used for GC checking
    ##
    ## `newFlags`: object Flags to enable on the related objects
    ##

  # AWARE
  # method GetLifetimeReplicatedProps(OutLifetimeProps: var TArray[FLifetimeProperty]) {.noSideEffect.}
  #   ## Returns properties that are replicated for the lifetime of the actor channel

  method isNameStableForNetworking(): bool {.noSideEffect.}
    ## IsNameStableForNetworking means an object can be referred to its path name (relative to outer) over the network

  method isFullNameStableForNetworking(): bool {.noSideEffect.}
    ## IsFullNameStableForNetworking means an object can be referred to its full path name over the network

  method isSupportedForNetworking(): bool {.noSideEffect.}
    ## Returns a list of sub-objects that have stable names for networking

  method getSubobjectsWithStableNamesForNetworking(objList: var TArray[ptr UObject])

  method preNetReceive()
    ## Called right before receiving a bunch

  method postNetReceive()
    ## Called right after receiving a bunch

  method preDestroyFromReplication()
    ## Called right before being marked for destruction due to network replication


  # ******************************************************
  # Non virtual functions, not intended to be overridden
  # ******************************************************

  proc isSelected(): bool {.noSideEffect.}
    ## Test the selection state of a UObject

  # AWARE
  # proc propagatePreEditChange(affectedObjects: var TArray[ptr UObject];
  #                             propertyAboutToChange: var FEditPropertyChain) # WITH_EDITOR
  #   ## Serializes all objects which have this object as their archetype into GMemoryArchive, then recursively calls this function
  #   ## on each of those objects until the full list has been processed.
  #   ## Called when a property value is about to be modified in an archetype object.
  #   ##
  #   ## `affectedObjects`: the array of objects which have this object in their ObjectArchetype chain and will be affected by the change.
  #   ##                    Objects which have this object as their direct ObjectArchetype are removed from the list once they're processed.

  # proc propagatePostEditChange(affectedObjects: var TArray[ptr UObject];
  #     propertyChangedEvent: var FPropertyChangedChainEvent) # WITH_EDITOR
  #   ## De-serializes all objects which have this object as their archetype from the GMemoryArchive, then recursively calls this function
  #   ## on each of those objects until the full list has been processed.
  #   ##
  #   ## `affectedObjects`: the array of objects which have this object in their ObjectArchetype chain and will be affected by the change.
  #   ##                    Objects which have this object as their direct ObjectArchetype are removed from the list once they're processed.
  #   ##

  proc serializeScriptProperties(ar: var FArchive) {.noSideEffect.}
    ## Serializes the script property data located at Data.  When saving, only saves those properties which differ from the corresponding
    ## value in the specified 'DiffObject' (usually the object's archetype).
    ##
    ## @param ar        the archive to use for serialization

  proc getDetailedInfo(): FString {.noSideEffect.}
    ## This will return detail info about this specific object. (e.g. AudioComponent will return the name of the cue,
    ## ParticleSystemComponent will return the name of the ParticleSystem)  The idea here is that in many places
    ## you have a component of interest but what you really want is some characteristic that you can use to track
    ## down where it came from.
    ##
    ## **Note:** safe to call on nil object pointers!

  proc conditionalBeginDestroy(): bool
    ## Called before destroying the object.  This is called immediately upon deciding to destroy the object, to allow the object to begin an
    ## asynchronous cleanup process.

  proc conditionalFinishDestroy(): bool

  proc conditionalPostLoad()
    ## PostLoad if needed.

  # AWARE
  # proc reinitializeProperties(SourceObject: ptr UObject = nil;
  #                             InstanceGraph: ptr FObjectInstancingGraph = nil)
  #   ## Wrapper function for InitProperties() which handles safely tearing down this object before re-initializing it
  #   ## from the specified source object.
  #   ##
  #   ## `sourceObject`:  the object to use for initializing property values in this object.  If not specified, uses this object's archetype.
  #   ## `instanceGraph`: contains the mappings of instanced objects and components to their templates
  # proc conditionalPostLoadSubobjects(outerInstanceGraph: ptr FObjectInstancingGraph = nil)
  #   ## Instances subobjects and components for objects being loaded from disk, if necessary.  Ensures that references
  #   ## between nested components are fixed up correctly.
  #   ##
  #   ## `outerInstanceGraph`: when calling this method on subobjects, specifies the instancing graph which contains all instanced
  #   ##                       subobjects and components for a subobject root.

  # AWARE
  # method beginCacheForCookedPlatformData(targetPlatform: ptr ITargetPlatform) # WITH_EDITOR
  #   ## Starts caching of platform specific data for the target platform
  #   ## Called when cooking before serialization so that object can prepare platform specific data
  #   ## Not called during normal loading of objects
  #   ##
  #   ## `targetPlatform`: target platform to cache platform specific data for

  # method isCachedCookedPlatformDataLoaded(targetPlatform: ptr ITargetPlatform): bool # WITH_EDITOR
  #   ## Have we finished loading all the cooked platform data for the target platforms requested in BeginCacheForCookedPlatformData
  #   ##
  #   ## `targetPlatform`: target platform to check for cooked platform data

  # method clearCachedCookedPlatformData(targetPlatform: ptr ITargetPlatform) # WITH_EDITOR
  #   ## Clears cached cooked platform data for specific platform
  #   ##
  #   ## `targetPlatform`: target platform to cache platform specific data for

  method willNeverCacheCookedPlatformDataAgain() # WITH_EDITOR
    ## All caching has finished for this object (all IsCachedCookedPlatformDataLoaded functions have finished for all platforms)

  method clearAllCachedCookedPlatformData() # WITH_EDITOR
    ## Clear all cached cooked platform data
    ##
    ## `targetPlatform`  target platform to cache platform specific data for

  proc isBasedOnArchetype(someObject: ptr UObject): bool {.noSideEffect.}
    ## Determine if this object has SomeObject in its archetype chain.

  proc findFunction(inName: FName): ptr UFunction {.noSideEffect.}
  proc findFunctionChecked(inName: FName): ptr UFunction {.noSideEffect.}

  proc collectDefaultSubobjects(OutDefaultSubobjects: var TArray[ptr UObject];
                                bIncludeNestedSubobjects: bool = false)
    ## Uses the TArchiveObjectReferenceCollector to build a list of all components referenced by this object which have this object as the outer
    ##
    ## `outDefaultSubobjects`:      the array that should be populated with the default subobjects "owned" by this object
    ## `bIncludeNestedSubobjects`:  controls whether subobjects which are contained by this object, but do not have this object
    ##                              as its direct Outer should be included

  proc checkDefaultSubobjects(bForceCheck: bool = false): bool
    ## Checks default sub-object assumptions. Returns *true* if the assumptions are met, false otherwise.
    ##
    ## `bForceCheck` Force checks even if not enabled globally.

  # AWARE: interface when deps are added
  # proc SaveConfig(flags: uint64 = CPF_Config; filename: ptr TCHAR = nil;
  #                 config: ptr FConfigCacheIni = GConfig)
  #  ## Save configuration.
  #  ## **Warning:** Must be safe on class-default metaobjects.
  #  # !!may benefit from hierarchical propagation, deleting keys that match superclass...not sure what's best yet.

  proc updateDefaultConfigFile(specificFileLocation: FString = TEXT(""))
    ## Saves just the section(s) for this class into the default ini file for the class (with just the changes from base)

  proc updateGlobalUserConfigFile()
    ## Saves just the section(s) for this class into the global user ini file for the class (with just the changes from base)

  proc updateSinglePropertyInConfigFile(шnProperty: ptr UProperty; InConfigIniName: FString)
    ## Saves just the property into the global user ini file for the class (with just the changes from base)

  proc defaultConfigFilename(): FString {.noSideEffect, cppname: "GetDefaultConfigFilename".}
    ## Get the default config filename for the specified UObject

  proc globalUserConfigFilename(): FString {.noSideEffect, cppname: "GetGlobalUserConfigFilename".}
    ## Get the global user override config filename for the specified UObject

  method loadConfig(configClass: ptr UClass = nil; Filename: wstring = nil;
                  propagationFlags: uint32 = LCPF_None; propertyToLoad: ptr UProperty = nil)
    ## Imports property values from an .ini file.
    ##
    ## `configClass`:      the class to use for determining which section of the ini to retrieve text values from
    ## `filename`:         indicates the filename to load values from; if not specified, uses ConfigClass's ClassConfigName
    ## `propagationFlags`: indicates how this call to LoadConfig should be propagated; expects a bitmask of UE4.ELoadConfigPropagationFlags values.
    ## `propertyToLoad`:   if specified, only the ini value for the specified property will be imported.

  proc reloadConfig(configClass: ptr UClass = nil; filename: wstring = nil;
                    propagationFlags: uint32 = LCPF_None;
                    propertyToLoad: ptr UProperty = nil)
    ## Wrapper method for LoadConfig that is used when reloading the config data for objects at runtime which have already loaded their config data at least once.
    ## Allows the objects the receive a callback that it's configuration data has been reloaded.
    ##
    ## `configClass`:      the class to use for determining which section of the ini to retrieve text values from
    ## `filename`:         indicates the filename to load values from; if not specified, uses ConfigClass's ClassConfigName
    ## `propagationFlags`: indicates how this call to LoadConfig should be propagated; expects a bitmask of UE4::ELoadConfigPropagationFlags values.
    ## `propertyToLoad`:   if specified, only the ini value for the specified property will be imported

  proc parseParams(params: wstring) {.cppname: "parseParms".}
    ## Import an object from a file.

  # AWARE
  # proc OutputReferencers(ar: var FOutputDevice;
  #                        referencers: ptr FReferencerInformationList = nil)
  #   ## Outputs a string to an arbitrary output device, describing the list of objects which are holding references to this one.
  #   ##
  #   ## `ar`:          the output device to send output to
  #   ## `referencers`: optionally allows the caller to specify the list of references to output.

  # proc RetrieveReferencers(outInternalReferencers: ptr TArray[FReferencerInformation];
  #     outExternalReferencers: ptr TArray[FReferencerInformation])


  # AWARE: interface if needed (unlikely)
  # proc SetLinker(linkerLoad: ptr FLinkerLoad; linkerIndex: int32;
  #                bShouldDetachExisting: bool = true)
  #  ## Changes the linker and linker index to the passed in one. A linker of *nil* and linker index of INDEX_NONE
  #  ## indicates that the object is without a linker.
  #  ##
  #  ## `linkerLoad`: New LinkerLoad object to set
  #  ## `linkerIndex`: New LinkerIndex to set
  #  ## `bShouldDetachExisting`: If true, detach existing linker and call PostLinkerChange

  proc getArchetypeFromRequiredInfo(class: ptr UClass; outer: ptr UObject; name: FName;
                                    objectFlags: EObjectFlags): ptr UObject
    ## Return the template that an object with this class, outer and name would be

  proc archetype(): ptr UObject {.noSideEffect, cppname: "getArchetype".}
    ## Return the template this object is based on.

  proc archetypeInstances(instances: var TArray[ptr UObject]) {.cppname: "getArchetypeInstances".}
    ## Builds a list of objects which have this object in their archetype chain.
    ##
    ## `instances`: receives the list of objects which have this one in their archetype chain

  # AWARE
  # proc InstanceSubobjectTemplates(instanceGraph: ptr FObjectInstancingGraph = nil)
  #   ## Wrapper for calling UClass::InstanceSubobjectTemplates() for this object.

  proc implements[T](): bool {.noSideEffect.}
    ## Returns true if this object implements the interface T, false otherwise.


proc getNameSafe*(obj: ptr UObjectBaseUtility): FString {.
  importc: "GetNameSafe", header: "UObject/UObjectBaseUtility.h".}
  ## Returns the name of this object (with no path information)
  ## @param Object object to retrieve the name for; NULL gives "None"
  ## @return Name of the object.

proc getPathNameSafe*(obj: ptr UObjectBaseUtility): FString {.
  importc: "GetPathNameSafe", header: "UObject/UObjectBaseUtility.h".}
  ## Returns the path name of this object
  ## @param Object object to retrieve the path name for; NULL gives "None"
  ## @return path name of the object.

proc getFullNameSafe*(obj: ptr UObjectBaseUtility): FString {.
  importc: "GetFullNameSafe", header: "UObject/UObjectBaseUtility.h".}
  ## Returns the full name of this object
  ## @param Object object to retrieve the full name for; NULL (or a null class!) gives "None"
  ## @return full name of the object.

template setDefaultSubobjectClass*(this: var FObjectInitializer, T: typedesc, subobjName: FName or wstring) =
  ## Sets the class of a subobject for a base class
  ## @param	subobjName	name of the new component or subobject
  # TODO: cannot yet wrap this properly
  {.emit: "`$#`.SetDefaultSubobjectClass<$#>(`$#`);".format(astToStr(this), T.name, astToStr(subobjName)).}

proc loadObject*[T: UObject](path: wstring): ptr T {.
  header: "UObject/UObjectGlobals.h", importcpp: "(Cast<'*0>(StaticLoadObject('*0::StaticClass(), NULL, #)))".}
proc loadObject*[T: UObject](path: FString): ptr T =
  result = loadObject[T](wideString(path))
proc loadObject*[T: UObject](path: string): ptr T =
  result = loadObject[T](toWideString(path))

proc ueNew*[T](): ptr T {.importcpp: "(NewObject<'*0>())", nodecl.}
proc ueNew*[T](outer: ptr UObject): ptr T {.importcpp: "(NewObject<'*0>(@))", nodecl.}
proc ueNew*[T](outer: ptr UObject, class: ptr UClass): ptr T {.importcpp: "(NewObject<'*0>(@))", nodecl.}
proc ueNew*[T](outer: ptr UObject, class: ptr UClass, name: FName = NAME_None,
               flags = RF_NoFlags, objTemplate: ptr UObject = nil, bCopyTransientsFromClassDefaults = false,
               inInstanceGraph: ptr FObjectInstancingGraph): ptr T {.importcpp: "(NewObject<'*0>(@))", nodecl.}

proc ctorLoadObject*(T: typedesc, path: static[string]): ptr T {.inline.} =
  ## Loads object of the specified type from the specified path.
  ## Must only be used from constructors.
  var thePath: string
  shallowCopy(thePath, path)
  {.emit: "static ConstructorHelpers::FObjectFinder<" & T.name & "> rCont(UTF8_TO_TCHAR((`thePath`)->data));`result`=rCont.Object;".}

proc ctorLoadClass*(T: typedesc, path: static[string]): TSubclassOf[T] {.inline.} =
  ## Loads object of the specified type from the specified path.
  ## Must only be used from constructors.
  var thePath: string
  shallowCopy(thePath, path)
  {.emit: "static ConstructorHelpers::FClassFinder<" & T.name & "> rCont(UTF8_TO_TCHAR((`thePath`)->data));`result`=rCont.Class;".}

wclass(UClass of UObject, header: "UObject/Class.h", notypedef):
  proc getDefaultObject[T](): ptr T {.cppname: "#.GetDefaultObject<'*0>(@)".}
    ## Get the default object from the class
    ## @param	bCreateIfNeeded if true (default) then the CDO is created if it is NULL.
    ## @return		the CDO for this class

  proc getDefaultObjectName(): FName
    ## Get the name of the CDO for the this class
    ## @return The name of the CDO
