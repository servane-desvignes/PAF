
class Pack {
  ArrayList<Cheetah> cheetahs; // An ArrayList for all the boids

  Pack() {
    cheetahs = new ArrayList<Cheetah>(); // Initialize the ArrayList
  }

  void run(ArrayList<Boid> boids) {
    for (Cheetah c : cheetahs) {
      c.run(boids);  // Passing the entire list of boids to each boid individually
    }
  }

  void addCheetah(Cheetah c) {
    cheetahs.add(c);
  }
}
