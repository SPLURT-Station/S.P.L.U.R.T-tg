/datum/controller/subsystem/ticker/proc/opfor_report()
	var/list/result = list()

	result += "<span class='header'>Opposing Force Report - <span class='greentext header'>Approved: [LAZYLEN(SSopposing_force.approved_applications)]</span>, <span class='redtext header'>Denied: [LAZYLEN(SSopposing_force.submitted_applications)]</span></span><br>" // SPLURT EDIT - Add info about number of applications

	if(!SSopposing_force.approved_applications.len)
		result += span_red("No applications were approved.")
	else
		for(var/datum/opposing_force/opfor in SSopposing_force.approved_applications)
			result += opfor.roundend_report()

	return "<div class='panel stationborder'>[result.Join()]</div>"
