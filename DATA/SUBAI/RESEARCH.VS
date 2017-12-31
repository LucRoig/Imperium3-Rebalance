// void, Obj This 
// cmdparam is like this ReqSet, <research>, ReqPlr, <research>, SetsPlr, <env>, <value>, SetsSet, <env>, <value>, NamePlr, <research>, NameSet, <research>

str dest, name, token;
Building this;
this = This.AsBuilding();
dest = cmdparam;

EnvWriteString(this, "researching", "yes");

while(dest != "")
{
	token = ParseStr(dest, dest);
	if(token == "NamePlr")
	{
		name = ParseStr(dest, dest);
		EnvWriteString(.player, name, "researching");
		if (name == "Tribute") {
			Building th;
			th = .settlement.GetCentralBuilding;
			th.GlobalSpellStart(gsTribute, .player);
			EnvWriteObj(.player, "TributeBuilding", th);
			PlaySound("data/Sound Entities/StonehengeSpell.xml");
		}
		break;
	}
	if(token == "NameSet")
	{
		name = ParseStr(dest, dest);
		EnvWriteString(.settlement, name, "researching");
		break;
	}
}

.Progress();
PlaySound(.player, "data/Sounds Entities/UpgradeComplete.xml");
