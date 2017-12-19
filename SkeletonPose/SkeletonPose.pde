 
 //TODO: Timer com ajuda
 //Mudar o nome do muted para sound0
 //Always present: som, 

import KinectPV2.KJoint;
import KinectPV2.*;
import processing.sound.*;

KinectPV2 kinect;

SkeletonPoser poseArmsUp, poseArmsOpen;

class Object{
  float x, y, z;
  PImage image;
  String buttonType;
  boolean active;
  ArrayList<Integer> activeScreens;
 
  Object(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.activeScreens = new ArrayList<Integer>();
  }
  
  void setImage(PImage image) {
    this.image = image;
  }
  
  PImage getImage() {
    return this.image;
  }
  
  void setButtonType(String name) {
    this.buttonType = name;
  }
  
  String getButtonType() {
    return this.buttonType;
  }
  
  void setActive(boolean active) {
    this.active = active;
  }
  
  boolean getActive() {
    return this.active;
  }
  
  void setActiveScreens(int screen) {
    this.activeScreens.add(screen);
  }
  
  ArrayList<Integer> getActiveScreens() {
    return this.activeScreens;
  }
  
  void setCoordinates(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

PImage continue_button;
PImage continue_selected;
PImage start;
PImage start_selected;
PImage sound1;
PImage sound2;
PImage sound3;
PImage sound1_selected;
PImage sound2_selected;
PImage sound3_selected;
PImage sound0;
PImage sound0_selected;
PImage settings;
PImage settings_selected;
PImage exit;
PImage exit_selected;
PImage inventory;
PImage inventory_sel;
PImage dialog3;
SoundFile file;

ArrayList<Object> gameObjects;
ArrayList<Object> gameButtons;
ArrayList<Object> gameBackgrounds;
ArrayList<Object> gameCharacters;
ArrayList<Object> gameHelps;
ArrayList<Object> gameMissions;
ArrayList<Object> triggeredByObjects;

Object[] soundButtonState;


Object soundButton, settingsButton, exitButton, startButton, continueButton, capuchinho;

int selectedMargin = 10;
int sound_state = 0;

boolean rightHand_open = true; // true : Open, false: Closed
boolean leftHand_open = true;

int screen = 0; // This will allow us to change screens... Hopefully
int startScenarioTimer = 0;
int changeScreenAfter = 2500; // we can only change screen after 2.5 secs
int helpTimer = 5000; // set help timer for 10 secs
int startHelpTimer = 0;
int changeSoundAfter = 500;
int startSoundTimer = 0;
float image_anim = 100.0;

void setup() {
  
  image_anim= 100;
  
  println("Started setup");
  gameObjects = new ArrayList<Object>();
  gameBackgrounds = new ArrayList<Object>();
  soundButtonState = new Object[8];
  gameCharacters = new ArrayList<Object>();
  gameHelps = new ArrayList<Object>();
  gameButtons = new ArrayList<Object>();
  gameMissions = new ArrayList<Object>();
  triggeredByObjects = new ArrayList<Object>();

  //size(1920, 1080, P3D);
  fullScreen(P3D);

  kinect = new KinectPV2(this);

  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);

  kinect.init();


  // initialize the pose object
  poseArmsUp = new SkeletonPoser(kinect);
  poseArmsUp.addRule(KinectPV2.JointType_HandRight, PoseRule.ABOVE, KinectPV2.JointType_ElbowRight);
  poseArmsUp.addRule(KinectPV2.JointType_HandRight, PoseRule.LEFT_OF, KinectPV2.JointType_ElbowRight);
  poseArmsUp.addRule(KinectPV2.JointType_HandLeft, PoseRule.ABOVE, KinectPV2.JointType_ElbowLeft);
  poseArmsUp.addRule(KinectPV2.JointType_HandLeft, PoseRule.RIGHT_OF, KinectPV2.JointType_ElbowLeft);

  poseArmsOpen = new SkeletonPoser(kinect);
  poseArmsOpen.addRule(KinectPV2.JointType_HandRight, PoseRule.ABOVE, KinectPV2.JointType_ElbowRight);
  poseArmsOpen.addRule(KinectPV2.JointType_HandLeft, PoseRule.ABOVE, KinectPV2.JointType_ElbowLeft);
  poseArmsOpen.addRule(KinectPV2.JointType_HandRight, PoseRule.RIGHT_OF, KinectPV2.JointType_ElbowRight);
  poseArmsOpen.addRule(KinectPV2.JointType_HandLeft, PoseRule.LEFT_OF, KinectPV2.JointType_ElbowLeft);
  
  /**********************************************************************
  *
  * Screens: 
  *  0: Inicial
  *  1: Primeiro capuchinho
  *  ...
  *  6: Menu histórias
  *  7: Menu pausa?
  *
  ***********************************************************************/
  
  //Backgrounds loading here
  Object tempBackground = new Object(0, 0, 0);
  tempBackground.setImage(loadImage("cenario0.png"));
  tempBackground.setActive(true);
  tempBackground.setActiveScreens(0);
  gameBackgrounds.add(tempBackground);
  
  tempBackground = new Object(0, 0, 0);
  tempBackground.setImage(loadImage("cenario1.png"));
  tempBackground.setActive(false);
  tempBackground.setActiveScreens(1);
  gameBackgrounds.add(tempBackground);
  
  tempBackground = new Object(0, 0, 0);
  tempBackground.setImage(loadImage("cenario2.png"));
  tempBackground.setActive(false);
  tempBackground.setActiveScreens(2);
  gameBackgrounds.add(tempBackground);
  
  tempBackground = new Object(0, 0, 0);
  tempBackground.setImage(loadImage("cenario3.png"));
  tempBackground.setActive(false);
  tempBackground.setActiveScreens(3);
  gameBackgrounds.add(tempBackground);
  
  tempBackground = new Object(0, 0, 0);
  tempBackground.setImage(loadImage("cenario4.png"));
  tempBackground.setActive(false);
  tempBackground.setActiveScreens(4);
  gameBackgrounds.add(tempBackground);
  
  tempBackground = new Object(0, 0, 0);
  tempBackground.setImage(loadImage("cenario5.png"));
  tempBackground.setActive(false);
  tempBackground.setActiveScreens(5);
  gameBackgrounds.add(tempBackground);
  
  tempBackground = new Object(0, 0, 0);
  tempBackground.setImage(loadImage("Quarto.png"));
  tempBackground.setActive(false);
  tempBackground.setActiveScreens(6);
  gameBackgrounds.add(tempBackground);
  
  tempBackground = new Object(0, 0, 0);
  tempBackground.setImage(loadImage("Fim.png"));
  tempBackground.setActive(false);
  tempBackground.setActiveScreens(7);
  gameBackgrounds.add(tempBackground);
  
  /*tempBackground = new Object(0, 0, 0);
  tempBackground.setImage(loadImage("cenario7.png"));
  tempBackground.setActive(false);
  tempBackground.setActiveScreens(8);
  gameBackgrounds.add(tempBackground);*/
  
  //Inventory bar loading here
  inventory = loadImage("inventory.png");
  inventory_sel = loadImage("inventory_sel.png");
  
  
  //Set game characters
  Object tempCharacter = new Object(500, 500, 0);
  tempCharacter.setImage(loadImage("mae_sem_cesta.png"));
  tempCharacter.setActive(false);
  tempCharacter.setActiveScreens(1);
  gameCharacters.add(tempCharacter);
  
  
  tempCharacter = new Object(500, 500, 0);
  tempCharacter.setImage(loadImage("lobo.png"));
  tempCharacter.setActive(false);
  tempCharacter.setActiveScreens(2);
  gameCharacters.add(tempCharacter);
  
  
  //Set game objects here
  Object objectKey = new Object((width/2)+130, (height/4)-100, 0);
  objectKey.setImage(loadImage("chave.png"));
  objectKey.setActive(false);
  objectKey.setActiveScreens(4);
  objectKey.setActiveScreens(5);
  objectKey.setActiveScreens(6);
  objectKey.setButtonType("chave");
  gameObjects.add(objectKey);
  
  Object objectBasket = new Object(560, 700, 0);
  objectBasket.setImage(loadImage("cesta.png"));
  objectBasket.setActiveScreens(1);
  objectBasket.setActiveScreens(2);
  objectBasket.setActiveScreens(3);
  objectBasket.setActiveScreens(4);
  objectBasket.setActiveScreens(5);
  objectBasket.setActiveScreens(6);
  objectBasket.setActive(false);
  objectBasket.setButtonType("cesta");
  println(objectBasket.getActiveScreens().size());
  for (int sc : objectBasket.getActiveScreens()) {
    println(sc);
  }
  gameObjects.add(objectBasket);
  
  
  continue_button = loadImage("continue.png");
  continue_selected = loadImage("continue_selected.png");
  start = loadImage("start.png");
  start_selected = loadImage("start_selected.png");
  sound1 = loadImage("sound1.png");
  sound2 = loadImage("sound2.png");
  sound3 = loadImage("sound3.png");
  sound1_selected = loadImage("sound1_selected.png");
  sound2_selected = loadImage("sound2_selected.png");
  sound3_selected = loadImage("sound3_selected.png");
  sound0 = loadImage("sound0.png");
  sound0_selected = loadImage("sound0_selected.png");
  settings = loadImage("settings.png");
  settings_selected = loadImage("settings_selected.png");
  exit = loadImage("exit.png");
  exit_selected = loadImage("exit_selected.png");
  
  
  //Set game buttons here
  Object soundButtonTemp = new Object(350, 50, 0);
  soundButtonTemp.setImage(sound0);
  soundButtonTemp.setButtonType("sound");
  soundButtonState[0] = soundButtonTemp;
  
  soundButtonTemp = new Object(350, 50, 0);
  soundButtonTemp.setImage(sound0_selected);
  soundButtonTemp.setButtonType("sound");
  soundButtonState[1] = soundButtonTemp;
  
  soundButtonTemp = new Object(350, 50, 0);
  soundButtonTemp.setImage(sound1);
  soundButtonTemp.setButtonType("sound");
  soundButtonState[2] = soundButtonTemp;
  
  soundButtonTemp = new Object(350, 50, 0);
  soundButtonTemp.setImage(sound1_selected);
  soundButtonTemp.setButtonType("sound");
  soundButtonState[3] = soundButtonTemp;
  
  soundButtonTemp = new Object(350, 50, 0);
  soundButtonTemp.setImage(sound2);
  soundButtonTemp.setButtonType("sound");
  soundButtonState[4] = soundButtonTemp;
  
  soundButtonTemp = new Object(350, 50, 0);
  soundButtonTemp.setImage(sound2_selected);
  soundButtonTemp.setButtonType("sound");
  soundButtonState[5] = soundButtonTemp;
  
  soundButtonTemp = new Object(350, 50, 0);
  soundButtonTemp.setImage(sound3);
  soundButtonTemp.setButtonType("sound");
  soundButtonState[6] = soundButtonTemp;
  
  soundButtonTemp = new Object(350, 50, 0);
  soundButtonTemp.setImage(sound3_selected);
  soundButtonTemp.setButtonType("sound");
  soundButtonState[7] = soundButtonTemp;
  
  
  settingsButton = new Object(width-150, height - 150, 0);
  settingsButton.setImage(settings);
  settingsButton.setButtonType("settings");
  settingsButton.setActiveScreens(0);
  settingsButton.setActiveScreens(6);
  settingsButton.setActive(true);
 
  
  exitButton = new Object(50, height -150, 0);
  exitButton.setImage(exit);
  exitButton.setButtonType("exit");
  exitButton.setActiveScreens(0);
  exitButton.setActiveScreens(6);
  exitButton.setActive(true);
  
  continueButton = new Object(710, 350, 0);
  continueButton.setImage(continue_button);
  continueButton.setButtonType("continue");
  continueButton.setActive(true);
  continueButton.setActiveScreens(0);
 
  
  startButton = new Object(710, 590, 0);
  startButton.setImage(start);
  startButton.setButtonType("start");
  startButton.setActive(true);
  startButton.setActiveScreens(0);
  
  
  soundButton = new Object(350, 50, 0);
  soundButton.setImage(sound3);
  soundButton.setButtonType("sound");
  soundButton.setActive(true);
  soundButton.setActiveScreens(-1);
  
  Object pauseButton = new Object(exitButton.x, exitButton.y, 0);
  pauseButton.setImage(loadImage("b_pause.png"));
  pauseButton.setButtonType("pause");
  pauseButton.setActive(false);
  pauseButton.setActiveScreens(1);
  pauseButton.setActiveScreens(2);
  pauseButton.setActiveScreens(3);
  pauseButton.setActiveScreens(4);
  pauseButton.setActiveScreens(5);
  
  Object helpButton = new Object(settingsButton.x, settingsButton.y, 0);
  helpButton.setImage(loadImage("b_ajuda.png"));
  helpButton.setButtonType("help");
  helpButton.setActive(false);
  helpButton.setActiveScreens(1);
  helpButton.setActiveScreens(2);
  helpButton.setActiveScreens(3);
  helpButton.setActiveScreens(4);
  helpButton.setActiveScreens(5);
  
  
  
  gameButtons.add(soundButton);
  gameButtons.add(settingsButton);
  gameButtons.add(exitButton);
  gameButtons.add(continueButton);
  gameButtons.add(startButton);
  
  // Set game help
  Object helpPopUp = new Object(512, 950, 0);
  helpPopUp.setImage(loadImage("help1.png"));
  helpPopUp.setActiveScreens(0);
  helpPopUp.setActive(false);
  gameHelps.add(helpPopUp);
  
  helpPopUp = new Object(512, 950, 0);
  helpPopUp.setImage(loadImage("help2.png"));
  helpPopUp.setActiveScreens(1);
  helpPopUp.setActive(false);
  gameHelps.add(helpPopUp);
  
  helpPopUp = new Object(512, 950, 0);
  helpPopUp.setImage(loadImage("help3.png"));
  helpPopUp.setActiveScreens(2);
  helpPopUp.setActive(false);
  gameHelps.add(helpPopUp);
  
  Object missionPopUp = new Object(160, 930, 0);
  missionPopUp.setImage(loadImage("Missao1.png"));
  missionPopUp.setActiveScreens(1);
  missionPopUp.setActive(false);
  gameMissions.add(missionPopUp);
  
  missionPopUp = new Object(160, 930, 0);
  missionPopUp.setImage(loadImage("Missao2.png"));
  missionPopUp.setActiveScreens(2);
  missionPopUp.setActive(false);
  gameMissions.add(missionPopUp);
  
  missionPopUp = new Object(160, 930, 0);
  missionPopUp.setImage(loadImage("Missao3.png"));
  missionPopUp.setActiveScreens(3);
  missionPopUp.setActive(false);
  gameMissions.add(missionPopUp);
  
  missionPopUp = new Object(512, 950, 0);
  missionPopUp.setImage(loadImage("Missao4.png"));
  missionPopUp.setActiveScreens(4);
  missionPopUp.setActive(false);
  gameMissions.add(missionPopUp);
  
  missionPopUp = new Object(512, 950, 0);
  missionPopUp.setImage(loadImage("Missao5.png"));
  missionPopUp.setActiveScreens(5);
  missionPopUp.setActive(false);
  gameMissions.add(missionPopUp);
  
  missionPopUp = new Object(512, 950, 0);
  missionPopUp.setImage(loadImage("Missao6.png"));
  missionPopUp.setActiveScreens(6);
  missionPopUp.setActive(false);
  gameMissions.add(missionPopUp);
  
 Object inventoryBar = new Object(0, 0, 0);
 inventoryBar.setImage(inventory);
 inventoryBar.setActiveScreens(1);
 inventoryBar.setActiveScreens(2);
 inventoryBar.setActiveScreens(3);
 inventoryBar.setActiveScreens(4);
 inventoryBar.setActiveScreens(5);
 inventoryBar.setActiveScreens(6);
 inventoryBar.setActive(false);  
 inventoryBar.setButtonType("inventory");
  
  triggeredByObjects.add(inventoryBar);
  
  capuchinho = new Object(900, 524, 0);
  capuchinho.setImage(loadImage("capuchinho_costas.png"));
  capuchinho.setButtonType("capuchinho");
  capuchinho.setActiveScreens(2);
  capuchinho.setActiveScreens(3);
  capuchinho.setActive(false);
  image_anim = capuchinho.y;
  
  dialog3 = loadImage("help3.png");
  
  
  // Load a soundfile from the /data folder of the sketch and play it back
  file = new SoundFile(this, "sound.wav");
  file.play();
  file.loop();
  file.amp(0.0);
  println("Finished Setup");
}

void draw() {
  
  // Draw background
  background(0);
  
  for (Object gameBackground : gameBackgrounds) {
    if (gameBackground.getActive()) {
      image(gameBackground.getImage(), 0, 0);
    }
  }
  
  for (Object gameCharacter : gameCharacters) {
    if (gameCharacter.getActive()) {
      image(gameCharacter.getImage(), gameCharacter.x, gameCharacter.y);
    }
  }
  
  for (Object gameMission : gameMissions) {
    if (gameMission.getActive()) {
      image(gameMission.getImage(), gameMission.x, gameMission.y);
    }
  }
  
  for (Object gameHelp : gameHelps) {
    if (gameHelp.getActive()) {
      image(gameHelp.getImage(), gameHelp.x, gameHelp.y);
    }
  }
  
  for (Object gameObject : gameObjects) {
    if (gameObject.getActive()) {
      image(gameObject.getImage(), gameObject.x, gameObject.y);
    }
  }
  for (Object triggeredByObject: triggeredByObjects) {
    if (triggeredByObject.getActive()) {
      image(triggeredByObject.getImage(), triggeredByObject.x, triggeredByObject.y);
    }
  }
  
  if (capuchinho.getActive()) {
    image(capuchinho.getImage(), capuchinho.x, capuchinho.y);
  }
  
  
  
  
  
  
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();

  //individual JOINTS
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();

      //color col  = skeleton.getIndexColor();
      //fill(col);
      //stroke(col);
      // check to see if the user
      // is in the pose
      if (poseArmsUp.check(i)) {
        //if they are, set the color white
        strokeWeight(5);
        stroke(0, 255, 0);
      } else if (poseArmsOpen.check(i)) {
        strokeWeight(5);
        stroke(0, 0, 255);
      } else {
        strokeWeight(1);
        stroke(255);
      }

      drawBody(joints);

      //draw different color for each hand state
      drawHandState(joints[KinectPV2.JointType_HandRight]);
      drawHandState(joints[KinectPV2.JointType_HandLeft]);
      //println(joints[KinectPV2.JointType_HandRight].getPosition());
      for (int j = 0; j < gameObjects.size(); j++) {
        if (holdsObject(gameObjects.get(j), gameObjects.get(j).getImage(), joints[KinectPV2.JointType_HandRight]) && gameObjects.get(j).getActive()) {
          moveObject(gameObjects.get(j), gameObjects.get(j).getImage(), joints[KinectPV2.JointType_HandRight].getPosition());
          image(gameObjects.get(j).getImage(), gameObjects.get(j).x , gameObjects.get(j).y);
          
          for (int k = 0; k < triggeredByObjects.size(); k++) {
            if (triggeredByObjects.get(k).getButtonType().equals("inventory")) {
              if (isTriggered(gameObjects.get(j), triggeredByObjects.get(k))) {
                triggeredByObjects.get(k).setImage(inventory_sel);
              } else {
                triggeredByObjects.get(k).setImage(inventory);
              }
            }
          }
        }
        else if (holdsObject(gameObjects.get(j), gameObjects.get(j).getImage(), joints[KinectPV2.JointType_HandLeft]) && gameObjects.get(j).getActive()) {
          
          moveObject(gameObjects.get(j), gameObjects.get(j).getImage(), joints[KinectPV2.JointType_HandLeft].getPosition());
          image(gameObjects.get(j).getImage(), gameObjects.get(j).x , gameObjects.get(j).y);
          for (int k = 0; k < triggeredByObjects.size(); k++) {
            if (isTriggered(gameObjects.get(j), triggeredByObjects.get(k))) {
              if (triggeredByObjects.get(k).getButtonType().equals("inventory")) {
                triggeredByObjects.get(k).setImage(inventory_sel);
              } else {
                triggeredByObjects.get(k).setImage(inventory);
              }
            }
          }
          
        } else {
          if (gameObjects.get(j).getActive() && dropObject(gameObjects.get(j)))
            changeScreen(screen + 1 );
        }
      }
      for (int k = 0; k < gameButtons.size(); k++) {
        
        if (gameButtons.get(k).getActive())
          image(gameButtons.get(k).getImage(), gameButtons.get(k).x , gameButtons.get(k).y);
      

        // HERE WE HIGHLIGHT THE BUTTON WHEN SOMEONE HOVERS IT
        if (hoversObject(gameButtons.get(k), gameButtons.get(k).getImage() , joints[KinectPV2.JointType_HandRight]) && gameButtons.get(k).getActive()) { 
          if (gameButtons.get(k).getButtonType().equals("sound")) {
            Object gameButton = gameButtons.get(k);
            gameButton.setImage(soundButtonState[sound_state + 1].getImage());
            //gameButton.setCoordinates(soundButtonState[sound_state + 1].x, soundButtonState.get(sound_state + 1).y);
          }
          
          // If the button is the settings button
          else if (gameButtons.get(k).getButtonType().equals("settings")){
            Object gameButton = gameButtons.get(k);
            gameButton.setImage(settings_selected);
            //gameButton.setCoordinates(settingsButtonState.get(1).x, settingsButtonState.get(1).y);
          }
          // If the button is the continue button
          else if (gameButtons.get(k).getButtonType().equals("continue")){
            Object gameButton = gameButtons.get(k);
            gameButton.setImage(continue_selected);
            //gameButton.setCoordinates(continueButtonState.get(1).x, continueButtonState.get(1).y);
          }
          // If the button is the exit button
          else if (gameButtons.get(k).getButtonType().equals("exit")){
            Object gameButton = gameButtons.get(k);
            gameButton.setImage(exit_selected);
            //gameButton.setCoordinates(exitButtonState.get(1).x, exitButtonState.get(1).y);
          }
           // If the button is the start button
          else if (gameButtons.get(k).getButtonType().equals("start")){
            Object gameButton = gameButtons.get(k);
            gameButton.setImage(start_selected);
            //gameButton.setCoordinates(startButtonState.get(1).x, startButtonState.get(1).y);
          }
          
          rightHand_open = true;
        }
        
        // HERE WE DECIDE WHAT TO DO WHEN SOMEONE SELECTS IT
        else if (holdsObject(gameButtons.get(k), gameButtons.get(k).getImage(), joints[KinectPV2.JointType_HandRight]) && (rightHand_open == true) && gameButtons.get(k).getActive()) { 
          rightHand_open = false;
          // If the button is the sound button
          if (gameButtons.get(k).getButtonType().equals("sound")) {
            if (startSoundTimer == 0) {
              startSoundTimer = millis();
              sound_state += 2;
              if (sound_state >= 8) {
                sound_state = 0;
              }
              // We change the button image
              file.amp(0.125 * sound_state);
              Object gameButton = gameButtons.get(k);
              gameButton.setImage(soundButtonState[sound_state].getImage());
              //gameButton.setCoordinates(soundButtonState.get(sound_state).x, soundButtonState.get(sound_state).y);
            }
            else if (startSoundTimer + changeSoundAfter <= millis()) {
              startSoundTimer = millis();
              sound_state += 2;
              if (sound_state >= 8) {
                sound_state = 0;
              }
              file.amp(0.125 * sound_state);
              // We change the button image
              Object gameButton = gameButtons.get(k);
              gameButton.setImage(soundButtonState[sound_state].getImage());
            }
          }
          
          // If the button is the settings button
          else if (gameButtons.get(k).getButtonType().equals("settings")){
            // Do whatever here....
          }
          // If the button is the continue button
          else if (gameButtons.get(k).getButtonType().equals("continue")){
            changeScreen(6);      
          }
          // If the button is the exit button
          else if (gameButtons.get(k).getButtonType().equals("exit")){
            // Exit the game
            exit();
          }
           // If the button is the start button
          else if (gameButtons.get(k).getButtonType().equals("start")){
            changeScreen(screen + 1); 
          }
        }
        
        // HERE WE HIGHLIGHT THE BUTTON WHEN SOMEONE HOVERS IT
        if (hoversObject(gameButtons.get(k), gameButtons.get(k).getImage() , joints[KinectPV2.JointType_HandLeft]) && gameButtons.get(k).getActive()) { 
          if (gameButtons.get(k).getButtonType().equals("sound")) {
            Object gameButton = gameButtons.get(k);
            gameButton.setImage(soundButtonState[sound_state + 1].getImage());
            //gameButton.setCoordinates(soundButtonState.get(sound_state + 1).x, soundButtonState.get(sound_state + 1).y);
          }
          
          // If the button is the settings button
          else if (gameButtons.get(k).getButtonType().equals("settings")){
            Object gameButton = gameButtons.get(k);
            gameButton.setImage(settings_selected);
            //gameButton.setCoordinates(settingsButtonState.get(1).x, settingsButtonState.get(1).y);
          }
          // If the button is the continue button
          else if (gameButtons.get(k).getButtonType().equals("continue")){
            Object gameButton = gameButtons.get(k);
            gameButton.setImage(continue_selected);
            //gameButton.setCoordinates(continueButtonState.get(1).x, continueButtonState.get(1).y);
            println("Faz hover com mao esquerda no continue");
            println(gameButtons.get(k).getImage());
          }
          // If the button is the exit button
          else if (gameButtons.get(k).getButtonType().equals("exit")){
            Object gameButton = gameButtons.get(k);
            gameButton.setImage(exit_selected);
            //gameButton.setCoordinates(exitButtonState.get(1).x, exitButtonState.get(1).y);
          }
           // If the button is the start button
          else if (gameButtons.get(k).getButtonType().equals("start")){
            Object gameButton = gameButtons.get(k);
            gameButton.setImage(start_selected);
            //gameButton.setCoordinates(startButtonState.get(1).x, startButtonState.get(1).y);
          }
          
          leftHand_open = true;
        }
        
        // HERE WE DECIDE WHAT TO DO WHEN SOMEONE SELECTS IT
        else if (holdsObject(gameButtons.get(k), gameButtons.get(k).getImage(), joints[KinectPV2.JointType_HandLeft]) && (leftHand_open == true) && gameButtons.get(k).getActive()) { 
          leftHand_open = false;
          // If the button is the sound button
          if (gameButtons.get(k).getButtonType().equals("sound")) {
            if (startSoundTimer == 0) {
              startSoundTimer = millis();
              sound_state += 2;
              if (sound_state >= 8) {
                sound_state = 0;
              }
              file.amp(0.125 * sound_state);
              // We change the button image
              Object gameButton = gameButtons.get(k);
              gameButton.setImage(soundButtonState[sound_state].getImage());
              //gameButton.setCoordinates(soundButtonState.get(sound_state).x, soundButtonState.get(sound_state).y);
            }
            else if (startSoundTimer + changeSoundAfter <= millis()) {
              startSoundTimer = millis();
              sound_state += 2;
              if (sound_state >= 8) {
                sound_state = 0;
              }
              file.amp(0.125 * sound_state);
              // We change the button image
              Object gameButton = gameButtons.get(k);
              gameButton.setImage(soundButtonState[sound_state].getImage());
            }
          }
          
          // If the button is the settings button
          else if (gameButtons.get(k).getButtonType().equals("settings")){
            // Do whatever here....
          }
          // If the button is the continue button
          else if (gameButtons.get(k).getButtonType().equals("continue")){
            changeScreen(6);
            
          }
          // If the button is the exit button
          else if (gameButtons.get(k).getButtonType().equals("exit")){
            // Exit the game
            exit();
          }
           // If the button is the start button
          else if (gameButtons.get(k).getButtonType().equals("start")){
            changeScreen(screen + 1); 
          }
        }
        
        //Return them to 'normal' state
        else if (gameButtons.get(k).getActive()){
          if (gameButtons.get(k).getButtonType().equals("sound")) {
            Object gameButton = gameButtons.get(k);
            gameButton.setImage(soundButtonState[sound_state].getImage());
            //gameButton.setCoordinates(soundButtonState.get(sound_state).x, soundButtonState.get(sound_state).y);
          }
          
          // If the button is the settings button
          else if (gameButtons.get(k).getButtonType().equals("settings")){
            Object gameButton = gameButtons.get(k);
            gameButton.setImage(settings);
            //gameButton.setCoordinates(settingsButtonState.get(0).x, settingsButtonState.get(0).y);
          }
          // If the button is the continue button
          else if (gameButtons.get(k).getButtonType().equals("continue")){
            Object gameButton = gameButtons.get(k);
            gameButton.setImage(continue_button);
            //gameButton.setCoordinates(continueButtonState.get(0).x, continueButtonState.get(0).y);

          }
          // If the button is the exit button
          else if (gameButtons.get(k).getButtonType().equals("exit")){
            Object gameButton = gameButtons.get(k);
            gameButton.setImage(exit);
            //gameButton.setCoordinates(exitButtonState.get(0).x, exitButtonState.get(0).y);
          }
           // If the button is the start button
          else if (gameButtons.get(k).getButtonType().equals("start")){
            Object gameButton = gameButtons.get(k);
            gameButton.setImage(start);
            //gameButton.setCoordinates(startButtonState.get(0).x, startButtonState.get(0).y);
          }
          
          rightHand_open = true;
          leftHand_open = true;
        }
      }
      if (moveOn(joints[KinectPV2.JointType_HandRight], joints[KinectPV2.JointType_HandLeft])) {
        if (screen == 2) {
          PImage backup = capuchinho.getImage();
          int w_b = capuchinho.getImage().width;
          int h_b = capuchinho.getImage().height;
          float w = capuchinho.getImage().width;
          w -= 1;
          if( w > 50) {
            capuchinho.image.resize(capuchinho.getImage().width -1, 0);
          }
          image_anim -= 1;
          capuchinho.setActive(true);
          capuchinho.y = image_anim;
          
          image(capuchinho.getImage(), capuchinho.x, capuchinho.y);
          if (capuchinho.y <= 450) {
            capuchinho.setActive(false);
            capuchinho.setImage(backup);
            capuchinho.image.resize(w_b, h_b);
            changeScreen(3);
            image_anim = 525;
          }
        }
         else if (screen == 3) {
          PImage backup = capuchinho.getImage();
          int w_b = capuchinho.getImage().width;
          int h_b = capuchinho.getImage().height;
          float w = capuchinho.getImage().width;
          w -= 1;
          if( w > 50) {
            capuchinho.image.resize(capuchinho.getImage().width -1, 0);
          }
          image_anim -= 1;
          capuchinho.setActive(true);
          capuchinho.y = image_anim;
          image(capuchinho.getImage(), capuchinho.x, capuchinho.y);
          if (capuchinho.y <= 450) {
            capuchinho.setActive(false);
            capuchinho.setImage(backup);
            capuchinho.image.resize(w_b, h_b);
            changeScreen(5);
            image_anim = 800;
          }
       }
      }
    }
    showHelp();
  }

  fill(255, 0, 0);
  text(frameRate, 50, 50);
}

