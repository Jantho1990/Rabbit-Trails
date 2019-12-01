extends HBoxContainer

export(String) var stat_title = 'Stat'
export(String) var stat_content = '10000'

onready var eei_stat_title = $EEIStatTitle
onready var eei_stat_content = $EEIStatContent
onready var plus_sign = $PlusSign
onready var minus_sign = $MinusSign

# Called when the node enters the scene tree for the first time.
func _ready():
	eei_stat_title.text = stat_title
	set_content(stat_content)

func _set(property, value):
	match property:
		'stat_title':
			eei_stat_title.text = value
		'stat_content':
			set_content(value)
	
	self.set(property, value)

func set_content(value):
	eei_stat_content.text = value
	match int(sign(float(value))):
		1:
			plus_sign.show()
			minus_sign.hide()
		-1:
			plus_sign.hide()
			minus_sign.show()