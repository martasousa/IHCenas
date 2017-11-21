
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

import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;

SkeletonPoser poseArmsUp, poseArmsOpen;

PImage keyImage;

class Object{
  float x, y, z;
  Object(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
}

Object ball;


void setup() {
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
  
  ball = new Object(width/2, height/4, 0);
  keyImage = loadImage("chave.png");
  image(keyImage, ball.x, ball.y);
  
  
  
}

void draw() {
  background(0);
  
  image(kinect.getColorImage(), 0, 0, width, height);
  image(keyImage, ball.x, ball.y);
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
      if (holdsObject(ball, joints[KinectPV2.JointType_HandRight])) {
        println("Mao direita na bola");
        moveObject(ball, joints[KinectPV2.JointType_HandRight].getPosition());
        image(keyImage, ball.x, ball.y);
      }
      if (holdsObject(ball, joints[KinectPV2.JointType_HandLeft])) {
        println("Mao esquerda na bola");
        moveObject(ball, joints[KinectPV2.JointType_HandLeft].getPosition());
      }
    }
    
    
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

void drawBall(Object object){
  pushMatrix();
  translate(object.x, object.y, object.z);
  ellipse(0,0,100,100);
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
  
boolean holdsObject(Object object, KJoint joint) {
  PVector vector = joint.getPosition();
  if (joint.getState() != KinectPV2.HandState_Closed) {
    return false;
  }
  if ((vector.x < object.x + 50 ) && (vector.x > object.x - 50)) {
     if ((vector.y < object.y + 50 ) && (vector.y > object.y - 50)) {
       return true;
     }
  }
  return false;
}

void moveObject(Object object, PVector vector) {
  object.x = vector.x;
  object.y = vector.y;
}