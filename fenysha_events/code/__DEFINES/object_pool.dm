/// Получить экземпляр типа из пула или создать новый с указанными аргументами.
/// Использование: POOL_TAKE(/obj/foo, loc, arg2)
#define POOL_TAKE(type, arguments...) SSobject_pool.Take(type, ##arguments)

/// Вернуть экземпляр в пул (сбрасывает его переменные из шаблона и очищает ссылки).
#define POOL_RELEASE(obj) SSobject_pool.Release(obj).
#define POOL_ASYNC_RELEASE(obj) SSobject_pool.ReleaseAsync(obj)

/// Уничтожить экземпляр без возврата в пул (qdel).
#define POOL_DELETE(obj) SSobject_pool.Delete(obj)

/// Убедиться, что тип зарегистрирован в пуле (создаёт шаблон если нужно). Опционально перед первым POOL_TAKE.
#define POOL_REGISTER(type) SSobject_pool.RegisterType(type)
