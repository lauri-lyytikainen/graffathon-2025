class SurfaceScene extends EffectScene
{
    public SurfaceScene(float startTime, float endTime)
    {
        super(startTime, endTime);
    }

    int cols, rows;
    int scale = 30;
    int w = 1600;
    int h = 1200;

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
        lights();
        fill(120,120,120);
        noStroke();

        flying -= 0.05;

        float yoff = flying;
        for (int y = 0; y < rows; y++) {
            float xoff = 0;
            for (int x = 0; x < cols; x++) {
            terrain[x][y] = map(noise(xoff, yoff), 0, 1, -100, 100);
            xoff += 0.1;
            }
            yoff += 0.1;
        }

        translate(width/2, height/2 + 50);
        rotateX(PI/3);
        translate(-w/2, -h/2);

        for (int y = 0; y < rows - 1; y++) {
            beginShape(TRIANGLE_STRIP);
            for (int x = 0; x < cols; x++) {
                float z = terrain[x][y];

                float normalize = map(z, -100, 100, 0, 1);

                int r = (int)lerp(50, 255, normalize);
                int g = (int)lerp(100, 255, normalize);
                int b = (int)lerp(50, 255, normalize);

                fill(r, g, b);

                vertex(x * scale, y * scale, terrain[x][y]);
                vertex(x * scale, (y + 1) * scale, terrain[x][y + 1]);
            }
            endShape();
        }
    }
}