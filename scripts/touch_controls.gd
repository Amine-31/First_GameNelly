extends CanvasLayer

const BTN_SIZE = 90.0      # حجم الزر (صغرو/كبرو)
const MARGIN = 30.0        # البعد على الحافة
const PRESS_SCALE = 0.85   # قد ما يصغر ملي تكليكي (1.0 = بلا تأثير)
const ALWAYS_SHOW = false   # من بعد بدلو لـ false

@export var tex_left: Texture2D
@export var tex_right: Texture2D
@export var tex_jump: Texture2D

var btn_left: TouchScreenButton
var btn_right: TouchScreenButton
var btn_jump: TouchScreenButton

func _ready():
	layer = 10
	if not ALWAYS_SHOW and not DisplayServer.is_touchscreen_available():
		visible = false
		return
	btn_left = _make_button(tex_left, "L_move")
	btn_right = _make_button(tex_right, "R_move")
	btn_jump = _make_button(tex_jump, "Jump")
	get_viewport().size_changed.connect(_layout)
	_layout()

func _make_button(tex: Texture2D, action_name: String) -> TouchScreenButton:
	var b = TouchScreenButton.new()
	b.texture_normal = tex
	b.action = action_name
	var base = 1.0
	if tex:
		base = BTN_SIZE / float(max(tex.get_width(), tex.get_height()))
	b.scale = Vector2(base, base)
	b.set_meta("base_scale", base)
	b.set_meta("origin", Vector2.ZERO)
	b.pressed.connect(_animate.bind(b, true))
	b.released.connect(_animate.bind(b, false))
	add_child(b)
	return b

func _animate(b: TouchScreenButton, is_pressed: bool):
	var base: float = b.get_meta("base_scale")
	var origin: Vector2 = b.get_meta("origin")
	var k = PRESS_SCALE if is_pressed else 1.0
	var size = Vector2(BTN_SIZE, BTN_SIZE)
	if b.texture_normal:
		size = b.texture_normal.get_size() * base
	var tw = create_tween().set_parallel(true)
	tw.tween_property(b, "scale", Vector2(base * k, base * k), 0.06)
	tw.tween_property(b, "position", origin + size * (1.0 - k) / 2.0, 0.06)
	tw.tween_property(b, "modulate", Color(1, 1, 1, 0.55) if is_pressed else Color.WHITE, 0.06)

func _place(b: TouchScreenButton, pos: Vector2):
	b.set_meta("origin", pos)
	b.position = pos

func _layout():
	var screen = get_viewport().get_visible_rect().size
	var y = screen.y - BTN_SIZE - MARGIN
	_place(btn_left, Vector2(MARGIN, y))
	_place(btn_right, Vector2(MARGIN * 2 + BTN_SIZE, y))
	_place(btn_jump, Vector2(screen.x - BTN_SIZE - MARGIN, y))
