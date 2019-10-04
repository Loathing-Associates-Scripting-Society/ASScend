script "auto_restore.ash";

import<autoscend.ash>

/**
 * Private Interface
 */
record __RestorationMetadata{
  string name;
  string type;
  int hp_restored;
  boolean restores_all_hp;
  int mp_restored;
  boolean restores_all_mp;
  boolean removes_beaten_up;
  boolean[effect] removes_effects;
  boolean[effect] gives_effects;
};

record __RestorationEffectiveness{
  int hp_goal;
  int starting_hp;
  int mp_goal;
  int starting_mp;
  int hp_restored_per_use;
  int mp_restored_per_use;
  int uses_available;
  int uses_to_hp_goal;
  int uses_to_mp_goal;
  int mp_cost_per_use;
  int meat_cost_per_use;
  int hp_effectiveness_value;
  int hp_effectiveness_cost_modifier;
  int mp_effectiveness_value;
  int mp_effectiveness_cost_modifier;
  int total_uses_needed;
  int total_mp_restored;
  int total_meat_spent;
  int total_value;
}

string to_string(__RestorationMetadata r){
  string list_to_string(boolean[effect] e_list){
    string s = "[";
    boolean first = true;
    foreach e in e_list{
      if(!first){
        s += ", ";
        first = false;
      }
      s += e.to_string();
    }
    s += "]";
    return s;
  }

  string removes_effects_str = list_to_string(r.removes_effects);
  string gives_effects_str = list_to_string(r.gives_effects);
  return "__RestorationMetadata("+r.name+", "+r.type+", "+r.hp_restored+", "+r.restores_all_hp+", "+r.mp_restored+", "+r.restores_all_mp+", "+r.removes_beaten_up+", "+removes_effects_str+", "+gives_effects_str+")";
}

