// void, Settlement set

// WARNING: since the script language doesn't have arrays and has complete boolean evaluation,
//          the code in this script is ridiculously big and ugly :)

// called from "ES_Stronghold.vs". return "nBuildCount" and "nBuildType" in the environment.

int AIPlayer, nRace;
str strTech = "", strDbg = "";
int nType;
int nCount;
int nArmyBuilds;
int nAssUnderFire;
bool bBuildArmy;
int  nLastResearched;
int  nLRCounter;
int  nEnabled = 0;
int  nEarlyResearch;
int  nLastResearchTime, nLastCounterTime;
int i, j, k, m, nDesireCount;
bool bNoArchers, bArchers;
bool bNeedTraining;
int nDbg = 0;
bool bResearchTime;
bool bLogArmy;
int nMilUnits = 0;
int nNewResearchCount = 20;
bool bHeavyWant = false;
StrArray MaxConsts;
StrArray TechGerman;
IntArray UnitsDesire;

if (set.food < 1000)
	return;

AIPlayer = set.player;
nRace = set.GetCentralBuilding.race;
bLogArmy = (AIVar(AIPlayer, AIV_LogArmy) != 0) && UEnabled(AIVar(AIPlayer, AIV_LogPlayer), AIPlayer);
strTech = "";
nAssUnderFire = EnvReadInt(set, "AssUnderFire");         /// set in "ES_Stronghold.vs"
nArmyBuilds = EnvReadInt(set, "nArmyBuilds");             /// set in "ES_Stronghold.vs"
nLastResearched = EnvReadInt(set, "nLastResearched");     /// used only here
nLRCounter = EnvReadInt(set, "nLRCounter");               /// used only here
nEarlyResearch = EnvReadInt(set, "nEarlyResearch");       /// used only here [0..3]
nLastResearchTime = EnvReadInt(set, "nLastResearchTime"); /// used only here
nLastCounterTime = EnvReadInt(set, "nLastCounterTime"); /// used only here
bNeedTraining = EnvReadInt(AIPlayer, "NeedTraining")==1;  /// set in "ES_Stronghold.vs". used also in "ESH_NeedTech.vs"
bResearchTime = !bNeedTraining && (nLastResearchTime == 0 || GetTime() > nLastResearchTime + 600000);
nMilUnits = MilUnits(AIPlayer);

MaxConsts[5] = "MaxMacemen";
MaxConsts[4] = "MaxTeutonRiders";
MaxConsts[3] = "MaxHuntresses";
MaxConsts[2] = "MaxAxemen";
MaxConsts[1] = "";
MaxConsts[0] = "";

TechGerman[5] = "Macemen production";
TechGerman[4] = "Horseshoes production";
TechGerman[3] = "Javelin production";
TechGerman[2] = "Axemen production";
TechGerman[1] = "";
TechGerman[0] = "";

bHeavyWant = set.food > 5000;
EnvWriteInt(set, "HeavyWant", bHeavyWant);

nType = -1;
if (nLastResearched > 0)
{
	Building bld;
	nType = nLastResearched - 1;
	bld = set.FindResearchLab(TechGerman[nType]);
	if (bld.IsValid)
	if (bld.CmdCount(TechGerman[nType]) > 0)
		return; /// still researching
	if (Count(AIPlayer, UType(nType, Germany)) >= EnvReadInt(AIPlayer, MaxConsts[nType])) {
		nType = -1; // unlucky... new tech is needed
		nLastResearched = 0;
		nLRCounter = 0;
		EnvWriteInt(set, "nLastResearched", 0);
		EnvWriteInt(set, "nLRCounter", 0);
	}
}

i = 0;
i += Count(AIPlayer, "GArcher");
i += Count(AIPlayer, "RArcher");
i += Count(AIPlayer, "CJavelinThrower");
i += Count(AIPlayer, "IArcher") + Count(AIPlayer, "ISlinger");
i += Count(AIPlayer, "BBowman");
i += Count(AIPlayer, "EArcher") + Count(AIPlayer, "EAxetrower");
i += Count(AIPlayer, "TArcher") + Count(AIPlayer, "THuntress") + Count(AIPlayer, "TeutonArcher");

bNoArchers = (i > (AIVar(AIPlayer, AIV_ArcherPercent) * nMilUnits / 100));
bArchers = (!bNoArchers && ((nMilUnits > 15) && (i < (AIVar(AIPlayer, AIV_ArcherPercent) * nMilUnits / 200))));

//------------ENABLED UNITS (depend on the current count!) ----------------
set.AIRun("ESH_EnabledUnits.vs");
nEnabled = EnvReadInt(AIPlayer, GetRaceStr(nRace) + "UnitsEnabled");

