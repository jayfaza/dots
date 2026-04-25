// ── Resize: Liquid Crossfade ──────────────────────────────────────────────────
// При ресайзе старый и новый контент перетекают друг в друга.
// Граница между ними "плывёт" с лёгкой волной, а не режет прямой линией.

vec4 resize_color(vec3 coords_curr_geo, vec3 size_curr_geo) {
    float p = niri_clamped_progress;

    // Предыдущий кадр
    vec3 coords_prev = niri_geo_to_tex_prev * coords_curr_geo;
    vec4 color_prev = texture2D(niri_tex_prev, coords_prev.st);

    // Следующий кадр (stretch to current size)
    vec3 coords_next = niri_geo_to_tex_next * coords_curr_geo;
    vec4 color_next = texture2D(niri_tex_next, coords_next.st);

    // Волновая граница перехода
    // Граница движется по X (горизонтальный ресайз) и Y одновременно
    float freq = 8.0;
    float amp = 0.04 * sin(p * 3.14159);  // нарастает и спадает
    float wave_x = amp * sin(coords_curr_geo.y * freq * 3.14159);
    float wave_y = amp * sin(coords_curr_geo.x * freq * 3.14159 * 0.7);

    // Смещённая позиция для границы
    float blend_x = coords_curr_geo.x + wave_x;
    float blend_y = coords_curr_geo.y + wave_y;

    // Crossfade с liquid-границей: разные части окна переходят в разное время
    float offset = (wave_x + wave_y) * 0.5;
    float t = clamp(p + offset, 0.0, 1.0);

    // Smooth step для красивого перехода
    t = smoothstep(0.0, 1.0, t);

    vec4 color = mix(color_prev, color_next, t);

    // Лёгкий brightness flash на пике перехода (p ≈ 0.5)
    float flash = 0.08 * sin(p * 3.14159);
    color.rgb += flash * color.a;

    return color;
}
