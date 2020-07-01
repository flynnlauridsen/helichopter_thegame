extends Node
# GLOBAL SCRIPT

func changeScene(path):
	get_tree().change_scene(path)
	
#	# Remove the current level
#	var level = get_tree().get_root().get_children()[0]
#	get_tree().get_root().remove_child(level)
#	level.call_deferred("queue_free")
#
#	# Add the next level
#	var next_level_resource = load(path)
#	var next_level = next_level_resource.instance()
#	get_tree().get_root().add_child(next_level)
