//bool, Settlement set, str tech

int gold, food;

if (IsResearched(set, tech))
{
	return true;
}

if (GetCmdCost(tech, gold, food))
{
	if (gold <= set.gold && food <= set.food) if (set.CanResearch(tech))
	{
		set.SpentGoldOnTech(gold);
		set.Research(tech);
	}
}
return false;
