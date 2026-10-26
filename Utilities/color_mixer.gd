class_name ColorMixer

static func ryb_to_rgb(ryb: Vector3) -> Color:
	var r := ryb.x
	var y := ryb.y
	var b := ryb.z
	# Corner colors of the RYB cube (Gosset-Chen)
	var c000 := Vector3(1, 1, 1)
	var c100 := Vector3(1, 0, 0)
	var c010 := Vector3(1, 1, 0)
	var c110 := Vector3(1, 0.5, 0)
	var c001 := Vector3(0.163, 0.373, 0.6)
	var c101 := Vector3(0.5, 0, 0.5)
	var c011 := Vector3(0, 0.66, 0.2)
	var c111 := Vector3(0.2, 0.094, 0)
	var c00 := c000.lerp(c100, r)
	var c01 := c001.lerp(c101, r)
	var c10 := c010.lerp(c110, r)
	var c11 := c011.lerp(c111, r)
	var c0 := c00.lerp(c10, y)
	var c1 := c01.lerp(c11, y)
	var c := c0.lerp(c1, b)
	return Color(c.x, c.y, c.z)

static func rgb_to_ryb(c: Color) -> Vector3:
	var r := c.r
	var g := c.g
	var b := c.b
	var w := minf(r, minf(g, b))
	r -= w; g -= w; b -= w
	var mg := maxf(r, maxf(g, b))
	var y := minf(r, g)
	r -= y; g -= y
	if b > 0.0 and g > 0.0:
		b /= 2.0; g /= 2.0
	y += g
	b += g
	var my := maxf(r, maxf(y, b))
	if my > 0.0:
		var n := mg / my
		r *= n; y *= n; b *= n
	return Vector3(r, y, b)

static func mix_rgb(colors: Array, weights: Array) -> Color:
	var ryb_sum := Vector3.ZERO
	var ryb_total := 0.0
	var v_sum := 0.0
	var total := 0.0
	for i in colors.size():
		var c: Color = colors[i]
		var v := maxf(c.r, maxf(c.g, c.b))
		if v > 0.0:
			var base := Color(c.r / v, c.g / v, c.b / v)
			ryb_sum += rgb_to_ryb(base) * (weights[i] * v)
			ryb_total += weights[i] * v
		v_sum += v * weights[i]
		total += weights[i]
	if total <= 0.0 or ryb_total <= 0.0:
		return Color.BLACK
	var result := ryb_to_rgb(ryb_sum / ryb_total)
	var v_mix := v_sum / total
	return Color(result.r * v_mix, result.g * v_mix, result.b * v_mix)
