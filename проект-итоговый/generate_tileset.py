
base_str = """[sub_resource type="TileSetAtlasSource" id="TileSetAtlasSource_ak60p"]
texture = ExtResource("2_8j1yk")"""

# Квадрат 6x6 по центру
collision = "physics_layer_0/polygon_0/points = PackedVector2Array(-3, -3, 3, -3, 3, 3, -3, 3)"

for y in range(3):
    for x in range(8):
        base_str += f"\n{x}:{y}/0 = 0"
        base_str += f"\n{x}:{y}/0/{collision}"

print(base_str)
