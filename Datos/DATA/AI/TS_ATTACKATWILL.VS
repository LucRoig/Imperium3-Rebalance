// void, Settlement set, ObjList ol, Obj obj, int nParam


Building hall;
int area_radius;
point area_center;
point pt;
Query bears, boars, lions, lionesses, wolves, deer;
Query slow_animals, fast_animals;
Query wells;
Query training_camps;
//Query garrisons, ioutposts;
Obj well, ruins, outpost;
ObjList objs;
str class_name;
Unit ruin_hero;
int max_train_level;
bool check_ruins = true;
bool use_ruins = true;

int k, l, m;

hall = set.GetCentralBuilding();
area_center = hall.pos();
area_radius = 5000;

bears = ObjsInCircle(area_center, area_radius, "BearUnit");
boars = ObjsInCircle(area_center, area_radius, "BoarUnit");
lions = ObjsInCircle(area_center, area_radius, "LionMUnit");
lionesses = ObjsInCircle(area_center, area_radius, "LionFUnit");
wolves = ObjsInCircle(area_center, area_radius, "WolfUnit");
deer = ObjsInCircle(area_center, area_radius, "Deer");

slow_animals = Union(bears, Union(boars, Union(lions, lionesses)));
fast_animals = Union(wolves, deer);

wells = ObjsInCircle(area_center, area_radius, "BaseWell");

training_camps = Intersect(Union(ObjsInCircle(area_center, area_radius, "IOutpost"), ObjsInCircle(area_center, area_radius, "BOutpost")), FriendlyObjs(set.player, "Outpost"));

if (AIVar(set.player(), AIV_UseRuins) == 0)
	use_ruins = false;

SetNoAIFlag(ol, true);

while (ol.count > 0) {
	Sleep(2000);

	ol.ClearDead();
	max_train_level = EnvReadInt(set.player, "maxtrainlevel");

	l = 0;
	for (k = ol.count - 1; k >= 0; k -= 1) {
		if (ol[k].AsUnit().inherentlevel() < max_train_level) l += 1;
		if (l > 1) break;
	}
	if (l <= 1) max_train_level = 0;

	for (k = ol.count - 1; k >= 0; k -= 1) {
		Unit u;
		u = ol[k].AsUnit();

		// use divine grace
		if (u.AsHero().IsValid())
		if (u.health < 4*u.maxhealth/5)
		if (u.stamina >= 4)
			u.ExecCmd("divine_grace", u.pos, u, false);

		l = 15 * (51 - u.level); // lower level => bigger coward
		if (l < 400) l = 400;

		// try to prevent premature death
		if (u.health < l)
		if (u.command != "move")
 		if (u.IsEnemyInSquadSight()) {
			if (u.HasItem("Healing water"))
				u.UseItem("Healing water");
			else if (u.HasItem("Healing herbs"))
				u.UseItem("Healing herbs");
			else if (u.HasItem("Ash of druid heart"))
				u.UseItem("Ash of druid heart");
			else {
				l = 1000000;
				if (!wells.IsEmpty()) {
					well = wells.GetObjList().FilterClosest(u.pos, 1)[0];
					l = u.DistTo(well);
					if (l < 300) l = 1000000;
				}

				if (l < u.DistTo(hall)) {
					pt = well.pos - u.pos;
					pt.SetLen(pt.Len + 150);
					pt = pt + u.pos;
					u.SetCommand("move", pt);
				} else {
					u.SetCommand("move", area_center + Point(hall.radius,hall.radius));
					u.AddCommand(false, "enter", hall);
				}
			}
		}

		if (u.health >= l + 350)
		if (u.command == "move")
			u.SetCommand("idle");

		if (u.food < 2)
		if (u.HasItem("Rye spikes"))
			u.UseItem("Rye spikes");

		if (use_ruins) {
			// if ruins around, check it
			if (check_ruins)
			if (u.item_count < u.max_items) {
				ruins = FindRuins(area_center, area_radius, u.level);
				if (ruins.IsValid()) {
					u.SetCommand("enter", ruins);
					ruin_hero = u;
					check_ruins = false;
					continue;
				}
			}

			if (!check_ruins)
			if (u == ruin_hero)
			if (u.command != "enter")
			if (u.command != "sleep")
				check_ruins = true;
		}

		// check for nearby items 
		if (u.command == "getitem") continue;
		if (u.item_count < u.max_items)
		if (u.GetSquad().TakeNearbyItems(u.sight()))
			continue;

		if (u.command != "idle")
			continue;

		// can we still train?
		if (u.inherentlevel < max_train_level) {
			u.SetCommand("approach", hall);
			u.AddCommand(false, "train");
			continue;
		}

/*
		if (!garrisons.IsEmpty()) {
			outpost = garrisons.GetObjList().FilterClosest(u.pos, 1)[0];
			objs = outpost.AsBuilding().settlement().ObjectsAround("CMaceman");
			objs.ClearDead();
			if (objs.count() > 0) {
				u.SetCommand("approach", outpost);
				u.AddCommand(false, "engage");
				continue;
			}
		}

		if (!ioutposts.IsEmpty()) {
			outpost = ioutposts.GetObjList().FilterClosest(u.pos, 1)[0];
			objs = outpost.AsBuilding().settlement().ObjectsAround("ISlinger");
			objs.ClearDead();
			if (objs.count() > 0) {
				u.SetCommand("approach", outpost);
				u.AddCommand(false, "engage_unit_type_exclusive", objs[0]);
				continue;
			}
		}
*/

		if (AttackSetForTraining(u, area_center, area_radius))
			continue;

		// try to hunt some slow animal
		if (u.inherentlevel < 6)
		if (!slow_animals.IsEmpty()) {
			u.SetCommand("attack", slow_animals.GetObjList().FilterClosest(u.pos, 1)[0]);
			continue;
		}

		// go in some nearby training camp
		if (u.inherentlevel < 8)
		if (!training_camps.IsEmpty()) {
			if (!u.InHolder())
				u.SetCommand("enter", training_camps.GetObjList().FilterClosest(u.pos, 1)[0]);
			else {
				class_name = u.GetHolderSett().GetCentralBuilding().class;
				if (class_name != "BOutpost")
				if (class_name != "IOutpost")
					u.SetCommand("enter", training_camps.GetObjList().FilterClosest(u.pos, 1)[0]);
			}
		}

		// try to hunt some fast animal
		if (u.inherentlevel < 8)
		if (!fast_animals.IsEmpty()) {
			u.SetCommand("attack", fast_animals.GetObjList().FilterClosest(u.pos, 1)[0]);
			continue;
		}

		// if nothing else to do, go home
		if (!u.InHolder())
			u.SetCommand("enter", hall);
	}
}

// this script must be terminated by the calling script by AIBreakScript
while (1)
	Sleep(900600);
