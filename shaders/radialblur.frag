uniform float time;

float PI = 3.1415926535;

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
    vec2 scale = love_ScreenSize.xy;
    vec4 total = Texel(tex, tc);
    float count = 1.0;
    for (float i = 0.0; i < 2.0 * PI; i += PI / 8.0) {
        vec4 pix = Texel(tex, tc + vec2(sin(i) * 9.0, cos(i) * 9.0) / scale);

        total += pix;

        count += 1.0;
    }

    return (total / count) * color;
}
