extends Area2D
@onready var gamemanager: Node = get_tree().current_scene.get_node("Gamemanager")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var collected := false

func _enter_tree():
	add_to_group("coins")

func _on_body_entered(_body: Node2D) -> void:
	if collected:
		return
	collected = true
	gamemanager.add_point()
	print("+1 coin")
	animation_player.play("Pickup")
