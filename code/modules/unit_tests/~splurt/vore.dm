/datum/unit_test/vore_autotransfer_timer_uses_displayed_seconds/Run()
	var/mob/living/carbon/human/consistent/pred = allocate(/mob/living/carbon/human/consistent)
	var/datum/component/vore/vore_component = pred.AddComponent(/datum/component/vore)

	TEST_ASSERT_NOTNULL(vore_component, "Pred failed to receive a vore component.")
	TEST_ASSERT_NOTNULL(vore_component.selected_belly, "Vore component did not create a default belly.")

	var/obj/vore_belly/source_belly = vore_component.selected_belly
	var/obj/vore_belly/target_belly = allocate(/obj/vore_belly, pred, vore_component)

	source_belly.autotransfer_enabled = TRUE
	source_belly.autotransfer_target = target_belly
	source_belly.autotransfer_delay = 60 SECONDS

	for(var/i in 1 to 60)
		source_belly.handle_autotransfer(1)

	TEST_ASSERT_EQUAL(source_belly.autotransfer_timer, 0, "Auto-transfer should fire after the displayed 60 second delay.")
