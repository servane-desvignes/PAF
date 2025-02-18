//classe des proies

abstract class Prey extends Boid {

  float alpha = 5*PI/6; //caractérise le champs de vision de la proies

  float desiredSeparationPrey = 25.0f; // distance de separation d'une autre proie

  float desiredSeparationPredator = 2000.0f; // distance de separation entre proie et predateur ( plus grande que la precedente pour modeliser la fuite des proies )

  boolean isTargeted=false; // true si elle est attaquee par un predateur

  boolean isIsolated=false; // true si l'agent est isolé


  /** Constructeur de la classe **/

  Prey(float x, float y, float r, float maxforce, float maxspeed, float rangeVision, float rangeAudition) {
    super(x, y, r, maxforce, maxspeed, rangeVision, rangeAudition);
  }

  /** Methode reposant sur le comportement a liaison dynamique de java
   * Nous indique si l'agent est une proie
   **/

  @Override
    boolean isPrey() {
    return true;
  }

  /** Methode renvoyant true si l'agent this est visible par l'agent b ( utilisé sur des predateurs )
   @param b l'agent dont on verifie le champ de vision
   **/

  boolean canBeSeen(Boid b) {
    PVector P = new PVector(b.x, b.y);
    PVector delta=PVector.sub(P, this.position);
    float dist = delta.mag();
    if (dist>this.rangeVision) {
      return false;
    }
    float beta = abs(PVector.angleBetween(this.velocity, delta));
    float gamma = PI-alpha;
    if (beta>PI-gamma) {
      return false;
    }
    return true;
  }

  /** Methode renvoyant true si l'agent this peut etre entendu par l'agent b
   *@param b l'agent dont on verifie le champ d'audition
   **/

  boolean canBeHeard(Boid b) {

    PVector P = new PVector(b.x, b.y);
    PVector delta=PVector.sub(P, this.position);
    float dist = delta.mag();
    if (dist>this.rangeAudition) {
      return false;
    }
    return true;
  }

  /** Methode pour compter le nombre de voisins. Utilisée pour verifier si une proie est isolée , c'est-a-dire son nombre de voisins est inferieur a 3 **/

  int numberOfNeighboors() {
    ArrayList<Prey> preys = savana.getPreys();
    preys.remove(this);
    int i = 0;
    for (Prey p : preys) {
      if (this.distTo(p)<5*this.r) { // On considere que deux agents sont proches si leur distance est inferieur a 5 fois leur taille
        i++;
      }
    }
    return i;
  }

  /** Decrit le comportement des proies **/

  void behavior(ArrayList<Boid> boids) {

    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    if (this.numberOfNeighboors()<3) {
      this.isIsolated = true;
    }
    if (this.numberOfNeighboors()>2) {
      this.isIsolated = false;
    }
    // coefficiente arbitrairement les forces
    sep.mult(1.5);
    ali.mult(0.5);
    coh.mult(0.3);
    // ajoute les forces a l'acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  /** Alignement
   *Pour tous les boids proches, calcule la vitesse moyenne
   **/

  @Override
    PVector align (ArrayList<Boid> boids) {
    float neighbordist = rangeVision;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      } else if (this.isPrey()) {
        float alignementPourcentage = Flocking.desireAssociation/100;
        if ((d > 0) && (d < neighbordist)) {
          sum.add(PVector.mult(other.velocity, alignementPourcentage));
          count++;
        }
      }
    }

      if (count > 0) {

        sum.div((float)count);
        // First two lines of code below could be condensed with new PVector setMag() method
        // Not using this method until Processing.js catches up
        // sum.setMag(maxspeed);

        // Implement Reynolds: Steering = Desired - Velocity
        sum.normalize();
        sum.mult(maxspeed);
        PVector steer = PVector.sub(sum, velocity);
        steer.limit(maxforce);
        return steer;
      } else {
        return new PVector(0, 0);
      }
    
  }

  /** Cohesion
   * Pour le centre de tous les boids proches , calcule le vecteur qui mene a cette position
   **/

  @Override
    PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = rangeVision;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all positions
    int count = 0;

    for (Boid other : boids) {
      if (this.isSameSpecies(other) || Flocking.desireAssociation != 0 && this.isPrey() ) {
        float d = PVector.dist(position, other.position);
        if ((d > 0) && (d < neighbordist)) {
          sum.add(other.position); // Add position
          count++;
        }
      }
    }

    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the position
    } else {
      return new PVector(0, 0);
    }
  }

  @Override
    PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    for (Boid other : boids) {
      if (other.isPrey()) {
        desiredseparation=desiredSeparationPrey;
      }
      if (other.isPredator()) {
        desiredseparation=desiredSeparationPredator;
      }
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < desiredseparation)) {
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    //moyenne
    if (count > 0) {
      steer.div((float)count);
    }
    if (steer.mag() > 0) {
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }
}
