// Note: Locating the Security Wardrobe definition. 
// If SPLURT uses a different path for vendors, this should be adjusted to code/modules/vending/security.dm

/obj/machinery/vending/wardrobe/sec_wardrobe/New()
	..()
	// Adding to premium products as requested
	var/list/sec_premium = list(
		/obj/item/clothing/under/rank/security/blue = 2,
		/obj/item/clothing/under/rank/security/white = 2
	)
	product_ads += "Try our new 'Classic Blue' and 'Oversight White' security lines!"
	premium += sec_premium
