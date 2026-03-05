// macOS-inspired: Clean, minimal, subtle
// Matches Apple's design language with minimal texture

uniform sampler2D iChannel0;
uniform vec3 iResolution;
uniform float iTime;

float noise(vec2 p) {
  return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = fragCoord.xy / iResolution.xy;
  vec4 term = texture(iChannel0, uv);
  
  // Apple's classic dark gray (matches system appearance)
  vec3 bg = vec3(0.11, 0.11, 0.11);  // #1c1c1c
  
  // Extremely subtle noise (barely visible)
  float subtle = (noise(uv * 200.0) - 0.5) * 0.003;
  bg += subtle;
  
  // Gentle vignette (Apple design touch)
  vec2 c = uv - 0.5;
  float vignette = smoothstep(0.7, 0.2, length(c));
  bg *= mix(0.98, 1.0, vignette);
  
  // Blend terminal content over background
  vec3 out_rgb = mix(bg, term.rgb, term.a);
  fragColor = vec4(out_rgb, 1.0);
}
