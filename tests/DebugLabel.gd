extends Label

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignal.listen("debug_label", self, "_on_Debug_label")

func _on_Debug_label(data):
	text = String(data.text)