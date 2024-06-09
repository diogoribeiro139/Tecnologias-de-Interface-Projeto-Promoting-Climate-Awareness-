#include <Adafruit_NeoPixel.h>
#include <Adafruit_NeoMatrix.h>
#include <Adafruit_GFX.h>

#define PIN 7
#define WIDTH 16
#define HEIGHT 16


//as famosas bibliotecas
Adafruit_NeoMatrix matrix = Adafruit_NeoMatrix(WIDTH, HEIGHT, PIN, NEO_MATRIX_BOTTOM + NEO_MATRIX_LEFT + NEO_MATRIX_COLUMNS + NEO_MATRIX_ZIGZAG, NEO_RGB + NEO_KHZ800);

int joystickX = A0;  // Pino para o eixo X do joystick
int joystickY = A1;  // Pino para o eixo Y do joystick
// acrescentar a cablibração

// posição inicial da primeira LED
int currentX = 0;
int currentY = HEIGHT - 1;

//botão do joystick
const int joystickButtonPin = 2;
int buttonState;
int lastButtonState = LOW;
unsigned long lastDebounceTime = 0;
unsigned long debounceDelay = 50;

//três botões
const int buttonAzul = 4;
const int buttonAmarelo = 5;
const int buttonVerde = 6;
int buttonStateEco;
int lastButtonStateEco = HIGH;
long lastDebounceTimeEco = 0;
long debounceDelayEco = 50;

const int numLEDsRandom = 6;
int randomLEDs[numLEDsRandom][2];

bool joystickBloq = false;

void setup() {
  matrix.begin();
  matrix.setBrightness(3);

  //novo "for" para preencher a matriz com LEDs amarelas
  for (int x = 0; x < WIDTH; x++) {
    for (int y = 0; y < HEIGHT; y++) {
      matrix.drawPixel(x, y, matrix.Color(255, 255, 0));
    }
  }
  // a LED agora é azul
  matrix.drawPixel(currentX, currentY, matrix.Color(0, 0, 255));

  //randomizar posições de LEDs com lixo
  for (int i = 0; i < numLEDsRandom; i++) {
    randomLEDs[i][0] = random(WIDTH);
    randomLEDs[i][1] = random(HEIGHT);
    matrix.drawPixel(randomLEDs[i][0], randomLEDs[i][1], matrix.Color(255, 255, 0));  // Cor amarela
  }
  matrix.show();

  // Deixo aqui escrito que acho que devem haver melhores maneiras de implementar botões, mas testamos esta para já
  Serial.begin(9600);

  pinMode(joystickButtonPin, INPUT_PULLUP);
  pinMode(buttonAzul, INPUT_PULLUP);
  pinMode(buttonAmarelo, INPUT_PULLUP);
  pinMode(buttonVerde, INPUT_PULLUP);

  matrix.show();
}

void loop() {

  //joystick botão
  int reading = !digitalRead(joystickButtonPin);

  if (reading != lastButtonState) {
    lastDebounceTime = millis();
    //Serial.println("CLICK");
  }

  if ((millis() - lastDebounceTime) > debounceDelay) {
    buttonState = reading;
  }

if (reading != buttonState){
  buttonState = reading;
  if (buttonState == HIGH) {
    joystickBloq = true;
  } else {
    joystickBloq = false;
  }
}
  lastButtonState = reading;

  //botões Ecoponto
  int readingEco;
  readingEco = digitalRead(buttonAzul);
  readingEco = digitalRead(buttonAmarelo);
  readingEco = digitalRead(buttonVerde);

  if (readingEco != lastButtonStateEco) {
    lastDebounceTimeEco = millis();
  }

  if ((millis() - lastDebounceTimeEco) > debounceDelayEco) {
    buttonStateEco = readingEco;
  }

  lastButtonStateEco = readingEco;

  // Ler os buttons
  int buttonBlue = digitalRead(4);
  int buttonGreen = digitalRead(5);
  int buttonYellow = digitalRead(6);
  int joystickButtonPin = digitalRead(2);

  //envia o estado dos buttons para o Processing
  Serial.print(buttonYellow);
  Serial.print(",");
  Serial.print(buttonGreen);
  Serial.print(",");
  Serial.print(buttonBlue);
  Serial.print(",");
  Serial.println(joystickButtonPin);


  int xPosition = analogRead(joystickX);
  int yPosition = analogRead(joystickY);

  int previousX = currentX;
  int previousY = currentY;


  //saber se está em cima da LED randomizada
  bool emCimaLedRandom = false;

  for (int i = 0; i < numLEDsRandom; i++) {
    if (currentX == randomLEDs[i][0] && currentY == randomLEDs[i][1]) {
      emCimaLedRandom = true;
      //Serial.println("IIII");
      break;
    }
  }

  if (emCimaLedRandom == true) {
    // Piscar a LED azul
    if (joystickBloq == false) {
      for (int i = 0; i < 3; i++) {
        matrix.drawPixel(currentX, currentY, matrix.Color(0, 0, 255));
        matrix.show();
        delay(200);
        matrix.drawPixel(currentX, currentY, matrix.Color(0, 0, 0));  // Apagar
        matrix.show();
        delay(200);
      }
    } else {
      matrix.drawPixel(currentX, currentY, matrix.Color(0, 255, 0));
      matrix.show();
    }
    matrix.drawPixel(currentX, currentY, matrix.Color(0, 0, 255));  // Restaura a cor azul
  } else {
    // Acender a nova LED na cor azul
    matrix.drawPixel(currentX, currentY, matrix.Color(0, 0, 255));
    matrix.show();
  }

  //if (joystickBloq == true) {


  //return;

  if (joystickBloq == false) {
    // MATRIZ DE LUZES
    // joystick

    // Movimento para a direita
    if (xPosition > 600) {
      if (currentX < WIDTH - 1) {
        currentX++;
      }
    }
    // Movimento para a esquerda
    else if (xPosition < 400) {
      if (currentX > 0) {
        currentX--;
      }
    }

    // Movimento para cima
    if (yPosition > 600) {
      if (currentY > 0) {
        currentY--;
      }
    }
    // Movimento para baixo
    else if (yPosition < 400) {
      if (currentY < HEIGHT - 1) {
        currentY++;
      }
    }

    // LED out
    matrix.drawPixel(previousX, previousY, matrix.Color(255, 255, 0));
    // new LED
    matrix.drawPixel(currentX, currentY, matrix.Color(0, 0, 255));
  } else {
    //Serial.println("BLOQ");
    if (buttonStateEco == LOW) {
      joystickBloq = false;
      matrix.drawPixel(currentX, currentY, matrix.Color(0, 0, 255));
    }
  }
  // dar update na Matriz
  matrix.show();

  // pequena pausa pq tava demasiado rápido
  delay(250);
}
