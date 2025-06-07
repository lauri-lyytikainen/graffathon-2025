class SolidScene extends EffectScene {

    PVector[] my_samples;
    int steps = 25;  // Revolve resolution (around Y)
    int res = 25;    // Spline sampling resolution

    float radius = 100;

    public SolidScene(float startTime, float endTime) {
        super(startTime, endTime);
    }

    PShader metallicShader;

    public void setup() {
        my_samples = new PVector[res];

        metallicShader = loadShader("metallic_frag.glsl", "metallic_vert.glsl");
        
        for (int i = 0; i < res; i++) {
            float t = map(i, 0, res - 1, -2, 2);    
            float y = t * 50;                       
            float r = 100 * exp(-t * t);         
            my_samples[i] = new PVector(r, y, 0);    
        }
    }

    public void draw(float time) {
        
        background(139, 0, 0);
        lights();
        translate(width/2, height/2);
        rotateX(-PI/6);
        rotateY(time * 0.2);

        shader(metallicShader);

        noStroke();
        fill(150, 100, 255);

        for (int i = 0; i < res - 1; i++) {
            beginShape(QUAD_STRIP);
            for (int j = 0; j <= steps; j++) {
                float angle = TWO_PI * j / steps;
                for (int k = 0; k < 2; k++) {
                    float noiseVal = noise(i * 0.05, j * 0.05, time * 0.5);
                    float displacement = map(noiseVal, 0, 1, -100, 100);

                    float r = my_samples[i + k].x + displacement;
                    float y = my_samples[i + k].y + displacement;
                    float x = r * cos(angle) + displacement;
                    float z = r * sin(angle) + displacement;
                    vertex(x, y, z);
                }
            }
            endShape();
        }
    }
}