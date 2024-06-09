//------------------------------------------------------------------------------botoes
Botoes bt;
Circ c;
int screen=0;
import processing.serial.*;
PImage img, img1;
PImage[] h = new PImage[4];
int imagemAtual = 0;
Serial myPort;

color r= color(0, 255, 0);
color w= color(255, 0, 0);

int buttonBluePin = 6;
int buttonYellowPin = 5;
int buttonGreenPin = 4;
int buttonjoystickPin = 2;

int buttonWidth = 100;
int buttonHeight = 50;
int buttonY = 200;
int blueButtonX = 100;
int yellowButtonX = 250;
int greenButtonX = 400;

String[] wasteTypes = {"Garrafa de vinho", "Caixa de cartão", "Embalagem de leite", "Jornal", "Latas de refrigerante", "Plástico", "Cacos de espelho", "Vidros de perfume", "Revista", "Saco de combrsa"};
String[] correctButtons = {"verde", "azul", "amarelo", "azul", "amarelo", "amarelo", "verde", "verde", "azul", "azul"};
int currentWasteIndex = 0;
int lives = 5;
String message = "";
boolean gameOver = false;
void setup() {
  //size(600, 400);
  PFont poppins;
  poppins = createFont("Poppins-Bold.ttf", 128);
  fullScreen();
  background(255);
  textAlign(CENTER, CENTER);
  textSize(16);
  textFont(poppins);
  img= loadImage ("0.jpg");
  img1= loadImage ("1.png");
  h[0] = loadImage("h0.png");
  h[1] = loadImage("h1.png");
  h[2] = loadImage("h2.png");
  h[3] = loadImage("h3.png");
  bt= new Botoes();
  c= new Circ();

  myPort = new Serial(this, Serial.list()[0], 9600);
}

