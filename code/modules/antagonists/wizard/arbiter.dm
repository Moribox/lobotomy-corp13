/datum/antagonist/wizard/arbiter
	name = "Arbiter"
	roundend_category = "arbiters"
	antagpanel_category = "The Head"
	give_objectives = FALSE
	move_to_lair = FALSE
	outfit_type = /datum/outfit/arbiter
	antag_attributes = list(
		FORTITUDE_ATTRIBUTE = 130,
		PRUDENCE_ATTRIBUTE = 130,
		TEMPERANCE_ATTRIBUTE = 130,
		JUSTICE_ATTRIBUTE = 130
		)

	var/list/spell_types = list(
		/obj/effect/proc_holder/spell/aimed/fairy,
		/obj/effect/proc_holder/spell/aimed/pillar,
		/obj/effect/proc_holder/spell/aoe_turf/repulse/arbiter,
		/obj/effect/proc_holder/spell/aoe_turf/knock/arbiter
		)

/datum/antagonist/wizard/arbiter/greet()
	to_chat(owner, span_boldannounce("You are the Arbiter!"))

/datum/antagonist/wizard/arbiter/farewell()
	to_chat(owner, span_boldannounce("You have been fired from The Head. Your services are no longer needed."))

/datum/antagonist/wizard/arbiter/apply_innate_effects(mob/living/mob_override)
	var/mob/living/carbon/human/M = mob_override || owner.current
	add_antag_hud(antag_hud_type, antag_hud_name, M)
	M.faction |= "Head"
	M.faction |= "hostile"
	M.faction -= "neutral"
	ADD_TRAIT(M, TRAIT_BOMBIMMUNE, "Arbiter") // We truly are the elite agent of the Head
	ADD_TRAIT(M, TRAIT_STUNIMMUNE, "Arbiter")
	ADD_TRAIT(M, TRAIT_SLEEPIMMUNE, "Arbiter")
	ADD_TRAIT(M, TRAIT_PUSHIMMUNE, "Arbiter")
	ADD_TRAIT(M, TRAIT_IGNOREDAMAGESLOWDOWN, "Arbiter")
	ADD_TRAIT(M, TRAIT_NOFIRE, "Arbiter")
	ADD_TRAIT(M, TRAIT_NODISMEMBER, "Arbiter")
	ADD_TRAIT(M, TRAIT_SANITYIMMUNE, "Arbiter")
	M.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, 500) // Obviously they are very tough
	for(var/spell_type in spell_types)
		var/obj/effect/proc_holder/spell/S = new spell_type
		M.mind?.AddSpell(S)

/datum/antagonist/wizard/arbiter/remove_innate_effects(mob/living/mob_override)
	var/mob/living/carbon/human/M = mob_override || owner.current
	remove_antag_hud(antag_hud_type, M)
	M.faction -= "Head"
	M.faction -= "hostile"
	M.faction += "neutral"
	REMOVE_TRAIT(M, TRAIT_BOMBIMMUNE, "Arbiter") // We truly are the elite agent of the Head
	REMOVE_TRAIT(M, TRAIT_STUNIMMUNE, "Arbiter")
	REMOVE_TRAIT(M, TRAIT_SLEEPIMMUNE, "Arbiter")
	REMOVE_TRAIT(M, TRAIT_PUSHIMMUNE, "Arbiter")
	REMOVE_TRAIT(M, TRAIT_IGNOREDAMAGESLOWDOWN, "Arbiter")
	REMOVE_TRAIT(M, TRAIT_NOFIRE, "Arbiter")
	REMOVE_TRAIT(M, TRAIT_NODISMEMBER, "Arbiter")
	REMOVE_TRAIT(M, TRAIT_SANITYIMMUNE, "Arbiter")
	M.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -500)

/datum/outfit/arbiter
	name = "Arbiter"

	uniform = /obj/item/clothing/under/suit/lobotomy/extraction/arbiter
	suit = /obj/item/clothing/suit/armor/extraction/arbiter
	neck = /obj/item/clothing/neck/cloak/arbiter
	shoes = /obj/item/clothing/shoes/combat
	ears = /obj/item/radio/headset/headset_head/alt
	id = /obj/item/card/id

/datum/outfit/arbiter/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/W = H.wear_id
	W.assignment = "Arbiter"
	W.registered_name = H.real_name
	W.update_label()
	..()
