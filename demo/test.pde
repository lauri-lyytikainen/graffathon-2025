class CubeScene extends EffectScene {

    public CubeScene(float startTime, float endTime) {
        super(startTime, endTime);
    }

    @Override
    public void draw(double time) {
        background(0);
        lights();
        translate(width / 2, height / 2, -200);
        rotateX((float)(time));
        rotateY((float)(time));
        fill((float)moonlander.getValue("bg_color"));
        box(100);
    }
}