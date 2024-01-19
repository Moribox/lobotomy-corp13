// "Scavenger" Tree Skills
// A "resource/money" Focused tree

// level 1
//Scurry, [ This code is literally just the code for assault with changed variables , credits to Ender for writing it.]
/obj/item/book/granter/action/skill/scurry
	granted_action = /datum/action/cooldown/scurry
	name = "Level 1 Scavenger Skill: Run"
	actionname = "Scurry"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/scurry
	cooldown_time = 200
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "Run"


/datum/action/cooldown/scurry/Trigger()
	. = ..()
	if(!.)
		return FALSE
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		human.add_movespeed_modifier(/datum/movespeed_modifier/scurry)
		addtimer(CALLBACK(human, .mob/proc/remove_movespeed_modifier, /datum/movespeed_modifier/scurry), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		StartCooldown()

/datum/movespeed_modifier/scurry
	variable = TRUE
	multiplicative_slowdown = -0.1


// level 2
// level 3
// level 4
