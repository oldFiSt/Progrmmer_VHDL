#!/usr/bin/env python3
# ============================================================================
#  Статическая проверка раскладки байт (НЕ требует симулятора).
#  Воспроизводит resp_comb из pkt2axil_binder.sv и парсер receive_response()
#  из pkt2axil_test.py и проверяет, что type/resp/addr/rdata восстанавливаются.
#  Запуск:  python3 tools/check_layout.py
# ============================================================================

def build_resp_comb(tt, addr, bresp=0, rresp=0, rdata=0, err_code=0):
    """Модель resp_comb из pkt2axil_binder.sv (80 бит, байты little-endian)."""
    a = [(addr >> 0) & 0xFF, (addr >> 8) & 0xFF, (addr >> 16) & 0xFF, (addr >> 24) & 0xFF]
    d = [(rdata >> 0) & 0xFF, (rdata >> 8) & 0xFF, (rdata >> 16) & 0xFF, (rdata >> 24) & 0xFF]
    if tt == 0b11:      # write:  байт1 = bresp
        msb = [0xEE, 0xEE, 0xEE, 0xEE, a[3], a[2], a[1], a[0], (bresp & 3), 0b11]
    elif tt == 0b01:    # read:   байты 6..9 = rdata
        msb = [d[3], d[2], d[1], d[0], a[3], a[2], a[1], a[0], (rresp & 3), 0b01]
    else:               # error:  байт1 = полный 8-битный код (наша правка)
        msb = [0xEE, 0xEE, 0xEE, 0xEE, a[3], a[2], a[1], a[0], (err_code & 0xFF), 0b00]
    v = 0
    for b in msb:
        v = (v << 8) | (b & 0xFF)
    return v


def le_bytes(v):
    return [(v >> (8 * i)) & 0xFF for i in range(10)]


def harness_parse(b):
    """Модель receive_response() из pkt2axil_test.py."""
    t = b[0] & 3
    r = b[1] & 3
    a = [(b[i] if b[i] != 0xEE else 0) for i in range(2, 6)]
    addr = a[0] | a[1] << 8 | a[2] << 16 | a[3] << 24
    val = (b[6] | b[7] << 8 | b[8] << 16 | b[9] << 24) if t == 1 else r
    return t, r, addr, val


def cmd_words(cmd, addr, data, strb=0xF, prot=0):
    b1 = (strb & 0xF) | ((prot & 7) << 4)
    return [cmd, b1,
            addr & 0xFF, (addr >> 8) & 0xFF, (addr >> 16) & 0xFF, (addr >> 24) & 0xFF,
            data & 0xFF, (data >> 8) & 0xFF, (data >> 16) & 0xFF, (data >> 24) & 0xFF]


def ck(name, cond):
    print(("  OK  " if cond else " FAIL ") + name)
    return cond


def main():
    ok = True
    print("== binder response layout vs harness parser ==")

    b = le_bytes(build_resp_comb(0b11, 0x1000, bresp=0)); t, r, a, v = harness_parse(b)
    ok &= ck("write: type=write(3)", t == 3)
    ok &= ck("write: addr=0x1000", a == 0x1000)
    ok &= ck("write: resp=OKAY(0)", r == 0)

    b = le_bytes(build_resp_comb(0b11, 0x204, bresp=2)); t, r, a, v = harness_parse(b)
    ok &= ck("write SLVERR: resp=2", r == 2 and t == 3 and a == 0x204)

    b = le_bytes(build_resp_comb(0b01, 0x10, rdata=0xDEADBEEF)); t, r, a, v = harness_parse(b)
    ok &= ck("read: type=read(1)", t == 1)
    ok &= ck("read: addr=0x10", a == 0x10)
    ok &= ck("read: rdata=0xDEADBEEF", v == 0xDEADBEEF)

    b = le_bytes(build_resp_comb(0b00, 0x40, err_code=0x01)); t, r, a, v = harness_parse(b)
    ok &= ck("error: type=error(0)", t == 0)
    ok &= ck("error: addr=0x40", a == 0x40)
    ok &= ck("error: byte1 (full code) = 0x01", b[1] == 0x01)

    for code, exp in [(0x01, 1), (0x02, 2), (0x03, 3)]:
        bb = le_bytes(build_resp_comb(0b00, 0x40, err_code=code))
        ok &= ck("error code 0x%02X: byte1 + resp&3=%d" % (code, exp),
                 bb[1] == code and (bb[1] & 3) == exp)

    print("== command construction (send_write_transaction) ==")
    c = cmd_words(0xF3, 0x1000, 0x12345678)
    ok &= ck("cmd length = 10 bytes", len(c) == 10)
    ok &= ck("cmd[0] = 0xF3", c[0] == 0xF3)
    ok &= ck("addr LE = 0x1000", (c[2] | c[3] << 8 | c[4] << 16 | c[5] << 24) == 0x1000)
    ok &= ck("data LE = 0x12345678", (c[6] | c[7] << 8 | c[8] << 16 | c[9] << 24) == 0x12345678)

    print()
    print("RESULT:", "ALL PASS" if ok else "FAILURES")
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
