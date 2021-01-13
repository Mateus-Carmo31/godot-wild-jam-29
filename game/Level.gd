extends Node

onready var pack_button = $UI/Control/Button
onready var table = $Table

func _on_Table_table_updated(level_completed):
	pack_button.disabled = !level_completed
