extends Node

onready var pack_button = $UI/Control/PackButton
onready var table = $Table

func _on_Table_table_updated(level_completed):
	pack_button.disabled = !level_completed

func _on_PackButton_pressed():
	get_tree().change_scene("res://level_select.tscn")
