
/*
https://msdn.microsoft.com/en-us/library/microsoft.kinect.jointtype.aspx

 KinectPV2.JointType_Head
 KinectPV2.JointType_Neck
 KinectPV2.JointType_SpineShoulder
 KinectPV2.JointType_SpineMid
 KinectPV2.JointType_SpineBase

 // Right Arm
 KinectPV2.JointType_ShoulderRight
 KinectPV2.JointType_ElbowRight
 KinectPV2.JointType_WristRight
 KinectPV2.JointType_HandRight
 KinectPV2.JointType_ThumbRight
 KinectPV2.JointType_HandTipRight

 // Right Leg
 KinectPV2.JointType_HipRight
 KinectPV2.JointType_KneeRight
 KinectPV2.JointType_AnkleRight
 KinectPV2.JointType_FootRight

 */
 
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
  int[] activeScreens;
 
  Object(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
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
    this.activeScreens = append(this.activeScreens, screen);
  }
  int[] getActiveScreens() {
    return this.activeScreens;
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
SoundFile file;

Object[] gameObjects;
Object[] gameButtons;
Object[] gameBackgrounds;
Object[] soundButtonState;
Object[] continueButtonState;
Object[] exitButtonState;
Object[] settingsButtonState;
Object[] startButtonState;
Object[] gameCharacters;

Object soundButton, settingsButton, exitButton, startButton, continueButton;

int selectedMargin = 10;
int sound_state = 0;
int other_state = 0;

boolean rightHand_open = true; // true : Open, false: Closed
boolean leftHand_open = true;

int screen = 0; // This will allow us to change screens... Hopefully

void setup() {
  
  println("Started setup");
  gameObjects = new Object[1]; // Set to the number of objects present in this project (First screen)
  gameButtons = new Object[5]; // Set to the number of buttons present in this project (First screen)
  soundButtonState = new Object[8]; // Set to the number of possible states for this button
  settingsButtonState = new Object[2]; // Set to the number of possible states for this button
  exitButtonState = new Object[2]; // Set to the number of possible states for this button
  startButtonState = new Object[2]; // Set to the number of possible states for this button
  continueButtonState = new Object[2]; // Set to the number of possible states for this button
  gameBackgrounds = new Object[6]; //Set the number of backgrounds
  
  int j = 0;
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
  
  //Backgrounds loading here
  Object tempBackground = new Object(0, 0, 0);
  tempBackground.setImage(loadImage("cenario0.png"));
  tempBackground.setActive(true);
  tempBackground.setActiveScreens(0);
  gameBackgrounds = (Object[]) append(gameBackgrounds, tempBackground);
  
  tempBackground = new Object(0, 0, 0);
  tempBackground.setImage(loadImage("cenario1.png"));
  tempBackground.setActive(false);
  tempBackground.setActiveScreens(1);
  gameBackgrounds = (Object[]) append(gameBackgrounds, tempBackground);
  
  tempBackground = new Object(0, 0, 0);
  tempBackground.setImage(loadImage("cenario2.png"));
  tempBackground.setActive(false);
  tempBackground.setActiveScreens(2);
  gameBackgrounds = (Object[]) append(gameBackgrounds, tempBackground);
  
  tempBackground = new Object(0, 0, 0);
  tempBackground.setImage(loadImage("cenario3.png"));
  tempBackground.setActive(false);
  tempBackground.setActiveScreens(3);
  gameBackgrounds = (Object[]) append(gameBackgrounds, tempBackground);
  
  tempBackground = new Object(0, 0, 0);
  tempBackground.setImage(loadImage("cenario4.png"));
  tempBackground.setActive(false);
  tempBackground.setActiveScreens(4);
  gameBackgrounds = (Object[]) append(gameBackgrounds, tempBackground);
  
  tempBackground = new Object(0, 0, 0);
  tempBackground.setImage(loadImage("cenario5.png"));
  tempBackground.setActive(false);
  tempBackground.setActiveScreens(5);
  gameBackgrounds = (Object[]) append(gameBackgrounds, tempBackground);
  
  
  //Set game characters
  Object tempCharacter = new Object(500, 500, 0);
  tempCharacter.setImage(loadImage("mae.png"));
  tempCharacter.setActive(false);
  tempCharacter.setActiveScreens(1);
  gameCharacters = (Object[]) append(gameCharacters, tempCharacter);
  
  
  tempCharacter = new Object(500, 500, 0);
  tempCharacter.setImage(loadImage("lobo.png"));
  tempCharacter.setActive(false);
  tempCharacter.setActiveScreens(2);
  gameCharacters = (Object[]) append(gameCharacters, tempCharacter);
  
  
  //Set game objects here
  Object objectKey = new Object((width/2)+130, (height/4)-100, 0);
  objectKey.setImage(loadImage("chave.png"));
  objectKey.setActive(false);
  objectKey.setActiveScreens(4);
  objectKey.setActiveScreens(5);
  gameObjects = (Object[]) append(gameObjects, objectKey);
  
  
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
  Object soundButtonTemp = new Object(50, 50, 0);
  soundButtonTemp.setImage(sound0);
  soundButtonTemp.setButtonType("sound");
  soundButtonState = (Object[]) append(soundButtonState, soundButtonTemp);
  
  soundButtonTemp = new Object(50, 50, 0);
  soundButtonTemp.setImage(sound0_selected);
  soundButtonTemp.setButtonType("sound");
  soundButtonState = (Object[]) append(soundButtonState, soundButtonTemp);
  
  soundButtonTemp = new Object(50, 50, 0);
  soundButtonTemp.setImage(sound1);
  soundButtonTemp.setButtonType("sound");
  soundButtonState = (Object[]) append(soundButtonState, soundButtonTemp);
  
  soundButtonTemp = new Object(50, 50, 0);
  soundButtonTemp.setImage(sound1_selected);
  soundButtonTemp.setButtonType("sound");
  soundButtonState = (Object[]) append(soundButtonState, soundButtonTemp);
  
  soundButtonTemp = new Object(50, 50, 0);
  soundButtonTemp.setImage(sound2);
  soundButtonTemp.setButtonType("sound");
  soundButtonState = (Object[]) append(soundButtonState, soundButtonTemp);
  
  soundButtonTemp = new Object(50, 50, 0);
  soundButtonTemp.setImage(sound2_selected);
  soundButtonTemp.setButtonType("sound");
  soundButtonState = (Object[]) append(soundButtonState, soundButtonTemp);
  
  soundButtonTemp = new Object(50, 50, 0);
  soundButtonTemp.setImage(sound3);
  soundButtonTemp.setButtonType("sound");
  soundButtonState = (Object[]) append(soundButtonState, soundButtonTemp);
  
  soundButtonTemp = new Object(50, 50, 0);
  soundButtonTemp.setImage(sound3_selected);
  soundButtonTemp.setButtonType("sound");
  soundButtonState = (Object[]) append(soundButtonState, soundButtonTemp);
  
  
  settingsButton = new Object(width-150, height - 150, 0);
  settingsButton.setImage(settings);
  settingsButton.setButtonType("settings");
  settingsButtonState[0] = settingsButton;
  
  Object settingsButtonTemp = new Object(width-150, height - 150, 0);
  settingsButtonTemp.setImage(settings_selected);
  settingsButtonTemp.setButtonType("settings");
  settingsButtonState[1] = settingsButtonTemp;
  
  
  exitButton = new Object(50, height -150, 0);
  exitButton.setImage(exit);
  exitButton.setButtonType("exit");
  exitButtonState[0] = exitButton;
  
  Object exitButtonTemp = new Object(50, height -150, 0);
  exitButtonTemp.setImage(exit_selected);
  exitButtonTemp.setButtonType("exit");
  exitButtonState[1] = exitButtonTemp;
  
  
  continueButton = new Object(710, 350, 0);
  continueButton.setImage(continue_button);
  continueButton.setButtonType("continue");
  continueButtonState[0] = continueButton;
  
  Object continueButtonTemp = new Object(710, 350, 0);
  continueButtonTemp.setImage(continue_selected);
  continueButtonTemp.setButtonType("continue");
  continueButtonState[1] = continueButtonTemp;
  
  
  startButton = new Object(710, 590, 0);
  startButton.setImage(start);
  startButton.setButtonType("start");
  startButtonState[0] = startButton;
  
  Object startButtonTemp = new Object(710, 590, 0);
  startButtonTemp.setImage(start_selected);
  startButtonTemp.setButtonType("start");
  startButtonState[1] = startButtonTemp;
  
  
  gameButtons[j] = soundButton;
  j++;
  gameButtons[j] = settingsButton;
  j++;
  gameButtons[j] = exitButton;
  j++;
  gameButtons[j] = continueButton;
  j++;
  gameButtons[j] = startButton;
  
  // Load a soundfile from the /data folder of the sketch and play it back
  file = new SoundFile(this, "sound.wav");
  file.play();
  file.loop();
  println("Finished Setup");
}

void draw() {
  
  // Draw background
  background(0);
  
  for(int i = 0; i < gameBackgrounds.length; i++) {
    if (gameBackgrounds[i].getActive()){
      image(gameBackgrounds[i].getImage(), 0, 0);
    }
  }
  
  for (int i = 0; i < gameObjects.length; i++) {
    if (gameObjects[i].getActive()){
      image(gameObjects[i].getImage(), gameObjects[i].x, gameObjects[i].y);
    }
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
      for (int j = 0; j < gameObjects.length; j++) {
        
        image(gameObjects[j].image, gameObjects[j].x , gameObjects[j].y );
        
        if (holdsObject(gameObjects[j], gameObjects[j].image, joints[KinectPV2.JointType_HandRight])) {
          println("Mao direita na bola");
          moveObject(gameObjects[j], gameObjects[j].image, joints[KinectPV2.JointType_HandRight].getPosition());
          image(gameObjects[j].image, gameObjects[j].x , gameObjects[j].y);
        }
        if (holdsObject(gameObjects[j], gameObjects[j].image, joints[KinectPV2.JointType_HandLeft])) {
          println("Mao esquerda na bola");
          moveObject(gameObjects[j], gameObjects[j].image, joints[KinectPV2.JointType_HandLeft].getPosition());
          image(gameObjects[j].image, gameObjects[j].x , gameObjects[j].y);
        }
      }
      for (int k = 0; k < gameButtons.length; k++) {
        image(gameButtons[k].image, gameButtons[k].x, gameButtons[k].y);
        // HERE WE HIGHLIGHT THE BUTTON WHEN SOMEONE HOVERS IT
        if (hoversObject(gameButtons[k], gameButtons[k].image , joints[KinectPV2.JointType_HandRight])) { 
          if (gameButtons[k].getButtonType().equals("sound")) {
            gameButtons[k] = soundButtonState[sound_state + 1];
          }
          
          // If the button is the settings button
          else if (gameButtons[k].getButtonType().equals("settings")){
            gameButtons[k] = settingsButtonState[other_state + 1];
          }
          // If the button is the continue button
          else if (gameButtons[k].getButtonType().equals("continue")){
            gameButtons[k] = continueButtonState[other_state + 1];
          }
          // If the button is the exit button
          else if (gameButtons[k].getButtonType().equals("exit")){
            gameButtons[k] = exitButtonState[other_state + 1];
          }
           // If the button is the start button
          else if (gameButtons[k].getButtonType().equals("start")){
            gameButtons[k] = startButtonState[other_state + 1];
          }
          
          rightHand_open = true;
        }
        
        // HERE WE DECIDE WHAT TO DO WHEN SOMEONE SELECTS IT
        else if (holdsObject(gameButtons[k], gameButtons[k].image, joints[KinectPV2.JointType_HandRight]) && (rightHand_open == true)) { 
          rightHand_open = false;
          // If the button is the sound button
          if (gameButtons[k].getButtonType().equals("sound")) {
            sound_state += 2;
            if (sound_state >= 8) {
              sound_state = 0;
            }
            // We change the button image
            gameButtons[k] = soundButtonState[sound_state];
          }
          
          // If the button is the settings button
          else if (gameButtons[k].getButtonType().equals("settings")){
            // Do whatever here....
          }
          // If the button is the continue button
          else if (gameButtons[k].getButtonType().equals("continue")){
            screen += 1;
          }
          // If the button is the exit button
          else if (gameButtons[k].getButtonType().equals("exit")){
            // Exit the game
            exit();
          }
           // If the button is the start button
          else if (gameButtons[k].getButtonType().equals("start")){
            // Do whatever here...
          }
        }
        else if (hoversObject(gameButtons[k], gameButtons[k].image , joints[KinectPV2.JointType_HandLeft])) { 
          if (gameButtons[k].getButtonType().equals("sound")) {
            gameButtons[k] = soundButtonState[sound_state + 1];
          }
          
          // If the button is the settings button
          else if (gameButtons[k].getButtonType().equals("settings")){
            gameButtons[k] = settingsButtonState[other_state + 1];
          }
          // If the button is the continue button
          else if (gameButtons[k].getButtonType().equals("continue")){
            gameButtons[k] = continueButtonState[other_state + 1];
          }
          // If the button is the exit button
          else if (gameButtons[k].getButtonType().equals("exit")){
            gameButtons[k] = exitButtonState[other_state + 1];
          }
           // If the button is the start button
          else if (gameButtons[k].getButtonType().equals("start")){
            gameButtons[k] = startButtonState[other_state + 1];
          }
          
          leftHand_open = true;
        }
         // HERE WE DECIDE WHAT TO DO WHEN SOMEONE SELECTS IT
        else if (holdsObject(gameButtons[k], gameButtons[k].image, joints[KinectPV2.JointType_HandLeft]) && (leftHand_open == true)) { 
          leftHand_open = false;
          // If the button is the sound button
          if (gameButtons[k].getButtonType().equals("sound")) {
            sound_state += 2;
            if (sound_state >= 8) {
              sound_state = 0;
            }
            // We change the button image
            gameButtons[k] = soundButtonState[sound_state];
          }
          
          // If the button is the settings button
          else if (gameButtons[k].getButtonType().equals("settings")){
            // Do whatever here....
          }
          // If the button is the continue button
          else if (gameButtons[k].getButtonType().equals("continue")){
            screen += 1;
          }
          // If the button is the exit button
          else if (gameButtons[k].getButtonType().equals("exit")){
            // Exit the game
            exit();
          }
           // If the button is the start button
          else if (gameButtons[k].getButtonType().equals("start")){
            // Do whatever here...
          }
        }
        //Return them to 'normal' state
        else {
          if (gameButtons[k].getButtonType().equals("sound")) {
            gameButtons[k] = soundButtonState[sound_state];
          }
          
          // If the button is the settings button
          else if (gameButtons[k].getButtonType().equals("settings")){
            gameButtons[k] = settingsButtonState[other_state];
          }
          // If the button is the continue button
          else if (gameButtons[k].getButtonType().equals("continue")){
            gameButtons[k] = continueButtonState[other_state];
          }
          // If the button is the exit button
          else if (gameButtons[k].getButtonType().equals("exit")){
            gameButtons[k] = exitButtonState[other_state];
          }
           // If the button is the start button
          else if (gameButtons[k].getButtonType().equals("start")){
            gameButtons[k] = startButtonState[other_state];
          }
          
          rightHand_open = true;
          leftHand_open = true;
        }
      }
    }
    setActiveScreens(screen);
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
  object.x = vector.x - image.width/2;
  object.y = vector.y - image.height/2;
}

void setActiveScreens(int screen) {
  manageActiveObjects(gameObjects, screen);
  manageActiveObjects(gameButtons, screen);
  manageActiveObjects(gameBackgrounds, screen);
}

void manageActiveObjects(Object[] objects, int screen) {
  for (int i = 0; i < objects.length; i++) {
    int[] activeScreens = objects[i].getActiveScreens();
    for (int j = 0; j < activeScreens.length; j++) {
      if (screen == activeScreens[j]) {
        objects[i].setActive(true);
      } else {
        objects[i].setActive(false);
      }
    }
  }
}