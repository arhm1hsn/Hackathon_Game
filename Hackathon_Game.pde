/*
 --------------------------
 **** Gravity Flux *****
 __________________________
 *  MADE BY: Arham.H AND Hamza.W *
 *  DATE: 2023-12-27     *
 *  Halton Hackathon *
 __________________________
 */

//These variables are used to create images using PImage
PImage blackHole;
PImage finishLine;

//This variable creates is used to create fonts usign PFont
PFont gameFont;


int[] bottomGroundInitialX = {0, 600, 1000, 1600, 2450, 3000, 3700};
int[] bottomGroundXLength = {15, 5, 10, 15, 5, 10, 30};
int[] bottomGroundInitialY = {680, 680, 680, 680, 680, 680, 680};
int[] bottomGroundYLength = {3, 3, 3, 3, 3, 3, 3};

int[] topRoofInitialX = {200, 1300, 2100, 2600, 3350, 4100};
int[] topRoofXLength = {25, 15, 10, 12, 10, 20};
int[] topRoofInitialY = {0, 0, 0, 0, 0, 0, 0, 0};
int[] topRoofYLength = {3, 3, 3, 3, 3, 3, 3, 3};

//Vector's for player's position, velocity and acceleration
PVector playerPosition = new PVector(200, 630);
PVector playerVelocity = new PVector(0, 0);
PVector playerAcceleration = new PVector(0, 0);

int screenMovement = 0;
int playerSpeed = 8;
int attemptNumber = 1;
int direction = 0;

//These variables are used to create booleans switched for the player's movement, player winning, player's death screen, etc.
boolean movePlayerForward = false;
boolean switchPlayerGravity = false;
boolean playerTouchingGroundOrRoof = true;
boolean playerInMiddle = false;
boolean playerAlive = true;


void setup() {
  size(1000, 750);
  loadImagesAndFonts();
  imageMode(CENTER);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  textFont(gameFont, 32);
}

void loadImagesAndFonts() {
  playerPosition = new PVector(200, 630);
  playerVelocity = new PVector(0, 0);
  playerAcceleration = new PVector(0, 0);
  blackHole = loadImage("blackHole.png");
  finishLine = loadImage("finishLine.jpeg");

  gameFont = createFont("SuperMario256.ttf", 128);
}

void resetVariables() {
  screenMovement = 0;
  playerSpeed = 8;
  attemptNumber = 1;
  direction = 0;
  movePlayerForward = false;
  switchPlayerGravity = false;
  playerTouchingGroundOrRoof = true;
  playerInMiddle = false;
  playerAlive = true;
}

int gameState = 0;
void draw() {
  if (gameState == 0) { //This gamestate draws the menu screen
    drawMenuScreen();
  } else if (gameState == 1) { //This gamestate shows the instructions screen
    drawInstructions();
  } else if (gameState == 2) { //This gamestate pauses the game (NOT USED)
    //pauseGame();
  } else if (gameState == 3) { //This gamestate draws the game over screen
    gameOver();
  } else if (gameState == 4) { //This gamestate plays the actual game
    createGame();
  }
}

void background() {
  for (int i = 0; i < 800; i++) {
    strokeWeight(1);
    stroke(i/4, 2*i/6, 30+2*i/5);
    line(0, i, 1200, i);
  }
}

