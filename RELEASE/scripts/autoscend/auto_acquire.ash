// functions that deal with acquiring items. via buying or pulling

boolean haveAny(boolean[item] array)
{
	foreach thing in array
	{
		if(item_amount(thing) > 0)
		{
			return true;
		}
	}
	return false;
}

boolean acquireOrPull(item it)
{
	//this function is for when you want to make sure you have 1 of an item
	//if you have one it returns true. if you don't it will craft one. if it can't it will pull it.
	
	if(possessEquipment(it)) return true;
	if(item_amount(it) > 0)  return true;
	if(retrieve_item(1, it)) return true;
	if(canPull(it))
	{
		if(pullXWhenHaveY(it, 1, 0)) return true;
	}
	
	//special handling via pulling 1 ingredient to craft the item desired
	if($items[asteroid belt, meteorb, shooting morning star, meteorite guard, meteortarboard, meteorthopedic shoes] contains it)
	{
		if(canPull($item[metal meteoroid]))
		{
			if(pullXWhenHaveY($item[metal meteoroid], 1, 0))
			{
				if(retrieve_item(1, it)) return true;
			}
		}
	}
	
	return false;
}

boolean canPull(item it, boolean historical)
{
	if(in_hardcore())
	{
		return false;
	}
	if(it == $item[none])
	{
		return false;
	}
	if(!is_unrestricted(it))
	{
		return false;
	}
	if(pulls_remaining() == 0)
	{
		return false;
	}
	
	if(storage_amount(it) > 0)
	{
		return true;	//we have it in storage so we can pull it
	}
	else if(!is_tradeable(it))
	{
		return false;	//we do not have it in storage and we can not trade for it. gifts currently not handled
	}

	int meat = my_storage_meat();
	if(can_interact())
	{
		meat = max(meat, my_meat() - 5000);
	}
	int curPrice = historical_price(it);
	if(!historical)
	{
		curPrice = auto_mall_price(it);
	}
	if(curPrice < 1)
	{
		return false;	//a 0 or a -1 indicates the item is not available.
	}
	if (curPrice > get_property("autoBuyPriceLimit").to_int())
	{
		return false;
	}
	else if (curPrice < meat)
	{
		return true;
	}
	
	return false;
}

boolean canPull(item it)
{
	return canPull(it, false);
}

void pullAll(item it)
{
	if(storage_amount(it) > 0)
	{
		take_storage(storage_amount(it), it);
	}
}

void pullAndUse(item it, int uses)
{
	pullAll(it);
	while((item_amount(it) > 0) && (uses > 0))
	{
		use(1, it);
		uses = uses - 1;
	}
}

int auto_mall_price(item it)
{
	if(isSpeakeasyDrink(it))
	{
		return -1;	//speakeasy drinks are marked as tradeable but cannot be acquired as a physical item to trade.
	}
	if(available_choice_options() contains 0 || available_choice_options() contains 1)	//we are in a choice adventure.
	{
		//mafia returns -1 if we check mall_price() while in a choice adv. better to use historical price even if it is outdated
		return historical_price(it);
	}
	if(is_tradeable(it))
	{
		int retval = mall_price(it);
		if(retval == -1)
		{
			//0 could be due to item not being tradeable.
			//-1 could be due to tradeable item not found in the mall. Or due to an IO error during lookup
			//-1 is non trivial to fix due to mafia anti abuse code
			//historical price can never be -1. only 0 or a positive number
			//just use the historical price. It will be good enough. it never returns -1. and if it returns 0 it is because this mafia install never happened to look up that item before. which suggests an extreme edge case or that the item is really unavailable
			return historical_price(it);
		}
		return retval;
	}
	return -1;
}

