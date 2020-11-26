/datum/species/yautja
	name = "Yautja"
	name_plural = "Yautja"
	icobase_source = "species_hunter"
	deform_source = "species_hunter"
	brute_mod = 0.33 //Beefy!
	burn_mod = 0.65
	reagent_tag = IS_YAUTJA
	flags = IS_WHITELISTED|HAS_SKIN_COLOR|NO_SCAN|NO_POISON
	unarmed_type = /datum/unarmed_attack/punch/strong
	secondary_unarmed_type = /datum/unarmed_attack/bite/strong
	pain_type = /datum/pain/yautja
	stamina_type = /datum/stamina/none
	blood_color = "#20d450"
	flesh_color = "#907E4A"
	speech_sounds = list('sound/voice/pred_click1.ogg', 'sound/voice/pred_click2.ogg')
	speech_chance = 100
	death_message = "clicks in agony and falls still, motionless and completely lifeless..."
	darksight = 5
	slowdown = -0.5

	timed_hug = FALSE

	heat_level_1 = 500
	heat_level_2 = 700
	heat_level_3 = 1000

	inherent_verbs = list(
		/mob/living/carbon/human/proc/pred_buy,
		/mob/living/carbon/human/proc/butcher,
		/mob/living/carbon/human/proc/mark_for_hunt,
		/mob/living/carbon/human/proc/remove_from_hunt
		)

	knock_down_reduction = 2
	stun_reduction = 2

		//Set their special slot priority

	slot_equipment_priority= list( \
		WEAR_BACK,\
		WEAR_ID,\
		WEAR_BODY,\
		WEAR_JACKET,\
		WEAR_HEAD,\
		WEAR_FEET,\
		WEAR_IN_SHOES,\
		WEAR_FACE,\
		WEAR_HANDS,\
		WEAR_EAR,\
		WEAR_EYES,\
		WEAR_IN_SCABBARD,\
		WEAR_WAIST,\
		WEAR_IN_J_STORE,\
		WEAR_IN_L_STORE,\
		WEAR_IN_R_STORE,\
		WEAR_J_STORE,\
		WEAR_IN_ACCESSORY,\
		WEAR_IN_JACKET,\
		WEAR_L_STORE,\
		WEAR_R_STORE,\
		WEAR_IN_BELT,\
		WEAR_IN_BACK\
	)

/datum/species/yautja/larva_impregnated(var/obj/item/alien_embryo/embryo)
	var/datum/hive_status/hive = hive_datum[embryo.hivenumber]

	if(!istype(hive))
		return

	if(!(XENO_STRUCTURE_NEST in hive.hive_structure_types))
		hive.hive_structure_types.Add(XENO_STRUCTURE_NEST)

	if(!(XENO_STRUCTURE_NEST in hive.hive_structures_limit))
		hive.hive_structures_limit.Add(XENO_STRUCTURE_NEST)
		hive.hive_structures_limit[XENO_STRUCTURE_NEST] = 0

	hive.hive_structure_types[XENO_STRUCTURE_NEST] = /datum/construction_template/xenomorph/nest
	hive.hive_structures_limit[XENO_STRUCTURE_NEST] += 1

/datum/species/yautja/handle_death(var/mob/living/carbon/human/H, gibbed)
	if(gibbed)
		yautja_mob_list -= H

	if(H.yautja_hunted_prey)
		H.yautja_hunted_prey = null

	// Notify all yautja so they start the gear recovery
	message_all_yautja("[H] has died at \the [get_area(H).name].")

/datum/species/yautja/post_species_loss(mob/living/carbon/human/H)
	var/datum/mob_hud/medical/advanced/A = huds[MOB_HUD_MEDICAL_ADVANCED]
	A.add_to_hud(H)
	H.blood_type = pick("A+","A-","B+","B-","O-","O+","AB+","AB-")
	yautja_mob_list -= H
	for(var/obj/limb/L in H.limbs)
		switch(L.name)
			if("groin","chest")
				L.min_broken_damage = 40
				L.max_damage = 200
			if("head")
				L.min_broken_damage = 40
				L.max_damage = 60
			if("l_hand","r_hand","r_foot","l_foot")
				L.min_broken_damage = 25
				L.max_damage = 30
			if("r_leg","r_arm","l_leg","l_arm")
				L.min_broken_damage = 30
				L.max_damage = 35
		L.time_to_knit = -1

/datum/species/yautja/handle_post_spawn(var/mob/living/carbon/human/H)
	living_human_list -= H
	H.universal_understand = 1

	H.blood_type = "Y*"
	yautja_mob_list += H
	for(var/obj/limb/L in H.limbs)
		switch(L.name)
			if("groin","chest")
				L.min_broken_damage = 80
				L.max_damage = 200
				L.time_to_knit = 1200 // 10 mins
			if("head")
				L.min_broken_damage = 70
				L.max_damage = 90
				L.time_to_knit = 1200 // 10 mins
			if("l_hand","r_hand","r_foot","l_foot")
				L.min_broken_damage = 40
				L.max_damage = 60
				L.time_to_knit = 600 // 5 mins
			if("r_leg","r_arm","l_leg","l_arm")
				L.min_broken_damage = 60
				L.max_damage = 80
				L.time_to_knit = 600 // 5 mins


	var/datum/mob_hud/medical/advanced/A = huds[MOB_HUD_MEDICAL_ADVANCED]
	A.remove_from_hud(H)
	H.set_languages(list("Sainja"))
	return ..()