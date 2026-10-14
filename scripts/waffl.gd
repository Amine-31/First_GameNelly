extends Area2D

func _ready():
	print("Waffl ready at: ", global_position)
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	print("Waffl touched by: ", body.name)
	var gm = get_tree().current_scene.get_node("Gamemanager")
	if gm.add_heart():
		queue_free()
