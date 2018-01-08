//bool, ObjList objs, str OUT reasonText

// healing need not be researched
// if(EnvReadString(objs[0].player, "heal") == "researched")
	return true;

reasonText = Translate("Heal not available");
return false;
