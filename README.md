# Tutorial 7 - Game Development

Nama: Fikri Risyad Indratno<br>
NPM: 2206031170

## Latihan Mandiri: Eksplorasi Mechanics 3D

### *Sprinting* & *crouching*

Saya menambahkan variabel `is_crouching` dan `is_sprinting` untuk menyimpan status pemain, serta `camera_height` untuk menyimpan tinggi kamera yang nantinya akan berubah ketika *crouch*. `camera_height` akan di-assign dengan nilai *default* `camera.position.y`. Berikut adalah kodenya:

```
var camera_height: float = 0.0
var is_crouching: bool = false
var is_sprinting: bool = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera_height = camera.position.y
```

Kemudian, saya menambahkan input `control` (di Mac) untuk *action* baru bernama `crouch` dan input `shift` untuk *action* baru bernama `sprint` pada *tab Input Map* di *Project Settings*. Lalu, saya menambahkan kode di bawah ini setelah kode menormalisasikan `movement_vector` dan sebelum kode mengubah `velocity`:

```
	movement_vector = movement_vector.normalized()

	# Handle crouch
	if Input.is_action_pressed("crouch"):
		if not is_crouching:
			is_crouching = true
			camera.position.y = camera_height - 0.5
	else:
		if is_crouching:
			is_crouching = false
			camera.position.y = camera_height
	
	# Handle sprint
	if Input.is_action_pressed("sprint") and not is_crouching:
		is_sprinting = true
	else:
		is_sprinting = false
	
	# Adjust speed
	var movement_speed = speed
	if is_crouching:
		movement_speed = speed / 2.0
	elif is_sprinting:
		movement_speed = speed * 2.0
	
	velocity.x = lerp(velocity.x, movement_vector.x * movement_speed, acceleration * delta)
	velocity.z = lerp(velocity.z, movement_vector.z * movement_speed, acceleration * delta)
```

Ketika input yang ditekan dan ditahan adalah `control` atau *action* `crouch` dan sedang tidak *crouch*, maka posisi kamera akan diturunkan sebanyak `0.5`, sedangkan ketika sedang *crouch* dan melepas tombol `control`, maka kamera akan kembali ke posisi *default*. Kemudian, ketika input yang ditekan adalah `shift` atau *action* `sprint` dan sedang tidak *crouch*, maka karaktera akan melakukan *sprint*. Pada bagian terakhir, jika karakter sedang *crouch* maka `speed` jalannya menjadi setengah dari `speed` *default*, jika karakter sedang *sprint* maka `speed` jalannya menjadi dua kali dari `speed` *default*, dan jika tidak keduanya maka `speed`-nya adalah *default*.