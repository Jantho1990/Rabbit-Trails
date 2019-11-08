extends "res://containers/EntityContainer/EntityContainer.gd"

func _init().():
	container_type = "Bullet"
	container_callback = "on_Add_bullet"

# Create and fire a bullet
func on_Add_bullet(data):
	# Setup
	var bullet = data.Bullet.instance()
	bullet.origin = data.origin
	bullet.dir = data.direction
	bullet.speed = data.speed
	
	# Add nodes we don't want to collide with
	for colex in data.collision_exceptions:
		bullet.add_collision_exception_with(colex)
	
	# Add to the BulletContainer tree
	add_child(bullet)