//DRAW BODY
void drawBody(KJoint[] joints) {
  drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
  drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid);
  drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft);

  // Right Arm
  drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
  drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight);
  drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight);

  // Left Arm
  drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft);
  drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft);
  drawBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft);

  // Right Leg
  drawBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight);
  drawBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight);
  drawBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight);

  // Left Leg
  drawBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft);
  drawBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft);
  drawBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft);

  drawJoint(joints, KinectPV2.JointType_HandTipLeft);
  drawJoint(joints, KinectPV2.JointType_HandTipRight);
  drawJoint(joints, KinectPV2.JointType_FootLeft);
  drawJoint(joints, KinectPV2.JointType_FootRight);

  drawJoint(joints, KinectPV2.JointType_ThumbLeft);
  drawJoint(joints, KinectPV2.JointType_ThumbRight);

  drawJoint(joints, KinectPV2.JointType_Head);
}

//draw joint
void drawJoint(KJoint[] joints, int jointType) {
  pushMatrix();
  translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
}

//draw bone
void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  pushMatrix();
  translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
  line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());


}

//draw hand state
void drawHandState(KJoint joint) {
  noStroke();
  handState(joint.getState());
  pushMatrix();
  translate(joint.getX(), joint.getY(), joint.getZ());
  ellipse(0, 0, 70, 70);
  popMatrix();
}

