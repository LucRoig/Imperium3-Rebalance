// void, Obj This

PlaySound("data/Sound Entities/StonehengeSpell.xml");

SetGlobalBloodlust(true);
Sleep(GetConst("StonehengeBloodlustTime"));
SetGlobalBloodlust(false);
