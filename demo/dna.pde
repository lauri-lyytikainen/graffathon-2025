class DnaScene extends EffectScene {

    public DnaScene(float startTime, float endTime) {
        super(startTime, endTime);
    }

    public void setup()
    {}

    int resU = 50;
    int resV = 50;
    float uMin = -1.0;
    float uMax = 1.0;
    float vMin = -0.5;
    float vMax = 0.5;

    int helixRes = 100;
    float helixRadius = 20;
    float helixPitch = 20;
    float helixHeight = 300;
    float rungSpacing = 10;

    PVector wormSurface(float u, float v, float t) {
        float x = 100 * u;
        float y = 50 * sin(TWO_PI * u - t * TWO_PI);
        float z = 100 * v;

        float dy = 10 * cos(TWO_PI * u + t);
        float dz = 10 * sin(TWO_PI * u + t);

        return new PVector(x, y + dy, z + dz);
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
        rotateY(frameCount * 0.01);

        float du = (uMax - uMin) / (resU - 1);
        float dv = (vMax - vMin) / (resV - 1);
        
        float tMax = helixHeight / helixPitch;
        float dt = tMax / float(helixRes);
        
        pointLight(51, 102, 126, 20, 20, 20);

        for (float t = 0; t < tMax; t += dt) {
            // Compute positions for both helices
            PVector p1 = helixPoint(t, 0, time);
            PVector p2 = helixPoint(t, PI, time);  // Opposite phase for second helix

            // Draw helix strands
            stroke(255, 100, 150);
            strokeWeight(4);
            point(p1.x, p1.y, p1.z);
            //pointLight(51, 102, 126, p1.x, p1.y, p1.z);
            stroke(100, 150, 255);
            point(p2.x, p2.y, p2.z);
            //pointLight(51, 102, 126, p2.x, p2.y, p2.z);

            // Draw rungs between strands at intervals
            if (int(t * rungSpacing) % 5 == 0) {
            stroke(200);
            strokeWeight(1);
            line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
            }
        }
    }

}