//This method creates the menu screen
void drawMenuScreen() {
  background();
  strokeWeight(0);
  fill(#FFFFFF);
  textSize(100);
  text("Gravity Flux", 500, 150);
  textSize(24);
  text("By Arham and Hamza", 500, 275);
  textSize(36);
  text("Press 'Space Bar' to Start", 500, 380);
  text("Press 'I' for Instructions", 500, 460);

  image(blackHole, 500, 605, 300, 180);
}


//This method creates the instructions for user
void drawInstructions() {
  background();
  strokeWeight(0);
  textSize(64);
  text("INSTRUCTIONS", 500, 75);
  textSize(35);
  text("Movement", 500, 175);
  textSize(25);
  text("W - Start Moving", 500, 250);
  text("Spacebar - Reverse Gravity", 500, 300);
  textSize(40);
  text("Reach the Finish Line!", 500, 395);
  text("Time Your Flux or Your Ball Will", 500, 470);
  text("Get Pulled Through the Platforms!", 500, 545);
  textSize(20);
  text("Press 'M' to Return to Menu", 500, 685);
}

void gameOver() {
  background(#000000);
  fill(#FFFFFF);
  textSize(50);
  text("You Win", 500, 275);
  text("You scored " + -screenMovement/5 + " points", 500, 425);
  textSize(18);
  text("Press 'M' to Return to Menu", 500, 705);
}

void createGame() {
  background(#100430);
  drawLevels();
  createPlayer();
  speedBall();
  detectDeathAndGameOver();
}

void drawLevels() {
  drawBackground();
  drawHUD();
}

void drawBackground() {
  fill(#AA77FF);
  for (int i = 0; i < bottomGroundInitialX.length; i++) {
    for (int j = 0; j < bottomGroundXLength[i]; j++) {
      for (int k = 0; k < bottomGroundYLength[i]; k++) {
        rect(40*j+bottomGroundInitialX[i]+screenMovement, 40*k+bottomGroundInitialY[i], 40, 40);
      }
    }
  }
  for (int i = 0; i < topRoofInitialX.length; i++) {
    for (int j = 0; j < topRoofXLength[i]; j++) {
      for (int k = 0; k < topRoofYLength[i]; k++) {
        rect(40*j+topRoofInitialX[i]+screenMovement, 40*k+topRoofInitialY[i], 40, 40);
      }
    }
  }
  image(finishLine, 4250+screenMovement, 400, 360, 360);
}

void drawHUD() {
  text("Attempt " + attemptNumber, 200+screenMovement, 300);
  text("Score: " + -screenMovement/5, 165, 400);
}

void createPlayer() {
  drawPlayer();
  movePlayer();
  checkPlayerHitEdgesAndWalls();
}

void drawPlayer() {
  fill(#FFFFFF);
  strokeWeight(0);
  ellipse(playerPosition.x, playerPosition.y, 30, 30);
}

void movePlayer() {
  if (movePlayerForward) {
    playerVelocity.x = playerSpeed;
  } else {
    playerVelocity.x = 0;
  }

  playerTouchingGroundOrRoof = checkPlayerHitRoof() || checkPlayerHitGround();
  if (playerTouchingGroundOrRoof) {
    playerAcceleration.y = 0;
  } else if (playerPosition.y < 250) {
    playerAcceleration.y = -0.5;
  } else if (playerPosition.y > 500) {
    playerAcceleration.y = 0.5;
  }

  if (switchPlayerGravity) {
    if (playerPosition.y > 375) {
      direction = 120;
    } else {
      direction = 630;
    }
    playerPosition.y = direction;
    switchPlayerGravity = false;
  }
  playerPosition = playerPosition.add(playerVelocity);
  playerVelocity = playerVelocity.add(playerAcceleration);
}

boolean checkPlayerHitGround() {
  // Check if Player is on a space that is not a ground (where there is a gap)
  for (int i = 0; i < bottomGroundInitialX.length; i++) {
    if (playerPosition.x >= bottomGroundInitialX[i]+screenMovement && playerPosition.x <= bottomGroundInitialX[i]+40*bottomGroundXLength[i]+screenMovement && playerPosition.y > 500) {
      return true;
    }
  }
  if (playerPosition.y > 750 || playerPosition.y < 0) {
    playerAlive = false;
  }
  return false;
}

boolean checkPlayerHitRoof() {
  // Check if Player is on a space that is not a roof (where there is a gap)
  for (int i = 0; i < topRoofInitialX.length; i++) {
    if (playerPosition.x >= topRoofInitialX[i]+screenMovement && playerPosition.x <= topRoofInitialX[i]+40*topRoofXLength[i]+screenMovement && playerPosition.y < 250) {
      return true;
    }
  }
  if (playerPosition.y > 750 || playerPosition.y < 0) {
    playerAlive = false;
  }
  return false;
}

void checkPlayerHitEdgesAndWalls() {
  if (playerPosition.x >= 500 && playerPosition.x - screenMovement <= 4290) {
    // Adjust position and screen movement if true
    playerPosition.x = 500;
    playerInMiddle = true;
    screenMovement = screenMovement - playerSpeed;
  } else {
    playerInMiddle = false;
  }
}

boolean speedIncrease = false;
void speedBall() {
  if (screenMovement > 1000 && screenMovement < 1050 || screenMovement > 2000 && screenMovement < 2050 || screenMovement > 3000 && screenMovement < 3015) {
    speedIncrease = true;
  }
  if (speedIncrease) {
    playerSpeed = playerSpeed + 5;
    speedIncrease = false;
  }
}

void detectDeathAndGameOver() {
  println(screenMovement);
  if (!playerAlive) {
    attemptNumber = attemptNumber + 1;
    playerAlive = true;
    resetLife();
  }
  if (screenMovement <= -3784) {
    gameState = 3;
  }
}

void resetLife() {
  playerPosition = new PVector(200, 630);
  playerVelocity = new PVector(0, 0);
  playerAcceleration = new PVector(0, 0);

  screenMovement = 0;
  playerSpeed = 8;

  movePlayerForward = false;
  switchPlayerGravity = false;
  playerTouchingGroundOrRoof = true;
  playerInMiddle = false;
  playerAlive = true;
}


void keyPressed() {
  //println(keyCode);
  if (gameState == 4) { //When the game is running
    if (keyCode == 87) {
      movePlayerForward = true;
    }
    if (keyCode == 32 && movePlayerForward && playerTouchingGroundOrRoof) { //If pressing spacebar and player is on the ground or a platform, switch gravity
      switchPlayerGravity = true;
    }
  }

  if (keyCode == 73 && gameState == 0) { //In the menu screen, if you press I, show the instructions
    gameState = 1;
  }
  if (keyCode == 77 && gameState == 1) { //In the instructions screen, if you press M, show the menu
    gameState = 0;
  }
  if (keyCode == 32 && gameState == 0) { //In the menu screen, if you press spacebar, start the game
    gameState = 4;
  }
  if (keyCode == 77 && gameState == 3) { //In the game over screen, if you press m, return to menu
    gameState = 0;
    resetVariables();
  }
}

void keyReleased() {
  if (gameState == 4) {
    if (keyCode == 87) {
      //movePlayerForward = false;
    }
  }
}
