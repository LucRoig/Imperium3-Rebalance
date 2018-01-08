//bool, ObjList objs, str OUT reasonText

Building bld;
Settlement this;
int count_units;
bool bActivateCmd;
str charmitem;

count_units = 0;
bActivateCmd = false;
charmitem = cmdparam;
bld = objs[0].AsBuilding();
if (!bld.IsValid) return false;
this = bld.settlement;



if (EnvReadString(objs[0].AsBuilding(), "researching") == "yes")
  {
	reasonText = rollover(objs[0].AsBuilding(), true);
	return false;
  }


if (.IsValid) {
	ObjList l;
	int i;
	Unit u;

	l = .ObjectsAround("Military");
	for (i = l.count; i > 0;) {
		i -= 1;
		u = l[i].AsUnit();
		if (u.AsHero()) continue;
		if (!bld.IsEnemy(u) && !u.HasItem(charmitem) && !u.IsHeirOf("Sentry")) {
			count_units+=1;	
		}
	}	
}

if (count_units < 5)
  {
	reasonText = rollover(objs[0].AsBuilding(), false) + "\n<color 255 0 0 >" + Translate("Requires at least 5 warriors without that charm around the Townhall");
	return false;
  }
else if ((cmdcost_gold > .gold) || (cmdcost_food > .food) || (cmdcost_pop>0 && cmdcost_pop + GetConst("MinPopulation") > .population) )
  {
	reasonText = rollover(objs[0].AsBuilding(), true);
	return true; 
  }
else
  {	
	reasonText = rollover(objs[0].AsBuilding(), true);
	return true;
  }  
return true;