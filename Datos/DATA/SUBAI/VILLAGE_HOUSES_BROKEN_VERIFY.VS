//bool, ObjList objs, str OUT reasonText

Building this;

this = objs[0].AsBuilding;

if (.IsValid())
	if (.settlement.IsVillage()) // when anuy village house is damages
	{
		ObjList olBuildings;
		int i;
		olBuildings = .settlement.Buildings();
		for (i=0; i<olBuildings.count;i+=1)
		{
			Building b;
			b = olBuildings[i];
			if (!b.IsValid) continue;
			if (b.IsBroken() && b.IsVeryBroken() && .settlement.population<GetConst("MinPopulation"))
			return false;	
		}
	}
return true;
