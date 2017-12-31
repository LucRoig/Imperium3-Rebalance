//bool, ObjList objs, str OUT reasonText

if(EnvReadString(objs[0].player, "learn") == "researched")
	return true;

reasonText = rollover(objs[0],true);
return false;

