extends Control

enum States{FILL, CLEAR, REST}

var state = States.REST

@onready var abacus: TextureRect = $Abacus





func _ready() -> void :
    abacus.texture = SkinManager.set_skin("board")
    SignalHandler.create_bead_span.connect(create_bead_span)
    SignalHandler.clear_bead.connect(clear_bead)


func _on_abacus_gui_input(event: InputEvent) -> void :
    if event.is_action_pressed("click"):
        change_state(States.FILL)

    set_board_rest(event)

func _on_outside_gui_input(event: InputEvent) -> void :
    if event.is_action_pressed("click"):
        change_state(States.CLEAR)


    set_board_rest(event)

func set_board_rest(event):
    if event.is_action_released("click"):
        change_state(States.REST)




func change_state(newState):
    state = newState

func create_bead_span(area, bead):


    var new_block = bead.bead_scene
    var new_block_value = bead.value
    var new_block_texture

    if bead is RandomBead:
        new_block_texture = bead.pick_random_variation()
    else:
        new_block_texture = bead.texture


    var level

    var collision_shape = area.get_child(0)


    var shape_extents
    if collision_shape is CollisionShape2D and collision_shape.shape is RectangleShape2D:
        shape_extents = collision_shape.shape.extents
    elif collision_shape is CollisionPolygon2D:

        var polygon = collision_shape.polygon
        var min_x = 999999
        var max_x = -999999
        var min_y = 999999
        var max_y = -999999
        for point in polygon:
            min_x = min(min_x, point.x)
            max_x = max(max_x, point.x)
            min_y = min(min_y, point.y)
            max_y = max(max_y, point.y)
        shape_extents = Vector2((max_x - min_x) / 2, (max_y - min_y) / 2)
    else:

        shape_extents = Vector2(50, 50)


    var random_x = randf_range( - shape_extents.x, shape_extents.x)
    var random_y = randf_range( - shape_extents.y, shape_extents.y)
    var random_position = area.global_position + Vector2(random_x, random_y)


    var instance = new_block.instantiate()
    level = get_tree().current_scene.get_node("BlocksGroup")

    get_parent().add_child(instance)
    instance.get_node("Object").texture = new_block_texture
    instance.add_to_group("pieces")
    instance.piece_value = new_block_value
    if instance.piece_value == new_block_value:
        print("Instance Block Value Set : ", new_block_value)
    instance.position = random_position

    if bead is RandomBead:
        if bead.random_rotation:
            print("Random Rotation Triggered")
            var random_rotation = randf() * 2 * PI
            instance.rotation = random_rotation
            instance.wobble = false

    SignalHandler.update_playspace_span.emit(new_block_value, "add")

func clear_bead(bead, piece_value):
    if state == States.CLEAR:
        bead.queue_free()
        SignalHandler.update_playspace.emit(bead, "erase")
