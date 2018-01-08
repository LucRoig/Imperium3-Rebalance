// void, Obj This

Hero this;
Obj obj;
point pt;

int nSkillDevelop, nSkillDevelopLevel;
int available, skillpoints, cost, i;

str cmd_cry;
int nMilitary, nDruids;
int nFights, nFightsPerc;
int nArmyHealth, nArmyMaxHealth, nHealthPerc, nHealthGainPerc;
int nHealing, nHealAmount, nHealCount;
int nArmyStamina, nArmyMaxStamina, nStaminaPerc;
int nCharging, nChargeAmount, nChargeCount, nChargePerc;
int nRushing, nRushAmount, nRushPerc;
bool is_there_enemy_around;

this = This.AsHero;

nSkillDevelop = -1;
nSkillDevelopLevel = -1;

pt = Point(-2, -2);

Sleep(rand(1000) + 500);

while (1)
{
	if (!.IsAlive)
		break;

	if (!.autocast)
	if (!.AI)
	{
		Sleep(5813);
		continue;
	}
	
	/// check for available skill points
	if (.AI)
	while (1)
	{
		available = .AvailableSkillPoints;
		if (available <= 0) break;
		if (nSkillDevelop < 0)
		{
			.AIGetSkillToDevelop(nSkillDevelop, nSkillDevelopLevel);
			if (nSkillDevelop < 0) break; /// it seems we have mastered everything possible
		}
		// already developing a skill
		skillpoints = .GetSkill(nSkillDevelop);
		if (skillpoints < 0 || skillpoints >= nSkillDevelopLevel)
		{	// this case can appear only when any bad guy is mess up with the skills on the fly
			nSkillDevelop = -1;
			continue;
		}
		if (skillpoints + available < nSkillDevelopLevel) {
			.SetSkill(nSkillDevelop, skillpoints + available);
			break;
		}
		.SetSkill(nSkillDevelop, nSkillDevelopLevel);
		nSkillDevelop = -1;
		nSkillDevelopLevel = -1;
	}

	/// evaluate army status
	nMilitary = 0; nDruids = 0;
	nFights = 0; nFightsPerc = 0;
	nArmyHealth = 0; nArmyMaxHealth = 0; nHealthPerc = 0; nHealthGainPerc = 0;
	nArmyStamina = 0; nArmyMaxStamina = 0; nStaminaPerc = 0; nChargePerc = 0;
	nRushing = 0; nRushAmount = 0; nRushPerc = 0;
	
	nHealing = 10 * .GetSkill(hsHealing);
	if (nHealing < 0) nHealing = 0;
	nHealAmount = 0; // health spread
	nHealCount = 0;  // units affected

	nCharging = .GetSkill(hsCharge);
	if (nCharging < 0) nCharging = 0;
	nChargeAmount = 0; // stamina spread
	nChargeCount = 0;	 // units affected

	nRushing = .GetSkill(hsRush);
	if (nRushing < 0) nRushing = 0;
	
	.army.ClearDead;

	if (.army.count > 0) if (.stamina > 0)
	{
		is_there_enemy_around = .IsEnemyInSquadSight();
		for (i = 0; i < .army.count; i += 1)
		{
			Unit u; u = .army[i];
			if (u.AsDruid) nDruids += 1;
			else {
				nMilitary += 1;
				if (is_there_enemy_around)
				if (u.TimeWithoutAttack < 1500)
					nFights += 1;
			}
			nArmyHealth += u.health;
			nArmyMaxHealth += u.maxhealth;
			nHealAmount += (2*u.health + u.maxhealth + 1) * CLAMP(u.maxhealth - u.health, 0, nHealing) / (3*u.health + 1);
			

			nArmyStamina += u.stamina;
			nArmyMaxStamina += u.maxstamina;
			nChargeAmount += CLAMP(u.maxstamina - u.stamina, 0, nCharging);
			nRushAmount += (u.health - nRushing * 10) * CLAMP(u.maxstamina - u.stamina, 0, nRushing) / (u.health + 1);
		}
		if (nMilitary > 0) nFightsPerc = nFights * 100 / nMilitary;
		if (nArmyMaxHealth > 0) nHealthPerc = nArmyHealth * 100 / nArmyMaxHealth;
		if (nArmyMaxStamina > 0) nStaminaPerc = nArmyStamina * 100 / nArmyMaxStamina;

		if (nArmyMaxHealth > 0) nHealthGainPerc = nHealAmount * 100 / nArmyMaxHealth;
		if (nArmyMaxStamina > 0) nChargePerc = nChargeAmount * 100 / nArmyMaxStamina;
		if (nArmyMaxStamina > 0) nRushPerc = nRushAmount * 100 / nArmyMaxStamina;
	}

	/// check to use an active skill
	while (.stamina >= 4) // 4 is the minimal skill cost
	{
		int nWeight = 0;
		int nThisWeight = 0;
		cmd_cry = "";

		while (1)
		{
			// Ceasefire (army don't inflict or take damage)
			skillpoints = .GetSkill(hsCeasefire);
			if (skillpoints > 0) if (.command == "retreat") if (!.SkillInEffect(hsCeasefire))
			{
				cmd_cry = "skill_ceasefire";
				break; // max priority...dead hero is dead cause
			}

			// Divine grace (not a skill) (Heals the hero with 10% of his maximum health)
			if (.health < .maxhealth) {
				cmd_cry = "divine_grace";
				if (.health <= 500) break;
				nWeight = 1 + 40 * (.maxhealth - .health) / (.maxhealth + .health - 1000);
			}
			
			// Healing (restores 10 health points per skill point to all attached units)
			nThisWeight = nHealthGainPerc - 8;
			if (nThisWeight > nWeight)
			{
				cmd_cry = "skill_healing";
				nWeight = nThisWeight;
			}

			// Charge (adds 1 stamina per level to all attached units)
			nThisWeight = nChargePerc - 20;
			if (nThisWeight > nWeight)
			{
				cmd_cry = "skill_charge";
				nWeight = nThisWeight;
			}

			// Battle cry (increases the level of every attached warrior by 1 per skill point)
			skillpoints = .GetSkill(hsBattleCry);
			if (skillpoints > 0)
			if (!.SkillInEffect(hsBattleCry))
			if (nFightsPerc > 40)
			{
				nThisWeight = skillpoints * nFightsPerc / 10;
				if (nThisWeight > nWeight)
				{
					cmd_cry = "skill_battle_cry";
					nWeight = nThisWeight;
				}
			}

			// Assault (the attached units ignore the armor of the enemies)
			skillpoints = .GetSkill(hsAssault);
			if (skillpoints > 0)
			if (!.SkillInEffect(hsAssault))
			if (nFightsPerc > 40)
			{
				nThisWeight = skillpoints * nFightsPerc / 9;
				if (nThisWeight > nWeight)
				{
					cmd_cry = "skill_assault";
					nWeight = nThisWeight;
				}
			}

			// Defensive cry (increases the armor of the attached units by 20)
			skillpoints = .GetSkill(hsDefensiveCry);
			if (skillpoints > 0)
			if (!.SkillInEffect(hsDefensiveCry))
			if (nFightsPerc > 40)
			{
				nThisWeight = skillpoints * nFightsPerc / 10;
				if (nThisWeight > nWeight)
				{
					cmd_cry = "skill_defensive_cry";
					nWeight = nThisWeight;
				}
			}

			// Frenzy (halves the health of every attached unit and doubles its damage)
			skillpoints = .GetSkill(hsFrenzy);
			if (skillpoints > 7)
			if (!.SkillInEffect(hsFrenzy))
			if (nFightsPerc > 40)
			{
				nThisWeight = skillpoints * nFightsPerc / 12;
				if (nThisWeight > nWeight)
				{
					cmd_cry = "skill_frenzy";
					nWeight = nThisWeight;
				}
			}

			// Rush (adds 1 point of stamina per skill level and damages with 10 per skill level every attached unit)
			// what a freakish idea
			skillpoints = .GetSkill(hsRush);
			if (skillpoints > 0)
			{
				nThisWeight = nRushPerc;
//				pr ("rush weight " + nThisWeight);
				if (nThisWeight > nWeight)
				{
					cmd_cry = "skill_divine_rush";
					nWeight = nThisWeight;
				}
			}
			break;
		}

		if (StrLen(cmd_cry) == 0) break;
		cost = GetCmdStaminaCost(cmd_cry);
		if (.stamina < cost) break; // wait for more stamina
		cost = .stamina;
//		pr ("autocasting: " + cmd_cry + " " + nWeight);
		.ExecCmd(cmd_cry, pt, obj, false);
		if (.stamina >= cost)
			break;
	}
	Sleep(1317);
}

Sleep(9127);
