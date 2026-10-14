extends Node

const LEVELS = [
	{"id": "level_1", "scene": "res://scenes/level_1.tscn", "three": 90.0, "two": 120.0},
	# {"id": "level_2", "scene": "res://scenes/level_2.tscn", "three": 180.0, "two": 210.0},
]

var current := 0

func is_unlocked(i: int) -> bool:
	if i == 0:
		return true
	return Settings.get_best_stars(LEVELS[i - 1]["id"]) >= 1
