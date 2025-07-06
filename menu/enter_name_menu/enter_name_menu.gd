extends Control

signal enter_pressed(_name: String)
@onready var text_edit: TextEdit = $TextEdit

func _on_enter_pressed() -> void:
	if text_edit.get_text():
		enter_pressed.emit(text_edit.get_text())
		
func _input(event):
	if event.is_action_pressed("ui_accept"):
		_on_enter_pressed()
