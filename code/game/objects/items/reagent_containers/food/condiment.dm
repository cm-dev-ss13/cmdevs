
///////////////////////////////////////////////Condiments
//Notes by Darem: The condiments food-subtype is for stuff you don't actually eat but you use to modify existing food. They all
//	leave empty containers when used up and can be filled/re-filled with other items. Formatting for first section is identical
//	to mixed-drinks code. If you want an object that starts pre-loaded, you need to make it in addition to the other code.

//Food items that aren't eaten normally and leave an empty container behind.
/obj/item/reagent_container/food/condiment
	name = "Condiment Container"
	desc = "Just your average condiment container."
	icon = 'icons/obj/items/food.dmi'
	icon_state = "emptycondiment"
	flags_atom = FPRINT|OPENCONTAINER
	possible_transfer_amounts = list(1,5,10)
	center_of_mass = list("x"=16, "y"=6)
	volume = 50

	attackby(obj/item/W as obj, mob/user as mob)

		return
	attack_self(mob/user as mob)
		return
	attack(mob/M as mob, mob/user as mob, def_zone)
		var/datum/reagents/R = src.reagents

		if(!R || !R.total_volume)
			to_chat(user, "<span class='danger'>The [src.name] is empty!</span>")
			return 0

		if(M == user)
			to_chat(M, SPAN_NOTICE(" You swallow some of contents of the [src]."))
			if(reagents.total_volume)
				reagents.trans_to_ingest(M, 10)

			playsound(M.loc,'sound/items/drink.ogg', 15, 1)
			return 1
		else if( istype(M, /mob/living/carbon/human) )

			for(var/mob/O in viewers(world.view, user))
				O.show_message(SPAN_DANGER("[user] attempts to feed [M] [src]."), 1)
			if(!do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, M)) return
			for(var/mob/O in viewers(world.view, user))
				O.show_message("<span class='danger'>[user] feeds [M] [src].</span>", 1)

			var/rgt_list_text = get_reagent_list_text()

			M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [src.name] by [user.name] ([user.ckey]) Reagents: [rgt_list_text]</font>")
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [src.name] by [M.name] ([M.ckey]) Reagents: [rgt_list_text]</font>")
			msg_admin_attack("[user.name] ([user.ckey]) fed [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

			if(reagents.total_volume)
				reagents.trans_to_ingest(M, 10)

			playsound(M.loc,'sound/items/drink.ogg', 15, 1)
			return 1
		return 0

	attackby(obj/item/I as obj, mob/user as mob)

		return

	afterattack(obj/target, mob/user , flag)
		if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.

			if(!target.reagents.total_volume)
				to_chat(user, "<span class='danger'>[target] is empty.</span>")
				return

			if(reagents.total_volume >= reagents.maximum_volume)
				to_chat(user, "<span class='danger'>[src] is full.</span>")
				return

			var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)
			to_chat(user, SPAN_NOTICE(" You fill [src] with [trans] units of the contents of [target]."))

		//Something like a glass or a food item. Player probably wants to transfer TO it.
		else if(target.is_open_container() || istype(target, /obj/item/reagent_container/food/snacks))
			if(!reagents.total_volume)
				to_chat(user, "<span class='danger'>[src] is empty.</span>")
				return
			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				to_chat(user, "<span class='danger'>you can't add anymore to [target].</span>")
				return
			var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
			to_chat(user, SPAN_NOTICE(" You transfer [trans] units of the condiment to [target]."))

	on_reagent_change()
		if(icon_state == "saltshakersmall" || icon_state == "peppermillsmall")
			return
		if(reagents.reagent_list.len > 0)
			switch(reagents.get_master_reagent_id())
				if("ketchup")
					name = "Ketchup"
					desc = "You feel more American already."
					icon_state = "ketchup"
					center_of_mass = list("x"=16, "y"=6)
				if("capsaicin")
					name = "Hotsauce"
					desc = "You can almost TASTE the stomach ulcers now!"
					icon_state = "hotsauce"
					center_of_mass = list("x"=16, "y"=6)
				if("enzyme")
					name = "Universal Enzyme"
					desc = "Used in cooking various dishes."
					icon_state = "enzyme"
					center_of_mass = list("x"=16, "y"=6)
				if("soysauce")
					name = "Soy Sauce"
					desc = "A salty soy-based flavoring."
					icon_state = "soysauce"
					center_of_mass = list("x"=16, "y"=6)
				if("frostoil")
					name = "Coldsauce"
					desc = "Leaves the tongue numb in its passage."
					icon_state = "coldsauce"
					center_of_mass = list("x"=16, "y"=6)
				if("sodiumchloride")
					name = "Salt Shaker"
					desc = "Salt. From space oceans, presumably."
					icon_state = "saltshaker"
					center_of_mass = list("x"=16, "y"=10)
				if("blackpepper")
					name = "Pepper Mill"
					desc = "Often used to flavor food or make people sneeze."
					icon_state = "peppermillsmall"
					center_of_mass = list("x"=16, "y"=10)
				if("cornoil")
					name = "Corn Oil"
					desc = "A delicious oil used in cooking. Made from corn."
					icon_state = "oliveoil"
					center_of_mass = list("x"=16, "y"=6)
				if("sugar")
					name = "Sugar"
					desc = "Tastey space sugar!"
					center_of_mass = list("x"=16, "y"=6)
				else
					name = "Misc Condiment Bottle"
					if (reagents.reagent_list.len==1)
						desc = "Looks like it is [reagents.get_master_reagent_name()], but you are not sure."
					else
						desc = "A mixture of various condiments. [reagents.get_master_reagent_name()] is one of them."
					icon_state = "mixedcondiments"
					center_of_mass = list("x"=16, "y"=6)
		else
			icon_state = "emptycondiment"
			name = "Condiment Bottle"
			desc = "An empty condiment bottle."
			center_of_mass = list("x"=16, "y"=6)
			return

/obj/item/reagent_container/food/condiment/enzyme
	name = "Universal Enzyme"
	desc = "Used in cooking various dishes."
	icon_state = "enzyme"
	New()
		..()
		reagents.add_reagent("enzyme", 50)

/obj/item/reagent_container/food/condiment/sugar
	New()
		..()
		reagents.add_reagent("sugar", 50)

/obj/item/reagent_container/food/condiment/saltshaker		//Seperate from above since it's a small shaker rather then
	name = "Salt Shaker"											//	a large one.
	desc = "Salt. From space oceans, presumably."
	icon_state = "saltshakersmall"
	possible_transfer_amounts = list(1,20) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 20
	New()
		..()
		reagents.add_reagent("sodiumchloride", 20)

/obj/item/reagent_container/food/condiment/peppermill
	name = "Pepper Mill"
	desc = "Often used to flavor food or make people sneeze."
	icon_state = "peppermillsmall"
	possible_transfer_amounts = list(1,20) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 20
	New()
		..()
		reagents.add_reagent("blackpepper", 20)