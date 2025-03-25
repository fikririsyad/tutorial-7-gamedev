extends Area3D

@export var sceneName := "Level 1"

func _on_body_entered(body):
	if body.get_name() == "Player":
		get_tree().call_deferred("change_scene_to_file", "res://scenes/" + sceneName + ".tscn")
