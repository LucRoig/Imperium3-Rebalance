//void

bool bAllSatisfied = false;

Sleep(rand(1000) + 300);

while (1)
{

int AIPlayer;
int nHomeGaikaID;
int i, j, nAvail = 0, nMilEval = 0;
int nAttentionPoints = 0, nMaxAttentionPoints;
int nLogRecruit = 0;
bool bNotSatisfied = false;

bool b, bGLog, bLog;

AIPlayer = AIGetPlayer;
nLogRecruit = AIVar(AIPlayer, AIV_LogRecruit);
bGLog = (nLogRecruit != 0);
bLog = nLogRecruit < 0;

nMaxAttentionPoints = AIVar(AIPlayer, AIV_MaxAttentionPoints);

if (AIVar(AIPlayer, AIV_NoRecruit) != 0)
{
	if (bGLog) pr("Skipping [AIV_NoRecruit] AI(" + AIPlayer + ") recruit think");
	Sleep(2000);
	continue;
}

nMilEval = MilEval(AIPlayer); // this is without sentries
if (nMilEval < 1)
{
	if (bGLog) pr("Skipping [no mil units] AI(" + AIPlayer + ") recruit think");
	Sleep(2000);
	continue;
}
nAvail = nMilEval;

if (bGLog) pr("Starting AI(" + AIPlayer + ") recruit think ... ");

if (!GetGAIKA(GAIKACount - 1).Prioritized(AIPlayer))
{
	if (bGLog) pr("Not all GAIKA's prioritized");
	Sleep(1000);
	continue;
}

/// check home and try to find another home if the home is lost
nHomeGaikaID = EnvReadInt(AIPlayer, "HomeGaika");
b = false;
if (nHomeGaikaID > 0)
if (!GetGAIKA(nHomeGaikaID).settlement.IsOwn(AIPlayer))
	b = true;
if (b || nHomeGaikaID <= 0)
{
	Settlement set;
	point pt;
	set = NearestStronghold(pt, AIPlayer);
	if (set.IsValid) {
		nHomeGaikaID = set.GetGaika.ID;
		EnvWriteInt(AIPlayer, "HomeGaika", nHomeGaikaID);
	}
}

for (i = 0; i < GAIKACount; i += 1)
{
	GAIKA g;
	int own, ally, enemy, enemy_hidden;
	int nMinNeed, nMaxNeed, nPriority, nSent;
	bool bAssUnderFire = false;
	bool bAttention = false;
	bool bStrongholdGaika = false;

	/// always check the home GAIKA first (no matther the priority)
	if (i == 0)
	{
		if (nHomeGaikaID <= 0)
			continue;
		g = GetGAIKA(nHomeGaikaID);
	}
	else
	{
		g = LAIKA(AIPlayer, i);
		if (g.ID == nHomeGaikaID)
			continue;
	}

	if (nLogRecruit > 0)
		bLog = nLogRecruit == g.ID;

	bStrongholdGaika = g.settlement.IsStronghold;
	
	if (nAttentionPoints >= nMaxAttentionPoints)
	if (g.ID != nHomeGaikaID)
	if (!bStrongholdGaika)	/// check for alliance strongholds
	{
		if (bLog) pr("  [AIV_MaxAttentionPoints]");
		continue;
	}

	if (g.ID != nHomeGaikaID)
	if (!g.Explored(AIPlayer))
	if (!g.CanExplore(AIPlayer))
	{
		if (bLog) {
			g.Eval(AI_COMING + AI_STAYING, AIPlayer, own, ally, enemy, enemy_hidden);
			nMinNeed = g.MinNeed(AIPlayer, own, ally, enemy);
			nMaxNeed = g.MaxNeed(AIPlayer, own, ally, enemy);
			if (g.settlement.IsValid || enemy > 0)
				pr("  [" + i + "]" + "  [EXPL] GAIKA " + g.ID + ": Army " + own + ", Needed " + nMinNeed + "-" + nMaxNeed);
		}
		continue;
	}

	if (!g.settlement.IsValid)
	if (g.Empty)
	if (g.Explored(AIPlayer))
		continue;  // quick filter

	g.Eval(AI_COMING + AI_STAYING, AIPlayer, own, ally, enemy, enemy_hidden);

// calc army needs
	if (own + ally < enemy)
	if (bStrongholdGaika)
	if (g.settlement.IsOwn(AIPlayer) || g.settlement.IsAlly(AIPlayer))
		bAssUnderFire = true;

	if (!bAssUnderFire)
	if (nAttentionPoints >= nMaxAttentionPoints)
	{
		if (bLog) pr("  [AIV_MaxAttentionPoints]");
		continue;
	}

// count "attention points"
	if (own > 0)
		if (enemy > 0)
			bAttention = true;
		else
			if (g.settlement.IsEnemy(AIPlayer))
			if (!g.settlement.IsIndependent)
				bAttention = true;
	if (!bAttention)
	if (g.settlement.IsOwn(AIPlayer))
	if (enemy > 0)
	if (g.Eval(AI_STAYING, AIPlayer, AI_ENEMY) > 0)
		bAttention = true;
	if (bAttention)
	if (!bStrongholdGaika)
		nAttentionPoints += 1;

	nMinNeed = g.MinNeed(AIPlayer, own, ally, enemy);
	nMaxNeed = g.MaxNeed(AIPlayer, own, ally, enemy);

	if (own + ally >= nMinNeed)
	if (!bAllSatisfied || !g.settlement.IsValid || g.settlement.IsAlly(AIPlayer))
	{
		if (bLog)
		if (own + ally != 0)
			pr("  [" + i + "]" + "  [OK] GAIKA " + g.ID + ": Army " + (own + ally) + ", Needed " + nMinNeed + "-" + nMaxNeed);
		continue;
	}

	if (enemy < 1000)
	if (!bStrongholdGaika)
	if (g.settlement.IsValid)
	if (g.settlement.IsAlly(AIPlayer))
		continue;
	
	if (bAssUnderFire)
		nMinNeed = 1;

// quick "no chance" filter
	if (!bAssUnderFire)
	if (nAvail < nMinNeed - (own + ally))
	{
		if (bLog) pr("  [" + i + "]" + "  [no chance] GAIKA " + g.ID + ": Army " + (own + ally) + ", Needed " + nMinNeed + "-" + nMaxNeed + ", Army left: " + nAvail);
		continue;
	}
	if (IsWaterLsa(g.LSA))
	if (0 == Ships(AIPlayer, g.LSA))
	{
		IncShipNeeds(AIPlayer, g.LSA);
		if (bLog) pr("  [" + i + "]" + "  [no chance] GAIKA " + g.ID + ": Army " + (own + ally) + ", Needed " + nMinNeed + "-" + nMaxNeed + ", Army left: " + nAvail);
		continue;
	}

// LAIKA flags filters
	if (g.NoRecruit(AIPlayer))
	{
		if (bLog) pr("  [" + i + "]" + "  [AIL_NORECRUIT] GAIKA " + g.ID + ": Army " + (own + ally) + ", Needed " + nMinNeed + "-" + nMaxNeed + ", Army left: " + nAvail);
		continue;
	}
	if (g.NoAttack(AIPlayer))
	{
		bool bFilter = false;
		if (g.settlement.IsEnemy(AIPlayer))
			bFilter = true;
		else
			if (!g.settlement.IsValid)
			if (enemy > 0)
			if (own == 0)
			if (ally == 0)
				bFilter = true;
		if (bFilter) {
			if (bLog) pr("  [" + i + "]" + "  [AIL_NOATTACK] GAIKA " + g.ID + ": Army " + (own + ally) + ", Needed " + nMinNeed + "-" + nMaxNeed + ", Army left: " + nAvail);
			continue;
		}
	}

// AI vars filters
	if (AIVar(AIPlayer, AIMV_NoAttack) != 0)
	{
		bool bFilter = false;
		if (g.settlement.IsEnemy(AIPlayer))
		if (AIVar(AIPlayer, AIMV_NoAttack, g.settlement.player)) 
			bFilter = true;
		if (!g.settlement.IsValid)
		if (enemy > 0)
		if (own == 0)
		if (ally == 0)
			for (j = 1; j <= 16; j += 1)
			{
				if (!AIVar(AIPlayer, AIMV_NoAttack, j))
					continue;
				if (g.Eval(AI_STAYING + AI_LEAVING, j) > 0)
					bFilter = true;
			}
		if (bFilter) {
			if (bLog) pr("  [" + i + "]" + "  [AIMV_NoAttack] GAIKA " + g.ID + ": Army " + (own + ally) + ", Needed " + nMinNeed + "-" + nMaxNeed + ", Army left: " + nAvail);
			continue;
		}
	}
	if (g.ID != nHomeGaikaID)
	if (g.settlement.IsEnemy(AIPlayer))
	{
		if (AIVar(AIPlayer, AIMV_NoAttackStrongholds) != 0)
		if (bStrongholdGaika) 
		if (AIVar(AIPlayer, AIMV_NoAttackStrongholds, g.settlement.player))
		{
			if (bLog) pr("  [" + i + "]" + "  [AIMV_NoAttackStrongholds] GAIKA " + g.ID + ": Army " + (own + ally) + ", Needed " + nMinNeed + "-" + nMaxNeed + ", Army left: " + nAvail);
			continue;
		}
		if (AIVar(AIPlayer, AIMV_NoAttackVillages) != 0)
		if (g.settlement.IsVillage) 
		if (AIVar(AIPlayer, AIMV_NoAttackVillages, g.settlement.player))
		{
			if (bLog) pr("  [" + i + "]" + "  [AIMV_NoAttackVillages] GAIKA " + g.ID + ": Army " + (own + ally) + ", Needed " + nMinNeed + "-" + nMaxNeed + ", Army left: " + nAvail);
			continue;
		}
		if (AIVar(AIPlayer, AIMV_NoAttackOutposts) != 0)
		if (g.settlement.IsOutpost) 
		if (AIVar(AIPlayer, AIMV_NoAttackOutposts, g.settlement.player))
		{
			if (bLog) pr("  [" + i + "]" + "  [AIMV_NoAttackOutposts] GAIKA " + g.ID + ": Army " + (own + ally) + ", Needed " + nMinNeed + "-" + nMaxNeed + ", Army left: " + nAvail);
			continue;
		}
	}

	if (bAllSatisfied)
	{
		nMaxNeed = 10000000;
		//pr("Player " + AIPlayer + ": All gaikas satisfied! Go the rest army in gaika " + g.ID);
	}
	bAllSatisfied = false;
	bNotSatisfied = true;

// recruit
	if (bAssUnderFire)
	{
		EnvWriteInt(AIPlayer, "AssUnderFireGaika", g.ID);
		nSent = g.Recruit(AIPlayer, 1, nMaxNeed - own, nAvail);
		EnvWriteInt(AIPlayer, "AssUnderFireGaika", 0);
	}
	else
		nSent = g.Recruit(AIPlayer, nMinNeed - (own + ally), nMaxNeed - own, nAvail);

	if (nSent == 0)
	{
		int me;
		if (bLog) pr("  [" + i + "]" + "  [tried] GAIKA " + g.ID + ": Army " + (own + ally) + ", Needed " + nMinNeed + "-" + nMaxNeed + ", Army left: " + nAvail);
		if (IsWaterLsa(g.LSA))
		if (g.Explored(AIPlayer))
			IncShipNeeds(AIPlayer, g.LSA);
		if (nAvail == 0)
			break;
		Sleep(AIVar(AIPlayer, AIV_Sleep_Recruit));
		// fix nAvail - units might have born while we slept :)
		me = MilEval(AIPlayer);
		if (me > nMilEval)
		{
			nAvail += me - nMilEval;
			nMilEval = me;
		}
		continue;
	}

// found GAIKA
	if (bLog) pr("  [" + i + "]" + "->GAIKA " + g.ID + ": Army " + (own + ally) + ", Needed " + nMinNeed + "-" + nMaxNeed + ", Sent " + nSent + ", Army left: " + nAvail);
	if (nAvail == 0) break;
	break;
}

bAllSatisfied = !bNotSatisfied;

if (bGLog) pr("DONE");
Sleep(AIVar(AIPlayer, AIV_Sleep_Recruit));

}
