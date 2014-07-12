
boolean enablePopUpWindow = false;
int messageType = -1;
PVector popupWindowSize = new PVector( 1920, 1080 );

// Message Type: 1 (Boot to Windows)
int estBootTime;
int audioReceiverMode = -1; // -1 = Unknown, 0 = Linux, 1 = Windows, 2 = Xbox
int stereoEnabled = -1;
int surroundEnabled = -1;
int audioMuted = -1;
int serverVol = -10000;
int mountPointsFixed = 0;

int soundServerRunning = -1;

void onBootCluster( int os, int minute, int second )
{
  enablePopUpWindow = true;
  messageType = os;
  
  if( os == 1 )
    mountPointsFixed = 0;
    
  estBootTime = millis() + (minute * 60 + second) * 1000;
}

void drawPopUpWindow()
{
  if( !enablePopUpWindow )
    return;
    
  pushMatrix();
  translate( targetWidth/2 - popupWindowSize.x/2, targetHeight/2 - popupWindowSize.y/2, 1000);

  fill(0,0,0,164);
  stroke(124);
  rect(0, 0, popupWindowSize.x, popupWindowSize.y );
  
  switch( messageType )
  {
    case(1): // Boot to Windows
      
      textAlign(LEFT);
      fill(200);
      textFont( st_font, 64 );
      text("CLUSTER BOOTING TO WINDOWS", 50, 50 + 32);
      
      textFont( st_font, 32 );
      if( soundServerRunning == -1 )
      {
        fill(210,210,20);
        text("AUDIO SERVER - STATUS UNKNOWN", 50, 50 + 32 + 64 * 8);
      }
      else if( soundServerRunning == 0 )
      {
        fill(210,110,20);
        text("AUDIO SERVER - OFFLINE", 50, 50 + 32 + 64 * 8);
      }
      else if( audioReceiverMode == 1 && surroundEnabled == 1 )
      {
        fill(10,210,10);
        text("AUDIO SERVER - READY", 50, 50 + 32 + 64 * 8);
      }
      else
      {
        fill(210,210,20);
        text("AUDIO SERVER - NOT CONFIGURED", 50, 50 + 32 + 64 * 8);
      }
      
      
      if( audioReceiverMode == 0 )
      {
        fill(210,10,20);
        text("     RECEIVER SET FOR LINUX", 50, 50 + 32 + 64 * 9);
      }
      else if( audioReceiverMode == 1 )
      {
        fill(10,210,10);
        text("     RECEIVER SET FOR WINDOWS", 50, 50 + 32 + 64 * 9);
      }
      else if( audioReceiverMode == 2 )
      {
        fill(210,10,20);
        text("     RECEIVER SET FOR AUXILIARY (XBOX)", 50, 50 + 32 + 64 * 9);
      }
      else
      {
        fill(210,110,20);
        text("     RECEIVER STATUS UNKNOWN", 50, 50 + 32 + 64 * 9);
      }
      
      if( surroundEnabled == 0 )
      {
        fill(210,10,10);
        text("     SURROUND SOUND FOR WINDOWS IS DISABLED", 50, 50 + 32 + 64 * 9 + 32 * 1);
      }
      else if( surroundEnabled == 1 )
      {
        fill(10,210,10);
        text("     SURROUND SOUND FOR WINDOWS IS ENABLED", 50, 50 + 32 + 64 * 9 + 32 * 1);
      }
      else
      {
        fill(210,210,10);
        text("     SURROUND SOUND STATUS UNKNOWN", 50, 50 + 32 + 64 * 9 + 32 * 1);
      }
      
      if( estBootTime - millis() > 0 )
      {
        fill(200);
        text("ESTIMATED TIME REMAINING:", 50, 50 + 32 + 64 * 4);
      
        textAlign(CENTER);
        textFont( st_font, 256 );
        int timeInSec = (estBootTime - millis()) / 1000;
        int timeInMin = timeInSec / 60;
        int timeInMinSec = timeInSec - (timeInMin*60);
        if( timeInMinSec < 10 )
          text( timeInMin + ":0" + timeInMinSec, popupWindowSize.x/2, popupWindowSize.y/2);
        else
          text( timeInMin + ":" + timeInMinSec, popupWindowSize.x/2, popupWindowSize.y/2);
      }
      else if( estBootTime - millis() < -2000 && audioReceiverMode == 1 && surroundEnabled == 1)
      {
        enablePopUpWindow = false;
      }
      break;
    case(0):
      textAlign(LEFT);
      fill(200);
      textFont( st_font, 64 );
      text("CLUSTER BOOTING TO LINUX", 50, 50 + 32);
      
      textFont( st_font, 32 );
      if( soundServerRunning == -1 )
      {
        fill(210,210,20);
        text("AUDIO SERVER - STATUS UNKNOWN", 50, 50 + 32 + 64 * 8);
      }
      else if( soundServerRunning == 0 )
      {
        fill(210,110,20);
        text("AUDIO SERVER - OFFLINE", 50, 50 + 32 + 64 * 8);
      }
      else if( audioReceiverMode == 0 && stereoEnabled == 1 )
      {
        fill(10,210,10);
        text("AUDIO SERVER - READY", 50, 50 + 32 + 64 * 8);
      }
      else
      {
        fill(210,210,20);
        text("AUDIO SERVER - NOT CONFIGURED", 50, 50 + 32 + 64 * 8);
      }
      
      if( mountPointsFixed == 1 )
      {
        fill(10,210,10);
        text("LINUX MOUNT POINTS FIXED", 50, 50 + 32 + 64 * 12);
      }
      else
      {
        fill(210,210,20);
        text("ACTION NEEDED - FIX MOUNT POINTS", 50, 50 + 32 + 64 * 12);
      }
      
      if( audioReceiverMode == 0 )
      {
        fill(10,210,10);
        text("     RECEIVER SET FOR LINUX", 50, 50 + 32 + 64 * 9);
      }
      else if( audioReceiverMode == 1 )
      {
        fill(210,10,20);
        text("     RECEIVER SET FOR WINDOWS", 50, 50 + 32 + 64 * 9);
      }
      else if( audioReceiverMode == 2 )
      {
        fill(210,10,20);
        text("     RECEIVER SET FOR AUXILIARY (XBOX)", 50, 50 + 32 + 64 * 9);
      }
      else
      {
        fill(210,110,20);
        text("     RECEIVER STATUS UNKNOWN", 50, 50 + 32 + 64 * 9);
      }
      
      if( stereoEnabled == 0 )
      {
        fill(210,10,10);
        text("     STEREO (ELECTRO) SOUND FOR LINUX IS DISABLED", 50, 50 + 32 + 64 * 9 + 32 * 1);
      }
      else if( stereoEnabled == 1 )
      {
        fill(10,210,10);
        text("     STEREO (ELECTRO) SOUND FOR LINUX IS ENABLED", 50, 50 + 32 + 64 * 9 + 32 * 1);
      }
      else
      {
        fill(210,210,10);
        text("     STEREO (ELECTRO) SOUND STATUS UNKNOWN", 50, 50 + 32 + 64 * 9 + 32 * 1);
      }
      
      
      if( estBootTime - millis() > 0 )
      {
        fill(200);
        text("ESTIMATED TIME REMAINING:", 50, 50 + 32 + 64 * 4);
      
        textAlign(CENTER);
        textFont( st_font, 256 );
        int timeInSec = (estBootTime - millis()) / 1000;
        int timeInMin = timeInSec / 60;
        int timeInMinSec = timeInSec - (timeInMin*60);
        if( timeInMinSec < 10 )
          text( timeInMin + ":0" + timeInMinSec, popupWindowSize.x/2, popupWindowSize.y/2);
        else
          text( timeInMin + ":" + timeInMinSec, popupWindowSize.x/2, popupWindowSize.y/2);
      }
      else if( estBootTime - millis() < -2000 && audioReceiverMode == 0 && stereoEnabled == 1 && mountPointsFixed == 1 )
      {
        enablePopUpWindow = false;
      }
      break;
    default:
      
      fill(200);
      textFont( st_font, 32 );
      text("OSC DEBUGGING WINDOW", 50, 50);
      
      text("Last OSC Message Received: " + lastOSCMessage, 50, 50 + 32 + 64 * 1);
      
      if( soundServerRunning == -1 )
      {
        fill(210,210,20);
        text("AUDIO SERVER - STATUS UNKNOWN", 50, 50 + 32 + 64 * 8);
      }
      else if( soundServerRunning == 0 )
      {
        fill(210,110,20);
        text("AUDIO SERVER - OFFLINE", 50, 50 + 32 + 64 * 8);
      }
      else if( soundServerRunning == 1 )
      {
        fill(10,210,20);
        text("AUDIO SERVER - ONLINE", 50, 50 + 32 + 64 * 8);
      }
      
      fill(200);
      if( audioReceiverMode == 0 )
      {
        text("     RECEIVER SET FOR LINUX", 50, 50 + 32 + 64 * 9);
      }
      else if( audioReceiverMode == 1 )
      {
        text("     RECEIVER SET FOR WINDOWS", 50, 50 + 32 + 64 * 9);
      }
      else if( audioReceiverMode == 2 )
      {
        text("     RECEIVER SET FOR AUXILIARY (XBOX)", 50, 50 + 32 + 64 * 9);
      }
      else
      {
        fill(210,210,10);
        text("     RECEIVER STATUS UNKNOWN", 50, 50 + 32 + 64 * 9);
      }
      
      fill(200);
      if( stereoEnabled == 0 )
      {
        text("     STEREO (ELECTRO) SOUND FOR LINUX IS DISABLED", 50, 50 + 32 + 64 * 9 + 32 * 1);
      }
      else if( stereoEnabled == 1 )
      {
        text("     STEREO (ELECTRO) SOUND FOR LINUX IS ENABLED", 50, 50 + 32 + 64 * 9 + 32 * 1);
      }
      else
      {
        fill(210,210,10);
        text("     STEREO SOUND STATUS UNKNOWN", 50, 50 + 32 + 64 * 9 + 32 * 1);
      }
      
      fill(200);
      if( surroundEnabled == 0 )
      {
        text("     SURROUND SOUND IS DISABLED", 50, 50 + 32 + 64 * 9 + 32 * 2);
      }
      else if( surroundEnabled == 1 )
      {
        text("     SURROUND SOUND IS ENABLED", 50, 50 + 32 + 64 * 9 + 32 * 2);
      }
      else
      {
        fill(210,210,10);
        text("     SURROUND SOUND STATUS UNKNOWN", 50, 50 + 32 + 64 * 9 + 32 * 2);
      }
      
      fill(200);
      if( serverVol != -10000 )
      {
        text("     SOUND SERVER VOLUME: " + serverVol, 50, 50 + 32 + 64 * 9 + 32 * 3);
      }
      else
      {
        fill(210,210,10);
        text("     SOUND SERVER VOLUME: UNKNOWN", 50, 50 + 32 + 64 * 9 + 32 * 3);
      }
      
      fill(200);
      if( audioMuted == 1 )
      {
        text("     SOUND SERVER MUTED", 50, 50 + 32 + 64 * 9 + 32 * 4);
      }
      else if( audioMuted == 0 )
      {
        text("     SOUND SERVER NOT MUTED", 50, 50 + 32 + 64 * 9 + 32 * 4);
      }
      else
      {
        fill(210,210,10);
        text("     SOUND SERVER MUTE STATUS UNKNOWN", 50, 50 + 32 + 64 * 9 + 32 * 4);
      }
      
      break;
  }
  textAlign(LEFT);
  popMatrix();
}
