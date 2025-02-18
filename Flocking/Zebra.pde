//classe des zebres

class Zebra extends Prey {

  /** Constructeur de la classe des zebres 
  *@param x,y la position initiale **/
  
  Zebra(float x, float y) {
    super(x, y, 2, 0.03, 4, 500, 100);
  }
  
  /**Methode pour mettre a jour l'apparence des zebres **/
  
  void render() {
    float theta = velocity.heading() + radians(90);
    fill(0, 128, 0);
    stroke(255);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  }

  /** Methode pour mettre a jour le comportement des zebres 
  *@param boids la liste des boids autour **/
  
  void behavior(ArrayList<Boid> boids) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  @Override
  boolean isZebra() {
    return true;
  }
  
  @Override
  boolean isSameSpecies(Boid other) { return other.isZebra(); }
}
