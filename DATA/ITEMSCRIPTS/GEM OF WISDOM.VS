//void, Obj owner, Obj attached

int exp, exp2;

if (rand(100) > 50)
	return;
if (attached.AsUnit.InHolder())
	return;

exp = attached.AsUnit().experience;
exp2 = owner.AsUnit().experience;

CreateFeedback("Experience", owner.AsUnit());
exp2 += 1;
owner.AsUnit.SetExperience(exp2);
