// ── Close: Vortex Dissolve ────────────────────────────────────────────────────
// Окно закрывается засасываясь в центр по спирали.
// Края закручиваются и растворяются быстрее центра.

vec4 close_color(vec3 coords_geo, vec3 size_geo) {
    float p = niri_clamped_progress;        // 0 → 1 (закрытие)
    float inv = 1.0 - p;

    vec2 center = vec2(0.5, 0.5);
    vec2 delta = coords_geo.xy - center;

    // Расстояние от центра (с учётом aspect ratio)
    float aspect = size_geo.x / size_geo.y;
    vec2 delta_scaled = delta * vec2(aspect, 1.0);
    float dist = length(delta_scaled);

    // Вращение — края крутятся сильнее центра
    float angle = p * 4.0 * dist * 6.2832;  // до 4π на краях
    float s = sin(angle);
    float c = cos(angle);
    vec2 rotated = vec2(
        delta.x * c - delta.y * s,
        delta.x * s + delta.y * c
    );

    // Стягивание к центру — нелинейно (быстрее в конце)
    float pull = 1.0 - p * p * (1.5 - 0.5 * p * p);
    vec2 uv = center + rotated * pull;

    vec3 coords_transformed = vec3(uv, 1.0);
    vec3 coords_tex = niri_geo_to_tex * coords_transformed;
    vec4 color = texture2D(niri_tex, coords_tex.st);

    // Clip за пределами
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0)
        color = vec4(0.0);

    // Fade out: края исчезают раньше центра
    float edge_fade = 1.0 - smoothstep(0.0, 1.0, dist * 1.4);
    float alpha = inv * (0.3 + 0.7 * edge_fade);
    color *= alpha;

    return color;
}
