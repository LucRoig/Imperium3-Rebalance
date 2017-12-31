//int, Squad sq, GAIKA g, GAIKA *gDepend

GAIKA gCurDest;
int   lsaPathLen;
Obj   teleport;
bool  bFightForFood = false;
int   nEval, nStateTime;
bool  bAssUnderFire = false;
Settlement set;
int idPlayer, nSqState;

set = g.settlement;
idPlayer = sq.Player;
nSqState = sq.State;
bAssUnderFire = (g.ID == EnvReadInt(idPlayer, "AssUnderFireGaika"));

if (!bAssUnderFire)
if (nSqState != SS_IDLE)
if (nSqState != SS_Approach)
if (nSqState != SS_Wait)
if (nSqState != SS_ApproachWait)
if (nSqState != SS_Enter)
	return -1;

gCurDest = sq.AIDest;
if (gCurDest == g)
	return -2;

/// do not give tasks too often
nStateTime = sq.StateTime;
if (GetTime < 3 * 60 * 1000) /// Ivo: explore problem otherwise.
	nStateTime = 10000000;
if (!bAssUnderFire)
if (nStateTime < 1000 * AIVar(idPlayer, AIV_SquadRecruitWait))
	return -3;

if (sq.Leader.AsShip.IsValid)
{
	if (sq.Leader.AsShip.HasAiTransport)
		return -4;
	if (!IsWaterLsa(g.LSA))
		return -5;
}
else
	if (IsWaterLsa(g.LSA))
		return -6;

if (AIVar(idPlayer, AIV_UseTeleports) != 0)
	teleport = FindTeleport(idPlayer, sq.pos, g.Center);
if (teleport.IsValid)
	lsaPathLen = 1;
else
	lsaPathLen = CheckLsaPath(sq.GAIKAIn.LSA, g.LSA, idPlayer);
if (lsaPathLen == 0)
	return -7;

/// prevent scattering small armyes
if (set.IsValid)
if (!set.IsOwn(idPlayer))
if (set.IsTeutonTent || !set.IsIndependent || set.IsIndependentGuarded)	/// not resque
if (!sq.Leader.AsHero.IsValid && !sq.Leader.HasFreedom)
	return -8;

// Do not explore with Liberati or Viking Lords (prevent scattering them and force using on purpose)
if (!bAssUnderFire)
if (sq.Leader.HasFreedom)
{
	if (sq.Leader.class == "BVikingLord")
	if (g.Eval(AI_STAYING, idPlayer, AI_ENEMY) < 500)
		return -9;
	if (set.IsIndependent)
	if (set.IsStronghold)
		return -10;
	if (!g.Explored(idPlayer))
		return -11;
}

if (set.IsVillage)
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
				return -12;
		}

		if (!set.IsOwn(idPlayer) || !set.IsStronghold) // && 
		//if (sq.Leader.InHolder || nSqState == SS_Enter) // &&
		if (sq.health < sq.maxhealth * 8 / 10) // &&
		if (sq.GAIKAIn.settlement.IsValid)
		if (sq.GAIKAIn.settlement.food > 100)
			return -13; // heal first
	}
	else
	{
		if (sq.Units.count < 10)
		if (sq.Leader.GetHolderSett.IsTeutonTent)
			return -14;
		if (g.Explored(idPlayer))
		if (!set.IsIndependent)
		{
			Settlement s;
			s = sq.GAIKAIn.settlement;
			if (s.IsStronghold)
			if (!sq.HasFreedom)
			if (s.IsOwn(idPlayer)) 
				return -15; // Wait to attach before sending
		}
	}

if (!bAssUnderFire)
if (gCurDest.GetPriority(idPlayer) >= g.GetPriority(idPlayer))
	gDepend = gCurDest;

nEval = 100000 - sq.pos.Dist(g.Center) * lsaPathLen;

{ /// do not give tasks too often
	int nWeightTime;
	nWeightTime = AIVar(idPlayer, AIV_SquadRecruitWeight);
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
