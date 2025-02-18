class Cheetah extends Predator {
  float rangeVision=0;
  float rangeAudition=0;

  Cheetah(float x, float y) {
    super(x, y, 4, 0.05, 3, 100, 30, 100);
  } // les argument sont (x,y,r,f,v,rV,dminkill,rA)


  @Override
    void behavior(ArrayList<Boid> boids) {
    if (this.timeAlive<0.1*starvingTime || savana.getPreys().size()==0) {
      this.stayStill();
    } else {
      if (this.hasAPrey) {
        PVector direction = seek(this.target.position);
        applyForce(direction);
        if (distanceToPrey(this.target)<dMinKill) {
          this.target.killed();
          println("prey killed prey population remaining =" + savana.getPreys().size());
          this.hasAPrey = false;
          this.timeAlive = 0;
          this.target.isTargeted=false;
          println("l'énergie est " + this.energy());
        }
      } else {
        PVector dir = seek(savana.wildebeestCenter());
        applyForce(dir.mult(1));
        this.target = findATarget();
        for (Prey p : savana.getPreys()) {

          if ((canBeSeen( p) || canBeHeard( p)) && p.numberOfNeighboors()<3 && !p.isTargeted) {
            println(this +" is seeing " +this.target);
            this.target = p;
            p.isTargeted=true;
            this.hasAPrey=true;
          }
        }
      }
    }
    if (this.timeAlive>starvingTime) {
      this.alive = false;
    }
  }



  float energy() {
    return ((this.starvingTime-this.timeAlive)/this.starvingTime);
  }


  PVector randomVector() {
    float r = random(1000);
    float x = cos((r/1000.0)*2*PI);
    float y = sin((r/1000.0)*2*PI);
    PVector P =new PVector(x, y);
    return   P;
  }



  Prey findATarget() {
    ArrayList<Prey> preys = savana.getPreys();
    Prey victim = closestPrey(preys);
    Prey isolatedVictim = savana.MostIsolateWildebeest();
    if (PVector.sub(position, victim.position).mag()<PVector.sub(position, isolatedVictim.position).mag()) {
      return victim;
    }
    return isolatedVictim;
  }

  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading() + radians(90);
    // heading2D() above is now heading() but leaving old syntax until Processing.js catches up
    if (this.hasAPrey) {
      fill(200, 0, 0);
      noStroke();
      pushMatrix();
      translate(position.x, position.y);
      rotate(theta);
      beginShape(TRIANGLES);
      vertex(0, -r*2);
      vertex(-r, r*2);
      vertex(r, r*2);
      endShape();
      popMatrix();
    } else {
      fill(100, 0, 0);
      noStroke();
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
  }

  @Override
    boolean isCheetah() {
    return true;
  }
  
  @Override
  boolean isSameSpecies(Boid other) { return other.isCheetah(); }
}
