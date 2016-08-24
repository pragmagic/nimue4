# Copyright 2016 Xored Software, Inc.

wclass(TAttribute[T], header: "Misc/Attribute.h", bycopy):
  ## Attribute object

  proc initTAttribute(): TAttribute[T] {.constructor, noSideEffect.}
    ## Default constructor.

  proc initTAttribute(inInitialValue: T): TAttribute[T] {.constructor, noSideEffect.}
    ## Construct implicitly from an initial value
    ##
    ## @param  InInitialValue  The value for this attribute

  proc set[OtherT](inNewValue: OtherT)
    ## Sets the attribute's value
    ##
    ## @param  InNewValue  The value to set the attribute to

  proc isSet(): bool {.noSideEffect.}
    ## Was this TAttribute ever assigned?

  proc get(): var T
    ## Gets the attribute's current value.
    ## Assumes that the attribute is set.
    ##
    ## @return  The attribute's value

  proc getOrDefault(defaultValue: T): var T {.cppname: "Get".}
    ## Gets the attribute's current value. The attribute may not be set, in which case use the default value provided.
    ## Shorthand for the boilerplate code: MyAttribute.IsSet() ? MyAttribute.Get() : DefaultValue

  proc bindUFunction[U](inUserObject: ptr U, inFunctionName: FName)
    ## Binds an arbitrary function that will be called to generate this attribute's value on demand.
    ## After binding, the attribute will no longer have a value that can be accessed directly, and instead the bound
    ## function will always be called to generate the value.
    ##
    ## @param  InUserObject  Instance of the class that contains the member function you want to bind.
    ## @param  InFunctionName Member function name to bind.

  proc isBound(): bool {.noSideEffect.}
    ## Checks to see if this attribute has a 'getter' function bound
    ##
    ## @return  True if attribute is bound to a getter function

  proc identicalTo[OtherT](inOther: TAttribute[OtherT]): bool {.noSideEffect.}
    ## Is this attribute identical to another TAttribute.
    ##
    ## @param InOther The other attribute to compare with.
    ## @return true if the attributes are identical, false otherwise.

converter toAttribute*[T](val: T): TAttribute[T] {.importcpp: "(#)", nodecl.}
# TODO: binding procs/macros
