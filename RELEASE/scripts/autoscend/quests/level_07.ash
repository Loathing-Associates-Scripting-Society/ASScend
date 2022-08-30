void cyrptChoiceHandler(int choice)
{
	if(choice == 153) // Turn Your Head and Coffin (The Defiled Alcove)
	{
		if(my_meat() < 1000 + meatReserve())
		{
			run_choice(2); // get meat if needed
		}
		else
		{
			run_choice(4); // skip
		}
	}
	else if(choice == 155) // Skull, Skull, Skull (The Defiled Nook)
	{
		if(in_zombieSlayer() && (item_amount($item[talkative skull]) == 0 || !have_familiar($familiar[Hovering Skull])))
		{
			run_choice(1); // get talkative skull
		}
		else if(my_meat() < 1000 + meatReserve())
		{
			run_choice(2); // get meat if needed
		}
		else
		{
			run_choice(5); // skip
		}
	}
	else if(choice == 157) // Urning Your Keep (The Defiled Niche)
	{
		if(my_meat() < 1000 + meatReserve())
		{
			run_choice(3); // get meat if needed
		}
		else
		{
			run_choice(4); // skip
		}
	}
	else if(choice == 523) // Death Rattlin' (The Defiled Cranny)
	{
		if(in_darkGyffte() && have_skill($skill[Flock of Bats Form]) && have_skill($skill[Sharp Eyes]))
		{
			int desired_pills = in_hardcore() ? 6 : 4;
			desired_pills -= my_fullness()/2;
			auto_log_info("We want " + desired_pills + " dieting pills and have " + item_amount($item[dieting pill]), "blue");
			if(item_amount($item[dieting pill]) < desired_pills)
			{
				if(!bat_wantHowl($location[The Defiled Cranny]))
				{
					bat_formBats();
				}
			}
			run_choice(5); // if meets thresholds, skip to farm more dieting pills in DG
		}
		else
		{
			run_choice(4); // fight swarm of ghuol whelps
		}
	}
	else if(choice == 527) // The Haert of Darkness (The Cyrpt)
	{
		run_choice(1); // fight whichever version of the bonerdagon
	}
	else
	{
		abort("unhandled choice in cyrptChoiceHandler");
	}
}

int cyrptEvilBonus()
{
	//returns value of regularly available bonus to evil reduction
	int cyrptBonus = (auto_hasRetrocape() && auto_forceEquipSword(true)) ? 1 : 0;
	cyrptBonus += (possessEquipment($item[gravy boat]) && auto_is_valid($item[gravy boat])) ? 1 : 0;
	cyrptBonus += (is_pete() && get_property("peteMotorbikeCowling") == "Ghost Vacuum") ? 1 : 0;
	return cyrptBonus;
}

