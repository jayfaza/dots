// ── Open: Ripple Portal ───────────────────────────────────────────────────────
// Окно появляется из центра — круговая волна расходится от точки открытия,
// при этом поверхность слегка "дышит" как вода.

vec4 open_color(vec3 coords_geo, vec3 size_geo) {
    float p = niri_clamped_progress;

    // Масштаб: окно вырастает из нуля
    float scale = p;
    vec2 center = vec2(0.5, 0.5);
    vec2 uv = (coords_geo.xy - center) / max(scale, 0.0001) + center;
    vec3 coords_scaled = vec3(uv, 1.0);

    // Ripple distortion — волна, бегущая от центра
    vec2 delta = coords_geo.xy - center;
    float dist = length(delta * size_geo.xy);
    float wave_speed = 6.0;
    float wave_amp = 0.012 * (1.0 - p);  // затухает к концу
    float wave = sin(dist * wave_speed - p * 14.0) * wave_amp;
    vec2 dir = length(delta) > 0.0001 ? normalize(delta) : vec2(0.0);
    coords_scaled.xy += dir * wave;

    // Сэмплируем текстуру
    vec3 coords_tex = niri_geo_to_tex * coords_scaled;
    vec4 color = texture2D(niri_tex, coords_tex.st);

    // Clip за пределами геометрии — прозрачно
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0)
        color = vec4(0.0);

    // Fade in + небольшой brightness burst в начале
    float brightness = 1.0 + 0.3 * (1.0 - p) * (1.0 - p);
    color.rgb *= brightness;
    color *= p;

    return color;
}
