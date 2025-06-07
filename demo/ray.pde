class RayScene extends EffectScene
{
    PVector sphereCenter = new PVector(0, 0, 5);
    float sphereRadius = 1;

    PImage img;

    public RayScene(float startTime, float endTime)
    {
        super(startTime, endTime);
    }

    Sphere[] spheres;

    void setup() {
    img = createImage(width, height, RGB);
    
    // Create two spheres with positions and reflective properties
    spheres = new Sphere[] {
        new Sphere(new PVector(-1.5, 0, 6), 1, color(255, 0, 0), true),  // Reflective red sphere
        //new Sphere(new PVector(1.5, 0, 6), 1, color(0, 0, 255), false)   // Blue sphere
    };
    
    rayTrace();
    image(img, 0, 0);
    }

    void rayTrace() {
    PVector eye = new PVector(0, 0, 0);
    float fov = PI / 3.0;

    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
        float ndcX = (x + 0.5) / width;
        float ndcY = (y + 0.5) / height;
        float screenX = (2 * ndcX - 1) * tan(fov / 2) * width / height;
        float screenY = (1 - 2 * ndcY) * tan(fov / 2);
        PVector rayDir = new PVector(screenX, screenY, 1).normalize();

        color c = traceRay(eye, rayDir, 0);
        img.set(x, y, c);
        }
    }
    }

    // Recursive ray tracer (1 bounce for reflection)
    color traceRay(PVector origin, PVector dir, int depth) {
    if (depth > 1) return color(0);  // Max depth for reflection

    float closest = Float.MAX_VALUE;
    Sphere hitSphere = null;
    float t = 0;

    for (Sphere s : spheres) {
        Float hit = s.intersect(origin, dir);
        if (hit != null && hit < closest) {
        closest = hit;
        hitSphere = s;
        t = hit;
        }
    }

    if (hitSphere != null) {
        PVector hitPoint = PVector.add(origin, PVector.mult(dir, t));
        PVector normal = PVector.sub(hitPoint, hitSphere.center).normalize();
        PVector lightDir = new PVector(1, 1, -1).normalize();
        float diff = max(normal.dot(lightDir), 0);
        color base = lerpColor(color(0), hitSphere.col, diff);

        if (hitSphere.reflective && depth < 1) {
        PVector reflectDir = reflect(dir, normal).normalize();
        PVector offset = PVector.add(hitPoint, PVector.mult(normal, 0.001));  // Avoid self-hit
        color reflected = traceRay(offset, reflectDir, depth + 1);
        return lerpColor(base, reflected, 0.5);
        }

        return base;
    }

    return color(20);  // Background
    }

    PVector reflect(PVector I, PVector N) {
    return PVector.sub(I, PVector.mult(N, 2 * I.dot(N)));
    }

    class Sphere {
    PVector center;
    float radius;
    color col;
    boolean reflective;

    Sphere(PVector c, float r, color col, boolean refl) {
        this.center = c;
        this.radius = r;
        this.col = col;
        this.reflective = refl;
    }

    Float intersect(PVector origin, PVector dir) {
        PVector oc = PVector.sub(origin, center);
        float a = dir.dot(dir);
        float b = 2 * oc.dot(dir);
        float c = oc.dot(oc) - radius * radius;
        float discriminant = b*b - 4*a*c;

        if (discriminant < 0) return null;
        return (-b - sqrt(discriminant)) / (2 * a);
    }
    }

    public void draw(float time)
    {
    }
}
