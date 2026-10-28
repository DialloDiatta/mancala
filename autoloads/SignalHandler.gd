extends Node


signal update_playspace(change: int, signal_id: String)
signal update_playspace_span(change: int, signal_id: String)

signal create_bead(new_block: PackedScene, new_block_value: int, new_block_texture: String)
signal create_bead_span(area, bead_resource: Bead)
signal clear_bead(bead: Node, piece_value: int)

signal say_addend(addend: int)

signal update_bead_resource(new_bead: Bead)
signal update_cursor(bead_resource: Bead)
