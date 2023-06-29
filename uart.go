package main

import "unsafe"

const UART0 = 0x10000000

const (
	THR uint = 0 // 写缓冲
	IER uint = 1 // Interrupt Enable
	FCR uint = 2 // FIFO control
	LCR uint = 3 // line control
	LSR uint = 5 // line status

	DLL uint = 0 // DLL, divisor latch LSB
	DLM uint = 1 // DLM, divisor latch LMB

	FCR_FIFO_ENABLE byte = 1 << 0
	FCR_FIFO_CLEAR  byte = 3 << 1
	LCR_EIGHT_BITS  byte = 3 << 0 // no parity
	LCR_BAUD_LATCH  byte = 1 << 7 // DLAB, DLL DLM accessible
)

func initUart() {
	// 关闭中断
	writeRegister(IER, 0x0)
	// DLAB
	writeRegister(LCR, LCR_BAUD_LATCH)
	// 38.4k baud rate, see:
	writeRegister(DLL, 0x03)
	writeRegister(DLM, 0x00)
	// 8 bits payload，无奇偶校验
	writeRegister(LCR, LCR_EIGHT_BITS)
	// 开启FIFO
	writeRegister(FCR, FCR_FIFO_ENABLE|FCR_FIFO_CLEAR)
}

func putChar(c byte) {
	for {
		// 等待写缓冲区空闲
		if readRegister(LSR)&(1<<5) != 0 {
			break
		}
	}
	// byte写入寄存器
	writeRegister(THR, c)
}

func writeRegister(offset uint, val byte) {
	ptr := unsafe.Pointer(uintptr(UART0 + offset))
	*(*byte)(ptr) = val
}

func readRegister(offset uint) byte {
	ptr := (*byte)(unsafe.Pointer(uintptr(UART0 + offset)))
	return *ptr
}
