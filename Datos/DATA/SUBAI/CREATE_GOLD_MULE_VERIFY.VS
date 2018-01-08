//bool, ObjList objs, str OUT reasonText

int nMinRes;

nMinRes = GetConst("MinResQtyToTransport");
if(objs.count)
{
	Building bld;
	bld = objs[0].AsBuilding();
	if(bld.IsValid)
	{
		Settlement this;
		this = bld.settlement;

		if(.IsValid)
		{
			if (.IsVillage()) // when anuy village house is damages
			{
				ObjList olBuildings;
				int i;
				olBuildings = .Buildings();
				for (i=0; i<olBuildings.count;i+=1)
				{
					Building b;
					b = olBuildings[i];
					if (!b.IsValid) continue;
					if ((b.IsBroken() || b.IsVeryBroken()) && .population<GetConst("MinPopulation"))
					return false;	
				}
			}
			
			if(.gold < nMinRes)
			{
				reasonText = rollover(bld, true) + "\n<color 255 0 0>";
				reasonText = reasonText + Translatef("Requires %s1 gold", nMinRes);
				return false;
			}
		}
	}
}
return true;