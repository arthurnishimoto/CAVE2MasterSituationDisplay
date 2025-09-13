/**
 * ---------------------------------------------
 * AudioDisplay.pde
 * Description: CAVE2 Master Situation Display (MSD)
 *
 * Class: 
 * System: Processing 2.2, SUSE 12.1, Windows 7 x64
 * Author: Arthur Nishimoto
 * Copyright (C) 2012-2014
 * Electronic Visualization Laboratory, University of Illinois at Chicago
 *
 * Version Notes:
 * ---------------------------------------------
 */
 
ArrayList soundList = new ArrayList();
boolean playingStereo = false;

int stereoSounds = 0;

class Sound
{
  int bufferNo;
  int nodeID;
  float amplitude;
  float maxDistance, minDistance;
  
  PVector position;
  boolean isStereo = false;
  
  float triggerTime;
  float maxLifetime = 1.0;
  float lifetime = maxLifetime;
  
  Sound( float xPos, float zPos )
  {
    position = new PVector(xPos, 0, zPos);
    triggerTime = programTimer;
  }
  
  void draw()
  {
    pushMatrix();
    translate( position.x * CAVE2_Scale, position.z * CAVE2_Scale, 0 );
    
    lifetime -= deltaTime;
    
    noStroke();
    fill(255, 255, 255, 255 * lifetime);
    ellipse( 0, 0, 20, 20 );
    popMatrix();
  }
  
}// class Sound

/* incoming osc message are forwarded to the oscEvent method. */
String lastOSCMessage = "";
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  //print("### received an osc message.");
  //print(" addrpattern: "+theOscMessage.addrPattern());
  //println(" typetag: "+theOscMessage.typetag());
  lastOSCMessage = theOscMessage.toString() + "\n Arguments: ";
  
  for( int i = 0; i < theOscMessage.arguments().length; i++ )
  {
    lastOSCMessage += "'"+theOscMessage.arguments()[i] + "' ";
  }
  
  // newMonoSound nodeID, bufNum, amp, xPos, zPos
  // newStereoSound nodeID, bufNum, amp
  
  if( theOscMessage.checkAddrPattern("newMonoSound") ) {
    /* check if the typetag is the right one. */
    if( theOscMessage.checkTypetag("iifff") ) {
      float xPos = theOscMessage.get(3).floatValue();
      float zPos = theOscMessage.get(4).floatValue();
      
      Sound s = new Sound( xPos, zPos );
      s.nodeID = theOscMessage.get(0).intValue();
      s.bufferNo = theOscMessage.get(1).intValue();
      s.amplitude = theOscMessage.get(2).floatValue();
      
      soundList.add(s);
      return;
    }
  }
  
  if( theOscMessage.checkAddrPattern("newStereoSound") ) {
    /* check if the typetag is the right one. */
    if( theOscMessage.checkTypetag("iif") ) {
      println("stereoSound");
      playingStereo = true;
      return;
    }
  }
  
  if( theOscMessage.checkAddrPattern("bootCluster") ) {
    /* check if the typetag is the right one. */
    if( theOscMessage.checkTypetag("iii") ) {
      onBootCluster( theOscMessage.get(0).intValue(), theOscMessage.get(1).intValue(), theOscMessage.get(2).intValue() );
      return;
    }
  }
  
  if( theOscMessage.checkAddrPattern("fixedMountPoints") ) {
    mountPointsFixed = 1;
  }
  
  if( theOscMessage.checkAddrPattern("audioReceiver") ) {
    /* check if the typetag is the right one. */
    if( theOscMessage.checkTypetag("i") ) {
      audioReceiverMode =  theOscMessage.get(0).intValue();
      return;
    }
  }
  
  if( theOscMessage.checkAddrPattern("soundServerStarted") ) {
    soundServerRunning = 1;
    stereoEnabled = 0;
    surroundEnabled = 0;
    audioMuted = 0;
  }
  
  if( theOscMessage.checkAddrPattern("soundServerStopped") ) {
    soundServerRunning = 0;
    stereoEnabled = 0;
    surroundEnabled = 0;
    audioMuted = 0;
  }
  
  if( theOscMessage.checkAddrPattern("audioMuted") ) {
    if( theOscMessage.checkTypetag("i") ) {
      audioMuted =  theOscMessage.get(0).intValue();
      return;
    }
  }
  
  if( theOscMessage.checkAddrPattern("serverVol") ) {
    if( theOscMessage.checkTypetag("i") ) {
      serverVol =  theOscMessage.get(0).intValue();
      return;
    }
  }
  
  if( theOscMessage.checkAddrPattern("audioStereoEnabled") ) {
    stereoEnabled = 1;
  }
  if( theOscMessage.checkAddrPattern("audioSurroundEnabled") ) {
    surroundEnabled = 1;
  }
  
  if( theOscMessage.checkAddrPattern("oscDebugWindowEnabled") ) {
    enablePopUpWindow = true;
    messageType = -1;
  }
  if( theOscMessage.checkAddrPattern("oscDebugWindowDisabled") ) {
    enablePopUpWindow = false;
    messageType = -1;
  }
}

void drawSounds()
{
  ArrayList activeSounds = new ArrayList();
  for( int i = 0; i < soundList.size(); i++ )
  {
    Sound s = (Sound)soundList.get(i);
    s.draw();
    
    if( s.lifetime > 0 )
      activeSounds.add(s);
  }
  
  soundList = activeSounds;
}

void drawAudioStatus()
{
  background(0);
  systemText = "AUDIO SYSTEM";
}
