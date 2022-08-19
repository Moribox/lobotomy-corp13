/mob/living/simple_animal/hostile/abnormality/scorched_girl
	name = "Scorched girl"
	desc = "An abnormality resembling a girl burnt to ashes. \
	Even though there's nothing left to burn, the fire still doesn't extinguish."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "scorched"
	icon_living = "scorched"
	maxHealth = 400
	health = 400
	threat_level = TETH_LEVEL
	stat_attack = HARD_CRIT
	ranged = TRUE
	speed = 3
	vision_range = 12
	aggro_vision_range = 24
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 40,
		ABNORMALITY_WORK_INSIGHT = list(60, 60, 50, 50, 50),
		ABNORMALITY_WORK_ATTACHMENT = list(30, 15, 0, -40, -50),
		ABNORMALITY_WORK_REPRESSION = list(50, 50, 40, 40, 40)
		)
	work_damage_amount = 6
	work_damage_type = RED_DAMAGE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 2, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	faction = list("hostile")
	can_breach = TRUE
	start_qliphoth = 2

	ego_list = list(
		/datum/ego_datum/weapon/match,
		/datum/ego_datum/armor/match
		)
	gift_type =  /datum/ego_gifts/match
	/// Restrict movement when this is set to TRUE
	var/exploding = FALSE
	/// Current cooldown for the players
	var/boom_cooldown
	/// Amount of RED damage done on explosion
	var/boom_damage = 250

/mob/living/simple_animal/hostile/abnormality/scorched_girl/OpenFire()
	if(client)
		explode()
		return

	var/amount_inview = 0
	for(var/mob/living/carbon/human/H in view(7, src))
		amount_inview += 1
	if(prob(amount_inview*20))
		explode()

/mob/living/simple_animal/hostile/abnormality/scorched_girl/Move()
	if(exploding)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/scorched_girl/CanAttack(atom/the_target)
	if(ishuman(the_target))
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/abnormality/scorched_girl/AttackingTarget(atom/attacked_target)
	explode()
	return

/mob/living/simple_animal/hostile/abnormality/scorched_girl/proc/explode()
	if(boom_cooldown > world.time) // That's only for players
		return
	boom_cooldown = world.time + 3 SECONDS
	playsound(get_turf(src), 'sound/abnormalities/scorchedgirl/pre_ability.ogg', 50, 0, 2)
	if(client)
		if(!do_after(src, 1.5 SECONDS, target = src))
			return
	else
		SLEEP_CHECK_DEATH(1.5 SECONDS)
	exploding = TRUE
	playsound(get_turf(src), 'sound/abnormalities/scorchedgirl/ability.ogg', 60, 0, 4)
	SLEEP_CHECK_DEATH(3 SECONDS)
	// Ka-boom
	playsound(get_turf(src), 'sound/abnormalities/scorchedgirl/explosion.ogg', 125, 0, 8)
	for(var/mob/living/carbon/human/H in view(7, src))
		H.apply_damage(boom_damage, RED_DAMAGE, null, H.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		if(H.health < 0)
			H.gib()
	new /obj/effect/temp_visual/explosion(get_turf(src))
	var/datum/effect_system/smoke_spread/S = new
	S.set_up(7, get_turf(src))
	S.start()
	qdel(src)

/mob/living/simple_animal/hostile/abnormality/scorched_girl/neutral_effect(mob/living/carbon/human/user, work_type, pe)
	if(prob(40))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/scorched_girl/failure_effect(mob/living/carbon/human/user, work_type, pe)
	if(prob(80))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/scorched_girl/breach_effect(mob/living/carbon/human/user)
	..()
	boom_cooldown = world.time + 5 SECONDS // So it doesn't instantly explode
	update_icon()
	GiveTarget(user)

/mob/living/simple_animal/hostile/abnormality/scorched_girl/update_icon_state()
	if(status_flags & GODMODE) // Not breaching
		icon_state = initial(icon)
	else // Breaching
		icon_state = "scorched_breach"
	icon_living = icon_state


