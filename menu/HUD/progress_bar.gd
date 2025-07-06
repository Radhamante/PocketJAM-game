extends ProgressBar

var total_time = 180.0
var elapsed_time = 0.0

func _ready():
	value = max_value
	show_percentage = false
	visible = false

func _process(delta):
	visible = true
	elapsed_time += delta
	if elapsed_time > total_time:
		elapsed_time = total_time
	value = (elapsed_time / total_time) * max_value
	var ratio = elapsed_time / total_time
