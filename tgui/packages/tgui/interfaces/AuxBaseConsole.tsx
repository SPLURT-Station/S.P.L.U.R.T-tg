// Añadir al proc de tragar existente soporte para múltiples presas y chomp
/mob/living/carbon/human/proc/vore_swallow(mob/living/carbon/human/prey, var/absorb = FALSE, var/chomp = FALSE)
    if(!prey || !prey.can_be_vored())
        return FALSE
    // Verificar capacidad de panza
    var/belly_capacity = get_belly_capacity()
    if(belly_capacity <= 0)
        return FALSE
    // Chomp: permitir tragar múltiples presas sin reducir capacidad tan drásticamente
    if(chomp)
        belly_capacity *= 2
    // Añadir presa a la panza
    add_prey_to_belly(prey, absorb)
    // Efectos de sonido y animación
    visible_message("\icon[prey] <b>[src]</b> traga a [prey] entero!")
    // Procesar digestión
    process_digestion(prey, absorb)
    return TRUE

// Nuevo proc para verificar si puede ser voreado
/mob/living/carbon/human/proc/can_be_vored()
    if(stat & DEAD)
        return FALSE
    if(is_vore_immune())
        return FALSE
    return TRUE

// Proc para obtener capacidad de panza (sobrescrito por chomp)
/mob/living/carbon/human/proc/get_belly_capacity()
    return 1 // Valor base, chomp aumenta esto
