OUTPUT_ARCH(riscv)
ENTRY(__start)              
BASE_ADDRESS = 0x80000000;

SECTIONS
{
    . = BASE_ADDRESS;
    .text : {
        *(.text, .text.*)
    }
    . = ALIGN(4K);
    etext = .;
    srodata = .;
    .rodata : {
        *(.rodata, .rodata.*)
    }
    . = ALIGN(4K);
    .data : {
        *(.data, .data.*)
    }
    . = ALIGN(4K);
    .bss : {
        . = ALIGN(4K);
        *(.bss, .bss.*)
    }
    . = ALIGN(4K);
    /DISCARD/ : {
        *(.eh_frame)
    }
}
