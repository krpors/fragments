uniform number time;
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec2 direction = vec2(-5.0, -0.0) / love_ScreenSize.xy;

    vec4 pix = Texel(texture, texture_coords);

    float r = Texel(texture, texture_coords - direction).r;
    float g = Texel(texture, texture_coords).g;
    float b = Texel(texture, texture_coords + direction).b;

    return vec4(r,g,b, pix.a);
}
