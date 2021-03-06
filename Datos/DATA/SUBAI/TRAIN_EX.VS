// void, Obj This

// this script train number of units, adds them to a group
// parm="numbertotrain, maxnumber, class, grouptoadd"

Building this;
str dest, numparam;
int numbertotrain, maxnumber;
str class, grouptoadd;

dest = cmdparam;

this = This.AsBuilding();

numbertotrain = Str2Int(ParseStr(dest, dest));
numparam = ParseStr(dest, dest);
if( numparam == "elephant" ) {
	maxnumber = EnvReadInt(.player, "MaxElephants") + 1;
}
else if( numparam == "axemen" ) {
	maxnumber = EnvReadInt(.player, "MaxAxemen");
}
else if( numparam == "huntress" ) {
	maxnumber = EnvReadInt(.player, "MaxHuntresses");
}
else if( numparam == "teutonrider" ) {
	maxnumber = EnvReadInt(.player, "MaxTeutonRiders");
}
else if( numparam == "macemen" ) {
	maxnumber = EnvReadInt(.player, "MaxMacemen");
}
else if (numparam == "mountaineer") {
	maxnumber = Str2Int(EnvReadString(.player, "MaxMountaineers"));
	if (maxnumber == 0)
		maxnumber = 10;
}
else {
	maxnumber = Str2Int(numparam);
}
class = ParseStr(dest, dest);
grouptoadd = ParseStr(dest, dest);

.Progress(.cmddelay);

EnvWriteString(this, "Build", class);
EnvWriteString(this, "BuildGroup", grouptoadd);
EnvWriteInt(this, "Build/"+class, numbertotrain);
EnvWriteInt(this, "Build/"+class+"maxnumber", maxnumber);
EnvWriteInt(this, "QueuedBuild/"+class, EnvReadInt(this, "QueuedBuild/"+class) - numbertotrain);
