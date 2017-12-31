//void, Obj This

Obj target;
Catapult this;
bool bChange;

this = This.AsCatapult;
if(!.IsValid)
	return;

while (.IsAlive)
{
	if (.CmdCount() > 1)
		break;
	if (.settlement.UnitsCount <= 0)
		break;
	target = .GetCurrentTarget;
	.SetTarget(target);//I'm doing this to set the target of the fake tower!
	bChange = false;
	if (!target.IsValid)
		bChange = true;
	else
		if (!target.IsAlive || !.IsEnemy(target) || !.IsValidTarget(target))
			bChange = true;
		else {
			Building bld;	bld = target.AsBuilding;
			if (bld.IsValid)
			if (bld.IsVeryBroken)
			if (!bld.IsCentralBuliding || bld.settlement.UnitsCount == 0)
				bChange = true;
		}
	if (bChange) {
		target = .BestTarget();
		if(target.IsValid())
		{
			.SetTarget( target );
		}
	}
	Sleep(1000);
}
