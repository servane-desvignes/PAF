// classe des prédateurs

abstract class Predator extends Boid {

  ArrayList<Prey> Eaten;
  float dMinKill;
  float alpha = PI/3; // caractérise le champs de vision des prédateurs
  boolean hasAPrey=false;
  Prey target;
  float energy;
  float initialEnergy=1;
  int starvingTime=1000;
  boolean starving = false ;
  boolean isTargeted=false;


  Predator(float x, float y, float r, float maxforce, float maxspeed, float rangeVision, float dMinKill, float rangeAudition) {
    super(x, y, r, maxforce, maxspeed, rangeVision, rangeAudition);
    this.dMinKill = dMinKill;
  }

  boolean canBeSeen(Prey b) {
    PVector P = new PVector(b.x, b.y);
    PVector delta=PVector.sub(P, this.position);
    float dist = delta.mag();
    if (dist>this.rangeVision) {
      return false;
    }
    float beta = abs(PVector.angleBetween(this.velocity, delta));
    if ( (beta>alpha/2)) {
      return false;
    }
    return true;
  }


  float energyDecreasement() {
    return float(1-(this.timeAlive/this.starvingTime));
  }


  void starvation() {
    if (energyDecreasement()<0.5) {
      this.starving = true;
    }
  }


  boolean canBeHeard(Prey b) {
    PVector P = new PVector(b.x, b.y);
    PVector delta=PVector.sub(P, this.position);
    float dist = delta.mag();
    if (dist>this.rangeAudition) {
      return false;
    }
    return true;
  }





  /*
  Prey closestPrey(ArrayList<Prey> preys) {
   float dMin = PVector.sub(position, preys.get(0).position).mag();
   int i = 0;
   for (Prey p : preys) {
   PVector delta = PVector.sub(position, p.position);
   float distance = delta.mag();
   if (distance<dMin) {
   dMin=distance;
   i++;
   }
   }
   return preys.get(i);
   }*/

  Prey closestPrey(ArrayList<Prey> preys) {
    float dMin = PVector.sub(position, preys.get(0).position).mag();
    int imin=0;
    for (int i =0; i<preys.size(); i++) {
      Prey p =preys.get(i);
      if (PVector.sub(position, p.position).mag()<dMin || (PVector.sub(position, p.position).mag()==dMin && p.isWildebeest() )) { // si cas d'egalité des distances, le predateur prefere chasser les cheetahs
        dMin = PVector.sub(position, p.position).mag();
        imin=i;
      }
    }
    this.hasAPrey=true;
    return preys.get(imin);
  }



  float distanceToPrey(Prey p) {
    return PVector.sub(position, p.position).mag();
  }


  /* boolean tooCloseToCenter(){
   PVector c = savana.wildebeestCenter();
   if(distancetTo(c)<
   }*/


  float distanceToClosestPrey(ArrayList<Prey> preys) {
    return distanceToPrey(closestPrey(preys));
  }

  @Override
    PVector separate(ArrayList<Boid> boids) {
    return new PVector(0, 0);
  }

  @Override
    PVector align(ArrayList<Boid> boids) {
    return new PVector(0, 0);
  }

  @Override
    PVector cohesion(ArrayList<Boid> boids) {
    return new PVector(0, 0);
  }




  @Override
    boolean isPredator() {
    return true;
  }
}
