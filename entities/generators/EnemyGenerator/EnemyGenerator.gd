extends "res://entities/generators/EntityGenerator/EntityGenerator.gd"

class_name EnemyGenerator

# If set, all spawned entities will start out moving toward the specified target's position.
export(NodePath) var target = null

func _ready():
	GlobalSignal.listen("enemy_dead", self, "on_Enemy_dead")

func on_Enemy_dead(data):
	var enemy = data.enemy
	if enemy.get("generator") != null and enemy.generator == self:
		entity_count -= 1

func make_entity():
	var new_entity = Entity.instance()
	new_entity.generator = self
	
	if not randomize_spawn:
		new_entity.position = self.position
	else:
		map.random_spawn(new_entity)
		
	if target != null and typeof(target) != 15: # Nodepath
		new_entity.set_target(target)
	
	entity_count += 1
	print("Entity Count: ", entity_count, " for ", target_container_id)
	
	GlobalSignal.dispatch("add_enemy", {
		"enemy": new_entity,
		"instance": false,
		"container_id": target_container_id
	})