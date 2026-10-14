extends Control

var filled := true
var star_size := 72.0

func _ready():
	custom_minimum_size = Vector2(star_size, star_size)

func _draw():
	var c = Vector2(star_size, star_size) / 2.0
	var big_r = star_size / 2.0 - 3.0
	var pts = PackedVector2Array()
	for i in 10:
		var r = big_r if i % 2 == 0 else big_r * 0.41
		var a = -PI / 2.0 + i * PI / 5.0
		pts.append(c + Vector2(cos(a), sin(a)) * r)
	var col = Color(1, 0.8, 0.2) if filled else Color(0.25, 0.25, 0.3)
	draw_colored_polygon(pts, col)
	var outline = pts.duplicate()
	outline.append(pts[0])
	draw_polyline(outline, Color.BLACK, maxf(2.0, star_size / 18.0))
