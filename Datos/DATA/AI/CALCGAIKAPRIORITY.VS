// int, int idPlayer, GAIKA g

int nPriority; // means where we want to go first
bool bExplored;
int nHomeDist, nAllyHomeDist, nEnemyHomeDist;
rect rcMap;
int nMaxDist;
int nActualPerc;
Settlement set;

set = g.settlement;
bExplored = AIVar(idPlayer, AIV_LuckyExplore) != 0;
if (!bExplored)
	bExplored = g.Explored(idPlayer);

rcMap = GetMapRect();
nMaxDist = Point(rcMap.left, rcMap.top).Dist(Point(rcMap.right, rcMap.bottom));
g.GetDistToPlayers(idPlayer, nHomeDist, nAllyHomeDist, nEnemyHomeDist);

nActualPerc = 30;
if (!bExplored)
	nActualPerc = 70;
else if (set.IsStronghold())
	nActualPerc = 100;
else if (set.IsVillage())
	nActualPerc = 90;
else if (set.IsTeutonTent())
	nActualPerc = 80;
else if (set.IsOutpost())
{
	nActualPerc = 60;
	if (set.IsIndependent())
		nActualPerc = 80;
	if (AIVar(idPlayer, AIV_DonateGold) > 0)
	if (AIVar(idPlayer, AIV_TradeGold) > 0)
	{
		int nRace; nRace = set.GetCentralBuilding.race;
		if (nRace == RepublicanRome || nRace == Egypt)
			nActualPerc += 10;
	}
}
else if (set.IsShipyard)
	nActualPerc = 60;

nPriority = nActualPerc * (MaxGAIKAPriority * (100 - nHomeDist * 100 / nMaxDist) / 100) / 100;
if (nPriority >= MaxGAIKAPriority)
	nPriority = MaxGAIKAPriority - 1; // just in case
if (nPriority <= 0)
	nPriority = 1; // must be > 0. All GAIKA are prioritized when all are > 0
return nPriority;
