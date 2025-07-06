extends Control

signal on_video_finished
@onready var video_stream_player: VideoStreamPlayer = $VideoStreamPlayer
const INTRO = preload("res://sprites/intro.ogv")


func play_video():
	print(INTRO)
	video_stream_player.stream = INTRO
	video_stream_player.play()

func _on_video_stream_player_finished() -> void:
	on_video_finished.emit()
	video_stream_player.stream = null
