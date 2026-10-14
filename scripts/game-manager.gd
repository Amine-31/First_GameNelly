extends Node

const MAX_HEARTS = 3
const HEART_TEXTURE = preload("res://assets/sprites/Heart.png")
@onready var menu_button: Button = $"../HUD/GameOverPanel/VBoxContainer/MenuButton"
@onready var timer_label: Label = $"../HUD/TimerLabel"
@onready var scor_label: Label = $"../HUD/CoinsBar/SccorLabel"
@onready var game_over_panel: Control = $"../HUD/GameOverPanel"
@onready var retry_button: Button = $"../HUD/GameOverPanel/VBoxContainer/RetryButton"
@onready var hearts_bar: HBoxContainer = $"../HUD/HeartsBar"
@onready var spawn_point: Marker2D = $"../Level_1/SpawnPoint"
@export var level_id := "level_1"   # كل مرحلة عندها id مختلف
const FONT = preload("res://assets/fonts/PixelOperator8.ttf")

@export var three_star_time := 90.0   # 1:30
@export var two_star_time := 120.0    # 2:00
@export_file("*.tscn") var next_level := ""

var dying := false
var scor = 0
var hearts = MAX_HEARTS
var invincible := false
var heart_icons: Array[TextureRect] = []
var total_coins := 0
var time := 0.0
var running := false
var level_done := false

func _ready():
	$"../Player2".global_position = spawn_point.global_position
	retry_button.pressed.connect(_on_retry_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	game_over_panel.visible = false
	_build_hearts()
	total_coins = get_tree().get_nodes_in_group("coins").size()
	print("Total coins: ", total_coins)
	_update_label()
	_update_hearts()
	
func _fmt(t: float) -> String:
	return "%d:%02d" % [int(t) / 60, int(t) % 60]
func _process(delta: float) -> void:
	if level_done:
		return
	if not running:
		var moved = Input.get_axis("L_move", "R_move") != 0
		if moved or Input.is_action_just_pressed("Jump"):
			running = true
		return
	time += delta / maxf(Engine.time_scale, 0.01)
	_update_timer()
	
func on_slime_killed(bonus_time: float):
	time = maxf(0.0, time - bonus_time)
	_update_timer()
	
func _update_timer():
	timer_label.text = "%d:%02d" % [int(time) / 60, int(time) % 60]
	
func _on_menu_pressed():
	get_tree().paused = false
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _update_label():
	scor_label.text = "%d/%d" % [scor, total_coins]

func add_point():
	scor += 1
	_update_label()
	if total_coins > 0 and scor >= total_coins:
		_level_complete()

func get_stars() -> int:
	if time <= three_star_time:
		return 3
	if time <= two_star_time:
		return 2
	return 1

func _level_complete():
	level_done = true
	running = false
	var stars = get_stars()
	var previous_best = Settings.get_best_time(level_id)
	var is_new_best = Settings.save_result(level_id, time, stars)
	print("LEVEL COMPLETE! Time: ", snappedf(time, 0.01), " s | Stars: ", stars)
	await get_tree().create_timer(0.8, true, false, true).timeout
	_show_complete_panel(stars, is_new_best, previous_best)

func _show_complete_panel(stars: int, is_new_best: bool, previous_best: float):
	get_tree().paused = true
	var panel = ColorRect.new()
	panel.color = Color(0, 0, 0, 0.75)
	panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	$"../HUD".add_child(panel)

	var box = VBoxContainer.new()
	box.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 18)
	panel.add_child(box)

	box.add_child(_label("LEVEL COMPLETE", 48, Color(1, 0.8, 0.2)))
	box.add_child(_label("TIME  %d:%02d" % [int(time) / 60, int(time) % 60], 28))
	if is_new_best:
		box.add_child(_label("NEW BEST!", 24, Color(0.4, 1, 0.4)))
	else:
		box.add_child(_label("BEST  " + _fmt(previous_best), 20, Color(0.8, 0.8, 0.8)))
	var row = HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 14)
	box.add_child(row)
	for i in 3:
		var star = preload("res://scripts/star_icon.gd").new()
		star.filled = i < stars
		star.pivot_offset = Vector2(36, 36)
		star.scale = Vector2.ZERO
		row.add_child(star)
		star.create_tween().tween_property(star, "scale", Vector2.ONE, 0.25).set_delay(0.3 * (i + 1))

	box.add_child(_button("RETRY", _on_retry_pressed))
	if next_level != "":
		box.add_child(_button("NEXT LEVEL", _on_next_pressed))
	box.add_child(_button("MENU", _on_menu_pressed))

func _on_next_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(next_level)

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

func _button(text: String, on_press: Callable) -> Button:
	var b = Button.new()
	b.text = text
	b.custom_minimum_size = Vector2(260, 52)
	b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	b.focus_mode = Control.FOCUS_NONE
	b.add_theme_font_override("font", FONT)
	b.add_theme_font_size_override("font_size", 24)
	for state in ["normal", "hover", "pressed"]:
		var s = StyleBoxFlat.new()
		s.bg_color = Color(0.18, 0.28, 0.55, 0.95) if state == "hover" else Color(0.08, 0.12, 0.28, 0.95)
		s.border_color = Color(1, 0.8, 0.2)
		s.set_border_width_all(4)
		b.add_theme_stylebox_override(state, s)
	b.pressed.connect(on_press)
	return b

func _build_hearts():
	for i in MAX_HEARTS:
		var icon = TextureRect.new()
		icon.texture = HEART_TEXTURE
		icon.custom_minimum_size = Vector2(32, 32)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		hearts_bar.add_child(icon)
		heart_icons.append(icon)

func _update_hearts():
	for i in MAX_HEARTS:
		heart_icons[i].modulate = Color.WHITE if i < hearts else Color(0.15, 0.15, 0.15, 0.6)

func add_heart() -> bool:
	if hearts >= MAX_HEARTS:
		return false
	hearts += 1
	_update_hearts()
	return true
func kill_player(body: Node2D):
	if dying or invincible or level_done:		return
	dying = true
	print("You died")
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").set_deferred("disabled", true)
	await get_tree().create_timer(1.0, true, false, true).timeout  # كيتجاهل time_scale
	Engine.time_scale = 1
	dying = false
	lose_heart(body)
func lose_heart(body: Node2D):
	hearts -= 1
	print("Hearts left: ", hearts)
	_update_hearts()
	if hearts <= 0:
		game_over()
	else:
		respawn(body)

func respawn(body: Node2D):
	print("Respawn at: ", spawn_point.global_position)
	body.global_position = spawn_point.global_position
	if "velocity" in body:
		body.velocity = Vector2.ZERO
	body.get_node("CollisionShape2D").set_deferred("disabled", false)
	invincible = true
	await get_tree().create_timer(1.0).timeout
	invincible = false

func game_over():
	game_over_panel.visible = true
	get_tree().paused = true

func _on_retry_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
