boolean in_iluh()
{
	return my_path() == $path[11 Things I Hate About U];
}

boolean iluh_foodConsumable(string str)
{
	if(!in_iluh())
	{
		return true;
	}

	//can't consume anything with a u in it. Must have an i in it
	if(contains_text(str.to_lower_case(), "u"))
	{
		return false;
	}
	if(contains_text(str.to_lower_case(), "i"))
	{
		return true;
	}
	
	return false;
}

boolean iluh_famAllowed(string fam)
{
	if(!in_iluh())
	{
		return true;
	}
	//Is there an acceptable number of u's? Familiars with u's in name deal 10-20 sleaze damage per U each round
	if(contains_text(fam.to_lower_case(), "u"))
	{
		return false;
	}
	return true;
}