// Note: these data structures may hold skills/items/effects that are not available to the player, up to caller to check auto_is_valid
static boolean[effect] __all_negative_effects;
static __RestorationMetadata[string] __known_restoration_sources;
static __RestorationMetadata[item] __known_dwellings;
static __RestorationMetadata[item] __known_items;
static __RestorationMetadata[skill] __known_skills;
static __RestorationMetadata __NO_RESTORATION_METADATA = new __RestorationMetadata("", "", 0, false, 0, false, false, {},{});
static __RestorationEffectiveness __NO_EFFECTIVENESS = new __RestorationEffectiveness(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
static int __mp_cost_multiplier = 3;

void __init_restoration_metadata(){
  static string resotration_filename = "autoscend_restoration.txt";

  boolean[item] load_known_dwellings(__RestorationMetadata[string] source){
    boolean[item] dwellings;
    foreach name, r in source {
      if(r.type == "dwelling"){
        dwellings[to_item(name)] = true;
      }
    }
    return dwellings;
  }

  boolean[item] load_known_items(__RestorationMetadata[string] source){
    boolean[item] restores;
    foreach name, r in source {
      if(r.type == "item"){
        restores[to_item(name)] = true;
      }
    }
    return restores;
  }

  boolean[skill] load_known_skills(__RestorationMetadata[string] source){
    boolean[skill] restores;
    foreach name, r in source {
      if(r.type == "skill"){
        restores[to_skill(name)] = true;
      }
    }
    return restores;
  }

  boolean[effect] parse_effects(string name, string effects_list){
    effects_list = effects_list.to_lower_case();
    boolean[effect] parsed_effects;

    if(effects_list == "all negative"){
      parsed_effects = __all_negative_effects;
    } else if(effects_list != "none" && effects_list != ""){
      foreach _, s in split_string(effects_list, ","){
        effect e = to_effect(s);
        if(e != $effect[none]){
          parsed_effects[e] = true;
        } else{
          print("Unknown effect found parsing restoration metadata: " + name + " removes effect: " + s);
        }
      }
    }

    return parsed_effects;
  }

  int parse_restored_amount(string restored_str){
    restored_str = restored_str.to_lower_case();
    if(restored_str == "all"){
      return 0;
    } else{
      return to_int(restored_str);
    }
  }

  boolean parse_restores_all(string restored_str){
    restored_str = restored_str.to_lower_case();
    return restored_str == "all";
  }

  void init(){
    record intermediate_record{
      string name;
      string type;
      string hp_restored;
      string mp_restored;
      string removes_effects;
      string gives_effects;
    };

    intermediate_record[int] raw_records;
    file_to_map(resotration_filename, raw_records);

    __RestorationMetadata[string] parsed_records;

    foreach i, r in raw_records{
      __RestorationMetadata parsed;
      parsed.name = r.name.to_lower_case();
      parsed.type = r.type.to_lower_case();
      parsed.hp_restored = parse_restored_amount(r.hp_restored);
      parsed.restores_all_hp = parse_restores_all(r.hp_restored);
      parsed.mp_restored = parse_restored_amount(r.mp_restored);
      parsed.restores_all_mp = parse_restores_all(r.mp_restored);
      parsed.removes_effects = parse_effects(parsed.name, r.removes_effects);
      parsed.removes_beaten_up = (parsed.removes_effects contains $effect[Beaten Up]);
      parsed.gives_effects = parse_effects(parsed.name, r.gives_effects);

      __known_restoration_sources[parsed.name] = parsed;

      if(parsed.type == "skill"){
        if(to_skill(parsed.name) != $skill[none]){
          __known_skills[to_skill(parsed.name)] = parsed;
        } else{
          print("Unknown skill encountered parsing restoration metadata: " + parsed.name);
        }
      } else if(parsed.type == "dwelling"){
        if(to_item(parsed.name) != $item[none]){
          __known_dwellings[to_item(parsed.name)] = parsed;
        } else{
          print("Unknown dwelling encountered parsing restoration metadata: " + parsed.name);
        }
      } else if(parsed.type == "item"){
        if(to_item(parsed.name) != $item[none]){
          __known_items[to_item(parsed.name)] = parsed;
        } else{
          print("Unknown item encountered parsing restoration metadata: " + parsed.name);
        }
      } else{
        print("Unexpected type " + parsed.type + " encountered parsing restoration metadata: " + parsed.name);
      }
    }
  }

  init();
}

void __init_restoration_metadata(boolean reload){
  if(reload){
    clear(__known_restoration_sources);
    clear(__known_dwellings);
    clear(__known_items);
    clear(__known_skills);
  }
  __init_restoration_metadata();
}

__RestorationEffectiveness __determin_effectiveness(int hp_goal, int starting_hp, int mp_goal, int starting_mp, __RestorationMetadata metadata){

  int uses_on_hand(){
    if(metadata.type == "dwelling"){
      return freeRestsRemaining();
    } else if(metadata.type == "item"){
      return available_amount(to_item(metadata.name));
    } else if(metadata.type == "skill"){
      return floor(starting_mp / mp_cost(to_skill(metadata.name)));
    }
    return 0;
  }

  int hp_restored_per(){
    int restored_amount = metadata.hp_restored;
    if(metadata.restores_all_hp){
      restored_amount = my_maxhp();
    }

    return restored_amount;
  }

  int mp_restored_per(){
    int restored_amount = metadata.mp_restored;
    if(metadata.restores_all_mp){
      restored_amount = my_maxmp();
    }

    return restored_amount;
  }

  int hp_wasted_by(int starting_hp){
    int needed = hp_goal - starting_hp;
    int wasted = hp_restored_per() - needed;

    // negative waste means we are short of goal, no waste
    return max(0, wasted);
  }

  int mp_wasted_by(int starting_mp){
    int needed = mp_goal - starting_mp;
    int wasted = mp_restored_per() - needed;

    // negative waste means we are short of goal, no waste
    return max(0, wasted);
  }

  int uses_needed_to_reach_hp_goal(){
    if(hp_restored() < 1){
      return -1;
    }
    return max(1, floor((hp_goal - starting_hp) / hp_restored()));
  }

  int uses_needed_to_reach_mp_goal(){
    if(mp_restored() < 1){
      return -1;
    }
    return max(1, floor((mp_goal - starting_mp) / mp_restored()));
  }

  int mp_cost_per(){
    if(metadata.type == "skill"){
      return mp_cost(to_skill(metadata.name));
    }
    return 0;
  }

  int meat_cost_per(){
    if(metadata.type == "item"){
      return npc_price(to_item(metadata.name));
    }
    return 0;
  }

  void hp_effectiveness(__RestorationEffectiveness effectiveness){
    if(effectiveness.uses_to_hp_goal == -1){
      effectiveness.hp_effectiveness_value = 0;
      effectivenes.hp_effectiveness_cost_modifier = 0;
      effectiveness.total_hp_restored = 0;
      return;
    }

    int hp_effectiveness_value = 0;
    int hp_effectiveness_cost_modifier = 0;

    if(effectiveness.mp_cost_per_use > 0){
      int mp_to_max = effectiveness.mp_cost_per_use * effectiveness.total_uses_needed;
      if(mp_to_max > effectiveness.starting_mp){
        hp_effectiveness_cost_modifier = effectiveness.starting_mp + (__mp_cost_multiplier * (mp_to_max - effectiveness.starting_mp));
      } else{
        hp_effectiveness_cost_modifier = mp_to_max;
      }
      hp_effectiveness_cost_modifier -= mp_regen(); // we get some mp back for free, which is valuable.
    }

    if(effectiveness.total_uses_needed > 1){
      hp_effectiveness_value = effectiveness.hp_restored_per_use * (effectiveness.uses_to_hp_goal - 1);
      int wasted_on_last_use = hp_wasted_by(starting_hp + hp_effectiveness_value);
      hp_effectiveness_value += effectiveness.hp_restored_per_use - wasted_on_last_use;
      hp_effectiveness_cost_modifier -= wasted_on_last_use;
    } else{
      hp_effectiveness_value = effectiveness.hp_restored_per_use - hp_wasted_by(starting_hp);
      hp_effectiveness_cost_modifier -= hp_wasted_by(starting_hp);
    }

    //case when using hp+mp restore with a higher mp goal than hp, calculate extra uses as wasteful
    hp_effectiveness_cost_modifier -= (effectiveness.total_uses_needed - effectiveness.uses_to_hp_goal) * effectiveness.hp_restored_per_use;

    effectiveness.hp_effectiveness_value = hp_effectiveness_value;
    effectivenes.hp_effectiveness_cost_modifier = hp_effectiveness_cost_modifier;
    effectiveness.total_hp_restored = effectiveness.hp_restored_per_use * effectiveness.uses_to_hp_goal;
  }

  void mp_effectiveness(__RestorationEffectiveness effectiveness){
    if(effectiveness.uses_to_mp_goal == -1 || effectiveness.mp_cost_per_use > 0){
      effectiveness.mp_effectiveness_value = 0;
      effectivenes.mp_effectiveness_cost_modifier = 0;
      effectiveness.total_mp_restored = 0;
      return;
    }

    int mp_effectiveness_value = 0;
    int mp_effectiveness_cost_modifier = 0;

    if(effectiveness.total_uses_needed > 1){
      mp_effectiveness_value = effectiveness.mp_restored_per_use * (effectiveness.uses_to_mp_goal - 1);
      int wasted_on_last_use = mp_wasted_by(starting_mp + mp_effectiveness_value);
      mp_effectiveness_value += effectiveness.mp_restored_per_use - wasted_on_last_use;
      mp_effectiveness_cost_modifier -= wasted_on_last_use;
    } else{
      mp_effectiveness_value = effectiveness.mp_restored_per_use - mp_wasted_by(starting_mp);
      mp_effectiveness_cost_modifier -= mp_wasted_by(starting_mp);
    }

    //case when using hp+mp restore with a higher hp goal than mp, calculate extra uses as wasteful
    mp_effectiveness_cost_modifier -= (effectiveness.total_uses_needed - effectiveness.uses_to_mp_goal) * effectiveness.mp_restored_per_use;

    effectiveness.mp_effectiveness_value = mp_effectiveness_value;
    effectivenes.mp_effectiveness_cost_modifier = mp_effectiveness_cost_modifier;
    effectiveness.total_mp_restored = effectiveness.mp_restored_per_use * effectiveness.uses_to_mp_goal;
  }

  __RestorationEffectiveness effectiveness;
  effectiveness.hp_goal = hp_goal;
  effectiveness.starting_hp = starting_hp;
  effectiveness.mp_goal = mp_goal;
  effectiveness.starting_mp = starting_mp;
  effectiveness.hp_restored_per_use = hp_restored_per();
  effectiveness.hp_restored_per_use = mp_restored_per();
  effectiveness.uses_available = uses_on_hand();
  effectiveness.uses_to_hp_goal = uses_needed_to_reach_hp_goal();
  effectiveness.uses_to_mp_goal = uses_needed_to_reach_mp_goal();
  effectiveness.total_uses_needed = max(effectiveness.uses_to_hp_goal, effectiveness.uses_to_mp_goal);
  effectiveness.mp_cost_per_use = mp_cost_per();
  effectiveness.meat_cost_per_use = meat_cost_per();
  hp_effectiveness(effectiveness);
  mp_effectiveness(effectiveness);
  effectiveness.total_meat_spent = effectiveness.meat_cost_per_use * max(effectiveness.total_uses_needed - effectiveness.uses_available, 0);
  effectiveness.total_value = (effectiveness.mp_effectiveness_value + effectiveness.hp_effectiveness_value) - (effectivenes.mp_effectiveness_cost_modifier + effectivenes.hp_effectiveness_cost_modifier);
  return effectivenes;
}

boolean __is_useable(__RestorationMetadata metadata){
  if(metadata == __NO_RESTORATION_METADATA){
    return false;
  }
  if(metadata.type == "item"){
    return auto_is_valid(to_item(metadata.name));
  }
  if(metadata.type == "skill"){
    return auto_is_valid(to_skill(metadata.name));
  }
}

__RestorationMetadata __most_effective_restore(int goal_hp, int starting_hp, int goal_mp, int starting_mp, boolean buyItems, boolean useFreeRests){

  __RestorationMetadata best = __NO_RESTORATION_METADATA;
  __RestorationEffectiveness best_effectiveness = __NO_EFFECTIVENESS;

  foreach name, metadata in __known_restoration_sources {
    //cant use this skill/item in current path
    if(!__is_useable(metadata)){
      continue;
    }

    //caller doesnt want to rest (or is out of free rests)
    if(metadata.type == "dwelling" && (!useFreeRests ||
      (to_item(metadata.name) == $item[Chateau Mantegna Room Key] && !chateaumantegna_available()) ||
      (to_item(metadata.name) == $item[Distant Woods Getaway Brochure] && !auto_campawayAvailable()) ||
      get_dwelling() != to_item(metadata.name)))){
      continue;
    }

    __RestorationEffectiveness effectiveness = __determin_effectiveness(goal_hp, starting_hp, goal_mp, starting_mp, metadata);

    //dont have enough items on hand
    if(metadata.type == "item" && !buyItems && effectiveness.uses_available < effectiveness.total_uses_needed){
      continue
    }

    if(effectiveness.total_value > best_effectiveness.total_value){
      best_effectiveness = effectivenes;
      best = metadata;
    }
  }

  return best;
}

