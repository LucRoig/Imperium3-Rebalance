//bool, ObjList objs, str OUT reasonText

Hero this;
int skill, level;

if (objs.count != 1)
	return false;
this = objs[0].AsHero;
if (!.IsValid)
	return false;

skill = HeroSkillId(cmdparam);
if (skill < 0)
	return false;
level = .GetSkill(skill);
if (level < 0)
	return false;

if (level == 0)	{
	reasonText = rollover(this,false) + "\n<color 255 0 0>" + Translate("You need to have at least 1 point to can use this skill");
	return false;
}
if (.SkillInEffect(skill)) {
	reasonText = rollover(this,false) + "\n<color 255 0 0>" + Translate("Skill already in effect");
	return false;
}
if (cmdcost_stamina > .stamina)
{
	reasonText = rollover(this,false) + "\n<color 255 0 0>" + Translate("Insufficient stamina");
	return false;
}
return true;
