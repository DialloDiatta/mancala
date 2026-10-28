extends Control
class_name Cup

@onready var parent: Control = $".."
@onready var new_bead_resource: Bead = preload("res://resources/toys/positive_bead.tres")
var new_bead: PackedScene
var new_bead_value: int
var new_bead_texture

var hovering = false
var full = false

@onready var area_2d: Area2D = $Area2D
@onready var click_handler: ColorRect = $ClickHandler


var level

var piece_over_cup = null
var filling_piece = null

func _ready() -> void :
    SignalHandler.update_bead_resource.connect(_update_bead_resource)
    area_2d.area_entered.connect(_on_area_entered)
    area_2d.area_exited.connect(_on_area_exited)

    level = get_tree().current_scene.get_node("BlocksGroup")

    _update_bead_resource(new_bead_resource)

func _on_area_entered(area: Area2D) -> void :
    hovering = true
    piece_over_cup = area.get_parent()
    print("Cup -> Area2d Entered -> Update Emitted")
    SignalHandler.update_playspace.emit(area.get_parent().piece_value, "add")

func _on_area_exited(area: Area2D) -> void :
    var exiting_piece = area.get_parent()


    if exiting_piece == filling_piece:
        filling_piece = null
        full = false



    if exiting_piece == piece_over_cup:
        hovering = false
        piece_over_cup = null

    SignalHandler.update_playspace.emit(area.get_parent().piece_value, "erase")

func _input(event: InputEvent) -> void :
    if Input.is_action_just_released("click") and hovering == true and full == false:
        var tween = get_tree().create_tween()
        tween.set_parallel(true)
        tween.tween_property(piece_over_cup, "position", position, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

        if new_bead_resource is not RandomBead:

            tween.tween_property(piece_over_cup, "rotation", rotation, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
        full = true
        filling_piece = piece_over_cup













func _on_area_2d_mouse_entered() -> void :
    if parent.state == parent.States.FILL:
        print("create_bead_span : emitted")
        var area = $Area2D

        if new_bead_resource is RandomBead:
                new_bead_texture = new_bead_resource.pick_random_variation()
        SignalHandler.create_bead_span.emit(area, new_bead_resource)

func _on_area_2d_mouse_exited() -> void :
    pass

func _update_bead_resource(bead: Bead):

    if bead:
        new_bead_resource = bead
        new_bead = new_bead_resource.bead_scene
        new_bead_value = new_bead_resource.value
        new_bead_texture = new_bead_resource.texture
    else:
        pass
