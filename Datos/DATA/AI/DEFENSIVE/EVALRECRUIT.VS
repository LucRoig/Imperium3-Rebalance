//int, Squad sq, GAIKA g, GAIKA *gDepend

GAIKA gCurDest;
int   lsaPathLen;
Obj   teleport;
bool  bFightForFood = false;
int   nEval, nStateTime;
bool  bAssUnderFire = false;

bAssUnderFire = g.ID == EnvReadInt(sq.Player, "AssUnderFireGaika");

if (!bAssUnderFire)
if (sq.State != SS_IDLE)
if (sq.State != SS_Approach)
if (sq.State != SS_Wait)
if (sq.State != SS_ApproachWait)
if (sq.State != SS_Enter)
	return 0;

gCurDest = sq.AIDest;
if (gCurDest == g)
	return 0;

/// do not give tasks too often
nStateTime = sq.StateTime;
if (!bAssUnderFire)
if (nStateTime < 1000 * AIVar(sq.Player, AIV_SquadRecruitWait))
	return 0;

if (sq.Leader.AsShip.IsValid)
{
	if (sq.Leader.AsShip.HasAiTransport)
		return 0;
	if (!IsWaterLsa(g.LSA))
		return 0;
}
else
	if (IsWaterLsa(g.LSA))
		return 0;

if (AIVar(sq.Player, AIV_UseTeleports) != 0)
	teleport = FindTeleport(sq.Player, sq.pos, g.Center);
if (teleport.IsValid)
	lsaPathLen = 1;
else
	lsaPathLen = CheckLsaPath(sq.GAIKAIn.LSA, g.LSA, sq.Player);
if (lsaPathLen == 0)
	return 0;

// Defensive AI addition - don't attack GAIKAs that are not marked for attack
if (!g.GetControlFlag(sq.Player))
if (GetTime > 300000)
{
	if (g.Explored(sq.Player))
		return 0;
	else if (sq.Size>5)
		return 0;
}

// Do not explore with Liberati or Viking Lords (prevent scattering them and force using on purpose)
if (!bAssUnderFire)
if (sq.Leader.HasFreedom)
{
	if (sq.Leader.class == "BVikingLord")
	if (g.Eval(AI_STAYING, sq.Player, AI_ENEMY) < 500)
		return 0;
	if (g.settlement.IsIndependent)
	if (g.settlement.IsStronghold)
		return 0;
	if (!g.Explored(sq.Player))
		return 0;
}

if (g.settlement.IsVillage)
if (sq.GAIKAIn.settlement.IsStronghold)
if (sq.GAIKAIn.settlement.food < 100)
	bFightForFood = true;

if (!bAssUnderFire)
if (!bFightForFood) 
	if (sq.Leader.AsHero.IsValid)
	{
		//if (sq.SrcGAIKA == 0) // &&
		if (sq.GAIKAIn.settlement.IsStronghold)
		{
			int time, min;
			time = GetTime / 60000;
			if (time < 10) min = 15;
			else if (time < 20) min = 20;
			else if (time < 30) min = 31;
			else min = 41;
			if (sq.Size < min) 
				return 0;
		}

		if (!g.settlement.IsOwn(sq.Player) || !g.settlement.IsStronghold) // && 
		//if (sq.Leader.InHolder || sq.State == SS_Enter) // &&
		if (sq.health < sq.maxhealth * 8 / 10) // &&
		if (sq.GAIKAIn.settlement.IsValid)
		if (sq.GAIKAIn.settlement.food > 100)
			return 0; // heal first
	}
	else
	{
		if (sq.Units.count < 10)
		if (sq.Leader.GetHolderSett.IsTeutonTent)
			return 0;
		if (g.Explored(sq.Player))
		if (!g.settlement.IsIndependent)
		{
			Settlement s;
			s = sq.GAIKAIn.settlement;
			if (s.IsStronghold)
			if (!sq.HasFreedom)
			if (s.IsOwn(sq.Player)) 
				return 0; // Wait to attach before sending
		}
	}

if (!bAssUnderFire)
if (gCurDest.GetPriority(sq.Player) >= g.GetPriority(sq.Player))
	gDepend = gCurDest;

nEval = 100000 - sq.pos.Dist(g.Center) * lsaPathLen;

{ /// do not give tasks too often
	int nWeightTime;
	nWeightTime = AIVar(sq.Player, AIV_SquadRecruitWeight);
	if (nWeightTime > 0)
	{
		nStateTime = nStateTime / 1000;
		if (nStateTime < nWeightTime) {
			nEval = nEval * nStateTime / nWeightTime;
			if (nEval <= 0)
				nEval = 1;
		}
	}
}

return nEval;
