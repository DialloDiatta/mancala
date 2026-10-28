extends Control

func _ready() -> void :
    SignalHandler.create_bead.connect(create_bead)


func create_bead(new_block, new_block_value, new_block_texture):

    var new_instance = new_block.instantiate()
    add_child(new_instance)
    new_instance.add_to_group("pieces")
    new_instance.position = get_global_mouse_position()
    new_instance.is_dragging = true


    new_instance.piece_value = new_block_value
    new_instance.get_node("Object").texture = new_block_texture

    print("Created")
