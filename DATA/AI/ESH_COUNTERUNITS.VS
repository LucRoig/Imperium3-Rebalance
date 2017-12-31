// void, Settlement set

int AIPlayer, nRace;
int nEnabled;
int i, nType, total;
IntArray W;
int nCarthageSpec;
bool bLogArmy;
int nMilUnits = 0;
bool bHeavyWant = false;

AIPlayer = set.player;
nRace = set.GetCentralBuilding.race;
bLogArmy = (AIVar(AIPlayer, AIV_LogArmy) != 0) && UEnabled(AIVar(AIPlayer, AIV_LogPlayer), AIPlayer);
nEnabled = EnvReadInt(AIPlayer, GetRaceStr(nRace) + "UnitsEnabled");
nCarthageSpec = -1;
if (EnvReadInt(set, "HeavyWant") > 0)
	bHeavyWant = true;

GetCounterUnits(set, W);

//bLogArmy = true;
if (bLogArmy)
	pr("Counters for player " + AIPlayer);

// zero weights for disabled types
for (i = 0; i < 6; i += 1) {
	if (!UEnabled(nEnabled, i))
		W[i] = 0;
}
// calc weighted random
total = W[0] + W[1] + W[2] + W[3] + W[4] + W[5];
if (total <= 0)	{
	EnvWriteInt(set, "CounterUnit_1", 0);
	return;
}

/// spread some additional weight for all units
nMilUnits = MilUnits(AIPlayer);
if (nMilUnits > 20)
{
	int nAddWeight;
	nAddWeight = total / 30; /// 20% -> * 20 / 100 / 6
	for (i = 0; i < 6; i += 1)
		W[i] = W[i] + nAddWeight;
	total = W[0] + W[1] + W[2] + W[3] + W[4] + W[5];
}

/// boost heavy units. Every units is boosted with its health
if (nMilUnits > 50 || bHeavyWant)
{
	for (i = 0; i < 6; i += 1)
		if (W[i] != 0)
		{
			int nCost; nCost = GetTrainGold(UTrainCmd(i, nRace)) / 10;
			//int nCost; nCost = GetClassHealt(UTrainCmd(i, nRace)) / 10;
			if (nCost > 0)
				W[i] = W[i] * nCost;
			if (bHeavyWant && i > 2)
				W[i] = W[i] * i;
		}
	total = W[0] + W[1] + W[2] + W[3] + W[4] + W[5];
}

/// boost army variety
if (nMilUnits > 50)
{
	for (i = 0; i < 6; i += 1) {
		int n; n = 100 * Count(AIPlayer, UType(i, nRace)) / nMilUnits;
		//n -= 30;
		if (n > 0)
			W[i] = W[i] * (100 - MAX(n, 0)) / 100;
	}
	total = W[0] + W[1] + W[2] + W[3] + W[4] + W[5];
}

if (nRace == Carthage)
{
	/// boost to research more units on a particular type to increase the level they are hired
	/// 0-50% bonus depend on the units count (bonus increase with the count)
	if (IsResearched(set, "Shared Strength"))	/// researching "Shared Triumph" do not change the evaluation
	{
		int nMin = 0, nMax = 50;
		for (i = 0; i < 6; i += 1)
			if (W[i] > 0)	{
				int k; k = Count(AIPlayer, UType(i, Carthage));
				if (k > 50) k = 50;
				W[i] += W[i] * (nMin + (nMax - nMin) * k / 50) / 100;
			}
	}
	/// boost current carthage specialization - 20-50% (bonus decrease with the count)
	if (EnvReadString(set, "Specialization") != "")
	{
		nCarthageSpec = EnvReadInt(set, "SpecializedUnit") - 1;
		if (bLogArmy)
			if (nCarthageSpec < 0)
				pr("Mish-Mash with specialization of player " + AIPlayer);
			else if (!IsResearched(set, UTech(nCarthageSpec, nRace)))
				pr("Mish-Mash2 with specialization of player " + AIPlayer);
		if (W[nCarthageSpec] > 0)
		{
			int nMin = 20, nMax = 50;
			int k; k = Count(AIPlayer, UType(nCarthageSpec, Carthage));
			if (k > 50) k = 50;
			W[nCarthageSpec] += W[nCarthageSpec] * (nMin + (nMax - nMin) * (50 - k) / 50) / 100;
		}
	}
}
else
{ /// give some bonus to the original plan for not researched units
	// more boost for heavy units when researched
	/*
	if (W[5] > 0)
	{
		W[5] += total / 15;
		if (UTech(5, nRace) != "") if (!IsResearched(set, UTech(5, nRace)))
			W[5] += total / 5;
	}
	*/
	// boost the next tech seq
	for (i = 1; i < 6; i += 1)
	{
		str strTech;
		int t;
		if (i == 1) if (nRace == Gaul)
			continue;
		t = EnvReadInt(set, "TechSeq" + AIPlayer + "_" + i);
		if (!UEnabled(nEnabled, t))
			continue;
		strTech = UTech(t, nRace);
		if (strTech != "") if (!IsResearched(set, strTech)) if (t > 0 && t < 6)
			W[t] += total / 10;
		break;
	}
}

for (i = 0; i < 6; i += 1) {
	if (!UEnabled(nEnabled, i))
		W[i] = 0;
}
total = W[0] + W[1] + W[2] + W[3] + W[4] + W[5];

if (bLogArmy)
{
	str s = "";
	for (i = 0; i < 6; i += 1)
	{
		nType = W[i];
		s = s + " " + nType;
	}
	nType = EnvReadInt(set, "CounterUnit_1") - 1;
	pr(s);
}

for (i = 1; i < 7 && total > 0; i += 1)
{
	int r; r = rand(total);
	for (nType = 0; nType < 6; nType += 1) {
		r -= W[nType];
		if (r < 0) {
			EnvWriteInt(set, "CounterUnit_" + i, nType + 1);
			total -= W[nType];
			W[nType] = 0;
			break;
		}
	}
}

EnvWriteInt(set, "CounterUnit_" + i, 0);

/// logging
if (bLogArmy)
{
	str s = "";

	if (total != 0)
		pr("Player " + AIPlayer + ": Error in the counter units estimation! (total = " + total + ")");

	for (i = 0; i < 6; i += 1)
	{
		nType = W[i];
		s = s + " " + (EnvReadInt(set, "CounterUnit_" + (i + 1)) - 1);
	}
	pr(s);
	nType = EnvReadInt(set, "CounterUnit_1") - 1;
	pr("Counter unit result for player " + AIPlayer + ": No" + nType + " -> " + UType(nType, nRace));
}
