/** classe des gnous **/

class Wildebeest extends Prey {

  float r=2; //taille du gnou

  float maxforce=0.01; //force maximale applicable au gnou

  float maxspeed=0; // vitesse maximale acceptee

  float rangeVision=50; // champ de vision

  boolean alive; // true si le bdi est en vie

  float rangeAudition; // champ d'audition


  /** Constructeur de la classe des gnous **/
  Wildebeest(float x, float y) {
    super(x, y, 2, 0.03, 2, 100, 100);
  }

  /** Determine l'apparence des gnous en fonction de si ils sont isolés ou pas, afin de mieux voir les proies vite attaquées par les predateurs **/

  void render() {
    float theta = velocity.heading() + radians(90);
    if (this.isIsolated) {
      fill(245, 198, 215);
      stroke(255);
      pushMatrix();
      translate(position.x, position.y);
      rotate(theta);
      beginShape(QUAD);
      vertex(0, -r*2);
      vertex(-r*2, 0);
      vertex(0, r*2);
      vertex(r*2, 0);
      endShape();
      popMatrix();
    }
    if (!this.isIsolated) {
      fill(14, 36, 173);
      stroke(255);
      pushMatrix();
      translate(position.x, position.y);
      rotate(theta);
      beginShape(QUAD);
      vertex(0, -r*2);
      vertex(-r*2, 0);
      vertex(0, r*2);
      vertex(r*2, 0);
      endShape();
      popMatrix();
    }
  }

  @Override
    boolean isWildebeest() {
    return true;
  }
  
  @Override
  boolean isSameSpecies(Boid other) { return other.isWildebeest(); }
}
