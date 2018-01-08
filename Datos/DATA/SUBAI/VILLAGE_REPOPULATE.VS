//void, Obj b

Building this;
ObjList olBuildings;
Building bld;
int i, minpop;

this = b.AsBuilding();
.Progress();

if(!.IsValid()) return;

minpop = GetConst("MinPopulation");
.settlement.SetPopulation(minpop);

olBuildings = .settlement.Buildings();
for (i = 0; i < olBuildings.count; i += 1)
{
	bld = olBuildings[i].AsBuilding();
	if (bld == this)
		continue;
	if (!bld.IsValid())
		continue;
	bld.RRepair();
}
.RRepair();
