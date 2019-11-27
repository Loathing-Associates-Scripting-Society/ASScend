script "autoscend.ash";
since r19599; // In Kingdom of Exploathing, mark the Palindome quest as started as soon as you make the Talisman o' Namsilat.
/***
	autoscend_header.ash must be first import
	All non-accessory scripts must be imported here

	Accessory scripts can import autoscend.ash

***/


import <autoscend/autoscend_header.ash>
import <autoscend/autoscend_migration.ash>
import <canadv.ash>
import <autoscend/auto_restore.ash>
import <autoscend/auto_util.ash>
import <autoscend/auto_deprecation.ash>
import <autoscend/auto_combat.ash>
import <autoscend/auto_floristfriar.ash>
import <autoscend/auto_equipment.ash>
import <autoscend/auto_eudora.ash>
import <autoscend/auto_elementalPlanes.ash>
import <autoscend/auto_clan.ash>
import <autoscend/auto_cooking.ash>
import <autoscend/auto_adventure.ash>
import <autoscend/auto_mr2012.ash>
import <autoscend/auto_mr2013.ash>
import <autoscend/auto_mr2014.ash>
import <autoscend/auto_mr2015.ash>
import <autoscend/auto_mr2016.ash>
import <autoscend/auto_mr2017.ash>
import <autoscend/auto_mr2018.ash>
import <autoscend/auto_mr2019.ash>

import <autoscend/auto_boris.ash>
import <autoscend/auto_jellonewbie.ash>
import <autoscend/auto_fallout.ash>
import <autoscend/auto_community_service.ash>
import <autoscend/auto_sneakypete.ash>
import <autoscend/auto_heavyrains.ash>
import <autoscend/auto_picky.ash>
import <autoscend/auto_standard.ash>
import <autoscend/auto_edTheUndying.ash>
import <autoscend/auto_summerfun.ash>
import <autoscend/auto_awol.ash>
import <autoscend/auto_bondmember.ash>
import <autoscend/auto_groundhog.ash>
import <autoscend/auto_digimon.ash>
import <autoscend/auto_majora.ash>
import <autoscend/auto_glover.ash>
import <autoscend/auto_batpath.ash>
import <autoscend/auto_tcrs.ash>
import <autoscend/auto_koe.ash>
import <autoscend/auto_monsterparts.ash>
import <autoscend/auto_theSource.ash>
import <autoscend/auto_optionals.ash>
import <autoscend/auto_list.ash>
import <autoscend/auto_zlib.ash>
import <autoscend/auto_zone.ash>


void initializeSettings()
{
	if(my_ascensions() <= get_property("auto_doneInitialize").to_int())
	{
		return;
	}
	set_location($location[none]);
	invalidateRestoreOptionCache();

	set_property("auto_useCubeling", true);
	set_property("auto_100familiar", $familiar[none]);
	if(my_familiar() != $familiar[none])
	{
		boolean userAnswer = user_confirm("Familiar already set, is this a 100% familiar run? Will default to 'No' in 15 seconds.", 15000, false);
		if(userAnswer)
		{
			set_property("auto_100familiar", my_familiar());
		}
		if(is100FamiliarRun())
		{
			set_property("auto_useCubeling", false);
		}
	}

	if(!is100FamiliarRun() && auto_have_familiar($familiar[Crimbo Shrub]))
	{
		use_familiar($familiar[Crimbo Shrub]);
		use_familiar($familiar[none]);
	}

	string pool = visit_url("questlog.php?which=3");
	matcher my_pool = create_matcher("a skill level of (\\d+) at shooting pool", pool);
	if(my_pool.find() && (my_turncount() == 0))
	{
		int curSkill = to_int(my_pool.group(1));
		int sharkCountMin = ceil((curSkill * curSkill) / 4);
		int sharkCountMax = ceil((curSkill + 1) * (curSkill + 1) / 4);
		if(get_property("poolSharkCount").to_int() < sharkCountMin || get_property("poolSharkCount").to_int() >= sharkCountMax)
		{
			auto_log_warning("poolSharkCount set to incorrect value.", "red");
			auto_log_info("You can \"set poolSharkCount="+sharkCountMin+"\" to use the least optimistic value consistent with your pool skill.", "blue");
		}
	}

	set_property("auto_abooclover", true);
	set_property("auto_aboopending", 0);
	set_property("auto_aftercore", false);
	set_property("auto_airship", "");
	set_property("auto_ballroom", "");
	set_property("auto_ballroomflat", "");
	set_property("auto_ballroomopen", "");
	set_property("auto_ballroomsong", "");
	set_property("auto_banishes", "");
	set_property("auto_bat", "");
	set_property("auto_batoomerangDay", 0);
	set_property("auto_bean", false);
	set_property("auto_beatenUpCount", 0);
	set_property("auto_getBeehive", false);
	set_property("auto_blackfam", true);
	set_property("auto_blackmap", "");
	set_property("auto_boopeak", "");
	set_property("auto_breakstone", get_property("auto_pvpEnable").to_boolean());
	set_property("auto_bruteForcePalindome", false);
	set_property("auto_cabinetsencountered", 0);
	set_property("auto_castlebasement", "");
	set_property("auto_castleground", "");
	set_property("auto_castletop", "");
	set_property("auto_chasmBusted", true);
	set_property("auto_chewed", "");
	set_property("auto_clanstuff", "0");
	set_property("auto_combatHandler", "");
	set_property("auto_consumption", "");
	set_property("auto_cookie", -1);
	set_property("auto_copies", "");
	set_property("auto_copperhead", 0);
	set_property("auto_crackpotjar", "");
	set_property("auto_crypt", "");
	set_property("auto_cubeItems", true);
	set_property("auto_dakotaFanning", false);
	set_property("auto_day_init", 0);
	set_property("auto_day1_cobb", "");
	set_property("auto_day1_dna", "");
	set_property("auto_debuffAsdonDelay", 0);
	set_property("auto_disableAdventureHandling", false);
	set_property("auto_doCombatCopy", "no");
	set_property("auto_drunken", "");
	set_property("auto_eaten", "");
	set_property("auto_familiarChoice", $familiar[none]);
	set_property("auto_fcle", "");
	set_property("auto_forceTavern", false);
	set_property("auto_friars", "");
	set_property("auto_funTracker", "");
	set_property("auto_getBoningKnife", false);
	set_property("auto_getStarKey", false);
	set_property("auto_getSteelOrgan", get_property("auto_alwaysGetSteelOrgan").to_boolean());
	set_property("auto_gnasirUnlocked", false);
	set_property("auto_goblinking", "");
	set_property("auto_gremlins", "");
	set_property("auto_gremlinBanishes", "");
	set_property("auto_grimstoneFancyOilPainting", true);
	set_property("auto_grimstoneOrnateDowsingRod", true);
	set_property("auto_gunpowder", "");
	set_property("auto_haveoven", false);
	set_property("auto_haveSourceTerminal", false);
	set_property("auto_hedge", "fast");
	set_property("auto_hiddenapartment", "0");
	set_property("auto_hiddenbowling", "");
	set_property("auto_hiddencity", "");
	set_property("auto_hiddenhospital", "");
	set_property("auto_hiddenoffice", "");
	set_property("auto_hiddenunlock", "");
	set_property("auto_hiddenzones", "");
	set_property("auto_highlandlord", "");
	set_property("auto_hippyInstead", false);
	set_property("auto_holeinthesky", true);
	set_property("auto_ignoreCombat", "");
	set_property("auto_ignoreFlyer", false);
	set_property("auto_instakill", "");
	set_property("auto_masonryWall", false);
	set_property("auto_mcmuffin", "");
	set_property("auto_mistypeak", "");
	set_property("auto_modernzmobiecount", "");
	set_property("auto_mosquito", "");
	set_property("auto_nuns", "");
	set_property("auto_oilpeak", "");
	set_property("auto_orchard", "");
	set_property("auto_otherstuff", "");
	set_property("auto_palindome", "");
	set_property("auto_paranoia", -1);
	set_property("auto_paranoia_counter", 0);
	set_property("auto_phatloot", "");
	set_property("auto_prewar", "");
	set_property("auto_prehippy", "");
	set_property("auto_pirateoutfit", "");
	set_property("auto_priorCharpaneMode", "0");
	set_property("auto_powerLevelLastLevel", "0");
	set_property("auto_powerLevelAdvCount", "0");
	set_property("auto_powerLevelLastAttempted", "0");
	set_property("auto_pulls", "");
	set_property("auto_shenCopperhead", true);
	set_property("auto_skipDesert", 0);
	set_property("auto_snapshot", "");
	set_property("auto_sniffs", "");
	set_property("auto_spookyfertilizer", "");
	set_property("auto_spookymap", "");
	set_property("auto_spookyravensecond", "");
	set_property("auto_spookysapling", "");
	set_property("auto_sonofa", "");
	set_property("auto_sorceress", "");
	set_property("auto_swordfish", "");
	set_property("auto_tavern", "");
	set_property("auto_trytower", "");
	set_property("auto_trapper", "");
	set_property("auto_treecoin", "");
	set_property("auto_twinpeak", "");
	set_property("auto_twinpeakprogress", "");
	set_property("auto_waitingArrowAlcove", "50");
	set_property("auto_wandOfNagamar", true);
	set_property("auto_war", "");
	set_property("auto_winebomb", "");
	set_property("auto_wineracksencountered", 0);
	set_property("auto_wishes", "");
	set_property("auto_writingDeskSummon", false);
	set_property("auto_yellowRays", "");

	set_property("choiceAdventure1003", 0);
	beehiveConsider();

	auto_sourceTerminalEducate($skill[Extract], $skill[Digitize]);
	if(contains_text(get_property("sourceTerminalEnquiryKnown"), "monsters.enq") && (auto_my_path() == "Pocket Familiars"))
	{
		auto_sourceTerminalRequest("enquiry monsters.enq");
	}
	else if(contains_text(get_property("sourceTerminalEnquiryKnown"), "familiar.enq") && auto_have_familiar($familiar[Mosquito]))
	{
		auto_sourceTerminalRequest("enquiry familiar.enq");
	}
	else if(contains_text(get_property("sourceTerminalEnquiryKnown"), "stats.enq"))
	{
		auto_sourceTerminalRequest("enquiry stats.enq");
	}
	else if(contains_text(get_property("sourceTerminalEnquiryKnown"), "protect.enq"))
	{
		auto_sourceTerminalRequest("enquiry protect.enq");
	}

	eudora_initializeSettings();
	hr_initializeSettings();
	picky_initializeSettings();
	awol_initializeSettings();
	theSource_initializeSettings();
	standard_initializeSettings();
	florist_initializeSettings();
	ocrs_initializeSettings();
	ed_initializeSettings();
	boris_initializeSettings();
	jello_initializeSettings();
	bond_initializeSettings();
	fallout_initializeSettings();
	pete_initializeSettings();
	groundhog_initializeSettings();
	digimon_initializeSettings();
	majora_initializeSettings();
	glover_initializeSettings();
	bat_initializeSettings();
	tcrs_initializeSettings();
	koe_initializeSettings();

	set_property("auto_doneInitialize", my_ascensions());
}

boolean handleFamiliar(string type)
{
	//Can this take zoneInfo into account?

	//	Put all familiars in reverse priority order here.
	int[familiar] blacklist;

	int ascensionThreshold = get_property("auto_ascensionThreshold").to_int();
	if(ascensionThreshold == 0)
	{
		ascensionThreshold = 100;
	}

	if(get_property("auto_blacklistFamiliar") != "")
	{
		string[int] noFams = split_string(get_property("auto_blacklistFamiliar"), ";");
		foreach index, fam in noFams
		{
			blacklist[to_familiar(trim(fam))] = 1;
		}
	}

	boolean suggest = type.ends_with("Suggest");
	if(suggest)
	{
		type = type.substring(0, type.length() - length("Suggest"));
		if(familiar_weight(my_familiar()) < 20)
		{
			return false;
		}
	}

	string [string,int,string] familiars_text;
	if(!file_to_map("autoscend_familiars.txt", familiars_text))
		auto_log_critical("Could not load autoscend_familiars.txt. This is bad!", "red");
	foreach i,name,conds in familiars_text[type]
	{
		familiar thisFamiliar = name.to_familiar();
		if(thisFamiliar == $familiar[none] && name != "none")
		{
			auto_log_error('"' + name + '" does not convert to a familiar properly!', "red");
			auto_log_error(type + "; " + i + "; " + conds, "red");
			continue;
		}
		if(!auto_check_conditions(conds))
			continue;
		if(!auto_have_familiar(thisFamiliar))
			continue;
		if(blacklist contains thisFamiliar)
			continue;
		return handleFamiliar(thisFamiliar);
	}
	return false;
}

boolean handleFamiliar(familiar fam)
{
	if(is100FamiliarRun())
	{
		return true;
	}

	if(fam == $familiar[none])
	{
		return true;
	}
	if(!is_unrestricted(fam))
	{
		return false;
	}

	if((fam == $familiar[Ms. Puck Man]) && !auto_have_familiar($familiar[Ms. Puck Man]) && auto_have_familiar($familiar[Puck Man]))
	{
		fam = $familiar[Puck Man];
	}
	if((fam == $familiar[Puck Man]) && !auto_have_familiar($familiar[Puck Man]) && auto_have_familiar($familiar[Ms. Puck Man]))
	{
		fam = $familiar[Ms. Puck Man];
	}

	familiar toEquip = $familiar[none];
	if(auto_have_familiar(fam))
	{
		toEquip = fam;
	}
	else
	{
		boolean[familiar] poss = $familiars[Mosquito, Leprechaun, Baby Gravy Fairy, Slimeling, Golden Monkey, Hobo Monkey, Crimbo Shrub, Galloping Grill, Fist Turkey, Rockin\' Robin, Piano Cat, Angry Jung Man, Grimstone Golem, Adventurous Spelunker, Rockin\' Robin];

		int spleen_hold = 4;
		if(item_amount($item[Astral Energy Drink]) > 0)
		{
			spleen_hold = spleen_hold + 8;
		}
		if(in_hardcore() && ((my_spleen_use() + spleen_hold) <= spleen_limit()))
		{
			foreach fam in $familiars[Golden Monkey, Grim Brother, Unconscious Collective]
			{
				if((fam.drops_today < 1) && auto_have_familiar(fam))
				{
					toEquip = fam;
				}
			}
		}
		else if(in_hardcore() && (item_amount($item[Yellow Pixel]) < 30) && auto_have_familiar($familiar[Ms. Puck Man]))
		{
			toEquip = $familiar[Ms. Puck Man];
		}
		else if(in_hardcore() && (item_amount($item[Yellow Pixel]) < 30) && auto_have_familiar($familiar[Puck Man]))
		{
			toEquip = $familiar[Puck Man];
		}

		foreach thing in poss
		{
			if((auto_have_familiar(thing)) && (my_bjorned_familiar() != thing))
			{
				toEquip = thing;
			}
		}
	}

	if((toEquip != $familiar[none]) && (my_bjorned_familiar() != toEquip))
	{
		#use_familiar(toEquip);
		set_property("auto_familiarChoice", toEquip);
	}
	if(get_property("kingLiberated").to_boolean() && (toEquip != $familiar[none]) && (toEquip != my_familiar()) && (my_bjorned_familiar() != toEquip))
	{
		use_familiar(toEquip);
	}
#	set_property("auto_familiarChoice", my_familiar());

	if(hr_handleFamiliar(fam))
	{
		return true;
	}
	return false;
}

boolean basicFamiliarOverrides()
{
	if(($familiars[Adventurous Spelunker, Rockin\' Robin] contains my_familiar()) && auto_have_familiar($familiar[Grimstone Golem]) && (in_hardcore() || !possessEquipment($item[Buddy Bjorn])))
	{
		if(!possessEquipment($item[Ornate Dowsing Rod]) && (item_amount($item[Odd Silver Coin]) < 5) && (item_amount($item[Grimstone Mask]) == 0) && considerGrimstoneGolem(false))
		{
			handleFamiliar($familiar[Grimstone Golem]);
		}
	}

	int spleen_hold = 8 * item_amount($item[Astral Energy Drink]);
	foreach it in $items[Agua De Vida, Grim Fairy Tale, Groose Grease, Powdered Gold, Unconscious Collective Dream Jar]
	{
		spleen_hold += 4 * item_amount(it);
	}
	if((spleen_left() >= (4 + spleen_hold)) && haveSpleenFamiliar())
	{
		int spleenHave = 0;
		foreach fam in $familiars[Baby Sandworm, Bloovian Groose, Golden Monkey, Grim Brother, Unconscious Collective]
		{
			if(auto_have_familiar(fam))
			{
				spleenHave++;
			}
		}

		if(spleenHave > 0)
		{
			int need = (spleen_left() + 3)/4;
			int bound = (need + spleenHave - 1) / spleenHave;
			foreach fam in $familiars[Baby Sandworm, Bloovian Groose, Golden Monkey, Grim Brother, Unconscious Collective]
			{
				if((fam.drops_today < bound) && auto_have_familiar(fam))
				{
					handleFamiliar(fam);
					break;
				}
			}
		}
	}
	else if((item_amount($item[Yellow Pixel]) < 20) && (auto_have_familiar($familiar[Ms. Puck Man]) || auto_have_familiar($familiar[Puck Man])))
	{
		handleFamiliar($familiar[Ms. Puck Man]);
	}

	foreach fam in $familiars[Golden Monkey, Grim Brother, Unconscious Collective]
	{
		if((my_familiar() == fam) && (fam.drops_today >= 1))
		{
			handleFamiliar("item");
		}
	}
	if((my_familiar() == $familiar[Puck Man]) && (item_amount($item[Yellow Pixel]) > 20))
	{
		handleFamiliar("item");
	}
	if((my_familiar() == $familiar[Ms. Puck Man]) && (item_amount($item[Yellow Pixel]) > 20))
	{
		handleFamiliar("item");
	}

	if(in_hardcore() && (my_mp() < 50) && ((my_maxmp() - my_mp()) > 20))
	{
		handleFamiliar("regen");
	}

	return false;
}


boolean LX_burnDelay()
{
	location burnZone = solveDelayZone();
	boolean wannaVote = auto_voteMonster(true);
	boolean wannaDigitize = isOverdueDigitize();
	boolean wannaSausage = auto_sausageGoblin();
	if(burnZone != $location[none])
	{
		if(auto_voteMonster(true))
		{
			auto_log_info("Burn some delay somewhere (voting), if we found a place!", "green");
			if(auto_voteMonster(true, burnZone, ""))
			{
				return true;
			}
		}
		if(isOverdueDigitize())
		{
			auto_log_info("Burn some delay somewhere (digitize), if we found a place!", "green");
			if(autoAdv(burnZone))
			{
				return true;
			}
		}
		if(auto_sausageGoblin())
		{
			auto_log_info("Burn some delay somewhere (sausage goblin), if we found a place!", "green");
			if(auto_sausageGoblin(burnZone, ""))
			{
				return true;
			}
		}
	}
	else if(wannaVote || wannaDigitize || wannaSausage)
	{
		if(wannaVote) auto_log_warning("Had overdue voting monster but couldn't find a zone to burn delay", "red");
		if(wannaDigitize) auto_log_warning("Had overdue digitize but couldn't find a zone to burn delay", "red");
		if(wannaSausage) auto_log_warning("Had overdue sausage but couldn't find a zone to burn delay", "red");
	}
	return false;
}


boolean LX_universeFrat()
{
	if(my_daycount() >= 2)
	{
		if(possessEquipment($item[Beer Helmet]) && possessEquipment($item[Distressed Denim Pants]) && possessEquipment($item[Bejeweled Pledge Pin]))
		{
			doNumberology("adventures3");
		}
		else if((my_mp() >= mp_cost($skill[Calculate the Universe])) && adjustForYellowRayIfPossible($monster[War Frat 151st Infantryman]) && (doNumberology("battlefield", false) != -1))
		{
			doNumberology("battlefield");
			return true;
		}
	}
	return false;
}

boolean LX_faxing()
{
	if (my_level() >= 9 && !get_property("_photocopyUsed").to_boolean() && isActuallyEd() && my_daycount() < 3 && !is_unrestricted($item[Deluxe Fax Machine]))
	{
		auto_sourceTerminalEducate($skill[Extract], $skill[Digitize]);
		if(handleFaxMonster($monster[Lobsterfrogman]))
		{
			return true;
		}
	}
	return false;
}

void maximize_hedge()
{
	string data = visit_url("campground.php?action=telescopelow");

	element first = ns_hedge1();
	element second = ns_hedge2();
	element third = ns_hedge3();
	if((first == $element[none]) || (second == $element[none]) || (third == $element[none]))
	{
		uneffect($effect[Flared Nostrils]);
		if(useMaximizeToEquip())
		{
			addToMaximize("200all res");
		}
		else
		{
			autoMaximize("all res -equip snow suit", 2500, 0, false);
		}
	}
	else
	{
		if ($element[stench] == first || $element[stench] == second || $element[stench] == third)
		{
			uneffect($effect[Flared Nostrils]);
		}
		if(useMaximizeToEquip())
		{
			addToMaximize("200" + first + " res,200" + second + " res,200" + third + " res");
		}
		else
		{
			autoMaximize(to_string(first) + " res, " + to_string(second) + " res, " + to_string(third) + " res -equip snow suit", 2500, 0, false);
		}
	}

	bat_formMist();
	foreach eff in $effects[Egged On, Patent Prevention, Spectral Awareness]
	{
		buffMaintain(eff, 0, 1, 1);
	}
}

int pullsNeeded(string data)
{
	if(get_property("kingLiberated").to_boolean())
	{
		return 0;
	}
	if (isActuallyEd() || auto_my_path() == "Community Service")
	{
		return 0;
	}

	int count = 0;
	int adv = 0;

	int progress = 0;
	if(get_property("auto_sorceress") == "hedge")
	{
		progress = 1;
	}
	if(get_property("auto_sorceress") == "door")
	{
		progress = 2;
	}
	if(get_property("auto_sorceress") == "tower")
	{
		progress = 3;
	}
	if(get_property("auto_sorceress") == "top")
	{
		progress = 4;
	}
	visit_url("campground.php?action=telescopelow");

	if(progress < 1)
	{
		int crowd1score = 0;
		int crowd2score = 0;
		int crowd3score = 0;

//		Note: Maximizer gives concert White-boy angst, instead of concert 3 (consequently, it doesn\'t work).

		switch(ns_crowd1())
		{
		case 1:					crowd1score = initiative_modifier()/40;							break;
		}

		switch(ns_crowd2())
		{
		case $stat[Moxie]:		crowd2score = (my_buffedstat($stat[Moxie]) - 150) / 40;			break;
		case $stat[Muscle]:		crowd2score = (my_buffedstat($stat[Muscle]) - 150) / 40;		break;
		case $stat[Mysticality]:crowd2score = (my_buffedstat($stat[Mysticality]) - 150) / 40;	break;
		}

		switch(ns_crowd3())
		{
		case $element[cold]:	crowd3score = numeric_modifier("cold damage") / 9;				break;
		case $element[hot]:		crowd3score = numeric_modifier("hot damage") / 9;				break;
		case $element[sleaze]:	crowd3score = numeric_modifier("sleaze damage") / 9;			break;
		case $element[spooky]:	crowd3score = numeric_modifier("spooky damage") / 9;			break;
		case $element[stench]:	crowd3score = numeric_modifier("stench damage") / 9;			break;
		}

		crowd1score = min(max(0, crowd1score), 9);
		crowd2score = min(max(0, crowd2score), 9);
		crowd3score = min(max(0, crowd3score), 9);
		adv = adv + (10 - crowd1score) + (10 - crowd2score) + (10 - crowd3score);
	}

	if(progress < 2)
	{
		ns_hedge1();
		ns_hedge2();
		ns_hedge3();

		auto_log_warning("Hedge time of 4 adventures. (Up to 10 without Elemental Resistances)", "red");
		adv = adv + 4;
	}

	if(progress < 3)
	{
		if((item_amount($item[Richard\'s Star Key]) == 0) && (item_amount($item[Star Chart]) == 0))
		{
			auto_log_warning("Need star chart", "red");
			if((auto_my_path() == "Heavy Rains") && (my_rain() >= 50))
			{
				auto_log_info("You should rain man a star chart", "blue");
			}
			else
			{
				count = count + 1;
			}
		}

		if(item_amount($item[Richard\'s Star Key]) == 0)
		{
			int stars = item_amount($item[star]);
			int lines = item_amount($item[line]);

			if(stars < 8)
			{
				auto_log_warning("Need " + (8-stars) + " stars.", "red");
				count = count + (8-stars);
			}
			if(lines < 7)
			{
				auto_log_warning("Need " + (7-lines) + " lines.", "red");
				count = count + (7-lines);
			}
		}

		if((item_amount($item[Digital Key]) == 0) && (item_amount($item[White Pixel]) < 30))
		{
			auto_log_warning("Need " + (30-item_amount($item[white pixel])) + " white pixels.", "red");
			count = count + (30 - item_amount($item[white pixel]));
		}

		if(item_amount($item[skeleton key]) == 0)
		{
			if((item_amount($item[skeleton bone]) > 0) && (item_amount($item[loose teeth]) > 0))
			{
				cli_execute("make skeleton key");
			}
		}
		if(item_amount($item[skeleton key]) == 0)
		{
			auto_log_warning("Need a skeleton key or the ingredients (skeleton bone, loose teeth) for it.");
		}
	}

	if(progress < 4)
	{
		adv = adv + 6;
		if(get_property("auto_wandOfNagamar").to_boolean() && (item_amount($item[Wand Of Nagamar]) == 0) && (cloversAvailable() == 0))
		{
			auto_log_warning("Need a wand of nagamar (can be clovered).", "red");
			count = count + 1;
		}
	}

	if(adv > 0)
	{
		auto_log_info("Estimated adventure need (tower) is: " + adv + ".", "orange");
		if(!in_hardcore())
		{
			auto_log_info("You need " + count + " pulls.", "orange");
		}
	}
	if(pulls_remaining() > 0)
	{
		auto_log_info("You have " + pulls_remaining() + " pulls.", "orange");
	}
	return count;
}

boolean tophatMaker()
{
	if(!knoll_available() || (item_amount($item[Brass Gear]) == 0) || possessEquipment($item[Mark V Steam-Hat]))
	{
		return false;
	}
	item reEquip = $item[none];

	if(possessEquipment($item[Mark IV Steam-Hat]))
	{
		if(equipped_item($slot[Hat]) == $item[Mark IV Steam-Hat])
		{
			reEquip = $item[Mark V Steam-Hat];
			equip($slot[hat], $item[none]);
		}
		autoCraft("combine", 1, $item[Brass Gear], $item[Mark IV Steam-Hat]);
	}
	else if(possessEquipment($item[Mark III Steam-Hat]))
	{
		if(equipped_item($slot[Hat]) == $item[Mark III Steam-Hat])
		{
			reEquip = $item[Mark IV Steam-Hat];
			equip($slot[hat], $item[none]);
		}
		autoCraft("combine", 1, $item[Brass Gear], $item[Mark III Steam-Hat]);
	}
	else if(possessEquipment($item[Mark II Steam-Hat]))
	{
		if(equipped_item($slot[Hat]) == $item[Mark II Steam-Hat])
		{
			reEquip = $item[Mark III Steam-Hat];
			equip($slot[hat], $item[none]);
		}
		autoCraft("combine", 1, $item[Brass Gear], $item[Mark II Steam-Hat]);
	}
	else if(possessEquipment($item[Mark I Steam-Hat]))
	{
		if(equipped_item($slot[Hat]) == $item[Mark I Steam-Hat])
		{
			reEquip = $item[Mark II Steam-Hat];
			equip($slot[hat], $item[none]);
		}
		autoCraft("combine", 1, $item[Brass Gear], $item[Mark I Steam-Hat]);
	}
	else if(possessEquipment($item[Brown Felt Tophat]))
	{
		if(equipped_item($slot[Hat]) == $item[Brown Felt Tophat])
		{
			reEquip = $item[Mark I Steam-Hat];
			equip($slot[hat], $item[none]);
		}
		autoCraft("combine", 1, $item[Brass Gear], $item[Brown Felt Tophat]);
	}
	else
	{
		return false;
	}

	auto_log_info("Mark Steam-Hat upgraded!", "blue");
	if(reEquip != $item[none])
	{
		equip($slot[hat], reEquip);
	}
	return true;
}

boolean warOutfit(boolean immediate)
{
	boolean reallyWarOutfit(string toWear)
	{
		if(immediate)
		{
			return outfit(toWear);
		}
		else
		{
			return autoOutfit(toWear);
		}
	}

	if(!get_property("auto_hippyInstead").to_boolean())
	{
		if(!reallyWarOutfit("frat warrior fatigues"));
		{
			foreach it in $items[Beer Helmet, Distressed Denim Pants, Bejeweled Pledge Pin]
			{
				take_closet(closet_amount(it), it);
			}
			if(!reallyWarOutfit("frat warrior fatigues"))
			{
				abort("Do not have frat warrior fatigues and don't know why....");
				return false;
			}
		}
		return true;
	}
	else
	{
		if(!reallyWarOutfit("war hippy fatigues"))
		{
			foreach it in $items[Reinforced Beaded Headband, Bullet-proof Corduroys, Round Purple Sunglasses]
			{
				take_closet(closet_amount(it), it);
			}
			if(!reallyWarOutfit("war hippy fatigues"))
			{
				abort("Do not have war hippy fatigues and don't know why....");
				return false;
			}
		}
		return true;
	}
}

boolean haveWarOutfit()
{
	if(!get_property("auto_hippyInstead").to_boolean())
	{
		foreach it in $items[Beer Helmet, Distressed Denim Pants, Bejeweled Pledge Pin]
		{
			if(available_amount(it) == 0)
			{
				return false;
			}
		}
	}
	else
	{
		foreach it in $items[Reinforced Beaded Headband, Bullet-proof Corduroys, Round Purple Sunglasses]
		{
			if(available_amount(it) == 0)
			{
				return false;
			}
		}
	}
	return true;
}

boolean warAdventure()
{
	if(auto_have_familiar($familiar[Space Jellyfish]) && (get_property("_spaceJellyfishDrops").to_int() < 3))
	{
		handleFamiliar($familiar[Space Jellyfish]);
	}

	if(!get_property("auto_hippyInstead").to_boolean())
	{
		if(!autoAdv(1, $location[The Battlefield (Frat Uniform)]))
		{
			set_property("hippiesDefeated", get_property("hippiesDefeated").to_int() + 1);
			string temp = visit_url("island.php");
		}
	}
	else
	{
		if(!autoAdv(1, $location[The Battlefield (Hippy Uniform)]))
		{
			set_property("fratboysDefeated", get_property("fratboysDefeated").to_int() + 1);
			string temp = visit_url("island.php");
		}
	}
	return true;
}

boolean L12_ThemtharHills()
{
	if(in_tcrs() || in_koe())
	{
		set_property("auto_nuns", "finished"); // if only :(
		return false;
	}
	if(get_property("auto_nuns") == "done")
	{
		return false;
	}
	if((get_property("currentNunneryMeat").to_int() >= 100000) || (get_property("sidequestNunsCompleted") != "none") || (auto_my_path() == "Way of the Surprising Fist"))
	{
		handleBjornify($familiar[el vibrato megadrone]);
		set_property("auto_nuns", "done");
		return false;
	}

	if((get_property("hippiesDefeated").to_int() >= 1000) || (get_property("fratboysDefeated").to_int() >= 1000))
	{
		return false;
	}

	if(get_property("auto_hippyInstead").to_boolean() || (get_property("hippiesDefeated").to_int() >= 192))
	{
		auto_log_info("Themthar Nuns!", "blue");
	}

	if((get_property("sidequestArenaCompleted") == "fratboy") && !get_property("concertVisited").to_boolean() && (have_effect($effect[Winklered]) == 0))
	{
		outfit("frat warrior fatigues");
		cli_execute("concert 2");
	}

	handleBjornify($familiar[Hobo Monkey]);
	if((equipped_item($slot[off-hand]) != $item[Half a Purse]) && !possessEquipment($item[Half a Purse]) && (item_amount($item[Lump of Brituminous Coal]) > 0))
	{
		buyUpTo(1, $item[Loose Purse Strings]);
		autoCraft("smith", 1, $item[Lump of Brituminous Coal], $item[Loose purse strings]);
	}

	autoEquip($item[Half a Purse]);
	if(auto_my_path() == "Heavy Rains")
	{
		autoEquip($item[Thor\'s Pliers]);
	}
	autoEquip($item[Miracle Whip]);

	shrugAT($effect[Polka of Plenty]);
	if (isActuallyEd())
	{
		if(!have_skill($skill[Gift of the Maid]) && ($servant[Maid].experience >= 441))
		{
			visit_url("charsheet.php");
			if(have_skill($skill[Gift of the Maid]))
			{
				auto_log_warning("Gift of the Maid not properly detected until charsheet refresh.", "red");
			}
		}
	}
	buffMaintain($effect[Purr of the Feline], 10, 1, 1);
	songboomSetting("meat");

	if(is100FamiliarRun())
	{
		if(useMaximizeToEquip())
		{
			addToMaximize("200meat drop");
		}
		else
		{
			autoMaximize("meat drop, -equip snow suit", 1500, 0, false);
		}
	}
	else
	{
		if(useMaximizeToEquip())
		{
			addToMaximize("200meat drop,switch Hobo Monkey,switch rockin' robin,switch adventurous spelunker,switch Grimstone Golem,switch Fist Turkey,switch Unconscious Collective,switch Golden Monkey,switch Angry Jung Man,switch Leprechaun,switch cat burglar");
		}
		else
		{
			autoMaximize("meat drop, -equip snow suit, switch Hobo Monkey, switch rockin' robin, switch adventurous spelunker, switch Grimstone Golem, switch Fist Turkey, switch Unconscious Collective, switch Golden Monkey, switch Angry Jung Man, switch Leprechaun,switch cat burglar", 1500, 0, false);
		}
		handleFamiliar(my_familiar());
	}
	int expectedMeat = simValue("Meat Drop");


	if(get_property("auto_useWishes").to_boolean())
	{
		makeGenieWish($effect[Frosty]);
	}
	buffMaintain($effect[Greedy Resolve], 0, 1, 1);
	buffMaintain($effect[Disco Leer], 10, 1, 1);
	buffMaintain($effect[Polka of Plenty], 8, 1, 1);
	#Handle for familiar weight change.
	buffMaintain($effect[Kindly Resolve], 0, 1, 1);
	buffMaintain($effect[Heightened Senses], 0, 1, 1);
	buffMaintain($effect[Big Meat Big Prizes], 0, 1, 1);
	buffMaintain($effect[Human-Machine Hybrid], 0, 1, 1);
	buffMaintain($effect[Human-Constellation Hybrid], 0, 1, 1);
	buffMaintain($effect[Human-Humanoid Hybrid], 0, 1, 1);
	buffMaintain($effect[Human-Fish Hybrid], 0, 1, 1);
	buffMaintain($effect[Cranberry Cordiality], 0, 1, 1);
	buffMaintain($effect[Patent Avarice], 0, 1, 1);
	if(item_amount($item[body spradium]) > 0 && !in_tcrs() && have_effect($effect[Boxing Day Glow]) == 0)
	{
		autoChew(1, $item[body spradium]);
	}
	if(have_effect($effect[meat.enh]) == 0)
	{
		if(auto_sourceTerminalEnhanceLeft() > 0)
		{
			auto_sourceTerminalEnhance("meat");
		}
	}
	if(have_effect($effect[Synthesis: Greed]) == 0)
	{
		rethinkingCandy($effect[Synthesis: Greed]);
	}
	asdonBuff($effect[Driving Observantly]);



	handleFamiliar("meat");
	if(auto_have_familiar($familiar[Trick-or-Treating Tot]) && (available_amount($item[Li\'l Pirate Costume]) > 0) && !is100FamiliarRun($familiar[Trick-or-Treating Tot]) && (auto_my_path() != "Heavy Rains"))
	{
		use_familiar($familiar[Trick-or-Treating Tot]);
		autoEquip($item[Li\'l Pirate Costume]);
		handleFamiliar($familiar[Trick-or-Treating Tot]);
	}

	if(auto_my_path() == "Heavy Rains")
	{
		buffMaintain($effect[Sinuses For Miles], 0, 1, 1);
	}
	// Target 1000 + 400% = 5000 meat per brigand. Of course we want more, but don\'t bother unless we can get this.
	float meat_need = 400.00;
#	if(auto_my_path() == "Standard")
#	{
#		meat_need = meat_need - 100.00;
#	}
#	if(get_property("auto_dickstab").to_boolean())
#	{
#		meat_need = meat_need + 200.00;
#	}
	if(item_amount($item[Mick\'s IcyVapoHotness Inhaler]) > 0)
	{
		meat_need = meat_need - 200;
	}
	if((my_class() == $class[Vampyre]) && have_skill($skill[Wolf Form]) && (0 == have_effect($effect[Wolf Form])))
	{
		meat_need = meat_need - 150;
	}

	float meatDropHave = meat_drop_modifier();

	if (isActuallyEd() && have_skill($skill[Curse of Fortune]) && item_amount($item[Ka Coin]) > 0)
	{
		meatDropHave = meatDropHave + 200;
	}
	if(meatDropHave < meat_need)
	{
		auto_log_warning("Meat drop (" + meatDropHave+ ") is pretty low, (we want: " + meat_need + ") probably not worth it to try this.", "red");

		float minget = 800.00 * (meatDropHave / 100.0);
		int meatneed = 100000 - get_property("currentNunneryMeat").to_int();
		auto_log_info("The min we expect is: " + minget + " and we need: " + meatneed, "blue");

		if(minget < meatneed)
		{
			int curMeat = get_property("currentNunneryMeat").to_int();
			int advs = $location[The Themthar Hills].turns_spent;
			int needMeat = 100000 - curMeat;

			boolean failNuns = true;
			if(advs < 25)
			{
				int advLeft = 25 - $location[The Themthar Hills].turns_spent;
				float needPerAdv = needMeat / advLeft;
				if(minget > needPerAdv)
				{
					auto_log_info("We don't have the desired +meat but should be able to complete the nuns to our advantage", "green");
					failNuns = false;
				}
			}

			if(failNuns)
			{
				set_property("auto_nuns", "done");
				handleFamiliar("item");
				return true;
			}
		}
		else
		{
			auto_log_info("The min should be enough! Doing it!!", "purple");
		}
	}


	buffMaintain($effect[Disco Leer], 10, 1, 1);
	buffMaintain($effect[Polka of Plenty], 8, 1, 1);
	buffMaintain($effect[Sinuses For Miles], 0, 1, 1);
	buffMaintain($effect[Greedy Resolve], 0, 1, 1);
	buffMaintain($effect[Kindly Resolve], 0, 1, 1);
	buffMaintain($effect[Heightened Senses], 0, 1, 1);
	buffMaintain($effect[Big Meat Big Prizes], 0, 1, 1);
	buffMaintain($effect[Fortunate Resolve], 0, 1, 1);
	buffMaintain($effect[Human-Machine Hybrid], 0, 1, 1);
	buffMaintain($effect[Human-Constellation Hybrid], 0, 1, 1);
	buffMaintain($effect[Human-Humanoid Hybrid], 0, 1, 1);
	buffMaintain($effect[Human-Fish Hybrid], 0, 1, 1);
	buffMaintain($effect[Cranberry Cordiality], 0, 1, 1);
	bat_formWolf();

	{
		warOutfit(false);

		int lastMeat = get_property("currentNunneryMeat").to_int();
		int myLastMeat = my_meat();
		auto_log_info("Meat drop to start: " + meat_drop_modifier(), "blue");
		if(!autoAdv(1, $location[The Themthar Hills]))
		{
			//Maybe we passed it!
			string temp = visit_url("bigisland.php?place=nunnery");
		}
		if(last_monster() != $monster[dirty thieving brigand])
		{
			return true;
		}
		if(get_property("lastEncounter") != $monster[Dirty Thieving Brigand])
		{
			return true;
		}

		int curMeat = get_property("currentNunneryMeat").to_int();
		if(lastMeat == curMeat)
		{
			int diffMeat = my_meat() - myLastMeat;
			set_property("currentNunneryMeat", diffMeat);
		}

		int advs = $location[The Themthar Hills].turns_spent + 1;

		int diffMeat = curMeat - lastMeat;
		int needMeat = 100000 - curMeat;
		int average = curMeat / advs;
		auto_log_info("Cur Meat: " + curMeat + " Average: " + average, "blue");

		diffMeat = diffMeat * 1.2;
		average = average * 1.2;
	}
	handleFamiliar("item");
	return true;
}


int handlePulls(int day)
{
	if(item_amount($item[Astral Six-Pack]) > 0)
	{
		use(1, $item[Astral Six-Pack]);
	}
	if(item_amount($item[Astral Hot Dog Dinner]) > 0)
	{
		use(1, $item[Astral Hot Dog Dinner]);
	}

	initializeSettings();

	if(in_hardcore())
	{
		return 0;
	}

	if(day == 1)
	{
		set_property("lightsOutAutomation", "1");
		# Do starting pulls:
		if((pulls_remaining() != 20) && !in_hardcore() && (my_turncount() > 0))
		{
			auto_log_info("I assume you've handled your pulls yourself... who knows.");
			return 0;
		}

		if((storage_amount($item[can of rain-doh]) > 0) && glover_usable($item[Can Of Rain-Doh]) && (pullXWhenHaveY($item[can of Rain-doh], 1, 0)))
		{
			if(item_amount($item[Can of Rain-doh]) > 0)
			{
				use(1, $item[can of Rain-doh]);
				put_closet(1, $item[empty rain-doh can]);
			}
		}
		if((storage_amount($item[Buddy Bjorn]) > 0) && !($classes[Avatar of Boris, Avatar of Jarlsberg, Avatar of Sneaky Pete, Ed] contains my_class()))
		{
			pullXWhenHaveY($item[Buddy Bjorn], 1, 0);
		}
		if((storage_amount($item[Camp Scout Backpack]) > 0) && !possessEquipment($item[Buddy Bjorn]) && glover_usable($item[Camp Scout Backpack]))
		{
			pullXWhenHaveY($item[Camp Scout Backpack], 1, 0);
		}

		if(my_path() == "Way of the Surprising Fist")
		{
			pullXWhenHaveY($item[Bittycar Meatcar], 1, 0);
		}

		if(is_unrestricted($item[Pantsgiving]))
		{
			if((my_class() != $class[Avatar of Boris]) && glover_usable($item[Xiblaxian Stealth Cowl]))
			{
				pullXWhenHaveY($item[xiblaxian stealth cowl], 1, 0);
			}
			pullXWhenHaveY($item[Pantsgiving], 1, 0);
		}
		else
		{
			pullXWhenHaveY($item[The Crown Of Ed The Undying], 1, 0);
			adjustEdHat("ml");
			if(!possessEquipment($item[The Crown Of Ed The Undying]))
			{
				pullXWhenHaveY($item[Gravy Boat], 1, 0);
			}
			if(glover_usable($item[Xiblaxian Stealth Trousers]))
			{
				pullXWhenHaveY($item[Xiblaxian Stealth Trousers], 1, 0);
			}
		}

		if(!possessEquipment($item[Astral Shirt]))
		{
			boolean getPeteShirt = true;
			if(!hasTorso())
			{
				getPeteShirt = false;
			}
			if((my_primestat() == $stat[Muscle]) && get_property("loveTunnelAvailable").to_boolean())
			{
				getPeteShirt = false;
			}
			if(auto_my_path() == "G-Lover")
			{
				getPeteShirt = false;
			}

			if(getPeteShirt)
			{
				pullXWhenHaveY($item[Sneaky Pete\'s Leather Jacket], 1, 0);
				if(item_amount($item[Sneaky Pete\'s Leather Jacket]) == 0)
				{
					pullXWhenHaveY($item[Sneaky Pete\'s Leather Jacket (Collar Popped)], 1, 0);
				}
				else
				{
					cli_execute("fold " + $item[Sneaky Pete\'s Leather Jacket (Collar Popped)]);
				}
			}
		}

		if(((auto_my_path() == "Picky") || is100FamiliarRun()) && (item_amount($item[Deck of Every Card]) == 0) && (fullness_left() >= 4))
		{
			if((item_amount($item[Boris\'s Key]) == 0) && canEat($item[Boris\'s Key Lime Pie]) && !contains_text(get_property("nsTowerDoorKeysUsed"), $item[Boris\'s Key]))
			{
				pullXWhenHaveY($item[Boris\'s Key Lime Pie], 1, 0);
			}
			if((item_amount($item[Sneaky Pete\'s Key]) == 0) && canEat($item[Sneaky Pete\'s Key Lime Pie]) && !contains_text(get_property("nsTowerDoorKeysUsed"), $item[Sneaky Pete\'s Key]))
			{
				pullXWhenHaveY($item[Sneaky Pete\'s Key Lime Pie], 1, 0);
			}
			if((item_amount($item[Jarlsberg\'s Key]) == 0) && canEat($item[Jarlsberg\'s Key Lime Pie]) && !contains_text(get_property("nsTowerDoorKeysUsed"), $item[Jarlsberg\'s Key]))
			{
				pullXWhenHaveY($item[Jarlsberg\'s Key Lime Pie], 1, 0);
			}
		}
		else if(auto_my_path() == "Standard")
		{
			if(canEat(whatHiMein()))
			{
				pullXWhenHaveY(whatHiMein(), 3, 0);
			}
		}

		if((equipped_item($slot[folder1]) == $item[folder (tranquil landscape)]) && (equipped_item($slot[folder2]) == $item[folder (skull and crossbones)]) && (equipped_item($slot[folder3]) == $item[folder (Jackass Plumber)]) && glover_usable($item[Over-The-Shoulder Folder Holder]))
		{
			pullXWhenHaveY($item[over-the-shoulder folder holder], 1, 0);
		}
		if((my_primestat() == $stat[Muscle]) && (auto_my_path() != "Heavy Rains"))
		{
			if((closet_amount($item[Fake Washboard]) == 0) && glover_usable($item[Fake Washboard]))
			{
				pullXWhenHaveY($item[Fake Washboard], 1, 0);
			}
			if((item_amount($item[Fake Washboard]) == 0) && (closet_amount($item[Fake Washboard]) == 0))
			{
				pullXWhenHaveY($item[numberwang], 1, 0);
			}
			else
			{
				if(get_property("barrelShrineUnlocked").to_boolean())
				{
					put_closet(item_amount($item[Fake Washboard]), $item[Fake Washboard]);
				}
			}
		}
		else
		{
			pullXWhenHaveY($item[Numberwang], 1, 0);
		}
		if(auto_my_path() == "Pocket Familiars")
		{
			pullXWhenHaveY($item[Ring Of Detect Boring Doors], 1, 0);
			pullXWhenHaveY($item[Pick-O-Matic Lockpicks], 1, 0);
			pullXWhenHaveY($item[Eleven-Foot Pole], 1, 0);
		}

		if((my_class() == $class[Sauceror]) || (my_class() == $class[Pastamancer]))
		{
			if((item_amount($item[Deck of Every Card]) == 0) && !auto_have_skill($skill[Summon Smithsness]))
			{
				pullXWhenHaveY($item[Thor\'s Pliers], 1, 0);
			}
			if(glover_usable($item[Basaltamander Buckler]))
			{
				pullXWhenHaveY($item[Basaltamander Buckler], 1, 0);
			}
		}

		if(auto_my_path() == "Picky")
		{
			pullXWhenHaveY($item[gumshoes], 1, 0);
		}
		if(auto_have_skill($skill[Summon Smithsness]))
		{
			pullXWhenHaveY($item[hand in glove], 1, 0);
		}
		else
		{
			//pullXWhenHaveY(<smithsWeapon>, 1, 0);
			//Possibly pull other smiths gear?
		}

		if((auto_my_path() != "Heavy Rains") && (auto_my_path() != "License to Adventure") && !($classes[Avatar of Boris, Avatar of Jarlsberg, Avatar of Sneaky Pete, Ed] contains my_class()))
		{
			if(!possessEquipment($item[Snow Suit]) && !possessEquipment($item[Astral Pet Sweater]) && glover_usable($item[Snow Suit]))
			{
				pullXWhenHaveY($item[snow suit], 1, 0);
			}
			if(!possessEquipment($item[Snow Suit]) && !possessEquipment($item[Filthy Child Leash]) && !possessEquipment($item[Astral Pet Sweater]) && glover_usable($item[Filthy Child Leash]))
			{
				pullXWhenHaveY($item[Filthy Child Leash], 1, 0);
			}
		}

		if(get_property("auto_dickstab").to_boolean())
		{
			pullXWhenHaveY($item[Shore Inc. Ship Trip Scrip], 3, 0);
		}

		if(auto_my_path() != "G-Lover")
		{
			pullXWhenHaveY($item[Infinite BACON Machine], 1, 0);
		}

		if(is_unrestricted($item[Bastille Battalion control rig]))
		{
			string temp = visit_url("storage.php?action=pull&whichitem1=" + to_int($item[Bastille Battalion Control Rig]) + "&howmany1=1&pwd");
			#pullXWhenHaveY($item[Bastille Battalion control rig], 1, 0);
		}

		if((auto_my_path() != "Pocket Familiars") && (auto_my_path() != "G-Lover"))
		{
			pullXWhenHaveY($item[Replica Bat-oomerang], 1, 0);
		}

		if (!auto_have_familiar($familiar[Grim Brother]) && !isActuallyEd() && glover_usable($item[Unconscious Collective Dream Jar]))
		{
			pullXWhenHaveY($item[Unconscious Collective Dream Jar], 1, 0);
			if(item_amount($item[Unconscious Collective Dream Jar]) > 0)
			{
				autoChew(1, $item[Unconscious Collective Dream Jar]);
			}
		}


		if(my_class() == $class[Vampyre])
		{
			auto_log_info("You are a powerful vampire who is doing a softcore run. Turngen is busted in this path, so let's see how much we can get.", "blue");
			if((storage_amount($item[mime army shotglass]) > 0) && is_unrestricted($item[mime army shotglass]))
			{
				pullXWhenHaveY($item[mime army shotglass], 1, 0);
			}
			int available_bloodbags = 7;
			if(item_amount($item[Vampyric cloake]) > 0)
			{
				available_bloodbags += 1;
			}
			if(item_amount($item[Lil\' Doctor&trade; Bag]) > 0)
			{
				available_bloodbags += 1;
			}

			int available_stomach = 5;
			int available_drink = 5;
			if(item_amount($item[mime army shotglass]) > 0)
			{
				available_drink += 1;
			}

			// assuming dieting pills
			pullXWhenHaveY($item[gauze garter], (1+available_stomach)/2, 0);
			pullXWhenHaveY($item[monstar energy beverage], available_drink, 0);
		}
	}
	else if(day == 2)
	{
		if((closet_amount($item[Fake Washboard]) == 1) && get_property("barrelShrineUnlocked").to_boolean())
		{
			take_closet(1, $item[Fake Washboard]);
		}
	}

	return pulls_remaining();
}

boolean doVacation()
{
	if(in_koe())
	{
		return false;
	}
	if(my_primestat() == $stat[Muscle])
	{
		set_property("choiceAdventure793", "1");
	}
	else if(my_primestat() == $stat[Mysticality])
	{
		set_property("choiceAdventure793", "2");
	}
	else
	{
		set_property("choiceAdventure793", "3");
	}
	return autoAdv(1, $location[The Shore\, Inc. Travel Agency]);
}

boolean fortuneCookieEvent()
{
	if(get_counters("Fortune Cookie", 0, 0) == "Fortune Cookie")
	{
		auto_log_info("Semi rare time!", "blue");
		cli_execute("counters");
		cli_execute("counters clear");

		location goal = $location[The Hidden Temple];

		if((my_path() == "Community Service") && (my_daycount() == 1))
		{
			goal = $location[The Limerick Dungeon];
		}

		if (goal == $location[The Hidden Temple] && (get_property("semirareLocation") == goal || item_amount($item[stone wool]) >= 2 || get_property("auto_hiddenunlock") == "nose" || get_property("auto_hiddenunlock") == "finished" || internalQuestStatus("questL11Worship") >= 3 || get_property("lastTempleUnlock").to_int() < my_ascensions() || get_property("auto_spookysapling") != "finished"))
		{
			goal = $location[The Castle in the Clouds in the Sky (Top Floor)];
		}

		if (goal == $location[The Castle in the Clouds in the Sky (Top Floor)] && (get_property("semirareLocation") == goal || item_amount($item[Mick\'s IcyVapoHotness Inhaler]) > 0 || get_property("auto_nuns") == "done" || get_property("auto_nuns") == "finished" || internalQuestStatus("questL10Garbage") < 9 || get_property("lastCastleTopUnlock").to_int() < my_ascensions() || get_property("auto_castleground") != "finished" || get_property("sidequestNunsCompleted") != "none" || in_koe()))
		{
			goal = $location[The Limerick Dungeon];
		}

		if (goal == $location[The Limerick Dungeon] && (get_property("semirareLocation") == goal || item_amount($item[Cyclops Eyedrops]) > 0 || get_property("auto_orchard") == "start" || get_property("auto_orchard") == "done" || get_property("auto_orchard") == "finished" || get_property("lastFilthClearance").to_int() >= my_ascensions() || get_property("sidequestOrchardCompleted") != "none" || get_property("currentHippyStore") != "none" || isActuallyEd() || in_koe()))
		{
			goal = $location[The Copperhead Club];
		}

		if (goal == $location[The Copperhead Club] && (get_property("semirareLocation") == goal || internalQuestStatus("questL11Shen") < 0 || internalQuestStatus("questL11Ron") >= 2))
		{
			goal = $location[The Haunted Kitchen];
		}

		if (goal == $location[The Haunted Kitchen] && (get_property("semirareLocation") == goal || get_property("chasmBridgeProgress").to_int() >= 30 || internalQuestStatus("questL09Topping") >= 1 || isActuallyEd()))
		{
			goal = $location[The Outskirts of Cobb\'s Knob];
		}

		if (goal == $location[The Outskirts of Cobb\'s Knob] && (get_property("semirareLocation") == goal || internalQuestStatus("questL05Goblin") > 1 || item_amount($item[Knob Goblin encryption key]) > 0 || $location[The Outskirts of Cobb\'s Knob].turns_spent >= 10))
		{
			goal = $location[The Haunted Pantry];
		}

		if((goal == $location[The Haunted Pantry]) && (get_property("semirareLocation") == goal))
		{
			goal = $location[The Sleazy Back Alley];
		}

		if((goal == $location[The Sleazy Back Alley]) && (get_property("semirareLocation") == goal))
		{
			goal = $location[The Outskirts of Cobb\'s Knob];
		}

		if((goal == $location[The Outskirts of Cobb\'s Knob]) && (get_property("semirareLocation") == goal))
		{
			auto_log_warning("Do we not have access to either The Haunted Pantry or The Sleazy Back Alley?", "red");
			goal = $location[The Haunted Pantry];
		}

		boolean retval = autoAdv(goal);
		if (item_amount($item[Knob Goblin lunchbox]) > 0)
		{
			use(item_amount($item[Knob Goblin lunchbox]), $item[Knob Goblin lunchbox]);
		}
		return retval;
	}
	return false;
}

void initializeDay(int day)
{
	if(get_property("kingLiberated").to_boolean())
	{
		return;
	}

	invalidateRestoreOptionCache();

	if(!possessEquipment($item[Your Cowboy Boots]) && get_property("telegraphOfficeAvailable").to_boolean() && is_unrestricted($item[LT&T Telegraph Office Deed]))
	{
		#string temp = visit_url("desc_item.php?whichitem=529185925");
		#if(equipped_item($slot[bootspur]) == $item[Nicksilver spurs])
		#if(contains_text(temp, "Item Drops from Monsters"))
		#{
			string temp = visit_url("place.php?whichplace=town_right&action=townright_ltt");
		#}
	}

	auto_saberDailyUpgrade(day);

	if((item_amount($item[cursed microwave]) >= 1) && !get_property("_cursedMicrowaveUsed").to_boolean())
	{
		use(1, $item[cursed microwave]);
	}
	if((item_amount($item[cursed pony keg]) >= 1) && !get_property("_cursedKegUsed").to_boolean())
	{
		use(1, $item[cursed pony keg]);
	}
	if(storage_amount($item[Talking Spade]) > 0)
	{
		pullXWhenHaveY($item[Talking Spade], 1, 0);
	}

	if(item_amount($item[Telegram From Lady Spookyraven]) > 0)
	{
		auto_log_warning("Lady Spookyraven quest not detected as started should have been auto-started. Starting it. If you are not in an Ed run, report this. Otherwise, it is expected.", "red");
		use(1, $item[Telegram From Lady Spookyraven]);
		set_property("questM20Necklace", "started");
	}

	if(internalQuestStatus("questM20Necklace") == -1)
	{
		if(item_amount($item[Telegram From Lady Spookyraven]) > 0)
		{
			auto_log_warning("Lady Spookyraven quest not started and we have a Telegram so let us use it.", "red");
			boolean temp = use(1, $item[Telegram From Lady Spookyraven]);
		}
		else
		{
			auto_log_warning("Lady Spookyraven quest not detected as started but we don't have the telegram, assuming it is... If you are not in an Ed run, report this. Otherwise, it is expected.", "red");
			set_property("questM20Necklace", "started");
		}
	}

	auto_barrelPrayers();

	if(get_property("auto_mummeryChoice") != "")
	{
		string[int] mummeryChoice = split_string(get_property("auto_mummeryChoice"), ";");
		foreach idx, opt in mummeryChoice
		{
			int goal = idx + 1;
			if((opt == "") || (goal > 7))
			{
				continue;
			}
			mummifyFamiliar(to_familiar(opt), goal);
		}
	}

	if(!get_property("_pottedTeaTreeUsed").to_boolean() && (auto_get_campground() contains $item[Potted Tea Tree]) && !get_property("kingLiberated").to_boolean())
	{
		if(get_property("auto_teaChoice") != "")
		{
			string[int] teaChoice = split_string(get_property("auto_teaChoice"), ";");
			item myTea = trim(teaChoice[min(count(teaChoice), my_daycount()) - 1]).to_item();
			if(myTea != $item[none])
			{
				boolean buff = cli_execute("teatree " + myTea);
			}
		}
		else if(day == 1)
		{
			if(fullness_limit() > 0)
			{
				boolean buff = cli_execute("teatree " + $item[Cuppa Voraci Tea]);
			}
			else if(inebriety_limit() > 0)
			{
				boolean buff = cli_execute("teatree " + $item[Cuppa Sobrie Tea]);
			}
			else
			{
				boolean buff = cli_execute("teatree " + $item[Cuppa Royal Tea]);
			}
		}
		else if(day == 2)
		{
			if(inebriety_limit() > 0)
			{
				boolean buff = cli_execute("teatree " + $item[Cuppa Sobrie Tea]);
			}
			else if(fullness_limit() > 0)
			{
				boolean buff = cli_execute("teatree " + $item[Cuppa Voraci Tea]);
			}
			else
			{
				boolean buff = cli_execute("teatree " + $item[Cuppa Royal Tea]);
			}
		}
		else
		{
			visit_url("campground.php?action=teatree");
			run_choice(1);
		}
	}

	auto_floundryAction();

	if((item_amount($item[GameInformPowerDailyPro Magazine]) > 0) && (my_daycount() == 1))
	{
		visit_url("inv_use.php?pwd=&which=3&whichitem=6174", true);
		visit_url("inv_use.php?pwd=&which=3&whichitem=6174&confirm=Yep.", true);
		set_property("auto_disableAdventureHandling", true);
		autoAdv(1, $location[Video Game Level 1]);
		set_property("auto_disableAdventureHandling", false);
		if(item_amount($item[Dungeoneering Kit]) > 0)
		{
			use(1, $item[Dungeoneering Kit]);
		}
	}

	if((item_amount($item[GameInformPowerDailyPro Magazine]) > 0) && (my_daycount() == 2) && (auto_my_path() == "Community Service"))
	{
		visit_url("inv_use.php?pwd=&which=3&whichitem=6174", true);
		visit_url("inv_use.php?pwd=&which=3&whichitem=6174&confirm=Yep.", true);
		set_property("auto_disableAdventureHandling", true);
		autoAdv(1, $location[Video Game Level 1]);
		set_property("auto_disableAdventureHandling", false);
		if(item_amount($item[Dungeoneering Kit]) > 0)
		{
			use(1, $item[Dungeoneering Kit]);
		}
	}

	auto_doPrecinct();
	if((item_amount($item[Cop Dollar]) >= 10) && (item_amount($item[Shoe Gum]) == 0))
	{
		boolean temp = cli_execute("make shoe gum");
	}

	ed_initializeDay(day);
	boris_initializeDay(day);
	fallout_initializeDay(day);
	pete_initializeDay(day);
	cs_initializeDay(day);
	bond_initializeDay(day);
	digimon_initializeDay(day);
	majora_initializeDay(day);
	glover_initializeDay(day);
	bat_initializeDay(day);

	if(day == 1)
	{
		if(get_property("auto_day_init").to_int() < 1)
		{
			if (item_amount($item[Newbiesport&trade; tent]) > 0)
			{
				use(1, $item[Newbiesport&trade; tent]);
			}
			kgbSetup();
			if(item_amount($item[transmission from planet Xi]) > 0)
			{
				use(1, $item[transmission from planet xi]);
			}
			if(item_amount($item[Xiblaxian holo-wrist-puter simcode]) > 0)
			{
				use(1, $item[Xiblaxian holo-wrist-puter simcode]);
			}

			if(have_skill($skill[Iron Palm Technique]) && (have_effect($effect[Iron Palms]) == 0) && (my_class() == $class[Seal Clubber]))
			{
				use_skill(1, $skill[Iron Palm Technique]);
			}

			if((auto_get_clan_lounge() contains $item[Clan Floundry]) && (item_amount($item[Fishin\' Pole]) == 0))
			{
				visit_url("clan_viplounge.php?action=floundry");
			}

			visit_url("tutorial.php?action=toot");
			use(item_amount($item[Letter From King Ralph XI]), $item[Letter From King Ralph XI]);
			use(item_amount($item[Pork Elf Goodies Sack]), $item[Pork Elf Goodies Sack]);
			tootGetMeat();

			hr_initializeDay(day);
			// It's nice to have a moxie weapon for Flock of Bats form
			if(my_class() == $class[Vampyre] && get_property("darkGyfftePoints").to_int() < 21 && !possessEquipment($item[disco ball]))
			{
				acquireGumItem($item[disco ball]);
			}
			if(!($classes[Avatar of Boris, Avatar of Jarlsberg, Avatar of Sneaky Pete, Ed, Vampyre] contains my_class()))
			{
				if((item_amount($item[Antique Accordion]) == 0) && (item_amount($item[Aerogel Accordion]) == 0) && (auto_predictAccordionTurns() < 5) && ((my_meat() > npc_price($item[Toy Accordion])) && (npc_price($item[Toy Accordion]) != 0)))
				{
					//Try to get Antique Accordion early if we possibly can.
					if(isUnclePAvailable() && ((my_meat() > npc_price($item[Antique Accordion])) && (npc_price($item[Antique Accordion]) != 0)) && (auto_my_path() != "G-Lover"))
					{
						buyUpTo(1, $item[Antique Accordion]);
					}
					// Removed "else". In some situations when mafia or supporting scripts are behaving wonky we may completely fail to get an accordion
					if((isArmoryAvailable()) && (item_amount($item[Antique Accordion]) == 0))
					{
						buyUpTo(1, $item[Toy Accordion]);
					}
				}
				if(!possessEquipment($item[Turtle Totem]))
				{
					acquireGumItem($item[Turtle Totem]);
				}
				if(!possessEquipment($item[Saucepan]))
				{
					acquireGumItem($item[Saucepan]);
				}
			}

			makeStartingSmiths();

			handleFamiliar("item");
			equipBaseline();

			handleBjornify($familiar[none]);
			handleBjornify($familiar[El Vibrato Megadrone]);

			string temp = visit_url("guild.php?place=challenge");

			if(get_property("auto_breakstone").to_boolean())
			{
				temp = visit_url("peevpee.php?action=smashstone&pwd&confirm=on", true);
				temp = visit_url("peevpee.php?place=fight");
				set_property("auto_breakstone", false);
			}

			auto_beachCombHead("exp");
		}

		if((get_property("lastCouncilVisit").to_int() < my_level()) && (auto_my_path() != "Community Service"))
		{
			cli_execute("counters");
			council();
		}
	}
	else if(day == 2)
	{
		equipBaseline();
		fortuneCookieEvent();

		if(get_property("auto_day_init").to_int() < 2)
		{
			if((item_amount($item[Tonic Djinn]) > 0) && !get_property("_tonicDjinn").to_boolean())
			{
				set_property("choiceAdventure778", "2");
				use(1, $item[Tonic Djinn]);
			}
			if(item_amount($item[gym membership card]) > 0)
			{
				use(1, $item[gym membership card]);
			}

			hr_initializeDay(day);

			if(!in_hardcore() && (item_amount($item[Handful of Smithereens]) <= 5))
			{
				pulverizeThing($item[Hairpiece On Fire]);
				pulverizeThing($item[Vicar\'s Tutu]);
			}
			while(acquireHermitItem($item[Ten-Leaf Clover]));
			if((item_amount($item[Antique Accordion]) == 0) && (item_amount($item[Aerogel Accordion]) == 0) && isUnclePAvailable() && ((my_meat() > npc_price($item[Antique Accordion])) && (npc_price($item[Antique Accordion]) != 0)) && (auto_predictAccordionTurns() < 10) && !($classes[Avatar of Boris, Avatar of Jarlsberg, Avatar of Sneaky Pete, Ed, Vampyre] contains my_class()) && (auto_my_path() != "G-Lover"))
			{
				buyUpTo(1, $item[Antique Accordion]);
			}
			if(my_class() == $class[Avatar of Boris])
			{
				if((item_amount($item[Clancy\'s Crumhorn]) == 0) && (minstrel_instrument() != $item[Clancy\'s Crumhorn]))
				{
					buyUpTo(1, $item[Clancy\'s Crumhorn]);
				}
			}
			if(auto_have_skill($skill[Summon Smithsness]) && (my_mp() > (3 * mp_cost($skill[Summon Smithsness]))))
			{
				use_skill(3, $skill[Summon Smithsness]);
			}

			if(item_amount($item[handful of smithereens]) >= 2)
			{
				buyUpTo(2, $item[Ben-Gal&trade; Balm], 25);
				cli_execute("make 2 louder than bomb");
			}

			if(get_property("auto_dickstab").to_boolean())
			{
				pullXWhenHaveY($item[frost flower], 1, 0);
			}
		}
		if (chateaumantegna_havePainting() && !isActuallyEd() && auto_my_path() != "Community Service")
		{
			if(auto_have_familiar($familiar[Reanimated Reanimator]))
			{
				handleFamiliar($familiar[Reanimated Reanimator]);
			}
			chateaumantegna_usePainting();
			handleFamiliar($familiar[Angry Jung Man]);
		}
	}
	else if(day == 3)
	{
		if(get_property("auto_day_init").to_int() < 3)
		{
			while(acquireHermitItem($item[Ten-leaf Clover]));

			picky_pulls();
			standard_pulls();

		}
	}
	else if(day == 4)
	{
		if(get_property("auto_day_init").to_int() < 4)
		{
			while(acquireHermitItem($item[Ten-leaf Clover]));
		}
	}
	if(day >= 2)
	{
		ovenHandle();
	}

	string campground = visit_url("campground.php");
	if(contains_text(campground, "beergarden7.gif"))
	{
		cli_execute("garden pick");
	}
	if(contains_text(campground, "wintergarden3.gif"))
	{
		cli_execute("garden pick");
	}
	if(contains_text(campground, "thanksgardenmega.gif"))
	{
		cli_execute("garden pick");
	}

	set_property("auto_forceNonCombatSource", "");

	set_property("auto_day_init", day);
}

boolean dailyEvents()
{
	while(auto_doPrecinct());
	handleBarrelFullOfBarrels(true);

	auto_campawayGrabBuffs();
	kgb_getMartini();
	fightClubNap();
	fightClubStats();

	chateaumantegna_useDesk();

	if((item_amount($item[Burned Government Manual Fragment]) > 0) && is_unrestricted($item[Burned Government Manual Fragment]) && get_property("auto_alienLanguage").to_boolean())
	{
		use(item_amount($item[Burned Government Manual Fragment]), $item[Burned Government Manual Fragment]);
	}

	if((item_amount($item[glass gnoll eye]) > 0) && !get_property("_gnollEyeUsed").to_boolean())
	{
		use(1, $item[Glass gnoll Eye]);
	}
	if((item_amount($item[chroner trigger]) > 0) && !get_property("_chronerTriggerUsed").to_boolean())
	{
		use(1, $item[chroner trigger]);
	}
	if((item_amount($item[chroner cross]) > 0) && !get_property("_chronerCrossUsed").to_boolean())
	{
		use(1, $item[chroner cross]);
	}
	if((item_amount($item[chester\'s bag of candy]) > 0) && !get_property("_bagOfCandyUsed").to_boolean())
	{
		use(1, $item[chester\'s bag of candy]);
	}
	if((item_amount($item[cheap toaster]) > 0) && !get_property("_toastSummoned").to_boolean())
	{
		use(1, $item[cheap toaster]);
	}
	if((item_amount($item[warbear breakfast machine]) > 0) && !get_property("_warbearBreakfastMachineUsed").to_boolean())
	{
		use(1, $item[warbear breakfast machine]);
	}
	if((item_amount($item[warbear soda machine]) > 0) && !get_property("_warbearSodaMachineUsed").to_boolean())
	{
		use(1, $item[warbear soda machine]);
	}
	if((item_amount($item[the cocktail shaker]) > 0) && !get_property("_cocktailShakerUsed").to_boolean())
	{
		use(1, $item[the cocktail shaker]);
	}
	if((item_amount($item[taco dan\'s taco stand flier]) > 0) && !get_property("_tacoFlierUsed").to_boolean())
	{
		use(1, $item[taco dan\'s taco stand flier]);
	}
	if((item_amount($item[Festive Warbear Bank]) > 0) && !get_property("_warbearBankUsed").to_boolean())
	{
		use(1, $item[Festive Warbear Bank]);
	}

	if((item_amount($item[Can of Rain-doh]) > 0) && (item_amount($item[Rain-Doh Red Wings]) == 0))
	{
		use(1, $item[can of Rain-doh]);
		put_closet(1, $item[empty rain-doh can]);
	}

	if(item_amount($item[Clan VIP Lounge Key]) > 0)
	{
		if(!get_property("_olympicSwimmingPoolItemFound").to_boolean() && is_unrestricted($item[Olympic-sized Clan Crate]))
		{
			cli_execute("swim item");
		}
		if(!get_property("_lookingGlass").to_boolean() && is_unrestricted($item[Clan Looking Glass]))
		{
			string temp = visit_url("clan_viplounge.php?action=lookingglass");
		}
		if(get_property("_deluxeKlawSummons").to_int() == 0)
		{
			cli_execute("clan_viplounge.php?action=klaw");
			cli_execute("clan_viplounge.php?action=klaw");
			cli_execute("clan_viplounge.php?action=klaw");
		}
		if(!get_property("_crimboTree").to_boolean() && is_unrestricted($item[Crimbough]))
		{
			cli_execute("crimbotree get");
		}
	}

	if((get_property("_klawSummons").to_int() == 0) && (get_clan_id() != -1))
	{
		cli_execute("clan_rumpus.php?action=click&spot=3&furni=3");
		cli_execute("clan_rumpus.php?action=click&spot=3&furni=3");
		cli_execute("clan_rumpus.php?action=click&spot=3&furni=3");
	}

	if((item_amount($item[Infinite BACON Machine]) > 0) && !get_property("_baconMachineUsed").to_boolean())
	{
		use(1, $item[Infinite BACON Machine]);
	}
	if((item_amount($item[Picky Tweezers]) > 0) && !get_property("_pickyTweezersUsed").to_boolean())
	{
		use(1, $item[Picky Tweezers]);
	}

	if(have_skill($skill[That\'s Not a Knife]) && !get_property("_discoKnife").to_boolean())
	{
		foreach it in $items[Boot Knife, Broken Beer Bottle, Candy Knife, Sharpened Spoon, Soap Knife]
		{
			if(item_amount(it) == 1)
			{
				put_closet(1, it);
			}
		}
		use_skill(1, $skill[That\'s Not a Knife]);
	}

	while(zataraClanmate(""));

	if(item_amount($item[Genie Bottle]) > 0 && auto_is_valid($item[pocket wish]))
	{
		for(int i=get_property("_genieWishesUsed").to_int(); i<3; i++)
		{
			makeGeniePocket();
		}
	}

	return true;
}

boolean doBedtime()
{
	auto_log_info("Starting bedtime: Pulls Left: " + pulls_remaining(), "blue");

	if(get_property("lastEncounter") == "Like a Bat Into Hell")
	{
		abort("Our last encounter was UNDYING and we ended up trying to bedtime and failed.");
	}

	auto_process_kmail("auto_deleteMail");

	if(my_adventures() > 4)
	{
		if(my_inebriety() <= inebriety_limit())
		{
			if(my_class() != $class[Gelatinous Noob] && my_familiar() != $familiar[Stooper])
			{
				return false;
			}
		}
	}
	boolean out_of_blood = (my_class() == $class[Vampyre] && item_amount($item[blood bag]) == 0);
	if((fullness_left() > 0) && can_eat() && !out_of_blood)
	{
		return false;
	}
	if((inebriety_left() > 0) && can_drink() && !out_of_blood)
	{
		return false;
	}
	int spleenlimit = spleen_limit();
	if(is100FamiliarRun())
	{
		spleenlimit -= 3;
	}
	if(!haveSpleenFamiliar())
	{
		spleenlimit = 0;
	}
	if((my_spleen_use() < spleenlimit) && !in_hardcore() && (inebriety_left() > 0))
	{
		return false;
	}

	ed_terminateSession();
	bat_terminateSession();

	equipBaseline();
	while(true)
	{
		resetMaximize();
		handleFamiliar("stat");
		if(!LX_freeCombats()) break;
	}

	if((my_class() == $class[Seal Clubber]) && guild_store_available() && (auto_my_path() != "G-Lover"))
	{
		handleFamiliar("stat");
		int oldSeals = get_property("_sealsSummoned").to_int();
		while((get_property("_sealsSummoned").to_int() < 5) && (!get_property("kingLiberated").to_boolean()) && (my_meat() > 4500))
		{
			boolean summoned = false;
			if((my_daycount() == 1) && (my_level() >= 6) && isHermitAvailable())
			{
				cli_execute("make figurine of an ancient seal");
				buyUpTo(3, $item[seal-blubber candle]);
				ensureSealClubs();
				handleSealAncient();
				summoned = true;
			}
			else if(my_level() >= 9)
			{
				buyUpTo(1, $item[figurine of an armored seal]);
				buyUpTo(10, $item[seal-blubber candle]);
				ensureSealClubs();
				handleSealNormal($item[Figurine of an Armored Seal]);
				summoned = true;
			}
			else if(my_level() >= 5)
			{
				buyUpTo(1, $item[figurine of a Cute Baby Seal]);
				buyUpTo(5, $item[seal-blubber candle]);
				ensureSealClubs();
				handleSealNormal($item[Figurine of a Cute Baby Seal]);
				summoned = true;
			}
			else
			{
				buyUpTo(1, $item[figurine of a Wretched-Looking Seal]);
				buyUpTo(1, $item[seal-blubber candle]);
				ensureSealClubs();
				handleSealNormal($item[Figurine of a Wretched-Looking Seal]);
				summoned = true;
			}
			int newSeals = get_property("_sealsSummoned").to_int();
			if((newSeals == oldSeals) && summoned)
			{
				abort("Unable to summon seals.");
			}
			oldSeals = newSeals;
		}
	}

	if(get_property("auto_priorCharpaneMode").to_int() == 1)
	{
		auto_log_info("Resuming Compact Character Mode.");
		set_property("auto_priorCharpaneMode", 0);
		visit_url("account.php?am=1&pwd=&action=flag_compactchar&value=1&ajax=0", true);
	}

	if((item_amount($item[License To Chill]) > 0) && !get_property("_licenseToChillUsed").to_boolean())
	{
		use(1, $item[License To Chill]);
	}

	if((my_inebriety() <= inebriety_limit()) && can_drink() && (my_rain() >= 50) && (my_adventures() >= 1))
	{
		if(my_daycount() == 1)
		{
			if(item_amount($item[Rain-Doh Indigo Cup]) > 0)
			{
				auto_log_info("Copies left: " + (5 - get_property("_raindohCopiesMade").to_int()), "olive");
			}
			if(!in_hardcore())
			{
				auto_log_info("Pulls remaining: " + pulls_remaining(), "olive");
			}
			if(item_amount($item[beer helmet]) == 0)
			{
				auto_log_info("Please consider an orcish frat boy spy (You want Frat Warrior Fatigues).", "blue");
				if(canYellowRay())
				{
					auto_log_info("Make sure to Ball Lightning the spy!!", "red");
				}
			}
			else
			{
				auto_log_info("If you have the Frat Warrior Fatigues, rain man an Astronomer? Skinflute?", "blue");
			}
		}
		if(auto_have_familiar($familiar[Machine Elf]) && (get_property("_machineTunnelsAdv").to_int() < 5) && (inebriety_left() >= 0) && (my_adventures() > 0))
		{
			auto_log_info("You have " + (5 - get_property("_machineTunnelsAdv").to_int()) + " fights in The Deep Machine Tunnels that you should use!", "blue");
		}
		auto_log_info("You have a rain man to cast, please do so before overdrinking and run me again.", "red");
		return false;
	}

	//We are committing to end of day now...
	getSpaceJelly();
	while(acquireHermitItem($item[Ten-leaf Clover]));

	loveTunnelAcquire(true, $stat[none], true, 3, true, 1);

	if(item_amount($item[Genie Bottle]) > 0)
	{
		for(int i=get_property("_genieWishesUsed").to_int(); i<3; i++)
		{
			makeGeniePocket();
		}
	}
	if(canGenieCombat() && item_amount($item[beer helmet]) == 0)
	{
		auto_log_info("Please consider genie wishing for an orcish frat boy spy (You want Frat Warrior Fatigues).", "blue");
	}

	if((friars_available()) && (!get_property("friarsBlessingReceived").to_boolean()))
	{
		if(auto_my_path() == "Pocket Familiars" || my_class() == $class[Vampyre])
		{
			cli_execute("friars food");
		}
		else
		{
			cli_execute("friars familiar");
		}
	}

	# This does not check if we still want these buffs
	if((my_hp() < (0.9 * my_maxhp())) && hotTubSoaksRemaining() > 0)
	{
		boolean doTub = true;
		foreach eff in $effects[Once-Cursed, Thrice-Cursed, Twice-Cursed]
		{
			if(have_effect(eff) > 0)
			{
				doTub = false;
			}
		}
		if(doTub)
		{
			doHottub();
		}
	}

	if(!get_property("_mayoTankSoaked").to_boolean() && (auto_get_campground() contains $item[Portable Mayo Clinic]) && is_unrestricted($item[Portable Mayo Clinic]))
	{
		string temp = visit_url("shop.php?action=bacta&whichshop=mayoclinic");
	}

	if((auto_my_path() == "Nuclear Autumn") && (get_property("falloutShelterLevel").to_int() >= 3) && !get_property("_falloutShelterSpaUsed").to_boolean())
	{
		string temp = visit_url("place.php?whichplace=falloutshelter&action=vault3");
	}

	//	Also use "nunsVisits", as long as they were won by the Frat (sidequestNunsCompleted="fratboy").
	ed_doResting();
	skill libram = preferredLibram();
	if(libram != $skill[none])
	{
		while(haveFreeRestAvailable() && (mp_cost(libram) <= my_maxmp()))
		{
			doFreeRest();
			while(my_mp() > mp_cost(libram))
			{
				use_skill(1, libram);
			}
		}
	}

	if((is_unrestricted($item[Clan Pool Table])) && (get_property("_poolGames").to_int() < 3) && (item_amount($item[Clan VIP Lounge Key]) > 0))
	{
		visit_url("clan_viplounge.php?preaction=poolgame&stance=1");
		visit_url("clan_viplounge.php?preaction=poolgame&stance=1");
		visit_url("clan_viplounge.php?preaction=poolgame&stance=3");
	}
	if(is_unrestricted($item[Colorful Plastic Ball]) && !get_property("_ballpit").to_boolean() && (get_clan_id() != -1))
	{
		cli_execute("ballpit");
	}
	if((get_property("telescopeUpgrades").to_int() > 0) && (get_property("auto_sorceress") == ""))
	{
		if(get_property("telescopeLookedHigh") == "false")
		{
			cli_execute("telescope high");
		}
	}

	if(!possessEquipment($item[Vicar\'s Tutu]) && (my_daycount() == 1) && (item_amount($item[lump of Brituminous coal]) > 0))
	{
		if((item_amount($item[frilly skirt]) < 1) && knoll_available())
		{
			buyUpTo(1, $item[frilly skirt]);
		}
		if(item_amount($item[frilly skirt]) > 0)
		{
			autoCraft("smith", 1, $item[lump of Brituminous coal], $item[frilly skirt]);
		}
	}

	if((my_daycount() == 1) && (possessEquipment($item[Thor\'s Pliers]) || (freeCrafts() > 0)) && !possessEquipment($item[Chrome Sword]) && !get_property("kingLiberated").to_boolean() && !in_tcrs())
	{
		item oreGoal = to_item(get_property("trapperOre"));
		int need = 1;
		if(oreGoal == $item[Chrome Ore])
		{
			need = 4;
		}
		if((item_amount($item[Chrome Ore]) >= need) && !possessEquipment($item[Chrome Sword]) && isArmoryAvailable())
		{
			cli_execute("make " + $item[Chrome Sword]);
		}
	}

	equipRollover();
	hr_doBedtime();

	while((my_daycount() == 1) && (item_amount($item[resolution: be more adventurous]) > 0) && (get_property("_resolutionAdv").to_int() < 10) && (get_property("_casualAscension").to_int() < my_ascensions()))
	{
		use(1, $item[resolution: be more adventurous]);
	}

	// If in TCRS skip using freecrafts but alert user of how many they can manually use.
	if((in_tcrs()) && (freeCrafts() > 0))
	{
		auto_log_warning("In TCRS: Items are variable, skipping End Of Day crafting", "red");
		auto_log_warning("Consider manually using your "+freeCrafts()+" free crafts", "red");
	}
	else if((my_daycount() <= 2) && (freeCrafts() > 0) && my_adventures() > 0)
	{
		// Check for rapid prototyping
		while((freeCrafts() > 0) && (item_amount($item[Scrumptious Reagent]) > 0) && (item_amount($item[Cranberries]) > 0) && (item_amount($item[Cranberry Cordial]) < 2) && have_skill($skill[Advanced Saucecrafting]))
		{
			cli_execute("make " + $item[Cranberry Cordial]);
		}
		put_closet(item_amount($item[Cranberries]), $item[Cranberries]);
		while((freeCrafts() > 0) && (item_amount($item[Scrumptious Reagent]) > 0) && (item_amount($item[Glass Of Goat\'s Milk]) > 0) && (item_amount($item[Milk Of Magnesium]) < 2) && have_skill($skill[Advanced Saucecrafting]))
		{
			cli_execute("make " + $item[Milk Of Magnesium]);
		}
	}

	dna_bedtime();

	if((get_property("_grimBuff") == "false") && auto_have_familiar($familiar[Grim Brother]))
	{
		string temp = visit_url("choice.php?pwd=&whichchoice=835&option=1", true);
	}

	dailyEvents();
	if((get_property("auto_clanstuff").to_int() < my_daycount()) && (get_clan_id() != -1))
	{
		if(is_unrestricted($item[Olympic-sized Clan Crate]) && !get_property("_olympicSwimmingPool").to_boolean())
		{
			cli_execute("swim noncombat");
		}
		if(is_unrestricted($item[Olympic-sized Clan Crate]) && !get_property("_olympicSwimmingPoolItemFound").to_boolean())
		{
			cli_execute("swim item");
		}
		if(get_property("_klawSummons").to_int() == 0)
		{
			cli_execute("clan_rumpus.php?action=click&spot=3&furni=3");
			cli_execute("clan_rumpus.php?action=click&spot=3&furni=3");
			cli_execute("clan_rumpus.php?action=click&spot=3&furni=3");
		}
		if(is_unrestricted($item[Clan Looking Glass]) && !get_property("_lookingGlass").to_boolean())
		{
			string temp = visit_url("clan_viplounge.php?action=lookingglass");
		}
		if(get_property("_deluxeKlawSummons").to_int() == 0)
		{
			cli_execute("clan_viplounge.php?action=klaw");
			cli_execute("clan_viplounge.php?action=klaw");
			cli_execute("clan_viplounge.php?action=klaw");
		}
		if(!get_property("_aprilShower").to_boolean())
		{
			if(get_property("kingLiberated").to_boolean())
			{
				cli_execute("shower ice");
			}
			else
			{
				cli_execute("shower " + my_primestat());
			}
		}
		if(is_unrestricted($item[Crimbough]) && !get_property("_crimboTree").to_boolean())
		{
			cli_execute("crimbotree get");
		}
		set_property("auto_clanstuff", ""+my_daycount());
	}

	if((get_property("sidequestOrchardCompleted") != "none") && !get_property("_hippyMeatCollected").to_boolean())
	{
		visit_url("shop.php?whichshop=hippy");
	}

	if((get_property("sidequestArenaCompleted") != "none") && !get_property("concertVisited").to_boolean())
	{
		cli_execute("concert 2");
	}
	if(get_property("kingLiberated").to_boolean())
	{
		if((item_amount($item[The Legendary Beat]) > 0) && !get_property("_legendaryBeat").to_boolean())
		{
			use(1, $item[The Legendary Beat]);
		}
		if(auto_have_skill($skill[Summon Clip Art]) && get_property("_clipartSummons").to_int() == 0)
		{
			cli_execute("make unbearable light");
		}
		if(auto_have_skill($skill[Summon Clip Art]) && get_property("_clipartSummons").to_int() == 1)
		{
			cli_execute("make cold-filtered water");
		}
		if(auto_have_skill($skill[Summon Clip Art]) && get_property("_clipartSummons").to_int() == 2)
		{
			cli_execute("make bucket of wine");
		}
		if((item_amount($item[Handmade Hobby Horse]) > 0) && !get_property("_hobbyHorseUsed").to_boolean())
		{
			use(1, $item[Handmade Hobby Horse]);
		}
		if((item_amount($item[ball-in-a-cup]) > 0) && !get_property("_ballInACupUsed").to_boolean())
		{
			use(1, $item[ball-in-a-cup]);
		}
		if((item_amount($item[set of jacks]) > 0) && !get_property("_setOfJacksUsed").to_boolean())
		{
			use(1, $item[set of jacks]);
		}
	}

	if((my_daycount() - 5) >= get_property("lastAnticheeseDay").to_int())
	{
		visit_url("place.php?whichplace=desertbeach&action=db_nukehouse");
	}

	if(auto_haveWitchess() && (get_property("puzzleChampBonus").to_int() == 20) && !get_property("_witchessBuff").to_boolean())
	{
		visit_url("campground.php?action=witchess");
		visit_url("choice.php?whichchoice=1181&pwd=&option=3");
		visit_url("choice.php?whichchoice=1183&pwd=&option=2");
	}

	if(auto_haveSourceTerminal())
	{
		int enhances = auto_sourceTerminalEnhanceLeft();
		while(enhances > 0)
		{
			auto_sourceTerminalEnhance("items");
			auto_sourceTerminalEnhance("meat");
			enhances -= 2;
		}
	}

	// Is +50% to all stats the best choice here? I don't know!
	spacegateVaccine($effect[Broad-Spectrum Vaccine]);

	zataraSeaside("item");

	if(is_unrestricted($item[Source Terminal]) && (get_campground() contains $item[Source Terminal]))
	{
		if(!get_property("_kingLiberated").to_boolean() && (get_property("auto_extrudeChoice") != "none"))
		{
			int count = 3 - get_property("_sourceTerminalExtrudes").to_int();

			string[int] extrudeChoice;
			if(get_property("auto_extrudeChoice") != "")
			{
				string[int] extrudeDays = split_string(get_property("auto_extrudeChoice"), ":");
				string[int] tempChoice = split_string(trim(extrudeDays[min(count(extrudeDays), my_daycount()) - 1]), ";");
				for(int i=0; i<count(tempChoice); i++)
				{
					extrudeChoice[i] = tempChoice[i];
				}
			}
			int amt = count(extrudeChoice);
			string acquire = "booze";
			if(auto_my_path() == "Teetotaler")
			{
				acquire = "food";
			}
			while(amt < 3)
			{
				extrudeChoice[count(extrudeChoice)] = acquire;
				amt++;
			}

			while((count > 0) && (item_amount($item[Source Essence]) >= 10))
			{
				auto_sourceTerminalExtrude(extrudeChoice[3-count]);
				count -= 1;
			}
		}
		int extrudeLeft = 3 - get_property("_sourceTerminalExtrudes").to_int();
		if((extrudeLeft > 0) && (auto_my_path() != "Pocket Familiars") && (item_amount($item[Source Essence]) >= 10))
		{
			auto_log_info("You still have " + extrudeLeft + " Source Extrusions left", "blue");
		}
	}

	if(item_amount($item[Rain-Doh Indigo Cup]) > 0)
	{
		auto_log_info("Copies left: " + (5 - get_property("_raindohCopiesMade").to_int()), "olive");
	}
	if(!in_hardcore())
	{
		auto_log_info("Pulls remaining: " + pulls_remaining(), "olive");
	}

	if(have_skill($skill[Inigo\'s Incantation of Inspiration]))
	{
		int craftingLeft = 5 - get_property("_inigosCasts").to_int();
		auto_log_info("Free Inigo\'s craftings left: " + craftingLeft, "blue");
	}
	if(item_amount($item[Loathing Legion Jackhammer]) > 0)
	{
		int craftingLeft = 3 - get_property("_legionJackhammerCrafting").to_int();
		auto_log_info("Free Loathing Legion Jackhammer craftings left: " + craftingLeft, "blue");
	}
	if(item_amount($item[Thor\'s Pliers]) > 0)
	{
		int craftingLeft = 10 - get_property("_thorsPliersCrafting").to_int();
		auto_log_info("Free Thor's Pliers craftings left: " + craftingLeft, "blue");
	}
	if(freeCrafts() > 0)
	{
		auto_log_info("Free craftings left: " + freeCrafts(), "blue");
	}
	if(get_property("timesRested").to_int() < total_free_rests())
	{
		cs_spendRests();
		auto_log_info("You have " + (total_free_rests() - get_property("timesRested").to_int()) + " free rests remaining.", "blue");
	}
	if(possessEquipment($item[Kremlin\'s Greatest Briefcase]) && (get_property("_kgbClicksUsed").to_int() < 24))
	{
		kgbWasteClicks();
		int clicks = 22 - get_property("_kgbClicksUsed").to_int();
		if(clicks > 0)
		{
			auto_log_info("You have some KGB clicks (" + clicks + ") left!", "green");
		}
	}
	if((get_property("sidequestNunsCompleted") == "fratboy") && (get_property("nunsVisits").to_int() < 3))
	{
		auto_log_info("You have " + (3 - get_property("nunsVisits").to_int()) + " nuns visits left.", "blue");
	}
	if(get_property("libramSummons").to_int() > 0)
	{
		auto_log_info("Total Libram Summons: " + get_property("libramSummons"), "blue");
	}

	int smiles = (5 * (item_amount($item[Golden Mr. Accessory]) + storage_amount($item[Golden Mr. Accessory]) + closet_amount($item[Golden Mr. Accessory]))) - get_property("_smilesOfMrA").to_int();
	if(auto_my_path() == "G-Lover")
	{
		smiles = 0;
	}
	if(smiles > 0)
	{
		if(get_property("auto_smileAt") != "")
		{
			cli_execute("/cast " + smiles + " the smile @ " + get_property("auto_smileAt"));
		}
		else
		{
			auto_log_info("You have " + smiles + " smiles of Mr. A remaining.", "blue");
		}
	}

	if((item_amount($item[CSA Fire-Starting Kit]) > 0) && (!get_property("_fireStartingKitUsed").to_boolean()))
	{
		auto_log_info("Still have a CSA Fire-Starting Kit you can use!", "blue");
	}
	if((item_amount($item[Glenn\'s Golden Dice]) > 0) && (!get_property("_glennGoldenDiceUsed").to_boolean()))
	{
		auto_log_info("Still have some of Glenn's Golden Dice that you can use!", "blue");
	}
	if((item_amount($item[License to Chill]) > 0) && (!get_property("_licenseToChillUsed").to_boolean()))
	{
		auto_log_info("You are still licensed enough to be able to chill.", "blue");
	}

	if((item_amount($item[School of Hard Knocks Diploma]) > 0) && (!get_property("_hardKnocksDiplomaUsed").to_boolean()))
	{
		use(1, $item[School of Hard Knocks Diploma]);
	}

	if(!get_property("_lyleFavored").to_boolean())
	{
		string temp = visit_url("place.php?whichplace=monorail&action=monorail_lyle");
	}

	if (get_property("spookyAirportAlways").to_boolean() && !isActuallyEd() && !get_property("_controlPanelUsed").to_boolean())
	{
		visit_url("place.php?whichplace=airport_spooky_bunker&action=si_controlpanel");
		visit_url("choice.php?pwd=&whichchoice=986&option=8",true);
		if(get_property("controlPanelOmega").to_int() >= 99)
		{
			visit_url("choice.php?pwd=&whichchoice=986&option=10",true);
		}
	}

	elementalPlanes_takeJob($element[spooky]);
	elementalPlanes_takeJob($element[stench]);
	elementalPlanes_takeJob($element[cold]);

	if((get_property("auto_dickstab").to_boolean()) && chateaumantegna_available() && (my_daycount() == 1))
	{
		boolean[item] furniture = chateaumantegna_decorations();
		if(!furniture[$item[Artificial Skylight]])
		{
			chateaumantegna_buyStuff($item[Artificial Skylight]);
		}
	}

	auto_beachUseFreeCombs();

	boolean done = (my_inebriety() > inebriety_limit()) || (my_inebriety() == inebriety_limit() && my_familiar() == $familiar[Stooper]);
	if((my_class() == $class[Gelatinous Noob]) || !can_drink() || out_of_blood)
	{
		if((my_adventures() <= 1) || (internalQuestStatus("questL13Final") >= 14))
		{
			done = true;
		}
	}
	if(!done)
	{
		auto_log_info("Goodnight done, please make sure to handle your overdrinking, then you can run me again.", "blue");
		if(auto_have_familiar($familiar[Stooper]) && (inebriety_left() == 0) && (my_familiar() != $familiar[Stooper]) && (auto_my_path() != "Pocket Familiars"))
		{
			auto_log_info("You have a Stooper, you can increase liver by 1!", "blue");
			use_familiar($familiar[Stooper]);
		}
		if(auto_have_familiar($familiar[Machine Elf]) && (get_property("_machineTunnelsAdv").to_int() < 5))
		{
			auto_log_info("You have " + (5 - get_property("_machineTunnelsAdv").to_int()) + " fights in The Deep Machine Tunnels that you should use!", "blue");
		}
		if((my_inebriety() <= inebriety_limit()) && (my_rain() >= 50) && (my_adventures() >= 1))
		{
			if(item_amount($item[beer helmet]) == 0)
			{
				auto_log_info("Please consider an orcish frat boy spy (You want Frat Warrior Fatigues).", "blue");
				if(canYellowRay())
				{
					auto_log_info("Make sure to Ball Lightning the spy!!", "red");
				}
			}
			else
			{
				auto_log_info("If you have the Frat Warrior Fatigues, rain man an Astronomer? Skinflute?", "blue");
			}
			auto_log_info("You have a rain man to cast, please do so before overdrinking and then run me again.", "red");
			return false;
		}
		auto_autoDrinkNightcap(true); // simulate;
		auto_log_warning("You need to overdrink and then run me again. Beep.", "red");
		if(have_skill($skill[The Ode to Booze]))
		{
			shrugAT($effect[Ode to Booze]);
			buffMaintain($effect[Ode to Booze], 0, 1, 1);
		}
		return false;
	}
	else
	{
		if(!get_property("kingLiberated").to_boolean())
		{
			auto_log_info(get_property("auto_banishes_day" + my_daycount()));
			auto_log_info(get_property("auto_yellowRay_day" + my_daycount()));
			pullsNeeded("evaluate");
			if(!get_property("_photocopyUsed").to_boolean() && (is_unrestricted($item[Deluxe Fax Machine])) && (my_adventures() > 0) && !($classes[Avatar of Boris, Avatar of Sneaky Pete] contains my_class()) && (item_amount($item[Clan VIP Lounge Key]) > 0))
			{
				auto_log_info("You may have a fax that you can use. Check it out!", "blue");
			}
			if((pulls_remaining() > 0) && (my_daycount() == 1))
			{
				string consider = "";
				boolean[item] cList;
				cList = $items[Antique Machete, wet stew, blackberry galoshes, drum machine, killing jar];
				if(my_class() == $class[Avatar of Boris])
				{
					cList = $items[wet stew, blackberry galoshes, drum machine, killing jar];
				}
				foreach it in cList
				{
					if(item_amount(it) == 0)
					{
						if(consider == "")
						{
							consider = consider + it;
						}
						else
						{
							consider = consider + ", " + it;
						}
					}
				}
				auto_log_warning("You still have pulls, consider: " + consider + "?", "red");
			}
		}

		if(have_skill($skill[Calculate the Universe]) && (get_property("_universeCalculated").to_int() < get_property("skillLevel144").to_int()))
		{
			auto_log_info("You can still Calculate the Universe!", "blue");
		}

		if(is_unrestricted($item[Deck of Every Card]) && (item_amount($item[Deck of Every Card]) > 0) && (get_property("_deckCardsDrawn").to_int() < 15))
		{
			auto_log_info("You have a Deck of Every Card and " + (15 - get_property("_deckCardsDrawn").to_int()) + " draws remaining!", "blue");
		}

		if(is_unrestricted($item[Time-Spinner]) && (item_amount($item[Time-Spinner]) > 0) && (get_property("_timeSpinnerMinutesUsed").to_int() < 10) && glover_usable($item[Time-Spinner]))
		{
			auto_log_info("You have " + (10 - get_property("_timeSpinnerMinutesUsed").to_int()) + " minutes left to Time-Spinner!", "blue");
		}

		if(is_unrestricted($item[Chateau Mantegna Room Key]) && !get_property("_chateauMonsterFought").to_boolean() && get_property("chateauAvailable").to_boolean())
		{
			auto_log_info("You can still fight a Chateau Mangtegna Painting today.", "blue");
		}

		if(stills_available() > 0)
		{
			auto_log_info("You have " + stills_available() + " uses of Nash Crosby's Still left.", "blue");
		}

		if(!get_property("_streamsCrossed").to_boolean() && possessEquipment($item[Protonic Accelerator Pack]))
		{
			cli_execute("crossstreams");
		}

		if(is_unrestricted($item[shrine to the Barrel God]) && !get_property("_barrelPrayer").to_boolean() && get_property("barrelShrineUnlocked").to_boolean())
		{
			auto_log_info("You can still worship the barrel god today.", "blue");
		}
		if(is_unrestricted($item[Airplane Charter: Dinseylandfill]) && !get_property("_dinseyGarbageDisposed").to_boolean() && elementalPlanes_access($element[stench]))
		{
			if((item_amount($item[bag of park garbage]) > 0) || (pulls_remaining() > 0))
			{
				auto_log_info("You can still dispose of Garbage in Dinseyland.", "blue");
			}
		}
		if(is_unrestricted($item[Airplane Charter: That 70s Volcano]) && !get_property("_infernoDiscoVisited").to_boolean() && elementalPlanes_access($element[hot]))
		{
			if((item_amount($item[Smooth Velvet Hat]) > 0) || (item_amount($item[Smooth Velvet Shirt]) > 0) || (item_amount($item[Smooth Velvet Pants]) > 0) || (item_amount($item[Smooth Velvet Hanky]) > 0) || (item_amount($item[Smooth Velvet Pocket Square]) > 0) || (item_amount($item[Smooth Velvet Socks]) > 0))
			{
				auto_log_info("You can still disco inferno at the Inferno Disco.", "blue");
			}
		}
		if(is_unrestricted($item[Potted Tea Tree]) && !get_property("_pottedTeaTreeUsed").to_boolean() && (auto_get_campground() contains $item[Potted Tea Tree]))
		{
			auto_log_info("You have a tea tree to shake!", "blue");
		}

		auto_log_info("You are probably done for today, beep.", "blue");
		return true;
	}
	return false;
}

boolean questOverride()
{
	if(get_property("semirareCounter").to_int() == 0)
	{
		if(get_property("semirareLocation") != "")
		{
			set_property("semirareLocation", "");
		}
	}


	// At the start of an ascension, auto_get_campground() displays the wrong info.
	// Visiting the campground doesn\'t work.... grrr...
	//	visit_url("campground.php");

	if((get_property("lastTempleUnlock").to_int() == my_ascensions()) && (get_property("auto_treecoin") != "finished"))
	{
		auto_log_info("Found Unlocked Hidden Temple but unaware of tree-holed coin (2)");
		set_property("auto_treecoin", "finished");
	}
	if((get_property("lastTempleUnlock").to_int() == my_ascensions()) && (get_property("auto_spookymap") != "finished"))
	{
		auto_log_info("Found Unlocked Hidden Temple but unaware of spooky map (2)");
		set_property("auto_spookymap", "finished");
	}
	if((get_property("lastTempleUnlock").to_int() == my_ascensions()) && (get_property("auto_spookyfertilizer") != "finished"))
	{
		auto_log_info("Found Unlocked Hidden Temple but unaware of spooky fertilizer (2)");
		set_property("auto_spookyfertilizer", "finished");
	}
	if((get_property("lastTempleUnlock").to_int() == my_ascensions()) && (get_property("auto_spookysapling") != "finished"))
	{
		auto_log_info("Found Unlocked Hidden Temple but unaware of spooky sapling (2)");
		set_property("auto_spookysapling", "finished");
	}

	if((get_property("questL02Larva") == "finished") && (get_property("auto_mosquito") != "finished"))
	{
		auto_log_info("Found completed Mosquito Larva (2)");
		set_property("auto_mosquito", "finished");
	}
	if((get_property("questL03Rat") == "finished") && (get_property("auto_tavern") != "finished"))
	{
		auto_log_info("Found completed Tavern (3)");
		set_property("auto_tavern", "finished");
	}
	if((get_property("questL04Bat") == "finished") && (get_property("auto_bat") != "finished"))
	{
		auto_log_info("Found completed Bat Cave (4)");
		set_property("auto_bat", "finished");
	}
	if((get_property("questL05Goblin") == "finished") && (get_property("auto_goblinking") != "finished"))
	{
		auto_log_info("Found completed Goblin King (5)");
		set_property("auto_day1_cobb", "finished");
		set_property("auto_goblinking", "finished");
	}
	if((get_property("questL06Friar") == "finished") && (get_property("auto_friars") != "done") && (get_property("auto_friars") != "finished"))
	{
		auto_log_info("Found completed Friars (6)");
		set_property("auto_friars", "done");
	}
	if((get_property("questL07Cyrptic") == "finished") && (get_property("auto_crypt") != "finished"))
	{
		auto_log_info("Found completed Cyrpt (7)");
		set_property("auto_crypt", "finished");
	}
	if((get_property("questL08Trapper") == "step2") && (get_property("auto_trapper") != "yeti"))
	{
		auto_log_info("Found Trapper partially completed (8: Ores/Cheese)");
		set_property("auto_trapper", "yeti");
	}
	if((get_property("questL08Trapper") == "finished") && (get_property("auto_trapper") != "finished"))
	{
		auto_log_info("Found completed Trapper (8)");
		set_property("auto_trapper", "finished");
	}

	if((get_property("questL09Topping") == "finished") && (get_property("auto_highlandlord") != "finished"))
	{
		auto_log_info("Found completed Highland Lord (9)");
		set_property("auto_highlandlord", "finished");
		set_property("auto_boopeak", "finished");
		set_property("auto_oilpeak", "finished");
		set_property("auto_twinpeak", "finished");
	}
	if((get_property("questL10Garbage") == "finished") && (get_property("auto_castletop") != "finished"))
	{
		auto_log_info("Found completed Castle in the Clouds in the Sky with some Pie (10)");
		set_property("auto_castletop", "finished");
		set_property("auto_castleground", "finished");
		set_property("auto_castlebasement", "finished");
		set_property("auto_airship", "finished");
		set_property("auto_bean", true);
	}
	if((internalQuestStatus("questL10Garbage") >= 9) && (get_property("auto_castleground") != "finished"))
	{
		auto_log_info("Found completed Castle Ground Floor (10)");
		set_property("auto_castleground", "finished");
	}
	if((internalQuestStatus("questL10Garbage") >= 8) && (get_property("auto_castlebasement") != "finished"))
	{
		auto_log_info("Found completed Castle Basement (10)");
		set_property("auto_castlebasement", "finished");
	}
	if((internalQuestStatus("questL10Garbage") >= 7) && (get_property("auto_airship") != "finished"))
	{
		auto_log_info("Found completed Airship (10)");
		set_property("auto_airship", "finished");
	}
	if((internalQuestStatus("questL10Garbage") >= 2) && !get_property("auto_bean").to_boolean())
	{
		auto_log_info("Found completed Planted Beanstalk (10)");
		set_property("auto_bean", true);
	}

	if((internalQuestStatus("questL11Manor") >= 11) && (get_property("auto_ballroom") != "finished"))
	{
		auto_log_info("Found completed Spookyraven Manor (11)");
		set_property("auto_ballroom", "finished");
		set_property("auto_winebomb", "finished");
		set_property("auto_ballroomflat", "finished");
	}

	if((internalQuestStatus("questL11Manor") >= 3) && (get_property("auto_winebomb") != "finished"))
	{
		auto_log_info("Found completed Spookyraven Manor Organ Music (11)");
		set_property("auto_winebomb", "finished");
		set_property("auto_masonryWall", true);
		set_property("auto_ballroomflat", "finished");
	}

	if((internalQuestStatus("questL11Manor") >= 1) && (get_property("auto_ballroomflat") != "finished"))
	{
		auto_log_info("Found completed Spookyraven Manor Organ Music (11)");
		set_property("auto_ballroomflat", "finished");
	}

	if((internalQuestStatus("questL11Worship") >= 3) && (get_property("auto_hiddenunlock") != "finished"))
	{
		auto_log_info("Found unlocked Hidden City (11)");
		set_property("auto_hiddenunlock", "finished");
	}

	if((internalQuestStatus("questL11Black") >= 2) && (get_property("auto_blackmap") == ""))
	{
		auto_log_info("Found an unexpected Black Market (11 - via questL11Black)");
		set_property("auto_blackmap", "document");
	}
	if((get_property("blackForestProgress") >= 5) && (get_property("auto_blackmap") == ""))
	{
		auto_log_info("Found an unexpected Black Market (11 - via blackForestProgress)");
		set_property("auto_blackmap", "document");
	}

	if((get_property("questL11Black") == "finished") && (get_property("auto_blackmap") != "finished"))
	{
		auto_log_info("Found completed Black Market (11 - via questL11Black)");
		set_property("auto_blackmap", "finished");
	}
	if((internalQuestStatus("questL11MacGuffin") >= 2) && (get_property("auto_blackmap") != "finished"))
	{
		auto_log_info("Found completed Black Market (11 - via questL11MacGuffin)");
		set_property("auto_blackmap", "finished");
	}

	if((internalQuestStatus("questL11MacGuffin") >= 2) && (get_property("auto_mcmuffin") == ""))
	{
		auto_log_info("Found started McMuffin quest (11)");
		set_property("auto_mcmuffin", "start");
	}

	if((get_property("questL11Palindome") == "finished") && (get_property("auto_palindome") != "finished"))
	{
		auto_log_info("Found completed Palindome (11)");
		set_property("auto_palindome", "finished");
	}

	if(get_property("pyramidBombUsed").to_boolean() && (get_property("auto_mcmuffin") == "pyramid"))
	{
		auto_log_info("Found Ed in the Pyramid (11)");
		set_property("auto_mcmuffin", "ed");
	}

	if((get_property("questL11MacGuffin") == "finished") && (get_property("auto_mcmuffin") != "finished"))
	{
		auto_log_info("Found completed McMuffin (11)");
		visit_url("diary.php?whichpage=1");
		set_property("auto_mcmuffin", "finished");
	}

	if((get_property("questL11Business") == "finished") && (get_property("auto_hiddenoffice") != "finished"))
	{
		auto_log_info("Found completed Hidden Office Building (11)");
		set_property("auto_hiddenoffice", "finished");
		if((get_property("auto_hiddenzones") != "finished") && (get_property("auto_hiddenzones").to_int() < 3))
		{
			set_property("auto_hiddenzones", 3);
		}
	}
	if((get_property("questL11Curses") == "finished") && (get_property("auto_hiddenapartment") != "finished"))
	{
		auto_log_info("Found completed Hidden Apartment Building (11)");
		set_property("auto_hiddenapartment", "finished");
		if((get_property("auto_hiddenzones") != "finished") && (get_property("auto_hiddenzones").to_int() < 2))
		{
			set_property("auto_hiddenzones", 2);
		}
	}
	if((get_property("questL11Spare") == "finished") && (get_property("auto_hiddenbowling") != "finished"))
	{
		auto_log_info("Found completed Hidden Bowling Alley (11)");
		set_property("auto_hiddenbowling", "finished");
		if((get_property("auto_hiddenzones") != "finished") && (get_property("auto_hiddenzones").to_int() < 5))
		{
			set_property("auto_hiddenzones", 5);
		}
	}
	if((get_property("questL11Doctor") == "finished") && (get_property("auto_hiddenhospital") != "finished"))
	{
		auto_log_info("Found completed Hidden Hopickle (11)");
		set_property("auto_hiddenhospital", "finished");
		if((get_property("auto_hiddenzones") != "finished") && (get_property("auto_hiddenzones").to_int() < 4))
		{
			set_property("auto_hiddenzones", 4);
		}
	}
	if((get_property("questL11Worship") == "finished") && (get_property("auto_hiddencity") != "finished"))
	{
		auto_log_info("Found completed Hidden City (11)");
		set_property("auto_hiddencity", "finished");
		set_property("auto_hiddenzones", "finished");
		set_property("auto_hiddenunlock", "finished");
	}
	if((internalQuestStatus("questL11Worship") >= 3) && (get_property("auto_hiddenunlock") != "finished"))
	{
		auto_log_info("Found completed unlocked Hidden City (11)");
		set_property("auto_hiddenunlock", "finished");
	}

	if(get_property("sidequestArenaCompleted") != "none")
	{
		if(get_property("flyeredML").to_int() < 10000)
		{
			auto_log_info("Found completed Island War Arena but flyeredML does not match (12)");
			set_property("flyeredML", 10000);
		}
	}

	if(get_property("sidequestOrchardCompleted") != "none")
	{
		if(get_property("auto_orchard") != "finished")
		{
			auto_log_info("Found completed Orchard (12)");
			set_property("auto_orchard", "finished");
		}
	}

	if((get_property("sidequestLighthouseCompleted") != "none") && (get_property("auto_sonofa") != "finished"))
	{
		auto_log_info("Found completed Lighthouse (12)");
		set_property("auto_sonofa", "finished");
	}
	if((get_property("sidequestJunkyardCompleted") != "none") && (get_property("auto_gremlins") != "finished"))
	{
		auto_log_info("Found completed Junkyard (12)");
		set_property("auto_gremlins", "finished");
	}

	if((get_property("fratboysDefeated").to_int() >= 1000) || (get_property("hippiesDefeated").to_int() >= 1000) || (get_property("questL12War") == "finished"))
	{
		if(get_property("auto_gremlins") != "finished")
		{
			auto_log_info("Found completed Junkyard (12)");
			set_property("auto_gremlins", "finished");
		}

		if(get_property("auto_sonofa") != "finished")
		{
			auto_log_info("Found completed Lighthouse (12)");
			set_property("auto_sonofa", "finished");
		}

		if(get_property("auto_orchard") != "finished")
		{
			auto_log_info("Found completed Orchard (12)");
			set_property("auto_orchard", "finished");
		}

		if((get_property("auto_nuns") != "done") && (get_property("auto_nuns") != "finished"))
		{
			auto_log_info("Found completed Nuns (12)");
			set_property("auto_nuns", "finished");
		}
	}

	if((get_property("sidequestOrchardCompleted") != "none") && (get_property("auto_orchard") != "finished"))
	{
		auto_log_info("Found completed Orchard (12)");
		set_property("auto_orchard", "finished");
	}


	if((get_property("sidequestNunsCompleted") != "none") && (get_property("auto_nuns") != "done") && (get_property("auto_nuns") != "finished"))
	{
		auto_log_info("Found completed Nuns (12)");
		set_property("auto_nuns", "finished");
	}

	if((get_property("sideDefeated") != "neither") && (get_property("auto_war") != "finished"))
	{
		auto_log_info("Found completed Island War (12)");
		set_property("auto_war", "finished");
		council();
	}

	if((internalQuestStatus("questL12War") >= 1)  && (get_property("auto_prewar") != "started"))
	{
		auto_log_info("Found Started Island War (12)");
		set_property("auto_prewar", "started");
	}

	if((internalQuestStatus("questL12War") >= 2)  && (get_property("auto_war") != "finished"))
	{
		auto_log_info("Found completed Island War (12)");
		set_property("auto_war", "finished");
		council();
	}

	if((internalQuestStatus("questL13Final") >= 13) && (get_property("auto_sorceress") != "finished"))
	{
		auto_log_info("Found completed Prism Recovery (13)");
		set_property("auto_sorceress", "finished");
		if (isActuallyEd())
		{
			council();
		}
	}

	if(internalQuestStatus("questM12Pirate") >= 0)
	{
		if(get_property("auto_pirateoutfit") == "")
		{
			auto_log_info("Pirate Quest already started but we don't know that, fixing...");
			set_property("auto_pirateoutfit", "insults");
		}
	}

	if(internalQuestStatus("questM12Pirate") >= 3)
	{
		if((get_property("auto_pirateoutfit") == "insults") || (get_property("auto_pirateoutfit") == "blueprint"))
		{
			auto_log_info("Pirate Quest got enough insults and did the blueprint, fixing...");
			set_property("auto_pirateoutfit", "almost");
		}
	}

	if(internalQuestStatus("questM12Pirate") >= 5)
	{
		if(get_property("auto_pirateoutfit") != "finished")
		{
			auto_log_info("Completed Beer Pong but we were not aware, fixing...");
			set_property("auto_pirateoutfit", "finished");
		}
	}

	if(possessEquipment($item[Pirate Fledges]) || (internalQuestStatus("questM12Pirate") >= 6))
	{
		if(get_property("auto_pirateoutfit") != "finished")
		{
			auto_log_info("Found Pirate Fledges and incomplete pirate outfit, fixing...");
			set_property("auto_pirateoutfit", "finished");
		}
		if(get_property("auto_fcle") != "finished")
		{
			auto_log_info("Found Pirate Fledges and incomplete F\'C\'le, fixing...");
			set_property("auto_fcle", "finished");
		}
	}

	if((get_property("lastQuartetAscension").to_int() >= my_ascensions()) && (get_property("auto_ballroomsong") != "finished"))
	{
		auto_log_info("Found Ballroom Quarter Song set (X).");
		set_property("auto_ballroomsong", "finished");
	}

	if((get_property("auto_war") != "done") && (get_property("auto_war") != "finished") && ((get_property("hippiesDefeated").to_int() >= 1000) || (get_property("fratboysDefeated").to_int() >= 1000)))
	{
		set_property("auto_nuns", "finished");
		set_property("auto_war", "done");
	}

	if(get_property("auto_hippyInstead").to_boolean())
	{
		set_property("auto_ignoreFlyer", true);
	}

	return false;
}

boolean L11_aridDesert()
{
	if(my_level() < 12)
	{
		if(get_property("auto_palindome") != "finished")
		{
			return false;
		}
	}
#	Mafia probably handles this correctly (and probably has done so for a while). (failing again as of r19010)
	if(auto_my_path() == "Pocket Familiars")
	{
		string temp = visit_url("place.php?whichplace=desertbeach", false);
	}

	if(get_property("desertExploration").to_int() >= 100)
	{
		return false;
	}
	if(get_property("auto_mcmuffin") != "start")
	{
		return false;
	}
	if((get_property("auto_hiddenapartment") != "finished") && (0 < have_effect($effect[Once-Cursed]) + have_effect($effect[Twice-Cursed]) + have_effect($effect[Thrice-Cursed])))
	{
		return false;
	}

	item desertBuff = $item[none];
	int progress = 1;
	if(possessEquipment($item[UV-resistant compass]))
	{
		desertBuff = $item[UV-resistant compass];
		progress = 2;
	}
	if(possessEquipment($item[Ornate Dowsing Rod]) && is_unrestricted($item[Hibernating Grimstone Golem]))
	{
		desertBuff = $item[Ornate Dowsing Rod];
		progress = 3;
	}
	if((get_property("bondDesert").to_boolean()) && ($location[The Arid\, Extra-Dry Desert].turns_spent > 0))
	{
		progress += 2;
	}

	boolean failDesert = true;
	if(possessEquipment(desertBuff))
	{
		failDesert = false;
	}
	if($classes[Avatar of Boris, Avatar of Sneaky Pete] contains my_class())
	{
		failDesert = false;
	}
	if(auto_my_path() == "Way of the Surprising Fist")
	{
		failDesert = false;
	}
	if(get_property("bondDesert").to_boolean())
	{
		failDesert = false;
	}
	if(in_koe())
	{
		failDesert = false;
	}

	if(failDesert)
	{
		if((my_level() >= 12) && !in_hardcore())
		{
			auto_log_warning("Do you actually have a UV-resistant compass? Try 'refresh inv' in the CLI! If possible, pull a Grimstone mask and rerun, we may have missed that somehow.", "green");
			if(is_unrestricted($item[Hibernating Grimstone Golem]) && have_familiar($familiar[Grimstone Golem]))
			{
				abort("I can't do the Oasis without an Ornate Dowsing Rod. You can manually get a UV-resistant compass and I'll use that if you really hate me that much.");
			}
			else
			{
				cli_execute("refresh inv");
				if(possessEquipment($item[UV-resistant compass]))
				{
					desertBuff = $item[UV-resistant compass];
					progress = 2;
				}
				else if((my_adventures() > 3) && (my_meat() > 1200))
				{
					doVacation();
					if(item_amount($item[Shore Inc. Ship Trip Scrip]) > 0)
					{
						cli_execute("make UV-Resistant Compass");
					}
					if(!possessEquipment($item[UV-Resistant Compass]))
					{
						abort("Could not acquire a UV-Resistant Compass. Failing.");
					}
					return true;
				}
				else
				{
					abort("Can not handle the desert in our current situation.");
				}
			}
		}
		else
		{
			auto_log_warning("Skipping desert, don't have a rod or a compass.");
			set_property("auto_skipDesert", my_turncount());
		}
		return false;
	}

	if((have_effect($effect[Ultrahydrated]) > 0) || (get_property("desertExploration").to_int() == 0))
	{
		auto_log_info("Searching for the pyramid", "blue");
		if(auto_my_path() == "Heavy Rains")
		{
			autoEquip($item[Thor\'s Pliers]);
		}
		if(auto_have_familiar($familiar[Artistic Goth Kid]))
		{
			handleFamiliar($familiar[Artistic Goth Kid]);
		}

		if(possessEquipment($item[reinforced beaded headband]) && possessEquipment($item[bullet-proof corduroys]) && possessEquipment($item[round purple sunglasses]))
		{
			foreach it in $items[Beer Helmet, Distressed Denim Pants, Bejeweled Pledge Pin]
			{
				take_closet(closet_amount(it), it);
			}
		}

		buyUpTo(1, $item[hair spray]);
		buffMaintain($effect[Butt-Rock Hair], 0, 1, 1);
		if(my_primestat() == $stat[Muscle])
		{
			buyUpTo(1, $item[Ben-Gal&trade; Balm]);
			buffMaintain($effect[Go Get \'Em, Tiger!], 0, 1, 1);
			buyUpTo(1, $item[Blood of the Wereseal]);
			buffMaintain($effect[Temporary Lycanthropy], 0, 1, 1);
		}

		if(my_mp() > 30 && my_hp() < (my_maxhp()*0.5))
		{
			acquireHP();
		}

		if((in_hardcore() || (pulls_remaining() == 0)) && (item_amount($item[Worm-Riding Hooks]) > 0) && (get_property("desertExploration").to_int() <= (100 - (5 * progress))) && ((get_property("gnasirProgress").to_int() & 16) != 16) && (item_amount($item[Stone Rose]) == 0))
		{
			if(item_amount($item[Drum Machine]) > 0)
			{
				auto_log_info("Found the drums, now we use them!", "blue");
				use(1, $item[Drum Machine]);
			}
			else
			{
				auto_log_info("Off to find the drums!", "blue");
				autoAdv(1, $location[The Oasis]);
			}
			return true;
		}

		if(((get_property("gnasirProgress").to_int() & 1) != 1))
		{
			int expectedOasisTurns = 8 - $location[The Oasis].turns_spent;
			int equivProgress = expectedOasisTurns * progress;
			int need = 100 - get_property("desertExploration").to_int();
			auto_log_info("expectedOasis: " + expectedOasisTurns, "brown");
			auto_log_info("equivProgress: " + equivProgress, "brown");
			auto_log_info("need: " + need, "brown");
			if((need <= 15) && (15 >= equivProgress) && (item_amount($item[Stone Rose]) == 0))
			{
				auto_log_info("It seems raisinable to hunt a Stone Rose. Beep", "blue");
				autoAdv(1, $location[The Oasis]);
				return true;
			}
		}

		if(desertBuff != $item[none])
		{
			autoEquip(desertBuff);
		}
		handleFamiliar("initSuggest");
		set_property("choiceAdventure805", 1);
		int need = 100 - get_property("desertExploration").to_int();
		auto_log_info("Need for desert: " + need, "blue");
		auto_log_info("Worm riding: " + item_amount($item[Worm-Riding Manual Page]), "blue");

		if(!get_property("auto_gnasirUnlocked").to_boolean() && ($location[The Arid\, Extra-Dry Desert].turns_spent > 10) && (get_property("desertExploration").to_int() > 10))
		{
			auto_log_info("Did not appear to notice that Gnasir unlocked, assuming so at this point.", "green");
			set_property("auto_gnasirUnlocked", true);
		}

		if(get_property("auto_gnasirUnlocked").to_boolean() && (item_amount($item[Stone Rose]) > 0) && ((get_property("gnasirProgress").to_int() & 1) != 1))
		{
			auto_log_info("Returning the stone rose", "blue");
			auto_visit_gnasir();
			visit_url("choice.php?whichchoice=805&option=1&pwd=");
			visit_url("choice.php?whichchoice=805&option=2&pwd=");
			visit_url("choice.php?whichchoice=805&option=1&pwd=");
			if(item_amount($item[Desert Sightseeing Pamphlet]) == 0)
			{
				cli_execute("refresh inv");
				if(item_amount($item[Desert Sightseeing Pamphlet]) == 0)
				{
					abort("Returned stone rose but did not return stone rose.");
				}
				else
				{
					if((get_property("gnasirProgress").to_int() & 1) != 1)
					{
						auto_log_warning("Mafia did not track gnasir Stone Rose (0x1). Fixing.", "red");
						set_property("gnasirProgress", get_property("gnasirProgress").to_int() | 1);
					}
				}
			}
			use(1, $item[desert sightseeing pamphlet]);
			return true;
		}

		if(get_property("auto_gnasirUnlocked").to_boolean() && ((get_property("gnasirProgress").to_int() & 2) != 2))
		{
			boolean canBuyPaint = true;
			if((auto_my_path() == "Way of the Surprising Fist") || (auto_my_path() == "Nuclear Autumn"))
			{
				canBuyPaint = false;
			}

			if((item_amount($item[Can of Black Paint]) > 0) || ((my_meat() >= npc_price($item[Can of Black Paint])) && canBuyPaint))
			{
				buyUpTo(1, $item[Can of Black Paint]);
				auto_log_info("Returning the Can of Black Paint", "blue");
				auto_visit_gnasir();
				visit_url("choice.php?whichchoice=805&option=1&pwd=");
				visit_url("choice.php?whichchoice=805&option=2&pwd=");
				visit_url("choice.php?whichchoice=805&option=1&pwd=");
				if(item_amount($item[Desert Sightseeing Pamphlet]) == 0)
				{
					cli_execute("refresh inv");
					if(item_amount($item[Desert Sightseeing Pamphlet]) == 0)
					{
						if(item_amount($item[Can Of Black Paint]) == 0)
						{
							auto_log_warning("Mafia did not track gnasir Can of Black Paint (0x2). Fixing.", "red");
							set_property("gnasirProgress", get_property("gnasirProgress").to_int() | 2);
							return true;
						}
						else
						{
							abort("Returned can of black paint but did not return can of black paint.");
						}
					}
					else
					{
						if((get_property("gnasirProgress").to_int() & 2) != 2)
						{
							auto_log_warning("Mafia did not track gnasir Can of Black Paint (0x2). Fixing.", "red");
							set_property("gnasirProgress", get_property("gnasirProgress").to_int() | 2);
						}
					}
				}
				use(1, $item[desert sightseeing pamphlet]);
				return true;
			}
		}

		if(get_property("auto_gnasirUnlocked").to_boolean() && (item_amount($item[Killing Jar]) > 0) && ((get_property("gnasirProgress").to_int() & 4) != 4))
		{
			auto_log_info("Returning the killing jar", "blue");
			auto_visit_gnasir();
			visit_url("choice.php?whichchoice=805&option=1&pwd=");
			visit_url("choice.php?whichchoice=805&option=2&pwd=");
			visit_url("choice.php?whichchoice=805&option=1&pwd=");
			if(item_amount($item[Desert Sightseeing Pamphlet]) == 0)
			{
				cli_execute("refresh inv");
				if(item_amount($item[Desert Sightseeing Pamphlet]) == 0)
				{
					abort("Returned killing jar but did not return killing jar.");
				}
				else
				{
					if((get_property("gnasirProgress").to_int() & 4) != 4)
					{
						auto_log_warning("Mafia did not track gnasir Killing Jar (0x4). Fixing.", "red");
						set_property("gnasirProgress", get_property("gnasirProgress").to_int() | 4);
					}
				}
			}
			use(1, $item[desert sightseeing pamphlet]);
			return true;
		}

		if((item_amount($item[Worm-Riding Manual Page]) >= 15) && ((get_property("gnasirProgress").to_int() & 8) != 8))
		{
			auto_log_info("Returning the worm-riding manual pages", "blue");
			auto_visit_gnasir();
			visit_url("choice.php?whichchoice=805&option=1&pwd=");
			visit_url("choice.php?whichchoice=805&option=2&pwd=");
			visit_url("choice.php?whichchoice=805&option=1&pwd=");
			if(item_amount($item[Worm-Riding Hooks]) == 0)
			{
				auto_log_critical("We messed up in the Desert, get the Worm-Riding Hooks and use them please.");
				abort("We messed up in the Desert, get the Worm-Riding Hooks and use them please.");
			}
			if(item_amount($item[Worm-Riding Manual Page]) >= 15)
			{
				auto_log_warning("Mafia doesn't realize that we've returned the worm-riding manual pages... fixing", "red");
				cli_execute("refresh all");
				if((get_property("gnasirProgress").to_int() & 8) != 8)
				{
					auto_log_warning("Mafia did not track gnasir Worm-Riding Manual Pages (0x8). Fixing.", "red");
					set_property("gnasirProgress", get_property("gnasirProgress").to_int() | 8);
				}
			}
			return true;
		}

		need = 100 - get_property("desertExploration").to_int();
		if((item_amount($item[Worm-Riding Hooks]) > 0) && ((get_property("gnasirProgress").to_int() & 16) != 16))
		{
			pullXWhenHaveY($item[Drum Machine], 1, 0);
			if(item_amount($item[Drum Machine]) > 0)
			{
				auto_log_info("Drum machine desert time!", "blue");
				use(1, $item[Drum Machine]);
				return true;
			}
		}

		need = 100 - get_property("desertExploration").to_int();
		# If we have done the Worm-Riding Hooks or the Killing jar, don\'t do this.
		if((need <= 15) && ((get_property("gnasirProgress").to_int() & 12) == 0))
		{
			pullXWhenHaveY($item[Killing Jar], 1, 0);
			if(item_amount($item[Killing Jar]) > 0)
			{
				auto_log_info("Secondary killing jar handler", "blue");
				auto_visit_gnasir();
				visit_url("choice.php?whichchoice=805&option=1&pwd=");
				visit_url("choice.php?whichchoice=805&option=2&pwd=");
				visit_url("choice.php?whichchoice=805&option=1&pwd=");
				if(item_amount($item[Desert Sightseeing Pamphlet]) == 0)
				{
					cli_execute("refresh inv");
					if(item_amount($item[Desert Sightseeing Pamphlet]) == 0)
					{
						abort("Returned killing jar (secondard) but did not return killing jar.");
					}
					else
					{
						if((get_property("gnasirProgress").to_int() & 4) != 4)
						{
							auto_log_warning("Mafia did not track gnasir Killing Jar (0x4). Fixing.", "red");
							set_property("gnasirProgress", get_property("gnasirProgress").to_int() | 4);
						}
					}
				}
				use(1, $item[desert sightseeing pamphlet]);
				return true;
			}
		}

		autoAdv(1, $location[The Arid\, Extra-Dry Desert]);
		handleFamiliar("item");

		if(contains_text(get_property("lastEncounter"), "A Sietch in Time"))
		{
			auto_log_info("We've found the gnome!! Sightseeing pamphlets for everyone!", "green");
			set_property("auto_gnasirUnlocked", true);
		}

		if(contains_text(get_property("lastEncounter"), "He Got His Just Desserts"))
		{
			take_closet(closet_amount($item[Beer Helmet]), $item[Beer Helmet]);
			take_closet(closet_amount($item[Distressed Denim Pants]), $item[Distressed Denim Pants]);
			take_closet(closet_amount($item[Bejeweled Pledge Pin]), $item[Bejeweled Pledge Pin]);
		}
	}
	else
	{
		int need = 100 - get_property("desertExploration").to_int();
		auto_log_info("Getting some ultrahydrated, I suppose. Desert left: " + need, "blue");

		if((need > (5 * progress)) && (cloversAvailable() > 2) && !get_property("lovebugsUnlocked").to_boolean())
		{
			auto_log_info("Gonna clover this, yeah, it only saves 2 adventures. So?", "green");
			cloverUsageInit();
			autoAdvBypass("adventure.php?snarfblat=122", $location[The Oasis]);
			cloverUsageFinish();
		}
		else
		{
			if(!autoAdv(1, $location[The Oasis]))
			{
				auto_log_warning("Could not visit the Oasis for some raisin, assuming desertExploration is incorrect.", "red");
				set_property("desertExploration", 0);
			}
		}
	}
	return true;
}

boolean L11_palindome()
{
	if(get_property("auto_palindome") == "finished")
	{
		return false;
	}
	if(get_property("auto_mcmuffin") != "start")
	{
		return false;
	}

	if(get_property("questL11Palindome") == "finished")
	{
		set_property("auto_palindome", "finished");
		return true;
	}

	if(!possessEquipment($item[Talisman O\' Namsilat]))
	{
		return false;
	}

	int total = 0;
	total = total + item_amount($item[Photograph Of A Red Nugget]);
	total = total + item_amount($item[Photograph Of An Ostrich Egg]);
	total = total + item_amount($item[Photograph Of God]);
	total = total + item_amount($item[Photograph Of A Dog]);


	boolean lovemeDone = hasILoveMeVolI() || (internalQuestStatus("questL11Palindome") >= 1);
	if(!lovemeDone && (get_property("palindomeDudesDefeated").to_int() >= 5))
	{
		string palindomeCheck = visit_url("place.php?whichplace=palindome");
		lovemeDone = lovemeDone || contains_text(palindomeCheck, "pal_drlabel");
	}

	auto_log_info("In the palindome : emodnilap eht nI", "blue");
	#
	#	In hardcore, guild-class, the right side of the or doesn't happen properly due us farming the
	#	Mega Gem within the if, with pulls, it works fine. Need to fix this. This is bad.
	#
	if((item_amount($item[Bird Rib]) > 0) && (item_amount($item[Lion Oil]) > 0) && (item_amount($item[Wet Stew]) == 0))
	{
		autoCraft("cook", 1, $item[Bird Rib], $item[Lion Oil]);
	}
	if((item_amount($item[Stunt Nuts]) > 0) && (item_amount($item[Wet Stew]) > 0) && (item_amount($item[Wet Stunt Nut Stew]) == 0))
	{
		autoCraft("cook", 1, $item[wet stew], $item[stunt nuts]);
	}

	if((item_amount($item[Wet Stunt Nut Stew]) > 0) && !possessEquipment($item[Mega Gem]))
	{
		if(equipped_amount($item[Talisman o\' Namsilat]) == 0)
			equip($slot[acc3], $item[Talisman o\' Namsilat]);
		visit_url("place.php?whichplace=palindome&action=pal_mrlabel");
	}

	if((total == 0) && !possessEquipment($item[Mega Gem]) && lovemeDone && in_hardcore() && (item_amount($item[Wet Stunt Nut Stew]) == 0) && ((internalQuestStatus("questL11Palindome") >= 3) || isGuildClass()) && !get_property("auto_bruteForcePalindome").to_boolean())
	{
		if(item_amount($item[Wet Stunt Nut Stew]) == 0)
		{
			handleFamiliar("item");
			equipBaseline();
			if((item_amount($item[Bird Rib]) == 0) || (item_amount($item[Lion Oil]) == 0))
			{
				if(item_amount($item[white page]) > 0)
				{
					set_property("choiceAdventure940", 1);
					if(item_amount($item[Bird Rib]) > 0)
					{
						set_property("choiceAdventure940", 2);
					}

					if(get_property("lastGuildStoreOpen").to_int() < my_ascensions())
					{
						auto_log_warning("This is probably no longer needed as of r16907. Please remove me", "blue");
						auto_log_warning("Going to pretend we have unlocked the Guild because Mafia will assume we need to do that before going to Whitey's Grove and screw up us. We'll fix it afterwards.", "red");
					}
					backupSetting("lastGuildStoreOpen", my_ascensions());
					string[int] pages;
					pages[0] = "inv_use.php?pwd&which=3&whichitem=7555";
					pages[1] = "choice.php?pwd&whichchoice=940&option=" + get_property("choiceAdventure940");
					if(autoAdvBypass(0, pages, $location[Whitey\'s Grove], "")) {}
					restoreSetting("lastGuildStoreOpen");
					return true;
				}
				// +item is nice to get that food
				bat_formBats();
				auto_log_info("Off to the grove for some doofy food!", "blue");
				autoAdv(1, $location[Whitey\'s Grove]);
			}
			else if(item_amount($item[Stunt Nuts]) == 0)
			{
				auto_log_info("We got no nuts!! :O", "Blue");
				autoEquip($slot[acc3], $item[Talisman o\' Namsilat]);
				autoAdv(1, $location[Inside the Palindome]);
			}
			else
			{
				abort("Some sort of Wet Stunt Nut Stew error. Try making it yourself?");
			}
			return true;
		}
	}
	if((((total == 4) && hasILoveMeVolI()) || ((total == 0) && possessEquipment($item[Mega Gem]))) && loveMeDone)
	{
		if(hasILoveMeVolI())
		{
			useILoveMeVolI();
		}
		if (equipped_amount($item[Talisman o\' Namsilat]) == 0)
			equip($slot[acc3], $item[Talisman o\' Namsilat]);
		visit_url("place.php?whichplace=palindome&action=pal_drlabel");
		visit_url("choice.php?pwd&whichchoice=872&option=1&photo1=2259&photo2=7264&photo3=7263&photo4=7265");

		if (isActuallyEd())
		{
			set_property("auto_palindome", "finished");
			return true;
		}


		# is step 4 when we got the wet stunt nut stew?
		if (internalQuestStatus("questL11Palindome") < 5)
		{
			if(item_amount($item[&quot;2 Love Me\, Vol. 2&quot;]) > 0)
			{
				use(1, $item[&quot;2 Love Me\, Vol. 2&quot;]);
				auto_log_info("Oh no, we died from reading a book. I'm going to take a nap.", "blue");
				acquireHP();
				bat_reallyPickSkills(20);
			}
			if (equipped_amount($item[Talisman o\' Namsilat]) == 0)
				equip($slot[acc3], $item[Talisman o\' Namsilat]);
			visit_url("place.php?whichplace=palindome&action=pal_mrlabel");
			if(!in_hardcore() && (item_amount($item[Wet Stunt Nut Stew]) == 0))
			{
				if((item_amount($item[Wet Stew]) == 0) && (item_amount($item[Mega Gem]) == 0))
				{
					pullXWhenHaveY($item[Wet Stew], 1, 0);
				}
				if((item_amount($item[Stunt Nuts]) == 0) && (item_amount($item[Mega Gem]) == 0))
				{
					pullXWhenHaveY($item[Stunt Nuts], 1, 0);
				}
			}
			if(in_hardcore() && isGuildClass())
			{
				return true;
			}
		}

		if((item_amount($item[Bird Rib]) > 0) && (item_amount($item[Lion Oil]) > 0) && (item_amount($item[Wet Stew]) == 0))
		{
			autoCraft("cook", 1, $item[Bird Rib], $item[Lion Oil]);
		}

		if((item_amount($item[Stunt Nuts]) > 0) && (item_amount($item[Wet Stew]) > 0) && (item_amount($item[Wet Stunt Nut Stew]) == 0))
		{
			autoCraft("cook", 1, $item[wet stew], $item[stunt nuts]);
		}

		if(!possessEquipment($item[Mega Gem]))
		{
			if (equipped_amount($item[Talisman o\' Namsilat]) == 0)
				equip($slot[acc3], $item[Talisman o\' Namsilat]);
			visit_url("place.php?whichplace=palindome&action=pal_mrlabel");
		}

		if(!possessEquipment($item[Mega Gem]))
		{
			auto_log_warning("No mega gem for us. Well, no raisin to go further here....", "red");
			return false;
		}
		autoEquip($slot[acc2], $item[Mega Gem]);
		autoEquip($slot[acc3], $item[Talisman o\' Namsilat]);
		int palinChoice = random(3) + 1;
		set_property("choiceAdventure131", palinChoice);

		auto_log_info("War sir is raw!!", "blue");

		string[int] pages;
		pages[0] = "place.php?whichplace=palindome&action=pal_drlabel";
		pages[1] = "choice.php?pwd&whichchoice=131&option=" + palinChoice;
		autoAdvBypass(0, pages, $location[Noob Cave], "");

		if(item_amount($item[[2268]Staff Of Fats]) == 1)
		{
			set_property("auto_palindome", "finished");
		}
		return true;
	}
	else
	{
		if((my_mp() > 60) || considerGrimstoneGolem(true))
		{
			handleBjornify($familiar[Grimstone Golem]);
		}
		if (internalQuestStatus("questL11Palindome") > 1)
		{
			if(!get_property("auto_bruteForcePalindome").to_boolean())
			{
				auto_log_critical("Palindome failure:", "red");
				auto_log_critical("You probably just need to get a Mega Gem to fix this.", "red");
				abort("We have made too much progress in the Palindome and should not be here.");
			}
			else
			{
				auto_log_critical("We need wet stunt nut stew to get the Mega Gem, but I've been told to get it via the mercy adventure.", "red");
				auto_log_critical("Set auto_bruteForcePalindome=false to try to get a stunt nut stew", "red");
				auto_log_critical("(We typically only set this option in hardcore Kingdom of Exploathing, in which the White Forest isn't available)", "red");
			}
		}

		if((have_effect($effect[On The Trail]) > 0) && !($monsters[Bob Racecar, Racecar Bob] contains get_property("olfactedMonster").to_monster()) && internalQuestStatus("questL11Palindome") < 2)
		{
			if(item_amount($item[soft green echo eyedrop antidote]) > 0)
			{
				auto_log_info("Gotta hunt down them Naskar boys.", "blue");
				uneffect($effect[On The Trail]);
			}
		}

		autoEquip($slot[acc3], $item[Talisman o\' Namsilat]);
		autoAdv(1, $location[Inside the Palindome]);
		if(($location[Inside the Palindome].turns_spent > 30) && (auto_my_path() != "Pocket Familiars") && (auto_my_path() != "G-Lover") && !in_koe())
		{
			abort("It appears that we've spent too many turns in the Palindome. If you run me again, I'll try one more time but many I failed finishing the Palindome");
		}
	}
	return true;
}


boolean L13_towerNSNagamar()
{
	if(!get_property("auto_wandOfNagamar").to_boolean() && (get_property("questL13Final") != "step12"))
	{
		return false;
	}

	if(item_amount($item[Wand of Nagamar]) > 0)
	{
		set_property("auto_wandOfNagamar", false);
		return false;
	}
	else if(get_property("questL13Final") == "step12")
	{
		return autoAdv($location[The VERY Unquiet Garves]);
	}
	else if(pulls_remaining() >= 2)
	{
		if((item_amount($item[ruby w]) > 0) && (item_amount($item[metallic A]) > 0))
		{
			cli_execute("make " + $item[WA]);
		}
		pullXWhenHaveY($item[WA], 1, 0);
		pullXWhenHaveY($item[ND], 1, 0);
		cli_execute("make " + $item[Wand Of Nagamar]);
		return true;
	}
	else
	{
		if(auto_my_path() == "G-Lover")
		{
			pullXWhenHaveY($item[Ten-Leaf Clover], 1, 0);
		}
		else
		{
			pullXWhenHaveY($item[Disassembled Clover], 1, 0);
		}
		if(in_hardcore() && in_koe())
		{
			// TODO: Improve support
			abort("In Kingdom of Exploathing: Please buy a Wand of Nagamar from the bazaar and re-run.");
			return false;
		}
		else if(cloversAvailable() > 0)
		{
			cloverUsageInit();
			autoAdvBypass(322, $location[The Castle in the Clouds in the Sky (Basement)]);
			cloverUsageFinish();
			cli_execute("make " + $item[Wand Of Nagamar]);
			return true;
		}
		return false;
	}
}

boolean L13_towerNSTransition()
{
	if(get_property("auto_sorceress") == "top")
	{
		set_property("auto_sorceress", "final");
	}
	return false;
}

boolean L13_towerNSFinal()
{
	if(get_property("auto_sorceress") != "final")
	{
		return false;
	}
	if(get_property("auto_wandOfNagamar").to_boolean())
	{
		auto_log_warning("We do not have a Wand of Nagamar but appear to need one. We must lose to the Sausage first...", "red");
	}

	//Only if the final boss does not unbuff us...
	if($strings[Actually Ed the Undying, Avatar of Boris, Avatar of Jarlsberg, Avatar of Sneaky Pete, Bees Hate You, Bugbear Invasion, Community Service, Heavy Rains, The Source, Way of the Surprising Fist, Zombie Slayer] contains auto_my_path())
	{
		if(auto_my_path() == "The Source")
		{
			acquireMP(200, 0);
		}
	}
	else
	{
		cli_execute("scripts/autoscend/auto_post_adv.ash");
	}
	if(my_class() == $class[Turtle Tamer])
	{
		autoEquip($item[Ouija Board\, Ouija Board]);
	}

	if((pulls_remaining() == -1) || (pulls_remaining() > 0))
	{
		if(can_equip($item[Oscus\'s Garbage Can Lid]))
		{
			pullXWhenHaveY($item[Oscus\'s Garbage Can Lid], 1, 0);
		}
	}

	autoEquip($slot[Off-Hand], $item[Oscus\'s Garbage Can Lid]);

	handleFamiliar("boss");

	if(!useMaximizeToEquip())
	{
		autoEquip($item[Beer Helmet]);
		autoEquip($item[Misty Cloak]);
		autoEquip($slot[acc1], $item[gumshoes]);
		autoEquip($slot[acc3], $item[World\'s Best Adventurer Sash]);
	}
	else
	{
		addToMaximize("10dr,3moxie,0.5da 1000max,-5ml,1.5hp,0item,0meat");
	}
	autoEquip($slot[acc2], $item[Attorney\'s Badge]);


	if(internalQuestStatus("questL13Final") < 13)
	{
		cli_execute("scripts/autoscend/auto_pre_adv.ash");
		set_property("auto_disableAdventureHandling", true);
		autoAdvBypass("place.php?whichplace=nstower&action=ns_10_sorcfight", $location[Noob Cave]);
		if(have_effect($effect[Beaten Up]) > 0)
		{
			auto_log_warning("Sorceress beat us up. Wahhh.", "red");
			set_property("auto_disableAdventureHandling", false);
			return true;
		}
		if(last_monster() == $monster[Naughty Sorceress])
		{
			autoAdv(1, $location[Noob Cave]);
			if(have_effect($effect[Beaten Up]) > 0)
			{
				auto_log_warning("Blobbage Sorceress beat us up. Wahhh.", "red");
				set_property("auto_disableAdventureHandling", true);
				return true;
			}
			autoAdv(1, $location[Noob Cave]);
			if(have_effect($effect[Beaten Up]) > 0)
			{
				if(get_property("lastEncounter") == "The Naughty Sorceress (3)")
				{
					string page = visit_url("choice.php");
					if(last_choice() == 1016)
					{
						run_choice(1);
						set_property("auto_wandOfNagamar", true);
					}
					else
					{
						abort("Expected to start Nagamar side-quest but unable to");
					}
					return true;
				}
				auto_log_warning("We got beat up by a sausage....", "red");
				set_property("auto_disableAdventureHandling", false);
				return true;
			}
			if(get_property("auto_stayInRun").to_boolean())
			{
				set_property("auto_disableAdventureHandling", false);
				abort("User wanted to stay in run (auto_stayInRun), we are done.");
			}

			if(!($classes[Seal Clubber, Turtle Tamer, Pastamancer, Sauceror, Disco Bandit, Accordion Thief] contains my_class()))
			{
				set_property("auto_disableAdventureHandling", false);
				cli_execute("refresh quests");
				if(get_property("auto_sorceress") == "finished" || get_property("questL13Final") == "finished")
				{
					abort("Freeing the king will result in a path change and we can barely handle The Sleazy Back Alley. Aborting, run the script again after selecting your aftercore path in order for it to clean up.");
				}
				set_property("auto_sorceress", "finished");
				return true;
			}
			visit_url("place.php?whichplace=nstower&action=ns_11_prism");
		}
		set_property("auto_disableAdventureHandling", false);
	}
	else
	{
		visit_url("place.php?whichplace=nstower&action=ns_11_prism");
	}

	if(get_property("auto_stayInRun").to_boolean())
	{
		abort("User wanted to stay in run (auto_stayInRun), we are done.");
	}

	if(my_class() == $class[Vampyre] && (0 < item_amount($item[Thwaitgold mosquito statuette])))
	{
		abort("Freeing the king will result in a path change. Enjoy your immortality.");
	}

	visit_url("place.php?whichplace=nstower&action=ns_11_prism");
	if(get_property("kingLiberated") == "false")
	{
		abort("Yeah, so, I'm done. You might be stuck at the shadow, or at the final boss, or just with a king in a prism. I don't know and quite frankly, after the last " + my_daycount() + " days, I don't give a damn. That's right, I said it. Bitches.");
	}
	set_property("auto_sorceress", "finished");
	return true;
}


boolean L13_towerNSTower()
{
	if(get_property("auto_sorceress") != "tower")
	{
		return false;
	}

	auto_log_info("Scaling the mighty NStower...", "green");

	if(contains_text(visit_url("place.php?whichplace=nstower"), "ns_05_monster1"))
	{
		auto_log_info("Time to fight the Wall of Skins!", "blue");
		auto_change_mcd(0);
		acquireMP(120, 0);

		int sources = 0;
		if(autoEquip($item[astral shirt]))
		{
			// nothing, just for else
		}
		else if (autoEquip($item[Unfortunato\'s foolscap]))
		{
			// nothing, just for else
		}
		else if(item_amount($item[cigar box turtle]) > 0)
		{
			use(1, $item[cigar box turtle]);
		}
		else if(have_effect($effect[damage.enh]) == 0)
		{
			int enhances = auto_sourceTerminalEnhanceLeft();
			if(enhances > 0)
			{
				auto_sourceTerminalEnhance("damage");
			}
		}

		if(my_class() == $class[Turtle Tamer])
		{
			autoEquip($slot[shirt], $item[Shocked Shell]);
		}
		if(have_skill($skill[Belch the Rainbow]))
		{
			sources = 6;
		}
		else
		{
			foreach damage in $strings[Cold Damage, Hot Damage, Sleaze Damage, Spooky Damage, Stench Damage]
			{
				if(numeric_modifier(damage) > 0)
				{
					sources += 1;
				}
			}
		}
		if(have_skill($skill[headbutt]))
		{
			sources = sources + 1;
		}
		if((auto_have_familiar($familiar[warbear drone])) && !is100FamiliarRun())
		{
			sources = sources + 2;
			handleFamiliar($familiar[Warbear Drone]);
			use_familiar($familiar[Warbear Drone]);
			cli_execute("auto_pre_adv"); // TODO: can we remove this?
			if(!possessEquipment($item[Warbear Drone Codes]))
			{
				pullXWhenHaveY($item[warbear drone codes], 1, 0);
			}
			if(possessEquipment($item[warbear drone codes]))
			{
				autoEquip($item[warbear drone codes]);
				sources = sources + 2;
			}
		}
		else if((auto_have_familiar($familiar[Sludgepuppy])) && !is100FamiliarRun())
		{
			handleFamiliar($familiar[Sludgepuppy]);
			sources = sources + 3;
		}
		else if((auto_have_familiar($familiar[Imitation Crab])) && !is100FamiliarRun())
		{
			handleFamiliar($familiar[Imitation Crab]);
			sources = sources + 2;
		}
		if(autoEquip($slot[acc1], $item[hippy protest button]))
		{
			sources = sources + 1;
		}
		if(item_amount($item[glob of spoiled mayo]) > 0)
		{
			buffMaintain($effect[Mayeaugh], 0, 1, 1);
			sources = sources + 1;
		}
		if(autoEquip($item[smirking shrunken head]))
		{
			sources = sources + 1;
		}
		else if(autoEquip($item[hot plate]))
		{
			sources = sources + 1;
		}
		if(have_skill($skill[Scarysauce]))
		{
			buffMaintain($effect[Scarysauce], 0, 1, 1);
			sources = sources + 1;
		}
		if(have_skill($skill[Spiky Shell]))
		{
			buffMaintain($effect[Spiky Shell], 0, 1, 1);
			sources = sources + 1;
		}
		if(have_skill($skill[Jalape&ntilde;o Saucesphere]))
		{
			sources = sources + 1;
			buffMaintain($effect[Jalape&ntilde;o Saucesphere], 0, 1, 1);
		}
		handleBjornify($familiar[Hobo Monkey]);
		autoEquip($slot[acc2], $item[world\'s best adventurer sash]);
		autoEquip($slot[acc3], $item[Groll Doll]);
		autoEquip($slot[acc3], $item[old school calculator watch]);
		autoEquip($slot[acc3], $item[Bottle Opener Belt Buckle]);
		autoEquip($slot[acc3], $item[acid-squirting flower]);
		if(have_skill($skill[Frigidalmatian]) && (my_mp() > 300))
		{
			sources = sources + 1;
		}
		int sourceNeed = 13;
		if(have_skill($skill[Shell Up]))
		{
			if((have_effect($effect[Blessing of the Storm Tortoise]) > 0) || (have_effect($effect[Grand Blessing of the Storm Tortoise]) > 0) || (have_effect($effect[Glorious Blessing of the Storm Tortoise]) > 0))
			{
				if(have_skill($skill[Blessing of the War Snapper]) && (my_mp() > (2 * mp_cost($skill[Blessing of the War Snapper]))))
				{
					use_skill(1, $skill[Blessing of the War Snapper]);
				}
			}
			if((have_effect($effect[Blessing of the Storm Tortoise]) == 0) && (have_effect($effect[Grand Blessing of the Storm Tortoise]) == 0) && (have_effect($effect[Glorious Blessing of the Storm Tortoise]) == 0))
			{
				sourceNeed -= 2;
			}
		}
		if(have_skill($skill[Sauceshell]))
		{
			sourceNeed -= 2;
		}
		auto_log_info("I think I have " + sources + " sources of damage, let's do this!", "blue");
		if(auto_my_path() == "Pocket Familiars")
		{
			sources = 9999;
		}
		if((item_amount($item[Beehive]) > 0) || (sources > sourceNeed))
		{
			if(item_amount($item[Beehive]) == 0)
			{
				acquireHP();
			}
			autoAdvBypass("place.php?whichplace=nstower&action=ns_05_monster1", $location[Tower Level 1]);
			if(internalQuestStatus("questL13Final") < 7)
			{
				set_property("auto_getBeehive", true);
				auto_log_warning("I probably failed the Wall of Skin, I assume that I tried without a beehive. Well, I'm going back to get it.", "red");
			}
			else
			{
				handleFamiliar("item");
			}
		}
		else
		{
			set_property("auto_getBeehive", true);
			auto_log_warning("Need a beehive, buzz buzz. Only have " + sources + " damage sources and we want " + sourceNeed, "red");
		}
		return true;
	}

	if(contains_text(visit_url("place.php?whichplace=nstower"), "ns_06_monster2"))
	{
		equipBaseline();
		shrugAT($effect[Polka of Plenty]);
		buffMaintain($effect[Disco Leer], 0, 1, 1);
		buffMaintain($effect[Polka of Plenty], 0, 1, 1);
		buffMaintain($effect[Cranberry Cordiality], 0, 1, 1);
		buffMaintain($effect[Big Meat Big Prizes], 0, 1, 1);
		buffMaintain($effect[Patent Avarice], 0, 1, 1);
		bat_formWolf();
		if((get_property("sidequestArenaCompleted") == "fratboy") && !get_property("concertVisited").to_boolean() && (have_effect($effect[Winklered]) == 0))
		{
			cli_execute("concert 2");
		}
		if(!useMaximizeToEquip())
		{
			autoEquip($item[Silver Cow Creamer]);
			autoEquip($item[Sneaky Pete\'s Leather Jacket]);
		}
		if(is100FamiliarRun())
		{
			if(useMaximizeToEquip())
			{
				addToMaximize("200meat drop");
			}
			else
			{
				autoMaximize("meat drop, -equip snow suit", 1500, 0, false);
			}
		}
		else
		{
			if(useMaximizeToEquip())
			{
				addToMaximize("200meat drop,switch hobo monkey,switch rockin' robin,switch adventurous spelunker,switch grimstone golem,switch fist turkey,switch unconscious collective,switch golden monkey,switch angry jung man,switch leprechaun,switch cat burglar");
			}
			else
			{
				autoMaximize("meat drop, -equip snow suit, switch Hobo Monkey, switch rockin' robin, switch adventurous spelunker, switch Grimstone Golem, switch Fist Turkey, switch Unconscious Collective, switch Golden Monkey, switch Angry Jung Man, switch Leprechaun,switch cat burglar", 1500, 0, false);
				handleFamiliar(my_familiar());
			}
		}
		if(my_class() == $class[Seal Clubber])
		{
			autoEquip($item[Meat Tenderizer is Murder]);
		}

		acquireHP();
		autoAdvBypass("place.php?whichplace=nstower&action=ns_06_monster2", $location[Noob Cave]);
		return true;
	}

	if(contains_text(visit_url("place.php?whichplace=nstower"), "ns_07_monster3"))
	{
		if((item_amount($item[Electric Boning Knife]) > 0) || (auto_my_path() == "Pocket Familiars"))
		{
			set_property("auto_getBoningKnife", false);
		}

		if(!get_property("auto_getBoningKnife").to_boolean() && ((my_class() == $class[Sauceror]) || have_skill($skill[Garbage Nova])))
		{
			uneffect($effect[Scarysauce]);
			uneffect($effect[Jalape&ntilde;o Saucesphere]);
			uneffect($effect[Mayeaugh]);
			uneffect($effect[Spiky Shell]);
			handleFamiliar($familiar[none]);
			buffMaintain($effect[Tomato Power], 0, 1, 1);
			buffMaintain($effect[Seeing Colors], 0, 1, 1);
			buffMaintain($effect[Glittering Eyelashes], 0, 1, 1);
			buffMaintain($effect[OMG WTF], 0, 1, 1);
			buffMaintain($effect[There is a Spoon], 0, 1, 1);
			boolean keepTrying = true;
			acquireMP(216, 0);

			buffMaintain($effect[Song of Sauce], 0, 1, 1);
			buffMaintain($effect[Carol of the Hells], 0, 1, 1);
			if(item_amount($item[Electric Boning Knife]) == 0)
			{
				if(useMaximizeToEquip())
				{
					addToMaximize("100myst,60spell damage percent,20spell damage,-20ml");
				}
				else
				{
					autoMaximize("myst -equip snow suit", 1500, 0, false);
				}
			}
			foreach s in $slots[acc1, acc2, acc3]
			{
				if(equipped_item(s) == $item[hand in glove])
				{
					equip(s, $item[none]);
				}
			}

			acquireHP();

			// Go into the fight with No Familiar Equips since maximizer wants to force an equip
			// this keeps us from accidentally dealing damage and killing ourselves
			addToMaximize("-familiar");

			autoAdvBypass("place.php?whichplace=nstower&action=ns_07_monster3", $location[Noob Cave]);
			if(internalQuestStatus("questL13Final") < 9)
			{
				auto_log_warning("Could not towerkill Wall of Bones, reverting to Boning Knife", "red");
				acquireHP();
				set_property("auto_getBoningKnife", true);
			}
			else
			{
				handleFamiliar("item");
			}
		}
		else if((item_amount($item[Electric Boning Knife]) > 0) || (auto_my_path() == "Pocket Familiars"))
		{
			return autoAdvBypass("place.php?whichplace=nstower&action=ns_07_monster3", $location[Noob Cave]);
		}
		else if(canGroundhog($location[The Castle in the Clouds in the Sky (Ground Floor)]))
		{
			auto_log_info("Backfarming an Electric Boning Knife", "green");
			set_property("choiceAdventure1026", "2");
			autoAdv(1, $location[The Castle in the Clouds in the Sky (Ground Floor)]);
		}
		return true;
	}

	if(contains_text(visit_url("place.php?whichplace=nstower"), "ns_08_monster4"))
	{
		boolean confidence = get_property("auto_confidence").to_boolean();
		// confidence really just means take the first choice, so it's necessary in vampyre
		if(my_class() == $class[Vampyre])
			confidence = true;
		string choicenum = (confidence ? "1" : "2");
		set_property("choiceAdventure1015", choicenum);
		visit_url("place.php?whichplace=nstower&action=ns_08_monster4");
		visit_url("choice.php?pwd=&whichchoice=1015&option=" + choicenum, true);
		return true;
	}

	if(contains_text(visit_url("place.php?whichplace=nstower"), "ns_09_monster5"))
	{
		if(my_maxhp() < 800)
		{
			buffMaintain($effect[Industrial Strength Starch], 0, 1, 1);
			buffMaintain($effect[Truly Gritty], 0, 1, 1);
			buffMaintain($effect[Superheroic], 0, 1, 1);
			buffMaintain($effect[Strong Grip], 0, 1, 1);
			buffMaintain($effect[Spiky Hair], 0, 1, 1);
		}
		cli_execute("scripts/autoscend/auto_post_adv.ash");
		acquireHP();

		int n_healing_items = item_amount($item[gauze garter]) + item_amount($item[filthy poultice]);
		if(n_healing_items < 5)
		{
			abort("We only have " + n_healing_items + "healing items, I'm not sure we can do the shadow.");
		}
		autoAdvBypass("place.php?whichplace=nstower&action=ns_09_monster5", $location[Noob Cave]);
		return true;
	}

	if(contains_text(visit_url("place.php?whichplace=nstower"), "ns_10_sorcfight"))
	{
		set_property("auto_sorceress", "top");
		return true;
	}

	return false;
}

boolean L13_towerNSHedge()
{
	if(get_property("auto_sorceress") != "hedge")
	{
		return false;
	}
	string page = visit_url("place.php?whichplace=nstower");
	if(contains_text(page, "nstower_door"))
	{
		set_property("auto_sorceress", "door");
		return true;
	}
	if(contains_text(page, "hedgemaze"))
	{
		//If we got beaten up by the last hedgemaze, mafia might set questL13Final to step5 anyway. Fix that.
		set_property("questL13Final", "step4");
		if((have_effect($effect[Beaten Up]) > 0) || (my_hp() < 150))
		{
			auto_log_critical("Hedge maze not solved, the mysteries are still there (correcting step5 -> step4)", "red");
			abort("Heal yourself and try again...");
		}
	}
	if(internalQuestStatus("questL13Final") >= 5)
	{
		auto_log_warning("Should already be past the hedge maze but did not see the door", "red");
		set_property("auto_sorceress", "door");
		return false;
	}

	# Set this so it aborts if not enough adventures. Otherwise, well, we end up in a loop.
	set_property("choiceAdventure1004", "3");
	set_property("choiceAdventure1005", "2");			# 'Allo
	set_property("choiceAdventure1006", "2");			# One Small Step For Adventurer
	set_property("choiceAdventure1007", "2");			# Twisty Little Passages, All Hedge
	set_property("choiceAdventure1008", "2");			# Pooling Your Resources
	set_property("choiceAdventure1009", "2");			# Gold Ol' 44% Duck
	set_property("choiceAdventure1010", "2");			# Another Day, Another Fork
	set_property("choiceAdventure1011", "2");			# Of Mouseholes and Manholes
	set_property("choiceAdventure1012", "2");			# The Last Temptation
	set_property("choiceAdventure1013", "1");			# Masel Tov!

	maximize_hedge();
	cli_execute("auto_pre_adv");
	acquireHP();
	visit_url("place.php?whichplace=nstower&action=ns_03_hedgemaze");
	if(get_property("lastEncounter") == "This Maze is... Mazelike...")
	{
		run_choice(2);
		abort("May not have enough adventures for the hedge maze. Failing");
	}

	if(get_property("auto_hedge") == "slow")
	{
		visit_url("choice.php?pwd=&whichchoice=1005&option=1", true);
		visit_url("choice.php?pwd=&whichchoice=1006&option=1", true);
		visit_url("choice.php?pwd=&whichchoice=1007&option=1", true);
		visit_url("choice.php?pwd=&whichchoice=1008&option=1", true);
		visit_url("choice.php?pwd=&whichchoice=1009&option=1", true);
		visit_url("choice.php?pwd=&whichchoice=1010&option=1", true);
		visit_url("choice.php?pwd=&whichchoice=1011&option=1", true);
		visit_url("choice.php?pwd=&whichchoice=1012&option=1", true);
		visit_url("choice.php?pwd=&whichchoice=1013&option=1", true);
	}
	else if(get_property("auto_hedge") == "fast")
	{
		visit_url("choice.php?pwd=&whichchoice=1005&option=2", true);
		visit_url("choice.php?pwd=&whichchoice=1008&option=2", true);
		visit_url("choice.php?pwd=&whichchoice=1011&option=2", true);
		visit_url("choice.php?pwd=&whichchoice=1013&option=1", true);
	}
	else
	{
		abort("auto_hedge not set properly (slow/fast), assuming manual handling desired");
	}
	if(have_effect($effect[Beaten Up]) > 0)
	{
		abort("Failed the hedge maze, may want to do this manually...");
	}
	return true;
}


boolean L13_towerNSContests()
{
	if(get_property("auto_sorceress") != "start")
	{
		return false;
	}


	if((get_property("auto_trytower") == "pause") || (get_property("auto_trytower") == "stop"))
	{
		ns_crowd1();
		ns_crowd2();
		ns_crowd3();
		ns_hedge1();
		ns_hedge2();
		ns_hedge3();
		if(get_property("auto_trytower") == "stop")
		{
			auto_log_critical("Manual handling for the start of challenges still required. Then run me again. Beep", "blue");
			set_property("choiceAdventure1003", 3);
			abort("Can't handle this optimally just yet, damn it");
		}
		else if(get_property("auto_trytower") == "pause")
		{
			set_property("auto_trytower", "");
			auto_log_critical("Start the tower challenges and then run me again and I'll take care of the rest");
			abort("Run again once all three challenges have been started. We will assume they have been");
			set_property("choiceAdventure1003", 3);
		}
		else
		{
			auto_log_critical("Manual handling for the start of challenges still required. Then run me again. Beep");
			set_property("choiceAdventure1003", 3);
			abort("Can't handle this optimally just yet, damn it");
		}
		return true;
	}


	if(contains_text(visit_url("place.php?whichplace=nstower"), "nstower_door"))
	{
		set_property("auto_sorceress", "door");
		return true;
	}
	if(contains_text(visit_url("place.php?whichplace=nstower"), "ns_03_hedgemaze"))
	{
		set_property("auto_sorceress", "hedge");
		return true;
	}
	if(contains_text(visit_url("place.php?whichplace=nstower"), "ns_02_coronation"))
	{
		set_property("choiceAdventure1020", "1");
		set_property("choiceAdventure1021", "1");
		set_property("choiceAdventure1022", "1");
		visit_url("place.php?whichplace=nstower&action=ns_02_coronation");
		visit_url("choice.php?pwd=&whichchoice=1020&option=1", true);
		visit_url("choice.php?pwd=&whichchoice=1021&option=1", true);
		visit_url("choice.php?pwd=&whichchoice=1022&option=1", true);
		return true;
	}

	boolean crowd1Insufficient()
	{
		return numeric_modifier("Initiative") < 400.0;
	}

	stat crowd_stat = ns_crowd2();

	boolean crowd2Insufficient()
	{
		return my_buffedstat(crowd_stat) < 600;
	}

	element challenge = ns_crowd3();
	boolean crowd3Insufficient()
	{
		return numeric_modifier(challenge + " Damage") + numeric_modifier(challenge + " Spell Damage") < 100;
	}

	if(contains_text(visit_url("place.php?whichplace=nstower"), "ns_01_contestbooth"))
	{
		if(get_property("nsContestants1").to_int() == -1)
		{
			if(!get_property("_grimBuff").to_boolean() && auto_have_familiar($familiar[Grim Brother]))
			{
				cli_execute("grim init");
			}
			if((get_property("telescopeUpgrades").to_int() > 0) && (!get_property("telescopeLookedHigh").to_boolean()))
			{
				cli_execute("telescope high");
			}
			switch(ns_crowd1())
			{
			case 1:
				acquireMP(160); // only uses free rests or items on hand by default

				if(is100FamiliarRun())
				{
					autoMaximize("init, -equip snow suit", 1500, 0, false);
				}
				else
				{
					autoMaximize("init, switch xiblaxian holo-companion, switch oily woim, switch happy medium,switch cute meteor", 1500, 0, false);
					handleFamiliar(my_familiar());
				}

				bat_formBats();

				foreach eff in $effects[Adorable Lookout, Alacri Tea, All Fired Up, Bone Springs, Bow-Legged Swagger, Fishy\, Oily, The Glistening, Human-Machine Hybrid, Patent Alacrity, Provocative Perkiness, Sepia Tan, Sugar Rush, Ticking Clock, Well-Swabbed Ear, Your Fifteen Minutes]
				{
					if(crowd1Insufficient()) buffMaintain(eff, 0, 1, 1);
				}

				if(crowd1Insufficient()) buffMaintain($effect[Cletus\'s Canticle of Celerity], 10, 1, 1);
				if(crowd1Insufficient()) buffMaintain($effect[Suspicious Gaze], 10, 1, 1);
				if(crowd1Insufficient()) buffMaintain($effect[Springy Fusilli], 10, 1, 1);
				if(crowd1Insufficient()) buffMaintain($effect[Walberg\'s Dim Bulb], 5, 1, 1);
				if(crowd1Insufficient()) buffMaintain($effect[Song of Slowness], 100, 1, 1);
				if(crowd1Insufficient()) buffMaintain($effect[Soulerskates], 0, 1, 1);
				if(crowd1Insufficient()) asdonBuff($effect[Driving Quickly]);
				if(crowd1Insufficient()) auto_beachCombHead("init");

				if(crowd1Insufficient())
				{
					if(get_property("auto_secondPlaceOrBust").to_boolean())
						abort("Not enough initiative for the initiative test, aborting since auto_secondPlaceOrBust=true");
					else
						auto_log_warning("Not enough initiative for the initiative test, but continuing since auto_secondPlaceOrBust=false", "red");
				}
				break;
			}

			visit_url("place.php?whichplace=nstower&action=ns_01_contestbooth");
			visit_url("choice.php?pwd=&whichchoice=1003&option=1", true);
			visit_url("main.php");
		}
		if(get_property("nsContestants2").to_int() == -1)
		{
			if(!get_property("_lyleFavored").to_boolean())
			{
				string temp = visit_url("place.php?whichplace=monorail&action=monorail_lyle");
			}
			acquireMP(150); // only uses free rests or items on hand by default
			buffMaintain($effect[Big], 15, 1, 1);
			if (my_class() == $class[Vampyre])
			{
				if(crowd_stat == $stat[muscle] && !have_skill($skill[Preternatural Strength]))
				{
					boolean[skill] requirements;
					requirements[$skill[Preternatural Strength]] = true;
					auto_log_info("Torporing, since we want to get Preternatural Strength.", "blue");
					bat_reallyPickSkills(20, requirements);
				}
				// This could be generalized for stat equalizer potions, but that seems marginal
				if (crowd_stat == $stat[muscle] && have_skill($skill[Preternatural Strength]))
					crowd_stat = $stat[mysticality];
				if (crowd_stat == $stat[moxie] && have_skill($skill[Sinister Charm]))
					crowd_stat = $stat[mysticality];
			}
			switch(crowd_stat)
			{
			case $stat[moxie]:
				autoMaximize("moxie -equip snow suit", 1500, 0, false);

				foreach eff in $effects[Almost Cool, Busy Bein\' Delicious, Butt-Rock Hair, Funky Coal Patina, Impeccable Coiffure, Liquidy Smoky, Locks Like the Raven, Lycanthropy\, Eh?, Memories of Puppy Love, Newt Gets In Your Eyes, Notably Lovely, Oiled Skin, Pill Power, Radiating Black Body&trade;, Seriously Mutated,  Spiky Hair, Sugar Rush, Standard Issue Bravery, Superhuman Sarcasm, Tomato Power, Vital]
				{
					if(crowd2Insufficient()) buffMaintain(eff, 0, 1, 1);
				}

				if(crowd2Insufficient()) buffMaintain($effect[The Moxious Madrigal], 10, 1, 1);
				if(crowd2Insufficient()) {
					if(auto_have_skill($skill[Quiet Desperation]))
						buffMaintain($effect[Quiet Desperation], 10, 1, 1);
					else
						buffMaintain($effect[Disco Smirk], 10, 1, 1);
				}
				if(crowd2Insufficient()) buffMaintain($effect[Song of Bravado], 100, 1, 1);
				if(crowd2Insufficient()) buffMaintain($effect[Stevedave\'s Shanty of Superiority], 30, 1, 1);
				if(crowd1Insufficient()) auto_beachCombHead("moxie");
				if(have_effect($effect[Ten out of Ten]) == 0)
				{
					if(crowd2Insufficient()) fightClubSpa($effect[Ten out of Ten]);
				}
				break;
			case $stat[muscle]:
				autoMaximize("muscle -equip snow suit", 1500, 0, false);

				foreach eff in $effects[Browbeaten, Extra Backbone, Extreme Muscle Relaxation, Feroci Tea, Fishy Fortification, Football Eyes, Go Get \'Em\, Tiger!, Human-Human Hybrid, Industrial Strength Starch, Juiced and Loose, Lycanthropy\, Eh?, Marinated, Phorcefullness, Pill Power, Rainy Soul Miasma, Savage Beast Inside, Seriously Mutated, Slightly Larger Than Usual, Standard Issue Bravery, Steroid Boost, Spiky Hair, Sugar Rush, Superheroic, Temporary Lycanthropy, Tomato Power, Truly Gritty, Vital, Woad Warrior]
				{
					if(crowd2Insufficient()) buffMaintain(eff, 0, 1, 1);
				}

				if(crowd2Insufficient()) buffMaintain($effect[Quiet Determination], 10, 1, 1);
				if(crowd2Insufficient()) buffMaintain($effect[Power Ballad of the Arrowsmith], 10, 1, 1);
				if(crowd2Insufficient()) buffMaintain($effect[Song of Bravado], 100, 1, 1);
				if(crowd2Insufficient()) buffMaintain($effect[Stevedave\'s Shanty of Superiority], 30, 1, 1);
				if(crowd1Insufficient()) auto_beachCombHead("muscle");
				if(have_effect($effect[Muddled]) == 0)
				{
					if(crowd2Insufficient()) fightClubSpa($effect[Muddled]);
				}
				break;
			case $stat[mysticality]:
				autoMaximize("myst -equip snow suit", 1500, 0, false);

				# Gothy may have given us a strange bug during one ascension, removing it for now.
				foreach eff in $effects[Baconstoned, Erudite, Far Out, Glittering Eyelashes, Industrial Strength Starch, Liquidy Smoky, Marinated, Mind Vision, Mutated, Mystically Oiled, OMG WTF, Pill Power, Rainy Soul Miasma, Ready to Snap, Rosewater Mark, Seeing Colors, Slightly Larger Than Usual, Standard Issue Bravery, Sweet\, Nuts, Tomato Power, Vital]
				{
					if(crowd2Insufficient()) buffMaintain(eff, 0, 1, 1);
				}

				if(crowd2Insufficient()) buffMaintain($effect[Quiet Judgement], 10, 1, 1);
				if(crowd2Insufficient()) buffMaintain($effect[The Magical Mojomuscular Melody], 10, 1, 1);
				if(crowd2Insufficient()) buffMaintain($effect[Song of Bravado], 100, 1, 1);
				if(crowd2Insufficient()) buffMaintain($effect[Pasta Oneness], 1, 1, 1);
				if(crowd2Insufficient()) buffMaintain($effect[Saucemastery], 1, 1, 1);
				if(crowd2Insufficient()) buffMaintain($effect[Stevedave\'s Shanty of Superiority], 30, 1, 1);
				if(crowd1Insufficient()) auto_beachCombHead("mysticality");
				if(have_effect($effect[Uncucumbered]) == 0)
				{
					if(crowd2Insufficient()) fightClubSpa($effect[Uncucumbered]);
				}
				break;
			}

			if(crowd2Insufficient())
			{
				if(get_property("auto_secondPlaceOrBust").to_boolean())
					abort("Not enough " + crowd_stat + " for the stat test, aborting since auto_secondPlaceOrBust=true");
				else
					auto_log_warning("Not enough " + crowd_stat + " for the stat test, but continuing since auto_secondPlaceOrBust=false", "red");
			}
			visit_url("place.php?whichplace=nstower&action=ns_01_contestbooth");
			visit_url("choice.php?pwd=&whichchoice=1003&option=2", true);
			visit_url("main.php");
		}
		if(get_property("nsContestants3").to_int() == -1)
		{
			acquireMP(125); // only uses free rests or items on hand by default

			if(challenge != $element[none])
			{
				autoMaximize(challenge + " dmg, " + challenge + " spell dmg -equip snow suit", 1500, 0, false);
			}

			if(crowd3Insufficient()) buffMaintain($effect[All Glory To the Toad], 0, 1, 1);
			if(crowd3Insufficient()) buffMaintain($effect[Bendin\' Hell], 120, 1, 1);
			switch(challenge)
			{
			case $element[cold]:
				if(crowd3Insufficient()) buffMaintain($effect[Cold Hard Skin], 0, 1, 1);
				if(crowd3Insufficient()) buffMaintain($effect[Frostbeard], 15, 1, 1);
				if(crowd3Insufficient()) buffMaintain($effect[Icy Glare], 10, 1, 1);
				if(crowd3Insufficient()) buffMaintain($effect[Song of the North], 100, 1, 1);
				break;
			case $element[hot]:
				if(crowd3Insufficient()) buffMaintain($effect[Song of Sauce], 100, 1, 1);
				if(crowd3Insufficient()) buffMaintain($effect[Flamibili Tea], 0, 1, 1);
				if(crowd3Insufficient()) buffMaintain($effect[Flaming Weapon], 0, 1, 1);
				if(crowd3Insufficient()) buffMaintain($effect[Human-Demon Hybrid], 0, 1, 1);
				if(crowd3Insufficient()) buffMaintain($effect[Lit Up], 0, 1, 1);
				if(crowd3Insufficient()) buffMaintain($effect[Fire Inside], 0, 1, 1);
				if(crowd3Insufficient()) buffMaintain($effect[Pyromania], 15, 1, 1);
				if(crowd3Insufficient()) buffMaintain($effect[Your Fifteen Minutes], 50, 1, 1);
				break;
			case $element[sleaze]:
				if(crowd3Insufficient()) buffMaintain($effect[Takin\' It Greasy], 15, 1, 1);
				if(crowd3Insufficient()) buffMaintain($effect[Blood-Gorged], 0, 1, 1);
				if(crowd3Insufficient()) buffMaintain($effect[Greasy Peasy], 0, 1, 1);
				break;
			case $element[stench]:
				if(crowd3Insufficient()) buffMaintain($effect[Drenched With Filth], 0, 1, 1);
				if(crowd3Insufficient()) buffMaintain($effect[Musky], 0, 1, 1);
				if(crowd3Insufficient()) buffMaintain($effect[Stinky Hands], 0, 1, 1);
				if(crowd3Insufficient()) buffMaintain($effect[Stinky Weapon], 0, 1, 1);
				if(crowd3Insufficient()) buffMaintain($effect[Rotten Memories], 15, 1, 1);
				break;
			case $element[spooky]:
				if(crowd3Insufficient()) buffMaintain($effect[Spooky Hands], 0, 1, 1);
				if(crowd3Insufficient()) buffMaintain($effect[Spooky Weapon], 0, 1, 1);
				if(crowd3Insufficient()) buffMaintain($effect[Dirge of Dreadfulness], 10, 1, 1);
				if(crowd3Insufficient()) buffMaintain($effect[Intimidating Mien], 15, 1, 1);
				if(crowd3Insufficient()) buffMaintain($effect[Snarl of the Timberwolf], 10, 1, 1);
				break;
			}

			float score = numeric_modifier(challenge + " damage");
			score += numeric_modifier(challenge + " spell damage");
			if((score > 20.0) && (score < 85.0))
			{
				buffMaintain($effect[Bendin\' Hell], 100, 1, 1);
			}

			score = numeric_modifier(challenge + " damage");
			score += numeric_modifier(challenge + " spell damage");
			if((score < 80) && get_property("auto_useWishes").to_boolean())
			{
				switch(challenge)
				{
				case $element[cold]:
					makeGenieWish($effect[Staying Frosty]);
					break;
				case $element[hot]:
					makeGenieWish($effect[Dragged Through the Coals]);
					break;
				case $element[sleaze]:
					makeGenieWish($effect[Fifty Ways to Bereave your Lover]);
					break;
				case $element[stench]:
					makeGenieWish($effect[Sewer-Drenched]);
					break;
				case $element[spooky]:
					makeGenieWish($effect[You\'re Back...]);
					break;
				}
			}

			if(crowd3Insufficient())
			{
				if(get_property("auto_secondPlaceOrBust").to_boolean())
					abort("Not enough " + challenge + " for the elemental test, aborting since auto_secondPlaceOrBust=true");
				else
					auto_log_warning("Not enough " + challenge + " for the elemental test, but continuing since auto_secondPlaceOrBust=false", "red");
			}

			visit_url("place.php?whichplace=nstower&action=ns_01_contestbooth");
			visit_url("choice.php?pwd=&whichchoice=1003&option=3", true);
			visit_url("main.php");
		}

		set_property("choiceAdventure1003",  4);
		if((get_property("nsContestants1").to_int() == 0) && (get_property("nsContestants2").to_int() == 0) && (get_property("nsContestants3").to_int() == 0))
		{
			auto_log_info("The NS Challenges are over! Victory is ours!", "blue");
			visit_url("place.php?whichplace=nstower&action=ns_01_contestbooth");
			visit_url("choice.php?pwd=&whichchoice=1003&option=4", true);
			visit_url("main.php");
			if((get_property("nsContestants1").to_int() != 0) || (get_property("nsContestants2").to_int() != 0) || (get_property("nsContestants3").to_int() != 0))
			{
				if(get_property("questL13Final") == "step2")
				{
					if(auto_my_path() == "The Source")
					{
						//As of r17048, encountering a Source Agent on the Challenge line results in nsContestants being decremented twice.
						//Since we were using Mafia\'s tracking here, we have to compensate for when it fails...
						auto_log_warning("Probably encountered a Source Agent during the NS Contestants and Mafia's tracking fails on this. Let's try to correct it...", "red");
						set_property("questL13Final", "step1");
					}
					else
					{
						auto_log_critical("Error not recoverable (as not antipicipated) outside of The Source (Source Agents during NS Challenges), aborting.", "red");
						abort("questL13Final error in unexpected path.");
					}
				}
				else
				{
					auto_log_critical("Unresolvable error: Mafia thinks the NS challenges are complete but something is very wrong.", "red");
					abort("Unknown questL13Final/auto_sorceress state.");
				}
			}
			return true;
		}
	}

	handleFamiliar("item");
	equipBaseline();

	if(contains_text(visit_url("place.php?whichplace=nstower"), "ns_01_crowd1"))
	{
		autoAdv(1, $location[Fastest Adventurer Contest]);
		return true;
	}

	if(contains_text(visit_url("place.php?whichplace=nstower"), "ns_01_crowd2"))
	{
		location toCompete = $location[none];
		switch(get_property("nsChallenge1"))
		{
		case "Mysticality":	toCompete = $location[Smartest Adventurer Contest];		break;
		case "Moxie":		toCompete = $location[Smoothest Adventurer Contest];	break;
		case "Muscle":		toCompete = $location[Strongest Adventurer Contest];	break;
		}
		if(toCompete == $location[none])
		{
			abort("nsChallenge1 is invalid. This is a severe error.");
		}
		autoAdv(1, toCompete);
		return true;
	}

	if(contains_text(visit_url("place.php?whichplace=nstower"), "ns_01_crowd3"))
	{
		location toCompete = $location[none];
		switch(get_property("nsChallenge2"))
		{
		case "cold":		toCompete = $location[Coldest Adventurer Contest];		break;
		case "hot":			toCompete = $location[Hottest Adventurer Contest];		break;
		case "sleaze":		toCompete = $location[Sleaziest Adventurer Contest];	break;
		case "spooky":		toCompete = $location[Spookiest Adventurer Contest];	break;
		case "stench":		toCompete = $location[Stinkiest Adventurer Contest];	break;
		}
		if(toCompete == $location[none])
		{
			abort("nsChallenge1 is invalid. This is a severe error.");
		}
		autoAdv(1, toCompete);
		return true;
	}
	auto_log_info("No challenges left!", "green");
	if(auto_my_path() == "Pocket Familiars")
	{
		if(get_property("nsContestants1").to_int() == 0)
		{
			return false;
		}
		set_property("nsContestants1", 0);
		set_property("nsContestants2", 0);
		set_property("nsContestants3", 0);
		return true;
	}
	return false;
}

boolean L13_towerNSEntrance()
{
	if(get_property("auto_sorceress") != "")
	{
		return false;
	}

	if(L13_ed_towerHandler())
	{
		return true;
	}

	if(contains_text(visit_url("place.php?whichplace=nstower"), "ns_01_contestbooth"))
	{
		set_property("auto_sorceress", "start");
		set_property("choiceAdventure1003", 0);
	}
	else
	{
		if(my_level() < 13)
		{
			auto_log_warning("I seem to need to power level, or something... waaaa.", "red");
			# lx_attemptPowerLevel is before. We need to merge all of this into that....
			set_property("auto_newbieOverride", true);

			if(snojoFightAvailable() && (auto_my_path() == "Pocket Familiars"))
			{
				autoAdv(1, $location[The X-32-F Combat Training Snowman]);
				return true;
			}


			if(needDigitalKey())
			{
				woods_questStart();
				if(LX_getDigitalKey())
				{
					return true;
				}
			}
			if(needStarKey())
			{
				if(zone_isAvailable($location[The Hole In The Sky]))
				{
					if(LX_getStarKey())
					{
						return true;
					}
				}
			}
			if(neverendingPartyPowerlevel())
			{
				return true;
			}
			if(!hasTorso())
			{
				if(LX_melvignShirt())
				{
					return true;
				}
			}

			int delay = get_property("auto_powerLevelTimer").to_int();
			if(delay == 0)
			{
				delay = 10;
			}
			wait(delay);

			if(haveAnyIotmAlternativeRestSiteAvailable() && haveFreeRestAvailable() && auto_my_path() != "The Source")
			{
				doFreeRest();
				cli_execute("scripts/autoscend/auto_post_adv.ash");
				loopHandlerDelayAll();
				return true;
			}

			if(!LX_attemptPowerLevel())
			{
				if(get_property("auto_powerLevelAdvCount").to_int() >= 10)
				{
					auto_log_warning("The following error message is probably wrong, you just need to powerlevel to 13 most likely.", "red");
					if((item_amount($item[Rock Band Flyers]) > 0) || (item_amount($item[Jam Band Flyers]) > 0))
					{
						abort("Need more flyer ML but don't know where to go :(");
					}
					else
					{
						abort("I am lost, please forgive me. I feel underleveled.");
					}
				}
			}
			return true;
		}
		else
		{
			#need a wand (or substitute a key lime for food earlier)
			if(my_level() != get_property("auto_powerLevelLastLevel").to_int())
			{
				auto_log_warning("Hmmm, we need to stop being so feisty about quests...", "red");
				set_property("auto_powerLevelLastLevel", my_level());
				return true;
			}
			council(); // Log council output
			abort("Some sidequest is not done for some raisin. Some sidequest is missing, or something is missing, or something is not not something. We don't know what to do.");
		}
	}
	return false;
}

boolean L12_lastDitchFlyer()
{
	if(get_property("auto_ignoreFlyer").to_boolean())
	{
		return false;
	}
	if(my_level() < 12)
	{
		return false;
	}
	if(get_property("flyeredML").to_int() >= 10000)
	{
		return false;
	}
	if(get_property("sidequestArenaCompleted") != "none")
	{
		return false;
	}
	if(get_property("auto_war") == "finished")
	{
		return false;
	}
	if((item_amount($item[Rock Band Flyers]) == 0) && (item_amount($item[Jam Band Flyers]) == 0))
	{
		return false;
	}

	auto_log_info("Not enough flyer ML but we are ready for the war... uh oh", "blue");

	if (needStarKey())
	{
		if (!zone_isAvailable($location[The Hole in the Sky]))
		{
			return (L10_topFloor() || L10_holeInTheSkyUnlock());
		}
		else
		{
			handleFamiliar("item");
			if(LX_getStarKey())
			{
				return true;
			}
		}
		return true;
	}
	else
	{
		auto_log_warning("Should not have so little flyer ML at this point", "red");
		wait(1);
		if(!LX_attemptFlyering())
		{
			abort("Need more flyer ML but don't know where to go :(");
		}
		return true;
	}
}

boolean LX_attemptFlyering()
{
	if(elementalPlanes_access($element[stench]) && auto_have_skill($skill[Summon Smithsness]))
	{
		return autoAdv(1, $location[Uncle Gator\'s Country Fun-Time Liquid Waste Sluice]);
	}
	else if(elementalPlanes_access($element[spooky]))
	{
		return autoAdv(1, $location[The Deep Dark Jungle]);
	}
	else if(elementalPlanes_access($element[cold]))
	{
		return autoAdv(1, $location[VYKEA]);
	}
	else if(elementalPlanes_access($element[stench]))
	{
		return autoAdv(1, $location[Uncle Gator\'s Country Fun-Time Liquid Waste Sluice]);
	}
	else if(elementalPlanes_access($element[sleaze]))
	{
		return autoAdv(1, $location[Sloppy Seconds Diner]);
	}
	else if(neverendingPartyAvailable())
	{
		return neverendingPartyPowerlevel();
	}
	else
	{
		int flyer = get_property("flyeredML").to_int();
		boolean retval = autoAdv($location[Near an Abandoned Refrigerator]);
		if (flyer == get_property("flyeredML").to_int())
		{
			abort("Trying to flyer but failed to flyer");
		}
		set_property("auto_newbieOverride", true);
		return retval;
	}
	return false;
}

boolean powerLevelAdjustment()
{
	if(get_property("auto_powerLevelLastLevel").to_int() != my_level() && get_property("auto_powerLevelAdvCount").to_int() > 0)
	{
		set_property("auto_powerLevelLastLevel", my_level());
		set_property("auto_powerLevelAdvCount", 0);
		return true;
	}
	return false;
}

boolean LX_melvignShirt()
{
	if(internalQuestStatus("questM22Shirt") < 0)
	{
		return false;
	}
	if(get_property("questM22Shirt") == "finished")
	{
		return false;
	}
	if(item_amount($item[Professor What Garment]) == 0)
	{
		autoAdv($location[The Thinknerd Warehouse]);
		return true;
	}
	string temp = visit_url("place.php?whichplace=mountains&action=mts_melvin", false);
	return true;
}

boolean LX_attemptPowerLevel()
{
	set_property("auto_powerLevelAdvCount", get_property("auto_powerLevelAdvCount").to_int() + 1);
	set_property("auto_powerLevelLastAttempted", my_turncount());

	handleFamiliar("stat");

	if(snojoFightAvailable() && (auto_my_path() == "Pocket Familiars"))
	{
		autoAdv(1, $location[The X-32-F Combat Training Snowman]);
		return true;
	}

	if(LX_freeCombats())
	{
		return true;
	}

	if(!hasTorso())
	{
		// We need to acquire a letter from Melvign...
		if(LX_melvignShirt())
		{
			return true;
		}
	}

	if(auto_my_path() == "The Source")
	{
		if(get_property("auto_spookyravensecond") != "")
		{
			if(get_property("barrelShrineUnlocked").to_boolean())
			{
				if(cloversAvailable() == 0)
				{
					handleBarrelFullOfBarrels(false);
					string temp = visit_url("barrel.php");
					temp = visit_url("choice.php?whichchoice=1099&pwd=&option=2");
					handleBarrelFullOfBarrels(false);
					return true;
				}
				stat myStat = my_primestat();
				if(my_basestat(myStat) >= 148)
				{
					return false;
				}
				else if(my_basestat(myStat) >= 125)
				{
					//Should probably prefer to check what equipment failures we may be having.
					if((my_basestat($stat[Muscle]) < my_basestat(myStat)) && (my_basestat($stat[Muscle]) < 70))
					{
						myStat = $stat[Muscle];
					}
					if((my_basestat($stat[Mysticality]) < my_basestat(myStat)) && (my_basestat($stat[Mysticality]) < 70))
					{
						myStat = $stat[Mysticality];
					}
					if((my_basestat($stat[Moxie]) < my_basestat(myStat)) && (my_basestat($stat[Moxie]) < 70))
					{
						myStat = $stat[Moxie];
					}
				}
				//Else, default to mainstat.

				//Determine where to go for clover stats, do not worry about clover failures
				location whereTo = $location[none];
				switch(myStat)
				{
				case $stat[Muscle]:			whereTo = $location[The Haunted Gallery];				break;
				case $stat[Mysticality]:	whereTo = $location[The Haunted Bathroom];				break;
				case $stat[Moxie]:			whereTo = $location[The Haunted Ballroom];				break;
				}

				if((whereTo == $location[The Haunted Ballroom]) && (get_property("auto_ballroomopen") != "open"))
				{
					use(item_amount($item[ten-leaf clover]), $item[ten-leaf clover]);
					LX_spookyBedroomCombat();
					return true;
				}
				if(cloversAvailable() > 0)
				{
					cloverUsageInit();
				}
				autoAdv(1, whereTo);
				cloverUsageFinish();
				return true;
			}
			//Banish mahogant, elegant after gown only. (Harold\'s Bell?)
			LX_spookyBedroomCombat();
			return true;
		}
	}

	if(elementalPlanes_access($element[stench]) && auto_have_skill($skill[Summon Smithsness]) && (get_property("auto_beatenUpCount").to_int() == 0))
	{
		autoAdv(1, $location[Uncle Gator\'s Country Fun-Time Liquid Waste Sluice]);
	}
	else if(elementalPlanes_access($element[spooky]))
	{
		autoAdv(1, $location[The Deep Dark Jungle]);
	}
	else if(elementalPlanes_access($element[cold]))
	{
		autoAdv(1, $location[VYKEA]);
	}
	else if(elementalPlanes_access($element[sleaze]))
	{
		autoAdv(1, $location[Sloppy Seconds Diner]);
	}
	else if (elementalPlanes_access($element[hot]))
	{
		autoAdv(1, $location[The SMOOCH Army HQ]);
	}
	else
	{
		// burn all spare clovers after level 12 if we need to powerlevel.
		int cloverLimit = get_property("auto_wandOfNagamar").to_boolean() ? 1 : 0;
		if (my_level() >= 12 && internalQuestStatus("questL12War") > 1 && cloversAvailable() > cloverLimit)
		{
			//Determine where to go for clover stats, do not worry about clover failures
			location whereTo = $location[none];
			switch (my_primestat())
			{
				case $stat[Muscle]:
					whereTo = $location[The Haunted Gallery];
					break;
				case $stat[Mysticality]:
					whereTo = $location[The Haunted Bathroom];
					break;
				case $stat[Moxie]:
					whereTo = $location[The Haunted Ballroom];
					break;
			}

			cloverUsageInit();
			boolean retval = autoAdv(1, whereTo);
			cloverUsageFinish();
			return retval;
		}

		// optimal levelling if you have no IotMs with scaling monsters
		if (internalQuestStatus("questM21Dance") > 3)
		{
			switch (my_primestat())
			{
				case $stat[Muscle]:
					set_property("louvreDesiredGoal", "4"); // get Muscle stats
					break;
				case $stat[Mysticality]:
					set_property("louvreDesiredGoal", "5"); // get Myst stats
					break;
				case $stat[Moxie]:
					set_property("louvreDesiredGoal", "6"); // get Moxie stats
					break;
			}
			if (isActuallyEd() && (!possessEquipment($item[serpentine sword]) || !possessEquipment($item[snake shield])))
			{
				set_property("choiceAdventure89", "2"); // fight the snake knight (as Ed)
			}
			else
			{
				set_property("choiceAdventure89", "6"); // ignore the NC & banish it for 10 adv
			}
			providePlusNonCombat(25);
			return autoAdv($location[The Haunted Gallery]);
		}
		return false;
	}
	return true;
}

boolean L11_hiddenTavernUnlock()
{
	return L11_hiddenTavernUnlock(false);
}

boolean L11_hiddenTavernUnlock(boolean force)
{
	if(!auto_is_valid($item[Book of Matches]))
	{
		return false;
	}

	if(my_ascensions() == get_property("hiddenTavernUnlock").to_int())
	{
		return true;
	}

	if(force)
	{
		if(!in_hardcore())
		{
			pullXWhenHaveY($item[Book of Matches], 1, 0);
		}
	}

	if(my_ascensions() > get_property("hiddenTavernUnlock").to_int())
	{
		if(item_amount($item[Book of Matches]) > 0)
		{
			use(1, $item[Book of Matches]);
			return true;
		}
		return false;
	}
	return true;
}

boolean L11_hiddenCity()
{
	if(get_property("auto_hiddencity") == "finished")
	{
		return false;
	}

	if(get_property("auto_hiddenzones") != "finished")
	{
		return false;
	}

	if(item_amount($item[[2180]Ancient Amulet]) == 1)
	{
		set_property("auto_hiddencity", "finished");
		return true;
	}
	else if (item_amount($item[[7963]Ancient Amulet]) == 0 && isActuallyEd())
	{
		set_property("auto_hiddencity", "finished");
		return true;
	}

	L11_hiddenTavernUnlock();

	if(get_property("auto_hiddenzones") == "finished")
	{
		if((get_property("_nanorhinoBanishedMonster") == "") && (have_effect($effect[nanobrawny]) == 0) && auto_have_familiar($familiar[Nanorhino]))
		{
			handleFamiliar($familiar[Nanorhino]);
		}
		else
		{
			handleFamiliar("item");
		}

		if((get_property("auto_hiddenapartment") == "finished") || (item_amount($item[Moss-Covered Stone Sphere]) > 0))
		{
			set_property("auto_hiddenapartment", "finished");
			uneffect($effect[Thrice-Cursed]);
			if((have_effect($effect[On The Trail]) > 0) && (get_property("olfactedMonster") == $monster[Pygmy Shaman]))
			{
				if(item_amount($item[soft green echo eyedrop antidote]) > 0)
				{
					auto_log_info("They stink so much!", "blue");
					uneffect($effect[On The Trail]);
				}
			}
		}
		if((get_property("auto_hiddenoffice") == "finished") || (item_amount($item[Crackling Stone Sphere]) > 0))
		{
			set_property("auto_hiddenoffice", "finished");
			if((have_effect($effect[On The Trail]) > 0) && (get_property("olfactedMonster") == $monster[Pygmy Witch Accountant]))
			{
				if(item_amount($item[soft green echo eyedrop antidote]) > 0)
				{
					auto_log_info("No more accountants to hunt!", "blue");
					uneffect($effect[On The Trail]);
				}
			}
		}
		if((get_property("auto_hiddenbowling") == "finished") || (item_amount($item[Scorched Stone Sphere]) > 0))
		{
			set_property("auto_hiddenbowling", "finished");
			if((have_effect($effect[On The Trail]) > 0) && (get_property("olfactedMonster") == $monster[Pygmy Bowler]))
			{
				if(item_amount($item[soft green echo eyedrop antidote]) > 0)
				{
					auto_log_info("No more stinky bowling shoes to worry about!", "blue");
					uneffect($effect[On The Trail]);
				}
			}
		}


	if((item_amount($item[Moss-Covered Stone Sphere]) == 0) && (get_property("auto_hiddenapartment") != "finished"))
	{
		if(get_counters("Fortune Cookie", 0, 9) == "Fortune Cookie")
		{
			return false;
		}
	}
	if((get_property("auto_hiddenapartment") != "finished") && (get_counters("Fortune Cookie", 0, 9) != "Fortune Cookie") && (my_adventures() >= (9 - get_property("auto_hiddenapartment").to_int())) && (have_effect($effect[Ancient Fortitude]) == 0))
		{
			auto_log_info("The idden [sic] apartment!", "blue");

			int current = get_property("auto_hiddenapartment").to_int() + 1;
			set_property("auto_hiddenapartment", current);

			if(auto_canForceNextNoncombat())
			{
				L11_hiddenTavernUnlock(true);

				if((my_ascensions() == get_property("hiddenTavernUnlock").to_int() && (inebriety_left() >= 3*$item[Cursed Punch].inebriety) && !in_tcrs())
					|| (0 != have_effect($effect[Thrice-Cursed]) && current <= 4))
				{
					auto_forceNextNoncombat();

					if(auto_my_path() == "Pocket Familiars")
					{
						if(get_property("relocatePygmyLawyer").to_int() != my_ascensions())
						{
							set_property("choiceAdventure780", "3");
							autoAdv(1, $location[The Hidden Apartment Building]);
							return true;
						}
					}
					current = 9;
				}
			}

			if(current <= 8)
			{
				auto_log_info("Hidden Apartment Progress: " + get_property("hiddenApartmentProgress"), "blue");
				autoAdv(1, $location[The Hidden Apartment Building]);
				if(lastAdventureSpecialNC())
				{
					set_property("auto_hiddenapartment", current - 1);
				}
				return true;
			}
			else
			{
				set_property("choiceAdventure780", "1");
				if(have_effect($effect[Thrice-Cursed]) == 0)
				{
					L11_hiddenTavernUnlock(true);
					while(have_effect($effect[Thrice-Cursed]) == 0)
					{
						if((inebriety_left() >= $item[Cursed Punch].inebriety) && canDrink($item[Cursed Punch]) && (my_ascensions() == get_property("hiddenTavernUnlock").to_int()) && !in_tcrs())
						{
							buyUpTo(1, $item[Cursed Punch]);
							if(item_amount($item[Cursed Punch]) == 0)
							{
								abort("Could not acquire Cursed Punch, unable to deal with Hidden Apartment Properly");
							}
							autoDrink(1, $item[Cursed Punch]);
						}
						else
						{
							set_property("choiceAdventure780", "2");
							break;
						}
					}
				}
				auto_log_info("Hidden Apartment Progress: " + get_property("hiddenApartmentProgress"), "blue");
				autoAdv(1, $location[The Hidden Apartment Building]);
				return true;
			}
		}
		if((get_property("auto_hiddenoffice") != "finished") && (my_adventures() >= 11))
		{
			auto_log_info("The idden [sic] office!", "blue");

			if((item_amount($item[Boring Binder Clip]) == 1) && (item_amount($item[McClusky File (Page 5)]) == 1))
			{
				#cli_execute("make mcclusky file (complete)");
				visit_url("inv_use.php?pwd=&which=3&whichitem=6694");
				cli_execute("refresh inv");
			}

			if(item_amount($item[McClusky File (Complete)]) > 0)
			{
				set_property("choiceAdventure786", "1");
			}
			else if(item_amount($item[Boring Binder Clip]) == 0)
			{
				set_property("choiceAdventure786", "2");
			}
			else
			{
				set_property("choiceAdventure786", "3");
			}

			auto_log_info("Hidden Office Progress: " + get_property("hiddenOfficeProgress"), "blue");
			if(considerGrimstoneGolem(true))
			{
				handleBjornify($familiar[Grimstone Golem]);
			}

			backupSetting("autoCraft", false);
			autoAdv(1, $location[The Hidden Office Building]);
			restoreSetting("autoCraft");
			return true;
		}

		if(get_property("auto_hiddenbowling") != "finished")
		{
			auto_log_info("The idden [sic] bowling alley!", "blue");
			L11_hiddenTavernUnlock(true);
			if(my_ascensions() == get_property("hiddenTavernUnlock").to_int() && !in_koe())
			{
				if(item_amount($item[Bowl Of Scorpions]) == 0)
				{
					buyUpTo(1, $item[Bowl Of Scorpions]);
					if(auto_my_path() == "One Crazy Random Summer")
					{
						buyUpTo(3, $item[Bowl Of Scorpions]);
					}
				}
			}
			set_property("choiceAdventure788", "1");

			if(item_amount($item[Airborne Mutagen]) > 1)
			{
				buffMaintain($effect[Heightened Senses], 0, 1, 1);
			}

			buffMaintain($effect[Fishy Whiskers], 0, 1, 1);
			auto_log_info("Hidden Bowling Alley Progress: " + get_property("hiddenBowlingAlleyProgress"), "blue");
			autoAdv(1, $location[The Hidden Bowling Alley]);

			return true;
		}

		if(get_property("auto_hiddenhospital") != "finished")
		{
			if(item_amount($item[Dripping Stone Sphere]) > 0)
			{
				set_property("auto_hiddenhospital", "finished");
				return true;
			}
			auto_log_info("The idden osptial!! [sic]", "blue");
			set_property("choiceAdventure784", "1");

			autoEquip($item[bloodied surgical dungarees]);
			autoEquip($item[half-size scalpel]);
			autoEquip($item[surgical apron]);
			autoEquip($slot[acc3], $item[head mirror]);
			autoEquip($slot[acc2], $item[surgical mask]);
			auto_log_info("Hidden Hospital Progress: " + get_property("hiddenHospitalProgress"), "blue");
			if((my_mp() > 60) || considerGrimstoneGolem(true))
			{
				handleBjornify($familiar[Grimstone Golem]);
			}
			autoAdv(1, $location[The Hidden Hospital]);

			return true;
		}
		if((get_property("auto_hiddenapartment") == "finished") && (get_property("auto_hiddenoffice") == "finished") && (get_property("auto_hiddenbowling") == "finished") && (get_property("auto_hiddenhospital") == "finished"))
		{
			auto_log_info("Getting the stone triangles", "blue");
			set_property("choiceAdventure791", "1");
			while(item_amount($item[stone triangle]) < 1)
			{
				autoAdv(1, $location[An Overgrown Shrine (Northwest)]);
			}
			while(item_amount($item[stone triangle]) < 2)
			{
				autoAdv(1, $location[An Overgrown Shrine (Northeast)]);
			}
			while(item_amount($item[stone triangle]) < 3)
			{
				autoAdv(1, $location[An Overgrown Shrine (Southwest)]);
			}
			while(item_amount($item[stone triangle]) < 4)
			{
				autoAdv(1, $location[An Overgrown Shrine (Southeast)]);
			}

			auto_log_info("Fighting the out-of-work spirit", "blue");
			acquireHP();

			try
			{
				handleFamiliar("initSuggest");
				string[int] pages;
				pages[0] = "adventure.php?snarfblat=350";
				pages[1] = "choice.php?pwd&whichchoice=791&option=1";
				if(autoAdvBypass(0, pages, $location[A Massive Ziggurat], "")) {}
				handleFamiliar("item");
			}
			finally
			{
				auto_log_warning("If I stopped, just run me again, beep!", "red");
			}

			if(item_amount($item[2180]) == 1)
			{
				set_property("auto_hiddencity", "finished");
			}

			return true;
		}
		#abort("Should not have gotten here. Aborting");
	}
	return false;
}

boolean L11_hiddenCityZones()
{
	L11_hiddenTavernUnlock();

	if(my_level() < 11)
	{
		return false;
	}
	if(get_property("auto_mcmuffin") != "start")
	{
		return false;
	}
	if(get_property("auto_hiddenunlock") != "finished")
	{
		return false;
	}
	if(get_property("auto_hiddenzones") == "finished")
	{
		return false;
	}

	if(get_property("auto_hiddenzones") == "")
	{
		auto_log_info("Machete the hidden zones!", "blue");
		set_property("choiceAdventure791", "6");
		set_property("auto_hiddenzones", "0");
	}

	if(get_property("auto_hiddenzones") == "0")
	{
		boolean needMachete = !possessEquipment($item[Antique Machete]);
		boolean needRelocate = (get_property("relocatePygmyJanitor").to_int() != my_ascensions());
		boolean needMatches = (get_property("hiddenTavernUnlock").to_int() != my_ascensions());

		if(!in_hardcore() || (my_class() == $class[Avatar of Boris]) || (auto_my_path() == "Way of the Surprising Fist") || (auto_my_path() == "Pocket Familiars"))
		{
			needMachete = false;
		}

		if(!needMatches)
		{
			needRelocate = false;
		}

		if(!in_hardcore())
		{
			needMatches = false;
		}

		int banishers = 0;
		foreach sk in $skills[Batter Up!, Snokebomb]
		{
			if(have_skill(sk))
			{
				banishers++;
			}
		}

		if(banishers >= 1)
		{
			needRelocate = false;
		}

		if(!needRelocate)
		{
			needMatches = false;
		}

/*
		if(possessEquipment($item[Antique Machete]))
		{
			if(!in_hardcore() || (get_property("hiddenTavernUnlock").to_int() == my_ascensions()))
			{
				set_property("auto_hiddenzones", "1");
				return true;
			}
		}

		if(((my_class() == $class[Avatar of Boris]) || (auto_my_path() == "Way of the Surprising Fist") || (auto_my_path() == "Pocket Familiars")) && (get_property("relocatePygmyJanitor").to_int() == my_ascensions()))
		{
			if(!in_hardcore() || (get_property("hiddenTavernUnlock").to_int() == my_ascensions()))
			{
				set_property("auto_hiddenzones", "1");
				return true;
			}
		}
*/

		if(!needMachete && !needRelocate && !needMatches)
		{
			set_property("auto_hiddenzones", "1");
			return true;
		}

		if((my_mp() > 60) || considerGrimstoneGolem(true))
		{
			handleBjornify($familiar[Grimstone Golem]);
		}
		if(get_property("relocatePygmyJanitor").to_int() == my_ascensions())
		{
			set_property("choiceAdventure789", "1");
		}
		else
		{
			set_property("choiceAdventure789", "2");
		}

		// Try to get the NC so that we can relocate Janitors and get items quickly
		providePlusNonCombat(25, true);

		autoAdv(1, $location[The Hidden Park]);
		return true;
	}

	if(get_property("auto_hiddenzones") == "1")
	{
		if(internalQuestStatus("questL11Curses") >= 0)
		{
			set_property("auto_hiddenzones", "2");
			return true;
		}
		autoForceEquip($item[Antique Machete]);
		# Add provision for Golden Monkey, or even more so, "Do we need spleen item"
		if(($familiar[Unconscious Collective].drops_today < 1) && auto_have_familiar($familiar[Unconscious Collective]))
		{
			handleFamiliar($familiar[Unconscious Collective]);
		}
		else if(auto_have_familiar($familiar[Fist Turkey]))
		{
			handleFamiliar($familiar[Fist Turkey]);
		}
		handleBjornify($familiar[Grinning Turtle]);
		if(considerGrimstoneGolem(true))
		{
			handleBjornify($familiar[Grimstone Golem]);
		}

		set_property("choiceAdventure781", "1");
		autoAdv(1, $location[An Overgrown Shrine (Northwest)]);
		loopHandlerDelayAll();
		if(contains_text(get_property("lastEncounter"), "Earthbound and Down"))
		{
			set_property("auto_hiddenzones", "2");
			set_property("choiceAdventure781", 6);
		}
		return true;
	}

	if(get_property("auto_hiddenzones") == "2")
	{
		if(internalQuestStatus("questL11Business") >= 0)
		{
			set_property("auto_hiddenzones", "3");
			return true;
		}
		autoForceEquip($item[Antique Machete]);
		if(($familiar[Unconscious Collective].drops_today < 1) && auto_have_familiar($familiar[Unconscious Collective]))
		{
			handleFamiliar($familiar[Unconscious Collective]);
		}
		else
		{
			handleFamiliar($familiar[Fist Turkey]);
		}
		handleBjornify($familiar[Grinning Turtle]);
		if(considerGrimstoneGolem(true))
		{
			handleBjornify($familiar[Grimstone Golem]);
		}

		set_property("choiceAdventure785", "1");
		autoAdv(1, $location[An Overgrown Shrine (Northeast)]);
		loopHandlerDelayAll();
		if(contains_text(get_property("lastEncounter"), "Air Apparent"))
		{
			set_property("auto_hiddenzones", "3");
			set_property("choiceAdventure785", 6);
		}
		return true;
	}

	if(get_property("auto_hiddenzones") == "3")
	{
		if(internalQuestStatus("questL11Doctor") >= 0)
		{
			set_property("auto_hiddenzones", "4");
			return true;
		}
		autoForceEquip($item[Antique Machete]);

		if(($familiar[Unconscious Collective].drops_today < 1) && auto_have_familiar($familiar[Unconscious Collective]))
		{
			handleFamiliar($familiar[Unconscious Collective]);
		}
		else
		{
			handleFamiliar($familiar[Fist Turkey]);
		}
		handleBjornify($familiar[Grinning Turtle]);
		if(considerGrimstoneGolem(true))
		{
			handleBjornify($familiar[Grimstone Golem]);
		}

		set_property("choiceAdventure783", "1");
		autoAdv(1, $location[An Overgrown Shrine (Southwest)]);
		loopHandlerDelayAll();
		if(contains_text(get_property("lastEncounter"), "Water You Dune"))
		{
			set_property("auto_hiddenzones", "4");
			set_property("choiceAdventure783", 6);
		}
		return true;
	}

	if(get_property("auto_hiddenzones") == "4")
	{
		if(internalQuestStatus("questL11Spare") >= 0)
		{
			set_property("auto_hiddenzones", "5");
			return true;
		}
		autoForceEquip($item[Antique Machete]);

		if(($familiar[Unconscious Collective].drops_today < 1) && auto_have_familiar($familiar[Unconscious Collective]))
		{
			handleFamiliar($familiar[Unconscious Collective]);
		}
		else
		{
			handleFamiliar($familiar[Fist Turkey]);
		}
		handleBjornify($familiar[Grinning Turtle]);
		if(considerGrimstoneGolem(true))
		{
			handleBjornify($familiar[Grimstone Golem]);
		}

		set_property("choiceAdventure787", "1");
		autoAdv(1, $location[An Overgrown Shrine (Southeast)]);
		loopHandlerDelayAll();
		if(contains_text(get_property("lastEncounter"), "Fire When Ready"))
		{
			set_property("auto_hiddenzones", "5");
			set_property("choiceAdventure787", 6);
		}
		return true;
	}

	if(get_property("auto_hiddenzones") == "5")
	{
		autoForceEquip($item[Antique Machete]);

		handleFamiliar($familiar[Fist Turkey]);
		handleBjornify($familiar[Grinning Turtle]);
		if(considerGrimstoneGolem(true))
		{
			handleBjornify($familiar[Grimstone Golem]);
		}
		autoAdv(1, $location[A Massive Ziggurat]);
		if(contains_text(get_property("lastEncounter"), "Legend of the Temple in the Hidden City"))
		{
			set_property("choiceAdventure791", "1");
			set_property("choiceAdventure781", "2");
			set_property("choiceAdventure785", "2");
			set_property("choiceAdventure783", "2");
			set_property("choiceAdventure787", "2");
			set_property("auto_hiddenzones", "finished");
			handleFamiliar("item");
			handleBjornify($familiar[El Vibrato Megadrone]);
		}
		if(contains_text(get_property("lastEncounter"), "Temple of the Legend in the Hidden City"))
		{
			set_property("choiceAdventure791", "1");
			set_property("choiceAdventure781", "2");
			set_property("choiceAdventure785", "2");
			set_property("choiceAdventure783", "2");
			set_property("choiceAdventure787", "2");
			set_property("auto_hiddenzones", "finished");
		}
		return true;
	}
	return false;
}

boolean L11_wishForBaaBaaBuran()
{
	if(!get_property("auto_useWishes").to_boolean() && canGenieCombat())
	{
		auto_log_warning("Skipping wishing for Baa'baa'bu'ran because auto_useWishes=false", "red");
	}
	if (get_property("auto_useWishes").to_boolean() && canGenieCombat())
	{
		auto_log_info("I'm sorry we don't already have stone wool. You might even say I'm sheepish. Sheep wish.", "blue");
		handleFamiliar("item");
		if((numeric_modifier("item drop") >= 100))
		{
			if (!makeGenieCombat($monster[Baa\'baa\'bu\'ran]) || item_amount($item[Stone Wool]) == 0)
			{
				auto_log_warning("Wishing for stone wool failed.", "red");
				return false;
			}
			return true;
		}
		else
		{
			auto_log_warning("Never mind, we couldn't get a mere +100% item for the Baa'baa'bu'ran wish.", "red");
		}
	}
	return false;
}

boolean L11_unlockHiddenCity()
{
	if(my_level() < 11)
	{
		return false;
	}
	if(my_adventures() <= 3)
	{
		return false;
	}
	// Either we have the nostril of the serpent or were lucky and rolled Pikachu
	if(get_property("auto_hiddenunlock") != "nose" && get_property("questL11Worship") != "step2")
	{
		return false;
	}
	if(get_property("auto_mcmuffin") != "start")
	{
		return false;
	}

	boolean useStoneWool = true;

	if (auto_my_path() == "G-Lover" || in_tcrs())
	{
		if(my_adventures() <= 3)
		{
			return false;
		}
		useStoneWool = false;
		backupSetting("choiceAdventure581", 1);
		backupSetting("choiceAdventure579", 3);
	}

	auto_log_info("Searching for the Hidden City", "blue");
	if(useStoneWool)
	{
		if((item_amount($item[Stone Wool]) == 0) && (have_effect($effect[Stone-Faced]) == 0))
		{
			L11_wishForBaaBaaBuran();
			pullXWhenHaveY($item[Stone Wool], 1, 0);
		}
		buffMaintain($effect[Stone-Faced], 0, 1, 1);
		if(have_effect($effect[Stone-Faced]) == 0)
		{
			abort("We do not smell like Stone nor have the face of one. We currently donut farm Stone Wool. Please get some");
		}
	}

	boolean bypassResult = autoAdvBypass(280);

	if (auto_my_path() == "G-Lover" || in_tcrs())
	{
		if(get_property("lastEncounter") != "The Hidden Heart of the Hidden Temple")
		{
			restoreSetting("choiceAdventure579");
			restoreSetting("choiceAdventure581");
			return true;
		}
	}
	else
	{
		if(bypassResult)
		{
			auto_log_warning("Wandering monster interrupted our attempt at the Hidden City", "red");
			return true;
		}
		if(get_property("lastEncounter") != "Fitting In")
		{
			abort("We donut fit in. You are not a munchkin or your donut is invalid. Failed getting the correct adventure at the Hidden Temple. Exit adventure and restart.");
		}
	}

	if(get_property("lastEncounter") == "Fitting In")
	{
		visit_url("choice.php?whichchoice=582&option=2&pwd");
	}

	visit_url("choice.php?whichchoice=580&option=2&pwd");
	visit_url("choice.php?whichchoice=584&option=4&pwd");
	visit_url("choice.php?whichchoice=580&option=1&pwd");
	visit_url("choice.php?whichchoice=123&option=2&pwd");
	visit_url("choice.php");
	cli_execute("dvorak");
	visit_url("choice.php?whichchoice=125&option=3&pwd");
	auto_log_info("Hidden Temple Unlocked");
	set_property("auto_hiddenunlock", "finished");

	restoreSetting("choiceAdventure579");
	restoreSetting("choiceAdventure581");
	return true;
}


boolean L11_nostrilOfTheSerpent()
{
	if(get_property("questL11Worship") != "step1")
	{
		return false;
	}
#	if(get_property("lastTempleUnlock").to_int() != my_ascensions())
#	{
#		return false;
#	}
	if(get_property("auto_mcmuffin") != "start")
	{
		return false;
	}
	if(item_amount($item[The Nostril of the Serpent]) != 0)
	{
		return false;
	}
	if(get_property("auto_hiddenunlock") != "")
	{
		return false;
	}

	auto_log_info("Must get a snake nose.", "blue");
	boolean useStoneWool = true;

	if (auto_my_path() == "G-Lover" || in_tcrs())
	{
		if(my_adventures() <= 3)
		{
			return false;
		}
		useStoneWool = false;
		backupSetting("choiceAdventure581", 1);
	}

	if(useStoneWool)
	{
		if((item_amount($item[Stone Wool]) == 0) && (have_effect($effect[Stone-Faced]) == 0))
		{
			L11_wishForBaaBaaBuran();
			pullXWhenHaveY($item[Stone Wool], 1, 0);
		}
		buffMaintain($effect[Stone-Faced], 0, 1, 1);
		if(have_effect($effect[Stone-Faced]) == 0)
		{
			abort("We are not Stone-Faced. Please get a stone wool and run me again.");
		}
	}

	set_property("choiceAdventure582", "1");
	set_property("choiceAdventure579", "2");
	if (auto_my_path() == "G-Lover" || in_tcrs())
	{
		if(!autoAdvBypass(280))
		{
			if(get_property("lastEncounter") == "The Hidden Heart of the Hidden Temple")
			{
				string page = visit_url("main.php");
				if(contains_text(page, "decorated with that little lightning"))
				{
					visit_url("choice.php?whichchoice=580&option=1&pwd");
					visit_url("choice.php?whichchoice=123&option=2&pwd");
					visit_url("choice.php");
					cli_execute("dvorak");
					visit_url("choice.php?whichchoice=125&option=3&pwd");
					auto_log_info("Hidden Temple Unlocked");
					set_property("auto_hiddenunlock", "finished");
				}
				else
				{
					visit_url("choice.php?whichchoice=580&option=2&pwd");
					visit_url("choice.php?whichchoice=583&option=1&pwd");
				}
			}
		}
	}
	else
	{
		autoAdv(1, $location[The Hidden Temple]);
	}

	if(get_property("lastAdventure") == "Such Great Heights")
	{
		cli_execute("refresh inv");
	}
	if(item_amount($item[The Nostril of the Serpent]) == 1)
	{
		set_property("auto_hiddenunlock", "nose");
		set_property("choiceAdventure579", "0");
	}
	restoreSetting("choiceAdventure581");
	return true;
}

boolean LX_spookyBedroomCombat()
{
	set_property("auto_disableAdventureHandling", true);

	autoAdv(1, $location[The Haunted Bedroom]);
	if(contains_text(visit_url("main.php"), "choice.php"))
	{
		auto_log_info("Bedroom choice adventure get!", "green");
		autoAdv(1, $location[The Haunted Bedroom]);
	}
	else if(contains_text(visit_url("main.php"), "Combat"))
	{
		auto_log_info("Bedroom post-combat super combat get!", "green");
		autoAdv(1, $location[The Haunted Bedroom]);
	}
	set_property("auto_disableAdventureHandling", false);
	return false;
}

boolean LX_spookyravenSecond()
{
	if((get_property("auto_spookyravensecond") != "") || (get_property("lastSecondFloorUnlock").to_int() < my_ascensions()))
	{
		return false;
	}

	if(my_level() >= 7)
	{
		if((get_property("auto_beatenUpCount").to_int() > 7) && (get_property("auto_crypt") != "finished"))
		{
			return false;
		}
	}

	if(internalQuestStatus("questM21Dance") < 1)
	{
		auto_log_warning("Invalid questM21Dance detected. Trying to override", "red");
		set_property("questM21Dance", "step1");
	}

	if((item_amount($item[Lady Spookyraven\'s Powder Puff]) == 1) && (item_amount($item[Lady Spookyraven\'s Dancing Shoes]) == 1) && (item_amount($item[Lady Spookyraven\'s Finest Gown]) == 1))
	{
		auto_log_info("Finished Spookyraven, just dancing with the lady.", "blue");
		visit_url("place.php?whichplace=manor2&action=manor2_ladys");
		visit_url("place.php?whichplace=manor2&action=manor2_ladys");
		set_property("auto_ballroomopen", "open");
		autoAdv(1, $location[The Haunted Ballroom]);
		#
		#	Is it possible that some other adventure can interrupt us here? If so, we will need to fix that.
		#
		if(contains_text(get_property("lastEncounter"), "Lights Out in the Ballroom"))
		{
			autoAdv(1, $location[The Haunted Ballroom]);
		}
		set_property("choiceAdventure106", "2");
		if($classes[Avatar of Boris, Ed] contains my_class())
		{
			set_property("choiceAdventure106", "3");
		}
		if(auto_my_path() == "Nuclear Autumn")
		{
			set_property("choiceAdventure106", "3");
		}
		return true;
	}

	if(considerGrimstoneGolem(true))
	{
		handleBjornify($familiar[Grimstone Golem]);
	}

	//Convert Spookyraven Spectacles to a toggle
	boolean needSpectacles = (item_amount($item[Lord Spookyraven\'s Spectacles]) == 0);
	boolean needCamera = (item_amount($item[disposable instant camera]) == 0) && !get_property("auto_palindome").to_boolean();
	if(my_class() == $class[Avatar of Boris])
	{
		needSpectacles = false;
	}
	if(auto_my_path() == "Way of the Surprising Fist")
	{
		needSpectacles = false;
	}
	if((auto_my_path() == "Nuclear Autumn") && in_hardcore())
	{
		needSpectacles = false;
	}
	if(needSpectacles)
	{
		set_property("choiceAdventure878", "3");
	}
	else
	{
		if(needCamera)
		{
			set_property("choiceAdventure878", "4");
		}
		else
		{
			set_property("choiceAdventure878", "2");
		}
	}

	set_property("choiceAdventure877", "1");
	if((get_property("auto_ballroomopen") == "open") || (get_property("questM21Dance") == "finished") || (get_property("questM21Dance") == "step3"))
	{
		if(needSpectacles)
		{
			auto_log_info("Need Spectacles, damn it.", "blue");
			LX_spookyBedroomCombat();
			auto_log_info("Finished 1 Spookyraven Bedroom Spectacle Sequence", "blue");
		}
		else if(needCamera)
		{
			auto_log_info("Need Disposable Instant Camera, damn it.", "blue");
			LX_spookyBedroomCombat();
			auto_log_info("Finished 1 Spookyraven Bedroom Disposable Instant Camera Sequence", "blue");
		}
		else
		{
			set_property("auto_spookyravensecond", "finished");
		}
		return true;
	}
	else if(get_property("questM21Dance") != "finished")
	{
		if((item_amount($item[Lady Spookyraven\'s Finest Gown]) == 0) && !contains_text(get_counters("Fortune Cookie", 0, 10), "Fortune Cookie"))
		{
			auto_log_info("Spookyraven: Bedroom, rummaging through nightstands looking for naughty meatbag trinkets.", "blue");
			LX_spookyBedroomCombat();
			auto_log_info("Finished 1 Spookyraven Bedroom Sequence", "blue");
			return true;
		}
		if(item_amount($item[Lady Spookyraven\'s Dancing Shoes]) == 0)
		{
			set_property("louvreGoal", "7");
			set_property("louvreDesiredGoal", "7");
			auto_log_info("Spookyraven: Gallery", "blue");

			auto_sourceTerminalEducate($skill[Extract], $skill[Portscan]);

			autoAdv(1, $location[The Haunted Gallery]);
			return true;
		}
		if(item_amount($item[Lady Spookyraven\'s Powder Puff]) == 0)
		{
			if((my_daycount() == 1) && (get_property("_hipsterAdv").to_int() < 7) && is_unrestricted($familiar[Artistic Goth Kid]) && auto_have_familiar($familiar[Artistic Goth Kid]))
			{
				handleFamiliar($familiar[Artistic Goth Kid]);
			}
			auto_log_info("Spookyraven: Bathroom", "blue");
			set_property("choiceAdventure892", "1");

			auto_sourceTerminalEducate($skill[Extract], $skill[Portscan]);

			auto_forceNextNoncombat();
			autoAdv(1, $location[The Haunted Bathroom]);

			handleFamiliar("item");
			return true;
		}
	}
	return false;
}

boolean L11_mauriceSpookyraven()
{
	if(get_property("lastSecondFloorUnlock").to_int() < my_ascensions())
	{
		return false;
	}
	if(get_property("auto_mcmuffin") != "start")
	{
		return false;
	}
	if(get_property("auto_ballroom") != "")
	{
		return false;
	}

	if(L11_ed_mauriceSpookyraven())
	{
		return true;
	}

	if(item_amount($item[2286]) > 0)
	{
		set_property("auto_ballroom", "finished");
		return true;
	}

	if(get_property("auto_ballroomflat") == "")
	{
		auto_log_info("Searching for the basement of Spookyraven", "blue");
		if(!cangroundHog($location[The Haunted Ballroom]))
		{
			return false;
		}
		set_property("choiceAdventure90", "3");

		if((my_mp() > 60) || considerGrimstoneGolem(true))
		{
			handleBjornify($familiar[Grimstone Golem]);
		}
		buffMaintain($effect[Snow Shoes], 0, 1, 1);

		handleFamiliar("initSuggest");
		set_property("choiceAdventure106", "2");
		if($classes[Avatar of Boris, Ed] contains my_class())
		{
			set_property("choiceAdventure106", "3");
		}
		if(auto_my_path() == "Nuclear Autumn")
		{
			set_property("choiceAdventure106", "3");
		}

		if(!autoAdv(1, $location[The Haunted Ballroom]))
		{
			visit_url("place.php?whichplace=manor2");
			auto_log_warning("If 'That Area is not available', mafia isn't recognizing it without a visit to manor2, not sure why.", "red");
		}
		handleFamiliar("item");
		if(contains_text(get_property("lastEncounter"), "We\'ll All Be Flat"))
		{
			set_property("auto_ballroomflat", "finished");
		}
		return true;
	}
	if(item_amount($item[recipe: mortar-dissolving solution]) == 0)
	{
		if(possessEquipment($item[Lord Spookyraven\'s Spectacles]))
		{
			equip($slot[acc3], $item[Lord Spookyraven\'s Spectacles]);
		}
		visit_url("place.php?whichplace=manor4&action=manor4_chamberwall");
		use(1, $item[recipe: mortar-dissolving solution]);

		if(!useMaximizeToEquip())
		{
			autoEquip($slot[acc3], $item[numberwang]);
		}

		#Cellar, laundry room Lights out ignore
		set_property("choiceAdventure901", "2");
		set_property("choiceAdventure891", "1");
	}

	if((get_property("auto_winebomb") == "finished") || get_property("auto_masonryWall").to_boolean() || (internalQuestStatus("questL11Manor") >= 3))
	{
		auto_log_info("Down with the tyrant of Spookyraven!", "blue");
		acquireHP();
		buffMaintain($effect[Astral Shell], 10, 1, 1);
		buffMaintain($effect[Elemental Saucesphere], 10, 1, 1);


		# The autoAdvBypass case is probably suitable for Ed but we'd need to verify it.
		if (isActuallyEd())
		{
			visit_url("place.php?whichplace=manor4&action=manor4_chamberboss");
		}
		else
		{
			autoAdv($location[Summoning Chamber]);
		}

		if(internalQuestStatus("questL11Manor") >= 4)
		{
			set_property("auto_ballroom", "finished");
		}
		return true;
	}

	if(!get_property("auto_haveoven").to_boolean())
	{
		ovenHandle();
	}

	if(item_amount($item[wine bomb]) == 1)
	{
		set_property("auto_winebomb", "finished");
		visit_url("place.php?whichplace=manor4&action=manor4_chamberwall");
		return true;
	}

	if(!possessEquipment($item[Lord Spookyraven\'s Spectacles]) || (my_class() == $class[Avatar of Boris]) || (auto_my_path() == "Way of the Surprising Fist") || ((auto_my_path() == "Nuclear Autumn") && !get_property("auto_haveoven").to_boolean()))
	{
		auto_log_warning("Alternate fulminate pathway... how sad :(", "red");
		# I suppose we can let anyone in without the Spectacles.
		if(item_amount($item[Loosening Powder]) == 0)
		{
			autoAdv($location[The Haunted Kitchen]);
			return true;
		}
		if(item_amount($item[Powdered Castoreum]) == 0)
		{
			autoAdv($location[The Haunted Conservatory]);
			return true;
		}
		if(item_amount($item[Drain Dissolver]) == 0)
		{
			if(get_property("auto_towelChoice") == "")
			{
				set_property("auto_towelChoice", get_property("choiceAdventure882"));
				set_property("choiceAdventure882", 2);
			}
			autoAdv($location[The Haunted Bathroom]);
			if(get_property("auto_towelChoice") != "")
			{
				set_property("choiceAdventure882", get_property("auto_towelChoice"));
				set_property("auto_towelChoice", "");
			}
			return true;
		}
		if(item_amount($item[Triple-Distilled Turpentine]) == 0)
		{
			autoAdv($location[The Haunted Gallery]);
			return true;
		}
		if(item_amount($item[Detartrated Anhydrous Sublicalc]) == 0)
		{
			autoAdv($location[The Haunted Laboratory]);
			return true;
		}
		if(item_amount($item[Triatomaceous Dust]) == 0)
		{
			autoAdv($location[The Haunted Storage Room]);
			return true;
		}

		visit_url("place.php?whichplace=manor4&action=manor4_chamberwall");
		set_property("auto_masonryWall", true);
		return true;
	}

	if((item_amount($item[blasting soda]) == 1) && (item_amount($item[bottle of Chateau de Vinegar]) == 1))
	{
		auto_log_info("Time to cook up something explosive! Science fair unstable fulminate time!", "green");
		ovenHandle();
		autoCraft("cook", 1, $item[bottle of Chateau de Vinegar], $item[blasting soda]);
		set_property("auto_winebomb", "partial");
		if(item_amount($item[Unstable Fulminate]) == 0)
		{
			auto_log_warning("We could not make an Unstable Fulminate but we think we have an oven. Do this manually and resume?", "red");
			auto_log_warning("Speculating that get_campground() was incorrect at ascension start...", "red");
			// This issue is valid as of mafia r16799
			set_property("auto_haveoven", false);
			ovenHandle();
			autoCraft("cook", 1, $item[bottle of Chateau de Vinegar], $item[blasting soda]);
			if(item_amount($item[Unstable Fulminate]) == 0)
			{
				if(auto_my_path() == "Nuclear Autumn")
				{
					auto_log_warning("Could not make an Unstable Fulminate, assuming we have no oven for realz...", "red");
					return true;
				}
				else
				{
					abort("Could not make an Unstable Fulminate, make it manually and resume");
				}
			}
		}
	}

	if(get_property("spookyravenRecipeUsed") != "with_glasses")
	{
		abort("Did not read Mortar Recipe with the Spookyraven glasses. We can't proceed.");
	}

	if(possessEquipment($item[Unstable Fulminate]))
	{
		set_property("auto_winebomb", "partial");
	}

	if((item_amount($item[bottle of Chateau de Vinegar]) == 0) && (get_property("auto_winebomb") == ""))
	{
		auto_log_info("Searching for vinegar", "blue");
		if(considerGrimstoneGolem(true))
		{
			handleBjornify($familiar[Grimstone Golem]);
		}
		buffMaintain($effect[Joyful Resolve], 0, 1, 1);
		if(!bat_wantHowl($location[The Haunted Wine Cellar]))
		{
			bat_formBats();
		}
		autoAdv(1, $location[The Haunted Wine Cellar]);
		return true;
	}
	if((item_amount($item[blasting soda]) == 0) && (get_property("auto_winebomb") == ""))
	{
		auto_log_info("Searching for baking soda, I mean, blasting pop.", "blue");
		if(considerGrimstoneGolem(true))
		{
			handleBjornify($familiar[Grimstone Golem]);
		}
		if(!bat_wantHowl($location[The Haunted Wine Cellar]))
		{
			bat_formBats();
		}
		autoAdv(1, $location[The Haunted Laundry Room]);
		return true;
	}

	if(get_property("auto_winebomb") == "partial")
	{
		if(item_amount($item[unstable fulminate]) > 0)
		{
			if(weapon_hands(equipped_item($slot[weapon])) > 1)
			{
				autoEquip($slot[weapon], $item[none]);
			}
		}
		auto_log_info("Now we mix and heat it up.", "blue");

		if((auto_my_path() == "Picky") && (item_amount($item[gumshoes]) > 0))
		{
			auto_change_mcd(0);
			autoEquip($slot[acc2], $item[gumshoes]);
		}

		if(!autoEquip($item[Unstable Fulminate]))
		{
			abort("Unstable Fulminate was not equipped. Please report this and include the following: Equipped items and if you have or don't have an Unstable Fulminate. For now, get the wine bomb manually, and run again.");
		}

		if(monster_level_adjustment() < 57)
		{
			buffMaintain($effect[Sweetbreads Flamb&eacute;], 0, 1, 1);
		}

		auto_MaxMLToCap(auto_convertDesiredML(82), true);

		addToMaximize("500ml " + auto_convertDesiredML(82) + "max");

		autoAdv(1, $location[The Haunted Boiler Room]);

		if(item_amount($item[wine bomb]) == 1)
		{
			set_property("auto_winebomb", "finished");
			visit_url("place.php?whichplace=manor4&action=manor4_chamberwall");
			set_property("auto_masonryWall", true);
		}
		return true;
	}

	return false;
}

boolean L13_sorceressDoor()
{
	if(contains_text(visit_url("place.php?whichplace=nstower"), "ns_05_monster1"))
	{
		set_property("auto_sorceress", "tower");
		return false;
	}
	if(get_property("auto_sorceress") != "door")
	{
		return false;
	}

	if(internalQuestStatus("questL13Final") >= 6)
	{
		auto_log_warning("Should already be past the tower door but did not see the First wall.", "red");
		set_property("auto_sorceress", "tower");
		return false;
	}

	if((item_amount($item[Richard\'s Star Key]) == 0) && (item_amount($item[Star Chart]) == 0))
	{
		if(my_rain() < 50)
		{
			pullXWhenHaveY($item[Star Chart], 1, 0);
		}
	}

	if((item_amount($item[Richard\'s Star Key]) == 0) && (item_amount($item[Star Chart]) > 0) && (item_amount($item[star]) >= 8) && (item_amount($item[line]) >= 7))
	{
		visit_url("shop.php?pwd&whichshop=starchart&action=buyitem&quantity=1&whichrow=141");
		if(item_amount($item[Richard\'s Star Key]) == 0)
		{
			cli_execute("make richard's star key");
		}
	}

	if((item_amount($item[white pixel]) >= 30) && (item_amount($item[Digital Key]) == 0) && !in_koe())
	{
		cli_execute("make digital key");
		set_property("auto_crackpotjar", "finished");
	}

	string page = visit_url("place.php?whichplace=nstower_door");
	if(contains_text(page, "ns_lock6"))
	{
		if(item_amount($item[Skeleton Key]) == 0)
		{
			cli_execute("make skeleton key");
		}
		if(item_amount($item[Skeleton Key]) == 0)
		{
			abort("Need Skeleton Key for the Sorceress door :(");
		}
		visit_url("place.php?whichplace=nstower_door&action=ns_lock6");
	}

	if(towerKeyCount() < 3)
	{
		while(useMalware());
		if(towerKeyCount() < 3)
		{
			abort("Do not have enough hero keys");
		}
	}

	if(contains_text(page, "ns_lock1"))
	{
		if(item_amount($item[Boris\'s Key]) == 0)
		{
			if(in_koe() && item_amount($item[fat loot token]) > 0) {
				visit_url("shop.php?whichshop=exploathing&action=buyitem&quantity=1&whichrow=1093&pwd", true);
			}
			else {
				cli_execute("make Boris's Key");
			}
		}
		if(item_amount($item[Boris\'s Key]) == 0)
		{
			abort("Need Boris's Key for the Sorceress door :(");
		}
		visit_url("place.php?whichplace=nstower_door&action=ns_lock1");
	}
	if(contains_text(page, "ns_lock2"))
	{
		if(item_amount($item[Jarlsberg\'s Key]) == 0)
		{
			if(in_koe() && item_amount($item[fat loot token]) > 0) {
				visit_url("shop.php?whichshop=exploathing&action=buyitem&quantity=1&whichrow=1094&pwd", true);
			}
			else {
				cli_execute("make Jarlsberg's Key");
			}
		}
		if(item_amount($item[Jarlsberg\'s Key]) == 0)
		{
			abort("Need Jarlsberg's Key for the Sorceress door :(");
		}
		visit_url("place.php?whichplace=nstower_door&action=ns_lock2");
	}
	if(contains_text(page, "ns_lock3"))
	{
		if(item_amount($item[Sneaky Pete\'s Key]) == 0)
		{
			if(in_koe() && item_amount($item[fat loot token]) > 0) {
				visit_url("shop.php?whichshop=exploathing&action=buyitem&quantity=1&whichrow=1095&pwd", true);
			}
			else {
				cli_execute("make Sneaky Pete's Key");
			}
		}
		if(item_amount($item[Sneaky Pete\'s Key]) == 0)
		{
			abort("Need Sneaky Pete's Key for the Sorceress door :(");
		}
		visit_url("place.php?whichplace=nstower_door&action=ns_lock3");
	}

	if(contains_text(page, "ns_lock4"))
	{
		if(item_amount($item[Richard\'s Star Key]) == 0)
		{
			boolean temp = cli_execute("make richard's star key");
		}
		if(item_amount($item[Richard\'s Star Key]) == 0)
		{
			abort("Need Richard's Star Key for the Sorceress door :(");
		}
		visit_url("place.php?whichplace=nstower_door&action=ns_lock4");
	}

	if(contains_text(page, "ns_lock5"))
	{
		if(item_amount($item[Digital Key]) == 0)
		{
			if(item_amount($item[white pixel]) < 30)
			{
				int pulls_needed = 30 - item_amount($item[white pixel]);
				// Save 5 pulls for later, just in case.
				if(pulls_remaining() - pulls_needed >= 5)
				{
					pullXWhenHaveY($item[white pixel], pulls_needed, item_amount($item[white pixel]));
				}
			}
			if(in_koe() && item_amount($item[white pixel]) >= 30) {
				visit_url("shop.php?whichshop=exploathing&action=buyitem&quantity=1&whichrow=1090&pwd", true);
			}
			else {
				cli_execute("make digital key");
			}
		}
		if(item_amount($item[Digital Key]) == 0)
		{
			abort("Need Digital Key for the Sorceress door :(");
		}
		visit_url("place.php?whichplace=nstower_door&action=ns_lock5");
	}

	visit_url("place.php?whichplace=nstower_door&action=ns_doorknob");
	return true;
}


boolean L11_unlockEd()
{
	if(get_property("auto_mcmuffin") != "pyramid")
	{
		return false;
	}

	if (isActuallyEd())
	{
		set_property("auto_mcmuffin", "finished");
		return true;
	}

	if(get_property("auto_tavern") != "finished")
	{
		auto_log_warning("Uh oh, didn\'t do the tavern and we are at the pyramid....", "red");

		// Forcing Tavern.
		set_property("auto_forceTavern", true);
		return false;
	}

	auto_log_info("In the pyramid (W:" + item_amount($item[crumbling wooden wheel]) + ") (R:" + item_amount($item[tomb ratchet]) + ") (U:" + get_property("controlRoomUnlock") + ")", "blue");

	if(!get_property("middleChamberUnlock").to_boolean())
	{
		autoAdv(1, $location[The Upper Chamber]);
		return true;
	}

	int total = item_amount($item[Crumbling Wooden Wheel]);
	total = total + item_amount($item[Tomb Ratchet]);

	if((total >= 10) && (my_adventures() >= 4) && get_property("controlRoomUnlock").to_boolean())
	{
		visit_url("place.php?whichplace=pyramid&action=pyramid_control");
		int x = 0;
		while(x < 10)
		{
			if(item_amount($item[crumbling wooden wheel]) > 0)
			{
				visit_url("choice.php?pwd&whichchoice=929&option=1&choiceform1=Use+a+wheel+on+the+peg&pwd="+my_hash());
			}
			else
			{
				visit_url("choice.php?whichchoice=929&option=2&pwd");
			}
			x = x + 1;
			if((x == 3) || (x == 7) || (x == 10))
			{
				visit_url("choice.php?pwd&whichchoice=929&option=5&choiceform5=Head+down+to+the+Lower+Chambers+%281%29&pwd="+my_hash());
			}
			if((x == 3) || (x == 7))
			{
				visit_url("place.php?whichplace=pyramid&action=pyramid_control");
			}
		}
		set_property("auto_mcmuffin", "ed");
		return true;
	}
	if(total < 10)
	{
		buffMaintain($effect[Joyful Resolve], 0, 1, 1);
		buffMaintain($effect[One Very Clear Eye], 0, 1, 1);
		buffMaintain($effect[Fishy Whiskers], 0, 1, 1);
		buffMaintain($effect[Human-Fish Hybrid], 0, 1, 1);
		buffMaintain($effect[Human-Human Hybrid], 0, 1, 1);
		buffMaintain($effect[Unusual Perspective], 0, 1, 1);
		if(!bat_wantHowl($location[The Middle Chamber]))
		{
			bat_formBats();
		}
		if(get_property("auto_dickstab").to_boolean())
		{
			buffMaintain($effect[Wet and Greedy], 0, 1, 1);
			buffMaintain($effect[Frosty], 0, 1, 1);
		}
		if((item_amount($item[possessed sugar cube]) > 0) && (have_effect($effect[Dance of the Sugar Fairy]) == 0))
		{
			cli_execute("make sugar fairy");
			buffMaintain($effect[Dance of the Sugar Fairy], 0, 1, 1);
		}
		if((have_effect($effect[On The Trail]) > 0) && (get_property("olfactedMonster") != $monster[Tomb Rat]))
		{
			if(item_amount($item[soft green echo eyedrop antidote]) > 0)
			{
				uneffect($effect[On The Trail]);
			}
		}
		if(have_effect($effect[items.enh]) == 0)
		{
			auto_sourceTerminalEnhance("items");
		}
		handleFamiliar("item");
	}

	if(get_property("controlRoomUnlock").to_boolean())
	{
		if(!contains_text(get_property("auto_banishes"), $monster[Tomb Servant]) && !contains_text(get_property("auto_banishes"), $monster[Tomb Asp]) && (get_property("olfactedMonster") != $monster[Tomb Rat]))
		{
			autoAdv(1, $location[The Upper Chamber]);
			return true;
		}
	}

	autoAdv(1, $location[The Middle Chamber]);
	return true;
}

boolean L11_unlockPyramid()
{
	int pyramidLevel = 11;
	if(get_property("auto_dickStab").to_boolean())
	{
		pyramidLevel = 12;
	}

	if(my_level() < pyramidLevel)
	{
		return false;
	}
	if (isActuallyEd())
	{
		return false;
	}
	if(get_property("auto_mcmuffin") != "start")
	{
		return false;
	}

	if(get_property("questL11Pyramid") == "started")
	{
		set_property("auto_mcmuffin", "pyramid");
		return true;
	}

	if((item_amount($item[[2325]Staff Of Ed]) > 0) || ((item_amount($item[[2180]Ancient Amulet]) > 0) && (item_amount($item[[2268]Staff Of Fats]) > 0) && (item_amount($item[[2286]Eye Of Ed]) > 0)))
	{
		auto_log_info("Reveal the pyramid", "blue");
		if(item_amount($item[[2325]Staff Of Ed]) == 0)
		{
			if((item_amount($item[[2180]Ancient Amulet]) > 0) && (item_amount($item[[2286]Eye Of Ed]) > 0))
			{
				autoCraft("combine", 1, $item[[2180]Ancient Amulet], $item[[2286]Eye Of Ed]);
			}
			if((item_amount($item[Headpiece of the Staff of Ed]) > 0) && (item_amount($item[[2268]Staff Of Fats]) > 0))
			{
				autoCraft("combine", 1, $item[headpiece of the staff of ed], $item[[2268]Staff Of Fats]);
			}
		}
		if(item_amount($item[[2325]Staff Of Ed]) == 0)
		{
			abort("Failed making Staff of Ed (2325) via CLI. Please do it manually and rerun.");
		}

		if (in_koe())
		{
			visit_url("place.php?whichplace=exploathing_beach&action=expl_pyramidpre");
			cli_execute("refresh quests");
		}
		else
		{
			visit_url("place.php?whichplace=desertbeach&action=db_pyramid1");
		}

		if (internalQuestStatus("questL11Pyramid") < 0)
		{
			auto_log_info("No burning Ed's model now!", "blue");
			if((auto_my_path() == "One Crazy Random Summer") && (get_property("desertExploration").to_int() == 100))
			{
				auto_log_warning("We might have had an issue due to OCRS and the Desert, please finish the desert (and only the desert) manually and run again.", "red");
				string page = visit_url("place.php?whichplace=desertbeach");
				matcher desert_matcher = create_matcher("title=\"[(](\\d+)% explored[)]\"", page);
				if(desert_matcher.find())
				{
					int found = to_int(desert_matcher.group(1));
					if(found < 100)
					{
						set_property("desertExploration", found);
					}
				}

				if(get_property("desertExploration").to_int() == 100)
				{
					abort("Tried to open the Pyramid but could not - exploration at 100?. Something went wrong :(");
				}
				else
				{
					auto_log_info("Incorrectly had exploration value of 100 however, this was correctable. Trying to resume.", "blue");
					return false;
				}
			}
			if(my_turncount() == get_property("auto_skipDesert").to_int())
			{
				auto_log_warning("Did not have an Arid Desert Item and the Pyramid is next. Must backtrack and recover", "red");
				if((my_adventures() >= 3) && (my_meat() >= 500))
				{
					doVacation();
					if(item_amount($item[Shore Inc. Ship Trip Scrip]) > 0)
					{
						cli_execute("make UV-Resistant Compass");
					}
					if(item_amount($item[UV-Resistant Compass]) == 0)
					{
						abort("Could not acquire a UV-Resistant Compass. Failing.");
					}
				}
				else
				{
					abort("Could not backtrack to handle getting a UV-Resistant Compass");
				}
				return true;
			}
			abort("Tried to open the Pyramid but could not. Something went wrong :(");
		}

		set_property("auto_hiddencity", "finished");
		set_property("auto_ballroom", "finished");
		set_property("auto_palindome", "finished");
		set_property("auto_mcmuffin", "pyramid");
		buffMaintain($effect[Snow Shoes], 0, 1, 1);
		autoAdv(1, $location[The Upper Chamber]);
		return true;
	}
	else
	{
		return false;
	}
}

boolean L11_defeatEd()
{
	if(get_property("auto_mcmuffin") != "ed")
	{
		return false;
	}
	if(my_adventures() <= 7)
	{
		return false;
	}

	if(item_amount($item[[2334]Holy MacGuffin]) == 1)
	{
		set_property("auto_mcmuffin", "finished");
		council();
		return true;
	}

	int baseML = monster_level_adjustment();
	if(auto_my_path() == "Heavy Rains")
	{
		baseML = baseML + 60;
	}
	if(baseML > 150)
	{
		foreach s in $slots[acc1, acc2, acc3]
		{
			if(equipped_item(s) == $item[Hand In Glove])
			{
				equip(s, $item[none]);
			}
		}
		uneffect($effect[Ur-kel\'s Aria of Annoyance]);
		if(possessEquipment($item[Beer Helmet]))
		{
			autoEquip($item[beer helmet]);
		}
	}
	if(in_koe())
	{
		retrieve_item(1, $item[low-pressure oxygen tank]);
		autoForceEquip($item[low-pressure oxygen tank]);
	}

	acquireHP();
	auto_log_info("Time to waste all of Ed's Ka Coins :(", "blue");

	set_property("choiceAdventure976", "1");

	int x = 0;
	set_property("auto_disableAdventureHandling", true);
	while(item_amount($item[[2334]Holy MacGuffin]) == 0)
	{
		x = x + 1;
		auto_log_info("Hello Ed #" + x + " give me McMuffin please.", "blue");
		autoAdv(1, $location[The Lower Chambers]);
		if(have_effect($effect[Beaten Up]) > 0 && item_amount($item[[2334]Holy MacGuffin]) == 0)
		{
			set_property("auto_disableAdventureHandling", false);
			abort("Got Beaten Up by Ed the Undying - generally not safe to try to recover.");
		}
		if(x > 10)
		{
			abort("Trying to fight too many Eds, leave the poor dude alone!");
		}
		if(auto_my_path() == "Pocket Familiars" || in_koe())
		{
			cli_execute("refresh inv");
		}
	}
	set_property("auto_disableAdventureHandling", false);

	if(item_amount($item[[2334]Holy MacGuffin]) != 0)
	{
		set_property("auto_mcmuffin", "finished");
		council();
	}
	return true;
}

boolean L12_sonofaFinish()
{
	if(get_property("auto_sonofa") == "finished")
	{
		return false;
	}
	if(item_amount($item[barrel of gunpowder]) < 5)
	{
		return false;
	}
	if(my_level() < 12)
	{
		return false;
	}
#	if(get_property("auto_hippyInstead").to_boolean() && (get_property("fratboysDefeated").to_int() < 64))
#	{
#		return false;
#	}
	if(!haveWarOutfit())
	{
		return false;
	}

	warOutfit(true);
	visit_url("bigisland.php?place=lighthouse&action=pyro&pwd");
	visit_url("bigisland.php?place=lighthouse&action=pyro&pwd");
	set_property("auto_sonofa", "finished");
	return true;
}

boolean L12_gremlinStart()
{
	if(my_level() < 12)
	{
		return false;
	}
	if(get_property("auto_prewar") != "started")
	{
		return false;
	}
	if(get_property("auto_gremlins") != "")
	{
		return false;
	}
	auto_log_info("Gremlin prep", "blue");
	if(get_property("auto_hippyInstead").to_boolean())
	{
		if(!possessEquipment($item[Reinforced Beaded Headband]))
		{
			pullXWhenHaveY($item[Reinforced Beaded Headband], 1, 0);
		}
		if(!possessEquipment($item[Bullet-Proof Corduroys]))
		{
			pullXWhenHaveY($item[Bullet-Proof Corduroys], 1, 0);
		}
		if(!possessEquipment($item[Round Purple Sunglasses]))
		{
			pullXWhenHaveY($item[Round Purple Sunglasses], 1, 0);
		}
	}

	if((!possessEquipment($item[Ouija Board\, Ouija Board])) && (item_amount($item[Lump of Brituminous Coal]) > 0))
	{
		if(!possessEquipment($item[Turtle Totem]))
		{
			acquireGumItem($item[Turtle Totem]);
		}
		autoCraft("smith", 1, $item[lump of Brituminous coal], $item[turtle totem]);
		if(!possessEquipment($item[Turtle Totem]))
		{
			acquireGumItem($item[Turtle Totem]);
		}
	}
	if((item_amount($item[louder than bomb]) == 0) && (item_amount($item[Handful of Smithereens]) > 0) && ((my_meat() > npc_price($item[Ben-Gal&trade; Balm])) && (npc_price($item[Ben-Gal&trade; Balm]) != 0)))
	{
		buyUpTo(1, $item[Ben-Gal&trade; Balm]);
		cli_execute("make louder than bomb");
#		autoCraft("paste", 1, $item[Ben-Gal&trade; Balm], $item[Handful of Smithereens]);
	}
	set_property("auto_gremlins", "start");
	set_property("auto_gremlinBanishes", "");
	return true;
}

boolean L12_gremlins()
{
	if(get_property("auto_prewar") != "started")
	{
		return false;
	}
	if(get_property("auto_gremlins") != "start")
	{
		return false;
	}
	if(my_level() < 12)
	{
		return false;
	}
	if(get_property("sidequestJunkyardCompleted") != "none")
	{
		return false;
	}
	if(get_property("auto_hippyInstead").to_boolean() && (get_property("fratboysDefeated").to_int() < 192))
	{
		return false;
	}
	if(auto_my_path() == "Pocket Familiars")
	{
		return false;
	}
	if(auto_my_path() == "G-Lover")
	{
		int need = 30 - item_amount($item[Doc Galaktik\'s Pungent Unguent]);
		if((need > 0) && (item_amount($item[Molybdenum Pliers]) == 0))
		{
			int meatNeed = need * npc_price($item[Doc Galaktik\'s Pungent Unguent]);
			if(my_meat() < meatNeed)
			{
				return false;
			}
			buyUpTo(30, $item[Doc Galaktik\'s Pungent Unguent]);
		}
	}

	if(0 < have_effect($effect[Curse of the Black Pearl Onion])) {
		uneffect($effect[Curse of the Black Pearl Onion]);
	}

	if(item_amount($item[molybdenum magnet]) == 0)
	{
		abort("We don't have the molybdenum magnet but should... please get it and rerun the script");
	}

	if(auto_my_path() == "Disguises Delimit")
	{
		abort("Do gremlins manually, sorry. Or set auto_gremlins=finished and we will just skip them");
	}

	// Go into the fight with No Familiar Equips since maximizer wants to force an equip
	// this keeps us from accidentally killing gremlins
	addToMaximize("-familiar");

	#Put a different shield in here.
	auto_log_info("Doing them gremlins", "blue");
	if(useMaximizeToEquip())
	{
		addToMaximize("20dr,1da 1000max,3hp,-3ml");
	}
	else
	{
		if(item_amount($item[Ouija Board\, Ouija Board]) > 0)
		{
			equip($item[Ouija Board\, Ouija Board]);
		}
		if(item_amount($item[Reinforced Beaded Headband]) > 0)
		{
			equip($item[Reinforced Beaded Headband]);
		}
		if (item_amount($item[astral shield]) > 0)
		{
			equip($item[astral shield]);
		}
	}
	acquireHP();
	if(!bat_wantHowl($location[over where the old tires are]))
	{
		bat_formMist();
	}
	handleFamiliar("gremlins");
	songboomSetting("dr");
	if(item_amount($item[molybdenum hammer]) == 0)
	{
		autoAdv(1, $location[Next to that barrel with something burning in it], "auto_JunkyardCombatHandler");
		return true;
	}

	if(item_amount($item[molybdenum screwdriver]) == 0)
	{
		autoAdv(1, $location[Out by that rusted-out car], "auto_JunkyardCombatHandler");
		return true;
	}

	if(item_amount($item[molybdenum crescent wrench]) == 0)
	{
		autoAdv(1, $location[over where the old tires are], "auto_JunkyardCombatHandler");
		return true;
	}

	if(item_amount($item[Molybdenum Pliers]) == 0)
	{
		autoAdv(1, $location[near an abandoned refrigerator], "auto_JunkyardCombatHandler");
		return true;
	}
	handleFamiliar("item");
	warOutfit(true);
	visit_url("bigisland.php?action=junkman&pwd");
	set_property("auto_gremlins", "finished");
	return true;
}

boolean L12_sonofaBeach()
{
	if(my_level() < 12)
	{
		return false;
	}
	if(get_property("auto_sonofa") == "finished")
	{
		return false;
	}
	if(get_property("auto_war") == "finished")
	{
		return false;
	}
	if(!get_property("auto_hippyInstead").to_boolean())
	{
		if(get_property("auto_gremlins") != "finished")
		{
			return false;
		}
	}
	#Removing for now, we probably can not delay this at this point
#	if(get_property("_sourceTerminalDigitizeMonster") == $monster[Lobsterfrogman])
#	{
#		return false;
#	}
	if((get_property("fratboysDefeated").to_int() < 64) && get_property("auto_hippyInstead").to_boolean())
	{
		return false;
	}
	if(item_amount($item[barrel of gunpowder]) >= 5)
	{
		return false;
	}

	if(get_property("sidequestLighthouseCompleted") != "none")
	{
		set_property("auto_sonofa", "finished");
		return true;
	}

	if(auto_my_path() == "Pocket Familiars")
	{
		if(contains_text($location[Sonofa Beach].combat_queue, to_string($monster[Lobsterfrogman])))
		{
			if(timeSpinnerCombat($monster[Lobsterfrogman], ""))
			{
				return true;
			}
		}
	}

	if(chateaumantegna_havePainting() && !get_property("chateauMonsterFought").to_boolean() && (get_property("chateauMonster") == $monster[Lobsterfrogman]))
	{
		auto_sourceTerminalEducate($skill[Extract], $skill[Digitize]);
		if(chateaumantegna_usePainting())
		{
			handleFamiliar("item");
			return true;
		}
	}

	if (isActuallyEd() && item_amount($item[Talisman of Horus]) == 0 && have_effect($effect[Taunt of Horus]) == 0)
	{
		return false;
	}

	//Seriously? http://alliancefromhell.com/viewtopic.php?t=1338
	if(item_amount($item[Wool Hat]) == 1)
	{
		pulverizeThing($item[Wool Hat]);
	}
	if(item_amount($item[Goatskin Umbrella]) == 1)
	{
		pulverizeThing($item[Goatskin Umbrella]);
	}

	if(auto_my_path() != "Live. Ascend. Repeat.")
	{
		if(!providePlusCombat(25, true))
		{
			auto_log_warning("Failure in +Combat acquisition or -Combat shrugging (lobsterfrogman), delaying", "red");
			equipBaseline();
			return false;
		}

		if(equipped_item($slot[acc1]) == $item[over-the-shoulder folder holder])
		{
			if((item_amount($item[Ass-Stompers of Violence]) > 0) && (equipped_item($slot[acc1]) != $item[Ass-Stompers of Violence]) && can_equip($item[Ass-Stompers of Violence]))
			{
				equip($slot[acc1], $item[Ass-Stompers of Violence]);
			}
			else
			{
				equip($slot[acc1], $item[bejeweled pledge pin]);
			}
		}
		if(item_amount($item[portable cassette player]) > 0)
		{
			equip($slot[acc2], $item[portable cassette player]);
		}
		if(numeric_modifier("Combat Rate") <= 9.0)
		{
			if(possessEquipment($item[Carpe]))
			{
				equip($slot[Back], $item[Carpe]);
			}
		}
		asdonBuff($effect[Driving Obnoxiously]);

		if(numeric_modifier("Combat Rate") < 0.0)
		{
			auto_log_warning("Something is keeping us from getting a suitable combat rate, we have: " + numeric_modifier("Combat Rate") + " and Lobsterfrogmen.", "red");
			equipBaseline();
			return false;
		}
	}

	if(item_amount($item[barrel of gunpowder]) < 4)
	{
		set_property("auto_doCombatCopy", "yes");
	}

	autoAdv(1, $location[Sonofa Beach]);
	set_property("auto_doCombatCopy", "no");
	handleFamiliar("item");

	if (isActuallyEd() && my_hp() == 0)
	{
		use(1, $item[Linen Bandages]);
	}
	return true;
}

boolean L12_sonofaPrefix()
{
	if(get_property("auto_prewar") != "started")
	{
		return false;
	}
	if(L12_sonofaFinish())
	{
		return true;
	}

	if(my_level() < 12)
	{
		return false;
	}
	if(get_property("auto_sonofa") == "finished")
	{
		return false;
	}
	if(get_property("auto_war") == "finished")
	{
		return false;
	}
	if(in_koe())
	{
		return false;
	}

	if(get_property("_sourceTerminalDigitizeMonster") == $monster[Lobsterfrogman])
	{
		return false;
	}
	if((get_property("fratboysDefeated").to_int() < 64) && get_property("auto_hippyInstead").to_boolean())
	{
		return false;
	}
	if(item_amount($item[barrel of gunpowder]) >= 4 && !auto_voteMonster())
	{
		return false;
	}
	if(item_amount($item[barrel of gunpowder]) >= 5)
	{
		return false;
	}

	if(get_property("sidequestLighthouseCompleted") != "none")
	{
		set_property("auto_sonofa", "finished");
		return true;
	}

	if(chateaumantegna_havePainting() && !get_property("chateauMonsterFought").to_boolean() && (get_property("chateauMonster") == $monster[Lobsterfrogman]))
	{
		auto_sourceTerminalEducate($skill[Extract], $skill[Digitize]);
		if(chateaumantegna_usePainting())
		{
			handleFamiliar("stat");
			return true;
		}
	}

	if(!(auto_get_campground() contains $item[Source Terminal]))
	{
		if(possessEquipment($item[&quot;I voted!&quot; sticker]))
		{
			if(auto_voteMonster() && auto_have_skill($skill[Meteor Lore]) && (get_property("_macrometeoriteUses").to_int() < 10))
			{
				if(item_amount($item[barrel of gunpowder]) < 4)
				{
					set_property("auto_doCombatCopy", "yes");
				}
				set_property("auto_combatDirective", "start;skill macrometeorite");
				auto_voteMonster(false, $location[Sonofa Beach], "");
				set_property("auto_combatDirective", "");
				set_property("auto_doCombatCopy", "no");
				return true;
			}
		}
		return false;
	}

	if (isActuallyEd() && item_amount($item[Talisman of Horus]) == 0 && have_effect($effect[Taunt of Horus]) == 0)
	{
		return false;
	}

	if(in_koe())
	{
		return false;
	}

	//Seriously? http://alliancefromhell.com/viewtopic.php?t=1338
	if(item_amount($item[Wool Hat]) == 1)
	{
		pulverizeThing($item[Wool Hat]);
	}
	if(item_amount($item[Goatskin Umbrella]) == 1)
	{
		pulverizeThing($item[Goatskin Umbrella]);
	}

	if(auto_my_path() != "Live. Ascend. Repeat.")
	{
		if(!providePlusCombat(25))
		{
			auto_log_warning("Failure in +Combat acquisition or -Combat shrugging (lobsterfrogman), delaying", "red");
			return false;
		}

		if(equipped_item($slot[acc1]) == $item[over-the-shoulder folder holder])
		{
			if((item_amount($item[Ass-Stompers of Violence]) > 0) && (equipped_item($slot[acc1]) != $item[Ass-Stompers of Violence]) && can_equip($item[Ass-Stompers of Violence]))
			{
				equip($slot[acc1], $item[Ass-Stompers of Violence]);
			}
			else
			{
				equip($slot[acc1], $item[bejeweled pledge pin]);
			}
		}
		if(item_amount($item[portable cassette player]) > 0)
		{
			equip($slot[acc2], $item[portable cassette player]);
		}
		if(numeric_modifier("Combat Rate") <= 9.0)
		{
			if(possessEquipment($item[Carpe]))
			{
				equip($slot[Back], $item[Carpe]);
			}
		}
		if(numeric_modifier("Combat Rate") < 0.0)
		{
			auto_log_warning("Something is keeping us from getting a suitable combat rate, we have: " + numeric_modifier("Combat Rate") + " and Lobsterfrogmen.", "red");
			equipBaseline();
			return false;
		}
	}

	if(item_amount($item[barrel of gunpowder]) < 4)
	{
		set_property("auto_doCombatCopy", "yes");
	}

	if((my_mp() < mp_cost($skill[Digitize])) && (auto_get_campground() contains $item[Source Terminal]) && is_unrestricted($item[Source Terminal]) && (get_property("_sourceTerminalDigitizeMonster") != $monster[Lobsterfrogman]) && (get_property("_sourceTerminalDigitizeUses").to_int() < 3))
	{
		equipBaseline();
		return false;
	}

	if(possessEquipment($item[&quot;I voted!&quot; sticker]) && (my_adventures() > 15))
	{
		if(have_skill($skill[Meteor Lore]) && (get_property("_macrometeoriteUses").to_int() < 10))
		{
			if(auto_voteMonster())
			{
				set_property("auto_combatDirective", "start;skill macrometeorite");
				autoEquip($slot[acc3], $item[&quot;I voted!&quot; sticker]);
			}
			else
			{
				return false;
			}
		}
	}

	auto_sourceTerminalEducate($skill[Extract], $skill[Digitize]);

	autoAdv(1, $location[Sonofa Beach]);
	set_property("auto_combatDirective", "");
	set_property("auto_doCombatCopy", "no");
	handleFamiliar("item");

	if (isActuallyEd() && my_hp() == 0)
	{
		use(1, $item[Linen Bandages]);
	}
	return true;
}


boolean L12_filthworms()
{
	if(my_level() < 12)
	{
		return false;
	}
	if (in_tcrs() || in_koe())
	{
		return false;
	}
	if(item_amount($item[Heart of the Filthworm Queen]) > 0)
	{
		set_property("auto_orchard", "done");
	}
	if(get_property("auto_orchard") != "start")
	{
		return false;
	}
	if(get_property("auto_prewar") == "")
	{
		return false;
	}
	auto_log_info("Doing the orchard.", "blue");

	if(item_amount($item[Filthworm Hatchling Scent Gland]) > 0)
	{
		use(1, $item[Filthworm Hatchling Scent Gland]);
	}
	if(item_amount($item[Filthworm Drone Scent Gland]) > 0)
	{
		use(1, $item[Filthworm Drone Scent Gland]);
	}
	if(item_amount($item[Filthworm Royal Guard Scent Gland]) > 0)
	{
		use(1, $item[Filthworm Royal Guard Scent Gland]);
	}

	if(have_effect($effect[Filthworm Guard Stench]) > 0)
	{
		handleFamiliar("meat");
		autoAdv(1, $location[The Filthworm Queen\'s Chamber]);
		if(item_amount($item[Heart of the Filthworm Queen]) > 0)
		{
			set_property("auto_orchard", "done");
		}
		return true;
	}

	if(!have_skill($skill[Lash of the Cobra]))
	{
		buffMaintain($effect[Joyful Resolve], 0, 1, 1);
		buffMaintain($effect[Kindly Resolve], 0, 1, 1);
		buffMaintain($effect[Fortunate Resolve], 0, 1, 1);
		buffMaintain($effect[One Very Clear Eye], 0, 1, 1);
		buffMaintain($effect[Human-Fish Hybrid], 0, 1, 1);
		buffMaintain($effect[Human-Human Hybrid], 0, 1, 1);
		buffMaintain($effect[Human-Machine Hybrid], 0, 1, 1);
		buffMaintain($effect[Unusual Perspective], 0, 1, 1);
		buffMaintain($effect[Eagle Eyes], 0, 1, 1);
		asdonBuff($effect[Driving Observantly]);
		bat_formBats();

		if(get_property("auto_dickstab").to_boolean())
		{
			buffMaintain($effect[Wet and Greedy], 0, 1, 1);
		}
		buffMaintain($effect[Frosty], 0, 1, 1);
	}

	if((!possessEquipment($item[A Light That Never Goes Out])) && (item_amount($item[Lump of Brituminous Coal]) > 0))
	{
		buyUpTo(1, $item[third-hand lantern]);
		autoCraft("smith", 1, $item[Lump of Brituminous Coal], $item[third-hand lantern]);
	}

	if(possessEquipment($item[A Light That Never Goes Out]) && can_equip($item[A Light That Never Goes Out]))
	{
		if(weapon_hands(equipped_item($slot[weapon])) != 1)
		{
			equip($slot[weapon], $item[none]);
		}
		equip($item[A Light That Never Goes Out]);
	}

	handleFamiliar("item");
	if(item_amount($item[Training Helmet]) > 0)
	{
		equip($slot[hat], $item[Training Helmet]);
	}

	januaryToteAcquire($item[Broken Champagne Bottle]);
	if(item_amount($item[Broken Champagne Bottle]) > 0)
	{
		equip($item[Broken Champagne Bottle]);
	}

	if(auto_my_path() == "Live. Ascend. Repeat.")
	{
		if(item_drop_modifier() < 400.0)
		{
			abort("Can not handle item drop amount for the Filthworms, deja vu!! Either get us to +400% and rerun or do it yourself.");
		}
	}

	if(have_effect($effect[Filthworm Drone Stench]) > 0)
	{
		if(auto_have_familiar($familiar[XO Skeleton]) && (get_property("_xoHugsUsed").to_int() <= 10) && !is100FamiliarRun($familiar[XO Skeleton]))
		{
			handleFamiliar($familiar[XO Skeleton]);
		}
		autoAdv(1, $location[The Royal Guard Chamber]);
	}
	else if(have_effect($effect[Filthworm Larva Stench]) > 0)
	{
		if(auto_have_familiar($familiar[XO Skeleton]) && (get_property("_xoHugsUsed").to_int() <= 10) && !is100FamiliarRun($familiar[XO Skeleton]))
		{
			handleFamiliar($familiar[XO Skeleton]);
		}
		autoAdv(1, $location[The Feeding Chamber]);
	}
	else
	{
		if(auto_have_familiar($familiar[XO Skeleton]) && (get_property("_xoHugsUsed").to_int() <= 10) && !is100FamiliarRun($familiar[XO Skeleton]))
		{
			handleFamiliar($familiar[XO Skeleton]);
		}
		autoAdv(1, $location[The Hatching Chamber]);
	}
	handleFamiliar("item");
	return true;
}

boolean L12_finalizeWar()
{
	if(get_property("auto_war") != "done")
	{
		return false;
	}
	if(my_level() < 12)
	{
		return false;
	}

	if(have_outfit("War Hippy Fatigues"))
	{
		auto_log_info("Getting dimes.", "blue");
		foreach it in $items[padl phone, red class ring, blue class ring, white class ring]
		{
			sell(it.buyer, item_amount(it), it);
		}
		foreach it in $items[beer helmet, distressed denim pants, bejeweled pledge pin]
		{
			sell(it.buyer, item_amount(it) - 1, it);
		}
		if (isActuallyEd())
		{
			foreach it in $items[kick-ass kicks, perforated battle paddle, bottle opener belt buckle, keg shield, giant foam finger, war tongs, energy drink IV, Elmley shades, beer bong]
			{
				sell(it.buyer, item_amount(it), it);
			}
		}
	}
	if(have_outfit("Frat Warrior Fatigues"))
	{
		auto_log_info("Getting quarters.", "blue");
		foreach it in $items[pink clay bead, purple clay bead, green clay bead, communications windchimes]
		{
			sell(it.buyer, item_amount(it), it);
		}
		foreach it in $items[bullet-proof corduroys, round purple sunglasses, reinforced beaded headband]
		{
			sell(it.buyer, item_amount(it) - 1, it);
		}
		if (isActuallyEd())
		{
			foreach it in $items[hippy protest button, Lockenstock&trade; sandals, didgeridooka, wicker shield, oversized pipe, fire poi, Gaia beads, hippy medical kit, flowing hippy skirt, round green sunglasses]
			{
				sell(it.buyer, item_amount(it), it);
			}
		}
	}

	// Just in case we need the extra turngen to complete this day
	if (my_class() == $class[Vampyre])
	{
		int have = item_amount($item[monstar energy beverage]) + item_amount($item[carbonated soy milk]);
		if(have < 5)
		{
			int need = 5 - have;
			if(!get_property("auto_hippyInstead").to_boolean())
			{
				need = min(need, $coinmaster[Quartersmaster].available_tokens / 3);
				cli_execute("make " + need + " Monstar energy beverage");
			}
			else
			{
				need = min(need, $coinmaster[Dimemaster].available_tokens / 3);
				cli_execute("make " + need + " carbonated soy milk");
			}
		}
	}

	int have = item_amount($item[filthy poultice]) + item_amount($item[gauze garter]);
	if (have < 10 && !isActuallyEd())
	{
		int need = 10 - have;
		if(!get_property("auto_hippyInstead").to_boolean())
		{
			need = min(need, $coinmaster[Quartersmaster].available_tokens / 2);
			cli_execute("make " + need + " gauze garter");
		}
		else
		{
			need = min(need, $coinmaster[Dimemaster].available_tokens / 2);
			cli_execute("make " + need + " filthy poultice");
		}
	}

	if(have_outfit("War Hippy Fatigues"))
	{
		while($coinmaster[Dimemaster].available_tokens >= 5)
		{
			cli_execute("make " + $coinmaster[Dimemaster].available_tokens/5 + " fancy seashell necklace");
		}
		while($coinmaster[Dimemaster].available_tokens >= 2)
		{
			cli_execute("make " + $coinmaster[Dimemaster].available_tokens/2 + " filthy poultice");
		}
		while($coinmaster[Dimemaster].available_tokens >= 1)
		{
			cli_execute("make " + $coinmaster[Dimemaster].available_tokens + " water pipe bomb");
		}
	}

	if(have_outfit("Frat Warrior Fatigues"))
	{
		while($coinmaster[Quartersmaster].available_tokens >= 5)
		{
			cli_execute("make " + $coinmaster[Quartersmaster].available_tokens/5 + " commemorative war stein");
		}
		while($coinmaster[Quartersmaster].available_tokens >= 2)
		{
			cli_execute("make " + $coinmaster[Quartersmaster].available_tokens/2 + " gauze garter");
		}
		while($coinmaster[Quartersmaster].available_tokens >= 1)
		{
			cli_execute("make " + $coinmaster[Quartersmaster].available_tokens + " beer bomb");
		}
	}

	if(my_mp() < 40)
	{
		// fyi https://kol.coldfront.net/thekolwiki/index.php/Chateau_Mantegna states you wont get pantsgiving benefits resting there (presumably campsite as well)
		// so not sure this is doing much
		if(possessEquipment($item[Pantsgiving]))
		{
			equip($item[pantsgiving]);
		}
		doRest();
	}
	warOutfit(false);
	acquireHP();
	auto_log_info("Let's fight the boss!", "blue");

	location bossFight = $location[The Battlefield (Frat Uniform)];

	if (in_koe())
	{
		bossFight = 533.to_location();
	}
	else if(get_property("auto_hippyInstead").to_boolean())
	{
		bossFight = $location[The Battlefield (Hippy Uniform)];
	}

#	handlePreAdventure(bossFight);
	if(auto_have_familiar($familiar[Machine Elf]))
	{
		handleFamiliar($familiar[Machine Elf]);
	}
	string[int] pages;
	if (!in_koe())
	{
		pages[0] = "bigisland.php?place=camp&whichcamp=1";
		pages[1] = "bigisland.php?place=camp&whichcamp=2";
		pages[2] = "bigisland.php?action=bossfight&pwd";
	}
	if(!autoAdvBypass(0, pages, bossFight, ""))
	{
		auto_log_warning("Boss already defeated, ignoring", "red");
	}

	if(auto_my_path() == "Pocket Familiars")
	{
		string temp = visit_url("island.php");
		council();
	}

	cli_execute("refresh quests");
	if(get_property("questL12War") != "finished")
	{
		abort("Failing to complete the war.");
	}
	council();
	set_property("auto_war", "finished");
	return true;
}

boolean LX_getDigitalKey()
{
	if (in_koe())
	{
		return false;
	}
	if(contains_text(get_property("nsTowerDoorKeysUsed"), "digital key"))
	{
		return false;
	}
	if(((get_property("auto_war") != "finished") && (get_property("auto_war") != "")) && (item_amount($item[Rock Band Flyers]) == 0) && (item_amount($item[Jam Band Flyers]) == 0) && (get_property("auto_powerLevelAdvCount").to_int() < 9))
	{
		return false;
	}
	while((item_amount($item[Red Pixel]) > 0) && (item_amount($item[Blue Pixel]) > 0) && (item_amount($item[Green Pixel]) > 0) && (item_amount($item[White Pixel]) < 30) && (item_amount($item[Digital Key]) == 0))
	{
		cli_execute("make white pixel");
	}
	if((item_amount($item[white pixel]) >= 30) || (item_amount($item[Digital Key]) > 0))
	{
		if(have_effect($effect[Consumed By Fear]) > 0)
		{
			uneffect($effect[Consumed By Fear]);
			council();
		}
		return false;
	}

	if(get_property("auto_crackpotjar") == "")
	{
		if(item_amount($item[Jar Of Psychoses (The Crackpot Mystic)]) == 0)
		{
			pullXWhenHaveY($item[Jar Of Psychoses (The Crackpot Mystic)], 1, 0);
		}
		if(item_amount($item[Jar Of Psychoses (The Crackpot Mystic)]) == 0)
		{
			set_property("auto_crackpotjar", "fail");
		}
		else
		{
			woods_questStart();
			use(1, $item[Jar Of Psychoses (The Crackpot Mystic)]);
			set_property("auto_crackpotjar", "done");
		}
	}
	auto_log_info("Getting white pixels: Have " + item_amount($item[white pixel]), "blue");
	if(get_property("auto_crackpotjar") == "done")
	{
		set_property("choiceAdventure644", 3);
		autoAdv(1, $location[Fear Man\'s Level]);
		if(have_effect($effect[Consumed By Fear]) == 0)
		{
			auto_log_warning("Well, we don't seem to have further access to the Fear Man area so... abort that plan", "red");
			set_property("auto_crackpotjar", "fail");
		}
	}
	else if(get_property("auto_crackpotjar") == "fail")
	{
		woods_questStart();
		autoEquip($slot[acc3], $item[Continuum Transfunctioner]);
		if(auto_saberChargesAvailable() > 0)
		{
			autoEquip($item[Fourth of May cosplay saber]);
		}
		autoAdv(1, $location[8-bit Realm]);
	}
	return true;
}

boolean L11_getBeehive()
{
	if(my_level() < 11)
	{
		return false;
	}
	if(!get_property("auto_getBeehive").to_boolean())
	{
		return false;
	}
	if((internalQuestStatus("questL13Final") >= 7) || (item_amount($item[Beehive]) > 0))
	{
		auto_log_info("Nevermind, wall of skin already defeated (or we already have a beehiven). We do not need a beehive. Bloop.", "blue");
		set_property("auto_getBeehive", false);
		return false;
	}


	auto_log_info("Must find a beehive!", "blue");

	set_property("choiceAdventure923", "1");
	set_property("choiceAdventure924", "3");
	set_property("choiceAdventure1018", "1");
	set_property("choiceAdventure1019", "1");

	handleBjornify($familiar[Grimstone Golem]);
	buffMaintain($effect[The Sonata of Sneakiness], 20, 1, 1);
	buffMaintain($effect[Smooth Movements], 10, 1, 1);

	autoAdv(1, $location[The Black Forest]);
	if(item_amount($item[beehive]) > 0)
	{
		set_property("auto_getBeehive", false);
	}
	return true;
}

boolean L12_orchardStart()
{
	if((get_property("auto_orchard") == "finished") && (get_property("sidequestOrchardCompleted") == "none"))
	{
		if((get_property("hippiesDefeated").to_int() < 1000) && (get_property("fratboysDefeated").to_int() < 1000))
		{
			abort("The script thinks we completed the orchard but mafia doesn't, return the heart?");
		}
	}

	if(my_level() < 12)
	{
		return false;
	}
	if(get_property("auto_orchard") != "")
	{
		return false;
	}
	if((get_property("hippiesDefeated").to_int() < 64) && !get_property("auto_hippyInstead").to_boolean())
	{
		return false;
	}

	warOutfit(true);
	visit_url("bigisland.php?place=orchard&action=stand&pwd");
	set_property("auto_orchard", "start");
	return true;
}

boolean L12_orchardFinalize()
{
	if(get_property("auto_orchard") != "done")
	{
		return false;
	}
	if(!get_property("auto_hippyInstead").to_boolean() && (get_property("hippiesDefeated").to_int() < 64))
	{
		return false;
	}
	set_property("auto_orchard", "finished");
	if(item_amount($item[A Light that Never Goes Out]) == 1)
	{
		pulverizeThing($item[A Light that Never Goes Out]);
	}
	warOutfit(true);
	string temp = visit_url("bigisland.php?place=orchard&action=stand&pwd");
	temp = visit_url("bigisland.php?place=orchard&action=stand&pwd");
	return true;
}


boolean L10_plantThatBean()
{
	if(my_level() < 10)
	{
		return false;
	}
	if(get_property("auto_bean").to_boolean())
	{
		return false;
	}

	council();
	auto_log_info("Planting me magic bean!", "blue");
	string page = visit_url("place.php?whichplace=plains");
	if(contains_text(page, "place.php?whichplace=beanstalk"))
	{
		auto_log_warning("I have no bean but I see a stalk here. Okies. I'm ok with that", "blue");
		set_property("auto_bean", true);
		visit_url("place.php?whichplace=beanstalk");
		return true;
	}
	if(item_amount($item[Enchanted Bean]) > 0)
	{
		use(1, $item[Enchanted Bean]);
		set_property("auto_bean", true);
		return true;
	}
	else if (isActuallyEd())
	{
		set_property("auto_bean", true);
		return true;
	}

	if(internalQuestStatus("questL04Bat") >= 0)
	{
		auto_log_info("I don't have a magic bean! Travesty!!", "blue");
		return autoAdv($location[The Beanbat Chamber]);
	}
	return false;

}

boolean L10_holeInTheSkyUnlock()
{
	if(my_level() < 10)
	{
		return false;
	}
	if(get_property("auto_castleground") != "finished")
	{
		return false;
	}

	if(!get_property("auto_holeinthesky").to_boolean())
	{
		return false;
	}
	if(item_amount($item[Steam-Powered Model Rocketship]) > 0)
	{
		set_property("auto_holeinthesky", false);
		return false;
	}
	if (!needStarKey() && !isActuallyEd())
	{
		// we force auto_holeinthesky to true in L11_shenCopperhead() as Ed if Shen sends us to the Hole in the Sky
		// as otherwise the zone isn't required at all for Ed.
		set_property("auto_holeinthesky", false);
		return false;
	}

	auto_log_info("Castle Top Floor - Opening the Hole in the Sky", "blue");
	set_property("choiceAdventure677", 2);
	set_property("choiceAdventure675", 4);
	set_property("choiceAdventure678", 3);
	set_property("choiceAdventure676", 4);

	if(auto_have_familiar($familiar[Ms. Puck Man]))
	{
		handleFamiliar($familiar[Ms. Puck Man]);
	}
	else if(auto_have_familiar($familiar[Puck Man]))
	{
		handleFamiliar($familiar[Puck Man]);
	}
	if(!auto_forceNextNoncombat())
	{
		providePlusNonCombat(25);
	}
	autoAdv(1, $location[The Castle in the Clouds in the Sky (Top Floor)]);
	handleFamiliar("item");

	return true;
}

boolean L10_topFloor()
{
	if(my_level() < 10)
	{
		return false;
	}

	if(get_property("auto_castleground") != "finished")
	{
		return false;
	}

	if(get_property("auto_castletop") != "")
	{
		return false;
	}

	auto_log_info("Castle Top Floor", "blue");
	set_property("choiceAdventure680", 1); // Mercy adventure: Are you a Man or a Mouse?
	if(item_amount($item[Drum \'n\' Bass \'n\' Drum \'n\' Bass Record]) > 0)
	{
		auto_log_info("We have a drum 'n' bass record and are willing to use it!", "green");
		// Copper Feel: Move to Mellon Collie
		set_property("choiceAdventure677", 4);
		// Mellon Collie: Turn in record, complete quest
		set_property("choiceAdventure675", 2);
	}
	else
	{
		// Mellon Collie: Move to Gimme Steam
		set_property("choiceAdventure675", 4);
		// Copper feel: Turn in airship (will fight otherwise)
		set_property("choiceAdventure677", 1);
	}
	if (!possessEquipment($item[mohawk wig]) && auto_can_equip($item[mohawk wig]) && !in_hardcore())
	{
		pullXWhenHaveY($item[Mohawk Wig], 1, 0);
	}

	if(!possessEquipment($item[mohawk wig]) && 0 == item_amount($item[Drum \'n\' Bass \'n\' Drum \'n\' Bass Record]))
	{
		auto_log_info("We don't have a mohawk wig, let's try to get a drum 'n' bass record...", "green");
		// Yeah, You're for Me, Punk Rock Giant: Move to Flavor of a Raver (676)
		set_property("choiceAdventure678", 4);
		// Floor of a Raver: Acquire drum 'n' bass 'n' drum 'n' bass record
		set_property("choiceAdventure676", 3);
	}
	else
	{
		// Floor of a Raver: Move to "Yeah, You're for Me, Punk Rock Giant (678)"
		set_property("choiceAdventure676", 4);
		// Yeah, You're for Me, Punk Rock Giant: Get the Punk's Attention, complete quest
		set_property("choiceAdventure678", 1);
	}

	if (isActuallyEd())
	{
		set_property("choiceAdventure679", 2);
	}
	else
	{
		set_property("choiceAdventure679", 1);
	}

	handleFamiliar("initSuggest");
	if(!auto_forceNextNoncombat())
	{
		providePlusNonCombat(25);
	}
	autoEquip($item[mohawk wig]);
	autoAdv(1, $location[The Castle in the Clouds in the Sky (Top Floor)]);
	handleFamiliar("item");

	if(contains_text(get_property("lastEncounter"), "Keep On Turnin\' the Wheel in the Sky"))
	{
		set_property("auto_castletop", "finished");
		council();
	}
	if(possessEquipment($item[mohawk wig]) && contains_text(get_property("lastEncounter"), "Copper Feel"))
	{
		set_property("auto_castletop", "finished");
		council();
	}

	return true;
}

boolean L10_ground()
{
	if(my_level() < 10)
	{
		return false;
	}
	if(internalQuestStatus("questL10Garbage") > 8)
	{
		set_property("auto_castleground", "finished");
	}

	if(get_property("auto_castlebasement") != "finished")
	{
		return false;
	}

	if(get_property("auto_castleground") != "")
	{
		return false;
	}
	if(!canGroundhog($location[The Castle in the Clouds in the Sky (Ground Floor)]))
	{
		return false;
	}

	auto_log_info("Castle Ground Floor, boring!", "blue");
	set_property("choiceAdventure672", 3); // There's No Ability Like Possibility: Skip
	set_property("choiceAdventure673", 1); // Putting Off Is Off-Putting: Very Overdue Library Book then Skip
	set_property("choiceAdventure674", 3); // Huzzah!: Skip
	if (isActuallyEd() || (auto_my_path() == "Pocket Familiars"))
	{
		set_property("choiceAdventure1026", 3); // Home on the Free Range: Skip
	}
	else
	{
		set_property("choiceAdventure1026", 2); // Home on the Free Range: Get Electric Boning Knife then Skip
	}

	if(auto_have_familiar($familiar[Ms. Puck Man]))
	{
		handleFamiliar($familiar[Ms. Puck Man]);
	}
	else if(auto_have_familiar($familiar[Puck Man]))
	{
		handleFamiliar($familiar[Puck Man]);
	}

	auto_sourceTerminalEducate($skill[Extract], $skill[Portscan]);
	providePlusNonCombat(25);

	if((my_class() == $class[Gelatinous Noob]) && auto_have_familiar($familiar[Robortender]))
	{
		if(!have_skill($skill[Bendable Knees]) && (item_amount($item[Bottle of Gregnadigne]) == 0))
		{
			handleFamiliar($familiar[Robortender]);
		}
	}

	autoAdv(1, $location[The Castle in the Clouds in the Sky (Ground Floor)]);
	handleFamiliar("item");

	if(contains_text(get_property("lastEncounter"), "Top of the Castle, Ma"))
	{
		set_property("auto_castleground", "finished");
	}
	return true;
}

boolean L10_basement()
{
	if(my_level() < 10)
	{
		return false;
	}
	if(get_property("auto_castlebasement") != "")
	{
		return false;
	}
	if(my_adventures() < 3)
	{
		return false;
	}
	auto_log_info("Basement Search", "blue");
	set_property("choiceAdventure670", "5"); // You Don't Mess Around with Gym: Open Ground floor (with amulet)
	if(item_amount($item[Massive Dumbbell]) > 0)
	{
		set_property("choiceAdventure671", "1"); // Out in the Open Source: Open Ground floor
	}
	else
	{
		set_property("choiceAdventure671", "4"); // Out in the Open Source: Go to Fitness Choice
	}

	if(my_primestat() == $stat[Muscle])
	{
		buyUpTo(1, $item[Ben-Gal&trade; Balm]);
		buffMaintain($effect[Go Get \'Em\, Tiger!], 0, 1, 1);
	}
	buyUpTo(1, $item[Hair Spray]);
	buffMaintain($effect[Butt-Rock Hair], 0, 1, 1);

	if(possessEquipment($item[Titanium Assault Umbrella]) && can_equip($item[Titanium Assault Umbrella]))
	{
		set_property("choiceAdventure669", "4"); // The Fast and the Furry-ous: Skip (and ensure reoccurance)
	}
	else
	{
		set_property("choiceAdventure669", "1"); // The Fast and the Furry-ous: Open Ground floor (with Umbrella) or Neckbeard Choice
	}

	if(auto_have_familiar($familiar[Ms. Puck Man]))
	{
		handleFamiliar($familiar[Ms. Puck Man]);
	}
	else if(auto_have_familiar($familiar[Puck Man]))
	{
		handleFamiliar($familiar[Puck Man]);
	}
	if(!auto_forceNextNoncombat())
	{
		providePlusNonCombat(25);
	}
	if((my_class() == $class[Gelatinous Noob]) && auto_have_familiar($familiar[Robortender]))
	{
		if(!have_skill($skill[Bendable Knees]) && (item_amount($item[Bottle of Gregnadigne]) == 0))
		{
			handleFamiliar($familiar[Robortender]);
		}
	}

	autoAdv(1, $location[The Castle in the Clouds in the Sky (Basement)]);
	handleFamiliar("item");

	if(contains_text(get_property("lastEncounter"), "Out in the Open Source") && (get_property("choiceAdventure671").to_int() == 1))
	{
		auto_log_info("Dumbbell + Dumbwaiter means we fly!", "green");
		set_property("auto_castlebasement", "finished");
	}
	else if(contains_text(get_property("lastEncounter"), "The Fast and the Furry-ous"))
	{
		auto_log_info("We was fast and furry-ous!", "blue");
		autoEquip($item[Titanium Assault Umbrella]);
		set_property("choiceAdventure669", "1"); // The Fast and the Furry-ous: Open Ground floor (with Umbrella)
		autoAdv(1, $location[The Castle in the Clouds in the Sky (Basement)]);
		if(contains_text(get_property("lastEncounter"), "The Fast and the Furry-ous"))
		{
			set_property("auto_castlebasement", "finished");
		}
		else
		{
			auto_log_warning("Got interrupted trying to unlock the Ground Floor of the Castle", "red");
		}
	}
	else if(contains_text(get_property("lastEncounter"), "You Don\'t Mess Around with Gym"))
	{
		auto_log_info("Just messed with Gym", "blue");
		if(!can_equip($item[Amulet of Extreme Plot Significance]) || (item_amount($item[Massive Dumbbell]) > 0))
		{
			auto_log_warning("Can't equip an Amulet of Extreme Plot Signifcance...", "red");
			auto_log_warning("I suppose we will try the Massive Dumbbell... Beefcake!", "red");
			set_property("choiceAdventure670", "1"); // You Don't Mess Around with Gym: Get Massive Dumbbell then Skip
			autoAdv(1, $location[The Castle in the Clouds in the Sky (Basement)]);
			return true;
		}

		set_property("choiceAdventure670", "5"); // You Don't Mess Around with Gym: Open Ground floor (with amulet)
		if(!possessEquipment($item[Amulet Of Extreme Plot Significance]))
		{
			pullXWhenHaveY($item[Amulet of Extreme Plot Significance], 1, 0);
			if(!possessEquipment($item[Amulet of Extreme Plot Significance]))
			{
				if($location[The Penultimate Fantasy Airship].turns_spent >= 45 || in_koe())
				{
					auto_log_warning("Well, we don't seem to be able to find an Amulet...", "red");
					auto_log_warning("I suppose we will get the Massive Dumbbell... Beefcake!", "red");
					set_property("choiceAdventure670", "1"); // You Don't Mess Around with Gym: Get Massive Dumbbell then Skip
					autoAdv(1, $location[The Castle in the Clouds in the Sky (Basement)]);
				}
				else
				{
					auto_log_warning("Backfarming an Amulet of Extreme Plot Significance, sigh :(", "blue");
					autoAdv(1, $location[The Penultimate Fantasy Airship]);
				}
				return true;
			}
		}
		set_property("choiceAdventure670", "4"); // You Don't Mess Around with Gym: Open Ground floor (with amulet)

		if(!autoEquip($slot[acc3], $item[Amulet Of Extreme Plot Significance]))
		{
			abort("Unable to equip the Amulet when we wanted to...");
		}
		autoAdv(1, $location[The Castle in the Clouds in the Sky (Basement)]);
		if(contains_text(get_property("lastEncounter"), "You Don\'t Mess Around with Gym"))
		{
			set_property("auto_castlebasement", "finished");
		}
		else
		{
			auto_log_warning("Got interrupted trying to unlock the Ground Floor of the Castle", "red");
		}
	}
	return true;
}

boolean L10_airship()
{
	if(my_level() < 10)
	{
		return false;
	}
	if(item_amount($item[S.O.C.K.]) == 1)
	{
		set_property("auto_airship", "finished");
	}
	if(get_property("auto_airship") != "")
	{
		return false;
	}

	visit_url("clan_viplounge.php?preaction=goswimming&subaction=submarine");
	auto_log_info("Fantasy Airship Fly Fly time", "blue");
	if((my_mp() > 60) || considerGrimstoneGolem(true))
	{
		handleBjornify($familiar[Grimstone Golem]);
	}
	set_property("choiceAdventure178", "2"); // Hammering the Armory: Skip

	if(item_amount($item[Model Airship]) == 0)
	{
		set_property("choiceAdventure182", "4"); // Random Lack of an Encounter: Get Model Airship
	}
	else
	{
		set_property("choiceAdventure182", "1"); // Random Lack of an Encounter: Fight!
	}

	if((my_daycount() == 1) && (get_property("_hipsterAdv").to_int() < 7) && is_unrestricted($familiar[Artistic Goth Kid]) && auto_have_familiar($familiar[Artistic Goth Kid]))
	{
		auto_log_info("Hipster Adv: " + get_property("_hipsterAdv"), "blue");
		handleFamiliar($familiar[Artistic Goth Kid]);
	}

	if($location[The Penultimate Fantasy Airship].turns_spent < 10)
	{
		bat_formBats();
	}
	else
	{
		providePlusNonCombat(25);

		buffMaintain($effect[Fishy Whiskers], 0, 1, 1);
		buffMaintain($effect[Snow Shoes], 0, 1, 1);
		buffMaintain($effect[Fishy\, Oily], 0, 1, 1);
		buffMaintain($effect[Gummed Shoes], 0, 1, 1);
	}

	autoAdv(1, $location[The Penultimate Fantasy Airship]);
	handleFamiliar("item");
	return true;
}

boolean L12_flyerBackup()
{
	if(get_property("auto_prewar") != "started")
	{
		return false;
	}
	if(get_property("flyeredML").to_int() >= 10000)
	{
		return false;
	}
	if((item_amount($item[Rock Band Flyers]) == 0) && (item_amount($item[Jam Band Flyers]) == 0))
	{
		return false;
	}
	if(get_property("choiceAdventure1003").to_int() >= 3)
	{
		return false;
	}
	if(get_property("auto_ignoreFlyer").to_boolean())
	{
		return false;
	}

	return LX_freeCombats();
}

boolean LX_freeCombats()
{
	if(my_inebriety() > inebriety_limit())
	{
		return false;
	}

	if((auto_my_path() != "Disguises Delimit") && neverendingPartyCombat())
	{
		return true;
	}

	if(auto_have_familiar($familiar[Machine Elf]) && (get_property("_machineTunnelsAdv").to_int() < 5) && (my_adventures() > 0) && !is100FamiliarRun())
	{
		if(get_property("auto_choice1119") != "")
		{
			set_property("choiceAdventure1119", get_property("auto_choice1119"));
		}
		set_property("auto_choice1119", get_property("choiceAdventure1119"));
		set_property("choiceAdventure1119", 1);


		familiar bjorn = my_bjorned_familiar();
		if(bjorn == $familiar[Machine Elf])
		{
			handleBjornify($familiar[Grinning Turtle]);
		}
		handleFamiliar($familiar[Machine Elf]);
		autoAdv(1, $location[The Deep Machine Tunnels]);
		if(bjorn == $familiar[Machine Elf])
		{
			handleBjornify(bjorn);
		}

		set_property("choiceAdventure1119", get_property("auto_choice1119"));
		set_property("auto_choice1119", "");
		handleFamiliar("item");
		loopHandlerDelayAll();
		return true;
	}

	if(snojoFightAvailable() && (my_adventures() > 0))
	{
		handleFamiliar($familiar[Ms. Puck Man]);
		autoAdv(1, $location[The X-32-F Combat Training Snowman]);
		handleFamiliar("item");
		if(get_property("_auto_digitizeDeskCounter").to_int() > 2)
		{
			set_property("_auto_digitizeDeskCounter", get_property("_auto_digitizeDeskCounter").to_int() - 1);
		}
		loopHandlerDelayAll();
		return true;
	}

	if(((my_level() < 13) || (get_property("auto_disregardInstantKarma").to_boolean())) && godLobsterCombat())
	{
		return true;
	}

	return false;
}

boolean Lsc_flyerSeals()
{
	if(my_class() != $class[Seal Clubber])
	{
		return false;
	}
	if(get_property("auto_ignoreFlyer").to_boolean())
	{
		return false;
	}
	if(get_property("auto_prewar") != "started")
	{
		return false;
	}
	if(get_property("flyeredML").to_int() >= 10000)
	{
		return false;
	}
	if((item_amount($item[Rock Band Flyers]) == 0) && (item_amount($item[Jam Band Flyers]) == 0))
	{
		return false;
	}
	if(get_property("choiceAdventure1003").to_int() >= 3)
	{
		return false;
	}

	if((get_property("_sealsSummoned").to_int() < maxSealSummons()) && (my_meat() > 500))
	{
		element towerTest = ns_crowd3();
		boolean doElement = false;
		if(item_amount($item[powdered sealbone]) > 0)
		{
			if((towerTest == $element[cold]) && (item_amount($item[frost-rimed seal hide]) < 2) && (item_amount($item[figurine of a cold seal]) > 0))
			{
				doElement = true;
			}
			if((towerTest == $element[hot]) && (item_amount($item[sizzling seal fat]) < 2) && (item_amount($item[figurine of a charred seal]) > 0))
			{
				doElement = true;
			}
			if((towerTest == $element[sleaze]) && (item_amount($item[seal lube]) < 2) && (item_amount($item[figurine of a slippery seal]) > 0))
			{
				doElement = true;
			}
			if((towerTest == $element[spooky]) && (item_amount($item[scrap of shadow]) < 2) && (item_amount($item[figurine of a shadowy seal]) > 0))
			{
				doElement = true;
			}
			if((towerTest == $element[stench]) && (item_amount($item[fustulent seal grulch]) < 2) && (item_amount($item[figurine of a stinking seal]) > 0))
			{
				doElement = true;
			}
		}

		handleFamiliar("initSuggest");
		boolean clubbedSeal = false;
		if(doElement)
		{
			if((item_amount($item[imbued seal-blubber candle]) == 0) && guild_store_available())
			{
				buyUpTo(1, $item[seal-blubber candle]);
				cli_execute("make imbued seal-blubber candle");
			}
			if(item_amount($item[Imbued Seal-Blubber Candle]) > 0)
			{
				ensureSealClubs();
				handleSealElement(towerTest);
				clubbedSeal = true;
			}
		}
		else if(guild_store_available() && isHermitAvailable())
		{
			buyUpTo(1, $item[figurine of an armored seal]);
			buyUpTo(10, $item[seal-blubber candle]);
			if((item_amount($item[Figurine of an Armored Seal]) > 0) && (item_amount($item[Seal-Blubber Candle]) >= 10))
			{
				handleSealNormal($item[Figurine of an Armored Seal]);
				clubbedSeal = true;
			}
		}
		if((item_amount($item[bad-ass club]) == 0) && (item_amount($item[ingot of seal-iron]) > 0) && have_skill($skill[Super-Advanced Meatsmithing]))
		{
			if((item_amount($item[Tenderizing Hammer]) == 0) && ((my_meat() >= (npc_price($item[Tenderizing Hammer]) * 2)) && (npc_price($item[Tenderizing Hammer]) != 0)))
			{
				buyUpTo(1, $item[Tenderizing Hammer]);
			}
			if(item_amount($item[Tenderizing Hammer]) > 0)
			{
				use(1, $item[ingot of seal-iron]);
			}
		}
		handleFamiliar("item");
		return clubbedSeal;
	}
	return false;
}

boolean LX_dolphinKingMap()
{
	if(item_amount($item[Dolphin King\'s Map]) > 0)
	{
		if(possessEquipment($item[Snorkel]) || ((my_meat() >= npc_price($item[Snorkel])) && isArmoryAvailable()))
		{
			buyUpTo(1, $item[Snorkel]);
			item oldHat = equipped_item($slot[hat]);
			equip($item[Snorkel]);
			use(1, $item[Dolphin King\'s Map]);
			equip(oldHat);
			return true;
		}
	}
	return false;
}

boolean L7_crypt()
{
	if((my_level() < 7) || (get_property("auto_crypt") != ""))
	{
		return false;
	}
	if(item_amount($item[chest of the bonerdagon]) == 1)
	{
		set_property("auto_crypt", "finished");
		use(1, $item[chest of the bonerdagon]);
		return false;
	}
	oldPeoplePlantStuff();

	if(my_mp() > 60)
	{
		handleBjornify($familiar[Grimstone Golem]);
	}

	buffMaintain($effect[Browbeaten], 0, 1, 1);
	buffMaintain($effect[Rosewater Mark], 0, 1, 1);

	boolean edAlcove = true;
	if (isActuallyEd())
	{
		edAlcove = have_skill($skill[More Legs]);
	}

	if((get_property("romanticTarget") != $monster[modern zmobie]) && (get_property("auto_waitingArrowAlcove").to_int() < 50))
	{
		set_property("auto_waitingArrowAlcove", 50);
	}

	void useNightmareFuelIfPossible()
	{
		if((spleen_left() > 0) && (item_amount($item[Nightmare Fuel]) > 0) && !is_unrestricted($item[Powdered Gold]))
		{
			autoChew(1, $item[Nightmare Fuel]);
		}
	}

	if((get_property("cyrptAlcoveEvilness").to_int() > 0) && ((get_property("cyrptAlcoveEvilness").to_int() <= get_property("auto_waitingArrowAlcove").to_int()) || (get_property("cyrptAlcoveEvilness").to_int() <= 25)) && edAlcove && canGroundhog($location[The Defiled Alcove]))
	{
		handleFamiliar("init");

		if((get_property("_badlyRomanticArrows").to_int() == 0) && auto_have_familiar($familiar[Reanimated Reanimator]) && (my_daycount() == 1))
		{
			handleFamiliar($familiar[Reanimated Reanimator]);
		}

		buffMaintain($effect[Sepia Tan], 0, 1, 1);
		buffMaintain($effect[Walberg\'s Dim Bulb], 5, 1, 1);
		buffMaintain($effect[Bone Springs], 40, 1, 1);
		buffMaintain($effect[Springy Fusilli], 10, 1, 1);
		buffMaintain($effect[Patent Alacrity], 0, 1, 1);
		if((my_class() == $class[Seal Clubber]) || (my_class() == $class[Turtle Tamer]))
		{
			buyUpTo(1, $item[Cheap Wind-up Clock]);
			buffMaintain($effect[Ticking Clock], 0, 1, 1);
		}
		buffMaintain($effect[Song of Slowness], 110, 1, 1);
		buffMaintain($effect[Your Fifteen Minutes], 90, 1, 1);
		buffMaintain($effect[Fishy\, Oily], 0, 1, 1);
		buffMaintain($effect[Nearly Silent Hunting], 0, 1, 1);
		buffMaintain($effect[Soulerskates], 0, 1, 1);
		buffMaintain($effect[Cletus\'s Canticle of Celerity], 10, 1, 1);

		if (isActuallyEd() && monster_attack($monster[modern zmobie]) >= my_maxhp())
		{
			// Need to be able to tank a hit from the modern zmobies as Ed
			// as we'll never get the jump because their initiative is ridiculous.
			// Otherwise we'll just die repeatedly.
			if (get_property("telescopeUpgrades").to_int() > 0 && !get_property("telescopeLookedHigh").to_boolean())
			{
				cli_execute("telescope high");
			}
			if (!get_property("_lyleFavored").to_boolean())
			{
				cli_execute("monorail");
			}
			if (have_effect($effect[Butt-Rock Hair]) == 0)
			{
				buyUpTo(1, $item[Hair Spray]);
				buffMaintain($effect[Butt-Rock Hair], 0, 1, 1);
			}
			if (have_effect($effect[Go Get \'Em, Tiger!]) == 0)
			{
				buyUpTo(1, $item[Ben-Gal&trade; Balm]);
				buffMaintain($effect[Go Get \'Em, Tiger!], 0, 1, 1);
			}
		}

		auto_beachCombHead("init");

		if(have_effect($effect[init.enh]) == 0)
		{
			int enhances = auto_sourceTerminalEnhanceLeft();
			if(enhances > 0)
			{
				auto_sourceTerminalEnhance("init");
			}
		}

		if((have_effect($effect[Soles of Glass]) == 0) && (get_property("_grimBuff") == false))
		{
			visit_url("choice.php?pwd&whichchoice=835&option=1", true);
		}

		autoEquip($item[Gravy Boat]);

		if(!useMaximizeToEquip() && (get_property("cyrptAlcoveEvilness").to_int() > 26))
		{
			autoEquip($item[The Nuge\'s Favorite Crossbow]);
		}
		bat_formBats();

		addToMaximize("100initiative 850max");

		if(get_property("cyrptAlcoveEvilness").to_int() >= 28)
		{
			useNightmareFuelIfPossible();
		}

		auto_log_info("The Alcove! (" + initiative_modifier() + ")", "blue");
		autoAdv(1, $location[The Defiled Alcove]);
		handleFamiliar("item");
		return true;
	}

	// In KoE, skeleton astronauts are random encounters that drop Evil Eyes.
	// We might be able to reach the Nook boss without adventuring.

	while((item_amount($item[Evil Eye]) > 0) && auto_is_valid($item[Evil Eye]) && (get_property("cyrptNookEvilness").to_int() > 25))
	{
		use(1, $item[Evil Eye]);
	}

	boolean skip_in_koe = in_koe() && (get_property("cyrptNookEvilness").to_int() > 25) && get_property("questL12HippyFrat") != "finished";

	if((get_property("cyrptNookEvilness").to_int() > 0) && canGroundhog($location[The Defiled Nook]) && !skip_in_koe)
	{
		auto_log_info("The Nook!", "blue");
		buffMaintain($effect[Joyful Resolve], 0, 1, 1);
		handleFamiliar("item");
		autoEquip($item[Gravy Boat]);

		bat_formBats();

		januaryToteAcquire($item[broken champagne bottle]);
		if(useMaximizeToEquip() && (get_property("cyrptNookEvilness").to_int() > 26))
		{
			removeFromMaximize("-equip " + $item[broken champagne bottle]);
		}
		else if((numeric_modifier("item drop") < 400) && (item_amount($item[Broken Champagne Bottle]) > 0) && (get_property("cyrptNookEvilness").to_int() > 26))
		{
			autoEquip($item[broken champagne bottle]);
		}

		if(get_property("cyrptNookEvilness").to_int() >= 28)
		{
			useNightmareFuelIfPossible();
		}

		autoAdv(1, $location[The Defiled Nook]);
		return true;
	}
	else if(skip_in_koe)
	{
		auto_log_debug("In Exploathing, skipping Defiled Nook until we get more evil eyes.");
	}

	if((get_property("cyrptNicheEvilness").to_int() > 0) && canGroundhog($location[The Defiled Niche]))
	{
		if((my_daycount() == 1) && (get_property("_hipsterAdv").to_int() < 7) && is_unrestricted($familiar[Artistic Goth Kid]) && auto_have_familiar($familiar[Artistic Goth Kid]))
		{
			handleFamiliar($familiar[Artistic Goth Kid]);
		}
		autoEquip($item[Gravy Boat]);

		if(auto_have_familiar($familiar[Space Jellyfish]) && (get_property("_spaceJellyfishDrops").to_int() < 3))
		{
			handleFamiliar($familiar[Space Jellyfish]);
		}

		if(get_property("cyrptNicheEvilness").to_int() >= 28)
		{
			useNightmareFuelIfPossible();
		}

		auto_log_info("The Niche!", "blue");
		autoAdv(1, $location[The Defiled Niche]);

		handleFamiliar("item");
		return true;
	}

	if(get_property("cyrptCrannyEvilness").to_int() > 0)
	{
		auto_log_info("The Cranny!", "blue");
		set_property("choiceAdventure523", "4");

		if(my_mp() > 60)
		{
			handleBjornify($familiar[Grimstone Golem]);
		}

		autoEquip($item[Gravy Boat]);

		spacegateVaccine($effect[Emotional Vaccine]);

		if(auto_have_familiar($familiar[Space Jellyfish]) && (get_property("_spaceJellyfishDrops").to_int() < 3))
		{
			handleFamiliar($familiar[Space Jellyfish]);
		}

		if(get_property("cyrptCrannyEvilness").to_int() >= 28)
		{
			useNightmareFuelIfPossible();
		}

		// In Dark Gyffte: Each dieting pill gives about 23 adventures of turngen
		if(have_skill($skill[Flock of Bats Form]) && have_skill($skill[Sharp Eyes]))
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
				set_property("choiceAdventure523", "5");
			}
		}

		auto_MaxMLToCap(auto_convertDesiredML(149), true);

		providePlusNonCombat(25);

		addToMaximize("200ml " + auto_convertDesiredML(149) + "max");
		autoAdv(1, $location[The Defiled Cranny]);
		return true;
	}

	if(get_property("cyrptTotalEvilness").to_int() <= 0)
	{
		if(my_primestat() == $stat[Muscle])
		{
			buyUpTo(1, $item[Ben-Gal&trade; Balm]);
			buffMaintain($effect[Go Get \'Em\, Tiger!], 0, 1, 1);
			buyUpTo(1, $item[Blood of the Wereseal]);
			buffMaintain($effect[Temporary Lycanthropy], 0, 1, 1);
		}

		acquireHP();
		set_property("choiceAdventure527", 1);
		if(auto_have_familiar($familiar[Machine Elf]))
		{
			handleFamiliar($familiar[Machine Elf]);
		}
		if (isActuallyEd())
		{
			auto_change_mcd(10); // get vertebra to make the necklace.
		}
		boolean tryBoner = autoAdv(1, $location[Haert of the Cyrpt]);
		council();
		cli_execute("refresh quests");
		if(item_amount($item[chest of the bonerdagon]) == 1)
		{
			set_property("auto_crypt", "finished");
			use(1, $item[chest of the bonerdagon]);
			auto_badassBelt(); // mafia doesn't make this any more even if autoCraft = true for some random reason so lets do it manually.
		}
		else if(get_property("questL07Cyrptic") == "finished")
		{
			auto_log_warning("Looks like we don't have the chest of the bonerdagon but KoLmafia marked Cyrpt quest as finished anyway. Probably some weird path shenanigans.", "red");
			set_property("auto_crypt", "finished");
		}
		else if(!tryBoner)
		{
			auto_log_warning("We tried to kill the Bonerdagon because the cyrpt was defiled but couldn't adventure there and the chest of the bonerdagon is gone so we can't check that. Anyway, we are going to assume the cyrpt is done now.", "red");
			set_property("auto_crypt", "finished");
		}
		else
		{
			abort("Failed to kill bonerdagon");
		}
		return true;
	}
	return false;
}

boolean LX_hardcoreFoodFarm()
{
	if(!in_hardcore() || !isGuildClass())
	{
		return false;
	}
	if(my_fullness() >= 11)
	{
		return false;
	}

	if(my_level() < 8)
	{
		return false;
	}

	// If we are in TCRS we don't know what food is good, we don't want to waste adv.
	if(in_tcrs())
	{
		return false;
	}

	int possMeals = item_amount($item[Goat Cheese]);
	possMeals = possMeals + item_amount($item[Bubblin\' Crude]);

	if((my_fullness() >= 5) && (possMeals > 0))
	{
		return false;
	}
	if(possMeals > 1)
	{
		return false;
	}

	if((my_daycount() >= 3) && (my_adventures() > 15))
	{
		return false;
	}
	if(my_daycount() >= 4)
	{
		return false;
	}

	if((my_level() >= 9) && ((get_property("auto_highlandlord") == "start") || (get_property("auto_highlandlord") == "finished")))
	{
		autoAdv(1, $location[Oil Peak]);
		return true;
	}
	if(my_level() >= 8)
	{
		if(get_property("_sourceTerminalDuplicateUses").to_int() == 0)
		{
			auto_sourceTerminalEducate($skill[Extract], $skill[Duplicate]);
		}
		autoAdv(1, $location[The Goatlet]);
		auto_sourceTerminalEducate($skill[Extract], $skill[Portscan]);
	}

	return false;
}

boolean L6_friarsGetParts()
{
	if((my_level() < 6) || (get_property("auto_friars") != "") || (my_adventures() == 0))
	{
		return false;
	}
	if((my_mp() > 50) || considerGrimstoneGolem(true))
	{
		handleBjornify($familiar[Grimstone Golem]);
	}

	buffMaintain($effect[Snow Shoes], 0, 1, 1);
	buffMaintain($effect[Gummed Shoes], 0, 1, 1);

	if($location[The Dark Heart of the Woods].turns_spent == 0)
	{
		visit_url("friars.php?action=friars&pwd=");
	}

	handleFamiliar("item");
	if(equipped_item($slot[Shirt]) == $item[Tunac])
	{
		autoEquip($slot[Shirt], $item[none]);
	}

	providePlusNonCombat(25);

	if(auto_have_familiar($familiar[Space Jellyfish]) && (get_property("_spaceJellyfishDrops").to_int() < 2))
	{
		handleFamiliar($familiar[Space Jellyfish]);
	}

	if((my_class() == $class[Gelatinous Noob]) && auto_have_familiar($familiar[Robortender]))
	{
		if(!have_skill($skill[Frown Muscles]) && (item_amount($item[Bottle of Novelty Hot Sauce]) == 0))
		{
			handleFamiliar($familiar[Robortender]);
		}
	}

	if(item_amount($item[box of birthday candles]) == 0)
	{
		auto_log_info("Getting Box of Birthday Candles", "blue");
		autoAdv(1, $location[The Dark Heart of the Woods]);
		return true;
	}

	if(item_amount($item[dodecagram]) == 0)
	{
		auto_log_info("Getting Dodecagram", "blue");
		autoAdv(1, $location[The Dark Neck of the Woods]);
		return true;
	}
	if(item_amount($item[eldritch butterknife]) == 0)
	{
		auto_log_info("Getting Eldritch Butterknife", "blue");
		autoAdv(1, $location[The Dark Elbow of the Woods]);
		return true;
	}
	auto_log_info("Finishing friars", "blue");
	visit_url("friars.php?action=ritual&pwd");
	council();
	set_property("auto_friars", "finished"); # used to be done, but no longer need hot wings
	return true;
}

boolean LX_steelOrgan()
{
	if(!get_property("auto_getSteelOrgan").to_boolean())
	{
		return false;
	}
	if((get_property("auto_friars") != "done") && (get_property("auto_friars") != "finished"))
	{
		return false;
	}
	if(my_adventures() == 0)
	{
		return false;
	}
	if($classes[Ed, Gelatinous Noob, Vampyre] contains my_class())
	{
		auto_log_info(my_class() + " can not use a Steel Organ, turning off setting.", "blue");
		set_property("auto_getSteelOrgan", false);
		return false;
	}
	if((auto_my_path() == "Nuclear Autumn") || (auto_my_path() == "License to Adventure"))
	{
		auto_log_info("You could get a Steel Organ for aftercore, but why? We won't help with this deviant and perverse behavior. Turning off setting.", "blue");
		set_property("auto_getSteelOrgan", false);
		return false;
	}
	if(my_path() == "Avatar of West of Loathing")
	{
		if((get_property("awolPointsCowpuncher").to_int() < 7) || (get_property("awolPointsBeanslinger").to_int() < 1) || (get_property("awolPointsSnakeoiler").to_int() < 5))
		{
			set_property("auto_getSteelOrgan", false);
			return false;
		}
	}

	if(have_skill($skill[Liver of Steel]) || have_skill($skill[Stomach of Steel]) || have_skill($skill[Spleen of Steel]))
	{
		auto_log_info("We have a steel organ, turning off the setting." ,"blue");
		set_property("auto_getSteelOrgan", false);
		return false;
	}
	if(get_property("questM10Azazel") != "finished")
	{
		auto_log_info("I am hungry for some steel.", "blue");
	}

	if(have_effect($effect[items.enh]) == 0)
	{
		auto_sourceTerminalEnhance("items");
	}

	if(get_property("questM10Azazel") == "unstarted")
	{
		string temp = visit_url("pandamonium.php");
		temp = visit_url("pandamonium.php?action=moan");
		temp = visit_url("pandamonium.php?action=infe");
		temp = visit_url("pandamonium.php?action=sven");
		temp = visit_url("pandamonium.php?action=sven");
		temp = visit_url("pandamonium.php?action=beli");
		temp = visit_url("pandamonium.php?action=mourn");
	}
	if(get_property("questM10Azazel") == "started")
	{
		if(((item_amount($item[Observational Glasses]) == 0) || (item_amount($item[Imp Air]) < 5)) && (item_amount($item[Azazel\'s Tutu]) == 0))
		{
			if(item_amount($item[Observational Glasses]) == 0)
			{
				uneffect($effect[The Sonata of Sneakiness]);
				buffMaintain($effect[Hippy Stench], 0, 1, 1);
				buffMaintain($effect[Carlweather\'s Cantata of Confrontation], 10, 1, 1);
				buffMaintain($effect[Musk of the Moose], 10, 1, 1);
				# Should we check for -NC stuff and deal with it?
				# We need a Combat Modifier controller
			}
			if(item_amount($item[Imp Air]) >= 5)
			{
				handleFamiliar($familiar[Jumpsuited Hound Dog]);
			}
			else
			{
				handleFamiliar("item");
			}
			autoAdv(1, $location[The Laugh Floor]);
		}
		else if(((item_amount($item[Azazel\'s Unicorn]) == 0) || (item_amount($item[Bus Pass]) < 5)) && (item_amount($item[Azazel\'s Tutu]) == 0))
		{
			int jim = 0;
			int flargwurm = 0;
			int bognort = 0;
			int stinkface = 0;
			int need = 4;
			if(item_amount($item[Comfy Pillow]) > 0)
			{
				jim = to_int($item[Comfy Pillow]);
				need -= 1;
			}
			if(item_amount($item[Booze-Soaked Cherry]) > 0)
			{
				flargwurm = to_int($item[Booze-Soaked Cherry]);
				need -= 1;
			}
			if(item_amount($item[Giant Marshmallow]) > 0)
			{
				bognort = to_int($item[Giant Marshmallow]);
				need -= 1;
			}
			if(item_amount($item[Beer-Scented Teddy Bear]) > 0)
			{
				stinkface = to_int($item[Beer-Scented Teddy Bear]);
				need -= 1;
			}
			if(need > 0)
			{
				int cake = item_amount($item[Sponge Cake]);
				if((jim == 0) && (cake > 0))
				{
					jim = to_int($item[Sponge Cake]);
					need -= 1;
					cake -= 1;
				}
				if((flargwurm == 0) && (cake > 0))
				{
					flargwurm = to_int($item[Sponge Cake]);
					need -= 1;
					cake -= 1;
				}
				int paper = item_amount($item[Gin-Soaked Blotter Paper]);
				if((bognort == 0) && (paper > 0))
				{
					bognort = to_int($item[Gin-Soaked Blotter Paper]);
					need -= 1;
					paper -= 1;
				}
				if((stinkface == 0) && (paper > 0))
				{
					stinkface = to_int($item[Gin-Soaked Blotter Paper]);
					need -= 1;
					paper -= 1;
				}
			}


			if((need == 0) && (item_amount($item[Azazel\'s Unicorn]) == 0))
			{
				string temp = visit_url("pandamonium.php?action=sven");
				visit_url("pandamonium.php?action=sven&bandmember=Jim&togive=" + jim + "&preaction=try");
				temp = visit_url("pandamonium.php?action=sven");
				visit_url("pandamonium.php?action=sven&bandmember=Flargwurm&togive=" + flargwurm + "&preaction=try");
				temp = visit_url("pandamonium.php?action=sven");
				visit_url("pandamonium.php?action=sven&bandmember=Bognort&togive=" + bognort + "&preaction=try");
				temp = visit_url("pandamonium.php?action=sven");
				visit_url("pandamonium.php?action=sven&bandmember=Stinkface&togive=" + stinkface + "&preaction=try");
				return true;
			}

			if(item_amount($item[Azazel\'s Unicorn]) == 0)
			{
				uneffect($effect[Carlweather\'s Cantata of Confrontation]);
				buffMaintain($effect[The Sonata of Sneakiness], 20, 1, 1);
				buffMaintain($effect[Smooth Movements], 10, 1, 1);
			}
			else
			{
				uneffect($effect[The Sonata of Sneakiness]);
			}
			handleFamiliar("item");
			autoAdv(1, $location[Infernal Rackets Backstage]);
		}
		else if((item_amount($item[Azazel\'s Lollipop]) == 0) && (item_amount($item[Azazel\'s Tutu]) == 0))
		{
			foreach it in $items[Hilarious Comedy Prop, Victor\, the Insult Comic Hellhound Puppet, Observational Glasses]
			{
				if(item_amount(it) > 0)
				{
					string temp = visit_url("pandamonium.php?action=mourn&whichitem=" + to_int(it) + "&pwd=");
				}
				else
				{
					if(available_amount(it) == 0)
					{
						abort("Somehow we do not have " + it + " at this point...");
					}
				}
			}
		}
		else if((item_amount($item[Azazel\'s Tutu]) == 0) && (item_amount($item[Bus Pass]) >= 5) && (item_amount($item[Imp Air]) >= 5))
		{
			string temp = visit_url("pandamonium.php?action=moan");
		}
		else if((item_amount($item[Azazel\'s Tutu]) > 0) && (item_amount($item[Azazel\'s Lollipop]) > 0) && (item_amount($item[Azazel\'s Unicorn]) > 0))
		{
			string temp = visit_url("pandamonium.php?action=temp");
		}
		else
		{
			auto_log_warning("Stuck in the Steel Organ quest and can't continue, moving on.", "red");
			set_property("auto_getSteelOrgan", false);
		}
		return true;
	}
	else if(get_property("questM10Azazel") == "finished")
	{
		auto_log_info("Considering Steel Organ consumption.....", "blue");
		if((item_amount($item[Steel Lasagna]) > 0) && (fullness_left() >= $item[Steel Lasagna].fullness))
		{
			eatsilent(1, $item[Steel Lasagna]);
		}
		boolean wontBeOverdrunk = inebriety_left() >= $item[Steel Margarita].inebriety - 5;
		boolean notOverdrunk = my_inebriety() <= inebriety_limit();
		boolean notSavingForBilliards = hasSpookyravenLibraryKey() || get_property("lastSecondFloorUnlock").to_int() == my_ascensions();
		if((item_amount($item[Steel Margarita]) > 0) && wontBeOverdrunk && notOverdrunk && (notSavingForBilliards || my_inebriety() + $item[Steel Margarita].inebriety <= 10 || my_inebriety() >= 12))
		{
			autoDrink(1, $item[Steel Margarita]);
		}
		if((item_amount($item[Steel-Scented Air Freshener]) > 0) && (spleen_left() >= 5))
		{
			autoChew(1, $item[Steel-Scented Air Freshener]);
		}
	}
	return false;
}

boolean L9_leafletQuest()
{
	if((my_level() < 9) || possessEquipment($item[Giant Pinky Ring]))
	{
		return false;
	}
	if (isActuallyEd() || in_koe())
	{
		return false;
	}
	if(auto_get_campground() contains $item[Frobozz Real-Estate Company Instant House (TM)])
	{
		return false;
	}
	if(item_amount($item[Frobozz Real-Estate Company Instant House (TM)]) > 0)
	{
		return false;
	}
	auto_log_info("Got a leaflet to do", "blue");
	council();
	cli_execute("leaflet");
	use(1, $item[Frobozz Real-Estate Company Instant House (TM)]);
	return true;
}

boolean L8_trapperGround()
{
	if(get_property("auto_trapper") != "start")
	{
		return false;
	}

	item oreGoal = to_item(get_property("trapperOre"));

	if((item_amount(oreGoal) >= 3) && (item_amount($item[Goat Cheese]) >= 3))
	{
		auto_log_info("Giving Trapper goat cheese and " + oreGoal, "blue");
		set_property("auto_trapper", "yeti");
		visit_url("place.php?whichplace=mclargehuge&action=trappercabin");
		return true;
	}

	if(item_amount($item[Goat Cheese]) < 3)
	{
		auto_log_info("Yay for goat cheese!", "blue");
		handleFamiliar("item");
		if(get_property("_sourceTerminalDuplicateUses").to_int() == 0)
		{
			auto_sourceTerminalEducate($skill[Extract], $skill[Duplicate]);
		}
		autoAdv(1, $location[The Goatlet]);
		auto_sourceTerminalEducate($skill[Extract], $skill[Portscan]);
		return true;
	}

	if(item_amount(oreGoal) >= 3)
	{
		if(item_amount($item[Goat Cheese]) >= 3)
		{
			auto_log_info("Giving Trapper goat cheese and " + oreGoal, "blue");
			set_property("auto_trapper", "yeti");
			visit_url("place.php?whichplace=mclargehuge&action=trappercabin");
			return true;
		}
		auto_log_info("Yay for goat cheese!", "blue");
		handleFamiliar("item");
		if(get_property("_sourceTerminalDuplicateUses").to_int() == 0)
		{
			auto_sourceTerminalEducate($skill[Extract], $skill[Duplicate]);
		}
		autoAdv(1, $location[The Goatlet]);
		auto_sourceTerminalEducate($skill[Extract], $skill[Portscan]);
		return true;
	}
	else if((my_rain() > 50) && (have_effect($effect[Ultrahydrated]) == 0) && (auto_my_path() == "Heavy Rains") && have_skill($skill[Rain Man]))
	{
		auto_log_info("Trying to summon a mountain man", "blue");
		set_property("auto_mountainmen", "1");
		return rainManSummon("mountain man", false, false);
	}
	else if(auto_my_path() == "Heavy Rains")
	{
		#Do pulls instead if we don't possess rain man?
		auto_log_info("Need Ore but not enough rain", "blue");
		return false;
	}
	else if(!in_hardcore())
	{
		if(pulls_remaining() >= (3 - item_amount(oreGoal)))
		{
			pullXWhenHaveY(oreGoal, 3 - item_amount(oreGoal), item_amount(oreGoal));
			return true;
		}
	}
	else if (canGenieCombat() && (get_property("auto_useWishes").to_boolean()) && (catBurglarHeistsLeft() >= 2))
	{
		auto_log_info("Trying to wish for a mountain man, which the cat will then burgle, hopefully.");
		handleFamiliar("item");
		handleFamiliar($familiar[cat burglar]);
		return makeGenieCombat($monster[mountain man]);
	}
	else if((my_level() >= 12) && in_hardcore())
	{
		int numCloversKeep = 0;
		if(get_property("auto_wandOfNagamar").to_boolean())
		{
			numCloversKeep = 1;
			if(get_property("auto_powerLevelLastLevel").to_int() == my_level())
			{
				numCloversKeep = 0;
			}
		}
		if(auto_my_path() == "Nuclear Autumn")
		{
			if(cloversAvailable() <= numCloversKeep)
			{
				handleBarrelFullOfBarrels(false);
				string temp = visit_url("barrel.php");
				temp = visit_url("choice.php?whichchoice=1099&pwd=&option=2");
				handleBarrelFullOfBarrels(false);
				return true;
			}
		}
		if(cloversAvailable() > numCloversKeep)
		{
			cloverUsageInit();
			autoAdvBypass(270, $location[Itznotyerzitz Mine]);
			cloverUsageFinish();
			return true;
		}
	}
	return false;
}

boolean LX_guildUnlock()
{
	if(!isGuildClass() || guild_store_available())
	{
		return false;
	}
	if((auto_my_path() == "Nuclear Autumn") || (auto_my_path() == "Pocket Familiars"))
	{
		return false;
	}
	auto_log_info("Let's unlock the guild.", "green");

	string pref;
	location loc = $location[None];
	item goal = $item[none];
	switch(my_primestat())
	{
		case $stat[Muscle] :
			set_property("choiceAdventure111", "3");//Malice in Chains -> Plot a cunning escape
			set_property("choiceAdventure113", "2");//Knob Goblin BBQ -> Kick the chef
			set_property("choiceAdventure118", "2");//When Rocks Attack -> "Sorry, gotta run."
			set_property("choiceAdventure120", "4");//Ennui is Wasted on the Young -> "Since you\'re bored, you\'re boring. I\'m outta here."
			set_property("choiceAdventure543", "1");//Up In Their Grill -> Grab the sausage, so to speak. I mean... literally.
			pref = "questG09Muscle";
			loc = $location[The Outskirts of Cobb\'s Knob];
			goal = $item[11-Inch Knob Sausage];
			break;
		case $stat[Mysticality]:
			set_property("choiceAdventure115", "1");//Oh No, Hobo -> Give him a beating
			set_property("choiceAdventure116", "4");//The Singing Tree (Rustling) -> "No singing, thanks."
			set_property("choiceAdventure117", "1");//Trespasser -> Tackle him
			set_property("choiceAdventure114", "2");//The Baker\'s Dilemma -> "Sorry, I\'m busy right now."
			set_property("choiceAdventure544", "1");//A Sandwich Appears! -> sudo exorcise me a sandwich
			pref = "questG07Myst";
			loc = $location[The Haunted Pantry];
			goal = $item[Exorcised Sandwich];
			break;
		case $stat[Moxie]:
			goal = equipped_item($slot[pants]);
			set_property("choiceAdventure108", "4");//Aww, Craps -> Walk Away
			set_property("choiceAdventure109", "1");//Dumpster Diving -> Punch the hobo
			set_property("choiceAdventure110", "4");//The Entertainer -> Introduce them to avant-garde
			set_property("choiceAdventure112", "2");//Please, Hammer -> "Sorry, no time."
			set_property("choiceAdventure121", "2");//Under the Knife -> Umm, no thanks. Seriously.
			set_property("choiceAdventure542", "1");//Now\'s Your Pants! I Mean... Your Chance! -> Yoink
			pref = "questG08Moxie";
			if(goal != $item[none])
			{
				loc = $location[The Sleazy Back Alley];
			}
			break;
	}
	if(loc != $location[none])
	{
		if(get_property(pref) != "started")
		{
			string temp = visit_url("guild.php?place=challenge");
		}
		if(internalQuestStatus(pref) < 0)
		{
			auto_log_warning("Visiting the guild failed to set guild quest.", "red");
			return false;
		}

		autoAdv(1, loc);
		if(item_amount(goal) > 0)
		{
			visit_url("guild.php?place=challenge");
		}
		return true;
	}
	return false;
}

boolean L8_trapperStart()
{
	if((my_level() < 8) || (get_property("auto_trapper") != ""))
	{
		return false;
	}
	council();
	auto_log_info("Let's meet the trapper.", "blue");

	visit_url("place.php?whichplace=mclargehuge&action=trappercabin");
	set_property("auto_trapper", "start");
	return true;
}

boolean L5_findKnob()
{
	if((my_level() >= 5) && (item_amount($item[Knob Goblin Encryption Key]) == 1))
	{
		if(item_amount($item[Cobb\'s Knob Map]) == 0)
		{
			council();
		}
		use(1, $item[Cobb\'s Knob Map]);
		return true;
	}
	return false;
}

boolean L5_goblinKing()
{
	if(get_property("auto_goblinking") == "finished")
	{
		return false;
	}
	if (my_level() < 8 && get_property("auto_powerLevelAdvCount").to_int() < 9)
	{
		return false;
	}
	if(my_adventures() <= 2)
	{
		return false;
	}
	if(get_counters("Fortune Cookie", 0, 3) == "Fortune Cookie")
	{
		return false;
	}
	if(!have_outfit("Knob Goblin Harem Girl Disguise"))
	{
		return false;
	}

	auto_log_info("Death to the gobbo!!", "blue");
	if(!autoOutfit("knob goblin harem girl disguise"))
	{
		abort("Could not put on Knob Goblin Harem Girl Disguise, aborting");
	}
	buffMaintain($effect[Knob Goblin Perfume], 0, 1, 1);
	if(have_effect($effect[Knob Goblin Perfume]) == 0)
	{
		autoAdv(1, $location[Cobb\'s Knob Harem]);
		if(contains_text(get_property("lastEncounter"), "Cobb's Knob lab key"))
		{
			autoAdv(1, $location[Cobb\'s Knob Harem]);
		}
		return true;
	}

	if(my_primestat() == $stat[Muscle])
	{
		buyUpTo(1, $item[Ben-Gal&trade; Balm]);
		buffMaintain($effect[Go Get \'Em\, Tiger!], 0, 1, 1);
	}
	buyUpTo(1, $item[Hair Spray]);
	buffMaintain($effect[Butt-Rock Hair], 0, 1, 1);

	if((my_class() == $class[Seal Clubber]) || (my_class() == $class[Turtle Tamer]))
	{
		buyUpTo(1, $item[Blood of the Wereseal]);
		buffMaintain($effect[Temporary Lycanthropy], 0, 1, 1);
	}

	if(monster_level_adjustment() > 150)
	{
		autoEquip($slot[acc2], $item[none]);
	}

	autoAdv(1, $location[Throne Room]);

	if((item_amount($item[Crown of the Goblin King]) > 0) || (item_amount($item[Glass Balls of the Goblin King]) > 0) || (item_amount($item[Codpiece of the Goblin King]) > 0) || (get_property("questL05Goblin") == "finished"))
	{
		set_property("auto_goblinking", "finished");
		council();
	}
	return true;
}

boolean L4_batCave()
{
	if(get_property("auto_bat") == "finished")
	{
		return false;
	}
	if(my_level() < 4)
	{
		return false;
	}

	auto_log_info("In the bat hole!", "blue");
	if(considerGrimstoneGolem(true))
	{
		handleBjornify($familiar[Grimstone Golem]);
	}
	buffMaintain($effect[Fishy Whiskers], 0, 1, 1);

	int batStatus = internalQuestStatus("questL04Bat");
	if((item_amount($item[Sonar-In-A-Biscuit]) > 0) && (batStatus < 3))
	{
		use(1, $item[Sonar-In-A-Biscuit]);
		visit_url("place.php?whichplace=bathole"); // ensure quest status is updated.
		return true;
	}

	if(batStatus >= 4)
	{
		if (item_amount($item[Enchanted Bean]) == 0 && !get_property("auto_bean").to_boolean() && !isActuallyEd())
		{
			autoAdv(1, $location[The Beanbat Chamber]);
			return true;
		}
		set_property("auto_bat", "finished");
		council();
		if (in_koe())
		{
			cli_execute("refresh quests");
		}
		return true;
	}
	if(batStatus >= 3)
	{
		buffMaintain($effect[Polka of Plenty], 15, 1, 1);
		bat_formWolf();
		addToMaximize("10meat");
		int batskinBelt = item_amount($item[Batskin Belt]);
		if (isActuallyEd())
		{
			auto_change_mcd(4); // get the pants from the Boss Bat.
		}
		autoAdv(1, $location[The Boss Bat\'s Lair]);
		# DIGIMON remove once mafia tracks this
		if(item_amount($item[Batskin Belt]) != batskinBelt)
		{
			set_property("auto_bat", "finished");
			auto_badassBelt(); // mafia doesn't make this any more even if autoCraft = true for some random reason so lets do it manually.
		}
		return true;
	}
	if(batStatus >= 2)
	{
		bat_formBats();
		if (item_amount($item[Enchanted Bean]) == 0 && !get_property("auto_bean").to_boolean() && !isActuallyEd())
		{
			autoAdv(1, $location[The Beanbat Chamber]);
			return true;
		}
		autoAdv(1, $location[The Batrat and Ratbat Burrow]);
		return true;
	}
	if(batStatus >= 1)
	{
		bat_formBats();
		autoAdv(1, $location[The Batrat and Ratbat Burrow]);
		return true;
	}

	buffMaintain($effect[Hide of Sobek], 10, 1, 1);
	buffMaintain($effect[Astral Shell], 10, 1, 1);
	buffMaintain($effect[Elemental Saucesphere], 10, 1, 1);
	buffMaintain($effect[Spectral Awareness], 10, 1, 1);
	if(elemental_resist($element[stench]) < 1)
	{
		if(!useMaximizeToEquip())
		{
			if(possessEquipment($item[Knob Goblin Harem Veil]))
			{
				equip($item[Knob Goblin Harem Veil]);
			}
			else if(item_amount($item[Pine-Fresh Air Freshener]) > 0)
			{
				equip($slot[Acc3], $item[Pine-Fresh Air Freshener]);
			}
			else
			{
				if(get_property("auto_powerLevelAdvCount").to_int() >= 5)
				{
					bat_formBats();
					autoAdv(1, $location[The Bat Hole Entrance]);
					return true;
				}
				auto_log_warning("I can nae handle the stench of the Guano Junction!", "green");
				return false;
			}
		}
		else
		{
			boolean success = simMaximizeWith("stench res 1max 1min");
			if(success)
			{
				addToMaximize("stench res 1max 1min");
			}
			else
			{
				auto_log_warning("I can nae handle the stench of the Guano Junction!", "green");
				return false;
			}
		}
	}

	if (cloversAvailable() > 0 && batStatus <= 1)
	{
		cloverUsageInit();
		autoAdvBypass(31, $location[Guano Junction]);
		cloverUsageFinish();
		return true;
	}

	bat_formBats();
	autoAdv(1, $location[Guano Junction]);
	return true;
}

boolean LX_craftAcquireItems()
{
	if((item_amount($item[Ten-Leaf Clover]) > 0) && glover_usable($item[Ten-Leaf Clover]))
	{
		use(item_amount($item[Ten-Leaf Clover]), $item[Ten-Leaf Clover]);
	}

	if(get_property("questM22Shirt") == "unstarted")
	{
		januaryToteAcquire($item[Letter For Melvign The Gnome]);
		if(possessEquipment($item[Makeshift Garbage Shirt]))
		{
			string temp = visit_url("inv_equip.php?pwd&which=2&action=equip&whichitem=" + to_int($item[Makeshift Garbage Shirt]));
		}
	}

	if((get_property("lastGoofballBuy").to_int() != my_ascensions()) && (internalQuestStatus("questL03Rat") >= 0))
	{
		visit_url("place.php?whichplace=woods");
		auto_log_info("Gotginb Goofballs", "blue");
		visit_url("tavern.php?place=susguy&action=buygoofballs", true);
		put_closet(item_amount($item[Bottle of Goofballs]), $item[Bottle of Goofballs]);
	}

	auto_floundryUse();

	if(in_hardcore())
	{
		if(have_effect($effect[Adventurer\'s Best Friendship]) > 120)
		{
			set_property("choiceAdventure1106", 3);
		}
		else
		{
			set_property("choiceAdventure1106", 2);
		}
	}
	else
	{
		if((have_effect($effect[Adventurer\'s Best Friendship]) > 30) && auto_have_familiar($familiar[Mosquito]))
		{
			set_property("choiceAdventure1106", 3);
		}
		else
		{
			set_property("choiceAdventure1106", 2);
		}
	}

	// Snow Berries can be acquired out of standard by using Van Keys from NEP. We need to check to make sure they are usable.
	if(auto_is_valid($item[snow berries]))
	{
		if((item_amount($item[snow berries]) == 3) && (my_daycount() == 1) && get_property("auto_grimstoneFancyOilPainting").to_boolean())
		{
			cli_execute("make 1 snow cleats");
		}

		if((item_amount($item[snow berries]) > 0) && (my_daycount() > 1) && (get_property("chasmBridgeProgress").to_int() >= 30) && (my_level() >= 9))
		{
			visit_url("place.php?whichplace=orc_chasm");
			if(get_property("chasmBridgeProgress").to_int() >= 30)
			{
				#if(in_hardcore() && isGuildClass())
				if(isGuildClass())
				{
					if((item_amount($item[Snow Berries]) >= 3) && (item_amount($item[Ice Harvest]) >= 3) && (item_amount($item[Unfinished Ice Sculpture]) == 0))
					{
						cli_execute("make 1 Unfinished Ice Sculpture");
					}
					if((item_amount($item[Snow Berries]) >= 2) && (item_amount($item[Snow Crab]) == 0))
					{
						cli_execute("make 1 Snow Crab");
					}
				}
				#cli_execute("make " + item_amount($item[snow berries]) + " snow cleats");
			}
			else
			{
				abort("Bridge progress came up as >= 30 but is no longer after viewing the page.");
			}
		}
	}

	if(knoll_available() && (item_amount($item[Detuned Radio]) == 0) && (my_meat() >= npc_price($item[Detuned Radio])) && (auto_my_path() != "G-Lover"))
	{
		buyUpTo(1, $item[Detuned Radio]);
		auto_setMCDToCap();
		visit_url("choice.php?pwd&whichchoice=835&option=2", true);
	}

	if((my_adventures() <= 3) && (my_daycount() == 1) && in_hardcore())
	{
		if(LX_meatMaid())
		{
			return true;
		}
	}

	#Can we have some other way to check that we have AT skills? Checking all skills just to be sure.
	if((item_amount($item[Antique Accordion]) == 0) && (item_amount($item[Aerogel Accordion]) == 0) && isUnclePAvailable() && (my_meat() >= npc_price($item[Antique Accordion])) && (auto_predictAccordionTurns() < 10) && (auto_my_path() != "G-Lover"))
	{
		boolean buyAntiqueAccordion = false;

	foreach SongCheck in ATSongList()
		{
			if(have_skill(SongCheck))
			{
				buyAntiqueAccordion = true;
			}
		}

		if(buyAntiqueAccordion)
		{
			buyUpTo(1, $item[Antique Accordion]);
		}
	}

	if((my_meat() > 7500) && (item_amount($item[Seal Tooth]) == 0))
	{
		acquireHermitItem($item[Seal Tooth]);
	}

	if(my_class() == $class[Turtle Tamer])
	{
		if(!possessEquipment($item[Turtle Wax Shield]) && (item_amount($item[Turtle Wax]) > 0))
		{
			use(1, $item[Turtle Wax]);
		}
		if(have_skill($skill[Armorcraftiness]) && !possessEquipment($item[Painted Shield]) && (my_meat() > 3500) && (item_amount($item[Painted Turtle]) > 0) && (item_amount($item[Tenderizing Hammer]) > 0))
		{
			// Make Painted Shield - Requires an Adventure
		}
		if(have_skill($skill[Armorcraftiness]) && !possessEquipment($item[Spiky Turtle Shield]) && (my_meat() > 3500) && (item_amount($item[Hedgeturtle]) > 1) && (item_amount($item[Tenderizing Hammer]) > 0))
		{
			// Make Spiky Turtle Shield - Requires an Adventure
		}
	}
	if((get_power(equipped_item($slot[pants])) < 70) && !possessEquipment($item[Demonskin Trousers]) && (my_meat() >= npc_price($item[Pants Kit])) && (item_amount($item[Demon Skin]) > 0) && (item_amount($item[Tenderizing Hammer]) > 0) && knoll_available())
	{
		buyUpTo(1, $item[Pants Kit]);
		autoCraft("smith", 1, $item[Pants Kit], $item[Demon Skin]);
	}
	if(!possessEquipment($item[Tighty Whiteys]) && (my_meat() >= npc_price($item[Pants Kit])) && (item_amount($item[White Snake Skin]) > 0) && (item_amount($item[Tenderizing Hammer]) > 0) && knoll_available())
	{
		buyUpTo(1, $item[Pants Kit]);
		autoCraft("smith", 1, $item[Pants Kit], $item[White Snake Skin]);
	}

	if(!possessEquipment($item[Grumpy Old Man Charrrm Bracelet]) && (item_amount($item[Jolly Roger Charrrm Bracelet]) > 0) && (item_amount($item[Grumpy Old Man Charrrm]) > 0))
	{
		use(1, $item[Jolly Roger Charrrm Bracelet]);
		use(1, $item[Grumpy Old Man Charrrm]);
	}

	if(!possessEquipment($item[Booty Chest Charrrm Bracelet]) && (item_amount($item[Jolly Roger Charrrm Bracelet]) > 0) && (item_amount($item[Booty Chest Charrrm]) > 0))
	{
		use(1, $item[Jolly Roger Charrrm Bracelet]);
		use(1, $item[Booty Chest Charrrm]);
	}

	if((item_amount($item[Magical Baguette]) > 0) && !possessEquipment($item[Loafers]))
	{
		visit_url("inv_use.php?pwd=&which=1&whichitem=8167");
		run_choice(2);
	}
	if((item_amount($item[Magical Baguette]) > 0) && !possessEquipment($item[Bread Basket]))
	{
		visit_url("inv_use.php?pwd=&which=1&whichitem=8167");
		run_choice(3);
	}
	if((item_amount($item[Magical Baguette]) > 0) && !possessEquipment($item[Breadwand]))
	{
		visit_url("inv_use.php?pwd=&which=1&whichitem=8167");
		run_choice(1);
	}

	if(knoll_available() && (have_skill($skill[Torso Awaregness]) || have_skill($skill[Best Dressed])) && (item_amount($item[Demon Skin]) > 0) && !possessEquipment($item[Demonskin Jacket]))
	{
		//Demonskin Jacket, requires an adventure, knoll available doesn\'t matter here...
	}

	if((in_koe() && creatable_amount($item[Antique Accordion]) > 0 && !possessEquipment($item[Antique Accordion])) && (auto_predictAccordionTurns() < 10))
	{
		retrieve_item(1, $item[Antique Accordion]);
	}

	LX_dolphinKingMap();
	auto_mayoItems();

	if(item_amount($item[Metal Meteoroid]) > 0 && !in_tcrs())
	{
		item it = $item[Meteorthopedic Shoes];
		if(!possessEquipment(it))
		{
			int choice = 1 + to_int(it) - to_int($item[Meteortarboard]);
			string temp = visit_url("inv_use.php?pwd=&which=3&whichitem=9516");
			temp = visit_url("choice.php?pwd=&whichchoice=1264&option=" + choice);
		}

		it = $item[Meteortarboard];
		if(!possessEquipment(it) && (get_power(equipped_item($slot[Hat])) < 140) && (get_property("auto_beatenUpCount").to_int() >= 5))
		{
			int choice = 1 + to_int(it) - to_int($item[Meteortarboard]);
			string temp = visit_url("inv_use.php?pwd=&which=3&whichitem=9516");
			temp = visit_url("choice.php?pwd=&whichchoice=1264&option=" + choice);
		}

		it = $item[Meteorite Guard];
		if(!possessEquipment(it) && !possessEquipment($item[Kol Con 13 Snowglobe]) && (get_property("auto_beatenUpCount").to_int() >= 5))
		{
			int choice = 1 + to_int(it) - to_int($item[Meteortarboard]);
			string temp = visit_url("inv_use.php?pwd=&which=3&whichitem=9516");
			temp = visit_url("choice.php?pwd=&whichchoice=1264&option=" + choice);
		}
	}

	if(item_amount($item[Letter For Melvign The Gnome]) > 0)
	{
		use(1, $item[Letter For Melvign The Gnome]);
		if(get_property("questM22Shirt") == "unstarted")
		{
			auto_log_warning("Mafia did not register using the Melvign letter...", "red");
			cli_execute("refresh inv");
			set_property("questM22Shirt", "started");
		}
	}

	if(auto_my_path() != "Community Service")
	{
		if(item_amount($item[Portable Pantogram]) > 0)
		{
			switch(my_daycount())
			{
			case 1:
				pantogramPants(my_primestat(), $element[hot], 1, 1, 1);
				break;
			default:
				pantogramPants(my_primestat(), $element[cold], 1, 2, 1);
				break;
			}
		}
		mummifyFamiliar($familiar[Intergnat], my_primestat());
		mummifyFamiliar($familiar[Hobo Monkey], "meat");
		mummifyFamiliar($familiar[XO Skeleton], "mpregen");
		if((my_primestat() == $stat[Muscle]) && get_property("loveTunnelAvailable").to_boolean() && is_unrestricted($item[Heart-Shaped Crate]) && possessEquipment($item[LOV Eardigan]))
		{
			if((januaryToteTurnsLeft($item[Makeshift Garbage Shirt]) > 0) && (my_session_adv() > 75) && ((januaryToteTurnsLeft($item[Makeshift Garbage Shirt]) + 15) > my_adventures()))
			{
				januaryToteAcquire($item[Makeshift Garbage Shirt]);
			}
			else
			{
				januaryToteAcquire($item[Wad Of Used Tape]);
			}
		}
		else
		{
			if((januaryToteTurnsLeft($item[Makeshift Garbage Shirt]) > 0) && hasTorso() && (my_session_adv() > 75))
			{
				januaryToteAcquire($item[Makeshift Garbage Shirt]);
			}
			else
			{
				januaryToteAcquire($item[Wad Of Used Tape]);
			}
		}
		#set_property("_dailyCreates", true);
	}

	return false;
}

boolean councilMaintenance()
{
	if (auto_my_path() == "Community Service" || in_koe())
	{
		return false;
	}
	if(my_level() > get_property("lastCouncilVisit").to_int())
	{
		council();
		if (isActuallyEd() && my_level() == 11 && item_amount($item[7961]) > 0)
		{
			cli_execute("refresh inv");
		}
		return true;
	}
	return false;
}

boolean adventureFailureHandler()
{
	if(my_location().turns_spent > 52)
	{
		boolean tooManyAdventures = false;
		if (($locations[The Battlefield (Frat Uniform), The Battlefield (Hippy Uniform), The Deep Dark Jungle, The Neverending Party, Noob Cave, Pirates of the Garbage Barges, The Secret Government Laboratory, Sloppy Seconds Diner, The SMOOCH Army HQ, Super Villain\'s Lair, Uncle Gator\'s Country Fun-Time Liquid Waste Sluice, VYKEA, The X-32-F Combat Training Snowman, The Exploaded Battlefield] contains my_location()) == false)
		{
			tooManyAdventures = true;
		}

		if(tooManyAdventures && (my_path() == "The Source"))
		{
			if($locations[The Haunted Ballroom, The Haunted Bathroom, The Haunted Bedroom, The Haunted Gallery] contains my_location())
			{
				tooManyAdventures = false;
			}
		}

		if(tooManyAdventures && isActuallyEd())
		{
			if ($location[Hippy Camp] == my_location())
			{
				tooManyAdventures = false;
			}
		}

		if (get_property("auto_powerLevelAdvCount").to_int() > 20 && my_level() < 13)
		{
			if ($location[The Haunted Gallery] == my_location())
			{
				tooManyAdventures = false;
			}
		}

		if(($locations[The Hidden Hospital, The Penultimate Fantasy Airship] contains my_location()) && (my_location().turns_spent < 100))
		{
			tooManyAdventures = false;
		}

		if(tooManyAdventures)
		{
			if(get_property("auto_newbieOverride").to_boolean())
			{
				set_property("auto_newbieOverride", false);
				auto_log_warning("We have spent " + my_location().turns_spent + " turns at '" + my_location() + "' and that is bad... override accepted.", "red");
			}
			else
			{
				auto_log_critical("You can set auto_newbieOverride = true to bypass this once.", "blue");
				abort("We have spent " + my_location().turns_spent + " turns at '" + my_location() + "' and that is bad... aborting.");
			}
		}
	}

	if(last_monster() == $monster[Crate])
	{
		if(get_property("auto_newbieOverride").to_boolean())
		{
			set_property("auto_newbieOverride", false);
		}
		else
		{
			abort("We went to the Noob Cave for reals... uh oh");
		}
	}
	else
	{
		set_property("auto_newbieOverride", false);
	}
	return false;
}

boolean beatenUpResolution(){

	if(have_effect($effect[Beaten Up]) > 0){
		if(get_property("auto_beatenUpCount").to_int() > 10){
			abort("We are getting beaten up too much, this is not good. Aborting.");
		}
		acquireHP();
	}

	if(have_effect($effect[Beaten Up]) > 0){
		cli_execute("refresh all");
	}
	return have_effect($effect[Beaten Up]) > 0;
}

boolean LX_meatMaid()
{
	if(auto_get_campground() contains $item[Meat Maid])
	{
		return false;
	}
	if(!knoll_available() || (my_daycount() != 1) || (get_property("auto_crypt") != "finished"))
	{
		return false;
	}

	if((item_amount($item[Smart Skull]) > 0) && (item_amount($item[Disembodied Brain]) > 0))
	{
		auto_log_info("Got a brain, trying to make and use a meat maid now.", "blue");
		cli_execute("make meat maid");
		use(1, $item[meat maid]);
		return true;
	}

	if(cloversAvailable() == 0)
	{
		return false;
	}
	if(my_meat() < 320)
	{
		return false;
	}
	auto_log_info("Well, we could make a Meat Maid and that seems raisinable.", "blue");

	if((item_amount($item[Brainy Skull]) == 0) && (item_amount($item[Disembodied Brain]) == 0))
	{
		cloverUsageInit();
		autoAdvBypass(58, $location[The VERY Unquiet Garves]);
		cloverUsageFinish();
		if(get_property("lastEncounter") == "Rolling the Bones")
		{
			auto_log_info("Got a brain, trying to make and use a meat maid now.", "blue");
			cli_execute("make " + $item[Meat Maid]);
			use(1, $item[Meat Maid]);
		}
		if(lastAdventureSpecialNC())
		{
			abort("May be stuck in an interrupting Non-Combat adventure, finish current adventure and resume");
		}
		return true;
	}
	return false;
}

boolean LX_bitchinMeatcar()
{
	if((item_amount($item[Bitchin\' Meatcar]) > 0) || (auto_my_path() == "Nuclear Autumn"))
	{
		return false;
	}
	if(get_property("lastDesertUnlock").to_int() == my_ascensions())
	{
		return false;
	}
	if(in_koe())
	{
		auto_log_info("The desert exploded, so no need to build a meatcar...");
		set_property("lastDesertUnlock", my_ascensions());
		return false;
	}

	int meatRequired = 100;
	if(item_amount($item[Meat Stack]) > 0)
	{
		meatRequired = 0;
	}
	foreach it in $items[Spring, Sprocket, Cog, Empty Meat Tank, Tires, Sweet Rims]
	{
		if(item_amount(it) == 0)
		{
			meatRequired += npc_price(it);
		}
	}

	if(knoll_available())
	{
		if(my_meat() >= meatRequired)
		{
			cli_execute("make bitch");
			cli_execute("place.php?whichplace=desertbeach&action=db_nukehouse");
			return true;
		}
		return false;
	}
	else
	{
		if((my_meat() >= (npc_price($item[Desert Bus Pass]) + 1000)) && isGeneralStoreAvailable())
		{
			auto_log_info("We're rich, let's take the bus instead of building a car.", "blue");
			buyUpTo(1, $item[Desert Bus Pass]);
			if(item_amount($item[Desert Bus Pass]) > 0)
			{
				return true;
			}
		}
		auto_log_info("Farming for a Bitchin' Meatcar", "blue");
		if(get_property("questM01Untinker") == "unstarted")
		{
			visit_url("place.php?whichplace=forestvillage&preaction=screwquest&action=fv_untinker_quest");
		}
		if((item_amount($item[Tires]) == 0) || (item_amount($item[empty meat tank]) == 0) || (item_amount($item[spring]) == 0) ||(item_amount($item[sprocket]) == 0) ||(item_amount($item[cog]) == 0))
		{
			if(!autoAdv(1, $location[The Degrassi Knoll Garage]))
			{
				if(guild_store_available())
				{
					visit_url("guild.php?place=paco");
				}
				else
				{
					abort("Need to farm a Bitchin' Meatcar but guild not available.");
				}
			}
			if(item_amount($item[Gnollish Toolbox]) > 0)
			{
				use(1, $item[Gnollish Toolbox]);
			}
		}
		else
		{
			if(my_meat() >= meatRequired)
			{
				cli_execute("make bitch");
				cli_execute("place.php?whichplace=desertbeach&action=db_nukehouse");
				return true;
			}
			return false;
		}
	}
	return true;
}

boolean LX_desertAlternate()
{
	if(auto_my_path() == "Nuclear Autumn")
	{
		if(my_basestat(my_primestat()) < 25)
		{
			return false;
		}
		if(get_property("questM19Hippy") == "unstarted")
		{
			string temp = visit_url("place.php?whichplace=woods&action=woods_smokesignals");
			temp = visit_url("choice.php?pwd=&whichchoice=798&option=1");
			temp = visit_url("choice.php?pwd=&whichchoice=798&option=2");
			temp = visit_url("woods.php");

			if(get_property("questM19Hippy") == "unstarted")
			{
				abort("Failed to unlock The Old Landfill. Not sure what to do now...");
			}
			return true;
		}
		if((item_amount($item[Old Claw-Foot Bathtub]) > 0) && (item_amount($item[Old Clothesline Pole]) > 0) && (item_amount($item[Antique Cigar Sign]) > 0) && (item_amount($item[Worse Homes and Gardens]) > 0))
		{
			cli_execute("make 1 junk junk");
			string temp = visit_url("place.php?whichplace=woods&action=woods_hippy");
			return true;
		}

		if(item_amount($item[Funky Junk Key]) > 0)
		{
			//We will hit a Once More Unto the Junk adventure now
			if(item_amount($item[Old Claw-Foot Bathtub]) == 0)
			{
				set_property("choiceAdventure794", 1);
				set_property("choiceAdventure795", 1);
			}
			else if(item_amount($item[Old Clothesline Pole]) == 0)
			{
				set_property("choiceAdventure794", 2);
				set_property("choiceAdventure796", 2);
			}
			else if(item_amount($item[Antique Cigar Sign]) == 0)
			{
				set_property("choiceAdventure794", 3);
				set_property("choiceAdventure797", 3);
			}
			return autoAdv($location[The Old Landfill]);
		}
		else
		{
			return autoAdv($location[The Old Landfill]);
		}

	}
	if(knoll_available())
	{
		return false;
	}
	if((my_meat() >= npc_price($item[Desert Bus Pass])) && isGeneralStoreAvailable())
	{
		buyUpTo(1, $item[Desert Bus Pass]);
		if(item_amount($item[Desert Bus Pass]) > 0)
		{
			return true;
		}
	}
	return false;
}

boolean LX_islandAccess()
{
	if(in_koe())
	{
		return false;
	}

	boolean canDesert = (get_property("lastDesertUnlock").to_int() == my_ascensions());

	if((item_amount($item[Shore Inc. Ship Trip Scrip]) >= 3) && (item_amount($item[Dingy Dinghy]) == 0) && (my_meat() >= npc_price($item[dingy planks])) && isGeneralStoreAvailable())
	{
		cli_execute("make dinghy plans");
		buyUpTo(1, $item[dingy planks]);
		use(1, $item[dinghy plans]);
		return true;
	}

	if((item_amount($item[Dingy Dinghy]) > 0) || (get_property("lastIslandUnlock").to_int() == my_ascensions()))
	{
		if(get_property("lastIslandUnlock").to_int() == my_ascensions())
		{
			boolean reallyUnlocked = false;
			foreach it in $items[Dingy Dinghy, Skeletal Skiff, Yellow Submarine]
			{
				if(item_amount(it) > 0)
				{
					reallyUnlocked = true;
				}
			}
			if(get_property("peteMotorbikeGasTank") == "Extra-Buoyant Tank")
			{
				reallyUnlocked = true;
			}
			if(internalQuestStatus("questM19Hippy") >= 3)
			{
				reallyUnlocked = true;
			}
			if(!reallyUnlocked)
			{
				auto_log_warning("lastIslandUnlock is incorrect, you have no way to get to the Island. Unless you barrel smashed when that was allowed. Did you barrel smash? Well, correcting....", "red");
				set_property("lastIslandUnlock", my_ascensions() - 1);
				return true;
			}
		}
		return false;
	}

	if(!canDesert || !isGeneralStoreAvailable())
	{
		return LX_desertAlternate();
	}

	if((my_adventures() <= 9) || (my_meat() <= 1900))
	{
		return false;
	}
	if(get_counters("Fortune Cookie", 0, 9) == "Fortune Cookie")
	{
		//Just check the Fortune Cookie counter not any others.
		return false;
	}

	auto_log_info("At the shore, la de da!", "blue");
	if(item_amount($item[Dinghy Plans]) > 0)
	{
		abort("Dude, we got Dinghy Plans... we should not be here....");
	}
	while((item_amount($item[Shore Inc. Ship Trip Scrip]) < 3) && (my_meat() >= 500) && (item_amount($item[Dinghy Plans]) == 0))
	{
		doVacation();
	}
	if(item_amount($item[Shore Inc. Ship Trip Scrip]) < 3)
	{
		auto_log_warning("Failed to get enough Shore Scrip for some raisin, continuing...", "red");
		return false;
	}

	if((my_meat() >= npc_price($item[dingy planks])) && (item_amount($item[Dinghy Plans]) == 0) && isGeneralStoreAvailable())
	{
		cli_execute("make dinghy plans");
		buyUpTo(1, $item[dingy planks]);
		use(1, $item[dinghy plans]);
		return true;
	}
	return false;
}

boolean LX_phatLootToken()
{
	if(get_property("auto_phatloot").to_int() >= my_daycount())
	{
		return false;
	}
	if(towerKeyCount(false) >= 3)
	{
		return false;
	}
	if(my_adventures() <= 15 - get_property("_lastDailyDungeonRoom").to_int())
	{
		return false;
	}

	if(fantasyRealmToken())
	{
		return true;
	}
	if(fantasyRealmAvailable() && get_property("auto_sorceress") != "door")
	{
		return false;
	}

	if((!possessEquipment($item[Ring of Detect Boring Doors]) || (item_amount($item[Eleven-Foot Pole]) == 0) || (item_amount($item[Pick-O-Matic Lockpicks]) == 0)) && auto_have_familiar($familiar[Gelatinous Cubeling]))
	{
		if(!is100FamiliarRun($familiar[Gelatinous Cubeling]) && (auto_my_path() != "Pocket Familiars"))
		{
			return false;
		}
	}

	auto_log_info("Phat Loot Token Get!", "blue");
	set_property("choiceAdventure691", "2");
	autoEquip($slot[acc3], $item[Ring Of Detect Boring Doors]);

	backupSetting("choiceAdventure692", 4);
	if(item_amount($item[Platinum Yendorian Express Card]) > 0)
	{
		backupSetting("choiceAdventure692", 7);
	}
	else if(item_amount($item[Pick-O-Matic Lockpicks]) > 0)
	{
		backupSetting("choiceAdventure692", 3);
	}
	else
	{
		int keysNeeded = 2;
		if(contains_text(get_property("nsTowerDoorKeysUsed"), $item[Skeleton Key]))
		{
			keysNeeded = 1;
		}

		if((item_amount($item[Skeleton Key]) < keysNeeded) && (available_amount($item[Skeleton Key]) >= keysNeeded))
		{
			cli_execute("make 1 " + $item[Skeleton Key]);
		}
		if((item_amount($item[Skeleton Key]) < keysNeeded) && (available_amount($item[Skeleton Key]) >= keysNeeded))
		{
			cli_execute("make 1 " + $item[Skeleton Key]);
		}
		if(item_amount($item[Skeleton Key]) >= keysNeeded)
		{
			backupSetting("choiceAdventure692", 2);
		}
	}

	if(item_amount($item[Eleven-Foot Pole]) > 0)
	{
		backupSetting("choiceAdventure693", 2);
	}
	else
	{
		backupSetting("choiceAdventure693", 1);
	}
	if(equipped_amount($item[Ring of Detect Boring Doors]) > 0)
	{
		backupSetting("choiceAdventure690", 2);
		backupSetting("choiceAdventure691", 2);
	}
	else
	{
		backupSetting("choiceAdventure690", 3);
		backupSetting("choiceAdventure691", 3);
	}


	autoAdv(1, $location[The Daily Dungeon]);
	if(possessEquipment($item[Ring Of Detect Boring Doors]))
	{
		cli_execute("unequip acc3");
	}
	if(get_property("_lastDailyDungeonRoom").to_int() == 15)
	{
		set_property("auto_phatloot", "" + my_daycount());
	}
	restoreSetting("choiceAdventure690");
	restoreSetting("choiceAdventure691");
	restoreSetting("choiceAdventure692");
	restoreSetting("choiceAdventure693");

	return true;
}

boolean L6_dakotaFanning()
{
	if(!get_property("auto_dakotaFanning").to_boolean())
	{
		return false;
	}
	if(get_property("questM16Temple") == "unstarted")
	{
		if(my_basestat(my_primestat()) < 35)
		{
			return false;
		}
		string temp = visit_url("place.php?whichplace=woods&action=woods_dakota_anim");
		return true;
	}
	if(get_property("questM16Temple") == "finished")
	{
		set_property("auto_dakotaFanning", true);
		return false;
	}

	if(item_amount($item[Pellet Of Plant Food]) == 0)
	{
		autoAdv(1, $location[The Haunted Conservatory]);
		return true;
	}

	if(item_amount($item[Heavy-Duty Bendy Straw]) == 0)
	{
		if((get_property("auto_friars") != "finished") && (get_property("auto_friars") != "done"))
		{
			autoAdv(1, $location[The Dark Heart of the Woods]);
		}
		else
		{
			autoAdv(1, $location[Pandamonium Slums]);
		}
		return true;
	}

	if(item_amount($item[Sewing Kit]) == 0)
	{
		if(item_amount($item[Fat Loot Token]) > 0)
		{
			cli_execute("make " + $item[Sewing Kit]);
		}
		else
		{
			return fantasyRealmToken();
		}
		return true;
	}

	string temp = visit_url("place.php?whichplace=woods&action=woods_dakota");
	if(get_property("questM16Temple") != "finished")
	{
		abort("Elle FanninG quest gnot satisfied.");
	}
	set_property("auto_dakotaFanning", false);
	return true;
}


boolean L2_treeCoin()
{
	if(item_amount($item[Tree-Holed Coin]) == 1)
	{
		set_property("auto_treecoin", "finished");
	}
	if(item_amount($item[Spooky Temple Map]) == 1)
	{
		set_property("auto_treecoin", "finished");
	}
	if(get_property("auto_treecoin") == "finished")
	{
		return false;
	}

	auto_log_info("Time for a tree-holed coin", "blue");
	set_property("choiceAdventure502", "2");
	set_property("choiceAdventure505", "2");
	autoAdv(1, $location[The Spooky Forest]);
	return true;
}

boolean L2_spookyMap()
{
	if(get_property("auto_spookymap") == "finished")
	{
		return false;
	}
	auto_log_info("Need a spooky map now", "blue");
	set_property("choiceAdventure502", "3");
	set_property("choiceAdventure506", "3");
	set_property("choiceAdventure507", "1");
	autoAdv(1, $location[The Spooky Forest]);
	if(item_amount($item[spooky temple map]) == 1)
	{
		set_property("auto_spookymap", "finished");
	}
	return true;
}

boolean L2_spookyFertilizer()
{
	if(get_property("auto_spookyfertilizer") == "finished")
	{
		return false;
	}
	pullXWhenHaveY($item[Spooky-Gro Fertilizer], 1, 0);
	if(item_amount($item[Spooky-Gro Fertilizer]) > 0)
	{
		set_property("auto_spookyfertilizer", "finished");
		return false;
	}
	auto_log_info("Need some poop, I mean fertilizer now", "blue");
	set_property("choiceAdventure502", "3");
	set_property("choiceAdventure506", "2");
	autoAdv(1, $location[The Spooky Forest]);
	return true;
}

boolean L2_spookySapling()
{
	if(get_property("auto_spookysapling") == "finished")
	{
		return false;
	}
	if(my_meat() < 100)
	{
		return false;
	}
	auto_log_info("And a spooky sapling!", "blue");
	set_property("choiceAdventure502", "1");
	set_property("choiceAdventure503", "3");
	set_property("choiceAdventure504", "3");

	if(!autoAdvBypass("adventure.php?snarfblat=15", $location[The Spooky Forest]))
	{
		if(contains_text(get_property("lastEncounter"), "Hoom Hah"))
		{
			return true;
		}
		if(contains_text(get_property("lastEncounter"), "Blaaargh! Blaaargh!"))
		{
			auto_log_warning("Ewww, fake blood semirare. Worst. Day. Ever.", "red");
			return true;
		}
		if(lastAdventureSpecialNC())
		{
			auto_log_info("Special Non-combat interrupted us, no worries...", "green");
			return true;
		}
		visit_url("choice.php?whichchoice=502&option=1&pwd");
		visit_url("choice.php?whichchoice=503&option=3&pwd");
		if(item_amount($item[bar skin]) > 0)
		{
			visit_url("choice.php?whichchoice=504&option=2&pwd");
		}
		visit_url("choice.php?whichchoice=504&option=3&pwd");
		visit_url("choice.php?whichchoice=504&option=4&pwd");
		if(item_amount($item[Spooky Sapling]) > 0)
		{
			set_property("auto_spookysapling", "finished");
			use(1, $item[Spooky Temple Map]);
		}
		else
		{
			abort("Supposedly bought a spooky sapling, but failed :( (Did the semi-rare window just expire, just run me again, sorry)");
		}
	}
	return true;
}

boolean L2_mosquito()
{
	if(get_property("auto_mosquito") != "finished" && item_amount($item[mosquito larva]) > 0)
	{
		council();
		set_property("auto_mosquito", "finished");
		if (in_koe())
		{
			cli_execute("refresh quests");
		}
	}
	if(get_property("auto_mosquito") == "finished")
	{
		return false;
	}

	buffMaintain($effect[Snow Shoes], 0, 1, 1);
	providePlusNonCombat(25);

	auto_log_info("Trying to find a mosquito.", "blue");
	set_property("choiceAdventure502", "2"); // Arboreal Respite: go to Consciousness of a Stream
	set_property("choiceAdventure505", "1"); // Consciousness of a Stream: Acquire Mosquito Larva
	autoAdv(1, $location[The Spooky Forest]);
	return true;
}

boolean LX_handleSpookyravenFirstFloor()
{
	if(get_property("lastSecondFloorUnlock").to_int() >= my_ascensions())
	{
		return false;
	}

	boolean delayKitchen = get_property("auto_delayHauntedKitchen").to_boolean();
	if(item_amount($item[Spookyraven Billiards Room Key]) > 0)
	{
		delayKitchen = false;
	}
	if(my_level() == get_property("auto_powerLevelLastLevel").to_int())
	{
		delayKitchen = false;
	}
	if(delayKitchen)
	{
		boolean haveRes = (elemental_resist($element[hot]) >= 9 || elemental_resist($element[stench]) >= 9);
		if(useMaximizeToEquip())
		{
			simMaximizeWith("1000hot res 9 max,1000stench res 9 max");
			if(simValue("Hot Resistance") >= 9 && simValue("Stench Resistance") >= 9)
			{
				haveRes = true;
			}
		}
		if(!haveRes)
		{
			if (isActuallyEd())
			{
				// this should be false if we have the 3rd resist upgrade (max available for Ed) and true if we don't!
				delayKitchen = !have_skill($skill[Even More Elemental Wards]);
			}
		}
		else
		{
			delayKitchen = false;
		}
		if(delayKitchen)
		{
			int hot = elemental_resist($element[hot]);
			int stench = elemental_resist($element[stench]);
			int mpNeed = 0;
			int hpNeed = 0;
			if(((hot < 9) || (stench < 9)) && have_skill($skill[Astral Shell]) && (have_effect($effect[Astral Shell]) == 0))
			{
				hot += 1;
				stench += 1;
				mpNeed += mp_cost($skill[Astral Shell]);
			}
			if(((hot < 9) || (stench < 9)) && have_skill($skill[Elemental Saucesphere]) && (have_effect($effect[Elemental Saucesphere]) == 0))
			{
				hot += 2;
				stench += 2;
				mpNeed += mp_cost($skill[Elemental Saucesphere]);
			}
			if(((hot < 9) || (stench < 9)) && auto_have_skill($skill[Spectral Awareness]) && (have_effect($effect[Spectral Awareness]) == 0))
			{
				hot += 2;
				stench += 2;
				hpNeed += hp_cost($skill[Spectral Awareness]);
			}
			if(hot < 9 && auto_canBeachCombHead("hot"))
			{
				hot += 2;
			}
			if(stench < 9 && auto_canBeachCombHead("stench"))
			{
				stench += 2;
			}

			if((my_mp() > mpNeed) && (my_hp() > hpNeed) && (hot >= 9) && (stench >= 9))
			{
				buffMaintain($effect[Astral Shell], mp_cost($skill[Astral Shell]), 1, 1);
				buffMaintain($effect[Elemental Saucesphere], mp_cost($skill[Elemental Saucesphere]), 1, 1);
				buffMaintain($effect[Spectral Awareness], hp_cost($skill[Spectral Awareness]), 1, 1);
				if(elemental_resist($element[hot]) < 9) auto_beachCombHead("hot");
				if(elemental_resist($element[stench]) < 9) auto_beachCombHead("stench");
			}

			if((elemental_resist($element[hot]) >= 9) && (elemental_resist($element[stench]) >= 9))
			{
				delayKitchen = false;
			}
			if((get_property("auto_powerLevelAdvCount").to_int() > 7) && (get_property("auto_powerLevelLastLevel").to_int() == my_level()))
			{
				delayKitchen = false;
			}
		}
	}

	if(delayKitchen)
	{
		return false;
	}

	if(get_property("writingDesksDefeated").to_int() >= 5)
	{
		abort("Mafia reports 5 or more writing desks defeated yet we are still looking for them? Give Lady Spookyraven her necklace?");
	}
	if(item_amount($item[Lady Spookyraven\'s Necklace]) > 0)
	{
		abort("Have Lady Spookyraven's Necklace but did not give it to her....");
	}

	if(hasSpookyravenLibraryKey())
	{
		auto_log_info("Well, we need writing desks", "blue");
		auto_log_info("Going to the liberry!", "blue");
		set_property("choiceAdventure888", "4");
		set_property("choiceAdventure889", "5");
		set_property("choiceAdventure163", "4");
		autoAdv(1, $location[The Haunted Library]);
	}
	else if(item_amount($item[Spookyraven Billiards Room Key]) == 1)
	{
		int expectPool = get_property("poolSkill").to_int();
		expectPool += min(10,to_int(2 * square_root(get_property("poolSharkCount").to_int())));
		if(my_inebriety() >= 10)
		{
			expectPool += (30 - (2 * my_inebriety()));
		}
		else
		{
			expectPool += my_inebriety();
		}
		// Staff of Fats (non-Ed and Ed) and Staff of Ed (from Ed)
		item staffOfFats = $item[2268];
		item staffOfFatsEd = $item[7964];
		item staffOfEd = $item[7961];
		if((have_effect($effect[Chalky Hand]) > 0) || (item_amount($item[Handful of Hand Chalk]) > 0))
		{
			expectPool += 3;
		}
		if(have_effect($effect[Chalked Weapon]) > 0)
		{
			expectPool += 5;
		}
		if(have_effect($effect[Influence of Sphere]) > 0)
		{
			expectPool += 5;
		}
		if(have_effect($effect[Video... Games?]) > 0)
		{
			expectPool += 5;
		}
		if(have_effect($effect[Swimming with Sharks]) > 0)
		{
			expectPool += 3;
		}

		// Prevent the needless equipping of Cues if we don't need it.
		boolean usePoolEquips = true;

		if((expectPool < 18) && (!in_tcrs()))
		{
			if(possessEquipment(staffOfFats) || possessEquipment(staffOfFatsEd) || possessEquipment(staffOfEd))
			{
				expectPool += 5;
			}
			else if(possessEquipment($item[Pool Cue]))
			{
				expectPool += 3;
			}
		}
		else if(in_tcrs())
		{
				auto_log_info("During this Crazy Summer Pool Cues are used differently.", "blue");
				boolean usePoolEquips = false;
		}
		else
		{
				auto_log_info("I don't need to equip a cue to beat this ghostie.", "blue");
				boolean usePoolEquips = false;
		}

		if(!possessEquipment($item[Pool Cue]) && !possessEquipment(staffOfFats) && !possessEquipment(staffOfFatsEd) && !possessEquipment(staffOfEd) && !in_tcrs())
		{
			auto_log_info("Well, I need a pool cueball...", "blue");
			backupSetting("choiceAdventure330", 1);
			providePlusNonCombat(25, true);
			autoAdv(1, $location[The Haunted Billiards Room]);
			restoreSetting("choiceAdventure330");
			return true;
		}

		auto_log_info("Looking at the billiards room: 14 <= " + expectPool + " <= 18", "green");
		if((my_inebriety() < 8) && ((my_inebriety() + 2) < inebriety_limit()))
		{
			if(expectPool < 18)
			{
				auto_log_info("Not quite boozed up for the billiards room... we'll be back.", "green");
				if(get_property("auto_powerLevelAdvCount").to_int() < 5)
				{
					return false;
				}
			}

			auto_log_info("Well, maybe I'll just deal with not being drunk enough, punk", "blue");
		}
		if((my_inebriety() > 12) && (expectPool < 16))
		{
			if(in_hardcore() && (my_daycount() <= 2))
			{
				auto_log_info("Ok, I'm too boozed up for the billards room, I'll be back.", "green");
			}
			if(!in_hardcore() && (my_daycount() <= 1))
			{
				auto_log_info("I'm too drunk for pool, at least it is only " + format_date_time("yyyyMMdd", today_to_string(), "EEEE"), "green");
			}
			return false;
		}

		set_property("choiceAdventure875" , "1");
		if(expectPool < 14)
		{
			set_property("choiceAdventure875", "2");
		}

		if(usePoolEquips)
		{
			if(possessEquipment($item[Pool Cue]))
			{
				buffMaintain($effect[Chalky Hand], 0, 1, 1);
			}
			autoEquip($slot[weapon], $item[Pool Cue]);
			autoEquip(staffOfFats);
			autoEquip(staffOfFatsEd);
			autoEquip(staffOfEd);
		}

		auto_log_info("It's billiards time!", "blue");
		backupSetting("choiceAdventure330", 1);
		providePlusNonCombat(25, true);
		autoAdv(1, $location[The Haunted Billiards Room]);
		restoreSetting("choiceAdventure330");
	}
	else
	{
		auto_log_info("Looking for the Billards Room key (Hot/Stench:" + elemental_resist($element[hot]) + "/" + elemental_resist($element[stench]) + "): Progress " + get_property("manorDrawerCount") + "/24", "blue");
		if(auto_have_familiar($familiar[Mu]))
		{
			handleFamiliar($familiar[Mu]);
		}
		else if(auto_have_familiar($familiar[Exotic Parrot]))
		{
			handleFamiliar($familiar[Exotic Parrot]);
		}
		if(is100FamiliarRun())
		{
			if(auto_have_familiar($familiar[Trick-or-Treating Tot]) && (available_amount($item[Li\'l Candy Corn Costume]) > 0))
			{
				handleFamiliar($familiar[Trick-or-Treating Tot]);
			}
		}
		if(get_property("manorDrawerCount").to_int() >= 24)
		{
			cli_execute("refresh inv");
			if(item_amount($item[Spookyraven Billiards Room Key]) == 0)
			{
				auto_log_warning("We think you've opened enough drawers in the kitchen but you don't have the Billiards Room Key.");
				wait(10);
			}
		}
		buffMaintain($effect[Hide of Sobek], 10, 1, 1);
		buffMaintain($effect[Patent Prevention], 0, 1, 1);
		bat_formMist();

		addToMaximize("1000hot resistance 9 max,1000 stench resistance 9 max");
		autoAdv(1, $location[The Haunted Kitchen]);
		handleFamiliar("item");
	}
	return true;
}

boolean L5_getEncryptionKey()
{
	if (in_koe()) return false;

	if(item_amount($item[11-inch knob sausage]) == 1)
	{
		visit_url("guild.php?place=challenge");
		return true;
	}
	if(item_amount($item[Knob Goblin Encryption Key]) == 1)
	{
		set_property("auto_day1_cobb", "finished");
		if(my_level() >= 5)
		{
			council();
		}
	}
	if(get_property("auto_day1_cobb") == "finished")
	{
		return false;
	}
	if(internalQuestStatus("questL05Goblin") >= 1)
	{
		set_property("auto_day1_cobb", "finished");
		return false;
	}

	if((my_class() == $class[Gelatinous Noob]) && auto_have_familiar($familiar[Robortender]))
	{
		if(!have_skill($skill[Retractable Toes]) && (item_amount($item[Cocktail Mushroom]) == 0))
		{
			handleFamiliar($familiar[Robortender]);
		}
	}

	auto_log_info("Looking for the knob.", "blue");
	autoAdv(1, $location[The Outskirts of Cobb\'s Knob]);
	return true;
}

boolean LX_handleSpookyravenNecklace()
{
	if((get_property("lastSecondFloorUnlock").to_int() >= my_ascensions()) || (item_amount($item[Lady Spookyraven\'s Necklace]) == 0))
	{
		return false;
	}

	auto_log_info("Starting Spookyraven Second Floor.", "blue");
	visit_url("place.php?whichplace=manor1&action=manor1_ladys");
	visit_url("main.php");
	visit_url("place.php?whichplace=manor2&action=manor2_ladys");

	set_property("choiceAdventure876", "2");
	set_property("choiceAdventure877", "1");
	set_property("choiceAdventure878", "3");
	set_property("choiceAdventure879", "1");
	set_property("choiceAdventure880", "1");

	#handle lights-out, too bad we can\'t at least start Stephen Spookyraven here.
	set_property("choiceAdventure897", "2");
	set_property("choiceAdventure896", "1");
	set_property("choiceAdventure892", "2");

	if(item_amount($item[Lady Spookyraven\'s Necklace]) > 0)
	{
		cli_execute("refresh inv");
		#abort("Mafia still doesn't understand the ghost of a necklace, just re-run me.");
	}
	return true;
}


boolean L12_startWar()
{
	if(get_property("auto_prewar") != "")
	{
		return false;
	}

	if (my_level() < 12)
	{
		return false;
	}

	if (my_basestat($stat[Mysticality]) < 70 || my_basestat($stat[Moxie]) < 70)
	{
		return false;
	}

	if(in_koe())
	{
		return false;
	}

	auto_log_info("Must save the ferret!!", "blue");
	autoOutfit("frat warrior fatigues");
	if((my_mp() > 60) || considerGrimstoneGolem(true))
	{
		handleBjornify($familiar[Grimstone Golem]);
	}
	buffMaintain($effect[Snow Shoes], 0, 1, 1);
	buffMaintain($effect[Become Superficially Interested], 0, 1, 1);

	if((my_path() != "Dark Gyffte") && (my_mp() > 50) && have_skill($skill[Incredible Self-Esteem]) && !get_property("_incredibleSelfEsteemCast").to_boolean())
	{
		use_skill(1, $skill[Incredible Self-Esteem]);
	}

	autoAdv(1, $location[Wartime Hippy Camp]);
	set_property("choiceAdventure142", "3");
	if(contains_text(get_property("lastEncounter"), "Blockin\' Out the Scenery"))
	{
		set_property("auto_prewar", "started");
		visit_url("bigisland.php?action=junkman&pwd");
		if(!get_property("auto_hippyInstead").to_boolean())
		{
			visit_url("bigisland.php?place=concert&pwd");
			visit_url("bigisland.php?place=lighthouse&action=pyro&pwd=");
			visit_url("bigisland.php?place=lighthouse&action=pyro&pwd=");
			set_property("auto_gunpowder", "finished");
		}
	}
	return true;
}

boolean L12_getOutfit()
{
	if(get_property("auto_prehippy") == "done")
	{
		return false;
	}
	if(my_level() < 12)
	{
		return false;
	}

	set_property("choiceAdventure143", "3");
	set_property("choiceAdventure144", "3");
	set_property("choiceAdventure145", "1");
	set_property("choiceAdventure146", "1");

	if((get_property("auto_orcishfratboyspy") == "done") && !in_hardcore())
	{
		pullXWhenHaveY($item[Beer Helmet], 1, 0);
		pullXWhenHaveY($item[Bejeweled Pledge Pin], 1, 0);
		pullXWhenHaveY($item[Distressed Denim Pants], 1, 0);
	}

	if(!in_hardcore() && (auto_my_path() != "Heavy Rains"))
	{
		pullXWhenHaveY($item[Beer Helmet], 1, 0);
		pullXWhenHaveY($item[Bejeweled Pledge Pin], 1, 0);
		pullXWhenHaveY($item[Distressed Denim Pants], 1, 0);
	}

	if(possessEquipment($item[Beer Helmet]) && possessEquipment($item[Distressed Denim Pants]) && possessEquipment($item[Bejeweled Pledge Pin]))
	{
		set_property("choiceAdventure139", "3");
		set_property("choiceAdventure140", "3");
		set_property("auto_prehippy", "done");
		visit_url("clan_viplounge.php?preaction=goswimming&subaction=submarine");
		return true;
	}

	if(get_property("auto_prehippy") == "firstOutfit")
	{
		autoOutfit("filthy hippy disguise");
		if(my_lightning() >= 5)
		{
			autoAdv(1, $location[Wartime Frat House]);
			return true;
		}

		if(in_hardcore())
		{
			autoAdv(1, $location[Wartime Frat House]);
			return true;
		}

		if(!canYellowRay())
		{
			pullXWhenHaveY($item[Beer Helmet], 1, 0);
			pullXWhenHaveY($item[Bejeweled Pledge Pin], 1, 0);
			pullXWhenHaveY($item[Distressed Denim Pants], 1, 0);
			return true;
		}

		//We should probably have some kind of backup solution here
		return false;
	}
	else
	{
		if(!in_hardcore())
		{
			pullXWhenHaveY($item[Filthy Knitted Dread Sack], 1, 0);
			pullXWhenHaveY($item[Filthy Corduroys], 1, 0);
		}
		if(L12_preOutfit())
		{
			return true;
		}
	}
	return false;
}

boolean L12_preOutfit()
{
	if(get_property("lastIslandUnlock").to_int() != my_ascensions())
	{
		return false;
	}
	if(!in_hardcore())
	{
		return false;
	}
	if(my_level() < 9)
	{
		return false;
	}
	if(get_property("auto_prehippy") != "")
	{
		return false;
	}
	if(have_outfit("Filthy Hippy Disguise"))
	{
		set_property("auto_prehippy", "firstOutfit");
		return true;
	}
	if(possessEquipment($item[Beer Helmet]) && possessEquipment($item[Distressed Denim Pants]) && possessEquipment($item[Bejeweled Pledge Pin]))
	{
		set_property("auto_prehippy", "firstOutfit");
		return true;
	}

	if (isActuallyEd())
	{
		if(!canYellowRay() && (my_level() < 12))
		{
			return false;
		}
	}

	if(have_skill($skill[Calculate the Universe]) && (my_daycount() == 1))
	{
		return false;
	}
	auto_log_info("Trying to acquire a filthy hippy outfit", "blue");

	if((my_class() == $class[Gelatinous Noob]) && auto_have_familiar($familiar[Robortender]))
	{
		if(!have_skill($skill[Ink Gland]) && (item_amount($item[Shot of Granola Liqueur]) == 0))
		{
			handleFamiliar($familiar[Robortender]);
		}
	}

	if(my_level() < 12)
	{
		autoAdv(1, $location[Hippy Camp]);
	}
	else
	{
		autoAdv(1, $location[Wartime Hippy Camp]);
	}
	return true;
}

boolean L12_flyerFinish()
{
	if(get_property("auto_war") == "finished")
	{
		return false;
	}
	if((item_amount($item[Rock Band Flyers]) == 0) && (item_amount($item[Jam Band Flyers]) == 0))
	{
		return false;
	}
	if(get_property("flyeredML").to_int() < 10000)
	{
		if(get_property("sidequestArenaCompleted") != "none")
		{
			auto_log_warning("Sidequest Arena detected as completed but flyeredML is not appropriate, fixing.", "red");
			set_property("flyeredML", 10000);
		}
		else
		{
			return false;
		}
	}
	if(get_property("auto_ignoreFlyer").to_boolean())
	{
		return false;
	}
	auto_log_info("Done with this Flyer crap", "blue");
	warOutfit(true);
	visit_url("bigisland.php?place=concert&pwd");

	cli_execute("refresh inv");
	if((item_amount($item[Rock Band Flyers]) == 0) && (item_amount($item[Jam Band Flyers]) == 0))
	{
		auto_change_mcd(0);
		return true;
	}
	auto_log_warning("We thought we had enough flyeredML, but we don't. Big sadness, let's try that again.", "red");
	set_property("flyeredML", 9999);
	return false;
}

boolean L9_highLandlord()
{
	if(my_level() < 9)
	{
		return false;
	}
	if(get_property("chasmBridgeProgress").to_int() < 30)
	{
		return false;
	}
	if(get_property("auto_highlandlord") == "finished")
	{
		return false;
	}

	if (isActuallyEd() && !get_property("auto_chasmBusted").to_boolean())
	{
		return false;
	}

	if(get_property("auto_highlandlord") == "")
	{
		visit_url("place.php?whichplace=highlands&action=highlands_dude");
		set_property("choiceAdventure296", "1");
		set_property("auto_highlandlord", "start");
		set_property("auto_grimstoneFancyOilPainting", false);
		return true;
	}

	if(contains_text(visit_url("place.php?whichplace=highlands"), "fire1.gif"))
	{
		set_property("auto_boopeak", "finished");
	}

	if(L9_twinPeak())			return true;
	if(L9_aBooPeak())			return true;
	if(L9_oilPeak())			return true;

	if((get_property("twinPeakProgress").to_int() == 15) && (get_property("auto_oilpeak") == "finished") && (get_property("auto_boopeak") == "finished"))
	{
		auto_log_info("Highlord Done", "blue");
		visit_url("place.php?whichplace=highlands&action=highlands_dude");
		council();
		set_property("auto_highlandlord", "finished");
		return true;
	}

	return false;
}

boolean L9_aBooPeak()
{
	if(get_property("auto_boopeak") == "finished")
	{
		return false;
	}

	item clue = $item[A-Boo Clue];
	if(auto_my_path() == "G-Lover")
	{
		if((item_amount($item[A-Boo Glue]) > 0) && (item_amount(clue) > 0))
		{
			use(1, $item[A-Boo Glue]);
		}
		clue = $item[Glued A-Boo Clue];
	}
	int clueAmt = item_amount(clue);

	if (get_property("booPeakProgress").to_int() > 90)
	{
		auto_log_info("A-Boo Peak (initial): " + get_property("booPeakProgress"), "blue");

		if (clueAmt < 3 && item_amount($item[January\'s Garbage Tote]) > 0)
		{
			januaryToteAcquire($item[Broken Champagne Bottle]);
			if(!useMaximizeToEquip())
			{
				autoEquip($item[Broken Champagne Bottle]);
			}
			else
			{
				removeFromMaximize("-equip " + $item[Broken Champagne Bottle]);
			}
		}

		autoAdv(1, $location[A-Boo Peak]);
		return true;
	}

	boolean booCloversOk = false;
	if(cloversAvailable() > 0)
	{
		if(auto_my_path() == "G-Lover")
		{
			if(item_amount($item[A-Boo Glue]) > 0)
			{
				booCloversOk = true;
			}
		}
		else
		{
			booCloversOk = true;
		}
	}

	auto_log_info("A-Boo Peak: " + get_property("booPeakProgress"), "blue");
	boolean clueCheck = ((clueAmt > 0) || (get_property("auto_aboopending").to_int() != 0));
	if(clueCheck && (get_property("booPeakProgress").to_int() > 2))
	{
		boolean doThisBoo = false;

		if (isActuallyEd())
		{
			if(item_amount($item[Linen Bandages]) == 0)
			{
				return false;
			}
		}
		familiar priorBjorn = my_bjorned_familiar();

		string lihcface = "";
		if (isActuallyEd() && possessEquipment($item[The Crown of Ed the Undying]))
		{
			lihcface = "-equip lihc face";
		}
		string parrot = ", switch exotic parrot, switch mu, switch trick-or-treating tot";
		if(is100FamiliarRun())
		{
			parrot = "";
		}

		autoMaximize("spooky res, cold res, 0.01hp " + lihcface + " -equip snow suit" + parrot, 0, 0, true);
		int coldResist = simValue("Cold Resistance");
		int spookyResist = simValue("Spooky Resistance");
		int hpDifference = simValue("Maximum HP") - numeric_modifier("Maximum HP");
		int effectiveCurrentHP = my_hp();

		//	Do we need to manually adjust for the parrot?

		if(black_market_available() && (item_amount($item[Can of Black Paint]) == 0) && (have_effect($effect[Red Door Syndrome]) == 0) && (my_meat() >= npc_price($item[Can of Black Paint])))
		{
			buyUpTo(1, $item[Can of Black Paint]);
			coldResist += 2;
			spookyResist += 2;
		}
		else if (item_amount($item[Can of Black Paint]) > 0 && have_effect($effect[Red Door Syndrome]) == 0)
		{
			coldResist += 2;
			spookyResist += 2;
		}

		if(0 == have_effect($effect[Mist Form]))
		{
			if(have_skill($skill[Mist Form]))
			{
				coldResist += 4;
				spookyResist += 4;
				effectiveCurrentHP -= 10;
			}
			else if(have_skill($skill[Spectral Awareness]) && (0 == have_effect($effect[Spectral Awareness])))
			{
				coldResist += 2;
				spookyResist += 2;
				effectiveCurrentHP -= 10;
			}
		}

		if((item_amount($item[Spooky Powder]) > 0) && (have_effect($effect[Spookypants]) == 0))
		{
			spookyResist = spookyResist + 1;
		}
		if((item_amount($item[Ectoplasmic Orbs]) > 0) && (have_effect($effect[Balls of Ectoplasm]) == 0))
		{
			spookyResist = spookyResist + 1;
		}
		if((item_amount($item[Black Eyedrops]) > 0) && (have_effect($effect[Hyphemariffic]) == 0))
		{
			spookyResist = spookyResist + 9;
		}
		if((item_amount($item[Cold Powder]) > 0) && (have_effect($effect[Insulated Trousers]) == 0))
		{
			coldResist = coldResist + 1;
		}
		if(auto_canBeachCombHead("cold")) {
			coldResist = coldResist + 3;
		}
		if (auto_canBeachCombHead("spooky")) {
			spookyResist = spookyResist + 3;
		}

		#Calculate how much boo peak damage does per unit resistance.
		int estimatedCold = (13+25+50+125+250) * ((100.0 - elemental_resist_value(coldResist)) / 100.0);
		int estimatedSpooky = (13+25+50+125+250) * ((100.0 - elemental_resist_value(spookyResist)) / 100.0);
		auto_log_info("Current HP: " + my_hp() + "/" + my_maxhp(), "blue");
		auto_log_info("Expected cold damage: " + estimatedCold + " Expected spooky damage: " + estimatedSpooky, "blue");
		auto_log_info("Expected Cold Resist: " + coldResist + " Expected Spooky Resist: " + spookyResist + " Expected HP Difference: " + hpDifference, "blue");
		int totalDamage = estimatedCold + estimatedSpooky;

		if(get_property("booPeakProgress").to_int() <= 6)
		{
			estimatedCold = ((estimatedCold * 38) / 463) + 1;
			estimatedSpooky = ((estimatedSpooky * 38) / 463) + 1;
			totalDamage = estimatedCold + estimatedSpooky;
		}
		else if(get_property("booPeakProgress").to_int() <= 12)
		{
			estimatedCold = ((estimatedCold * 88) / 463) + 1;
			estimatedSpooky = ((estimatedSpooky * 88) / 463) + 1;
			totalDamage = estimatedCold + estimatedSpooky;
		}
		else if(get_property("booPeakProgress").to_int() <= 20)
		{
			estimatedCold = ((estimatedCold * 213) / 463) + 1;
			estimatedSpooky = ((estimatedSpooky * 213) / 463) + 1;
			totalDamage = estimatedCold + estimatedSpooky;
		}

		if(get_property("booPeakProgress").to_int() <= 20)
		{
			auto_log_info("Don't need a full A-Boo Clue, adjusting values:", "blue");
			auto_log_info("Expected cold damage: " + estimatedCold + " Expected spooky damage: " + estimatedSpooky, "blue");
			auto_log_info("Expected Cold Resist: " + coldResist + " Expected Spooky Resist: " + spookyResist + " Expected HP Difference: " + hpDifference, "blue");
		}

		int considerHP = my_maxhp() + hpDifference;

		int mp_need = 20 + simValue("Mana Cost");
		if((my_hp() - totalDamage) > 50)
		{
			mp_need = mp_need - 20;
		}

		loopHandler("_auto_lastABooConsider", "_auto_lastABooCycleFix", "We are in an A-Boo Peak cycle and can't find anything else to do. Aborting. If you have actual other quests left, please report this. Otherwise, complete A-Boo peak manually",15);

		if(get_property("booPeakProgress").to_int() == 0)
		{
			doThisBoo = true;
		}
		if((min(effectiveCurrentHP, my_maxhp() + hpDifference) > totalDamage) && (my_mp() >= mp_need))
		{
			doThisBoo = true;
		}
		if((considerHP >= totalDamage) && (my_mp() >= mp_need) && have_skill($skill[Cannelloni Cocoon]))
		{
			doThisBoo = true;
		}

		if(doThisBoo)
		{
			buffMaintain($effect[Go Get \'Em\, Tiger!], 0, 1, 1);
			bat_formMist();
			if(0 == have_effect($effect[Mist Form]))
			{
				buffMaintain($effect[Spectral Awareness], 10, 1, 1);
			}
			if(useMaximizeToEquip())
			{
				addToMaximize("1000spooky res,1000cold res,10hp" + parrot);
			}
			else
			{
				autoMaximize("spooky res,cold res " + lihcface + " -equip snow suit" + parrot, 0, 0, false);
			}
			adjustEdHat("ml");

			if(item_amount($item[ghost of a necklace]) > 0 && !useMaximizeToEquip())
			{
				equip($slot[acc2], $item[ghost of a necklace]);
			}
			buffMaintain($effect[Astral Shell], 10, 1, 1);
			buffMaintain($effect[Elemental Saucesphere], 10, 1, 1);
			buffMaintain($effect[Scarysauce], 10, 1, 1);
			buffMaintain($effect[Spookypants], 0, 1, 1);
			buffMaintain($effect[Hyphemariffic], 0, 1, 1);
			buffMaintain($effect[Insulated Trousers], 0, 1, 1);
			buffMaintain($effect[Balls of Ectoplasm], 0, 1, 1);
			buffMaintain($effect[Red Door Syndrome], 0, 1, 1);
			buffMaintain($effect[Well-Oiled], 0, 1, 1);

			auto_beachCombHead("cold");
			auto_beachCombHead("spooky");

			set_property("choiceAdventure611", "1");
			if((my_hp() - 50) < totalDamage)
			{
				acquireHP();
			}
			if(get_property("auto_aboopending").to_int() == 0)
			{
				if(item_amount(clue) > 0)
				{
					use(1, clue);
				}
				set_property("auto_aboopending", my_turncount());
			}
			if(auto_have_familiar($familiar[Mu]))
			{
				handleFamiliar($familiar[Mu]);
			}
			else if(auto_have_familiar($familiar[Exotic Parrot]))
			{
				handleFamiliar($familiar[Exotic Parrot]);
			}

			# When booPeakProgress <= 0, we want to leave this adventure. Can we?
			# I can not figure out how to do this via ASH since the adventure completes itself?
			# However, in mafia, (src/net/sourceforge/kolmafia/session/ChoiceManager.java)
			# upon case 611, if booPeakProgress <= 0, set choiceAdventure611 to 2
			# If lastDecision was 2, revert choiceAdventure611 to 1 (or perhaps unset it?)
			try
			{
				autoAdv(1, $location[A-Boo Peak]);
			}
			finally
			{
				if(get_property("lastEncounter") != "The Horror...")
				{
					auto_log_warning("Wandering adventure interrupt of A-Boo Peak, refreshing inventory.", "red");
					cli_execute("refresh inv");
				}
				else
				{
					set_property("auto_aboopending", 0);
				}
			}
			acquireHP();
			if ((my_hp() * 4) < my_maxhp() && item_amount($item[Scroll of Drastic Healing]) > 0 && (!isActuallyEd() || my_class() != $class[Vampyre]))
			{
				use(1, $item[Scroll of Drastic Healing]);
			}
			handleFamiliar("item");
			handleBjornify(priorBjorn);
			return true;
		}

		auto_log_info("Nevermind, that peak is too scary!", "green");
		equipBaseline();
		handleFamiliar("item");
		handleBjornify(priorBjorn);
	}
	else if(get_property("auto_abooclover").to_boolean() && (get_property("booPeakProgress").to_int() >= 30) && booCloversOk)
	{
		cloverUsageInit();
		autoAdvBypass(296, $location[A-Boo Peak]);
		if(cloverUsageFinish())
		{
			set_property("auto_abooclover", false);
		}
		return true;
	}
	else
	{
		if ($location[A-Boo Peak].turns_spent < 10 && item_amount($item[January\'s Garbage Tote]) > 0)
		{
			januaryToteAcquire($item[Broken Champagne Bottle]);
			if(!useMaximizeToEquip())
			{
				autoEquip($item[Broken Champagne Bottle]);
			}
			else
			{
				removeFromMaximize("-equip " + $item[Broken Champagne Bottle]);
			}
		}

		autoAdv(1, $location[A-Boo Peak]);
		set_property("auto_aboopending", 0);

		if(get_property("lastEncounter") == "Come On Ghosty, Light My Pyre")
		{
			set_property("auto_boopeak", "finished");
		}
		return true;
	}
	return false;
}

boolean L9_twinPeak()
{
	if(get_property("twinPeakProgress").to_int() >= 15)
	{
		return false;
	}

	buffMaintain($effect[Fishy Whiskers], 0, 1, 1);
	if(get_property("auto_twinpeakprogress").to_int() == 0)
	{
		auto_log_info("Twin Peak", "blue");
		set_property("choiceAdventure604", "1");
		set_property("choiceAdventure618", "2");
		buffMaintain($effect[Joyful Resolve], 0, 1, 1);
		autoAdv(1, $location[Twin Peak]);
		if(last_monster() != $monster[gourmet gourami])
		{
			visit_url("choice.php?pwd&whichchoice=604&option=1&choiceform1=Continue...");
			visit_url("choice.php?pwd&whichchoice=604&option=1&choiceform1=Everything+goes+black.");
			set_property("auto_twinpeakprogress", "1");
			set_property("choiceAdventure606", "2");
			set_property("choiceAdventure608", "1");
		}
		return true;
	}

	if((my_mp() > 60) || considerGrimstoneGolem(true))
	{
		handleBjornify($familiar[Grimstone Golem]);
	}

	int progress = get_property("twinPeakProgress").to_int();
	boolean needStench = ((progress & 1) == 0);
	boolean needFood = ((progress & 2) == 0);
	boolean needJar = ((progress & 4) == 0);
	boolean needInit = (progress == 7);

	int attemptNum = 0;
	boolean attempt = false;
	if(needInit)
	{
		buffMaintain($effect[Adorable Lookout], 0, 1, 1);
		if(initiative_modifier() < 40.0)
		{
			if((my_class() == $class[Turtle Tamer]) || (my_class() == $class[Seal Clubber]))
			{
				buyUpTo(1, $item[Cheap Wind-Up Clock]);
				buffMaintain($effect[Ticking Clock], 0, 1, 1);
			}
		}
		if(initiative_modifier() < 40.0)
		{
			return false;
		}
		attemptNum = 4;
		attempt = true;
	}

	if(needJar && (item_amount($item[Jar of Oil]) == 1))
	{
		attemptNum = 3;
		attempt = true;
	}

	if(!attempt && needFood)
	{
		float food_drop = item_drop_modifier();
		food_drop -= numeric_modifier(my_familiar(), "Item Drop", familiar_weight(my_familiar()), equipped_item($slot[familiar]));

		if(my_servant() == $servant[Cat])
		{
			food_drop -= numeric_modifier($familiar[Baby Gravy Fairy], "Item Drop", $servant[Cat].level, $item[none]);
		}

		if((food_drop < 50) && (food_drop >= 20))
		{
			if(friars_available() && (!get_property("friarsBlessingReceived").to_boolean()))
			{
				cli_execute("friars food");
			}
		}
		if(have_effect($effect[Brother Flying Burrito\'s Blessing]) > 0)
		{
			food_drop = food_drop + 30;
		}
		if((food_drop < 50.0) && (item_amount($item[Eagle Feather]) > 0) && (have_effect($effect[Eagle Eyes]) == 0))
		{
			use(1, $item[Eagle Feather]);
			food_drop = food_drop + 20;
		}
		if(food_drop >= 50.0)
		{
			attemptNum = 2;
			attempt = true;
		}
	}

	if(!attempt && needStench)
	{
		buffMaintain($effect[Astral Shell], 10, 1, 1);
		buffMaintain($effect[Elemental Saucesphere], 10, 1, 1);
		buffMaintain($effect[Hide of Sobek], 10, 1, 1);
		buffMaintain($effect[Spectral Awareness], 10, 1, 1);
		int possibleGain = 0;
		if(item_amount($item[Polysniff Perfume]) > 0)
		{
			possibleGain += 2;
		}
		if(item_amount($item[Pec Oil]) > 0)
		{
			possibleGain += 2;
		}
		if(item_amount($item[Oil of Parrrlay]) > 0)
		{
			possibleGain += 1;
		}
		if(item_amount($item[Can Of Black Paint]) > 0)
		{
			possibleGain += 2;
		}

		if(elemental_resist($element[stench]) < 4 && !useMaximizeToEquip())
		{
			if(possessEquipment($item[Training Legwarmers]) && glover_usable($item[Training Legwarmers]))
			{
				autoEquip($slot[acc3], $item[Training Legwarmers]);
			}

			familiar resist = $familiar[none];
			if((elemental_resist($element[stench]) < 4) && !is100FamiliarRun())
			{
				if(auto_have_familiar($familiar[Mu]))
				{
					resist = $familiar[Mu];
				}
				else if(auto_have_familiar($familiar[Exotic Parrot]))
				{
					resist = $familiar[Exotic Parrot];
				}
				if(auto_have_familiar($familiar[Trick-Or-Treating Tot]))
				{
					if (possessEquipment($item[li\'l candy corn costume]) && auto_is_valid($item[li\'l candy corn costume]))
					{
						resist = $familiar[Trick-Or-Treating Tot];
					}
				}
				if(resist != $familiar[none])
				{
					handleFamiliar(resist);
					if(resist == $familiar[Trick-Or-Treating Tot])
					{
						autoEquip($slot[familiar], $item[li\'l candy corn costume]);
					}
				}
			}

			if((elemental_resist($element[stench]) < 4) && ((elemental_resist($element[stench]) + possibleGain) >= 4))
			{
				foreach ef in $effects[Neutered Nostrils, Oiled-Up, Well-Oiled, Red Door Syndrome]
				{
					if(elemental_resist($element[stench]) < 4)
					{
						buffMaintain(ef, 0, 1, 1);
					}
				}
			}
		}
		else
		{
			addToMaximize("1000stench res 4max");
		}

		if(elemental_resist($element[stench]) < 4)
		{
			bat_formMist();
		}

		if(useMaximizeToEquip())
		{
			simMaximize();
		}

		if((useMaximizeToEquip() ? simValue("Stench Resistance") : elemental_resist($element[stench])) >= 4)
		{
			attemptNum = 1;
			attempt = true;
		}
	}

	if(!attempt)
	{
		return false;
	}

	set_property("choiceAdventure609", "1");
	if(attemptNum == 1)
	{
		set_property("choiceAdventure606", "1");
		set_property("choiceAdventure607", "1");
	}
	else if(attemptNum == 2)
	{
		set_property("choiceAdventure606", "2");
		set_property("choiceAdventure608", "1");
	}
	else if(attemptNum == 3)
	{
		set_property("choiceAdventure606", "3");
		set_property("choiceAdventure609", "1");
		set_property("choiceAdventure616", "1");
	}
	else if(attemptNum == 4)
	{
		set_property("choiceAdventure606", "4");
		set_property("choiceAdventure610", "1");
		set_property("choiceAdventure1056", "1");
	}

	int trimmers = item_amount($item[Rusty Hedge Trimmers]);
	if(item_amount($item[Rusty Hedge Trimmers]) > 0)
	{
		use(1, $item[rusty hedge trimmers]);
		cli_execute("refresh inv");
		if(item_amount($item[rusty hedge trimmers]) == trimmers)
		{
			abort("Tried using a rusty hedge trimmer but that didn't seem to work");
		}
		auto_log_info("Hedge trimming situation: " + attemptNum, "green");
		string page = visit_url("main.php");
		if((contains_text(page, "choice.php")) && (!contains_text(page, "Really Sticking Her Neck Out")) && (!contains_text(page, "It Came from Beneath the Sewer?")))
		{
			auto_log_info("Inside of a Rusty Hedge Trimmer sequence.", "blue");
		}
		else
		{
			auto_log_info("Rusty Hedge Trimmer Sequence completed itself.", "blue");
			return true;
		}
	}

	int lastTwin = get_property("twinPeakProgress").to_int();
	if(autoAdvBypass(297, $location[Twin Peak]))
	{
		if(lastAdventureSpecialNC())
		{
			autoAdv(1, $location[Twin Peak]);
			#abort("May be stuck in an interrupting Non-Combat adventure, finish current adventure and resume.");
		}
		return true;
	}
	if(lastTwin != get_property("twinPeakProgress").to_int())
	{
		return true;
	}

	auto_log_warning("Backwards Twin Peak Handler, can this be removed? (As of 2016/04/17, no)", "red");
	string page = visit_url("main.php");
	if((contains_text(page, "choice.php")) && (!contains_text(page, "Really Sticking Her Neck Out")) && (!contains_text(page, "It Came from Beneath the Sewer?")))
	{
		if(attemptNum == 1)
		{
			visit_url("choice.php?pwd&whichchoice=606&option=1&choiceform1=Investigate+Room+237");
			visit_url("choice.php?pwd&whichchoice=607&option=1&choiceform1=Carefully+inspect+the+body");
		}
		else if(attemptNum == 2)
		{
			visit_url("choice.php?pwd&whichchoice=606&option=2&choiceform2=Search+the+pantry");
			visit_url("choice.php?pwd&whichchoice=608&option=1&choiceform1=Search+the+shelves");
		}
		else if(attemptNum == 3)
		{
			visit_url("choice.php?pwd&whichchoice=606&option=3&choiceform3=Follow+the+faint+sound+of+music");
			visit_url("choice.php?pwd&whichchoice=609&option=1&choiceform1=Examine+the+painting");
			visit_url("choice.php?pwd&whichchoice=616&option=1&choiceform1=Mingle");
		}
		else if(attemptNum == 4)
		{
			visit_url("choice.php?pwd&whichchoice=606&option=4&choiceform4=Wait+--+who%27s+that%3F");
			visit_url("choice.php?pwd&whichchoice=610&option=1&choiceform1=Pursue+your+double");
			visit_url("choice.php?pwd&whichchoice=1056&option=1&choiceform1=And+then...");
		}
		return true;
	}
	else
	{
		autoAdv(1, $location[Twin Peak]);
		handleFamiliar("item");
	}
	return true;
}

boolean L9_oilPeak()
{
	if(get_property("auto_oilpeak") != "")
	{
		return false;
	}

	buffMaintain($effect[Drescher\'s Annoying Noise], 0, 1, 1);
	buffMaintain($effect[Pride of the Puffin], 0, 1, 1);
	buffMaintain($effect[Ur-kel\'s Aria of Annoyance], 0, 1, 1);
	buffMaintain($effect[Ceaseless Snarling], 0, 1, 1);

	int expectedML = 0;
	auto_change_mcd(11);
	expectedML = current_mcd();
	if(have_skill($skill[Drescher\'s Annoying Noise]))
	{
		expectedML += 10;
	}
	if(have_skill($skill[Pride of the Puffin]))
	{
		expectedML += 10;
	}
	if(have_skill($skill[Ur-kel\'s Aria of Annoyance]))
	{
		expectedML += (2 * my_level());
	}
	if(have_skill($skill[Ceaseless Snarl]))
	{
		expectedML += 30;
	}

	if((monster_level_adjustment() < expectedML) && (my_level() < 12))
	{
		return false;
	}

	if(contains_text(visit_url("place.php?whichplace=highlands"), "fire3.gif"))
	{
		int oilProgress = get_property("twinPeakProgress").to_int();
		boolean needJar = ((oilProgress & 4) == 0);

		if((item_amount($item[Bubblin\' Crude]) >= 12) && needJar)
		{
			if(auto_my_path() == "G-Lover")
			{
				if(item_amount($item[Crude Oil Congealer]) == 0)
				{
					cli_execute("make " + $item[Crude Oil Congealer]);
				}
				use(1, $item[Crude Oil Congealer]);
			}
			else
			{
				cli_execute("make " + $item[Jar Of Oil]);
			}
			set_property("auto_oilpeak", "finished");
			return true;
		}

		if((item_amount($item[Jar Of Oil]) > 0) || !needJar)
		{
			set_property("auto_oilpeak", "finished");
			return true;
		}
		auto_log_info("Oil Peak is finished but we need more crude!", "blue");
	}

	buffMaintain($effect[Litterbug], 0, 1, 1);
	buffMaintain($effect[Tortious], 0, 1, 1);
	buffMaintain($effect[Fishy Whiskers], 0, 1, 1);
	handleFamiliar("initSuggest");

	auto_MaxMLToCap(auto_convertDesiredML(100), false);

	if (isActuallyEd() && get_property("auto_dickstab").to_boolean())
	{
		buffMaintain($effect[The Dinsey Look], 0, 1, 1);
	}
	if(monster_level_adjustment() < 50)
	{
		buffMaintain($effect[The Dinsey Look], 0, 1, 1);
	}
	if(monster_level_adjustment() < 100)
	{
		buffMaintain($effect[Sweetbreads Flamb&eacute;], 0, 1, 1);
	}
	if(monster_level_adjustment() < 60)
	{
		buffMaintain($effect[Punchable Face], 50, 1, 1);
	}
	if((monster_level_adjustment() < 60))
	{
		if (item_amount($item[Dress Pants]) > 0)
		{
			autoEquip($slot[Pants], $item[Dress Pants]);
		}
		else
		{
			januaryToteAcquire($item[tinsel tights]);
			if(!useMaximizeToEquip())
			{
				autoEquip($item[tinsel tights]);
			}
		}
	}

	// Maximize Asdon usage
	if((have_effect($effect[Driving Recklessly]) == 0) && (have_effect($effect[Driving Wastefully]) == 0))
	{
		if((((simMaximizeWith("1000ml 75min")) && (!simMaximizeWith("1000ml 100min"))) || ((simMaximizeWith("1000ml 25min")) && (!simMaximizeWith("1000ml 50min"))) || (!simMaximizeWith("1000ml 11min"))) && (have_effect($effect[Driving Wastefully]) == 0))
		{
			asdonBuff($effect[Driving Recklessly]);
		}
		else if(have_effect($effect[Driving Recklessly]) == 0)
		{
			asdonBuff($effect[Driving Wastefully]);
		}
	}

	// Help protect ourselves against not getting enough crudes if tackling cartels
	if(simMaximizeWith("1000ml 100min"))
	{
		addToMaximize("120item");
	}

	addToMaximize("1000ml " + auto_convertDesiredML(100) + "max");

	auto_log_info("Oil Peak with ML: " + monster_level_adjustment(), "blue");

	autoAdv(1, $location[Oil Peak]);
	if(get_property("lastEncounter") == "Unimpressed with Pressure")
	{
		set_property("oilPeakProgress", 0.0);

		// Brute Force grouping with tavern (if not done) to maximize tangles while we have a high ML.
		auto_log_info("Checking to see if we should do the tavern while we are running high ML.", "green");
		set_property("auto_forceTavern", true);
		// Remove Driving Wastefully if we had it
		if (0 < have_effect($effect[Driving Wastefully]))
		{
			uneffect($effect[Driving Wastefully]);
		}
	}
	handleFamiliar("item");
	return true;
}

boolean LX_loggingHatchet()
{
	if (!canadia_available())
	{
		return false;
	}

	if (available_amount($item[logging hatchet]) > 0)
	{
		return false;
	}

	if ($location[Camp Logging Camp].turns_spent > 0 ||
		$location[Camp Logging Camp].combat_queue != "" ||
		$location[Camp Logging Camp].noncombat_queue != "")
	{
		return false;
	}

	auto_log_info("Acquiring the logging hatchet from Camp Logging Camp", "blue");
	autoAdv(1, $location[Camp Logging Camp]);
	return true;
}

void L9_chasmMaximizeForNoncombat()
{
	auto_log_info("Let's assess our scores for blech house", "blue");
	string best = "mus";
	string mustry = "100muscle,100weapon damage,1000weapon damage percent";
	string mystry = "100mysticality,100spell damage,1000 spell damage percent";
	string moxtry = "100moxie,1000sleaze resistance";
	simMaximizeWith(mustry);
	float musmus = simValue("Buffed Muscle");
	float musflat = simValue("Weapon Damage");
	float musperc = simValue("Weapon Damage Percent");
	int musscore = floor(square_root((musmus + musflat)/15*(1+musperc/100)));
	auto_log_info("Muscle score: " + musscore, "blue");
	simMaximizeWith(mystry);
	float mysmys = simValue("Buffed Mysticality");
	float mysflat = simValue("Spell Damage");
	float mysperc = simValue("Spell Damage Percent");
	int mysscore = floor(square_root((mysmys + mysflat)/15*(1+mysperc/100)));
	auto_log_info("Mysticality score: " + mysscore, "blue");
	if(mysscore > musscore)
	{
		best = "mys";
	}
	simMaximizeWith(moxtry);
	float moxmox = simValue("Buffed Moxie");
	float moxres = simValue("Sleaze Resistance");
	int moxscore = floor(square_root(moxmox/30*(1+moxres*0.69)));
	auto_log_info("Moxie score: " + moxscore, "blue");
	if(moxscore > mysscore && moxscore > musscore)
	{
		best = "mox";
	}
	switch(best)
	{
		case "mus":
			addToMaximize(mustry);
			set_property("choiceAdventure1345", 1);
			break;
		case "mys":
			addToMaximize(mystry);
			set_property("choiceAdventure1345", 2);
			break;
		case "mox":
			addToMaximize(moxtry);
			set_property("choiceAdventure1345", 3);
			break;
	}
}

boolean L9_chasmBuild()
{
	if (my_level() < 9 || get_property("chasmBridgeProgress").to_int() >= 30 || internalQuestStatus("questL09Topping") >= 1)
	{
		return false;
	}

	auto_log_info("Chasm time", "blue");

	if(item_amount($item[fancy oil painting]) > 0)
	{
		visit_url("place.php?whichplace=orc_chasm&action=bridge"+(to_int(get_property("chasmBridgeProgress"))));
	}

	// -Combat is useless here since NC is triggered by killing Orcs...So we kill orcs better!
	asdonBuff($effect[Driving Intimidatingly]);

	// Check our Load out to see if spells are the best option for Orc-Thumping
	boolean useSpellsInOrcCamp = false;
	if(setFlavour($element[cold]) && canUse($skill[Stuffed Mortar Shell]))
	{
		useSpellsInOrcCamp = true;
	}

	if(setFlavour($element[cold]) && canUse($skill[Cannelloni Cannon], false))
	{
		useSpellsInOrcCamp = true;
	}

	if(canUse($skill[Saucegeyser], false))
	{
		useSpellsInOrcCamp = true;
	}

	if(canUse($skill[Saucecicle], false))
	{
		useSpellsInOrcCamp = true;
	}

	// Always Maximize and choose our default Non-Com First, in case we are wrong about the non-com we MAY have some gear still equipped to help us.
	if(useSpellsInOrcCamp == true)
	{
		auto_log_info("Preparing to Blast Orcs with Cold Spells!", "blue");
		addToMaximize("myst,40spell damage,80spell damage percent,40cold spell damage,-1000 ml");
		buffMaintain($effect[Carol of the Hells], 50, 1, 1);
		buffMaintain($effect[Song of Sauce], 150, 1, 1);

		auto_log_info("If we encounter Blech House when we are not expecting it we will stop.", "blue");
		auto_log_info("Currently setup for Myst/Spell Damage, option 2: Blast it down with a spell", "blue");
		set_property("choiceAdventure1345", 0);
	}
	else
	{
		auto_log_info("Preparing to Ice-Punch Orcs!", "blue");
		addToMaximize("muscle,40weapon damage,60weapon damage percent,40cold damage,-1000 ml");
		buffMaintain($effect[Carol of the Bulls], 50, 1, 1);
		buffMaintain($effect[Song of The North], 150, 1, 1);

		auto_log_info("If we encounter Blech House when we are not expecting it we will stop.", "blue");
		auto_log_info("Currently setup for Muscle/Weapon Damage, option 1: Kick it down", "blue");
		set_property("choiceAdventure1345", 0);
	}

	if(get_property("smutOrcNoncombatProgress").to_int() == 15)
	{
		// If we think the non-com will hit NOW we clear maximizer to keep previous settings from carrying forward
		resetMaximize();

		auto_log_info("The smut orc noncombat is about to hit...");
		// This is a hardcoded patch for Dark Gyffte
		// TODO: once explicit formulas are spaded, use simulated maximizer
		// to determine best approach.
		if (my_class() == $class[Vampyre] && have_skill($skill[Sinister Charm]) && !useMaximizeToEquip())
		{
			// Maximizing moxie (through equalizer) and sleaze res is good here
			autoMaximize("myst, 50 sleaze res", 1000, 0, false);
			bat_formMist();
			buffMaintain($effect[Spectral Awareness], 10, 1, 1);
			set_property("choiceAdventure1345", 3);
		}
		else
		{
			if(useMaximizeToEquip())
			{
				L9_chasmMaximizeForNoncombat();
			}
			else
			{
				switch(my_primestat())
				{
					case $stat[Muscle]:
						set_property("choiceAdventure1345", 1);
						break;
					case $stat[Mysticality]:
						set_property("choiceAdventure1345", 2);
						break;
					case $stat[Moxie]:
						set_property("choiceAdventure1345", 3);
						break;
				}
			}
		}
		autoAdv(1, $location[The Smut Orc Logging Camp]);
		return true;
	}

	if(in_hardcore())
	{
		int need = (30 - get_property("chasmBridgeProgress").to_int());
		if(L9_ed_chasmBuildClover(need))
		{
			return true;
		}

		if((my_class() == $class[Gelatinous Noob]) && auto_have_familiar($familiar[Robortender]))
		{
			if(!have_skill($skill[Powerful Vocal Chords]) && (item_amount($item[Baby Oil Shooter]) == 0))
			{
				handleFamiliar($familiar[Robortender]);
			}
		}

		foreach it in $items[Loadstone, Logging Hatchet]
		{
			autoEquip(it);
		}

		autoAdv(1, $location[The Smut Orc Logging Camp]);

		if(item_amount($item[Smut Orc Keepsake Box]) > 0)
		{
			if(auto_my_path() != "G-Lover")
			{
				use(1, $item[Smut Orc Keepsake Box]);
			}
		}
		visit_url("place.php?whichplace=orc_chasm&action=bridge"+(to_int(get_property("chasmBridgeProgress"))));
		if(get_property("chasmBridgeProgress").to_int() >= 30)
		{
			visit_url("place.php?whichplace=highlands&action=highlands_dude");
		}
		return true;
	}

	int need = (30 - get_property("chasmBridgeProgress").to_int()) / 5;
	if(need > 0)
	{
		while((need > 0) && (item_amount($item[Snow Berries]) >= 2))
		{
			cli_execute("make 1 snow boards");
			need = need - 1;
			visit_url("place.php?whichplace=orc_chasm&action=bridge"+(to_int(get_property("chasmBridgeProgress"))));
		}
	}

	if (get_property("chasmBridgeProgress").to_int() < 30)
	{
		foreach it in $items[Loadstone, Logging Hatchet]
		{
			autoEquip(it);
		}

		auto_change_mcd(0);
		autoAdv(1, $location[The Smut Orc Logging Camp]);
		if(item_amount($item[Smut Orc Keepsake Box]) > 0)
		{
			if(auto_my_path() != "G-Lover")
			{
				use(1, $item[Smut Orc Keepsake Box]);
			}
		}
		visit_url("place.php?whichplace=orc_chasm&action=bridge"+(to_int(get_property("chasmBridgeProgress"))));
		return true;
	}
	visit_url("place.php?whichplace=highlands&action=highlands_dude");
	return true;
}

boolean L11_redZeppelin()
{
	if(my_level() < 11)
	{
		return false;
	}
	if(get_property("questL11Shen") != "finished")
	{
		return false;
	}
	if(internalQuestStatus("questL11Ron") >= 2)
	{
		return false;
	}

	if(internalQuestStatus("questL11Ron") == 0)
	{
		return autoAdv($location[A Mob Of Zeppelin Protesters]);
	}

	// TODO: create lynyrd skin items

	set_property("choiceAdventure856", 1);
	set_property("choiceAdventure857", 1);
	set_property("choiceAdventure858", 1);
	buffMaintain($effect[Greasy Peasy], 0, 1, 1);
	buffMaintain($effect[Musky], 0, 1, 1);
	buffMaintain($effect[Blood-Gorged], 0, 1, 1);

	providePlusNonCombat(25);

	if(item_amount($item[Flamin\' Whatshisname]) > 0)
	{
		backupSetting("choiceAdventure866", 3);
	}
	else
	{
		backupSetting("choiceAdventure866", 2);
	}

	if(useMaximizeToEquip())
	{
		addToMaximize("100sleaze damage,100sleaze spell damage");
	}
	else
	{
		autoMaximize("sleaze dmg, sleaze spell dmg", 2500, 0, false);
	}
	auto_beachCombHead("sleaze");
	foreach it in $items[lynyrdskin breeches, lynyrdskin cap, lynyrdskin tunic]
	{
		if(possessEquipment(it) && auto_can_equip(it) &&
		   (numeric_modifier(equipped_item(to_slot(it)), "sleaze damage") < 5) &&
		   (numeric_modifier(equipped_item(to_slot(it)), "sleaze spell damage") < 5))
		{
			autoEquip(it);
		}
	}

	if(item_amount($item[lynyrd snare]) > 0 && get_property("_lynyrdSnareUses").to_int() < 3 && my_hp() > 150)
	{
		return autoAdvBypass("inv_use.php?pwd=&whichitem=7204&checked=1", $location[A Mob of Zeppelin Protesters]);
	}

	if(cloversAvailable() > 0 && get_property("zeppelinProtestors").to_int() < 75)
	{
		if(cloversAvailable() >= 3 && get_property("auto_useWishes").to_boolean())
		{
			makeGenieWish($effect[Fifty Ways to Bereave Your Lover]); // +100 sleaze dmg
			makeGenieWish($effect[Dirty Pear]); // double sleaze dmg
		}
		if(in_tcrs())
		{
			if(my_class() == $class[Sauceror] && my_sign() == "Blender")
			{
				if (0 == have_effect($effect[Improprie Tea]))
				{
					buyUpTo(1, $item[Ben-Gal&trade; Balm], 25);
					use(1, $item[Ben-Gal&trade; Balm]);
				}
			}
		}
		float fire_protestors = item_amount($item[Flamin\' Whatshisname]) > 0 ? 10 : 3;
		float sleaze_amount = numeric_modifier("sleaze damage") + numeric_modifier("sleaze spell damage");
		float sleaze_protestors = square_root(sleaze_amount);
		float lynyrd_protestors = have_effect($effect[Musky]) > 0 ? 6 : 3;
		foreach it in $items[lynyrdskin cap, lynyrdskin tunic, lynyrdskin breeches]
		{
			if((item_amount(it) > 0) && can_equip(it))
			{
				lynyrd_protestors += 5;
			}
		}
		auto_log_info("Hiding in the bushes: " + lynyrd_protestors, "blue");
		auto_log_info("Going to a bench: " + sleaze_protestors, "blue");
		auto_log_info("Heading towards the flames" + fire_protestors, "blue");
		float best_protestors = max(fire_protestors, max(sleaze_protestors, lynyrd_protestors));
		if(best_protestors >= 10)
		{
			if(best_protestors == lynyrd_protestors)
			{
				foreach it in $items[lynyrdskin cap, lynyrdskin tunic, lynyrdskin breeches]
				{
					autoEquip(it);
				}
				set_property("choiceAdventure866", 1);
			}
			else if(best_protestors == sleaze_protestors)
			{
				set_property("choiceAdventure866", 2);
			}
			else if (best_protestors == fire_protestors)
			{
				set_property("choiceAdventure866", 3);
			}
			cloverUsageInit();
			boolean retval = autoAdv(1, $location[A Mob of Zeppelin Protesters]);
			cloverUsageFinish();
			return retval;
		}
	}

	int lastProtest = get_property("zeppelinProtestors").to_int();
	boolean retval = autoAdv($location[A Mob Of Zeppelin Protesters]);
	if(!lastAdventureSpecialNC())
	{
		if(lastProtest == get_property("zeppelinProtestors").to_int())
		{
			set_property("zeppelinProtestors", get_property("zeppelinProtestors").to_int() + 1);
		}
	}
	else
	{
		set_property("lastEncounter", "Clear Special NC");
	}
	restoreSetting("choiceAdventure866");
	set_property("choiceAdventure856", 2);
	set_property("choiceAdventure857", 2);
	set_property("choiceAdventure858", 2);
	return retval;
}


boolean L11_ronCopperhead()
{
	if(my_level() < 11)
	{
		return false;
	}
	if(internalQuestStatus("questL11Shen") < 0)
	{
		return false;
	}
	if(internalQuestStatus("questL11Ron") < 2)
	{
		return false;
	}
	if(get_property("questL11Ron") == "finished")
	{
		return false;
	}

	if((internalQuestStatus("questL11Ron") == 2) || (internalQuestStatus("questL11Ron") == 3) || (internalQuestStatus("questL11Ron") == 4))
	{
		if (item_amount($item[Red Zeppelin Ticket]) < 1)
		{
			// use the priceless diamond since we go to the effort of trying to get one in the Copperhead Club
			// and it saves us 4.5k meat.
			if (item_amount($item[priceless diamond]) > 0)
			{
				buy($coinmaster[The Black Market], 1, $item[Red Zeppelin Ticket]);
			}
			else if (my_meat() > npc_price($item[Red Zeppelin Ticket]))
			{
				buy(1, $item[Red Zeppelin Ticket]);
			}
		}
		// For Glark Cables. OPTIMAL!
		bat_formBats();
		boolean retval = autoAdv($location[The Red Zeppelin]);
		// open red boxes when we get them (not sure if this is the place for this but it'll do for now)
		if (item_amount($item[red box]) > 0)
		{
			use (item_amount($item[red box]), $item[red box]);
		}
		return retval;
	}

	if(get_property("questL11Ron") != "finished")
	{
		abort("Ron should be done with but tracking is not complete!");
	}

	// Copperhead Charm (rampant) autocreated successfully
	return false;
}

boolean L11_shenCopperhead()
{
	if(my_level() < 11)
	{
		return false;
	}
	if(internalQuestStatus("questL11Shen") < 0)
	{
		return false;
	}
	if(get_property("questL11Shen") == "finished")
	{
		return false;
	}

	set_property("choiceAdventure1074", 1);

	if (internalQuestStatus("questL11Shen") == 0 || internalQuestStatus("questL11Shen") == 2 || internalQuestStatus("questL11Shen") == 4 || internalQuestStatus("questL11Shen") == 6)
	{
		if (item_amount($item[Crappy Waiter Disguise]) > 0 && have_effect($effect[Crappily Disguised as a Waiter]) == 0 && !in_tcrs())
		{
			use(1, $item[Crappy Waiter Disguise]);

			// default to getting unnamed cocktails to turn into Flamin' Whatsisnames.
			int behindtheStacheOption = 4;
			if (item_amount($item[priceless diamond]) > 0 || item_amount($item[Red Zeppelin Ticket]) > 0 || (internalQuestStatus("questL11Shen") == 6 && item_amount($item[unnamed cocktail]) > 0))
			{
				if (get_property("auto_copperhead").to_int() != 3)
				{
					// got priceless diamond or zeppelin ticket so lets burn the place down (and make Flamin' Whatsisnames)
					behindtheStacheOption = 3;
				}
			}
			else
			{
				if (get_property("auto_copperhead").to_int() != 2)
				{
					// knock over the ice bucket & try for the priceless diamond.
					behindtheStacheOption = 2;
				}
			}
			set_property("choiceAdventure855", behindtheStacheOption);
		}

		if (!maximizeContains("-10ml"))
		{
			addToMaximize("-10ml");
		}
		boolean retval = autoAdv($location[The Copperhead Club]);
		if (maximizeContains("-10ml"))
		{
			removeFromMaximize("-10ml");
		}
		if (get_property("lastEncounter") == "Behind the 'Stache")
		{
			// store which of the 3 zone changing options we have active so we don't waste Crappy Waiter Disguises
			switch (get_property("choiceAdventure855").to_int())
			{
			case 1:
				set_property("auto_copperhead", 1);
				break;
			case 2:
				set_property("auto_copperhead", 2);
				break;
			case 3:
				set_property("auto_copperhead", 3);
				break;
			}
		}
		return retval;
	}

	if((internalQuestStatus("questL11Shen") == 1) || (internalQuestStatus("questL11Shen") == 3) || (internalQuestStatus("questL11Shen") == 5))
	{
		item it = to_item(get_property("shenQuestItem"));
		if (it == $item[none] && isActuallyEd())
		{
			// temp workaround until mafia bug is fixed - https://kolmafia.us/showthread.php?23742
			cli_execute("refresh quests");
			it = to_item(get_property("shenQuestItem"));
		}
		location goal = $location[none];
		switch(it)
		{
		case $item[The Stankara Stone]:					goal = $location[The Batrat and Ratbat Burrow];						break;
		case $item[The First Pizza]:					goal = $location[Lair of the Ninja Snowmen];						break;
		case $item[Murphy\'s Rancid Black Flag]:		goal = $location[The Castle in the Clouds in the Sky (Top Floor)];	break;
		case $item[The Eye of the Stars]:				goal = $location[The Hole in the Sky];								break;
		case $item[The Lacrosse Stick of Lacoronado]:	goal = $location[The Smut Orc Logging Camp];						break;
		case $item[The Shield of Brook]:				goal = $location[The VERY Unquiet Garves];							break;
		}
		if(goal == $location[none])
		{
			abort("Could not parse Shen event");
		}

		if(!zone_isAvailable(goal))
		{
			// handle paths which don't need Tower keys but the World's Biggest Jerk asks for The Eye of the Stars
			if (goal == $location[The Hole in the Sky])
			{
				if (!get_property("auto_holeinthesky").to_boolean())
				{
					set_property("auto_holeinthesky", true);
				}
				return (L10_topFloor() || L10_holeInTheSkyUnlock());
			}
			return false;
		}
		else
		{
			// If we haven't completed the top floor, try to complete it.
			if (goal == $location[The Castle in the Clouds in the Sky (Top Floor)] && (L10_topFloor() || L10_holeInTheSkyUnlock()))
			{
				return true;
			}
			else if (goal == $location[The Smut Orc Logging Camp] && (L9_ed_chasmStart() || L9_chasmBuild()))
			{
				return true;
			}

			return autoAdv(goal);
		}
	}

	if(get_property("questL11Shen") != "finished")
	{
		abort("Shen should be done with but tracking is not complete! Status: " + get_property("questL11Shen"));
	}

	//Now have a Copperhead Charm
	return false;
}

boolean L11_talismanOfNam()
{
	if(L11_shenCopperhead() || L11_redZeppelin() || L11_ronCopperhead())
	{
		return true;
	}
	if(creatable_amount($item[Talisman O\' Namsilat]) > 0)
	{
		if(create(1, $item[Talisman O\' Namsilat]))
		{
			return true;
		}
	}

	return false;
}

boolean L11_mcmuffinDiary()
{
	if(my_level() < 11)
	{
		return false;
	}
	if(get_property("auto_mcmuffin") != "")
	{
		return false;
	}
	if(item_amount($item[Your Father\'s Macguffin Diary]) > 0)
	{
		use(item_amount($item[Your Father\'s Macguffin Diary]), $item[Your Father\'s Macguffin Diary]);
		set_property("auto_mcmuffin", "start");
		return true;
	}
	if(item_amount($item[Copy of a Jerk Adventurer\'s Father\'s Diary]) > 0)
	{
		use(item_amount($item[Copy of a Jerk Adventurer\'s Father\'s Diary]), $item[Copy of a Jerk Adventurer\'s Father\'s Diary]);
		set_property("auto_mcmuffin", "start");
		return true;
	}
	if (my_adventures() < 4 || my_meat() < 500 || item_amount($item[Forged Identification Documents]) == 0)
	{
		auto_log_warning("Could not vacation at the shore to find your fathers diary!", "red");
		return false;
	}

	auto_log_info("Getting the McMuffin Diary", "blue");
	doVacation();
	foreach diary in $items[Your Father\'s Macguffin Diary, Copy of a Jerk Adventurer\'s Father\'s Diary]
	{
		if(item_amount(diary) > 0)
		{
			use(item_amount(diary), diary);
			set_property("auto_mcmuffin", "start");
			return true;
		}
	}
	return false;
}

boolean L11_forgedDocuments()
{
	if(my_level() < 11)
	{
		return false;
	}
	if(!black_market_available())
	{
		return false;
	}
	if(get_property("auto_blackmap") != "document")
	{
		return false;
	}
	if(item_amount($item[Forged Identification Documents]) != 0)
	{
		return false;
	}
	if(my_meat() < 5000)
	{
		auto_log_warning("Could not buy Forged Identification Documents, can not steal identities!", "red");
		return false;
	}

	auto_log_info("Getting the McMuffin Book", "blue");
	if(auto_my_path() == "Way of the Surprising Fist")
	{
		L11_fistDocuments();
	}
	buyUpTo(1, $item[Forged Identification Documents]);
	if(item_amount($item[Forged Identification Documents]) > 0)
	{
		set_property("auto_blackmap", "finished");
		handleFamiliar("item");
		return true;
	}
	auto_log_warning("Could not buy Forged Identification Documents, can't get booze now!", "red");
	return false;
}

boolean L11_fistDocuments()
{
	string[int] pages;
	pages[0] = "shop.php?whichshop=blackmarket";
	pages[1] = "shop.php?whichshop=blackmarket&action=fightbmguy";
	return autoAdvBypass(0, pages, $location[Noob Cave], "");
}

boolean L11_blackMarket()
{
	if(my_level() < 11)
	{
		return false;
	}
	if(get_property("auto_blackmap") != "")
	{
		return false;
	}

	if($location[The Black Forest].turns_spent > 12)
	{
		auto_log_warning("We have spent a bit many adventures in The Black Forest... manually checking", "red");
		visit_url("place.php?whichplace=woods");
		visit_url("woods.php");
		if($location[The Black Forest].turns_spent > 30)
		{
			abort("We have spent too many turns in The Black Forest and haven't found The Black Market. Something is wrong. (try \"refresh quests\" on the cli)");
		}
	}

	auto_log_info("Must find the Black Market: " + get_property("blackForestProgress"), "blue");
	if(get_property("auto_blackfam").to_boolean())
	{
		council();
		if (!possessEquipment($item[Blackberry Galoshes]) && auto_can_equip($item[Blackberry Galoshes]))
		{
			pullXWhenHaveY($item[blackberry galoshes], 1, 0);
		}
		set_property("auto_blackfam", false);
		set_property("choiceAdventure923", "1"); // All Over the Map: Head toward the blackberry patch
	}

	if(item_amount($item[beehive]) > 0)
	{
		set_property("auto_getBeehive", false);
	}

	if(get_property("auto_getBeehive").to_boolean())
	{
		set_property("choiceAdventure924", "3"); // You Found Your Thrill: Head toward the buzzing sound (get beehive step 1)
		set_property("choiceAdventure1018", "1"); // Bee Persistent: Keep going (get beehive step 2)
		set_property("choiceAdventure1019", "1"); // Bee Rewarded: Almost... there... (get beehive step 3)
	}
	else
	{
		if (!possessEquipment($item[Blackberry Galoshes]) && item_amount($item[Blackberry]) >= 3 && my_class() != $class[Vampyre])
		{
			set_property("choiceAdventure924", "2"); // You Found Your Thrill: Visit the cobbler's house
			set_property("choiceAdventure928", "4"); // The Blackberry Cobbler: Make some galoshes
		}
		else
		{
			set_property("choiceAdventure924", "1"); // You Found Your Thrill: Attack the bushes (fight blackberry bush)
		}
	}

	if(auto_my_path() != "Live. Ascend. Repeat.")
	{
		providePlusCombat(5);
	}

	autoEquip($slot[acc3], $item[Blackberry Galoshes]);

	if(considerGrimstoneGolem(true))
	{
		handleBjornify($familiar[Grimstone Golem]);
	}
	else
	{
		handleBjornify($familiar[Grim Brother]);
	}

	if((my_ascensions() == 0) || (item_amount($item[Reassembled Blackbird]) == 0))
	{
		handleFamiliar($familiar[Reassembled Blackbird]);
	}

	//If we want the Beehive, and don\'t have enough adventures, this is dangerous.
	autoAdv(1, $location[The Black Forest]);
	//For people with autoCraft set to false for some reason
	if(item_amount($item[Reassembled Blackbird]) == 0 && creatable_amount($item[Reassembled Blackbird]) > 0)
	{
		create(1, $item[Reassembled Blackbird]);
	}
	handleFamiliar("item");
	return true;
}

boolean LX_getStarKey()
{
	if(get_property("auto_castleground") != "finished")
	{
		return false;
	}
	if(my_level() < 10)
	{
		return false;
	}
	if(!get_property("auto_getStarKey").to_boolean())
	{
		return false;
	}
	if(item_amount($item[Steam-Powered Model Rocketship]) == 0 && !in_koe())
	{
		return false;
	}
	if(!needStarKey())
	{
		set_property("auto_getStarKey", false);
		return false;
	}
	if(!zone_isAvailable($location[The Hole In The Sky]))
	{
		auto_log_warning("The Hole In The Sky is not available, we have to do something else...", "red");
		return false;
	}

	if((item_amount($item[Star]) >= 8) && (item_amount($item[Line]) >= 7))
	{
		if(!in_hardcore())
		{
			set_property("auto_getStarKey", false);
			return false;
		}
	}
	else
	{
		handleFamiliar("item");
	}
	if(auto_have_familiar($familiar[Space Jellyfish]))
	{
		handleFamiliar($familiar[Space Jellyfish]);
		if(item_amount($item[Star Chart]) == 0)
		{
			set_property("choiceAdventure1221", 1);
		}
		else
		{
			set_property("choiceAdventure1221", 2 + (my_ascensions() % 2));
		}
	}
	autoAdv(1, $location[The Hole In The Sky]);
	return true;
}

boolean L5_haremOutfit()
{
	if(my_level() < 5)
	{
		return false;
	}
	if(get_property("questL05Goblin") == "finished")
	{
		return false;
	}
	if(have_outfit("knob goblin harem girl disguise"))
	{
		return false;
	}

	if(!adjustForYellowRayIfPossible($monster[Knob Goblin Harem Girl]))
	{
		if(my_level() != get_property("auto_powerLevelLastLevel").to_int())
		{
			return false;
		}
	}

	if(auto_my_path() == "Heavy Rains")
	{
		buffMaintain($effect[Fishy Whiskers], 0, 1, 1);
	}
	bat_formBats();

	auto_log_info("Looking for some sexy lingerie!", "blue");
	autoAdv(1, $location[Cobb\'s Knob Harem]);
	handleFamiliar("item");
	return true;
}

boolean L8_trapperGroar()
{
	if(my_level() < 8)
	{
		return false;
	}

	if (internalQuestStatus("questL08Trapper") < 2)
	{
		// if we haven't returned the goat cheese and ore
		// to the trapper yet, don't try to ascend the peak.
		return false;
	}

	if(get_property("auto_trapper") == "finished")
	{
		return false;
	}

	boolean canGroar = false;

	if((item_amount($item[Ninja Rope]) >= 1) && (item_amount($item[Ninja Carabiner]) >= 1) && (item_amount($item[Ninja Crampons]) >= 1))
	{
		canGroar = true;
		//If we can not get enough cold resistance, maybe we need to do extreme path.
	}
	if((internalQuestStatus("questL08Trapper") == 2) && (get_property("currentExtremity").to_int() == 3))
	{
		// TODO: There are some reports of this breaking in TCRS, when cold-weather
		// gear is not sufficient to have 5 cold resistance. Use a maximizer statement?
		if(outfit("eXtreme Cold-Weather Gear"))
		{
			string temp = visit_url("place.php?whichplace=mclargehuge&action=cloudypeak");
			return true;
		}
	}
	if((internalQuestStatus("questL08Trapper") >= 3) && (get_property("currentExtremity").to_int() == 0))
	{
		canGroar = true;
	}

	// Just in case
	cli_execute("refresh quests");

	//What is our potential +Combat score.
	//TODO: Use that instead of the Avatar/Hound Dog checks.

	if(!canGroar && in_hardcore() && ((auto_my_path() == "Avatar of Sneaky Pete") || !auto_have_familiar($familiar[Jumpsuited Hound Dog]) || is100FamiliarRun($familiar[Jumpsuited Hound Dog])))
	{
		if(L8_trapperExtreme())
		{
			return true;
		}
	}
	if(get_property("auto_powerLevelAdvCount").to_int() > 8)
	{
		if(L8_trapperExtreme())
		{
			return true;
		}
	}

	if((item_amount($item[Groar\'s Fur]) > 0) || (item_amount($item[Winged Yeti Fur]) > 0) || (internalQuestStatus("questL08Trapper") == 5))
	{
		visit_url("place.php?whichplace=mclargehuge&action=trappercabin");
		if(item_amount($item[Dense Meat Stack]) >= 5)
		{
			auto_autosell(5, $item[Dense Meat Stack]);
		}
		set_property("auto_trapper", "finished");
		council();
		return true;
	}

	if(canGroar)
	{
		if(elemental_resist($element[cold]) < 5)
		{
			buffMaintain($effect[Astral Shell], 10, 1, 1);
			buffMaintain($effect[Elemental Saucesphere], 10, 1, 1);
			buffMaintain($effect[Hide of Sobek], 10, 1, 1);
			buffMaintain($effect[Spectral Awareness], 10, 1, 1);
			if(elemental_resist($element[cold]) < 5)
			{
				bat_formMist();
			}
		}
		string lihcface = "";
		if (isActuallyEd() && possessEquipment($item[The Crown of Ed the Undying]))
		{
			lihcface = "-equip lihc face";
		}

		if((elemental_resist($element[cold]) < 5) && (my_level() == get_property("auto_powerLevelLastLevel").to_int()))
		{
			autoMaximize("cold res 5 max,-tie,-equip snow suit", 0, 0, true);
			int coldResist = simValue("Cold Resistance");
			if(coldResist >= 5)
			{
				if(useMaximizeToEquip())
				{
					addToMaximize("2000cold res 5 max");
				}
				else
				{
					autoMaximize("cold res,-tie,-equip snow suit,-weapon", 0, 0, false);
				}
			}
		}

		if(elemental_resist($element[cold]) >= 5)
		{
			if(get_property("auto_mistypeak") == "")
			{
				set_property("auto_ninjasnowmanassassin", "1");
				visit_url("place.php?whichplace=mclargehuge&action=trappercabin");
				visit_url("place.php?whichplace=mclargehuge&action=cloudypeak");
				set_property("auto_mistypeak", "finished");
			}

			auto_log_info("Time to take out Gargle, sure, Gargle (Groar)", "blue");
			if (item_amount($item[Groar\'s Fur]) == 0 && item_amount($item[Winged Yeti Fur]) == 0)
			{
				addToMaximize("5meat 2000cold res 5 max");
				//If this returns false, we might have finished already, can we check this?
				autoAdv(1, $location[Mist-shrouded Peak]);
			}
			else
			{
				visit_url("place.php?whichplace=mclargehuge&action=trappercabin");
				auto_autosell(5, $item[dense meat stack]);
				set_property("auto_trapper", "finished");
				council();
			}
			return true;
		}
	}
	return false;
}

boolean L8_trapperExtreme()
{
	if(get_property("currentExtremity").to_int() >= 3)
	{
		return false;
	}
	if(internalQuestStatus("questL08Trapper") >= 3)
	{
		return false;
	}
	if(get_property("_sourceTerminalDigitizeMonster") == $monster[Ninja Snowman Assassin])
	{
		return false;
	}

	//If choice 2 exists, we might want to take it, not that it is good in-run
	//What are the choices now (13/06/2018)?
	//Jar of frostigkraut:	"Dig deeper" (2?)
	//Free:	"Scram"
	//Lucky Pill:	"Look in the side Pocket"
	//set_property("choiceAdventure575", "2");

	if (possessEquipment($item[extreme mittens]) && possessEquipment($item[extreme scarf]) && possessEquipment($item[snowboarder pants]))
	{
		if (my_basestat($stat[moxie]) >= 35 && my_basestat($stat[mysticality]) >= 35 && autoOutfit("eXtreme Cold-Weather Gear"))
		{
			set_property("choiceAdventure575", "3");
			autoAdv(1, $location[The eXtreme Slope]);
			return true;
		}
		else
		{
			auto_log_warning("I can not wear the eXtreme Gear, I'm just not awesome enough :(", "red");
			return false;
		}
	}

	auto_log_info("Penguin Tony Hawk time. Extreme!! SSX Tricky!!", "blue");
	if(possessEquipment($item[extreme mittens]))
	{
		set_property("choiceAdventure15", "2");
		if(possessEquipment($item[extreme scarf]))
		{
			set_property("choiceAdventure15", "3");
		}
	}
	else
	{
		set_property("choiceAdventure15", "1");
	}

	if(possessEquipment($item[snowboarder pants]))
	{
		set_property("choiceAdventure16", "2");
		if(possessEquipment($item[extreme scarf]))
		{
			set_property("choiceAdventure16", "3");
		}
	}
	else
	{
		set_property("choiceAdventure16", "1");
	}

	if(possessEquipment($item[extreme mittens]))
	{
		set_property("choiceAdventure17", "2");
		if(possessEquipment($item[snowboarder pants]))
		{
			set_property("choiceAdventure17", "3");
		}
	}
	else
	{
		set_property("choiceAdventure17", "1");
	}

	set_property("choiceAdventure575", "1");

	autoAdv(1, $location[The eXtreme Slope]);
	return true;
}

boolean L8_trapperNinjaLair()
{
	if(get_property("auto_trapper") != "yeti")
	{
		return false;
	}

	if (internalQuestStatus("questL08Trapper") >= 3)
	{
		return false;
	}

	if(!have_skill($skill[Rain Man]) && (pulls_remaining() >= 3) && (internalQuestStatus("questL08Trapper") < 3))
	{
		foreach it in $items[Ninja Carabiner, Ninja Crampons, Ninja Rope]
		{
			pullXWhenHaveY(it, 1, 0);
		}
	}

	if((item_amount($item[Ninja Rope]) >= 1) && (item_amount($item[Ninja Carabiner]) >= 1) && (item_amount($item[Ninja Crampons]) >= 1))
	{
		return false;
	}

	if(get_property("_sourceTerminalDigitizeMonster") == $monster[Ninja Snowman Assassin])
	{
		if(loopHandler("_auto_digitizeAssassinTurn", "_auto_digitizeAssassinCounter", "Potentially unable to do anything while waiting on digitized Ninja Snowman Assassin.", 10))
		{
			auto_log_info("Have a digitized Ninja Snowman Assassin, let's put off the Ninja Snowman Lair", "blue");
		}
		return false;
	}

	if(in_hardcore())
	{
		if(get_property("questL08Trapper") == "step1")
		{
			set_property("questL08Trapper", "step2");
		}
		if (isActuallyEd())
		{
			if(item_amount($item[Talisman of Horus]) == 0)
			{
				return false;
			}
			if((have_effect($effect[Taunt of Horus]) == 0) && (item_amount($item[Talisman of Horus]) == 0))
			{
				return false;
			}
		}
		if((have_effect($effect[Thrice-Cursed]) > 0) || (have_effect($effect[Twice-Cursed]) > 0) || (have_effect($effect[Once-Cursed]) > 0))
		{
			return false;
		}

		handleFamiliar("item");
		asdonBuff($effect[Driving Obnoxiously]);
		if(!providePlusCombat(25))
		{
			auto_log_warning("Could not uneffect for ninja snowmen, delaying", "red");
			return false;
		}

		if (isActuallyEd() && !elementalPlanes_access($element[spooky]))
		{
			adjustEdHat("myst");
		}

		if(numeric_modifier("Combat Rate") <= 9.0)
		{
			autoEquip($slot[Back], $item[Carpe]);
		}

		if(numeric_modifier("Combat Rate") <= 0.0)
		{
			auto_log_warning("Something is keeping us from getting a suitable combat rate, we have: " + numeric_modifier("Combat Rate") + " and Ninja Snowmen.", "red");
			equipBaseline();
			return false;
		}

		if(!autoAdv(1, $location[Lair of the Ninja Snowmen]))
		{
			auto_log_warning("Seems like we failed the Ninja Snowmen unlock, reverting trapper setting", "red");
			set_property("auto_trapper", "start");
		}
		return true;
	}
	return false;
}

boolean auto_tavern()
{
	if (internalQuestStatus("questL03Rat") < 1 || internalQuestStatus("questL03Rat") > 1)
	{
		return false;
	}

	string temp = visit_url("cellar.php");
	if(contains_text(temp, "You should probably talk to the bartender before you go poking around in the cellar."))
	{
		abort("Quest not yet started, talk to Bart Ender and re-run.");
	}

	auto_log_info("In the tavern! Layout: " + get_property("tavernLayout"), "blue");
	boolean [int] locations = $ints[3, 2, 1, 0, 5, 10, 15, 20, 16, 21];

	// Infrequent compunding issue, reset maximizer
	resetMaximize();

	boolean maximized = false;
	foreach loc in locations
	{
		auto_interruptCheck();
		//Sleaze is the only one we don't care about

		if(!useMaximizeToEquip())
		{
			autoEquip($item[17-Ball]);
		}
		if (possessEquipment($item[Kremlin\'s Greatest Briefcase]))
		{
			string mod = string_modifier($item[Kremlin\'s Greatest Briefcase], "Modifiers");
			if(contains_text(mod, "Weapon Damage Percent"))
			{
				string page = visit_url("place.php?whichplace=kgb");
				boolean flipped = false;
				if(contains_text(page, "handleup"))
				{
					page = visit_url("place.php?whichplace=kgb&action=kgb_handleup", false);
					flipped = true;
				}

				page = visit_url("place.php?whichplace=kgb&action=kgb_button1", false);
				page = visit_url("place.php?whichplace=kgb&action=kgb_button1", false);
				if(flipped)
				{
					page = visit_url("place.php?whichplace=kgb&action=kgb_handledown", false);
				}
			}
			mod = string_modifier($item[Kremlin\'s Greatest Briefcase], "Modifiers");
			if(contains_text(mod, "Hot Damage") && !useMaximizeToEquip())
			{
				autoEquip($slot[acc3], $item[Kremlin\'s Greatest Briefcase]);
			}
		}

		if(numeric_modifier("Hot Damage") < 20.0)
		{
			buffMaintain($effect[Pyromania], 20, 1, 1);
		}
		if(numeric_modifier("Cold Damage") < 20.0)
		{
			buffMaintain($effect[Frostbeard], 20, 1, 1);
		}
		if(numeric_modifier("Stench Damage") < 20.0)
		{
			buffMaintain($effect[Rotten Memories], 20, 1, 1);
		}
		if(numeric_modifier("Spooky Damage") < 20.0)
		{
			if(auto_have_skill($skill[Intimidating Mien]))
			{
				buffMaintain($effect[Intimidating Mien], 20, 1, 1);
			}
			else
			{
				buffMaintain($effect[Dirge of Dreadfulness], 20, 1, 1);
				buffMaintain($effect[Snarl of the Timberwolf], 20, 1, 1);
			}
		}

		if (!isActuallyEd() && monster_level_adjustment() <= 299)
		{
			auto_MaxMLToCap(auto_convertDesiredML(150), true);
		}
		else
		{
			auto_MaxMLToCap(auto_convertDesiredML(150), false);
		}

		foreach element_type in $strings[Hot, Cold, Stench, Sleaze, Spooky]
		{
			if(numeric_modifier(element_type + " Damage") < 20.0)
			{
				auto_beachCombHead(element_type);
			}
		}

		if(!maximized)
		{
			// Tails are a better time saving investment
			addToMaximize("80cold damage 20max,80hot damage 20max,80spooky damage 20max,80stench damage 20max,500ml " + auto_convertDesiredML(150) + "max");
			simMaximize();
			maximized = true;
		}
		int [string] eleChoiceCombos = {
			"Cold": 513,
			"Hot": 496,
			"Spooky": 515,
			"Stench": 514
		};
		int capped = 0;
		foreach ele, choicenum in eleChoiceCombos
		{
			boolean passed = (useMaximizeToEquip() ? simValue(ele + " Damage") : numeric_modifier(ele + " Damage")) >= 20.0;
			set_property("choiceAdventure" + choicenum, passed ? "2" : "1");
			if(passed) ++capped;
		}
		if(capped >= 3)
		{
			providePlusNonCombat(25);
		}
		else
		{
			providePlusCombat(25);
		}

		string tavern = get_property("tavernLayout");
		if(tavern == "0000000000000000000000000")
		{
			string temp = visit_url("cellar.php");
			if(tavern == "0000000000000000000000000")
			{
				abort("Invalid Tavern Configuration, could not visit cellar and repair. Uh oh...");
			}
		}
		if(char_at(tavern, loc) == "0")
		{
			int actual = loc + 1;
			boolean needReset = false;

			if(autoAdvBypass("cellar.php?action=explore&whichspot=" + actual, $location[Noob Cave]))
			{
				return true;
			}

			string page = visit_url("main.php");
			if(contains_text(page, "You've already explored that spot."))
			{
				needReset = true;
				auto_log_warning("tavernLayout is not reporting places we've been to.", "red");
			}
			if(contains_text(page, "Darkness (5,5)"))
			{
				needReset = true;
				auto_log_warning("tavernLayout is reporting too many places as visited.", "red");
			}

			if(contains_text(page, "whichchoice value=") || contains_text(page, "whichchoice="))
			{
				auto_log_warning("Tavern handler: You are RL drunk, you should not be here.", "red");
				autoAdv(1, $location[Noob Cave]);
			}
			if(last_monster() == $monster[Crate])
			{
				if(get_property("auto_newbieOverride").to_boolean())
				{
					set_property("auto_newbieOverride", false);
				}
				else
				{
					abort("We went to the Noob Cave for reals... uh oh");
				}
			}
			if(get_property("lastEncounter") == "Like a Bat Into Hell")
			{
				abort("Got stuck undying while trying to do the tavern. Must handle manualy and then resume.");
			}

			if(needReset)
			{
				auto_log_warning("We attempted a tavern adventure but the tavern layout was not maintained properly.", "red");
				auto_log_warning("Attempting to reset this issue...", "red");
				set_property("tavernLayout", "0000100000000000000000000");
				visit_url("cellar.php");
			}
			return true;
		}
	}
	auto_log_warning("We found no valid location to tavern, something went wrong...", "red");
	auto_log_warning("Attempting to reset this issue...", "red");
	set_property("tavernLayout", "0000100000000000000000000");
	wait(5);
	return true;
}

boolean L3_tavern()
{
	if (internalQuestStatus("questL03Rat") < 0 || internalQuestStatus("questL03Rat") > 2)
	{
		return false;
	}

	if (internalQuestStatus("questL03Rat") < 1)
	{
		visit_url("tavern.php?place=barkeep");
	}

	int mpNeed = 0;
	if(have_skill($skill[The Sonata of Sneakiness]) && (have_effect($effect[The Sonata of Sneakiness]) == 0))
	{
		mpNeed = mpNeed + 20;
	}
	if(have_skill($skill[Smooth Movement]) && (have_effect($effect[Smooth Movements]) == 0))
	{
		mpNeed = mpNeed + 10;
	}

	boolean enoughElement = (numeric_modifier("cold damage") >= 20) && (numeric_modifier("hot damage") >= 20) && (numeric_modifier("spooky damage") >= 20) && (numeric_modifier("stench damage") >= 20);

	boolean delayTavern = false;

	if (isActuallyEd())
	{
		set_property("choiceAdventure1000", "1"); // Everything in Moderation: turn on the faucet (completes quest)
		set_property("choiceAdventure1001", "2"); // Hot and Cold Dripping Rats: Leave it alone (don't fight a rat)
		if (have_skill($skill[Shelter of Shed]) && my_mp() < mp_cost($skill[Shelter of Shed]))
		{
			delayTavern = true;
		}
	}
	else if(!enoughElement || (my_mp() < mpNeed))
	{
		if((my_daycount() <= 2) && (my_level() <= 11))
		{
			delayTavern = true;
		}
	}

	if(my_level() == get_property("auto_powerLevelLastLevel").to_int())
	{
		delayTavern = false;
	}

	if(get_property("auto_forceTavern").to_boolean())
	{
		delayTavern = false;
	}

	if(delayTavern)
	{
		return false;
	}

	auto_log_info("Doing Tavern", "blue");

	if((my_mp() > 60) || considerGrimstoneGolem(true))
	{
		handleBjornify($familiar[Grimstone Golem]);
	}

	buffMaintain($effect[Tortious], 0, 1, 1);
	buffMaintain($effect[Litterbug], 0, 1, 1);
	auto_setMCDToCap();

	if (auto_tavern())
	{
		return true;
	}

	if (internalQuestStatus("questL03Rat") > 1)
	{
		visit_url("tavern.php?place=barkeep");
		set_property("auto_tavern", "finished");
		council();
		return true;
	}
	return false;
}

boolean LX_setBallroomSong()
{
	if((get_property("auto_ballroomopen") != "open") || (get_property("auto_ballroomsong") == "finished"))
	{
		return false;
	}
	if(get_property("lastQuartetRequest").to_int() != 0)
	{
		set_property("auto_ballroomsong", "finished");
		return false;
	}
	if (isActuallyEd())
	{
		return false;
	}
	if(!cangroundHog($location[The Haunted Ballroom]))
	{
		return false;
	}

	if((my_mp() > 60) || considerGrimstoneGolem(true))
	{
		handleBjornify($familiar[Grimstone Golem]);
	}
	set_property("choiceAdventure90", "3");

	set_property("choiceAdventure106", "2");
	if($classes[Avatar of Boris, Avatar of Sneaky Pete, Ed] contains my_class())
	{
		set_property("choiceAdventure106", "3");
	}
	if(auto_my_path() == "Nuclear Autumn")
	{
		set_property("choiceAdventure106", "3");
	}


	autoAdv(1, $location[The Haunted Ballroom]);
	if(contains_text(get_property("lastEncounter"), "Strung-Up Quartet"))
	{
		set_property("auto_ballroomsong", "finished");
	}
	if(contains_text(get_property("lastEncounter"), "We\'ll All Be Flat"))
	{
		set_property("auto_ballroomflat", "finished");
		if (isActuallyEd())
		{
			set_property("auto_ballroomsong", "finished");
		}
	}
	return true;
}

boolean L12_clearBattlefield()
{
	if(in_koe())
	{
		if(get_property("auto_war") != "finished" && (get_property("hippiedDefeated").to_int() < 333) && (get_property("fratboysDefeated").to_int() < 333) && can_equip($item[Distressed denim pants]) && can_equip($item[beer helmet]) && can_equip($item[bejeweled pledge pin]))
		{
			handleFamiliar("item");
			if(haveWarOutfit())
			{
				warOutfit(false);
			}

			item warKillDoubler = my_primestat() == $stat[mysticality] ? $item[Jacob\'s rung] : $item[Haunted paddle-ball];
			pullXWhenHaveY(warKillDoubler, 1, 0);
			if(possessEquipment(warKillDoubler))
			{
				autoEquip($slot[weapon], warKillDoubler);
			}

			item food_item = $item[none];
			foreach it in $items[pie man was not meant to eat, spaghetti with Skullheads, gnocchetti di Nietzsche, Spaghetti con calaveras, space chowder, Spaghetti with ghost balls, Crudles, Agnolotti arboli, Shells a la shellfish, Linguini immondizia bianco, Fettucini Inconnu, ghuol guolash, suggestive strozzapreti, Fusilli marrownarrow]
			{
				if(item_amount(it) > 0)
				{
					food_item = it;
					break;
				}
			}
			if(food_item == $item[none])
			{
				if(creatable_amount($item[space chowder]) > 6)
				{
					create(1, $item[space chowder]);
					food_item = $item[space chowder];
				}
				else
				{
					abort("Couldn't find a good food item for the war.");
				}
			}

			// TODO: Mafia should really be tracking this.
			if(!autoAdvBypass("adventure.php?snarfblat=533", $location[The Exploaded Battlefield]))
			{
				if(get_property("lastEncounter") == "Rationing out Destruction")
				{
					visit_url("choice.php?whichchoice=1391&option=1&tossid=" + food_item.to_int() + "&pwd=" + my_hash(), true);
				}
			}

			if(item_amount($item[solid gold bowling ball]) > 0)
			{
				set_property("auto_war", "finished");
				council();
			}
			return true;
		}
		return false;
	}
	else
	{
		if((get_property("hippiesDefeated").to_int() < 64) && (get_property("fratboysDefeated").to_int() < 64) && (my_level() >= 12) && (get_property("auto_prewar") == "started") && (get_property("auto_war") != "finished"))
		{
			auto_log_info("First 64 combats. To orchard/lighthouse", "blue");
			if((item_amount($item[Stuffing Fluffer]) == 0) && (item_amount($item[Cashew]) >= 3))
			{
				cli_execute("make 1 stuffing fluffer");
			}
			if((item_amount($item[Stuffing Fluffer]) == 0) && (item_amount($item[Cornucopia]) > 0) && glover_usable($item[Cornucopia]))
			{
				use(1, $item[Cornucopia]);
				if((item_amount($item[Stuffing Fluffer]) == 0) && (item_amount($item[Cashew]) >= 3))
				{
					cli_execute("make 1 stuffing fluffer");
				}
				return true;
			}
			if(item_amount($item[Stuffing Fluffer]) > 0)
			{
				use(1, $item[Stuffing Fluffer]);
				return true;
			}
			handleFamiliar("item");
			warOutfit(false);
			return warAdventure();
		}

		if((get_property("hippiesDefeated").to_int() < 192) && (get_property("fratboysDefeated").to_int() < 192) && (my_level() >= 12) && (get_property("auto_prewar") != ""))
		{
			auto_log_info("Getting to the nunnery/junkyard", "blue");
			handleFamiliar("item");
			warOutfit(false);
			return warAdventure();
		}

		if(((get_property("auto_nuns") == "finished") || (get_property("auto_nuns") == "done")) && ((get_property("hippiesDefeated").to_int() < 1000) && (get_property("fratboysDefeated").to_int() < 1000)) && (my_level() >= 12))
		{
			auto_log_info("Doing the wars.", "blue");
			handleFamiliar("item");
			warOutfit(false);
			return warAdventure();
		}
	}
	return false;
}

boolean autosellCrap()
{
	if((item_amount($item[dense meat stack]) > 1) && (item_amount($item[dense meat stack]) <= 10))
	{
		auto_autosell(1, $item[dense meat stack]);
	}
	foreach it in $items[Blue Money Bag, Red Money Bag, White Money Bag]
	{
		if(item_amount(it) > 0)
		{
			auto_autosell(item_amount(it), it);
		}
	}
	foreach it in $items[Ancient Vinyl Coin Purse, Bag Of Park Garbage, Black Pension Check, CSA Discount Card, Fat Wallet, Gathered Meat-Clip, Old Leather Wallet, Penultimate Fantasy Chest, Pixellated Moneybag, Old Coin Purse, Shiny Stones, Warm Subject Gift Certificate]
	{
		if((item_amount(it) > 0) && glover_usable(it) && is_unrestricted(it))
		{
			use(1, it);
		}
	}

	if(!in_hardcore() && !isGuildClass())
	{
		return false;
	}
	if(my_meat() > 6500)
	{
		return false;
	}

	if(item_amount($item[meat stack]) > 1)
	{
		auto_autosell(1, $item[meat stack]);
	}

	foreach it in $items[Anticheese, Awful Poetry Journal, Beach Glass Bead, Beer Bomb, Chaos Butterfly, Clay Peace-Sign Bead, Decorative Fountain, Dense Meat Stack, Empty Cloaca-Cola Bottle, Enchanted Barbell, Fancy Bath Salts, Frigid Ninja Stars, Feng Shui For Big Dumb Idiots, Giant Moxie Weed, Half of a Gold Tooth, Headless Sparrow, Imp Ale, Keel-Haulin\' Knife, Kokomo Resort Pass, Leftovers Of Indeterminate Origin, Mad Train Wine, Mangled Squirrel, Margarita, Meat Paste, Mineapple, Moxie Weed, Patchouli Incense Stick, Phat Turquoise Bead, Photoprotoneutron Torpedo, Plot Hole, Procrastination Potion, Rat Carcass, Smelted Roe, Spicy Jumping Bean Burrito, Spicy Bean Burrito, Strongness Elixir, Sunken Chest, Tambourine Bells, Tequila Sunrise, Uncle Jick\'s Brownie Mix, Windchimes]
	{
		if(item_amount(it) > 0)
		{
			auto_autosell(min(5,item_amount(it)), it);
		}
	}
	if(item_amount($item[hot wing]) > 3)
	{
		auto_autosell(item_amount($item[hot wing]) - 3, $item[hot wing]);
	}
	return true;
}

void print_header()
{
	if(my_thunder() > get_property("auto_lastthunder").to_int())
	{
		set_property("auto_lastthunderturn", "" + my_turncount());
		set_property("auto_lastthunder", "" + my_thunder());
	}
	if(in_hardcore())
	{
		auto_log_info("Turn(" + my_turncount() + "): Starting with " + my_adventures() + " left at Level: " + my_level(), "cyan");
	}
	else
	{
		auto_log_info("Turn(" + my_turncount() + "): Starting with " + my_adventures() + " left and " + pulls_remaining() + " pulls left at Level: " + my_level(), "cyan");
	}
	if(((item_amount($item[Rock Band Flyers]) == 1) || (item_amount($item[Jam Band Flyers]) == 1)) && (get_property("flyeredML").to_int() < 10000) && !get_property("auto_ignoreFlyer").to_boolean())
	{
		auto_log_info("Still flyering: " + get_property("flyeredML"), "blue");
	}
	auto_log_info("Encounter: " + combat_rate_modifier() + "   Exp Bonus: " + experience_bonus(), "blue");
	auto_log_info("Meat Drop: " + meat_drop_modifier() + "	 Item Drop: " + item_drop_modifier(), "blue");
	auto_log_info("HP: " + my_hp() + "/" + my_maxhp() + ", MP: " + my_mp() + "/" + my_maxmp(), "blue");
	auto_log_info("Tummy: " + my_fullness() + "/" + fullness_limit() + " Liver: " + my_inebriety() + "/" + inebriety_limit() + " Spleen: " + my_spleen_use() + "/" + spleen_limit(), "blue");
	auto_log_info("ML: " + monster_level_adjustment() + " control: " + current_mcd(), "blue");
	if(my_class() == $class[Sauceror])
	{
		auto_log_info("Soulsauce: " + my_soulsauce(), "blue");
	}
	if((have_effect($effect[Ultrahydrated]) > 0) && (get_property("desertExploration").to_int() < 100))
	{
		auto_log_info("Ultrahydrated: " + have_effect($effect[Ultrahydrated]), "violet");
	}
	if(have_effect($effect[Everything Looks Yellow]) > 0)
	{
		auto_log_info("Everything Looks Yellow: " + have_effect($effect[Everything Looks Yellow]), "blue");
	}
	if(equipped_item($slot[familiar]) == $item[Snow Suit])
	{
		auto_log_info("Snow suit usage: " + get_property("_snowSuitCount") + " carrots: " + get_property("_carrotNoseDrops"), "blue");
	}
	if(auto_my_path() == "Heavy Rains")
	{
		auto_log_info("Post adventure done: Thunder: " + my_thunder() + " Rain: " + my_rain() + " Lightning: " + my_lightning(), "green");
	}
	if (isActuallyEd())
	{
		auto_log_info("Ka Coins: " + item_amount($item[Ka Coin]) + " Lashes used: " + get_property("_edLashCount"), "green");
	}
}

boolean doTasks()
{
	if(get_property("_casualAscension").to_int() >= my_ascensions())
	{
		auto_log_warning("I think I'm in a casual ascension and should not run. To override: set _casualAscension = -1", "red");
		return false;
	}

	if(get_property("auto_doCombatCopy") == "yes")
	{	# This should never persist into another turn, ever.
		set_property("auto_doCombatCopy", "no");
	}

	print_header();
	questOverride();

	auto_interruptCheck();

	int delay = get_property("auto_delayTimer").to_int();
	if(delay != 0)
	{
		auto_log_info("Delay between adventures... beep boop... ", "blue");
		wait(delay);
	}

	int paranoia = get_property("auto_paranoia").to_int();
	if(paranoia != -1)
	{
		int paranoia_counter = get_property("auto_paranoia_counter").to_int();
		if(paranoia_counter >= paranoia)
		{
			auto_log_info("I think I'm paranoid and complicated", "blue");
			auto_log_info("I think I'm paranoid, manipulated", "blue");
			cli_execute("refresh quests");
			set_property("auto_paranoia_counter", 0);
		}
		else
		{
			set_property("auto_paranoia_counter", paranoia_counter + 1);
		}
	}
	if(get_property("auto_helpMeMafiaIsSuperBrokenAaah").to_boolean())
	{
		cli_execute("refresh inv");
	}
	bat_formNone();
	horseDefault();
	resetMaximize();
	resetFlavour();

	basicAdjustML();
	powerLevelAdjustment();
	if (is100FamiliarRun())
	{
		// re-equip a familiar if it's a 100% run just in case something unequipped it
		// looking at you auto_maximizedConsumeStuff()...
		handleFamiliar(to_familiar(get_property("auto_100familiar")));
	}
	else
	{
		handleFamiliar("item");
	}
	basicFamiliarOverrides();

	councilMaintenance();
	# This function buys missing skills in general, not just for Picky.
	# It should be moved.
	picky_buyskills();
	awol_buySkills();
	awol_useStuff();
	theSource_buySkills();

	oldPeoplePlantStuff();
	use_barrels();
	auto_latteRefill();

	//This just closets stuff so G-Lover does not mess with us.
	if(LM_glover())						return true;

	tophatMaker();
	equipBaseline();
	xiblaxian_makeStuff();
	deck_useScheme("");
	autosellCrap();
	asdonAutoFeed();
	LX_craftAcquireItems();
	auto_spoonTuneMoon();

	ocrs_postCombatResolve();
	beatenUpResolution();
	groundhogSafeguard();


	//Early adventure options that we probably want
	if(dna_startAcquire())				return true;
	if(LM_boris())						return true;
	if(LM_pete())						return true;
	if(LM_jello())						return true;
	if(LM_fallout())					return true;
	if(LM_groundhog())					return true;
	if(LM_digimon())					return true;
	if(LM_majora())						return true;
	if(LM_batpath()) return true;
	if(doHRSkills())					return true;

	if(auto_my_path() != "Community Service")
	{
		cheeseWarMachine(0, 0, 0, 0);

		int turnGoal = 0;
		if (isActuallyEd() && !possessEquipment($item[The Crown Of Ed The Undying]))
		{
			turnGoal = 15;
		}

		if(my_turncount() >= turnGoal)
		{
			switch(my_daycount())
			{
			case 1:		loveTunnelAcquire(true, $stat[none], true, 1, true, 3);		break;
			case 2:		loveTunnelAcquire(true, $stat[none], true, 3, true, 1);		break;
			default:	loveTunnelAcquire(true, $stat[none], true, 2, true, 1);		break;
			}
		}
	}


	if(fortuneCookieEvent())			return true;
	if(theSource_oracle())				return true;
	if(LX_theSource())					return true;
	if(LX_ghostBusting())				return true;


	if(witchessFights())					return true;
	if(my_daycount() != 2)				doNumberology("adventures3");

	//
	//Adventuring actually starts here.
	//

	if(LA_cs_communityService())
	{
		return true;
	}
	if(auto_my_path() == "Community Service")
	{
		abort("Should not have gotten here, aborted LA_cs_communityService method allowed return to caller. Uh oh.");
	}

	auto_voteSetup(0,0,0);

	auto_setSongboom();

	if(LM_bond())						return true;
	if(LX_universeFrat())				return true;
	handleJar();
	adventureFailureHandler();

	dna_sorceressTest();
	dna_generic();

	if(get_property("auto_useCubeling").to_boolean())
	{
		if((item_amount($item[ring of detect boring doors]) == 1) && (item_amount($item[eleven-foot pole]) == 1) && (item_amount($item[pick-o-matic lockpicks]) == 1))
		{
			set_property("auto_cubeItems", false);
		}
		if(get_property("auto_cubeItems").to_boolean() && (my_familiar() != $familiar[Gelatinous Cubeling]) && auto_have_familiar($familiar[Gelatinous Cubeling]))
		{
			handleFamiliar($familiar[Gelatinous Cubeling]);
		}
	}

	if((my_daycount() == 1) && ($familiar[Fist Turkey].drops_today < 5) && auto_have_familiar($familiar[Fist Turkey]))
	{
		handleFamiliar($familiar[Fist Turkey]);
	}

	if(((my_hp() * 5) < my_maxhp()) && (my_mp() > 100))
	{
		acquireHP();
	}

	if(my_daycount() == 1)
	{
		if((my_adventures() < 10) && (my_level() >= 7) && (my_hp() > 0))
		{
			fightScienceTentacle();
			if(my_mp() > (2 * mp_cost($skill[Evoke Eldritch Horror])))
			{
				evokeEldritchHorror();
			}
		}
	}
	else if((my_level() >= 9) && (my_hp() > 0))
	{
		fightScienceTentacle();
		if(my_mp() > (2 * mp_cost($skill[Evoke Eldritch Horror])))
		{
			evokeEldritchHorror();
		}
	}

	if(catBurglarHeist())			return true;
	if(chateauPainting())			return true;
	if(LX_faxing())						return true;
	if(LX_artistQuest())				return true;
	if(L5_findKnob())					return true;
	if(LM_edTheUndying())				return true;
	if(L12_sonofaPrefix())				return true;
	if(LX_burnDelay())					return true;

	if(snojoFightAvailable() && (my_daycount() == 2) && (get_property("snojoMoxieWins").to_int() == 10))
	{
		handleFamiliar($familiar[Ms. Puck Man]);
		autoAdv(1, $location[The X-32-F Combat Training Snowman]);
		handleFamiliar("item");
		return true;
	}

	if(resolveSixthDMT())			return true;
	if(LX_dinseylandfillFunbucks())		return true;
	if(L12_flyerFinish())				return true;

	if((my_level() >= 12) && (item_amount($item[Rock Band Flyers]) == 0) && (item_amount($item[Jam Band Flyers]) == 0) && (get_property("flyeredML").to_int() < 10000) && ((get_property("auto_hiddenapartment") == "0") || (get_property("auto_hiddenapartment") == "finished")) && ((have_effect($effect[Ultrahydrated]) == 0) || (get_property("desertExploration").to_int() >= 100)))
	{
		if(L12_getOutfit() || L12_startWar())
		{
			return true;
		}
	}

	if(LX_loggingHatchet())				return true;
	if(LX_guildUnlock())				return true;
	if(knoll_available() && get_property("auto_spoonconfirmed").to_int() == my_ascensions())
	{
		if(LX_bitchinMeatcar())			return true;
	}
	if(LX_bitchinMeatcar())				return true;
	if(L5_getEncryptionKey())			return true;
	if(LX_handleSpookyravenNecklace())	return true;
	if(LX_unlockPirateRealm())			return true;
	if(handleRainDoh())				return true;
	if(routineRainManHandler())			return true;
	if(LX_handleSpookyravenFirstFloor())return true;

	if(!get_property("auto_slowSteelOrgan").to_boolean() && get_property("auto_getSteelOrgan").to_boolean())
	{
		if(L6_friarsGetParts())				return true;
		if(LX_steelOrgan())					return true;
	}

	if(L4_batCave())					return true;
	if(L2_mosquito())					return true;
	if(L2_treeCoin())					return true;
	if(L2_spookyMap())					return true;
	if(L2_spookyFertilizer())			return true;
	if(L2_spookySapling())				return true;
	if(L6_dakotaFanning())				return true;
	if(L5_haremOutfit())				return true;
	if(LX_phatLootToken())				return true;
	if(L5_goblinKing())					return true;
	if(LX_islandAccess())				return true;

	if(in_hardcore() && isGuildClass())
	{
		if(L6_friarsGetParts())
		{
			return true;
		}
	}

	if(LX_spookyravenSecond())			return true;
	if(LX_setBallroomSong())			return true;
	if(L3_tavern())						return true;
	if(L6_friarsGetParts())				return true;
	if(LX_hardcoreFoodFarm())			return true;

	if(in_hardcore() && LX_steelOrgan())
	{
		return true;
	}

	if(L9_leafletQuest())				return true;
	if(L7_crypt())						return true;
	if(fancyOilPainting())			return true;

	if((my_level() >= 7) && (my_daycount() != 2) && LX_freeCombats())
	{
		return true;
	}

	if(L8_trapperStart())				return true;
	if(L8_trapperGround())				return true;
	if(L8_trapperNinjaLair())				return true;
	if(L8_trapperGroar())				return true;
	if(LX_steelOrgan())					return true;
	if(L10_plantThatBean())				return true;
	if(L12_preOutfit())					return true;
	if(L10_airship())					return true;
	if(L10_basement())					return true;
	if(L10_ground())					return true;
	if(L11_blackMarket())				return true;
	if(L11_forgedDocuments())			return true;
	if(L11_mcmuffinDiary())				return true;
	if(L10_topFloor())					return true;
	if(L10_holeInTheSkyUnlock())		return true;
	if(L9_chasmBuild())					return true;
	if(L9_highLandlord())				return true;
	if(L12_flyerBackup())				return true;
	if(Lsc_flyerSeals())				return true;
	if(L11_mauriceSpookyraven())		return true;
	if(L11_nostrilOfTheSerpent())		return true;
	if(L11_unlockHiddenCity())			return true;
	if(L11_hiddenCityZones())			return true;
	if(ornateDowsingRod())			return true;
	if(L11_aridDesert())				return true;

	if((get_property("auto_nuns") == "done") && (item_amount($item[Half A Purse]) == 1))
	{
		pulverizeThing($item[Half A Purse]);
		if(item_amount($item[Handful of Smithereens]) > 0)
		{
			cli_execute("make " + $item[Louder Than Bomb]);
		}
	}

	if(L11_hiddenCity())				return true;
	if(L11_talismanOfNam())				return true;
	if(L11_palindome())					return true;
	if(L11_unlockPyramid())				return true;
	if(L11_unlockEd())					return true;
	if(L11_defeatEd())					return true;
	if (!in_koe())
	{
		if(L12_gremlins())					return true;
		if(L12_gremlinStart())				return true;
		if(L12_sonofaFinish())				return true;
		if(L12_sonofaBeach())				return true;
		if(L12_orchardStart())				return true;
		if(L12_filthworms())				return true;
		if(L12_orchardFinalize())			return true;
	}

	if((my_level() >= 12) && ((get_property("hippiesDefeated").to_int() >= 192) || get_property("auto_hippyInstead").to_boolean()) && (get_property("auto_nuns") == ""))
	{
		if(L12_ThemtharHills())
		{
			return true;
		}
	}

	if(L11_getBeehive())				return true;
	if(L12_finalizeWar())				return true;
	if(LX_getDigitalKey())				return true;
	if(LX_getStarKey())				return true;
	if(L12_lastDitchFlyer())			return true;

	if(!get_property("kingLiberated").to_boolean() && (my_inebriety() < inebriety_limit()) && !get_property("_gardenHarvested").to_boolean())
	{
		int[item] camp = auto_get_campground();
		if((camp contains $item[Packet of Thanksgarden Seeds]) && (camp contains $item[Cornucopia]) && (camp[$item[Cornucopia]] > 0) && (internalQuestStatus("questL12War") >= 1))
		{
			cli_execute("garden pick");
		}
	}

	if (L12_clearBattlefield())		return true;
	if(LX_koeInvaderHandler())		return true;
	if(L13_towerNSEntrance())			return true;
	if(L13_towerNSContests())			return true;
	if(L13_towerNSHedge())				return true;
	if(L13_sorceressDoor())				return true;
	if(L13_towerNSTower())				return true;
	if(L13_towerNSNagamar())			return true;
	if(L13_towerNSTransition())		return true;
	if(L13_towerNSFinal())				return true;
	if(L13_ed_councilWarehouse())	return true;

	if(my_level() != get_property("auto_powerLevelLastLevel").to_int())
	{
		set_property("auto_powerLevelLastLevel", my_level());
		return true;
	}

	auto_log_info("I should not get here more than once because I pretty much just finished all my in-run stuff. Beep", "blue");
	return false;
}

void auto_begin()
{
	if((svn_info("mafiarecovery").last_changed_rev > 0) && (get_property("recoveryScript") != ""))
	{
		user_confirm("Recovery scripts do not play nicely with this script. I am going to disable the recovery script. It will make me less grumpy. I will restore it if I terminate gracefully. Probably.");
		backupSetting("recoveryScript", "");
	}
	if(get_auto_attack() != 0)
	{
		boolean shouldUnset = user_confirm("You have an auto attack enabled. This can cause issues. Would you like us to disable it? Will default to 'No' in 30 seconds.", 30000, false);
		if(shouldUnset)
		{
			set_auto_attack(0);
		}
		else
		{
			auto_log_warning("Okay, but the warranty is off.", "red");
		}
	}

	//This also should set our path too.
	string page = visit_url("main.php");
	page = visit_url("api.php?what=status&for=4", false);
	if((get_property("_casualAscension").to_int() >= my_ascensions()) && (my_ascensions() > 0))
	{
		return;
	}

	if(contains_text(page, "Being Picky"))
	{
		picky_startAscension();
	}
	else if(contains_text(page, "Welcome to the Kingdom, Gelatinous Noob"))
	{
		jello_startAscension(page);
	}
	else if(contains_text(page, "it appears that a stray bat has accidentally flown right through you") || (get_property("lastAdventure") == "Intro: View of a Vampire"))
	{
		bat_startAscension();
	}
	else if(contains_text(page, "<b>Torpor</b>") && contains_text(page, "Madness of Untold Aeons") && contains_text(page, "Rest for untold Millenia"))
	{
		auto_log_info("Torporing, since I think we're already in torpor.", "blue");
		bat_reallyPickSkills(20);
	}

	if(to_string(my_class()) == "Astral Spirit")
	{
		# my_class() can report Astral Spirit even though it is not a valid class....
		auto_log_warning("We think we are an Astral Spirit, if you actually are that's bad!", "red");
		cli_execute("refresh all");
	}

	auto_log_info("Hello " + my_name() + ", time to explode!");
	auto_log_info("This is version: " + svn_info("autoscend").last_changed_rev + " Mafia: " + get_revision());
	auto_log_info("This is day " + my_daycount() + ".");
	auto_log_info("Turns played: " + my_turncount() + " current adventures: " + my_adventures());
	auto_log_info("Current Ascension: " + auto_my_path());

	set_property("auto_disableAdventureHandling", false);

	auto_spoonTuneConfirm();

	settingFixer();

	uneffect($effect[Ode To Booze]);
	handlePulls(my_daycount());
	initializeDay(my_daycount());

	backupSetting("trackLightsOut", false);
	backupSetting("autoSatisfyWithCoinmasters", true);
	backupSetting("autoSatisfyWithNPCs", true);
	backupSetting("removeMalignantEffects", false);
	backupSetting("autoAntidote", 0);

	backupSetting("kingLiberatedScript", "scripts/autoscend/auto_king.ash");
	backupSetting("afterAdventureScript", "scripts/autoscend/auto_post_adv.ash");
	backupSetting("betweenAdventureScript", "scripts/autoscend/auto_pre_adv.ash");
	backupSetting("betweenBattleScript", "scripts/autoscend/auto_pre_adv.ash");

	backupSetting("hpAutoRecovery", -1);
	backupSetting("hpAutoRecoveryTarget", -1);
	backupSetting("mpAutoRecovery", -1);
	backupSetting("mpAutoRecoveryTarget", -1);
	backupSetting("manaBurningTrigger", -1);
	backupSetting("manaBurningThreshold", -1);

	backupSetting("currentMood", "apathetic");
	backupSetting("customCombatScript", "autoscend_null");
	backupSetting("battleAction", "custom combat script");

	backupSetting("choiceAdventure1107", 1);

	if(get_property("counterScript") != "")
	{
		backupSetting("counterScript", "scripts/autoscend/auto_counter.ash");
	}

	string charpane = visit_url("charpane.php");
	if(contains_text(charpane, "<hr width=50%><table"))
	{
		auto_log_info("Switching off Compact Character Mode, will resume during bedtime");
		set_property("auto_priorCharpaneMode", 1);
		visit_url("account.php?am=1&pwd=&action=flag_compactchar&value=0&ajax=0", true);
	}

	ed_initializeSession();
	bat_initializeSession();
	questOverride();

	if(my_daycount() > 1)
	{
		equipBaseline();
	}

	if(my_familiar() == $familiar[Stooper])
	{
		auto_log_info("Avoiding stooper stupor...", "blue");
		use_familiar($familiar[none]);
	}
	dailyEvents();
	consumeStuff();
	while((my_adventures() > 1) && (my_inebriety() <= inebriety_limit()) && !(my_inebriety() == inebriety_limit() && my_familiar() == $familiar[Stooper]) && !get_property("kingLiberated").to_boolean() && doTasks())
	{
		if((my_fullness() >= fullness_limit()) && (my_inebriety() >= inebriety_limit()) && (my_spleen_use() == spleen_limit()) && (my_adventures() < 4) && (my_rain() >= 50) && (get_counters("Fortune Cookie", 0, 4) == "Fortune Cookie"))
		{
			abort("Manually handle, because we have fortune cookie and rain man colliding at the end of our day and we don't know quite what to do here");
		}
		#We save the last adventure for a rain man, damn it.
		if((my_adventures() == 1) && !get_property("auto_limitConsume").to_boolean())
		{
			keepOnTruckin();
		}
	}

	if(get_property("kingLiberated").to_boolean())
	{
		equipBaseline();
		handleFamiliar("item");
		if(item_amount($item[Boris\'s Helm]) > 0)
		{
			equip($item[Boris\'s Helm]);
		}
		if(item_amount($item[camp scout backpack]) > 0)
		{
			equip($item[camp scout backpack]);
		}
		if(item_amount($item[operation patriot shield]) > 0)
		{
			equip($item[operation patriot shield]);
		}
		if((equipped_item($slot[familiar]) != $item[snow suit]) && (item_amount($item[snow suit]) > 0))
		{
			equip($item[snow suit]);
		}
		if((item_amount($item[mr. cheeng\'s spectacles]) > 0) && !have_equipped($item[Mr. Cheeng\'s Spectacles]))
		{
			equip($slot[acc2], $item[mr. cheeng\'s spectacles]);
		}
		if((item_amount($item[mr. screege\'s spectacles]) > 0) && !have_equipped($item[Mr. Screege\'s Spectacles]))
		{
			equip($slot[acc3], $item[mr. screege\'s spectacles]);
		}
		if((item_amount($item[numberwang]) > 0) && can_equip($item[numberwang]))
		{
			equip($slot[acc1], $item[numberwang]);
		}
	}

	if(doBedtime())
	{
		auto_log_info("Done for today (" + my_daycount() + "), beep boop");
	}
}

void print_help_text()
{
	print_html("Thank you for using autoscend!");
	print_html("If you need to configure or interrupt the script, choose <b>autoscend</b> from the drop-down \"run script\" menu in your browser.");
	print_html("If you want to contribute, please open an issue <a href=\"https://github.com/Loathing-Associates-Scripting-Society/autoscend/issues\">on Github</a>");
	print_html("A FAQ with common issues (and tips for a great bug report) <a href=\"https://docs.google.com/document/d/1AfyKDHSDl-fogGSeNXTwbC6A06BG-gTkXUAdUta9_Ns\">can be found here</a>");
	print_html("The developers also hang around <a href=\"https://discord.gg/96xZxv3\">on the Ascension Speed Society discord server</a>");
	print_html("");
}

void sad_times()
{
	print_html('autoscend (formerly sl_ascend) is under new management. Soolar (the maintainer of sl_ascend) and Jeparo (the most active contributor) have decided to cease development of sl_ascend in response to Jick\'s behavior that has recently <a href="https://www.reddit.com/r/kol/comments/d0cq9s/allegations_of_misconduct_by_asymmetric_members/">come to light</a>. New developers have taken over maintenance and rebranded sl_ascend to autoscend as per Soolar\'s request. Please be patient with us during this transition period. Please see the readme on the <a href="https://github.com/Loathing-Associates-Scripting-Society/autoscend">github</a> page for more information.');
}

void safe_preference_reset_wrapper(int level)
{
	if(level <= 0)
	{
		auto_begin();
	}
	else
	{
		boolean succeeded;
		try
		{
			safe_preference_reset_wrapper(level-1);
			succeeded = true;
		}
		finally
		{
			restoreAllSettings();
			if(level == 1)
			{
				sad_times();
			}
		}
	}
}

void main()
{
	backupSetting("printStackOnAbort", true);
	print_help_text();
	sad_times();
	try
	{
		cli_execute("refresh all");
	}
	finally
	{
		if(!autoscend_migrate() && !user_confirm("autoscend might not have upgraded from a previous version correctly, do you want to continue? Will default to true in 10 seconds.", 10000, true)){
			abort("User aborted script after failed migration.");
		}
		safe_preference_reset_wrapper(3);
	}
}
