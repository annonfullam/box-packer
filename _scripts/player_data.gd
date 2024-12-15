extends Resource
class_name PlayerData

#region Saved Settings
@export_storage var rotation_sens: float = 200
@export_storage var position_sens: float = 500


@export_storage var snap_position: bool = false
@export_storage var snap_position_step: float = 1

@export_storage var snap_rotation: bool = false
@export_storage var snap_rotation_step: float = 15.0
#endregion

@export_storage var best_times: Array[float]
