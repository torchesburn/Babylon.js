precision highp float;

attribute vec3 position; // Vertex position attribute
attribute vec2 uv; // Vertex UV coordinates attribute

varying vec2 vDecalTC; // Texture coordinates from the decal
varying vec2 vUV; // Original UV coordinates

uniform sampler2D textureSampler; // The main texture sampler for decals
uniform sampler2D maskTexture; // The mask texture for seams

void main(void) {
    // Pass UV coordinates to the fragment shader
    vUV = uv;

    // Sample the center pixel and surrounding pixels from the mask texture
    float centerPixel = texture2D(maskTexture, vUV).r;
    float rightPixel = texture2D(maskTexture, vUV + vec2(0.1, 0.0)).r;
    float leftPixel = texture2D(maskTexture, vUV - vec2(.1, 0.0)).r;
    float topPixel = texture2D(maskTexture, vUV + vec2(0.0, 0.1)).r;
    float bottomPixel = texture2D(maskTexture, vUV - vec2(0.0, 0.1)).r;

    // Check if the current pixel is near a seam (center pixel is white)
    bool nearSeam = centerPixel > 0.5;

    // Check if any of the neighboring pixels are black (outside the UV island)
    bool adjacentToBlack = (rightPixel < 0.5 || leftPixel < 0.5 || topPixel < 0.5 || bottomPixel < 0.5);

    // If near the seam and adjacent to black, use the original vertex position
    if (nearSeam && adjacentToBlack) {
        // Transform vertex position (you can apply your world-view-projection matrix here)
        vec4 transformedPosition = vec4(position, 1.0);

        // Pass the transformed position to the fragment shader
        gl_Position = transformedPosition;

        // You can also pass additional data to the fragment shader if needed
        // (e.g., normals, tangents, etc.)
    } else {
        // Discard vertices that are not near the seam or not adjacent to black
        gl_Position = vec4(0.0); // Or any other value to discard
    }
}
