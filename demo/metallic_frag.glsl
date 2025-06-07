// metallic.frag
#version 150

in vec3 vNormal;
in vec3 vPosition;

out vec4 fragColor;

uniform vec3 lightDir = normalize(vec3(0.5, 1.0, 0.3));
uniform vec3 viewDir = normalize(vec3(0.0, 0.0, 1.0));

void main() {
    vec3 N = normalize(vNormal);
    vec3 L = normalize(lightDir);
    vec3 V = normalize(-vPosition);
    vec3 R = reflect(-L, N);

    float diffuse = max(dot(N, L), 0.0);
    float specular = pow(max(dot(R, V), 0.0), 64.0); // Sharp highlight

    vec3 baseColor = vec3(0.9, 0.25, 0.3); // Light metal
    vec3 metalColor = baseColor * 0.3 + vec3(specular) * 0.7;

    fragColor = vec4(metalColor * diffuse + vec3(specular * 0.8), 1.0);
}