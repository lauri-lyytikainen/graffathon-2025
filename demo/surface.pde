class SurfaceScene extends EffectScene
{
    public SurfaceScene(float startTime, float endTime)
    {
        super(startTime, endTime);
    }

    int cols, rows;
    int scale = 20;
    int w = 3 * width;
    int h = 3 * height;

    float flying = 0;
    float[][] terrain;

    public void setup()
    {
        cols = w / scale;
        rows = h / scale;
        terrain = new float[cols][rows];

    }

    public void draw(float time)
    {
        background(137, 207, 240);
        // lights();
        fill(120,120,120);
        noStroke();
        flying = -time * (float)moonlander.getValue("dna_radius") * 0.1; // Adjust flying speed based on moonlander value

        float yStep = 0.1;
        float xStep = 0.1;
        float yoff = flying - yStep / 2.0;
        for (int y = 0; y < rows; y++) {
            float xoff = -xStep / 2.0;
            for (int x = 0; x < cols; x++) {
                terrain[x][y] = map(noise(xoff, yoff), 0, 1, -100, 100) * (float)moonlander.getValue("meta_noise_amp"); // Adjust height based on moonlander value
                xoff += xStep;
            }
            yoff += yStep;
        }

        float camDist = (float)moonlander.getValue("galaxy_cam_dist");  // Distance from center
        float camHeight = (float)moonlander.getValue("galaxy_cam_height"); // Height above galaxy plane
        float camAngle = (float)moonlander.getValue("galaxy_cam_angle");  // Angle around galaxy
        float camRoll = (float)moonlander.getValue("galaxy_cam_roll");    // Camera roll
        
        // Calculate camera position based on angle and distance
        float camX = sin(radians(camAngle)) * camDist;
        float camY = cos(radians(camAngle)) * camDist;
        float camZ = camHeight;
        
        // Calculate up vector for camera roll
        float upX = sin(radians(camRoll));
        float upY = cos(radians(camRoll));
        float upZ = 1.0;
        
        // Apply the camera
        camera(camX, camZ, camY,           // Camera position
               0, 0, 0,                   // Always look at center
               upX, upY, -upZ);            // Up vector for roll

        // No need to translate or rotate here, since the camera() function above handles the view.
        // If you want to adjust the scene's position relative to the camera, you can add a translate here.
        // For now, center the terrain at the origin:
        translate(-w/2, -h * 0.8, 0);

        for (int y = 0; y < rows - 1; y++) {
            beginShape(TRIANGLE_STRIP);
            for (int x = 0; x < cols; x++) {
                float z1 = terrain[x][y];
                float z2 = terrain[x][y + 1];

                // Average the heights for smooth color interpolation between y rows
                float normalize1 = map(z1, -100, 100, 0, 1);
                float normalize2 = map(z2, -100, 100, 0, 1);

                int r1 = (int)lerp(50, 255, normalize1);
                int g1 = (int)lerp(100, 255, normalize1);
                int b1 = (int)lerp(50, 255, normalize1);

                int r2 = (int)lerp(50, 255, normalize2);
                int g2 = (int)lerp(100, 255, normalize2);
                int b2 = (int)lerp(50, 255, normalize2);

                fill(r1, g1, b1);
                vertex(x * scale, y * scale, z1);

                fill(r2, g2, b2);
                vertex(x * scale, (y + 1) * scale, z2);
            }
            endShape();
        }
    }
}