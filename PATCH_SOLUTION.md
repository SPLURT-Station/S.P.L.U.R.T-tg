To implement the `ghost_cafe_only` feature, we add a new boolean variable to the `obj` type that tracks whether an object is restricted to the Ghost Cafe or Infinidorms. We then modify the object movement logic to check this flag and prevent the object from being moved outside of these specific areas, effectively making it "vanish" or become unmovable if an attempt is made to smuggle it out.

```diff
--- a/code/modules/ghost_cafe/ghost_cafe.dm
+++ b/code/modules/ghost_cafe/ghost_cafe.dm
@@ -1,5 +1,6 @@
 /obj
 	var/ghost_cafe_only = FALSE
+	var/ghost_cafe_only_vanish = FALSE
 
 /obj/Move(atom/moving, dir)
 	if(ghost_cafe_only && !is_in_ghost_cafe_or_infinidorms(src))
 		return 0
+	if(ghost_cafe_only_vanish && !is_in_ghost_cafe_or_infinidorms(src))
+		qdel(src)
+		return 0
 	return ..()
```