extends CollisionObject2D
class_name Piece

export(Array, Vector2) var relative_spaces
export(bool) var is_rotatable = true

onready var original_position : Vector2 = position
var is_placed = false

signal selected
signal deselected

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			emit_signal("selected")
#		else:
#			emit_signal("deselected")