boolean pullXWhenHaveY(item it, int howMany, int whenHave)
{
	if(auto_my_path() == "Community Service")
	{
		return false;
	}
	if(in_hardcore())
	{
		return false;
	}
	if(it == $item[none])
	{
		return false;
	}
	if(!is_unrestricted(it) && !inAftercore())
	{
		return false;
	}
	if(pulls_remaining() == 0)
	{
		return false;
	}
	if (!auto_is_valid(it))
	{
		return false;
	}
	if((item_amount(it) + equipped_amount(it)) == whenHave)
	{
		int lastStorage = storage_amount(it);
		while(storage_amount(it) < howMany)
		{
			int oldPrice = historical_price(it) * 1.2;
			int curPrice = auto_mall_price(it);
			int meat = my_storage_meat();
			boolean getFromStorage = true;
			if(can_interact() && (meat < curPrice))
			{
				meat = my_meat() - 5000;
				getFromStorage = false;
			}
			if (curPrice >= 30000)
			{
				auto_log_warning(it + " is too expensive at " + curPrice + " meat, we're gonna skip buying one in the mall.", "red");
				break;
			}
			if((curPrice <= oldPrice) && (curPrice < 30000) && (meat >= curPrice))
			{
				if(getFromStorage)
				{
					buy_using_storage(howMany - storage_amount(it), it, curPrice);
				}
				else
				{
					howMany -= buy(howMany - storage_amount(it), it, curPrice);
				}
			}
			else
			{
				if(curPrice > oldPrice)
				{
					auto_log_warning("Price of " + it + " may have been mall manipulated. Expected to pay at most: " + oldPrice, "red");
				}
				if(my_storage_meat() < curPrice)
				{
					auto_log_warning("Do not have enough meat in Hagnk's to buy " + it + ". Need " + curPrice + " have " + my_storage_meat() + ".", "blue");
					if(curPrice > 10000000)
					{
						auto_log_warning("You must be a poor meatbag.", "green");
					}
				}
			}
			if(lastStorage == storage_amount(it))
			{
				break;
			}
			lastStorage = storage_amount(it);
		}

		if(storage_amount(it) < howMany)
		{
			auto_log_warning("Can not pull what we don't have. Sorry");
			return false;
		}

		auto_log_info("Trying to pull " + howMany + " of " + it, "blue");
		boolean retval = take_storage(howMany, it);
		if(item_amount(it) != (howMany + whenHave))
		{
			auto_log_warning("Failed pulling " + howMany + " of " + it, "red");
		}
		else
		{
			for(int i = 0; i < howMany; ++i)
			{
				handleTracker(it, "auto_pulls");
			}
		}
		return retval;
	}
	return false;
}

boolean pulverizeThing(item it)
{
	if(!have_skill($skill[Pulverize]))
	{
		return false;
	}
	if(item_amount($item[Tenderizing Hammer]) == 0)
	{
		if(my_meat() < npc_price($item[Tenderizing Hammer]))
		{
			return false;
		}
	}

	if(item_amount(it) == 0)
	{
		if(closet_amount(it) == 0)
		{
			return false;
		}
		take_closet(1, it);
	}
	if(item_amount(it) == 0)
	{
		return false;
	}
	cli_execute("pulverize 1 " + it);
	return true;
}

boolean buyableMaintain(item toMaintain, int howMany)
{
	return buyableMaintain(toMaintain, howMany, 0, true);
}

boolean buyableMaintain(item toMaintain, int howMany, int meatMin)
{
	return buyableMaintain(toMaintain, howMany, meatMin, true);
}

boolean buyableMaintain(item toMaintain, int howMany, int meatMin, boolean condition)
{
	if((!condition) || (my_meat() < meatMin) || in_wotsf())
	{
		return false;
	}

	return buyUpTo(howMany, toMaintain);
}

