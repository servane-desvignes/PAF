// The Boid class

abstract class Boid {

  //parametre regissant le mouvement d'un agent
  PVector position;
  PVector velocity;
  PVector acceleration;

  //la taille d'un agent
  float r;

  float maxforce;    // Maximum steering force
  float maxspeed;  // Maximum speed

  boolean alive; // true si l'agent est en vie

  float rangeVision; // son champ de vision

  float x;
  float y;

  float rangeAudition; // champ d'audition

  int timeAlive=0; //le temps de vie d'un agent

  boolean isTargeted; // true si il est attaque par un predateur

  PVector direction = velocity;

  int lifetime;

  /**Constructeur de la classe Boid
   *@param x 1 axe de position
   *@param y 1 axe de position
   *@param maxforce maximum steering force
   *@param rangeVision champ de vision
   *@param rangeAudition champ d'audition
   **/

  Boid(float x, float y, float r, float maxforce, float maxspeed, float rangeVision, float rangeAudition) {
    acceleration = new PVector(0, 0);
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));
    this.x=x;
    this.y=y;

    position = new PVector(x, y);
    this.r = r;
    this.maxspeed = maxspeed;
    this.maxforce = maxforce;
    this.rangeVision=rangeVision;
    alive = true;
    this.rangeAudition = rangeAudition;

    lifetime = 0;
  }

  /** Modifie les attributs lorsque l'agent est tué par un prédateur **/

  void killed() {
    this.alive=false;
    this.isTargeted=false;
  }


  /** Comportement du boid lors du lancement de la simulationi **/

  void run(ArrayList<Boid> boids) {
    if (alive) lifetime++;
    this.timeAlive++;
    behavior(boids);
    update();
    borders();
    render();
  }

  /** Applique une force au boid **/

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  /** Le boid arrete tout mouvement **/

  void stayStill() {
    acceleration.mult(0);
    velocity.mult(0);
  }

  /** Calcule la distance entre deux boids **/

  float distTo(Boid b) {
    return PVector.sub(b.position, this.position).mag();
  }

  float distanceTo(PVector p) {
    return PVector.sub(p, this.position).mag();
  }

  /** Modifie l'apparence du boid**/

  abstract void render();

  /** Decrit le comportement du boid **/

  abstract void behavior(ArrayList<Boid> boids);

  /** Met a jour le boid **/

  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    position.add(velocity);
    acceleration.mult(0);
    if (!this.alive) {
      savana.remove(this);
    }
  }

  boolean isAlive() {
    return alive;
  }

  /** Calcul et applique une force vers une proie **/

  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);  // vecteur entre la proie et le predateur
    desired.normalize();
    desired.mult(maxspeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  //limiter la force a la force maximale 
    return steer;
  }

  // Comportement torique des agents
  void borders() {
    if (position.x < -r) position.x = width*0.75+r-5;
    if (position.y < -r) position.y = height+r;
    if (position.x > width*0.75-5+r) position.x = -r;
    if (position.y > height+r) position.y = -r;
  }

  /** Separe les agents trop prochese entre eux **/
  
  abstract PVector separate (ArrayList<Boid> boids);
  
  /** Aligner les agents entre eux **/
  
  abstract PVector align(ArrayList<Boid> boids);
  
  /** Avoir comportement uniforme entre agents assez proches **/
  abstract PVector cohesion(ArrayList<Boid> boids);


  /** Les methodes suivantes reposent sur le comportement a liaison dynamique de Java 
  * On utilise l'heritage de classe pour redefinir ces methodes qui renverront true dans les classes respectives
  * Ainsi ces methodes nous permettrons de connaitre le type dese agents sans utiliser typeOf ou de switch **/
  
  boolean isZebra() {
    return false;
  }

  boolean isPredator() {
    return false;
  }

  boolean isPrey() {
    return false;
  }

  boolean isCheetah() {
    return false;
  }

  boolean isWildebeest() {
    return false;
  }
  
  abstract boolean isSameSpecies(Boid other);
}
