extends Control

var filled := true

func _ready():
	custom_minimum_size = Vector2(72, 72)

func _draw():
	var c = size / 2.0
	var pts = PackedVector2Array()
	for i in 10:
		var r = 34.0 if i % 2 == 0 else 14.0
		var a = -PI / 2.0 + i * PI / 5.0
		pts.append(c + Vector2(cos(a), sin(a)) * r)
	var col = Color(1, 0.8, 0.2) if filled else Color(0.25, 0.25, 0.3)
	draw_colored_polygon(pts, col)
	var outline = pts.duplicate()
	outline.append(pts[0])
	draw_polyline(outline, Color.BLACK, 4.0)