boolean buy_item(item it, int quantity, int maxprice)
{
	take_closet(closet_amount(it), it);
	if(inAftercore())
	{
		take_storage(storage_amount(it), it);
	}
	while((item_amount(it) < quantity) && (auto_mall_price(it) < maxprice))
	{
		if(auto_mall_price(it) > my_meat())
		{
			abort("Don't have enough meat to restock, big sad");
		}
		if(buy(1, it, maxprice) == 0)
		{
			auto_log_info("Price of " + it + " exceeded expected mall price of " + maxprice + ".", "blue");
			return false;
		}
	}
	if(item_amount(it) < quantity)
	{
		if(auto_mall_price(it) >= maxprice)
		{
			auto_log_info("Price of " + it + " exceeded expected mall price of " + maxprice + ".", "blue");
		}
		return false;
	}
	return true;
}

boolean buyUpTo(int num, item it)
{
	return buyUpTo(num, it, 20000);
}

boolean buyUpTo(int num, item it, int maxprice)
{
	if(item_amount(it) >= num)
	{
		return true;	//we already have the target amount
	}
	if(($items[Ben-Gal&trade; Balm, Hair Spray] contains it) && !isGeneralStoreAvailable())
	{
		return false;
	}
	if(($items[Blood of the Wereseal, Cheap Wind-Up Clock, Turtle Pheromones] contains it) && !isMusGuildStoreAvailable())
	{
		return false;
	}

	int missing = num - item_amount(it);
	if(can_interact() && shop_amount(it) > 0 && mall_price(it) < maxprice)	//prefer to buy from yourself
	{
		take_shop(min(missing, shop_amount(it)), it);
		missing = num - item_amount(it);
	}
	if(missing > 0)
	{
		buy(missing, it, maxprice);
		if(item_amount(it) < num)
		{
			auto_log_warning("Could not buyUpTo(" + num + ") of " + it + ". Maxprice: " + maxprice, "red");
		}
	}
	return (item_amount(it) >= num);
}

float npcStoreDiscountMulti()
{
	//calculates a multiplier to be applied to store prices for our current discount for NPC stores.
	//does not bother with sleaze jelly or Post-holiday sale coupon
	
	float retval = 1.0;
	
	if(auto_have_skill($skill[Five Finger Discount]))
	{
		retval -= 0.05;
	}
	if(possessEquipment($item[Travoltan trousers]) && auto_is_valid($item[Travoltan trousers]))
	{
		retval -= 0.05;
	}
	
	return retval;
}

boolean acquireGumItem(item it)
{
	if(!isGeneralStoreAvailable())
	{
		return false;
	}

	if(!($items[Disco Ball, Disco Mask, Helmet Turtle, Hollandaise Helmet, Mariachi Hat, Old Sweatpants, Pasta Spoon, Ravioli Hat, Saucepan, Seal-Clubbing Club, Seal-Skull Helmet, Stolen Accordion, Turtle Totem, Worthless Gewgaw, Worthless Knick-Knack, Worthless Trinket] contains it))
	{
		return false;
	}

	int have = item_amount(it);
	auto_log_info("Gum acquistion of: " + it, "green");
	while((have == item_amount(it)) && (my_meat() >= npc_price($item[Chewing Gum on a String])))
	{
		buyUpTo(1, $item[Chewing Gum on a String]);
		use(1, $item[Chewing Gum on a String]);
	}

	return (have + 1) == item_amount(it);
}

boolean acquireTotem()
{
	//this function checks if you have a valid totem for casting turtle tamer buffs with. Returning true if you do. If you don't, it will attempt to acquire one in a reasonable manner.

	//check if there is a valid totem in inventory or equipped, return true if there is.
	//check the closet from best to worst. If found in closet, uncloset 1 and return true
	
	foreach totem in $items[primitive alien totem, flail of the seven aspects, chelonian morningstar, mace of the tortoise, ouija board\, ouija board, turtle totem]
	{
		if (possessEquipment(totem))
		{
			return true;
		}
		if (0 < closet_amount(totem))
		{
			take_closet(1, totem);
			return true;
		}
	}

	//try fishing in the sewer for a turtle totem
	
	if(acquireGumItem($item[turtle totem]))
	{
		return true;
	}
	
	//still could not get a totem. Give up
	return false;
}

