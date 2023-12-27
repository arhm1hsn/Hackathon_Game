/*
 --------------------------
 **** Gravity Flux *****
 __________________________
 *  MADE BY: ARHAM.H AND RAYAN.R  *
 *  DATE: 2023-05-30     *
 *  COURSE CODE: ICS 3U1 *
 __________________________
 */

void setup() {
  size(1000, 750);
  loadImagesAndFonts();
  imageMode(CENTER);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
}

void loadImagesAndFonts() {
}

void resetVariables() {
}

int gameState = 0;
void draw() {
  if (gameState == 0) { //This gamestate draws the menu screen
    drawMenuScreen();
  } else if (gameState == 1) { //This gamestate shows the instructions screen
    drawInstructions();
  } else if (gameState == 2) { //This gamestate pauses the game (NOT USED)
    pauseGame();
  } else if (gameState == 3) { //This gamestate draws the game over screen
    gameOver();
  } else if (gameState == 4) { //This gamestate plays the actual game
    createGame();
  }
}

//This method creates the menu screen
void drawMenuScreen() {
  background(#77AEEB);
  drawBackground();

  drawMario(); //These mario methods are added to create the fun aesthetic of him running across the screen
  moveMario();
  moveMarioRight = true;
  if (marioPosition.x > 1100) {
    marioPosition.x = -100;
  }

  fill(#FFFFFF);
  image(Title, 500, 165, 475, 225);
  textSize(24);
  text("By Arham and Rayan", 500, 335);
  textSize(36);
  text("Press 'Space Bar' to Start", 500, 420);
  text("Press 'I' for Instructions", 500, 495);
}


//This method creates the instructions for user
void drawInstructions() {
  background(#77AEEB);
  image(Goomba, 350, 415, 65, 65);
  image(Thwomp, 500, 415, 146/2.7, 194/2.7);
  image(bulletBill, 650, 415, 820/12, 757/12);
  textSize(50);
  text("INSTRUCTIONS", 500, 75);
  textSize(35);
  text("Movement", 500, 150);
  textSize(25);
  text("W - Jump", 500, 225);
  text("A - Back", 500, 275);
  text("D - Forward", 500, 325);
  text("AVOID THESE ENEMIES AND TRY TO PASS THE LEVEL", 500, 510);
  text("Finish the game before the timer runs out", 500, 585);
  text("Collect the most coins", 500, 635);
  textSize(18);
  text("Press 'M' to Return to Menu", 500, 705);
}
