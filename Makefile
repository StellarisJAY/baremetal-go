TOOL = "riscv64-unknown-elf-"
QEMU_OPTS = -machine virt \
	    -bios none \
	    -kernel $(TARGET)/main.bin \
	    -smp 1 \
	    -nographic
QEMU = qemu-system-riscv64
TARGET=./target
build:
	@GOOS=linux GOARCH=riscv64 go build -gcflags='-N -l' -o $(TARGET)/main
	@$(TOOL)gcc -c -o $(TARGET)/entry.o entry.S
	@$(TOOL)ld -T linker.ld -o $(TARGET)/main.elf $(TARGET)/entry.o $(TARGET)/main
	@$(TOOL)objcopy --strip-all $(TARGET)/main.elf -O binary $(TARGET)/main.bin
qemu:build
	@$(QEMU) $(QEMU_OPTS)
debug:build
	@$(QEMU) $(QEMU_OPTS) -s -S
gdb:
	@$(TOOL)gdb -ex 'file main.elf' -ex 'set arch riscv:rv64' -ex 'target remote localhost:1234'
objdump:build
	@$(TOOL)objdump -d $(TARGET)/main.elf