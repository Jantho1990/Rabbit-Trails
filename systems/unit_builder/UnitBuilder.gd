extends Node

#export(Array, Array, String, FILE, "*.tscn") var buildable_units = []

# Path to directory containing buildable units.
export(String) var buildable_units_path = ''

# List of names of buildable units.
export(Array, String) var buildable_unit_names = []

var buildable_units = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignal.listen('build_unit', self, '_on_Build_unit')
	
	if buildable_units_path.substr(buildable_units_path.length() - 1, 1) != '/':
		buildable_units_path = buildable_units_path + '/'
	
	# Preload all entites.
	for unit_name in buildable_unit_names:
		var path = buildable_units_path + unit_name + '.tscn'
		print('path', path)
		var buildable_unit = load(buildable_units_path + unit_name + '.tscn')
		buildable_units[unit_name] = buildable_unit

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Build_unit(data):
	print('data', data)
#	breakpoint
	var unit_name = data.unit_name
	
	if buildable_units.has(unit_name):
		print('Building unit ', unit_name)
		var buildable_unit = buildable_units[unit_name]
		var unit = buildable_unit.instance()
		GlobalSignal.dispatch("add_" + unit_name, {
			'entity': unit,
			'instance': false,
			'container_id': unit_name
		})