boolean L7_crypt()
{
	if(internalQuestStatus("questL07Cyrptic") != 0)
	{
		return false;
	}
	if(item_amount($item[chest of the bonerdagon]) == 1)
	{
		equipStatgainIncreasers();
		use(1, $item[chest of the bonerdagon]);
		return false;
	}
	oldPeoplePlantStuff();

	if(my_mp() > 60)
	{
		handleBjornify($familiar[Grimstone Golem]);
	}

	buffMaintain($effect[Browbeaten]);
	buffMaintain($effect[Rosewater Mark]);

	boolean edAlcove = true;
	if(isActuallyEd())
	{
		edAlcove = (have_skill($skill[More Legs]) && (expected_damage($monster[modern zmobie]) + 15) < my_maxhp());
	}

	if((get_property("romanticTarget") != $monster[modern zmobie]) && (get_property("auto_waitingArrowAlcove").to_int() < 50))
	{
		set_property("auto_waitingArrowAlcove", 50);
	}

	void useNightmareFuelIfPossible()
	{
		// chews this when there are no guaranteed uses for spleen 
		if((spleen_left() > 0) && (item_amount($item[Nightmare Fuel]) > 0) && !isActuallyEd() && 
		!(auto_havePillKeeper() && spleen_left() >= 3) && 
		(spleen_left() > 4*min(auto_spleenFamiliarAdvItemsPossessed(),floor(spleen_left()/4)))) // only uses space than can't be filled with adv item
		{
			autoChew(1, $item[Nightmare Fuel]);
		}
	}

	void knockOffCapePrep()
	{
		if(auto_configureRetrocape("vampire", "kill"))
		{
			if(have_effect($effect[Iron Palms]) > 0 && auto_have_skill($skill[Iron Palm Technique]))
			{
				//slay the dead needs the sword to count as a sword and not as a club
				use_skill(1, $skill[Iron Palm Technique]);
			}
			auto_forceEquipSword();
		}
	}

	// make sure quest status is correct before we attempt to adventure.
	visit_url("crypt.php");
	use(1, $item[Evilometer]);

	int evilBonus = cyrptEvilBonus();

	if((get_property("cyrptAlcoveEvilness").to_int() > 0) && ((get_property("cyrptAlcoveEvilness").to_int() <= get_property("auto_waitingArrowAlcove").to_int()) || (get_property("cyrptAlcoveEvilness").to_int() <= 25)) && edAlcove && lar_repeat($location[The Defiled Alcove]))
	{

		if((get_property("_badlyRomanticArrows").to_int() == 0) && auto_have_familiar($familiar[Reanimated Reanimator]) && (my_daycount() == 1))
		{
			handleFamiliar($familiar[Reanimated Reanimator]);
		}

		if(get_property("cyrptAlcoveEvilness").to_int() > (26 + evilBonus))
		{
			provideInitiative(850, $location[The Defiled Alcove], true);
			addToMaximize("100initiative 850max");
		}

		autoEquip($item[Gravy Boat]);
		knockOffCapePrep();

		if(get_property("cyrptAlcoveEvilness").to_int() >= (28 + evilBonus))
		{
			useNightmareFuelIfPossible();
		}

		auto_log_info("The Alcove! (" + initiative_modifier() + ")", "blue");
		return autoAdv($location[The Defiled Alcove]);
	}
	// current mafia bug causes us to lose track of the amount of Evil Eyes in inventory so adding a refresh here
	cli_execute("refresh inv");
	// in KoE, skeleton astronauts are random encounters that drop Evil Eyes.
	// we might be able to reach the Nook boss without adventuring.

	while((item_amount($item[Evil Eye]) > 0) && auto_is_valid($item[Evil Eye]) && (get_property("cyrptNookEvilness").to_int() > 25))
	{
		use(1, $item[Evil Eye]);
	}

	boolean skip_in_koe = in_koe() && (get_property("cyrptNookEvilness").to_int() > 25) && get_property("questL12HippyFrat") != "finished";

	if((get_property("cyrptNookEvilness").to_int() > 0) && lar_repeat($location[The Defiled Nook]) && !skip_in_koe)
	{
		auto_log_info("The Nook!", "blue");
		autoEquip($item[Gravy Boat]);
		knockOffCapePrep();

		if(get_property("cyrptNookEvilness").to_int() > (26 + evilBonus) && auto_is_valid($item[Evil Eye]))
		{
			buffMaintain($effect[Joyful Resolve]);
			bat_formBats();
			januaryToteAcquire($item[broken champagne bottle]);
		}

		return autoAdv($location[The Defiled Nook]);
	}
	else if(skip_in_koe)
	{
		auto_log_debug("In Exploathing, skipping Defiled Nook until we get more evil eyes.");
	}

	if((get_property("cyrptNicheEvilness").to_int() > 0) && lar_repeat($location[The Defiled Niche]))
	{
		if((my_daycount() == 1) && (get_property("_hipsterAdv").to_int() < 7) && is_unrestricted($familiar[Artistic Goth Kid]) && auto_have_familiar($familiar[Artistic Goth Kid]))
		{
			handleFamiliar($familiar[Artistic Goth Kid]);
		}
		autoEquip($item[Gravy Boat]);

		// prioritize extinguisher over slay the dead in Defiled Niche if its available and unused in the cyrpt
		if(auto_FireExtinguisherCombatString($location[The Defiled Niche]) == "")
		{
			knockOffCapePrep();
		}
		
		if(auto_have_familiar($familiar[Space Jellyfish]) && (get_property("_spaceJellyfishDrops").to_int() < 3))
		{
			handleFamiliar($familiar[Space Jellyfish]);
		}

		if(get_property("cyrptNicheEvilness").to_int() >= (28 + evilBonus))
		{
			useNightmareFuelIfPossible();
		}

		auto_log_info("The Niche!", "blue");
		if(canSniff($monster[Dirty Old Lihc], $location[The Defiled Niche]) && get_property("cyrptNicheEvilness").to_int() >= (26 + evilBonus) && auto_mapTheMonsters())
		{
			auto_log_info("Attemping to use Map the Monsters to olfact a Dirty Old Lihc.");
		}
		return autoAdv($location[The Defiled Niche]);
	}

	if(get_property("cyrptCrannyEvilness").to_int() > 0)
	{
		auto_log_info("The Cranny!", "blue");

		if(my_mp() > 60)
		{
			handleBjornify($familiar[Grimstone Golem]);
		}

		autoEquip($item[Gravy Boat]);
		knockOffCapePrep();

		if(auto_is_valid($effect[Emotional Vaccine]))
		{
			spacegateVaccine($effect[Emotional Vaccine]);
		}

		if(auto_have_familiar($familiar[Space Jellyfish]) && (get_property("_spaceJellyfishDrops").to_int() < 3))
		{
			handleFamiliar($familiar[Space Jellyfish]);
		}

		if(get_property("cyrptCrannyEvilness").to_int() >= (28 + evilBonus))
		{
			useNightmareFuelIfPossible();
		}

		auto_MaxMLToCap(auto_convertDesiredML(149), true);

		addToMaximize("200ml " + auto_convertDesiredML(149) + "max");
		return autoAdv($location[The Defiled Cranny]);
	}

	if(get_property("cyrptTotalEvilness").to_int() <= 0)
	{
		if(my_class() == $class[seal clubber] && auto_have_skill($skill[Iron Palm Technique]) && (have_effect($effect[Iron Palms]) == 0))
		{
			//if this was toggled off for retrocape slay the dead it can be toggled back on now
			use_skill(1, $skill[Iron Palm Technique]);
		}
		
		if(my_primestat() == $stat[Muscle])
		{
			buyUpTo(1, $item[Ben-Gal&trade; Balm]);
			buffMaintain($effect[Go Get \'Em\, Tiger!]);
			buyUpTo(1, $item[Blood of the Wereseal]);
			buffMaintain($effect[Temporary Lycanthropy]);
		}

		acquireHP();
		if(auto_have_familiar($familiar[Machine Elf]))
		{
			handleFamiliar($familiar[Machine Elf]);
		}
		auto_change_mcd(10); // get vertebra to make the necklace.
		boolean tryBoner = autoAdv(1, $location[Haert of the Cyrpt]);
		council();
		cli_execute("refresh quests");
		if(item_amount($item[chest of the bonerdagon]) == 1)
		{
			equipStatgainIncreasers();
			use(1, $item[chest of the bonerdagon]);
			auto_badassBelt(); // mafia doesn't make this any more even if autoCraft = true for some random reason so lets do it manually.
		}
		else if(get_property("questL07Cyrptic") == "finished")
		{
			auto_log_warning("Looks like we don't have the chest of the bonerdagon but KoLmafia marked Cyrpt quest as finished anyway. Probably some weird path shenanigans.", "red");
		}
		else if(!tryBoner)
		{
			auto_log_warning("We tried to kill the Bonerdagon because the cyrpt was defiled but couldn't adventure there and the chest of the bonerdagon is gone so we can't check that. Anyway, we are going to assume the cyrpt is done now.", "red");
		}
		else
		{
			abort("Failed to kill bonerdagon");
		}
		return true;
	}
	return false;
}

boolean L7_override()
{
	//check if olfaction or banishes are being used for ongoing L7 tasks and give those priority
 	if(internalQuestStatus("questL07Cyrptic") != 0)
	{
		return false;
	}
	
	if(get_property("cyrptNookEvilness").to_int() <= 26 && get_property("cyrptNicheEvilness").to_int() <= 26)
	{
		return false;
	}
	
	int evilBonus = cyrptEvilBonus();
	if(get_property("cyrptNookEvilness").to_int() > (26 + evilBonus) && is_banished($monster[party skelteon]))
	{
		auto_log_info("Trying to check on the ongoing Nook before moving on to a different task");
		if(L7_crypt()) { return true; }
	}
	if(get_property("cyrptNicheEvilness").to_int() > (26 + evilBonus))
	{
		boolean lihcbanihced = is_banished($monster[basic lihc]) || is_banished($monster[Senile Lihc]) || is_banished($monster[Slick Lihc]);
		if(lihcbanihced || isSniffed($monster[Dirty Old Lihc]))
		{
			auto_log_info("Trying to check on the ongoing Niche before moving on to a different task");
			if(L7_crypt()) { return true; }
		}
	}
	return false;
}
