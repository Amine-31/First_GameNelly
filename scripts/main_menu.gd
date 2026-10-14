extends Control

const FONT = preload("res://assets/fonts/PixelOperator8.ttf")
const GAME_SCENE = "res://scenes/level_select.tscn"
const GOLD = Color(1, 0.8, 0.2)

@onready var vbox: VBoxContainer = $VBoxContainer
@onready var play_button: Button = $VBoxContainer/PlayButton
@onready var quit_button: Button = $VBoxContainer/QuitButton
@onready var title_label: Label = find_child("TitleLabel", true, false)

var music_button: Button
var sfx_button: Button

func _ready():
	_setup_title()
	_setup_layout()
	_setup_toggles()
	for b in [play_button, quit_button, music_button, sfx_button]:
		_style_button(b)
	play_button.pressed.connect(func(): get_tree().change_scene_to_file(GAME_SCENE))
	quit_button.pressed.connect(func(): get_tree().quit())
	_refresh_toggles()

func _setup_title():
	if title_label.get_parent() != self:
		title_label.reparent(self)
	title_label.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	title_label.offset_top = 30
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_override("font", FONT)
	title_label.add_theme_font_size_override("font_size", 72)
	title_label.add_theme_color_override("font_color", GOLD)
	title_label.add_theme_color_override("font_outline_color", Color.BLACK)
	title_label.add_theme_constant_override("outline_size", 14)

func _setup_layout():
	vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	vbox.offset_bottom = -30
	vbox.alignment = BoxContainer.ALIGNMENT_END
	vbox.add_theme_constant_override("separation", 12)

func _setup_toggles():
	var row = HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 12)
	vbox.add_child(row)
	music_button = Button.new()
	sfx_button = Button.new()
	row.add_child(music_button)
	row.add_child(sfx_button)
	music_button.pressed.connect(func():
		Settings.set_music(not Settings.music_on)
		_refresh_toggles())
	sfx_button.pressed.connect(func():
		Settings.set_sfx(not Settings.sfx_on)
		_refresh_toggles())

func _refresh_toggles():
	music_button.text = "MUSIC: " + ("ON" if Settings.music_on else "OFF")
	sfx_button.text = "SFX: " + ("ON" if Settings.sfx_on else "OFF")

func _style_button(b: Button):
	var is_main = b == play_button or b == quit_button
	b.custom_minimum_size = Vector2(300 if is_main else 144, 56 if is_main else 44)
	b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	b.focus_mode = Control.FOCUS_NONE
	b.add_theme_font_override("font", FONT)
	b.add_theme_font_size_override("font_size", 28 if is_main else 18)
	b.add_theme_color_override("font_color", Color.WHITE)
	b.add_theme_color_override("font_hover_color", GOLD)
	b.add_theme_stylebox_override("normal", _box(Color(0.08, 0.12, 0.28, 0.92)))
	b.add_theme_stylebox_override("hover", _box(Color(0.18, 0.28, 0.55, 0.95)))
	b.add_theme_stylebox_override("pressed", _box(Color(0.04, 0.06, 0.15, 1)))

func _box(c: Color) -> StyleBoxFlat:
	var s = StyleBoxFlat.new()
	s.bg_color = c
	s.border_color = GOLD
	s.set_border_width_all(4)
	s.set_corner_radius_all(0)
	return s
