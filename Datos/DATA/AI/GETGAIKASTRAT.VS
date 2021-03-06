// int, GAIKA gaika, int idPlayer

int        i;
Squad      squad;
SquadList  SL;
Settlement Set;
bool       bOurArmy     = false;
bool       bEnemyArmy   = false;  // armies
bool       bOurSet      = false;  // settlements
bool       bAllySet     = false;
bool       bEnemySet    = false;
bool       bNoSet       = false;
bool       bGates       = false;  // gates
//bool       bGatesBroken = false;
bool       bCanEnter    = false;
bool       bCanBeCapturedSet = false;
bool       bDebugDump   = false;
int        nOwn, nAlly, nEnemy, enemy_hidden;
int        nOwnC, nAllyC, nEnemyC, enemyCHidden;
int        nApproachOutpostDist = 1600;	/// if change see also in GS_Capture.vs!

i = AIVar(idPlayer, AIV_LogGetGS);
bDebugDump = ((i == -1) || (i == gaika.ID));

if (bDebugDump)
	pr("== GetGAIKAStrat(" + gaika.ID + ", " + idPlayer + "):");

/*
if (! gaika.MilitaryPresence(idPlayer))
{
	if (bDebugDump) pr("--> no military presence -> GS_NONE");
	return GS_NONE;
}
*/

Set = gaika.settlement;
// our squads in GAIKA
gaika.Eval(AI_STAYING, idPlayer, nOwn, nAlly, nEnemy, enemy_hidden);
if (Set.IsValid)
if (Set.IsOutpost)
	nOwn += gaika.ApproachingSquads(idPlayer, nApproachOutpostDist);

gaika.Count(AI_STAYING, idPlayer, nOwnC, nAllyC, nEnemyC, enemyCHidden);

bOurArmy = nOwn > 0;
bEnemyArmy = nEnemy > 0;

//gaika.GetSquads(SL, AI_STAYING, idPlayer, AI_OWN);
//bOurArmy = SL.EOL == false;

// remove?

/*
while (SL.EOL == false)
{
	squad = SL.Cur;
	if (squad.State != SS_Approach || squad.AIDest == gaika)
	{
		bOurArmy = true;
		break;
	}
	SL.Next;
}
*/

if (!bOurArmy)
{
	if (bDebugDump) pr("--> no our (military) units - GS_NONE");
	return GS_NONE; // *** GS_NONE ***
}

if (!bEnemyArmy)
{
	int nLOwn, nLAlly, nLEnemy, nLEnemyHidden;
	gaika.Count (AI_LEAVING, idPlayer, nLOwn, nLAlly, nLEnemy, nLEnemyHidden);
	bEnemyArmy = nLEnemy > 0;
}

// enemies in GAIKA (nEnemyArmy)
//gaika.GetSquads(SL, AI_ALL, idPlayer, AI_ENEMY);
//bEnemyArmy = SL.EOL == false;
// settlement
if (Set.IsValid)
{
	if (Set.player == idPlayer)
		bOurSet = true;
	else
		if (DiplGetCeaseFire(Set.player, idPlayer) == false)
			bEnemySet = true;
		else
			bAllySet = true;
	bGates = Set.NumGates > 0;
	//bGatesBroken = Set.NumGatesBroken > 0;
	bCanEnter = bOurSet || ! bGates /*|| bGatesBroken*/;
	bCanBeCapturedSet = Set.CanBeCaptured;
}
else
	bNoSet = true;

if (bDebugDump)
{
	if (bEnemyArmy)     pr("  enemy army");
	if (bOurSet)        pr("  our settlement");
	if (bAllySet)       pr("  ally settlement");
	if (bEnemySet)      pr("  enemy settlement ");
	if (bNoSet)         pr("  no settlement    ");
	if (bGates)         pr("  gates            ");
	//if (bGatesBroken)   pr("  gates broken     ");
	if (bCanEnter)      pr("  can enter        ");
	if (bCanBeCapturedSet)pr("  can be captured  ");
}

if (bOurSet)
if (!Set.IsFull)
if (!Set.IsTeutonTent)
{
	if (!bEnemyArmy)
	{
  	if (bDebugDump) pr("--> GS_EnterSettlement (no enemies)");
		return GS_EnterSettlement;
	}
	if (nEnemy >= nOwn * 2)
	if (!Set.IsStronghold)
	{ // we are very weak
  	if (bDebugDump) pr("--> GS_EnterSettlement (too many enemies)");
		return GS_EnterSettlement;
	}
}

if (bEnemySet && bCanEnter && bCanBeCapturedSet)
//if (!bEnemyArmy || gaika.AllEnemiesInHolder(idPlayer))
{
	bool bCapture = false;
	if (!bEnemyArmy && nOwnC + nAllyC > 5)
		bCapture = true;

	if (!bCapture)
	if (nOwn + nAlly > nEnemy * 2 || (nOwn + nAlly > nEnemy && nEnemy > 30000))
	{
		int nOwnC, nAllyC, nEnemyC, nEnemyCHidden;
		gaika.Count(AI_STAYING, idPlayer, nOwnC, nAllyC, nEnemyC, nEnemyCHidden);
		if (nOwnC + nAllyC > 10)
			bCapture = true;
	}
	if (bCapture)
	{
		if (AIVar(idPlayer, AIMV_NoCapture, Set.player))
		{
			if (bDebugDump) pr("--> GS_Guard (AIMV_NoCapture)");
			return GS_Guard; // *** GS_Guard ***
		}
		if (bDebugDump) pr("--> GS_Capture");
		return GS_Capture; // *** GS_Capture ***
	}
	else {
		if (bDebugDump) pr("--> GS_NONE (Military is too small to capture: Own+Ally=" + (nOwn + nAlly) + " enemy=" + nEnemy + ")");
		return GS_NONE;
	}
}

if (bEnemyArmy)
if (!bEnemySet || bCanEnter)
{
	if (bDebugDump) pr("--> GS_KillEnemies");
	return GS_KillEnemies;
}

if (bEnemySet)
if (!bCanEnter)
{
	if (gaika.NoAttack(idPlayer))
	{
		if (bDebugDump) pr("--> GS_Guard (no attack)");
		return GS_Guard; // *** GS_Guard ***
	}
	if (bDebugDump) pr("--> GS_Siege");
	if (Set.IsIndependent) {
		if (bDebugDump) pr("--> GS_Siege (Independent settlement)");
		return GS_Siege;
	}
	if (nOwnC + nAllyC > 5)
	if (nOwn + nAlly > 2 * nEnemy)
	{
		if (bDebugDump) pr("--> GS_Siege (Own+Ally=" + (nOwn + nAlly) + " enemy=" + nEnemy + ")");
		return GS_Siege;
	}
	if (nOwnC + nAllyC >= 15)	{
		if (bDebugDump) pr("--> GS_Siege (Count is more 15)");
		return GS_Siege;
	}
}

if (bEnemySet) {
	if (bDebugDump) pr("--> GS_NONE (Enemy settlment)");
	return GS_NONE;
}
if (!bEnemySet && Set.IsTeutonTent)	{
	if (bDebugDump) pr("--> GS_NONE (Teuton Tent)");
	return GS_NONE;
}

if (bDebugDump) pr("--> GS_Guard (default)");
return GS_Guard;
