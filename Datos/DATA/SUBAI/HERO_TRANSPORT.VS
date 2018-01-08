// void, Obj This, Obj other
Hero this;

//.pr("hero::move");
this = This.AsHero();

// Ivko: Always walk in formation, so newly attached units automatically enter formation
.FormSetupAndMoveTo (other, other.sight/3, other.radius, true);
while (.HasPath ())
{
  .FormKeepMoving (1497);
}

other.SetCommand("transport_request");