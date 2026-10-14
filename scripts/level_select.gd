extends Control

const FONT = preload("res://assets/fonts/PixelOperator8.ttf")
const GOLD = Color(1, 0.8, 0.2)
const SLOTS = 10
const COLUMNS = 5
const StarScript = preload("res://scripts/star_icon.gd")

func _ready():
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var bg = ColorRect.new()
	bg.color = Color(0.12, 0.3, 0.45)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var title = _label("SELECT STAGE", 48, GOLD)
	title.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	title.offset_top = 30
	add_child(title)

	var center = CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var grid = GridContainer.new()
	grid.columns = COLUMNS
	grid.add_theme_constant_override("h_separation", 24)
	grid.add_theme_constant_override("v_separation", 24)
	center.add_child(grid)
	for i in SLOTS:
		grid.add_child(_make_cell(i))

	var back = _make_button("< BACK", Vector2(160, 48), 20)
	back.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	back.offset_left = 30
	back.offset_right = 190
	back.offset_top = -78
	back.offset_bottom = -30
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/main_menu.tscn"))
	add_child(back)

func _make_cell(i: int) -> Control:
	var in_list = i < Levels.LEVELS.size()
	var unlocked = in_list and Levels.is_unlocked(i)
	var box = VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)

	var btn = _make_button(str(i + 1) if unlocked else "?", Vector2(110, 110), 40)
	btn.disabled = not unlocked
	box.add_child(btn)

	var row = HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 4)
	box.add_child(row)
	var stars = Settings.get_best_stars(Levels.LEVELS[i]["id"]) if in_list else 0
	for s in 3:
		var star = StarScript.new()
		star.star_size = 28.0
		star.filled = s < stars
		row.add_child(star)

	if unlocked:
		btn.pressed.connect(_on_level_pressed.bind(i))
	else:
		box.modulate = Color(1, 1, 1, 0.5)
	return box

func _on_level_pressed(i: int):
	Levels.current = i
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _label(text: String, font_size: int, color := Color.WHITE) -> Label:
	var l = Label.new()
	l.text = text
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.add_theme_font_override("font", FONT)
	l.add_theme_font_size_override("font_size", font_size)
	l.add_theme_color_override("font_color", color)
	l.add_theme_color_override("font_outline_color", Color.BLACK)
	l.add_theme_constant_override("outline_size", 8)
	return l

func _make_button(text: String, min_size: Vector2, font_size: int) -> Button:
	var b = Button.new()
	b.text = text
	b.custom_minimum_size = min_size
	b.focus_mode = Control.FOCUS_NONE
	b.add_theme_font_override("font", FONT)
	b.add_theme_font_size_override("font_size", font_size)
	b.add_theme_color_override("font_color", Color.WHITE)
	b.add_theme_color_override("font_disabled_color", Color(0.7, 0.7, 0.7))
	for state in ["normal", "hover", "pressed", "disabled"]:
		var s = StyleBoxFlat.new()
		s.bg_color = Color(0.18, 0.28, 0.55, 0.95) if state == "hover" else Color(0.08, 0.12, 0.28, 0.95)
		s.border_color = GOLD
		s.set_border_width_all(4)
		b.add_theme_stylebox_override(state, s)
	return b
