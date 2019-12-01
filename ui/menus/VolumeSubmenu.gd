extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/VBoxContainer/Master/HSlider.connect('value_changed', self, '_on_Master_volume_changed')
	$MarginContainer/VBoxContainer/SFX/HSlider.connect('value_changed', self, '_on_SFX_volume_changed')
	$MarginContainer/VBoxContainer/Music/HSlider.connect('value_changed', self, '_on_Music_volume_changed')

func _on_Master_volume_changed(value):
	Sound.set_volume("Master", value)

func _on_SFX_volume_changed(value):
	Sound.set_volume("SFX", value)

func _on_Music_volume_changed(value):
	Sound.set_volume("Music", value)