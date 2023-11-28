precision highp float;

// Varying
varying vec2 vUV; // The UV coordinate
varying vec3 vDecalPos; // The transformed position for the decal

// Samplers
uniform sampler2D textureSampler; // The main texture sampler
uniform sampler2D decalTexture; // The decal texture

void main(void) {
    // Sample the main texture
    vec4 mainColor = texture2D(textureSampler, vUV);

    // Sample the decal texture
    // You may need to transform vDecalPos to proper UVs for decalTexture
    vec4 decalColor = texture2D(decalTexture, vDecalPos.xy);

    // Blend the decal with the main texture based on decal alpha
    gl_FragColor = mix(mainColor, decalColor, decalColor.a);
}