void drawBall(Object object, PImage image){
  pushMatrix();
  translate(object.x, object.y, object.z);
  ellipse(0,0,10,10);
  popMatrix();
  pushMatrix();
  translate(object.x + image.width, object.y + image.height, object.z);
  ellipse(0,0,10,10);
  popMatrix();
}

/*
Different hand state
 KinectPV2.HandState_Open
 KinectPV2.HandState_Closed
 KinectPV2.HandState_Lasso
 KinectPV2.HandState_NotTracked
 */
void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    fill(0, 255, 0);
    break;
  case KinectPV2.HandState_Closed:
    fill(255, 0, 0);
    break;
  case KinectPV2.HandState_Lasso:
    fill(0, 0, 255);
    break;
  case KinectPV2.HandState_NotTracked:
    fill(255, 255, 255);
    break;
  }
}

boolean holdsObject(Object object, PImage image, KJoint joint) {
  PVector vector = joint.getPosition();
  if (joint.getState() != KinectPV2.HandState_Closed) {
    return false;
  }
  if ((vector.x <= object.x + image.width ) && (vector.x >= object.x )) {
     if ((vector.y <= object.y + image.height ) && (vector.y >= object.y)) {
       return true;
     }
  }
  return false;
}

boolean hoversObject(Object object, PImage image, KJoint joint) {
  PVector vector = joint.getPosition();
  if (joint.getState() != KinectPV2.HandState_Open) {
    return false;
  }
  if ((vector.x <= object.x + image.width ) && (vector.x >= object.x )) {
     if ((vector.y <= object.y + image.height ) && (vector.y >= object.y)) {
       return true;
     }
  }
  return false;
}

