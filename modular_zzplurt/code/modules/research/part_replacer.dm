///RPED. Allows installing & exchaging parts on machines

/obj/item/storage/part_replacer/bluespace/tier5/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/stock_parts/capacitor/abductor(src)
		new /obj/item/stock_parts/scanning_module/abductor(src)
		new /obj/item/stock_parts/servo/abductor(src)
		new /obj/item/stock_parts/micro_laser/abductor(src)
		new /obj/item/stock_parts/matter_bin/abductor(src)
		new /obj/item/stock_parts/power_store/cell/abductor(src)
		new /obj/item/stock_parts/power_store/battery/abductor(src)
		new /obj/item/stack/cable_coil/thirty(src)
