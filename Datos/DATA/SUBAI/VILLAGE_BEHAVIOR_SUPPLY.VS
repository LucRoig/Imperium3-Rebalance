// void, Obj This

Settlement this;
int min_resource, minpop, i;
int nSendGold, nSendFood;
Wagon wagon;
ObjList olBuildings;
bool bBrokenVillage = false;

this = This.AsBuilding().settlement;
min_resource = GetConst("MinResQtyToTransport");
minpop = GetConst("MinPopulation");

Sleep(rand(2000) + 1000);

while (1)
{
	Sleep(3000);
	if (.supplied == this)
		.StopSupply();
	if (!.supplied.IsValid()) continue;
	if (.IsEnemy(.supplied.player))
		continue;
	
	bBrokenVillage = false;
	if (.population < minpop)
	{	// hold 1000 gold to can repear
		bBrokenVillage = true;
		if (!.GetCentralBuilding().IsBroken())
		if (!.GetCentralBuilding().IsVeryBroken())
			bBrokenVillage = false;
		olBuildings = .Buildings();
		for (i = 0; i < olBuildings.count;i += 1)
		{
			Building b; b = olBuildings[i];
			if (!b.IsValid) continue;
			if ((b.IsBroken() || b.IsVeryBroken())) {
				bBrokenVillage = true;
				break;
			}
		}
	}
	nSendGold = .gold;
	nSendFood = .food;
	if (bBrokenVillage) {
		int gold, food;
		if (GetCmdCost("repair village", gold, food)) {
			nSendGold -= gold;
			nSendFood -= food;
		}
	}
	if (nSendGold > min_resource)
	if (!.supplied.IsTTent())
	{
		wagon = .CreateMuleGold(MIN(1000, nSendGold));
		wagon.SetCommand("unload", .supplied.GetCentralBuilding());
		wagon.AddCommand(false, "unload", .GetCentralBuilding()); // return back is somthing happens
		continue;
	}
	if (nSendFood > min_resource)
	{
		wagon = .CreateMuleFood(MIN(1000, nSendFood));
		wagon.SetCommand("unload", .supplied.GetCentralBuilding());
		wagon.AddCommand(false, "unload", .GetCentralBuilding()); // return back is somthing happens
		continue;
	}
}