void moveObject(Object object, PImage image, PVector vector) {
  object.setCoordinates((vector.x - image.width/2), (vector.y - image.height/2));
}

void setActiveScreen() {
  manageActiveObjects(gameObjects);
  manageActiveObjects(gameBackgrounds);
  manageActiveObjects(gameButtons);
  manageActiveObjects(gameCharacters);
  manageActiveObjects(gameMissions);
  manageActiveObjects(triggeredByObjects);
}

void manageActiveObjects(ArrayList<Object> objects) {
  print("Chamou manageActiveObjects com screen: ");
  println(screen);
  for (int i = 0; i < objects.size(); i++) {

    for (int activeScreen : objects.get(i).getActiveScreens())
    {
      if (screen == activeScreen || activeScreen == -1) {
        objects.get(i).setActive(true);
        break;
      } else {
        objects.get(i).setActive(false);
      }
    }
  }
  
}

void changeScreen(int new_screen) {
  if (screen == 1 || screen == 4 || screen == 5 || screen == 6)
  {
    if (startScenarioTimer + (changeScreenAfter/2) <= millis()) {
      startScenarioTimer = millis();
      screen = new_screen;
      for (int i = 0; i < gameHelps.size(); i++) {
        gameHelps.get(i).setActive(false);
      }
      if (screen > 7) {
        screen = 0;
      }
    }
    setActiveScreen();
  }
  if (startScenarioTimer == 0) {
    startScenarioTimer = millis();
    screen = new_screen;
    for (int i = 0; i < gameHelps.size(); i++) {
      gameHelps.get(i).setActive(false);
    }
    if (screen > 7) {
      screen = 0;
    }
    setActiveScreen();
  } else {
    if (startScenarioTimer + changeScreenAfter <= millis()) {
      startScenarioTimer = millis();
      screen = new_screen;
      for (int i = 0; i < gameHelps.size(); i++) {
        gameHelps.get(i).setActive(false);
      }
      if (screen > 7) {
        screen = 0;
      }
    }
    setActiveScreen();
  }
  
};

