/// Exercise the real wood crafting path, not a substitute recipe or spawned result alone.
/datum/unit_test/large_painting_frame
	abstract_type = /datum/unit_test/large_painting_frame

/datum/unit_test/large_painting_frame/proc/find_frame_recipe(obj/item/stack/sheet/mineral/wood/wood, result_type)
	for(var/datum/stack_recipe/recipe in wood.recipes)
		if(recipe.result_type == result_type)
			return recipe
	return null

/datum/unit_test/large_painting_frame/craft_large/Run()
	var/mob/living/carbon/human/consistent/builder = allocate(__IMPLIED_TYPE__)
	builder.mind_initialize()
	var/obj/item/stack/sheet/mineral/wood/wood = allocate(__IMPLIED_TYPE__, run_loc_floor_bottom_left, 3, FALSE)
	var/datum/stack_recipe/recipe = find_frame_recipe(wood, /obj/item/wallframe/painting/large)
	TEST_ASSERT_NOTNULL(recipe, "The actual wood crafting menu must offer a large painting frame")
	TEST_ASSERT(wood.make_item(builder, recipe), "Crafting the large frame through make_item must succeed")
	TEST_ASSERT(wood.amount == 1, "Crafting one large frame must consume exactly two wood sheets")
	var/obj/item/wallframe/painting/large/frame = locate() in builder
	TEST_ASSERT_NOTNULL(frame, "Crafting must produce the existing large wallframe item in the builder's hands")
	allocated += frame
	TEST_ASSERT(frame.result_path == /obj/structure/sign/painting/large, "The crafted frame must mount as the existing large painting structure")

/datum/unit_test/large_painting_frame/craft_ordinary/Run()
	var/mob/living/carbon/human/consistent/builder = allocate(__IMPLIED_TYPE__)
	builder.mind_initialize()
	var/obj/item/stack/sheet/mineral/wood/wood = allocate(__IMPLIED_TYPE__, run_loc_floor_bottom_left, 2, FALSE)
	var/datum/stack_recipe/recipe = find_frame_recipe(wood, /obj/item/wallframe/painting)
	TEST_ASSERT_NOTNULL(recipe, "The ordinary painting frame recipe must remain available")
	TEST_ASSERT(wood.make_item(builder, recipe), "The ordinary frame must still craft through make_item")
	TEST_ASSERT(wood.amount == 1, "The ordinary frame must retain its one-sheet cost")
	var/obj/item/wallframe/painting/frame = locate() in builder
	TEST_ASSERT_NOTNULL(frame, "The ordinary recipe must produce a frame")
	allocated += frame
	TEST_ASSERT(frame.type == /obj/item/wallframe/painting, "The ordinary recipe must not be replaced by a large frame")

/datum/unit_test/large_painting_frame/insufficient_wood/Run()
	var/mob/living/carbon/human/consistent/builder = allocate(__IMPLIED_TYPE__)
	builder.mind_initialize()
	var/obj/item/stack/sheet/mineral/wood/wood = allocate(__IMPLIED_TYPE__, run_loc_floor_bottom_left, 1, FALSE)
	var/datum/stack_recipe/recipe = find_frame_recipe(wood, /obj/item/wallframe/painting/large)
	TEST_ASSERT_NOTNULL(recipe, "The large frame recipe must be present even when materials are insufficient")
	TEST_ASSERT(!wood.make_item(builder, recipe), "One wood sheet must not produce a two-sheet frame")
	TEST_ASSERT(wood.amount == 1, "A refused craft must not consume wood")
	TEST_ASSERT(!(locate(/obj/item/wallframe/painting/large) in builder), "A refused craft must not put a frame in the builder's inventory")
	TEST_ASSERT(!(locate(/obj/item/wallframe/painting/large) in run_loc_floor_bottom_left), "A refused craft must not spawn a frame on the floor")

/datum/unit_test/large_painting_frame/canvas_sizes/Run()
	var/mob/living/carbon/human/consistent/builder = allocate(__IMPLIED_TYPE__)
	builder.mind_initialize()
	var/obj/item/stack/sheet/mineral/wood/wood = allocate(__IMPLIED_TYPE__, run_loc_floor_bottom_left, 3, FALSE)
	var/datum/stack_recipe/recipe = find_frame_recipe(wood, /obj/item/wallframe/painting/large)
	TEST_ASSERT_NOTNULL(recipe, "The large frame recipe must be available")
	TEST_ASSERT(wood.make_item(builder, recipe), "The compatibility test must start with an actually crafted frame")
	var/obj/item/wallframe/painting/large/wallframe = locate() in builder
	TEST_ASSERT_NOTNULL(wallframe, "Crafting must yield the large wallframe")
	allocated += wallframe
	// Test the crafted item's real mounted type; physical two-wall mounting is unchanged.
	var/obj/structure/sign/painting/large/frame = allocate(wallframe.result_path)
	var/obj/item/canvas/small_canvas = allocate(/obj/item/canvas)
	TEST_ASSERT(builder.put_in_hands(small_canvas), "The builder must hold the small canvas")
	TEST_ASSERT(!frame.frame_canvas(builder, small_canvas), "The large frame must reject an ordinary small canvas")
	TEST_ASSERT(isnull(frame.current_canvas), "Rejecting an incompatible canvas must leave the frame empty")
	builder.dropItemToGround(small_canvas)
	for(var/canvas_type in list(/obj/item/canvas/thirtysix_twentyfour, /obj/item/canvas/fortyfive_twentyseven))
		var/obj/item/canvas/canvas = allocate(canvas_type)
		// An existing completed painting avoids the interactive naming prompt.
		canvas.finalized = TRUE
		TEST_ASSERT(builder.put_in_hands(canvas), "The builder must hold the large canvas")
		TEST_ASSERT(frame.frame_canvas(builder, canvas), "Each existing large canvas size must fit the crafted frame's mounted type")
		TEST_ASSERT(frame.current_canvas == canvas && canvas.loc == frame, "Framing must transfer the actual canvas into the frame")
		canvas.forceMove(run_loc_floor_bottom_left)
		TEST_ASSERT(isnull(frame.current_canvas), "Removing the canvas must clear the frame for the other size")