boolean __use_restore(int count, __RestorationMetadata metadata){
  if(metadata == __NO_RESTORATION_METADATA){
    return false;
  }

  print("Using " + metadata.type + " " + metadata.name + " as restore.");
  if(metadata.type == "item"){
    return use(count, to_item(metadata.name));
  }

  if(metadata.type == "dwelling"){
    return doFreeRest();
  }

  if(metadata.type == "skill"){
    return use_skill(count, to_skill(metadata.name));
  }
}

/**
 * Public Interface
 */

boolean acquireMP(){
	return acquireMP(my_maxmp());
}

boolean acquireMP(int goal)
{
	return acquireMP(goal, false);
}

boolean acquireMP(int goal, boolean buyIt){
	return acquireMP(goal, buyIt, freeRestsRemaining() > 2);
}

boolean acquireMP(int goal, boolean buyIt, boolean freeRest)
{
	if(goal > my_maxmp())
	{
		return false;
	}

	if(my_mp() >= goal)
	{
		return true;
	}

	// Sausages restore 999MP, this is a pretty arbitrary cutoff but it should reduce pain
	if(my_maxmp() - my_mp() > 300)
	{
		auto_sausageEatEmUp(1);
	}

	if(freeRest){
		while(haveFreeRestAvailable() && my_mp() < goal){
			// dont waste free IotM rests since they are pretty valuable
			if((chateaumantegna_available() || auto_campawayAvailable()) && my_maxmp() - my_mp() < 100){
				int mp_waste = 125 - min(125, my_maxmp() - my_mp());
				int hp_waste = 250 - min(250, my_maxhp() - my_hp());
				if(mp_waste > 80 && hp_waste > 200){
					break;
				}
			}
			doFreeRest();
		}
	}

	item[int] recovers = List($items[Holy Spring Water, Spirit Beer, Sacramental Wine, Magical Mystery Juice, Black Cherry Soda, Doc Galaktik\'s Invigorating Tonic, Carbonated Soy Milk, Natural Fennel Soda, Grogpagne, Bottle Of Monsieur Bubble, Tiny House, Marquis De Poivre Soda, Cloaca-Cola, Phonics Down, Psychokinetic Energy Blob]);
	int at = 0;
	while((at < count(recovers)) && (my_mp() < goal))
	{
		item it = recovers[at];
		int expectedMP = (it.minmp + it.maxmp) / 2;
		int overage = (my_mp() + expectedMP) - goal;
		if(overage > 0)
		{
			float waste = overage / expectedMP;
			if(waste > 0.35)
			{
				at++;
				continue;
			}
		}

		if(!glover_usable(it))
		{
			at++;
			continue;
		}

		if(item_amount(it) > 0)
		{
			int count = item_amount(it);
			use(1, it);
			if(count == item_amount(it))
			{
				print("Failed using item " + it + "!", "red");
				return false;
			}
			continue;
		}
		at++;
	}

	while(buyIt && (my_mp() < goal))
	{
		boolean gLoverBlock = (auto_my_path() == "G-Lover");
		item goal = $item[none];

		if(($classes[Pastamancer, Sauceror] contains my_class()) && guild_store_available() && (my_level() >= 5))
		{
			goal = $item[Magical Mystery Juice];
		}
		else if((get_property("questM24Doc") == "finished") && isGeneralStoreAvailable() && (my_meat() > npc_price($item[Doc Galaktik\'s Invigorating Tonic])))
		{
			goal = $item[Doc Galaktik\'s Invigorating Tonic];
		}
		else if(black_market_available() && (my_meat() > npc_price($item[Black Cherry Soda])) && !gLoverBlock)
		{
			goal = $item[Black Cherry Soda];
		}
		else if(isGeneralStoreAvailable() && (my_meat() > npc_price($item[Doc Galaktik\'s Invigorating Tonic])))
		{
			goal = $item[Doc Galaktik\'s Invigorating Tonic];
		}

		if(goal != $item[none])
		{
			buyUpTo(1, goal, 100);
		}

		if(item_amount(goal) > 0)
		{
			int have = item_amount(goal);
			use(1, goal);
			if(have == item_amount(goal))
			{
				print("Failed using item " + goal + "!", "red");
				return false;
			}
		}
		else
		{
			break;
		}
	}

	return (my_mp() >= goal);
}

boolean acquireMP(float goalPercent){
	return acquireMP(goalPercent, false);
}

boolean acquireMP(float goalPercent, boolean buyIt){
	return acquireMP(goalPercent, buyIt, freeRestsRemaining() > 2);
}

boolean acquireMP(float goalPercent, boolean buyItm, boolean freeRest){
	int goal = my_maxmp();
	if(goalPercent > 1.0){
		goal = ceil((goalPercent/100.0) * my_maxmp());
	} else{
		goal = ceil(goalPercent*my_maxmp());
	}
	return acquireMP(goal.to_int(), buyItm, freeRest);
}

boolean acquireHP(){
	return acquireHP(my_maxhp());
}

boolean acquireHP(int goal){
	return acquireHP(goal, false);
}

boolean acquireHP(int goal, boolean buyIt){
	return acquireHP(goal, buyIt, false);
}

// TODO: not actually implemented yet
boolean acquireHP(int goal, boolean buyItems, boolean useFreeRests){

	if(goal > my_maxhp()){
		goal = my_maxhp();
	}

	// let mafia figure out how to best remove beaten up
	if(have_effect($effect[Beaten Up]) > 0){
		print("Ouch, you got beaten up. Lets get you patched up, if we can.");
		uneffect($effect[Beaten Up]);

		if(have_effect($Effect[Beaten Up]) > 0){
			print("Well, you're still beaten up, thats probably not great...", "red");
		}
	}

	print("Target HP => "+goal+" - Considering healing options at " + my_hp() + "/" + my_maxhp() + " HP with " + my_mp() + "/" + my_maxmp() + " MP", "blue");
	while(my_hp() < goal){
    __RestorationMetadata best_restore = __most_effective_restore(goal, my_hp(), 0, my_mp(), buyItems, useFreeRests);
    if(!__use_restore(best_restore)){
			print("Uh, couldnt determine an effective healing mechanism. Sorry.", "red");
			return false;
    }

		skill healing = mostEffectiveSkill(goal);
		if(restingIsMostEffective(goal, buyItm, freeRest)){
			print("Using rest (effectiveness value: "+ restEffectivenessValue(goal, freeRest) +", free: " + haveFreeRestAvailable() + ")");
			doRest();
		} else if(healing != $skill[none]){
			print("Using " + healing + " (effectiveness value: " + effectiveness(healing, goal) + ")");
			use_healing_skill(healing, goal, buyItm);
		} else{
			print("Uh, couldnt determine an effective healing mechanism. Sorry.", "red");
			return false;
		}
	}

	return true;
}

boolean acquireHP(float goalPercent){
	return acquireHP(goalPercent, false);
}

boolean acquireHP(float goalPercent, boolean buyItm){
	return acquireHP(goalPercent, buyItm, freeRestsRemaining() > 2);
}

boolean acquireHP(float goalPercent, boolean buyItm, boolean freeRest){
	int goal = my_maxhp();
	if(goalPercent > 1.0){
		goal = ceil((goalPercent/100.0) * my_maxhp());
	} else{
		goal = ceil(goalPercent*my_maxhp());
	}
	return acquireHP(goal.to_int(), buyItm, freeRest);
}

/*
 * Use a rest (can consume adventures if no free rests remain). Also attempts to maximize
 * chateau bonus from resting if possible.
 *
 * TODO: if resting in campaway camp, check if we can/should use a burnt stick to get extra stats
 *
 * returns the number of times rested today (caller will have to work out if it rested or not)
 */
int doRest()
{
	if(chateaumantegna_available())
	{
		cli_execute("outfit save Backup");
		chateaumantegna_nightstandSet();

		boolean[item] restBonus = chateaumantegna_decorations();
		stat bonus = $stat[none];
		if(restBonus contains $item[Electric Muscle Stimulator])
		{
			bonus = $stat[Muscle];
		}
		else if(restBonus contains $item[Foreign Language Tapes])
		{
			bonus = $stat[Mysticality];
		}
		else if(restBonus contains $item[Bowl of Potpourri])
		{
			bonus = $stat[Moxie];
		}

		boolean closet = false;
		item grab = $item[none];
		item replace = $item[none];
		switch(bonus)
		{
		case $stat[Muscle]:
			replace = equipped_item($slot[off-hand]);
			grab = $item[Fake Washboard];
			if(can_equip($item[LOV Eardigan]) && (item_amount($item[LOV Eardigan]) > 0))
			{
				equip($slot[shirt], $item[LOV Eardigan]);
			}
			break;
		case $stat[Mysticality]:
			replace = equipped_item($slot[off-hand]);
			grab = $item[Basaltamander Buckler];
			if(can_equip($item[LOV Epaulettes]) && (item_amount($item[LOV Epaulettes]) > 0))
			{
				equip($slot[back], $item[LOV Epaulettes]);
			}
			break;
		case $stat[Moxie]:
			replace = equipped_item($slot[weapon]);
			grab = $item[Backwoods Banjo];
			if(can_equip($item[LOV Earrings]) && (item_amount($item[LOV Earrings]) > 0))
			{
				equip($slot[acc1], $item[LOV Earrings]);
			}
			break;
		}

		if((grab != $item[none]) && possessEquipment(grab) && (replace != grab) && can_equip(grab))
		{
			equip(grab);
		}
		if(!possessEquipment(grab) && (replace != grab) && (closet_amount(grab) > 0) && can_equip(grab))
		{
			closet = true;
			take_closet(1, grab);
			equip(grab);
		}

		visit_url("place.php?whichplace=chateau&action=chateau_restbox");

		if((replace != grab) && (replace != $item[none]))
		{
			equip(replace);
		}
		cli_execute("outfit Backup");
		if(closet)
		{
			if(item_amount(grab) > 0)
			{
				put_closet(1, grab);
			}
		}

	}
	else
	{
		set_property("restUsingChateau", false);
		cli_execute("rest");
		set_property("restUsingChateau", true);
	}
	return get_property("timesRested").to_int();
}

boolean haveFreeRestAvailable(){
	return get_property("timesRested").to_int() < total_free_rests();
}

int freeRestsRemaining(){
	return max(0, total_free_rests() - get_property("timesRested").to_int());
}

boolean haveAnyIotmAlternateCampsight(){
	return chateaumantegna_available() || auto_campawayAvailable();
}

/*
 * Try to use a free rest.
 *
 * returns true if a rest was used false if it wasnt (for any reason)
 */
boolean doFreeRest(){
	if(haveFreeRestAvailable()){
		int rest_count = get_property("timesRested").to_int();
		return doRest() > rest_count;
	}
	return false;
}

/*
 * Do a rest if the conditions are met. If either hp or mp remaining is below
 * their respective thesholds, it will try to rest.
 *
 * hp_threshold is the percent of hp (out of 1.0, e.g. 0.8 = 80%) below which it will try to rest
 * mp_threshold is the percent of mp (out of 1.0, e.g. 0.8 = 80%) below which it will try to rest
 * freeOnly will only try to rest if it is free when set to true, otherwise will always rest if the above thesholds are met
 *
 * returns true if a rest was used, false if it wasnt (for any reason)
 */
boolean doRest(float hp_threshold, float mp_threshold, boolean freeOnly){
	float hp_percent = 1.0 - ((my_maxhp() - my_hp()) / my_maxhp());
	float mp_percent = 1.0 - ((my_maxmp() - my_mp()) / my_maxmp());
	if(hp_percent < hp_threshold || mp_percent < mp_threshold){
		if(freeOnly){
			return doFreeRest();
		} else{
			int rest_count = get_property("timesRested").to_int();
			return doRest() > rest_count;
		}
	}
	return false;
}

float mp_regen()
{
	return 0.5 * (numeric_modifier("MP Regen Min") + numeric_modifier("MP Regen Max"));
}

float hp_regen()
{
	return 0.5 * (numeric_modifier("HP Regen Min") + numeric_modifier("HP Regen Max"));
}

boolean uneffect(effect toRemove)
{
	if(have_effect(toRemove) == 0)
	{
		return true;
	}
	if(($effects[Driving Intimidatingly, Driving Obnoxiously, Driving Observantly, Driving Quickly, Driving Recklessly, Driving Safely, Driving Stealthily, Driving Wastefully, Driving Waterproofly] contains toRemove) && (auto_get_campground() contains $item[Asdon Martin Keyfob]))
	{
		string temp = visit_url("campground.php?pwd=&preaction=undrive");
		return true;
	}

	if(cli_execute("uneffect " + toRemove))
	{
		//Either we don\'t have the effect or it is shruggable.
		return true;
	}

	if(item_amount($item[Soft Green Echo Eyedrop Antidote]) > 0)
	{
		visit_url("uneffect.php?pwd=&using=Yep.&whicheffect=" + to_int(toRemove));
		print("Effect removed by Soft Green Echo Eyedrop Antidote.", "blue");
		return true;
	}
	else if(item_amount($item[Ancient Cure-All]) > 0)
	{
		visit_url("uneffect.php?pwd=&using=Yep.&whicheffect=" + to_int(toRemove));
		print("Effect removed by Ancient Cure-All.", "blue");
		return true;
	}
	return false;
}

boolean useCocoon()
{
	if((have_effect($effect[Beaten Up]) > 0 || my_maxhp() <= 70) && have_skill($skill[Tongue Of The Walrus]) && my_mp() >= mp_cost($skill[Tongue Of The Walrus]))
	{
		use_skill(1, $skill[Tongue Of The Walrus]);
	}

	if(my_hp() >= my_maxhp())
	{
		return true;
	}

	int mpCost = 0;
	int casts = 1;
	skill cocoon = $skill[none];
	if(have_skill($skill[Cannelloni Cocoon]))
	{
		print("Considering using Cocoon at " + my_hp() + "/" + my_maxhp() + " HP with " + my_mp() + "/" + my_maxmp() + " MP", "blue");

		boolean canUseFamiliars = have_familiar($familiar[Mosquito]);
		skill blood_skill = $skill[none];
		if(auto_have_skill($skill[Blood Bubble]) && auto_have_skill($skill[Blood Bond]))
		{
			if(have_effect($effect[Blood Bubble]) > have_effect($effect[Blood Bond]) && canUseFamiliars)
			{
				blood_skill = $skill[Blood Bond];
			}
			else
			{
				blood_skill = $skill[Blood Bubble];
			}
		}
		else if(auto_have_skill($skill[Blood Bubble]))
		{
			blood_skill = $skill[Blood Bubble];
		}
		else if(auto_have_skill($skill[Blood Bond]) && canUseFamiliars)
		{
			blood_skill = $skill[Blood Bond];
		}
		cocoon = $skill[Cannelloni Cocoon];
		mpCost = mp_cost(cocoon);
		int hpNeed = ceil((my_maxhp() - my_hp()) / 1000.0);
		int maxCasts = my_mp() / mpCost;
		casts = min(hpNeed, maxCasts);
		if(auto_beta() && blood_skill != $skill[none] && casts > 0)
		{
			int healto = my_hp() + 1000 * casts;
			int wasted = min(max(healto - my_maxhp(), 0), my_hp() - 1);
			int blood_casts = wasted / 30;
			use_skill(blood_casts, blood_skill);
		}
	}
	else if(have_skill($skill[Shake It Off]))
	{
		cocoon = $skill[Shake It Off];
		mpCost = mp_cost(cocoon);
	}
	else if(have_skill($skill[Gelatinous Reconstruction]))
	{
		cocoon = $skill[Gelatinous Reconstruction];
		mpCost = mp_cost(cocoon);
		int hpNeed = (my_maxhp() - my_hp()) / 15;
		int maxCasts = my_mp() / mpCost;
		int worst = min(hpNeed, maxCasts);
		casts = min(worst, 7);
	}

	if(cocoon == $skill[none])
	{
		return false;
	}
	if(casts > 0 && my_mp() >= (mpCost * casts))
	{
		use_skill(casts, cocoon);
		return true;
	}
	return false;
}

boolean main(string type, int amount) {
  if(type == "MP"){
    acquireMP(amount);
  } else if(type == "HP"){
    acquireHP(amount);
  }
	return true;	// This ensures that mafia does not attempt to heal with resources that are being conserved.
}