void showHelp() {
  if (startScenarioTimer + helpTimer <= millis()) {
    startHelpTimer = millis();
    for (int i = 0; i < gameHelps.size(); i++) {
      ArrayList<Integer> activeScreens = gameHelps.get(i).getActiveScreens();
      for (Integer activeScreen : activeScreens) {
        if (screen == activeScreen) {
          gameHelps.get(i).setActive(true);
          for (Object gameMission : gameMissions) {
            if (gameMission.getActive()) {
              gameMission.setActive(false);
            }
          }
        }
      }
    }
  }
}

boolean dropObject(Object object) {
  if (object.getActive() == false)
    return false;
    
  if (object.getButtonType().equals("cesta") && screen == 1){
    if (object.y < (soundButton.y + soundButton.getImage().height)) {
      object.x = 1600;
      object.y = 30;
      println("Dropou a cesta");
      return true;
    }
  }else if (object.getButtonType().equals("cesta") && (screen == 2)){
    object.x = 1600;
    object.y = 30;
  } else if (object.getButtonType().equals("cesta") && (screen == 3)){
    object.x = 1600;
    object.y = 30;
  } else if (object.getButtonType().equals("cesta") && (screen == 4)){
    object.x = 1600;
    object.y = 30;
  } else if (object.getButtonType().equals("cesta") && (screen == 5)){
    object.x = 1600;
    object.y = 30;
  } else if (object.getButtonType().equals("cesta") && (screen == 6)){
    if ((object.y < 700 ) && (object.y > 550)) {
      if ((object.x > 550) && (object.x < 750))
      {
        object.x = 560;
        object.y = 700;
        return true;
      } 
    }
  }
  
  if (object.getButtonType().equals("chave") && (screen == 4)){
    if (object.y < (soundButton.y + soundButton.getImage().height)) {
        object.x = (1600 - 300);
        object.y = 30;
        return true;
      }
  } else if (object.getButtonType().equals("chave") && (screen == 5)){
    if ((object.y < 880 ) && (object.y > 600)) {
      if ((object.x > 1000) && (object.x < 1400))
      {
        object.x = 560;
        object.y = 700;
        return true;
      } 
    }
  }
  
  return false;
}

boolean moveOn(KJoint right, KJoint left) {
  if ((screen == 2)|| (screen == 3)) {
    PVector rhand = right.getPosition();
    PVector lhand = left.getPosition();
    if (rhand.y  - lhand.y <= 50 ) {
      if (rhand.x - lhand.x <= 50) {
        return true;
      }
    }
    
  }
    
  return false;
}

boolean isTriggered(Object object, Object toTrigger) {
  if (!object.getActive() || !toTrigger.getActive()){
    return false;
  }
  if ((object.y <= (toTrigger.y + toTrigger.getImage().height)) && (object.y >= toTrigger.y)){
    if ((object.x <= (toTrigger.x + toTrigger.getImage().width)) && (object.x >= toTrigger.x)) {
      return true;
    }
  }
  return false;
  
}