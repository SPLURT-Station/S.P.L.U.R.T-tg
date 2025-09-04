/mob/dead/new_player/get_title_html()
	. = ..()
	if(SSticker.current_state == GAME_STATE_STARTUP || findtext(SStitle.splashscreen_name, "has_title"))
		return

	// Build optional inline styles for logo from splashscreen name
	var/name = SStitle.splashscreen_name
	var/container_style = ""
	var/img_style = ""
	var/param_start = findtext(name, "logo(")
	if(param_start)
		var/param_end = findtext(name, ")", param_start + length("logo("))
		if(param_end)
			var/params = copytext(name, param_start + length("logo("), param_end)
			var/list/parts = splittext(params, ",")
			for(var/p in parts)
				if(!istext(p) || !length(p))
					continue
				var/list/kv = splittext(p, "=")
				if(kv.len < 2)
					continue
				var/key = LOWER_TEXT(replacetext(kv[1], " ", ""))
				var/value = jointext(kv.Copy(2), "=")
				switch(key)
					if("top")
						container_style += "top:[value];"
					if("left")
						container_style += "left:[value];"
					if("right")
						container_style += "right:[value];"
					if("bottom")
						container_style += "bottom:[value];"
					if("x")
						container_style += "left:[value];"
					if("y")
						container_style += "top:[value];"
					if("align")
						var/val = LOWER_TEXT(value)
						if(val == "center")
							container_style += "left:50%;transform:translateX(-50%);"
						else if(val == "left")
							container_style += "left:0;transform:none;"
						else if(val == "right")
							container_style += "right:0;transform:none;"
					if("transform")
						container_style += "transform:[value];"
					if("z", "zindex", "z-index")
						container_style += "z-index:[value];"
					if("pointer", "pointer-events")
						container_style += "pointer-events:[value];"
					if("maxw", "max_width", "max-width")
						img_style += "max-width:[value];"
					if("maxh", "max_height", "max-height")
						img_style += "max-height:[value];"
					if("width")
						img_style += "width:[value];"
					if("height")
						img_style += "height:[value];"
					if("opacity")
						container_style += "opacity:[value];"

	var/attr_container = length(container_style) ? " style='[container_style]'" : ""
	var/attr_img = length(img_style) ? " style='[img_style]'" : ""

	. += {"<div class="container_logo"[attr_container]>
			<img class="logo_image" src="https://i.ibb.co/FLcjXLfL/splurtlogo.png" alt="SPLURT Title Logo"[attr_img]>
		</div>"}

