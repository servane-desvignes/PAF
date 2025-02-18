/*
import java.util.Map;

class SwarmDraws{
  ArrayList<Prey> wildebeests;
  ArrayList<Predator> cheetahs;
  ArrayList<Prey> zebras;
  float r = 4;
  PVector wCenter;
  
  SwarmDraws(Savana savana){
    this.wildebeests = savana.getWildebeests();
    this.zebras = savana.getZebras();
    this.cheetahs = savana.getCheetahs();
    this.wCenter = new PVector(0,0);
  }
  
  
  
  
  void run(){
   this.wCenter = savana.wildebeestCenter();
    render();}
    
    
  
void render() {
  PVector position = wCenter;
    // Draw a triangle rotated in the direction of velocity
    float theta =position.heading() + radians(90);
    // heading2D() above is now heading() but leaving old syntax until Processing.js catches up

  
       fill(185, 42,76);
    stroke(7);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape(QUAD);
    vertex(0, -r*2);
    vertex(-r*2,0);
    vertex(0, r*2);
    vertex(r*2,0);
    endShape();
    popMatrix();
    }
  
/*ArrayList<Prey> sortedByDistance(){
  PVector C = wildebeestCenter();
  FloatList D = new FloatList();
  HashMap<Prey, float> pd = new HashMap<Prey, float>();
  for(Prey p : wildebeests){
    float d = p.distanceTo(C);
    D.append(d);
    pd.put(p,d);
  }
  D.sort();
  ArrayList<Prey> S = new ArrayList<Prey>();
  for(float d : D){
    S.add(pd.get(d));
  }
  return S; 
  
  
  
}*/
  
  
