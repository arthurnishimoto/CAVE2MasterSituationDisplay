class Pulse
{
  float curPos = 0;

  public void setPosition(float val)
  {
    curPos = val;
  }
  
  public float getPosition()
  {
    return curPos;
  }
}

class NodeDisplay
{
  int nodeID = 0;
  int nodeWidth = 250;
  int nodeHeight = 70;
  
  int cpuBorder = 5;
  
  color baseColor = color(250,200,10);
  color nodeColor = color(10,50,10);

  int[] CPU = new int[16];
  
  int[] conduitLength = new int[37];
  int[] conduitAngledLength = new int[37];
  int[] conduitAngle = new int[37];
  
  int gpuMem;
  int nSegments;
  int nAngledSegments;
  int[] segments;
  
  ArrayList conduitPulses = new ArrayList();
  
  NodeDisplay( int id )
  {
    nodeID = id;
    
    for( int i = 0; i < 16; i++)
    {
      CPU[i] = (int)random(0,101);
    }
      
    gpuMem = (int)random(0,101);
    
    conduitLength[0] = 400;
    
    conduitLength[1] = 720;
    conduitLength[2] = 670;
    conduitLength[3] = 570;
    conduitLength[4] = 540;
    conduitLength[5] = 460;
    conduitLength[6] = 460;
    conduitLength[7] = 440;
    conduitLength[8] = 420;
    
    conduitLength[9] = 410;
    conduitLength[10] = 410;
    
    conduitLength[11] = 420;
    conduitLength[12] = 440;
    conduitLength[13] = 460;
    conduitLength[14] = 460;
    conduitLength[15] = 540;
    conduitLength[16] = 570;
    conduitLength[17] = 670;
    conduitLength[18] = 720;

    conduitAngledLength[1] = 210;
    conduitAngledLength[2] = 150;
    conduitAngledLength[3] = 125;
    conduitAngledLength[4] = 80;
    conduitAngledLength[5] = 80;
    conduitAngledLength[6] = 25;
    conduitAngledLength[7] = 0;
    conduitAngledLength[8] = 0;
    conduitAngledLength[9] = 0;
    conduitAngledLength[10] = 0;
    conduitAngledLength[11] = 0;
    conduitAngledLength[12] = 0;
    conduitAngledLength[13] = 30;
    conduitAngledLength[14] = 80;
    conduitAngledLength[15] = 80;
    conduitAngledLength[16] = 125;
    conduitAngledLength[17] = 150;
    conduitAngledLength[18] = 210;
    
    conduitAngle[1] = -72;
    conduitAngle[2] = -72;
    conduitAngle[3] = -54;
    conduitAngle[4] = -54;
    conduitAngle[5] = -35;
    conduitAngle[6] = -40;
    conduitAngle[7] = 0;
    conduitAngle[8] = 0;
    conduitAngle[9] = 0;
    conduitAngle[10] = 0;
    conduitAngle[11] = 0;
    conduitAngle[12] = 0;
    conduitAngle[13] = 40;
    conduitAngle[14] = 35;
    conduitAngle[15] = 54;
    conduitAngle[16] = 54;
    conduitAngle[17] = 72;
    conduitAngle[18] = 72;

    conduitLength[19] = 0;
    conduitLength[20] = 0;
    conduitLength[21] = 0;
    conduitLength[22] = 0;
    conduitLength[23] = 0;
    conduitLength[24] = 0;
    conduitLength[25] = 0;
    conduitLength[26] = 0;
    conduitLength[27] = 0;
    conduitLength[28] = 0;
    conduitLength[29] = 0;
    conduitLength[30] = 0;
    conduitLength[31] = 0;
    conduitLength[32] = 0;
    conduitLength[33] = 0;
    conduitLength[34] = 0;
    conduitLength[35] = 0;
    conduitLength[36] = 0;
    
    nSegments =  conduitLength[nodeID] / (1000 / conduitSegments);
    nAngledSegments = conduitAngledLength[nodeID] / (1000 / conduitSegments);
    segments = new int[nSegments+nAngledSegments];
    
    conduitPulses.add( new Pulse() );
  }
  
  float conduitWidth = 40;
  int conduitSegments = 100;
  int decayRate = 10;
  float curSegment;
  int segmentSizeRange = 1;

  float pulseDelay = 0.5;
  float pulseTimer = 0;
  float pulseSpeed = 20;
  
