class_name RoomChance
extends Resource

## Сцена комнаты (префаб)
@export var room_prefab: PackedScene

## Вес этой комнаты. Чем выше значение, тем чаще она будет появляться.
@export_range(0.1, 100.0) var chance_weight: float = 1.0
