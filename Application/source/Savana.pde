class Savana {
  ArrayList<Boid> boids;// An ArrayList for all the boids
  PVector wCenter;

  Savana() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
  }
  
  ArrayList<Prey> getPreys() {

    ArrayList<Prey> listePrey = new ArrayList<Prey>();
    for (Boid b : boids) {
      if (b.isPrey()) {
        listePrey.add((Prey) b);
      }
    }
    return listePrey;
  }

  ArrayList<Prey> getWildebeests() {
    ArrayList<Prey> w = new ArrayList<Prey>();
    for (Prey p : getPreys()) {
      if (p.isWildebeest()) {
        w.add(p);
      }
    }
    return w;
  }

  ArrayList<Prey> getZebras() {
    ArrayList<Prey> w = new ArrayList<Prey>();
    for (Prey p : getPreys()) {
      if (p.isZebra()) {

        w.add(p);
      }
    }
    return w;
  }

  ArrayList<Predator> getCheetahs() {
    ArrayList<Predator> w = new ArrayList<Predator>();
    for (Predator p : getPredators()) {
      if (p.isCheetah()) {

        w.add(p);
      }
    }
    return w;
  }


  PVector wildebeestCenter() {
    ArrayList<Prey> wildebeests = getWildebeests();
    int N=wildebeests.size();
    PVector C = new PVector(0, 0);
    for (Prey w : wildebeests) {
      C = C.add(w.position);
    }
    if (N!=0) {
      //float NFloat = (float)N;
      C = C.mult(1.0/N);
      println("----->>>>>>" + C.x + ", " + C.y);
      return C;
    } else {
      println("------>>>>> !!!!! returning C = 0");
      return C.mult(0);
    }
  }

  Prey MostIsolateWildebeest() {
    PVector center = wildebeestCenter();
    ArrayList<Prey> wflock = getWildebeests();
    int imin =0;
    float dMin= distanceTo(wflock.get(0), center);
    /*
   for(Prey w : wflock){
     float d = distanceTo(w,center);
     if(d<dMin){
     i++;
     }
     }
     return wflock.get(i);*/

    for (int i =0; i<wflock.size(); i++) {
      if (distanceTo(wflock.get(i), center)<dMin) {
        imin=i;
        dMin=distanceTo(wflock.get(i), center);
      }
    }
    return wflock.get(imin);
  }

  float distanceTo(Boid boid, PVector point) {
    return PVector.sub(boid.position, point).mag();
  }

  ArrayList<Predator> getPredators() {
    ArrayList<Predator> listePred = new ArrayList<Predator>();
    for (Boid b : boids) {
      if (!b.isPrey()) {
        listePred.add((Predator) b);
      }
    }
    return listePred;
  }

  void remove(Boid b) {
    boids.remove(b);
  }

  int number() {
    return boids.size();
  }

  void run() {
    this.wCenter = wildebeestCenter();
    render();

    for (int i=0; i<boids.size(); i++) {

      Boid b = boids.get(i);


      b.run(boids);
    }
  }

  int NumberOfCheetahs() {
    int c=0;
    for (Boid b : boids) {
      if (b.isCheetah()) {
        c++;
      }
    }
    return c;
  }

  int NumberOfZebras() {
    int c=0;
    for (Boid b : boids) {
      if (b.isZebra()) {
        c++;
      }
    }
    return c;
  }

  int NumberOfWildebeests() {
    int c=0;
    for (Boid b : boids) {
      if (b.isWildebeest()) {
        c++;
      }
    }
    return c;
  }
  int size() {
    return boids.size();
  }

  void addBoid(Boid b) {
    boids.add(b);
  }

  float rz = 4;

  void render() {
    PVector position = wCenter;
    // Draw a triangle rotated in the direction of velocity
    float theta =position.heading() + radians(90);
    // heading2D() above is now heading() but leaving old syntax until Processing.js catches up


    fill(185, 42, 76);
    stroke(7);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape(QUAD);
    vertex(0, -rz*2);
    vertex(-rz*2, 0);
    vertex(0, rz*2);
    vertex(rz*2, 0);
    endShape();
    popMatrix();

  }
}