boolean acquireHermitItem(item it)
{
	if(!isHermitAvailable())
	{
		return false;
	}
	if((item_amount($item[Hermit Permit]) == 0) && (my_meat() >= npc_price($item[Hermit Permit])))
	{
		buyUpTo(1, $item[Hermit Permit]);
	}
	if(item_amount($item[Hermit Permit]) == 0)
	{
		return false;
	}
	if(it == $item[Disassembled Clover])
	{
		it = $item[Ten-leaf Clover];
	}
	if(!($items[Banjo Strings, Catsup, Chisel, Figurine of an Ancient Seal, Hot Buttered Roll, Jaba&ntilde;ero Pepper, Ketchup, Petrified Noodles, Seal Tooth, Ten-Leaf Clover, Volleyball, Wooden Figurine] contains it))
	{
		return false;
	}
	if((it == $item[Figurine of an Ancient Seal]) && (my_class() != $class[Seal Clubber]))
	{
		return false;
	}
	if(!isGeneralStoreAvailable())
	{
		return false;
	}
	int have = item_amount(it);
	auto_log_info("Hermit acquistion of: " + it, "green");
	while((have == item_amount(it)) && ((my_meat() >= npc_price($item[Chewing Gum on a String])) || ((item_amount($item[Worthless Trinket]) + item_amount($item[Worthless Gewgaw]) + item_amount($item[Worthless Knick-knack])) > 0)))
	{
		if((item_amount($item[Worthless Trinket]) + item_amount($item[Worthless Gewgaw]) + item_amount($item[Worthless Knick-knack])) > 0)
		{
			if(it == $item[Ten-Leaf Clover])
			{
				have = item_amount($item[Disassembled Clover]);
			}
			if(!hermit(1, it))
			{
				return false;
			}
			if(it == $item[Ten-Leaf Clover])
			{
				if(have == item_amount($item[Disassembled Clover]))
				{
					return false;
				}
				else if((have + 1) == item_amount($item[Disassembled Clover]))
				{
					return true;
				}
				else
				{
					auto_log_warning("Invalid clover count from hermit behavior, reporting failure.", "red");
					return false;
				}
			}
		}
		else
		{
			buyUpTo(1, $item[Chewing Gum on a String]);
			use(1, $item[Chewing Gum on a String]);
		}
	}

	return (have + 1) == item_amount(it);
}

boolean pull_meat(int target)
{
	//pulls meat to reach the desired target amount. preferentially will pull items and autosell them.
	if(my_meat() >= target)
	{
		return true;	//already have target meat
	}
	if(pulls_remaining() < 1)		//hardcore returns 0. casual returns -1. both are < 1
	{
		return false;	//can not pull
	}
	if(in_wotsf())
	{
		return false;	//can not pull meat & autoselling items just donates them
	}
	
	//pull and autosell items
	while(my_meat() < target && pulls_remaining() > 0)
	{
		boolean fail = true;		//if true an item was not pulled and sold this loop
		foreach it in $items[1\,970 carat gold]
		{
			if(fail && storage_amount(it) > 0 && is_unrestricted(it))
			{
				if(pullXWhenHaveY(it, 1, 0) && autosell(1, it))		//pull and sell
				{
					fail = false;
				}
			}
		}
		if(fail) break;
	}
	
	//pull meat directly
	if(my_meat() < target && my_storage_meat() >= target)
	{
		float meat_pulls = target - my_meat();					//how much meat we need to pull. converted to float
		meat_pulls = ceil(meat_pulls / 1000.0);					//how many pulls it will require to get.
		meat_pulls = min(pulls_remaining(), meat_pulls);		//limit by remaining pulls
		int meat_pull_int = meat_pulls * 1000;		//we want to round it up to nearest 1000
		if(meat_pulls > 0)
		{
			cli_execute("pull " +meat_pull_int+ " meat");
		}
	}
	
	return my_meat() >= target;
}
