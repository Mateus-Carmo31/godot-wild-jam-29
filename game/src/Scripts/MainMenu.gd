extends Control

func _ready():
	$Buttons.show()
	$Credits.hide()

func show_credits():
	$Buttons.hide()
	$Credits.show()

func hide_credits():
	$Credits.hide()
	$Buttons.show()

func _on_Play_pressed():
	print("Start game!")

func _on_Exit_pressed():
	get_tree().quit()
