extends Node

const SAVE_PATH = "user://settings.cfg"
var music_on := true
var sfx_on := true
var cfg := ConfigFile.new()

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	cfg.load(SAVE_PATH)
	music_on = cfg.get_value("audio", "music", true)
	sfx_on = cfg.get_value("audio", "sfx", true)
	_apply()

func set_music(on: bool):
	music_on = on
	_apply()
	_save()

func set_sfx(on: bool):
	sfx_on = on
	_apply()
	_save()

func _apply():
	_mute("Music", not music_on)
	_mute("SFX", not sfx_on)

func _mute(bus_name: String, muted: bool):
	var i = AudioServer.get_bus_index(bus_name)
	if i != -1:
		AudioServer.set_bus_mute(i, muted)

func _save():
	cfg.set_value("audio", "music", music_on)
	cfg.set_value("audio", "sfx", sfx_on)
	cfg.save(SAVE_PATH)

# ---------- تقدم المراحل ----------
func get_best_time(id: String) -> float:
	return cfg.get_value("levels", id + "_time", -1.0)

func get_best_stars(id: String) -> int:
	return cfg.get_value("levels", id + "_stars", 0)

# كترجع true إلا كان هادا أحسن وقت
func save_result(id: String, time: float, stars: int) -> bool:
	var best = get_best_time(id)
	var is_new_best = best < 0.0 or time < best
	if is_new_best:
		cfg.set_value("levels", id + "_time", time)
	if stars > get_best_stars(id):
		cfg.set_value("levels", id + "_stars", stars)
	cfg.save(SAVE_PATH)
	return is_new_best
