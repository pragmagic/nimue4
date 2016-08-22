template <typename WrappedRetValType, typename... ParamTypes, typename FunctorType, typename... VarTypes>
class TBaseNimClosureDelegateInstance<WrappedRetValType(ParamTypes...), FunctorType, VarTypes...> : public IBaseDelegateInstance<typename TUnwrapType<WrappedRetValType>::Type(ParamTypes...)>
{
public:
	typedef typename TUnwrapType<WrappedRetValType>::Type RetValType;

private:
	static_assert(TAreTypesEqual<FunctorType, typename TRemoveReference<FunctorType>::Type>::Value, "FunctorType cannot be a reference");

	typedef IBaseDelegateInstance<typename TUnwrapType<WrappedRetValType>::Type(ParamTypes...)> Super;
	typedef TBaseFunctorDelegateInstance<RetValType(ParamTypes...), FunctorType, VarTypes...>   UnwrappedThisType;

public:
	TBaseFunctorDelegateInstance(const FunctorType& InFunctor, VarTypes... Vars)
		: Functor(InFunctor)
		, Payload(Vars...)
		, Handle (FDelegateHandle::GenerateNewHandle)
	{
	}

	TBaseFunctorDelegateInstance(FunctorType&& InFunctor, VarTypes... Vars)
		: Functor(MoveTemp(InFunctor))
		, Payload(Vars...)
		, Handle (FDelegateHandle::GenerateNewHandle)
	{
	}

	// IDelegateInstance interface

#if USE_DELEGATE_TRYGETBOUNDFUNCTIONNAME

	virtual FName TryGetBoundFunctionName() const override
	{
		return NAME_None;
	}

#endif

	// Deprecated
	virtual FName GetFunctionName() const override
	{
		return NAME_None;
	}

	// Deprecated
	virtual const void* GetRawMethodPtr() const override
	{
		// casting operator() to void* is not legal C++ if it's a member function
		// and wouldn't necessarily be a useful thing to return anyway
		check(0);
		return nullptr;
	}

	// Deprecated
	virtual const void* GetRawUserObject() const override
	{
		// returning &Functor wouldn't be particularly useful to the comparison code
		// as it would always be unique because we store a copy of the functor
		check(0);
		return nullptr;
	}

	// Deprecated
	virtual EDelegateInstanceType::Type GetType() const override
	{
		return EDelegateInstanceType::Functor;
	}

	virtual UObject* GetUObject() const override
	{
		return nullptr;
	}

	// Deprecated
	virtual bool HasSameObject(const void* UserObject) const override
	{
		// Functor Delegates aren't bound to a user object so they can never match
		return false;
	}

	virtual bool IsSafeToExecute() const override
	{
		// Functors are always considered safe to execute!
		return true;
	}

public:
	// IBaseDelegateInstance interface
	virtual void CreateCopy(FDelegateBase& Base) override
	{
		new (Base) UnwrappedThisType(*(UnwrappedThisType*)this);
	}

	virtual RetValType Execute(ParamTypes... Params) const override
	{
		return Payload.template ApplyAfter_ExplicitReturnType<RetValType>(Functor, Params...);
	}

	virtual FDelegateHandle GetHandle() const override
	{
		return Handle;
	}

	// Deprecated
	virtual bool IsSameFunction(const Super& InOtherDelegate) const override
	{
		// There's no nice way to implement this (we don't have the type info necessary to compare against OtherDelegate's Functor)
		return false;
	}

public:
	/**
	 * Creates a new static function delegate binding for the given function pointer.
	 *
	 * @param InFunctor C++ functor
	 * @return The new delegate.
	 */
	FORCEINLINE static void Create(FDelegateBase& Base, const FunctorType& InFunctor, VarTypes... Vars)
	{
		new (Base) UnwrappedThisType(InFunctor, Vars...);
	}
	FORCEINLINE static void Create(FDelegateBase& Base, FunctorType&& InFunctor, VarTypes... Vars)
	{
		new (Base) UnwrappedThisType(MoveTemp(InFunctor), Vars...);
	}

private:
	// C++ functor
	FunctorType Functor;

	// Payload member variables, if any.
	TTuple<VarTypes...> Payload;

	// The handle of this delegate
	FDelegateHandle Handle;
};
