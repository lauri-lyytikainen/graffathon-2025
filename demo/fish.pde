class FishScene extends EffectScene {

    PVector[] my_controlPts;

    public FishScene(float startTime, float endTime) {
        super(startTime, endTime);
    }

    public void setup()
    {
        my_controlPts = new PVector[] {
        new PVector(-600,  0,    0),
        new PVector(-450,  40,   50),
        new PVector(-300, -30,  100),
        new PVector(-150,  50,   50),
        new PVector(   0, -50,  100),
        new PVector( 150,  0,    50),
        new PVector( 300,  75,    0),
        new PVector( 450, -50,  -50),
        new PVector( 600,  40, -100),
        new PVector( 750,   0,  -75)
        };
    }

    int resU = 150;
    int resV = 150;
    float uMin = -1.0;
    float uMax = 1.0;
    float vMin = -0.5;
    float vMax = 0.5;

    int helixRes = 100;
    float helixRadius = 20;
    float helixPitch = 20;
    float helixHeight = 300;
    float rungSpacing = 10;

    PVector wormSurface(float u, float v, float t, PVector[] controlPts) {
        
        float s = 0.2 + u * 0.6;

        PVector center = splineEval(controlPts, s);

        PVector[] frame = new PVector[3]; // T, N, B
        getSplineFrame(controlPts, s, frame);
        PVector T = frame[0];
        PVector N = frame[1];
        PVector B = frame[2];

        // Local sine wave in the Binormal (like vertical wiggle)
        float amplitude = 50;
        float wave = amplitude * sin(TWO_PI * u - t * 2.0);

        // Position in local frame
        PVector offset = PVector.add(
            PVector.mult(N, v * 80), 
            PVector.mult(B, wave) 
        );

        return PVector.add(center, offset);
    }

    PVector helixPoint(float t, float phase, float time) {
        float angle = TWO_PI * t * 0.07 * time + phase;
        float y = helixRadius * cos(angle);
        float z = helixRadius * sin(angle);
        float x = -170 + helixPitch * t;
        return new PVector(x, y, z);
    }

    public void draw(float time) {
      background(20, 30, 50);  // Dark ocean depths
      ambientLight(80, 100, 120);  // Dim ambient light for deep ocean feel

      // Calculate the average position of the worm based on control points
      PVector wormCenter = new PVector(0, 0, 0);
      for (PVector pt : my_controlPts) {
          wormCenter.add(pt);
      }
      wormCenter.div(my_controlPts.length);  // Get the average (center) of the worm

      // 1. Translate the scene so that the worm's center is at the origin (centered)
      translate(width / 2 - wormCenter.x, height / 2 - wormCenter.y, 0);  // Center the worm in the view

      // Optional: Rotate the view to make the worm rotate with time
      rotateX(-PI / 6);
      rotateY(time);

      // 2. Worm rendering logic (color, bioluminescence, etc.)
      float du = (uMax - uMin) / (resU - 1);
      float dv = (vMax - vMin) / (resV - 1);

      noStroke();
      for (int i = 0; i < resU - 1; i++) {
          float u1 = uMin + i * du;
          float u2 = uMin + (i + 1) * du;
          
          float glow = map(sin(time + u1 * 5.0), -1, 1, 180, 255);  // Stronger glowing effect
          glow = pow(glow, 1.5);  // Exponentially increase the glow to make it more intense
          
          fill(glow, 255, 255, 180);  // Make the glow more intense and increase alpha for "stronger" effect
          
          beginShape(QUAD_STRIP);
          for (int j = 0; j < resV; j++) {
              float v = vMin + j * dv;
              
              PVector p1 = wormSurface(u1, v, (float)time, my_controlPts);
              PVector p2 = wormSurface(u2, v, (float)time, my_controlPts);

              // Add slight water distortion effect to worm's motion
              //float distortion = sin(time + u1 * 0.5) * 5.0;
              //p1.x += distortion; p1.y += distortion;
              //p2.x += distortion; p2.y += distortion;

              vertex(p1.x, p1.y, p1.z);
              vertex(p2.x, p2.y, p2.z);
          }
          endShape();
      }
  }

}
