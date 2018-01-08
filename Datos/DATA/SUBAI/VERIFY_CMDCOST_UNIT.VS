//bool, ObjList objs, str OUT reasonText

Unit this;
this = objs[0].AsUnit;
if (cmdcost_stamina > .stamina )
{
	reasonText = rollover(this,true);
	return false;
}

reasonText = rollover(this,true);
return true;
