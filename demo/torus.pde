class TorusScene extends EffectScene {

    public TorusScene(float startTime, float endTime) {
        super(startTime, endTime);
    }

    int numU = 10;  // Number of divisions in u-direction
    int numV = 10;  // Number of divisions in v-direction
    float R = 150;  // Major radius of the torus
    float r = 50;   // Minor radius of the torus
    float alpha = 0.15;  // Thermal diffusivity (heat equation parameter)
    float timeStep = 0.1;  // Time step for numerical solution
    float[][] uValues;  // Store the solution at each point
    float[][] uValuesOld;  // Store the previous time step for the heat equation
    float maxTime = 10;  // Maximum simulation time

    public void setup() {
        uValues = new float[numU][numV];
        uValuesOld = new float[numU][numV];
        
        // Initialize the solution at t = 0 with a heat source at the center
        for (int i = 0; i < numU; i++) {
            for (int j = 0; j < numV; j++) {
                float u = map(i, 0, numU, 0, TWO_PI);
                float v = map(j, 0, numV, 0, TWO_PI);
                
                // Initial condition: heat source near the center of the torus
                float distToCenter = dist(u, v, PI, PI); // Use distance from the center (u, v) coordinates
                uValues[i][j] = exp(-distToCenter * distToCenter / 0.1f);  // Gaussian-like heat distribution
                uValuesOld[i][j] = uValues[i][j];
            }
        }
    }

    public void draw(float time) {
        pushMatrix();
        translate(width/2, height/2);
        rotateY(time);

        background(20, 30, 50);  // Dark ocean-like background
        lights();
        
        // Solve the heat equation using finite differences
        for (int i = 1; i < numU - 1; i++) {
            for (int j = 1; j < numV - 1; j++) {
                // Apply finite difference for the heat equation: u_t = alpha * (u_xx + u_yy)
                float u_xx = uValues[i + 1][j] - 2 * uValues[i][j] + uValues[i - 1][j];
                float u_yy = uValues[i][j + 1] - 2 * uValues[i][j] + uValues[i][j - 1];
                
                // Discretized PDE solution update (forward Euler method)
                uValues[i][j] = uValuesOld[i][j] + alpha * (u_xx + u_yy) * timeStep;
            }
        }
        
        // Update the old values for the next iteration
        for (int i = 0; i < numU; i++) {
            for (int j = 0; j < numV; j++) {
                uValuesOld[i][j] = uValues[i][j];
            }
        }

        // Compute the center of the torus for camera positioning
        PVector torusCenter = new PVector(0, 0, 0);
        float du = TWO_PI / numU;
        float dv = TWO_PI / numV;

        // Find the minimum and maximum values of uValues to normalize the color scale
        float minVal = Float.MAX_VALUE;
        float maxVal = -Float.MAX_VALUE;
        for (int i = 0; i < numU; i++) {
            for (int j = 0; j < numV; j++) {
                minVal = min(minVal, uValues[i][j]);
                maxVal = max(maxVal, uValues[i][j]);
            }
        }

        // Render the torus with the solution applied to the surface
        for (int i = 0; i < numU - 1; i++) {  // Loop through all rows, including the last for wrapping
            int inext = (i + 1) % numU;   // Wrap around for seamless connection
            beginShape(TRIANGLE_STRIP);
            for (int j = 0; j <= numV; j++) {  // Go one past the end to wrap v
                int jmod = j % numV;           // Wrap v index

                // First vertex (i, jmod)
                float u = map(i, 0, numU, 0, TWO_PI);
                float v = map(jmod, 0, numV, 0, TWO_PI);
                float x1 = (R + r * cos(v)) * cos(u);
                float y1 = (R + r * cos(v)) * sin(u);
                float z1 = r * sin(v);
                float displacement1 = uValues[i][jmod];
                float normalizedVal1 = map(displacement1, minVal, maxVal, 0, 1);
                color c1 = lerpColor(color(0, 0, 255), color(255, 0, 0), normalizedVal1);
                fill(c1);
                stroke(255);
                vertex(x1 + displacement1, y1 + displacement1, z1 + displacement1);

                // Second vertex (inext, jmod)
                float unext = map(inext, 0, numU, 0, TWO_PI);
                float x2 = (R + r * cos(v)) * cos(unext);
                float y2 = (R + r * cos(v)) * sin(unext);
                float z2 = r * sin(v);
                float displacement2 = uValues[inext][jmod];
                float normalizedVal2 = map(displacement2, minVal, maxVal, 0, 1);
                color c2 = lerpColor(color(0, 0, 255), color(255, 0, 0), normalizedVal2);
                fill(c2);
                vertex(x2 + displacement2, y2 + displacement2, z2 + displacement2);
            }
            endShape();
        }
        
        // Optional: Rotate the torus over time
        popMatrix();
    }
}
