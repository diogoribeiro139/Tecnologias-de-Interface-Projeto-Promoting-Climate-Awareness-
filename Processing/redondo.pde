class Circ {

  float x, y, r1, col;

  Circ() {

    x=width/2;
    y=height/2;
  }

  Circ(float x, float y, float r1, float col) {
    this.x=x;
    this.y=y;
    this.col=col;

    this.r1=r1;
  }
  void desenha(float x, float y, float r1, float col) {
    noStroke();
    fill(col);
   //circleMode(CENTER);
    circle(x, y, 2*r1);
  }
  boolean colide(float x, float y, float r1, float r2) {
    if (mouseX < x+r1 && mouseX > x-r1 && mouseY < y+r2 && mouseY > y-r2) {
      return true;
    } else return false;
  }
}
