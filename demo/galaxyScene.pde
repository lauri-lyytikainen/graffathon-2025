

class GalaxyScene extends EffectScene 
{

    private ArrayList<PShape> rings = new ArrayList<PShape>();
    private PShape backgroundStars; // Background star field
    
    private final int ringCount = 100;
    private final float ringSpacing = 3;
    private final int starsInRing = 300;
    private final float ringSpread = 20f;
    private final float verticalSpread = 20f;
    private final int backgroundStarCount = 2000; // Number of background stars
    private final float backgroundStarDistance = 1500; // Distance of background stars

    public GalaxyScene(float startTime, float endTime) {
        super(startTime, endTime);
    }

    void setup(){
        blendMode(ADD);
        
        // Create the galaxy rings
        for(int i = 0; i < ringCount; i++) {
            PShape ring = createShape();
            ring.beginShape(POINTS);
            ring.stroke(lerpColor(color(73, 115, 161), color(157, 47, 77), i/50f), 175f);

            ring.strokeWeight(3);
            for (int starIndex = 0; starIndex < starsInRing; starIndex++) {
                float a = random(0f, 1f) * TWO_PI;
                float r = random(ringSpread) + i * ringSpacing;
                float h = random(-verticalSpread, verticalSpread);
                ring.vertex(cos(a)*r,sin(a)*r,h * (1f*i/ringCount));
            }
            ring.endShape();
            rings.add(ring);  
        }
        
        // Create background stars
        backgroundStars = createShape();
        backgroundStars.beginShape(POINTS);
        backgroundStars.stroke(255, 150);
        backgroundStars.strokeWeight(2);
        
        blendMode(BLEND);
        for (int i = 0; i < backgroundStarCount; i++) {
            // Create stars in a spherical distribution
            float theta = random(TWO_PI);
            float phi = random(TWO_PI);
            
            float x = backgroundStarDistance * sin(phi) * cos(theta);
            float y = backgroundStarDistance * sin(phi) * sin(theta);
            float z = backgroundStarDistance * cos(phi);
            
            // Add some random variation in brightness
            float brightness = random(80, 255);
            backgroundStars.stroke(brightness, brightness, random(brightness * 0.7, brightness), random(100, 200));
            
            // Vary the size of stars slightly
            backgroundStars.strokeWeight(random(2, 8));
            backgroundStars.vertex(x, y, z);
        }
        backgroundStars.endShape();
    }

    public void draw(float time) {
        background(0);
        lights();
        
        // Get camera control values from Moonlander
        float camDist = (float)moonlander.getValue("galaxy_cam_dist");  // Distance from center
        float camHeight = (float)moonlander.getValue("galaxy_cam_height"); // Height above galaxy plane
        float camAngle = (float)moonlander.getValue("galaxy_cam_angle");  // Angle around galaxy
        float camRoll = (float)moonlander.getValue("galaxy_cam_roll");    // Camera roll
        
        // Calculate camera position based on angle and distance
        float camX = sin(radians(camAngle)) * camDist;
        float camY = cos(radians(camAngle)) * camDist;
        float camZ = camHeight;
        
        // Calculate up vector for camera roll
        float upX = sin(radians(camRoll)) * 0.3;
        float upY = cos(radians(camRoll)) * 0.3;
        float upZ = 1.0;
        
        // Apply the camera
        camera(camX, camY, camZ,           // Camera position
               0, 0, 0,                   // Always look at center
               upX, upY, upZ);            // Up vector for roll
        
        // Draw background stars first (before zoom to keep them at the background)
        pushMatrix();
        // Slightly rotate the background stars for a subtle effect
        blendMode(BLEND);
        shape(backgroundStars);
        popMatrix();
               
        // Apply zoom if specified - only affects the galaxy, not the background stars
        float zoom = (float)moonlander.getValue("galaxy_zoom");
        scale(zoom);
        blendMode(ADD);
        
        for(int i = 0; i < ringCount; i++) {
            pushMatrix();
            float speed = 2;
            rotateY((TWO_PI/(i*i)*time) * speed * (float)moonlander.getValue("galaxy_speed_y"));
            rotateX((TWO_PI/(i*i)*time) * speed * (float)moonlander.getValue("galaxy_speed_x"));
            rotateZ((TWO_PI/(i*i)*time) * speed * (float)moonlander.getValue("galaxy_speed_z"));
            PShape ring = rings.get(i);
            color colorA = lerpColor(color(73, 115, 161), color(157, 47, 77), i/50f);
            color colorB = color(255,50);
            float hueShift = (float)moonlander.getValue("galaxy_hue_shift");
            color ringColor = lerpColor(colorA, colorB, hueShift);
            ring.setStroke(ringColor);
            ring.setStrokeWeight((float)moonlander.getValue("galaxy_stroke_weight") * 3 + 1);
            shape(ring);
            popMatrix();
        }
    }
}