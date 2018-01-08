//bool, ObjList objs, str OUT reasonText

if(EnvReadString(objs[0].AsBuilding.settlement, "specialization") != cmdparam)
	return true;
if( cmdparam != "" ) 
	reasonText = Translate("Currently specialized in this kind of weapon");
else
	reasonText = Translate("No weapons currently produced");
return false;
