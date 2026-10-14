extends TileMapLayer
## Test level generator for world_tileset.png (16x16 tiles).
## Attach to the TileMapLayer node, then run the scene (F6).

const SRC := 0  # atlas source id (first atlas in the TileSet = 0)

# Atlas coords (column, row) from world_tileset.png
const GRASS := Vector2i(0, 0)
const DIRT := Vector2i(0, 1)
const ROCK := Vector2i(1, 1)
const Q_BLOCK := Vector2i(0, 2)
const EX_BLOCK := Vector2i(1, 2)
const WATER_TOP := Vector2i(4, 9)
const WATER := Vector2i(4, 10)
const TREE_TOP := Vector2i(0, 3)
const TREE_MID := Vector2i(0, 4)
const TREE_BASE := Vector2i(0, 5)
const BUSH := Vector2i(1, 4)
const SIGN := Vector2i(8, 3)
const FENCE := Vector2i(9, 3)
const MUSHROOM_RED := Vector2i(7, 5)
const MUSHROOM_ORANGE := Vector2i(7, 6)
const PUMPKIN := Vector2i(4, 8)

@export var ground_y := 5        # row of the grass surface (increase = lower)
@export var x_start := -10
@export var x_end := 45
@export var rebuild_on_ready := true


func _ready() -> void:
	if rebuild_on_ready:
		build()


func build() -> void:
	clear()

	# Ground, with a water pit between x=14..17
	for x in range(x_start, x_end + 1):
		if x >= 14 and x <= 17:
			_pit_column(x)
		else:
			_ground_column(x)

	# Staircase (x=22..25)
	for i in range(4):
		for h in range(i + 1):
			put(22 + i, ground_y - 1 - h, GRASS if h == i else DIRT)

	# Floating grass platform
	for x in range(28, 32):
		put(x, ground_y - 3, GRASS)

	# Question / exclamation blocks
	put(34, ground_y - 4, Q_BLOCK)
	put(35, ground_y - 4, EX_BLOCK)
	put(36, ground_y - 4, Q_BLOCK)

	# Decoration
	_tree(3)
	_tree(19)
	put(6, ground_y - 1, BUSH)
	put(-2, ground_y - 1, SIGN)
	put(10, ground_y - 1, FENCE)
	put(11, ground_y - 1, FENCE)
	put(20, ground_y - 1, MUSHROOM_RED)
	put(27, ground_y - 1, MUSHROOM_ORANGE)
	put(40, ground_y - 1, PUMPKIN)


func put(x: int, y: int, tile: Vector2i) -> void:
	set_cell(Vector2i(x, y), SRC, tile)


func _ground_column(x: int) -> void:
	put(x, ground_y, GRASS)
	put(x, ground_y + 1, DIRT)
	put(x, ground_y + 2, ROCK)
	put(x, ground_y + 3, ROCK)


func _pit_column(x: int) -> void:
	put(x, ground_y, WATER_TOP)
	put(x, ground_y + 1, WATER)
	put(x, ground_y + 2, ROCK)
	put(x, ground_y + 3, ROCK)


func _tree(x: int) -> void:
	put(x, ground_y - 3, TREE_TOP)
	put(x, ground_y - 2, TREE_MID)
	put(x, ground_y - 1, TREE_BASE)
