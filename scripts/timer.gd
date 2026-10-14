extends Area2D
@onready var timer: Timer = $Timer
var dying_body: Node2D = null

func _ready():
	timer.one_shot = true

func _on_body_entered(body: Node2D) -> void:
	if dying_body:
		return
	print("You died")
	dying_body = body
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").set_deferred("disabled", true)
	timer.start()

func _on_timer_timeout() -> void:
	if dying_body == null:
		return
	Engine.time_scale = 1
	var gm = get_tree().current_scene.get_node("Gamemanager")
	gm.lose_heart(dying_body)
	dying_body = null
