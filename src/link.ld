ENTRY(__start);

PHDRS {
  text PT_LOAD;
}

SECTIONS {
    .text 0x00100000: {
        _ftext = . ;
        *(.text)
        *(.text.*)
        *(.gnu.linkonce.t*)
        KEEP(*(.init))
        KEEP(*(.fini))
        QUAD(0)
    } :text

    .data ALIGN(128): {
        _fdata = . ;
        *(.data)
        *(.data.*)
        *(.gnu.linkonce.d*)
        SORT(CONSTRUCTORS)
    }

}