void draw() {
  switch(screen) {
    ///home
  case 0:
    background(255);
    imageMode(CENTER);
    image(img, width/2, height/2);
    img.resize(1920, 1080);
    image(img1, width/2, height-290);
    img1.resize(1574, 595);

    bt.desenha(width/2, height/2-185, 150, 50);
    fill(67);
    textAlign(CENTER, CENTER);
    textSize(70);
    text("Jogar!", width/2, height/2-202);

    textSize(30);
    bt.desenha(width / 2, height -90, 90, 30);
    fill(0);
    text("Sair", width / 2, height -97);

    c.desenha(50, 50, 30, 255);
    fill(67);
    textAlign(CENTER, CENTER);
    textSize(30);
    text("i", 50, 48);


    break;
  case 1:
    background(255);
    imageMode(CENTER);
    image(img, width/2, height/2);
    img.resize(1920, 1080);
    image(img1, width/2, height-290);
    img1.resize(1574, 595);

    textSize(30);
    bt.desenha(width/2, height/3+3, 400, 30);
    fill(0);
    text("Tipo de lixo: " + wasteTypes[currentWasteIndex], width/2, height/3);

    bt.desenha(width-170, 43, 160, 30);
    fill(0);
    text("Vidas restantes: " + lives, width - 170, 37);
    // text(message, width/2, 100);

    if (myPort.available() > 0) {
      String data = myPort.readStringUntil('\n');
      if (data != null) {
        data = data.trim();
        String[] buttonStates = data.split(",");
        if (buttonStates.length == 4) {
          int buttonBlue = Integer.parseInt(buttonStates[2]);
          int buttonYellow = Integer.parseInt(buttonStates[0]);
          int buttonGreen = Integer.parseInt(buttonStates[1]);

          if (buttonBlue == 1) {
            checkWasteType("azul");
            screen = 4;
          } else if (buttonYellow == 1) {
            checkWasteType("amarelo");
            screen = 4;
          } else if (buttonGreen == 1) {
            checkWasteType("verde");
            screen = 4;
          }
        }
      }
    }

    if (gameOver) {
      screen=2;
    }
    break;

  case 2:
    background(255);
    imageMode(CENTER);
    image(img, width/2, height/2);
    img.resize(1920, 1080);
    fill(255, 0, 0, 120);
    rectMode(CENTER);
    rect(width / 2, height / 2+5, 700, 80, 8);
    textSize(30);

    fill(255);
    text("Fim de jogo! Você perdeu todas as vidas.", width / 2, height / 2);

    bt.desenha(width / 2, height / 2+150, 90, 30);
    fill(0);
    text("Sair", width / 2, height / 2 +147);

    break;

  case 3:
    imageMode(CENTER);
    image(img, width/2, height/2);
    img.resize(1920, 1080);
    image(img1, width/2, height-190);
    img1.resize(1574, 595);

    imageMode(CENTER);
    image(h[imagemAtual], width/2, height/2);
    c.desenha(150, height-100, 30, 255);
    fill(67);
    textAlign(CENTER, CENTER);
    textSize(30);
    text("<", 150, height-106);
    c.desenha(width-150, height-100, 30, 255);
    fill(67);
    textAlign(CENTER, CENTER);
    textSize(30);
    text(">", width-150, height-106);

    c.desenha(50, 50, 30, 255);
    fill(67);
    textAlign(CENTER, CENTER);
    textSize(30);
    text("i", 50, 50);

    c.desenha(width-50, 50, 30, 255);
    fill(67);
    text("X", width-49, 47);
    break;

  case 4:
    background(255);
    image(img, width/2, height/2);
    img.resize(1920, 1080);
    textAlign(CENTER, CENTER);
    textSize(50);
    fill(0);
    text("Procurando...", width / 2, height / 2 - 50);

    if (message == "Correto! Próximo tipo de lixo.") {
      fill(0, 255, 0, 90);
      rectMode(CENTER);
      rect(width / 2, height / 2 + 100, 700, 80, 8);
      textSize(20);
      fill(255, 255, 255);
      text(message, width / 2, height / 2 + 100);
    } else if (message == "Errado! Você perdeu uma vida.") {
      fill(255, 0, 0, 90);
      rectMode(CENTER);
      rect(width / 2, height / 2 + 100, 700, 80, 8);
      textSize(20);
      fill(255, 255, 255);
      text(message, width / 2, height / 2 + 100);
    }

    if (myPort.available() > 0) {
      String data = myPort.readStringUntil('\n');
      if (data != null) {
        data = data.trim();
        String[] buttonStates = data.split(",");
        if (buttonStates.length == 4) {
          int joystickButton = Integer.parseInt(buttonStates[3]);

          if (joystickButton == 0) {
            screen = 1;
          }
        }
      }
    }

    break;
  }
}

void checkWasteType(String buttonColor) {
  if (buttonColor.equals(correctButtons[currentWasteIndex])) {
    fill(r);
    message = "Correto! Próximo tipo de lixo.";
    currentWasteIndex = (currentWasteIndex + 1) % wasteTypes.length;
  } else {
    lives--;
    fill(w);
    message = "Errado! Você perdeu uma vida.";
    if (lives <= 0) {
      gameOver = true;
      message = "Fim de jogo! Você perdeu todas as vidas.";
    } else {
      currentWasteIndex = (currentWasteIndex + 1) % wasteTypes.length;
    }
  }
}
void mousePressed() {

  if (screen==0) {
    if (bt.colide(width/2, height/2-185, 150, 50)==true)
      screen=4;
    if (c.colide(50, 50, 30, 255)==true)
      screen=3;
    if (bt.colide(width / 2, height -90, 90, 30)==true)
      exit();
  }
  if (screen==3) {
    if (c.colide(width-50, 50, 30, 255)==true)
      screen=0;

    if ( c.colide(150, height-100, 30, 255)==true) {
      imagemAtual = (imagemAtual - 1 + h.length) % h.length;
    }
    if ( c.colide(width-150, height-100, 30, 255)==true) {
      imagemAtual = (imagemAtual + 1) % h.length;
    }
  }
  if (screen==2) {
    if (bt.colide(width / 2, height / 2+150, 90, 30)==true)
      exit();
  }
}
void keyPressed() {
  if (key=='0')
    screen=0;

  if (key=='1')
    screen=1;

  if (key=='2')
    screen=2;

  if (key=='3')
    screen=3;

  if (key=='4')
    screen=4;
}
