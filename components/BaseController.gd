extends Control


@export_group("Bead")
@export var new_bead_resource: Bead

var new_bead: PackedScene
var new_bead_value: int
var new_bead_texture

@export_group("Cup")
@export_file() var base_texture
@export var base_beads_texture: Texture2D
@export var board: Control

@onready var cup: TextureRect = $Cup
@onready var beads: TextureRect = $Beads

var level

func _ready():
    cup.texture = SkinManager.set_skin("cup")
    beads.texture = base_beads_texture
    self.gui_input.connect(_on_gui_input)
    await get_tree().process_frame


    _update_bead_resource(new_bead_resource)

func _on_gui_input(event):
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        if event.pressed:
            if new_bead_resource is RandomBead:
                new_bead_texture = new_bead_resource.pick_random_variation()
            SignalHandler.create_bead.emit(new_bead, new_bead_value, new_bead_texture)

func _update_bead_resource(bead: Bead):

    if bead:
        new_bead_resource = bead
        new_bead = new_bead_resource.bead_scene
        new_bead_value = new_bead_resource.value
        new_bead_texture = new_bead_resource.texture

    else:
        pass
