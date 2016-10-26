
extends Node

func adjust_properties(button_id, type, pos_x, pos_y, object_id, database):
	set_pos(Vector2(pos_x, pos_y))
	if (type == "attack"):
		pass #mudar a textura para ficar com o fundo vermelho, fazer para o resto (skills e items)
	
	
	
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


