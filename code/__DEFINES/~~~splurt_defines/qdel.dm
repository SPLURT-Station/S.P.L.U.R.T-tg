#define QDEL_NULL_LIST(x) if(x) { for(var/y in x) { qdel(y) } ; x = null }
