boolean in_pokefam()
{
	return auto_my_path() == "Pocket Familiars";
}

void pokefam_initializeDay(int day)
{
	pokefam_makeTeam();
}

void pokefam_initializeSettings()
{
	if(in_pokefam())
	{
		set_property("auto_hippyInstead", true);
		set_property("auto_ignoreFlyer", true);
		set_property("auto_wandOfNagamar", false);
	}
}

string pokefam_defaultMaximizeStatement()
{
	// combat is completely different in pokefam, so most stuff doesn't matter there
	string res = "5item,meat";
	if(my_level() < 13 || get_property("auto_disregardInstantKarma").to_boolean())
	{
		res += ",10exp,5" + my_primestat() + " experience percent";
	}
	return res;
}

boolean pokefam_makeTeam()
{
	if(in_pokefam())
	{
		// choose "strongest 2" in order to allow a middle spot for a pocket familiar to level up
		if(svn_info("Ezandora-Helix-Fossil-branches-Release").revision > 0)
		{
		auto_log_info("Setting our team via Ezandora:", "green");
		boolean ignore = cli_execute("PocketFamiliarsAutoSelect Strongest 2;");
		return true;
		}
	}	
	return true;
}

boolean pokefam_autoAdv(int num, location loc, string option)
{
	if(!in_pokefam())
	{
		abort("You are not in a Pocket Familiars run.");
	}

	if(option == "")
	{
		#Yeah, this is not a thing right now.
	}

#	boolean retval = adv1(loc, 0, option);
	string temp = visit_url(to_url(loc), false);

	if (get_property("pyramidBombUsed").to_boolean() && in_pokefam() && loc == $location[The Lower Chambers])
	{
		temp = visit_url(to_url(loc) + "a", false);
	}

	auto_log_info("Preparing battle script.", "green");
	temp = visit_url("fambattle.php");
	int choiceLimiter = 0;
	while(contains_text(temp, "whichchoice value=") || contains_text(temp, "whichchoice="))
	{
		auto_log_warning("Autoscend hit a choice adventure (" + loc + "), trying....", "red");
		matcher choice_matcher = create_matcher("(?:whichchoice value=(\\d+))|(?:whichchoice=(\\d+))", temp);
		if(choice_matcher.find())
		{
			int choice = choice_matcher.group(1).to_int();
			if(choice == 0)
			{
				choice = choice_matcher.group(2).to_int();
			}

			if($ints[89, 890, 891, 892, 893, 894, 895, 896, 897, 898, 899, 900, 901, 902, 903, 914] contains choice)
			{
				return adv1(loc, -1, option);
			}

			temp = visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=" + choice + "&option=" + get_property("choiceAdventure" + choice).to_int());
		}
		choiceLimiter += 1;
		if(choiceLimiter > 5)
		{
			abort("Choice chain too long or I'm stuck!");
		}
	}
	temp = visit_url("fambattle.php");

	if(!contains_text(temp, "Fight!"))
	{
		return false;
	}

	if(svn_info("Ezandora-Helix-Fossil-branches-Release").revision > 0)
	{
		auto_log_info("Consulting Ezandora's Helix Fossil script:", "green");
		boolean ignore = cli_execute("ashq import 'Pocket Familiars'; buffer temp = PocketFamiliarsFight();");
		if($locations[The Defiled Alcove, The Defiled Cranny, The Defiled Niche, The Defiled Nook] contains my_location())
		{
			if(item_amount($item[Evilometer]) > 0)
			{
				use(1, $item[Evilometer]);
			}
		}
		cli_execute("auto_post_adv");
		return true;
	}

	if(get_property("_pokefamFront") == "")
	{
		set_property("_pokefamFront", my_poke_fam(0));
	}
	if(get_property("_pokefamMiddle") == "")
	{
		set_property("_pokefamMiddle", my_poke_fam(1));
	}
	if(get_property("_pokefamBack") == "")
	{
		set_property("_pokefamBack", my_poke_fam(2));
	}


	familiar blastFam = to_familiar(get_property("_pokefamBack"));
	familiar midFam = to_familiar(get_property("_pokefamMiddle"));	

	if(contains_text(temp, "famaction[ult_crazyblast-" + to_int(blastFam) + "]"))
	{
		temp = visit_url("fambattle.php?pwd&famaction[ult_crazyblast-" + to_int(blastFam) + "]=ULTIMATE%3A+Spiky+Burst");
	}
	else
	{
		temp = visit_url("fambattle.php?pwd&famaction[backstab-" + to_int(blastFam) + "]=Backstab");
	}
	int action = 1;


	while(!contains_text(temp, "<!--WINWINWIN-->"))
	{
		if((action & 1) == 1)
		{
			temp = visit_url("fambattle.php?pwd&famaction[backstab-" + to_int(midFam) + "]=Backstab");
		}
		else
		{
			temp = visit_url("fambattle.php?pwd&famaction[backstab-" + to_int(blastFam) + "]=Backstab");
		}
		action++;
		if(contains_text(temp, "dejected and defeated"))
		{
			break;
		}
		if(action > 40)
		{
			abort("Can not win this Pocket Familiars battle!");
		}
	}

	if($locations[The Defiled Alcove, The Defiled Cranny, The Defiled Niche, The Defiled Nook] contains my_location())
	{
		if(item_amount($item[Evilometer]) > 0)
		{
			use(1, $item[Evilometer]);
		}
	}
	cli_execute("auto_post_adv");
	return true;
}
