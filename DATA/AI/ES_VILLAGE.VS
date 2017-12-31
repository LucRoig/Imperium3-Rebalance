// void, Settlement set

int idPlayer, min_pop, pop_group;
Building cb;
str strCmd;
point ptDummy;
Obj objDummy;

idPlayer = set.player;
cb = set.GetCentralBuilding;
strCmd = "trainpeasant" + cb.raceStrPrefLow;
min_pop = GetConst("MinPopulation");
pop_group = GetConst("PopGroup");

/// RestartEconomyScript is for debug purpose only -> it stops the current script and starts the new one.
/// -> EnvWriteInt(sels, "RestartEconomyScript", 1)

while (set.player == idPlayer && EnvReadInt(set, "RestartEconomyScript") == 0)
{
	Settlement DestStronghold;
	bool bIdle, bCanDrain;

	bIdle = cb.command == "idle";
	bCanDrain = bIdle && set.population - pop_group >= min_pop;
	if (bCanDrain)
	if (AIVar(idPlayer, AIV_VillageDrain) == 0)
	if (set.population < set.max_population)
		bCanDrain = false;
	
	/// be dafault produced food go to stronghold
	DestStronghold = set.BestToSupply(); /// the return value is always stronghold
	if (DestStronghold.IsValid)
	{
		if (bIdle)
			set.StartSupplyFood(DestStronghold);
		EnvWriteInt(set, "SupplyStronghold", cb.DistTo(DestStronghold.GetCentralBuilding));
	} else {
		set.StopSupply();
		bCanDrain = false;
	}

	/// drain peasants to stronghold
	if (bCanDrain)
	{
		bool bDrain = false;
		if (set.population >= set.max_population)
			bDrain = true;
		if (!bDrain)
		{
			int nThreshold = 60;
			int nSFood, nSPop, nVPop, nVDist, nS, nV, nSendPop;
			int i, nMin, nMax, nMaxFood;
			nMaxFood = MilUnits(idPlayer) * 20;
			i = Strongholds(idPlayer);
			if (i > 1) nMaxFood = nMaxFood / i;
			if (nMaxFood < 300) nMaxFood = 300;
			nSFood = 100 * DestStronghold.food / nMaxFood;
			if (nSFood > 100) nSFood = 100;

			nSPop = 100 * DestStronghold.population / DestStronghold.max_population;
			nVPop = 100 * set.population / set.max_population;
			i = GetMapRect.width;
			if (i < GetMapRect.height)
				i = GetMapRect.height;
			nVDist = 100 * cb.DistTo(DestStronghold.GetCentralBuilding) / i;

			nS = nSFood - nSPop;
			nV = (nThreshold - nVDist) - nVPop/2;
			if (nS >= nV)
				bDrain = true;
			/*
			/// debug info
			nMax = (nThreshold - nVDist) - (1000 / set.max_population) / 2;
			nMin = (nThreshold - nVDist) - 100 / 2;

			i = (nThreshold - nVDist - nS) * 2;
			i = i * set.max_population / 100;

			/// to see stats from the game write -> pr(EnvReadString(sels, "sendpop"))
			EnvWriteString(set, "sendpop",
				"     Stronghold pop/food weight: " + nS + " (Food=" + nSFood + "%, Pop=" + nSPop + "%),\n" + 
				"     Village pop/food weight [" + nMin + ".." + nMax + "]: " + nV + " (pop=" + nVPop + "%, dist=" + nVDist + "%)\n" + 
				"     Ballance: village sends pop when it is " + i);
			*/
		}
		bCanDrain = bDrain;
	}

	/// check whether to drain to Carthage outpost
	if (bCanDrain)
	if (AIVar(idPlayer, AIV_UseForts) != 0)
	{	/// drain to Carthage Outpost
		Building bOutpost; bOutpost = EnvReadObj(set, "SupplyOutpost").AsBuilding;
		if (bOutpost.IsValid)
		{
			bool bSupplyOutpost = false;
			if (bOutpost.player == idPlayer)
			if (bOutpost.race == Carthage)
			if (cb == EnvReadObj(bOutpost.settlement, "SuppledVillage").AsBuilding)
				bSupplyOutpost = true;
			if (!bSupplyOutpost)
				{ Building bDummy; EnvWriteObj(set, "SupplyOutpost", bDummy);	}
			else
			{
				int i, nPeasants = 0;
				ObjList ol;	ol = bOutpost.settlement.Units;
				for (i = 0; i < ol.count; i += 1)
					if (ol[i].IsHeirOf("Peasant")) {
						nPeasants += 1;
						if (nPeasants >= 5) break;
					}
				if (nPeasants < 5)
					set.StartSupplyFood(bOutpost.settlement);	/// drain flow to the outpost
			}
		}
	}
	// drain
	if (bCanDrain)
		cb.ExecCmd(strCmd, ptDummy, objDummy, false);

	Sleep(AIVar(idPlayer, AIV_Sleep_ES));
}

EnvWriteInt(set, "RestartEconomyScript", 0);
