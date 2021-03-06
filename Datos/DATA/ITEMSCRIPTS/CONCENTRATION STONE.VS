//void, Obj owner, Obj target

int nHealthToGive, nHealthToTake;

if( owner.AsUnit.InHolder )
{
	UserNotification("item cannot use in holder", "", owner.posRH, owner.player);
	return;
}

nHealthToTake = owner.maxhealth - owner.health;
if(!target.AsUnit().IsValid()) // Units only, please!
{
	UserNotification("friendly target only", "", owner.posRH, owner.player);
	return;
}
if(target.IsEnemy(owner))
{
	UserNotification("friendly target only", "", owner.posRH, owner.player);
	return;
}
if(target.DistTo(owner)>owner.sight*3/2) // Only ones nearby, please!
	return;

if (target.AsHero().IsValid()) {
	nHealthToGive = target.health - target.maxhealth/5; //20%
} else {
	nHealthToGive = target.health;
}

if (nHealthToGive>0) {
	if (nHealthToGive > nHealthToTake) {
		owner.Heal(nHealthToTake);
		target.Damage(nHealthToTake);
		CreateFeedback("Damage1", target.AsUnit());
		CreateFeedback("Heal", owner.AsUnit());
	} else {
		owner.Heal(nHealthToGive);
		target.Damage(nHealthToGive);
		CreateFeedback("Damage1", target.AsUnit());
		CreateFeedback("Heal", owner.AsUnit());
	}
}
