PVector catmullRom(PVector p0, PVector p1, PVector p2, PVector p3, float t) {
  float t2 = t * t;
  float t3 = t2 * t;

  float f1 = -0.5 * t3 + t2 - 0.5 * t;
  float f2 =  1.5 * t3 - 2.5 * t2 + 1.0;
  float f3 = -1.5 * t3 + 2.0 * t2 + 0.5 * t;
  float f4 =  0.5 * t3 - 0.5 * t2;

  float x = p0.x * f1 + p1.x * f2 + p2.x * f3 + p3.x * f4;
  float y = p0.y * f1 + p1.y * f2 + p2.y * f3 + p3.y * f4;
  float z = p0.z * f1 + p1.z * f2 + p2.z * f3 + p3.z * f4;

  return new PVector(x, y, z);
}

PVector splineTangent(PVector[] pts, float s) {
  float eps = 0.001;
  PVector p1 = splineEval(pts, s);
  PVector p2 = splineEval(pts, s + eps);
  return PVector.sub(p2, p1).normalize();
}

PVector splineEval(PVector[] pts, float s) {
  int n = pts.length - 3;
  int seg = constrain(int(s * n), 0, n - 1);
  float t = s * n - seg;
  return catmullRom(pts[seg], pts[seg+1], pts[seg+2], pts[seg+3], t);
}

void getSplineFrame(PVector[] pts, float s, PVector[] frameOut) {
  float eps = 0.001;
  PVector p = splineEval(pts, s);
  PVector pNext = splineEval(pts, s + eps);

  PVector T = PVector.sub(pNext, p).normalize();      // Tangent
  PVector up = new PVector(0, 1, 0);                  // Up direction
  PVector N = T.cross(up).normalize();                // Normal (side)
  PVector B = T.cross(N).normalize();                 // Binormal (up)

  frameOut[0] = T;  // Tangent
  frameOut[1] = N;  // Normal
  frameOut[2] = B;  // Binormal
}

class WormScene extends EffectScene {

    PVector[] my_controlPts;

    public WormScene(float startTime, float endTime) {
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


        background(110, 42, 110);
        lights();
        translate(width/2, height/2, 0);
        rotateX(-PI/6);
        rotateY(time);

        float du = (uMax - uMin) / (resU - 1);
        float dv = (vMax - vMin) / (resV - 1);
        
        noStroke();
    
        for (int i = 0; i < resU - 1; i++) {
            float u1 = uMin + i * du;
            float u2 = uMin + (i + 1) * du;
            
            fill(255, 255, 255);

            beginShape(QUAD_STRIP);
            for (int j = 0; j < resV; j++) {
            float v = vMin + j * dv;

            PVector p1 = wormSurface(u1, v, (float)time, my_controlPts);
            PVector p2 = wormSurface(u2, v, (float)time, my_controlPts);

            float r = 200 + 55 * sin(v * PI);
            float g = 100 + 100 * cos(u1 * PI);
            float b = 255;
            float alpha = (float)moonlander.getValue("worm_opacity"); // 150 + 100 * sin(time + u1 * 2);  // time-based shimmer
            fill(r, g, b, alpha);
            vertex(p1.x, p1.y, p1.z);
            vertex(p2.x, p2.y, p2.z);
            }
            endShape();
        }
    }

}
