//void, Obj THIS

Unit this;
Building bld;
Settlement sett;
Hero h;
Item item;
int gold;

this = THIS.AsUnit;
if (.IsValid) 
{
	if (!.IsMilitary()) return;	
	if (EnvReadString(.player, "Mercenary pact")=="researched")
	{
		h = .hero;
		if (!h.IsValid) return;
		gold = GetConst("MercenaryPactGold");
		item = h.FindItem("Gold");	
		if (item.IsValid()) // find item and add gold
			item.SetUseCount(item.use_count+gold);
		else // or spawn an item if there is space in inventory and add gold
			if (h.AddItem("Gold"))
			{
				item = h.FindItem("Gold");	
				item.SetUseCount(gold);					   
			}
	}
		
}