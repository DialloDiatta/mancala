extends Node

var board_skin: Texture2D = preload("res://assets/boards/burned.png")
var cup_skin: Texture2D = preload("res://assets/boards/burned_base_cup.png")

func assign_board_skin(board_texture: Texture2D):
    board_skin = board_texture

func assign_board_resource(board: Board):
    board_skin = board.board_texture

func set_skin(type: String):
    if type == "board":
        return board_skin
    if type == "cup":
        return cup_skin

func assign_skin(type: String, texture: Texture2D):
    if type == "board":
        board_skin = texture
    if type == "cup":
        cup_skin = texture
