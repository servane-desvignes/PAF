static boolean firstMousePress = false;

//* classe des "handles" qui permettent a l'utilisateur de manipuler les conditions initiales

class Box {

  int x, y; //coordonnees du debut de la ligne

  int boxx, boxy; // coordonnees de la boite

  int stretch; // distance entre le debut de la ligne et la boite

  int size; // taille de la boite

  boolean over; // true si la souris est au dessus du carré

  boolean press; // true si le carré est cliqué par la souris

  boolean locked = false; // bloque les autres carrés

  boolean otherslocked = false;

  Box[] others; // autres carres

  Flocking flock; // troupeau d'agents

  /** Constructeur de la classe **/

  Box(int ix, int iy, int il, int is, Box[] o) {
    x = ix;
    y = iy;
    stretch = il;
    size = is;
    boxx = x+stretch - size/2;
    boxy = y - size/2;
    others = o;
  }

  /** Met a jour la position du carré **/

  void update() {
    boxx = x+stretch;
    boxy = y - size/2;
    for (int i=0; i<others.length; i++) {
      if (others[i].locked == true) {
        otherslocked = true;
        break;
      } else {
        otherslocked = false;
      }
    }
    if (otherslocked == false) {
      overEvent();
      pressEvent();
    }
    if (press) {
      stretch = lock(0, mouseX-x, 280);
    }
  }

  /** Detecte si la souris est au dessus  **/
  
  void overEvent() {
    if (overRect(boxx, boxy, size, size)) {
      over = true;
    } else {
      over = false;
    }
  }

  /** Detecte si l'utilisateur clique dessus **/ 
  
  void pressEvent() {
    if (over  && firstMousePress || locked) {
      press = true;
      locked = true;
    } else {
      press = false;
    }
  }

  void releaseEvent() {
    locked = false;
  }

  /** Affiche le carre **/ 
  
  void display() {
    line(x, y, boxx, y);
    fill(255);
    stroke(0);
    rect(boxx, boxy, size, size);
    if (over || press) {
      line(boxx, boxy, boxx+size, boxy+size);
      line(boxx, boxy+size, boxx+size, boxy);
    }
  }

  /** Detecte si la souris et au dessus d'un carre quelconque **/
  
  boolean overRect(int x, int y, int width, int height) {
    if (mouseX >= x && mouseX <= x+width &&
      mouseY >= y && mouseY <= y+height) {
      return true;
    } else {
      return false;
    }
  }

  /** Permet de bloquer le carre si il depasse la lignee **/
  
  int lock(int val, int minv, int maxv) {
    return  min(max(val, minv), maxv);
  }

  /** Renvoie le nombre choisi par l'utilisateur **/
  
  int preyNumber() {
    return (int) ((stretch) * 300 /280);
  }
  
  int AssociationPourcent() {
    return (int) ((stretch) * 100 /280);
  }

}
