# tiny-m0 — MSPM0 LaunchPad Blink Example (Bare Metal)

Minimal bare-metal **LED blink** example for a **TI MSPM0 LaunchPad (Cortex-M0+)**.  
No SDK, no driver library, no C runtime — just the absolute minimum to boot the
CPU and toggle a GPIO pin.

This project is intended as a learning and experimentation baseline.

---

## Project Structure

```
.
├── LICENSE
├── link.ld
├── Makefile
├── README.md
└── startup.s
```

---

## What Does This Example Do?

Inside `Reset_Handler` the firmware:

1. Enables GPIO power/clock via `GPIO0_PWREN`.
2. Configures the IOMUX so the pin acts as a GPIO output.
3. Enables the GPIO output driver.
4. Toggles the GPIO using the GPIO toggle register.
5. Uses a simple busy-wait delay loop to blink the LED.

---

## Requirements

- GNU Arm Embedded Toolchain
  - `arm-none-eabi-gcc`
  - `arm-none-eabi-gdb`
- OpenOCD (recent enough, see below)
- TI MSPM0 LaunchPad with on-board **XDS110**

---

## Build

```bash
make
```

Build artifacts:

- `tiny-m0.elf`
- `tiny-m0.map`

Clean build outputs:

```bash
make clean
```

---

## Flashing with OpenOCD

Flashing is done using **OpenOCD** and the LaunchPad’s on-board **XDS110** debugger.

Start OpenOCD with:

```bash
openocd -f board/ti/mspm0-launchpad.cfg
```

### OpenOCD Requirements

- OpenOCD must be **new enough** to include  
  `board/ti/mspm0-launchpad.cfg`
- OpenOCD must be built **with XDS110 support enabled**

When building OpenOCD from source, configure it with:

```bash
./configure --enable-xds110=yes
```

Then build and install as usual.

---

## Flashing via GDB

Flashing and running the firmware is handled via a `.gdbinit` file.

From the project directory, simply start GDB:

```bash
gdb tiny-m0.elf
```

The `.gdbinit` will automatically:

- connect to OpenOCD
- flash the ELF
- reset and start the target
- enable the GDB TUI interface

No manual GDB commands are required.

---

## Notes / Limitations

- No C runtime startup (`.data` / `.bss` not initialized)
- No interrupts enabled
- Delay loop is CPU-frequency dependent
- Pure assembly, no SDK or driver libraries



