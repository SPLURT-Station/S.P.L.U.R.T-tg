/// Get an instance of a type from the pool, or create a new one with the given arguments.
/// Usage: POOL_TAKE(/obj/foo, loc, arg2)
#define POOL_TAKE(type, arguments...) SSobject_pool.Take(type, ##arguments)

/// Return an instance to the pool (resets its variables from the template and clears references).
#define POOL_RELEASE(obj) SSobject_pool.Release(obj).
#define POOL_ASYNC_RELEASE(obj) SSobject_pool.ReleaseAsync(obj)

/// Destroy an instance without returning it to the pool (qdel).
#define POOL_DELETE(obj) SSobject_pool.Delete(obj)

/// Ensure that a type is registered in the pool (creates a template if needed). Optional before the first POOL_TAKE.
#define POOL_REGISTER(type) SSobject_pool.RegisterType(type)
