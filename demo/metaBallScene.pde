class MetaBallScene extends EffectScene {
    PShape spikedSphere;
    float lastNoiseAmp = -1;
    float lastNoiseFreq = -1;
    float lastNoiseTime = -1;

    public MetaBallScene(float startTime, float endTime) {
        super(startTime, endTime);
    }

    public void setup() {
        spikedSphere = null;
        lastNoiseAmp = -1;
        lastNoiseFreq = -1;
        lastNoiseTime = -1;
    }

    public void draw(float time) {
        background(20);
        // Camera variables from galaxy scene
        float camDist = (float)moonlander.getValue("galaxy_cam_dist");
        float camHeight = (float)moonlander.getValue("galaxy_cam_height");
        float camAngle = (float)moonlander.getValue("galaxy_cam_angle");
        float camRoll = (float)moonlander.getValue("galaxy_cam_roll");
        float camX = sin(radians(camAngle)) * camDist;
        float camY = cos(radians(camAngle)) * camDist;
        float camZ = camHeight;
        float upX = sin(radians(camRoll)) * 0.3;
        float upY = cos(radians(camRoll)) * 0.3;
        float upZ = 1.0;
        camera(camX, camY, camZ, 0, 0, 0, upX, upY, upZ);

        // Improved lighting
        ambientLight(40, 40, 60);
        pointLight(200, 180, 255, 0, 0, 400);
        pointLight(100, 100, 255, 0, 0, -400);
        directionalLight(255, 200, 255, -0.5, 0.7, -1);

        // Get noise parameters every frame
        float noiseAmp = (float)moonlander.getValue("meta_noise_amp");
        float noiseFreq = (float)moonlander.getValue("meta_noise_freq");

        // Only regenerate if parameters changed or first frame
        if (spikedSphere == null || noiseAmp != lastNoiseAmp || noiseFreq != lastNoiseFreq || time != lastNoiseTime) {
            int detail = 40; // sphere resolution
            float radius = 120;
            spikedSphere = createShape();
            spikedSphere.beginShape(TRIANGLE_STRIP);
            spikedSphere.noStroke();
            spikedSphere.fill(200, 100, 255);
            for (int i = 0; i < detail; i++) {
                float theta1 = map(i, 0, detail, 0, PI);
                float theta2 = map(i + 1, 0, detail, 0, PI);
                for (int j = 0; j <= detail; j++) {
                    float phi = map(j, 0, detail, 0, TWO_PI);
                    // Vertex 1
                    float n1 = noise(
                        cos(theta1) * noiseFreq + time,
                        sin(theta1) * noiseFreq + time,
                        cos(phi) * noiseFreq + time
                    );
                    float r1 = radius + map(n1, 0, 1, -40, 60) * noiseAmp;
                    float x1 = r1 * sin(theta1) * cos(phi);
                    float y1 = r1 * sin(theta1) * sin(phi);
                    float z1 = r1 * cos(theta1);
                    PVector norm1 = new PVector(x1, y1, z1).normalize();
                    spikedSphere.normal(norm1.x, norm1.y, norm1.z);
                    spikedSphere.vertex(x1, y1, z1);
                    // Vertex 2
                    float n2 = noise(
                        cos(theta2) * noiseFreq + time,
                        sin(theta2) * noiseFreq + time,
                        cos(phi) * noiseFreq + time
                    );
                    float r2 = radius + map(n2, 0, 1, -40, 60) * noiseAmp;
                    float x2 = r2 * sin(theta2) * cos(phi);
                    float y2 = r2 * sin(theta2) * sin(phi);
                    float z2 = r2 * cos(theta2);
                    PVector norm2 = new PVector(x2, y2, z2).normalize();
                    spikedSphere.normal(norm2.x, norm2.y, norm2.z);
                    spikedSphere.vertex(x2, y2, z2);
                }
                // Duplicate seam vertices for phi=0
                float phi0 = 0;
                float n1_0 = noise(
                    cos(theta1) * noiseFreq + time,
                    sin(theta1) * noiseFreq + time,
                    cos(phi0) * noiseFreq + time
                );
                float r1_0 = radius + map(n1_0, 0, 1, -40, 60) * noiseAmp;
                float x1_0 = r1_0 * sin(theta1) * cos(phi0);
                float y1_0 = r1_0 * sin(theta1) * sin(phi0);
                float z1_0 = r1_0 * cos(theta1);
                PVector norm1_0 = new PVector(x1_0, y1_0, z1_0).normalize();
                spikedSphere.normal(norm1_0.x, norm1_0.y, norm1_0.z);
                spikedSphere.vertex(x1_0, y1_0, z1_0);
                float n2_0 = noise(
                    cos(theta2) * noiseFreq + time,
                    sin(theta2) * noiseFreq + time,
                    cos(phi0) * noiseFreq + time
                );
                float r2_0 = radius + map(n2_0, 0, 1, -40, 60) * noiseAmp;
                float x2_0 = r2_0 * sin(theta2) * cos(phi0);
                float y2_0 = r2_0 * sin(theta2) * sin(phi0);
                float z2_0 = r2_0 * cos(theta2);
                PVector norm2_0 = new PVector(x2_0, y2_0, z2_0).normalize();
                spikedSphere.normal(norm2_0.x, norm2_0.y, norm2_0.z);
                spikedSphere.vertex(x2_0, y2_0, z2_0);
            }
            spikedSphere.endShape();
            lastNoiseAmp = noiseAmp;
            lastNoiseFreq = noiseFreq;
            lastNoiseTime = time;
        }

        pushMatrix();
        if (spikedSphere != null) {
            shape(spikedSphere);
        }
        popMatrix();
    }
}