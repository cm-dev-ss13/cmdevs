//toggles
/client/verb/toggle_ghost_ears()
	set name = "Show/Hide GhostEars"
	set category = "Preferences"
	set desc = ".Toggle Between seeing all mob speech, and only speech of nearby mobs"
	prefs.toggles_chat ^= CHAT_GHOSTEARS
	to_chat(src, "As a ghost, you will now [(prefs.toggles_chat & CHAT_GHOSTEARS) ? "see all speech in the world" : "only see speech from nearby mobs"].")
	prefs.save_preferences()
	feedback_add_details("admin_verb","TGE") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ghost_sight()
	set name = "Show/Hide GhostSight"
	set category = "Preferences"
	set desc = ".Toggle Between seeing all mob emotes, and only emotes of nearby mobs"
	prefs.toggles_chat ^= CHAT_GHOSTSIGHT
	to_chat(src, "As a ghost, you will now [(prefs.toggles_chat & CHAT_GHOSTSIGHT) ? "see all emotes in the world" : "only see emotes from nearby mobs"].")
	prefs.save_preferences()
	feedback_add_details("admin_verb","TGS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ghost_radio()
	set name = "Enable/Disable GhostRadio"
	set category = "Preferences"
	set desc = ".Toggle between hearing all radio chatter, or only from nearby speakers"
	prefs.toggles_chat ^= CHAT_GHOSTRADIO
	to_chat(src, "As a ghost, you will now [(prefs.toggles_chat & CHAT_GHOSTRADIO) ? "hear all radio chat in the world" : "only hear from nearby speakers"].")
	prefs.save_preferences()
	feedback_add_details("admin_verb","TGR")

/client/proc/toggle_hear_radio()
	set name = "Show/Hide RadioChatter"
	set category = "Preferences"
	set desc = "Toggle seeing radiochatter from radios and speakers"
	if(!admin_holder) return
	prefs.toggles_chat ^= CHAT_RADIO
	prefs.save_preferences()
	to_chat(usr, "You will [(prefs.toggles_chat & CHAT_RADIO) ? "now" : "no longer"] see radio chatter from radios or speakers")
	feedback_add_details("admin_verb","THR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ghost_hivemind()
	set name = "Show/Hide GhostHivemind"
	set category = "Preferences"
	set desc = ".Toggle seeing all chatter from the Xenomorph Hivemind"
	prefs.toggles_chat ^= CHAT_GHOSTHIVEMIND
	to_chat(src, "As a ghost, you will [(prefs.toggles_chat & CHAT_GHOSTHIVEMIND) ? "now see chatter from the Xenomorph Hivemind" : "no longer see chatter from the Xenomorph Hivemind"].")
	prefs.save_preferences()
	feedback_add_details("admin_verb","TGH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggleadminhelpsound()
	set name = "Hear/Silence Adminhelps"
	set category = "Preferences"
	set desc = "Toggle hearing a notification when admin PMs are recieved"
	if(!admin_holder)	return
	prefs.toggles_sound ^= SOUND_ADMINHELP
	prefs.save_preferences()
	to_chat(usr, "You will [(prefs.toggles_sound & SOUND_ADMINHELP) ? "now" : "no longer"] hear a sound when adminhelps arrive.")
	feedback_add_details("admin_verb","AHS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/deadchat() // Deadchat toggle is usable by anyone.
	set name = "Show/Hide Deadchat"
	set category = "Preferences"
	set desc ="Toggles seeing deadchat"
	prefs.toggles_chat ^= CHAT_DEAD
	prefs.save_preferences()

	if(src.admin_holder)
		to_chat(src, "You will [(prefs.toggles_chat & CHAT_DEAD) ? "now" : "no longer"] see deadchat.")
	else
		to_chat(src, "As a ghost, you will [(prefs.toggles_chat & CHAT_DEAD) ? "now" : "no longer"] see deadchat.")

	feedback_add_details("admin_verb","TDV") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggleprayers()
	set name = "Show/Hide Prayers"
	set category = "Preferences"
	set desc = "Toggles seeing prayers"
	prefs.toggles_chat ^= CHAT_PRAYER
	prefs.save_preferences()
	to_chat(src, "You will [(prefs.toggles_chat & CHAT_PRAYER) ? "now" : "no longer"] see prayerchat.")
	feedback_add_details("admin_verb","TP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggletitlemusic()
	set name = "Hear/Silence LobbyMusic"
	set category = "Preferences"
	set desc = "Toggles hearing the GameLobby music"
	prefs.toggles_sound ^= SOUND_LOBBY
	prefs.save_preferences()
	if(prefs.toggles_sound & SOUND_LOBBY)
		to_chat(src, "You will now hear music in the game lobby.")
		if(istype(mob, /mob/new_player))
			playtitlemusic()
	else
		to_chat(src, "You will no longer hear music in the game lobby.")
		if(istype(mob, /mob/new_player))
			src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // stop the jamsz
	feedback_add_details("admin_verb","TLobby") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/togglemidis()
	set name = "Silence Current Midi"
	set category = "Preferences"
	set desc = "Toggles hearing sounds uploaded by admins"
	// prefs.toggles_sound ^= SOUND_MIDI // Toggle on/off
	// prefs.save_preferences() // We won't save the change - it'll be a temporary switch instead of permanent, but they can still make it permanent in character setup.
	if(prefs.toggles_sound & SOUND_MIDI) // Not using && midi_playing here - since we can't tell how long an admin midi is, the user should always be able to turn it off at any time.
		to_chat(src, "The currently playing midi has been silenced.")
		var/sound/break_sound = sound(null, repeat = 0, wait = 0, channel = 777)
		break_sound.priority = 250
		src << break_sound	//breaks the client's sound output on channel 777
		if(src.mob.client.midi_silenced)	return
		if(midi_playing)
			total_silenced++
			message_admins("A player has silenced the currently playing midi. Total: [total_silenced] player(s).", 1)
			src.mob.client.midi_silenced = 1
			spawn(SECONDS_30) // Prevents message_admins() spam. Should match with the midi_playing_timer spawn() in playsound.dm
				src.mob.client.midi_silenced = 0
	else
		to_chat(src, "You have 'Play Admin Midis' disabled in your Character Setup, so this verb is useless to you.")
	feedback_add_details("admin_verb","TMidi") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/listen_ooc()
	set name = "Show/Hide OOC"
	set category = "Preferences"
	set desc = "Toggles seeing OutOfCharacter chat"
	prefs.toggles_chat ^= CHAT_OOC
	prefs.save_preferences()
	to_chat(src, "You will [(prefs.toggles_chat & CHAT_OOC) ? "now" : "no longer"] see messages on the OOC channel.")
	feedback_add_details("admin_verb","TOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/listen_looc()
	set name = "Show/Hide LOOC"
	set category = "Preferences"
	set desc = "Toggles seeing Local OutOfCharacter chat"
	prefs.toggles_chat ^= CHAT_LOOC
	prefs.save_preferences()

	to_chat(src, "You will [(prefs.toggles_chat & CHAT_LOOC) ? "now" : "no longer"] see messages on the LOOC channel.")
	feedback_add_details("admin_verb","TLOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/Toggle_Soundscape() //All new ambience should be added here so it works with this verb until someone better at things comes up with a fix that isn't awful
	set name = "Hear/Silence Ambience"
	set category = "Preferences"
	set desc = "Toggles hearing ambient sound effects"
	prefs.toggles_sound ^= SOUND_AMBIENCE
	prefs.save_preferences()
	if(prefs.toggles_sound & SOUND_AMBIENCE)
		to_chat(src, "You will now hear ambient sounds.")
	else
		to_chat(src, "You will no longer hear ambient sounds.")
		src << sound(null, repeat = 0, wait = 0, volume = 0, channel = 1)
		src << sound(null, repeat = 0, wait = 0, volume = 0, channel = 2)
	feedback_add_details("admin_verb","TAmbi") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

//be special
/client/verb/toggle_be_special(role in be_special_flags)
	set name = "Toggle SpecialRole Candidacy"
	set category = "Preferences"
	set desc = "Toggles which special roles you would like to be a candidate for, during events."
	var/role_flag = be_special_flags[role]
	if(!role_flag)	return
	prefs.be_special ^= role_flag
	prefs.save_preferences()
	to_chat(src, "You will [(prefs.be_special & role_flag) ? "now" : "no longer"] be considered for [role] events (where possible).")
	feedback_add_details("admin_verb","TBeSpecial") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ignore_self() // Toggle whether anything will happen when you click yourself in non-help intent
	set name = "Toggle the Ability to Hurt Yourself"
	set category = "Preferences"
	set desc = "Toggles whether clicking on yourself in non-help intent will do anything"
	prefs.ignore_self = !prefs.ignore_self
	prefs.save_preferences()
	if(prefs.ignore_self)
		to_chat(src, "Clicking on yourself in non-help intent will no longer do anything.")
	else
		to_chat(src, "Clicking on yourself in non-help intent can harm you again.")

/client/verb/toggle_help_intent_safety() // Toggle whether anything will happen when you click yourself in non-help intent
	set name = "Toggle Help Intent Safety"
	set category = "Preferences"
	set desc = "Toggles whether help intent will be harmless"
	prefs.help_intent_safety = !prefs.help_intent_safety
	prefs.save_preferences()
	if(prefs.help_intent_safety)
		to_chat(src, "Help intent will now be completely harmless.")
	else
		to_chat(src, "Help intent can perform harmful actions again.")
