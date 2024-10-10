SEED_IMG 	  := seed.img
USER_DATA 	:= user-data.yaml
META_DATA 	:= meta-data.yaml

# init address: https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64-disk-kvm.img
CACHE_DIR :=  .cache
SYS_IMG   := $(CACHE_DIR)/jammy-server-cloudimg-amd64-disk-kvm.img
DISK_IMG  := jammy-server-cloudimg-amd64-disk-kvm.img


$(SEED_IMG): $(USER_DATA) $(META_DATA)
	cloud-localds $@ $^

restart: $(SYS_IMG)
	rm $(DISK_IMG)
	cp $(SYS_IMG) $(DISK_IMG)

run: $(SEED_IMG) $(DISK_IMG)
	qemu-system-x86_64 \
  -machine accel=kvm,type=q35 \
  -cpu host \
  -m 8G \
  -nographic \
  -device virtio-net-pci,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
  -drive if=virtio,format=qcow2,file=$(DISK_IMG) \
  -drive if=virtio,format=raw,file=$(SEED_IMG)
