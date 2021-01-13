extends CollisionObject2D
class_name Piece

export(Array, Vector2) var relative_spaces
export(bool) var moveable = true
export(bool) var rotatable = true
export(Vector2) var starts_placed_at = Vector2(-1,-1)
export(bool) var victory_requirement = false

onready var original_position : Vector2 = position
onready var original_relatives = relative_spaces.duplicate()
var placed = false

signal selected

func _ready():
	if starts_placed_at != Vector2(-1,-1):
		placed = true

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			emit_signal("selected")