  void drawLeft()
  {  
    /*   
    pulseTimer += deltaTime;
    if( pulseTimer > pulseDelay )
    {
      conduitPulses.add( new Pulse() );
      pulseTimer = 0;
    }
    */
    
    if( connectToClusterData )
      CPU = allCPUs[nodeID];
    
    float avgCPU = 0;
    for( int i = 0; i < 16; i++)
    {
      //CPU[i] = (int)random(100,100);
      avgCPU += CPU[i];
    }
    
    avgCPU /= 16 * 100;
    
    fill(baseColor);
    text( "Avg CPU: " + String.format("%.2f", avgCPU * 100), 20 + nodeWidth, -24 );
    fill(10,200,200);
    text( "GPU Memory: " + gpuMem, 200 + nodeWidth, -24 );
    
    // Bump up the CPU color effect
    avgCPU += 0.1;
    nodeColor = color( red(baseColor) * avgCPU, green(baseColor) * avgCPU, blue(baseColor) * avgCPU );
    
    // GPU conduit
    if( connectToClusterData )
      gpuMem = allGPUs[nodeID];
    curSegment += gpuMem / pulseSpeed;
    
    
    rectMode(CENTER);
    
    
    // Angled background segments
    float horzOffset = 0;
    float vertOffset = 0;

    pushMatrix();
    translate(horzOffset + 20 + nodeWidth + nSegments * (1000 / conduitSegments), vertOffset);
      
    rotate( radians(conduitAngle[nodeID]) );
    fill(10, 100, 110);
    rect(conduitAngledLength[nodeID]/2, 0, conduitAngledLength[nodeID], conduitWidth );

    if( conduitAngledLength[nodeID] > 0 )
      ellipse( 0, 0, conduitWidth, conduitWidth );
    popMatrix();
    
    
    // Straight background segment
    fill(10, 100, 110);
    rect( 20 + nodeWidth + conduitLength[nodeID]/2, 0, conduitLength[nodeID], conduitWidth );
    
    /*
    ArrayList nextPulseList = new ArrayList();
    
    for( int p = 0; p < conduitPulses.size(); p++ )
    {
      Pulse curPulse = (Pulse)conduitPulses.get(p);
      curSegment = curPulse.getPosition();
      */
      
    // Angled animated segment
    for( int i = 0; i < nAngledSegments; i++ )
    {
      float segmentValue = 100 * (i / (float)nSegments);
      
      if( (nSegments + i) > curSegment - segmentSizeRange && (nSegments + i) < curSegment + segmentSizeRange )
        segments[nSegments + i] = 100;
      else
        segments[nSegments + i] = segments[nSegments + i] - decayRate;
      
      fill(10,220 * segments[nSegments + i]/100.0, 110);
      
      pushMatrix();
      translate(horzOffset + 20 + nodeWidth + nSegments * (1000 / conduitSegments), vertOffset);
      rotate( radians(conduitAngle[nodeID]) );
      rect( i * (1000 / conduitSegments), 0, 5, conduitWidth );
      popMatrix();
    }

    // Straight animated segment
    for( int i = 0; i < nSegments; i++ )
    {
      float segmentValue = 100 * (i / (float)nSegments);
      
      if( i > curSegment - segmentSizeRange && i < curSegment + segmentSizeRange )
        segments[i] = 100;
      else
        segments[i] = segments[i] - decayRate;
      
      fill(10,220 * segments[i]/100.0, 110);
      
      rect( 20 + nodeWidth + i * (1000 / conduitSegments), 0, 5, conduitWidth );
    }
    if( curSegment > nSegments + nAngledSegments )
    {
      curSegment = 0;
      if( nodeID > 0 )
        columnPulse[(nodeID-1)/2] = 1;
    }
    
    /*
      if( curSegment < 100 )
      {
        curPulse.setPosition( curSegment + gpuMem / 55.0 );
        nextPulseList.add( curPulse );
      }
    }
    conduitPulses = nextPulseList;
    */
    
    rectMode(CORNER);
    
    // Node info
    fill(nodeColor);
    noStroke();
    ellipse( 0, 0, nodeHeight, nodeHeight );
    
    fill(0);
    rect( 0, -nodeHeight/2, nodeHeight/2, nodeHeight );
    
    fill(nodeColor);
    rect( 0, -nodeHeight/2, 10, nodeHeight );
    
    fill(nodeColor);
    rect( 20, -nodeHeight/2, nodeWidth, nodeHeight );
    
    if( avgCPU < 0.5 )
      fill(baseColor);
    else
      fill(0);
    textAlign(RIGHT);
    textFont( st_font, 24 );
    if( nodeID != 0 )
      text( nodeID, -nodeHeight/2 + 42, 8 );
    else
      text( "M", -nodeHeight/2 + 42, 8 );
      
    textAlign(LEFT);
    textFont( st_font, 16 );

    // CPU Display
    for( int i = 0; i < 16; i++ )
    {
      fill(10,200,10);
      rect( 10 + 3 * cpuBorder + ( 2 + nodeWidth / 18) * i, cpuBorder - nodeHeight/2, (nodeWidth / 18), nodeHeight - cpuBorder * 2 );
      
      fill(0);
      rect( 10 + 3 * cpuBorder + ( 2 + nodeWidth / 18) * i, cpuBorder - nodeHeight/2, (nodeWidth / 18), (1 - (CPU[i] / 100.0)) * (nodeHeight - cpuBorder * 2)  );
    }
  }
  
