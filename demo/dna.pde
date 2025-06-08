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
        float helixRadius = (float)moonlander.getValue("dna_radius");
        float angle = TWO_PI * t * 0.07 * time + phase;
        float y = helixRadius * cos(angle);
        float z = helixRadius * sin(angle);
        float x = -170 + helixPitch * t;
        return new PVector(x, y, z);
    }

    public void draw(float time) {
        // Get camera control values from Moonlander
        float camDist = (float)moonlander.getValue("galaxy_cam_dist");  // Distance from center
        float camHeight = (float)moonlander.getValue("galaxy_cam_height"); // Height above galaxy plane
        float camAngle = (float)moonlander.getValue("galaxy_cam_angle");  // Angle around galaxy
        float camRoll = (float)moonlander.getValue("galaxy_cam_roll");    // Camera roll

        // Compute helix center by averaging helix points
        float tMax = helixHeight / helixPitch;
        float dt = tMax / float(helixRes);
        PVector helixCenter = new PVector(0, 0, 0);
        int helixCount = 0;
        for (float t = 0; t < tMax; t += dt) {
            helixCenter.add(helixPoint(t, 0, time));
            helixCenter.add(helixPoint(t, PI, time));
            helixCount += 2;
        }
        helixCenter.div(helixCount);

        // Calculate camera position based on angle and distance, relative to helix center
        float camX = helixCenter.x + sin(radians(camAngle)) * camDist;
        float camY = helixCenter.y + cos(radians(camAngle)) * camDist;
        float camZ = helixCenter.z + camHeight;

        // Calculate up vector for camera roll
        float upX = sin(radians(camRoll)) * 0.3;
        float upY = cos(radians(camRoll)) * 0.3;
        float upZ = 1.0;

        // Apply the camera, looking at helix center
        camera(camX, camY, camZ,
               helixCenter.x, helixCenter.y, helixCenter.z,
               upX, upY, upZ);

        background(110, 42, 110);  // Background with dark purple, ocean-like feel
        lights();

        rotateX(QUARTER_PI); // Rotate to view the helix from the side

        // No need to translate, camera is already centered
        fill(255,255,255);
        
        float du = (uMax - uMin) / (resU - 1);
        float dv = (vMax - vMin) / (resV - 1);

        pointLight(51, 102, 126, 20, 20, 20);  // Light for better visualization

        // Loop through the helix height (t) to create the strands and base pairs
        for (float t = 0; t < tMax; t += dt) {
            // Compute positions for both helices
            PVector p1 = helixPoint(t, 0, time);
            PVector p2 = helixPoint(t, PI, time);  // Opposite phase for the second helix

            // Alternate base pairs (A-T, C-G)
            String basePair = (int(t * 5) % 2 == 0) ? "AT" : "CG";  // Alternate AT and CG pairs

            float noiseVal = noise(0.05, 0.05, time * 0.5);
            float displacement = map(noiseVal, 0, 1, -50, 50);

            // Color points based on the base pair
            if (basePair.equals("AT")) {
                stroke(255, 0, 0);  // Red for A-T pairs (p1)
                strokeWeight(4);
                point(p1.x + displacement, p1.y + displacement, p1.z);  // Point on first helix (A)
                
                stroke(0, 0, 255);  // Blue for A-T pairs (p2)
                point(p2.x, p2.y, p2.z);  // Point on second helix (T)
                stroke(255, 0, 0);  // Red for A-T pairs
                fill(255, 0, 0);
                textSize(24);
                text("A-T", p1.x, p1.y, p1.z);
            } else {
                stroke(0, 255, 0);  // Green for C-G pairs (p1)
                strokeWeight(4);
                point(p1.x, p1.y, p1.z);  // Point on first helix (C)
                
                stroke(255, 255, 0);  // Yellow for C-G pairs (p2)
                point(p2.x + displacement, p2.y + displacement, p2.z);  // Point on second helix (G)

                stroke(0, 255, 0);  // Green for C-G pairs
                fill(0, 255, 0);
                textSize(24);
                text("C-G", p2.x, p2.y, p2.z);  // Label "C-G"
            }

            // Draw rungs between strands at intervals (base pairs)
            if (int(t * rungSpacing) % 5 == 0) {
                // Alternate base pairs (A-T, C-G)
                basePair = (int(t * 5) % 2 == 0) ? "AT" : "CG";  // Alternate AT and CG pairs
                PVector midPoint = PVector.lerp(p1, p2, 0.5);  // Midpoint between the two strands for base pair

                // Color and label based on the base pair
                if (basePair.equals("AT")) {
                    stroke(255, 0, 0);  // Red for A-T pairs
                    fill(255, 0, 0);
                    textSize(32);
                    text("A-T", midPoint.x + 5, midPoint.y + 5, midPoint.z);  // Label "A-T"
                } else {
                    stroke(0, 255, 0);  // Green for C-G pairs
                    fill(0, 255, 0);
                    textSize(32);
                    text("C-G", midPoint.x + 5, midPoint.y + 5, midPoint.z);  // Label "C-G"
                }

                // Draw base pair connection (a line between p1 and p2)
                strokeWeight(1);
                line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
            }

            // Optional: Draw the rungs (lines) at regular intervals
            if (int(t * rungSpacing) % 5 == 0) {
                stroke(200);
                strokeWeight(1);
                line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);  // Rung connection between strands
            }
        }
    }

}
