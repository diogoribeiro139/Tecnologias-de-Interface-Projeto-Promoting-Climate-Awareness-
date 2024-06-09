class Botoes {

  float x, y, r1, r2;

  Botoes() {

    x=width/2;
    y=height/2;
  }

  Botoes(float x, float y, float r1, float r2) {
    this.x=x;
    this.y=y;

    this.r1=r1;
    this.r2=r2;
  }
  void desenha(float x, float y, float r1, float r2) {
    noStroke();
    fill(255);
    rectMode(CENTER);
    rect(x, y, 2*r1, 2*r2, 8);
  }
  boolean colide(float x, float y, float r1, float r2) {
    if (mouseX < x+r1 && mouseX > x-r1 && mouseY < y+r2 && mouseY > y-r2) {
      return true;
    } else return false;
  }
}
//rect(120, 80, 220, 220, 28);
