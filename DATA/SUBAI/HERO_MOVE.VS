// void, Obj This, point pt
Hero this;
point dpt;

//.pr("hero::move");
this = This.AsHero();

// Ivko: Always walk in formation, so newly attached units automatically enter formation
.FormSetupAndMoveTo (pt, 0, 0, true);
while (.HasPath ())
{
  .FormKeepMoving (1500);
}

dpt = .GetFinalPartyOrientation() - Point(1024, 1024);
if (dpt.x != 0 || dpt.y != 0)
	.Face(.pos + dpt);

if (.IsAlive)
if (.HasArmy)
if (.CmdCount == 1)
{
	.army.SetCommand("stand_position");
	.AddCommand(false, "stand_position");
}
