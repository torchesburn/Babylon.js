precision highp float;

varying vec3 vPositionW;
varying vec3 vNormalW;

uniform sampler2D decalSampler;
uniform vec3 decalPosition;
uniform vec3 decalNormal;
uniform vec3 decalTangent;
uniform vec3 decalBinormal;
uniform vec2 decalSize;

// Optional: Control the sharpness of the decal's edge
uniform float decalFalloff; // e.g., 0.5 for smooth edges

void main(void) {
    // Vector from decal position to fragment position
    vec3 toFragment = vPositionW - decalPosition;

    // Distance from fragment to decal plane
    float distance = dot(toFragment, decalNormal);

    // Project toFragment onto the decal's plane
    vec3 projected = toFragment - decalNormal * distance;

    // Compute local (u,v) coordinates in the decal's plane
    float u = dot(projected, decalTangent) / decalSize.x + 0.5;
    float v = dot(projected, decalBinormal) / decalSize.y + 0.5;

    // Check if the fragment is within the decal boundaries
    if (u >= 0.0 && u <= 1.0 && v >= 0.0 && v <= 1.0) {
        // Compute the angle between the fragment normal and decal normal
        float normalAlignment = dot(normalize(vNormalW), decalNormal);

        // Optional: Apply falloff based on normal alignment
        float alpha = smoothstep(decalFalloff, 1.0, normalAlignment);

        // Sample the decal texture
        vec4 decalColor = texture2D(decalSampler, vec2(u, v));

        // Apply the decal color with alpha blending
        gl_FragColor = vec4(decalColor.rgb, decalColor.a * alpha);
    } else {
        // Discard the fragment or output the base color
        discard;
    }
}
