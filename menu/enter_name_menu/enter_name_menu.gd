extends Control

signal enter_pressed(_name: String)
@onready var text_edit: TextEdit = $TextEdit

func _on_enter_pressed() -> void:
	enter_pressed.emit(text_edit.get_text())
