extends Node2D

@export var max_hp := 1            # 1 أخضر، 2 بنفسجي، 3 أحمر
@export var speed := 60.0
@export var bonus_time := 2.0      # ثواني كتنقص من العداد ملي يموت (من بعد)
@export var stomp_offset := 1.0    # لضبط الـ stomp

var direction := 1
var hp := 1
var dead := false
var invincible := false

@onready var ray_cast_r: RayCast2D = $RayCastR
@onready var ray_cast_l: RayCast2D = $RayCastL
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var kill_zone: Area2D = $"Kill zone"

func _ready():
	hp = max_hp

func _process(delta: float) -> void:
	if dead:
		return
	if ray_cast_r.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = true
	if ray_cast_l.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = false
	position.x += direction * speed * delta

# كيناديها Kill zone: ترجع true إلا كانت stomp (يعني اللاعب ما يموتش)
func try_stomp(body: Node2D) -> bool:
	if dead:
		return true
	if not ("velocity" in body):
		return false
	var from_above = body.velocity.y > 0 and body.global_position.y < global_position.y - stomp_offset
	if not from_above:
		return false
	if invincible:
		return true
	_take_hit(body)
	return true

func _take_hit(body: Node2D) -> void:
	hp -= 1
	body.velocity.y = -200   # ارتداد اللاعب
	if hp <= 0:
		_die()
		return
	invincible = true
	animated_sprite_2d.modulate = Color(3, 3, 3)   # flash أبيض
	var tw = create_tween()
	tw.tween_property(animated_sprite_2d, "modulate", Color.WHITE, 0.25)
	await get_tree().create_timer(0.3).timeout
	invincible = false

func _die() -> void:
	dead = true
	kill_zone.set_deferred("monitoring", false)
	var gm = get_tree().current_scene.get_node_or_null("Gamemanager")
	if gm and gm.has_method("on_slime_killed"):
		gm.on_slime_killed(bonus_time)
	var tw = create_tween().set_parallel(true)
	tw.tween_property(animated_sprite_2d, "scale", Vector2(1.3, 0.1), 0.2)
	tw.tween_property(animated_sprite_2d, "modulate:a", 0.0, 0.2)
	await tw.finished
	queue_free()
