//void, Obj this, Settlement sett
int money;
int gold;
Item item;
int i;

if (!sett.IsValid)
	return;

if (sett.GetCentralBuilding.AsCatapult)
	return;

if( sett.GetCentralBuilding.IsHeirOf("BaseRuins") )
	return;

// spoils of war
gold = GetConst("SpoilsOfWarGold");
money = .AsUnit.RemoveItemsOfType("Spoils of War");
if (money) {
	sett.SetGold(sett.gold + money * gold);
	sett.GoldConverted(money * gold);
}

// mercenary pact
if (EnvReadString(.player, "Mercenary pact")=="researched")
  {
	for (i=1; i<=.item_count; i+=1)
	  {
		item = .GetItem(i);
		if (!item.IsValid) 
		  continue;	
		if (item.name == "Gold")
		  {
			sett.SetGold(sett.gold + item.use_count);
			sett.GoldConverted(item.use_count);
			item.SetUseCount(0);
		  }		  
	  }
  }