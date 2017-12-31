Unit this, u;
Query q;

this = owner.AsUnit;
if (!.IsValid) return;

while (true)
{
	Sleep(2000);
	if (.health < .maxhealth * 8 / 10 + 10)
	continue;
	q = Intersect(ObjsInSight(this, "Unit"), EnemyObjs(.player, "Unit"));
	if (q.count < 1) 
	continue;
	u = q.GetObjList[rand(q.count)].AsUnit;
	if (u.IsDead)
	continue;
	u.Damage(.health - .maxhealth * 8 / 10);
	.Damage(.health - .maxhealth * 8 / 10);
	CreateFeedback("OffensiveTactics", u);
	CreateFeedback("Rage", this);
}
