uniform number time;
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
    vec4 pix = Texel(texture, texture_coords) * color;
    float avg = (pix.r + pix.g + pix.b) / 3.0;
    pix.r = avg;
    pix.g = avg;
    pix.b = avg;

    return pix;
}