  void drawRight()
  {
    if( connectToClusterData )
      CPU = allCPUs[nodeID];
    
    float avgCPU = 0;
    for( int i = 0; i < 16; i++)
    {
      //CPU[i] = (int)random(0,100);
      avgCPU += CPU[i];
    }
    
    avgCPU /= 16 * 100;

    text( "Avg CPU: " + String.format("%.2f", avgCPU * 100), 20 + nodeWidth, -16 * 2 );
    text( "GPU Memory: " + gpuMem, 20 + nodeWidth, -16 );
    
    // Bump up the CPU color effect
    avgCPU += 0.1;
    nodeColor = color( red(baseColor) * avgCPU, green(baseColor) * avgCPU, blue(baseColor) * avgCPU );
    
    // GPU conduit
    if( connectToClusterData )
      gpuMem = allGPUs[nodeID];
    curSegment += gpuMem / 20.0;
    
    int conduitOffset = -425;
    fill(10,100,110);
    rect( conduitOffset, -conduitWidth/2, conduitLength[nodeID], conduitWidth );

    float segments =  conduitLength[nodeID] / (1000 / conduitSegments);
    for( int i = 0; i < segments; i++ )
    {
      float segmentValue = 100 * (i / (float)segments);
      
      if( i == curSegment )
        fill(10,220,110);
      else if( i < curSegment )
        fill(10,220 * (i/(float)curSegment), 110);
      else
        fill(10,0,110);
      
      rect( conduitOffset - i * (1000 / conduitSegments) + segments * (1000 / conduitSegments), -conduitWidth/2, 5, conduitWidth );
    }
    
    if( curSegment > 300 )
      curSegment = 0;
      
    // Node info
    fill(nodeColor);
    noStroke();
    ellipse( nodeWidth * 2, 0, nodeHeight, nodeHeight );
    
    fill(0);
    rect( nodeWidth * 2 - nodeHeight/2, -nodeHeight/2, nodeHeight/2, nodeHeight );
    
    fill(nodeColor);
    rect( nodeWidth * 2 - 10, -nodeHeight/2, 10, nodeHeight );
    
    fill(nodeColor);
    rect( nodeWidth - 20, -nodeHeight/2, nodeWidth, nodeHeight );
    
    if( avgCPU < 0.5 )
      fill(10,200,10);
    else
      fill(10,20,10);
    textAlign(LEFT);
    textFont( st_font, 24 );
    text( nodeID, nodeWidth * 2 -nodeHeight/2 + 25, 8 );
    
    textAlign(LEFT);
    textFont( st_font, 16 );
    
    // CPU Display
    for( int i = 0; i < 16; i++ )
    {
      fill(10,200,10);
      rect( nodeWidth - 3 * cpuBorder + ( 2 + nodeWidth / 18) * i, cpuBorder - nodeHeight/2, (nodeWidth / 18), nodeHeight - cpuBorder * 2 );
      
      fill(0);
      rect( nodeWidth - 3 * cpuBorder + ( 2 + nodeWidth / 18) * i, cpuBorder - nodeHeight/2, (nodeWidth / 18), (1 - (CPU[i] / 100.0)) * (nodeHeight - cpuBorder * 2)  );
    }
    
  }
}// class NodeDisplay