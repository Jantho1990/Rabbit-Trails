extends Node2D

class_name Gizmo

export(int) var budget_cost = 1000 # Used by the Budget system.

enum COLLISION_LAYERS {
	PLACED = 4,
	MOVING = 8
}

var CollisionArea
var Placeable

func _ready():
	CollisionArea = get_node_or_null('CollisionArea')
	Placeable = get_node_or_null('Placeable')
	Selection.register_listener('select', self, '_on_Selection')
	Selection.register_listener('deselect', self, '_on_Deselection')

func _physics_process(delta):
	if Selection.selected_entity == self and Placeable.allowed_to_move and \
		not CollisionArea.collision_layer == COLLISION_LAYERS.MOVING:
			CollisionArea.collision_layer = COLLISION_LAYERS.MOVING
	if Selection.selected_entity == self:
		GlobalSignal.dispatch('debug_label', { 'text': CollisionArea.collision_layer })

func _exit_tree():
	Selection.unregister_listener('select', self, '_on_Selection')
	Selection.unregister_listener('deselect', self, '_on_Deselection')

func _on_Selection(selected_entity, previously_selected_entity):
	if self == selected_entity and Placeable.allowed_to_move:
		CollisionArea.collision_layer = COLLISION_LAYERS.MOVING

func _on_Deselection(previously_selected_entity):
	if self == previously_selected_entity:
		CollisionArea.collision_layer = COLLISION_LAYERS.PLACED