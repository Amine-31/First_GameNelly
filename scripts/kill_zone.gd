extends Area2D

func _on_body_entered(body: Node2D) -> void:
	var parent = get_parent()
	if parent.has_method("try_stomp") and parent.try_stomp(body):
		return
	var gm = get_tree().current_scene.get_node("Gamemanager")
	gm.kill_player(body)

func _on_timer_timeout() -> void:
	pass  # ما بقاش مستعمل، خليتو باش ما يخرجش خطأ من الـ signal