//------------DECIDE WHETHER TO BUILD ARMY AT ALL-------------------------
strDbg = "";
bBuildArmy = false;
if (nAssUnderFire > 0) {
	bBuildArmy = true;
	strDbg = "AssUnderFire";
} else
if (EnvReadInt(set, "FreezeArmyBuild") != 0) {
	bBuildArmy = false;
	strDbg = "Building army is temporary freezed";
} else
if (set.population <= 10) {
	bBuildArmy = false;
	strDbg = "The population is too low";
} else
if (nArmyBuilds == 0)	{
	bBuildArmy = true;
	strDbg = "Stronghold have no mind";
} else
if (set.food < 100 && nMilUnits >= 100) {
	bBuildArmy = false;
	strDbg = "Too large army and no food";
} else {
	int n, nPop = 0;
	strDbg = "Wait more population";
	if (nMilUnits < 20 || nArmyBuilds < 2)
		nPop = 60;
	else if (nArmyBuilds < 10)
		nPop = 80;
	else
		nPop = 100;
	n = 100 - set.food / 250;
	if (n < 40) n = 40;
	nPop = nPop * n / 100;
	bBuildArmy = (set.population >= set.max_population * nPop / 100);
	if (!bHeavyWant)
	if (GetTime > 5 * 60 * 1000)
		bHeavyWant = (set.population < set.max_population * 85 / 100);
	if (bHeavyWant)
		EnvWriteInt(set, "HeavyWant", bHeavyWant);
}
if (!bBuildArmy)
	return;

nDesireCount = 0;
for (i = 5; i >= 0; i -= 1) {
	if (i == 1 && bNoArchers)
		continue;
	if (i != 1 && i != 3 && bArchers)
		continue;
	if (UEnabled(nEnabled, i)) {
		UnitsDesire[nDesireCount] = i;
		nDesireCount += 1;
	}
}
if (!bHeavyWant) // shuffle disire units
	for (i = nDesireCount - 1; i > 0; i -= 1) {
		j = rand(i+1);
		k = UnitsDesire[i]; UnitsDesire[i] = UnitsDesire[j]; UnitsDesire[j] = k;
	}

if (nDesireCount == 0)
	return;

// look for counter units
if (rand(2) == 0) // do not believe it so much
if (nLastResearched == 0)
if (nType < 0)
if (AIVar(AIPlayer, AIV_CounterUnits) != 0)
{
	int nNextCounter = 1;
	if (nLastCounterTime == 0 || GetTime() > nLastCounterTime + 15000)	{
		set.AIRun("ESH_CounterUnits.vs");
		nLastCounterTime = GetTime();
		EnvWriteInt(set, "nLastCounterTime", nLastCounterTime);
	}
	i = EnvReadInt(set, "CounterUnit_" + nNextCounter) - 1;
	m = 0;
	while (i >= 0)
	{
		for (j = m; j < nDesireCount; j += 1)
			if (UnitsDesire[j] == i)
			{	// move it ahead
				for (k = j; k > m; k -= 1) 
					UnitsDesire[k] = UnitsDesire[k-1];
				UnitsDesire[m] = i;
				break;
			}
		nNextCounter += 1;
		i = EnvReadInt(set, "CounterUnit_" + nNextCounter) - 1;
	}
}
if (nType < 0)
{
	nType = UnitsDesire[0];
	if (nType >= 2)
	if (Count(AIPlayer, UType(nType, Germany)) >= EnvReadInt(AIPlayer, MaxConsts[nType]))
	{	// ask for a research
		Building bld;
		bld = set.FindResearchLab(TechGerman[nType]);
		if (bld.IsValid)
		if (bld.CmdCount(TechGerman[nType]) > 0)
			return; /// something is going on there
		if (set.CanResearch(TechGerman[nType]))
		if (set.CanAfford(TechGerman[nType]))
			set.Research(TechGerman[nType]);
		if (bld.CmdCount() > 0)
		{	// researching...
			EnvWriteInt(set, "nLastResearched", nType + 1);
			EnvWriteInt(set, "nLRCounter", 10);
			EnvWriteInt(set, "nLastResearchTime", GetTime());
			return;
		}
		nType = -1;
	}
}
if (nType < 0)
	for (i = 1; i < nDesireCount; i += 1) {
		nType = UnitsDesire[i];
		if (nType >= 2)
		if (Count(AIPlayer, UType(nType, Germany)) < EnvReadInt(AIPlayer, MaxConsts[nType]))
			break;
		nType = -1;
	}

EnvWriteInt(set, "nBuildType", nType);
nCount = 10;
if (nType >= 0)
if (nType == nLastResearched - 1)
if (nLRCounter > 0)
if (nCount > nLRCounter)
	nCount = nLRCounter - nCount;
EnvWriteInt(set, "nBuildCount", nCount);

if (nType >= 0)
if (nType == nLastResearched - 1)
{
	if (rand(5) == 0) nLRCounter = 0;
	else nLRCounter -= nCount; 
	if (nLRCounter < 0) nLRCounter = 0;
	EnvWriteInt(set, "nLRCounter", nLRCounter);
	if (nLRCounter <= 0) 
		EnvWriteInt(set, "nLastResearched", 0);
}
