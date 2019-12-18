uniform float time;

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
    vec2 scale = love_ScreenSize.xy;

    vec4 topleft  = Texel(tex, (tc + vec2(-1.0, -1.0) / scale));
    vec4 top      = Texel(tex, (tc + vec2(0,    -1.0) / scale));
    vec4 topright = Texel(tex, (tc + vec2(1.0,  -1.0) / scale));

    vec4 left     = Texel(tex, (tc + vec2(-1.0, 0) / scale));
    vec4 curr     = Texel(tex, tc);
    vec4 right    = Texel(tex, (tc + vec2(1.0, 0) / scale));

    vec4 botleft  = Texel(tex, (tc + vec2(-1.0, 1.0) / scale));
    vec4 bottom   = Texel(tex, (tc + vec2(0, 1.0) / scale));
    vec4 botright = Texel(tex, (tc + vec2(1.0, 1.0) / scale));

    vec4 avg = (topleft + top + topright + left + curr + right + botleft + bottom + botright) / 9.0;

    // return vec4(abs(sin(time) / 2), curr.g, curr.b, curr.a) * color;
    //  return Texel(tex, tc) * color;
    return avg * color;
}
