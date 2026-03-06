// Ghostty Shader - Minimalist Apple Aesthetic
// Subtle vignette and grain effect inspired by macOS design

#version 330 core

in vec2 fragTexture;
out vec4 fragColor;

uniform sampler2D textureIn;
uniform vec2 resolution;
uniform float time;

void main() {
    vec2 uv = fragTexture;
    
    // Sample base texture
    vec4 texColor = texture(textureIn, uv);
    
    // Subtle vignette effect (dark corners)
    vec2 center = uv - 0.5;
    float vignette = 1.0 - dot(center, center) * 0.25;
    vignette = mix(1.0, vignette, 0.15);
    
    // Minimal grain/noise for texture (0.003 intensity)
    float noise = fract(sin(dot(uv + time * 0.0001, vec2(12.9898, 78.233))) * 43758.5453);
    noise = (noise - 0.5) * 0.003;
    
    // Apply effects
    vec4 result = texColor;
    result.rgb = mix(result.rgb, result.rgb * vignette, 0.2);
    result.rgb += noise;
    
    fragColor = result;
}
