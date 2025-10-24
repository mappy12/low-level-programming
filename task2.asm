section .data
    align 16
    vec1: dd 1.0, 2.0, 3.0, 4.0
    
    align 16    
    vec2: dd 0.5, 1.5, 2.5, 3.5
    
section .text
    global main
    
sse_scalar:
    movss xmm0, [vec1]
    mulss xmm0, [vec2]
    
    movss xmm1, [vec1 + 4]
    mulss xmm1, [vec2 + 4]
    addss xmm0, xmm1
    
    movss xmm1, [vec1 + 8]
    mulss xmm1, [vec2 + 8]
    addss xmm0, xmm1
    
    movss xmm1, [vec1 + 12]
    mulss xmm1, [vec2 + 12] 
    addss xmm0, xmm1
    
    movss xmm2, [vec1]
    mulss xmm2, [vec1]
    
    movss xmm3, [vec1 + 4]
    mulss xmm3, [vec1 + 4]
    addss xmm2, xmm3
    
    movss xmm3, [vec1 + 8]
    mulss xmm3, [vec1 + 8]
    addss xmm2, xmm3
    
    movss xmm3, [vec1 + 12]
    mulss xmm3, [vec1 + 12]
    addss xmm2, xmm3
       
    sqrtss xmm2, xmm2
    
    movss xmm3, [vec2]
    mulss xmm3, [vec2]
    
    movss xmm4, [vec2 + 4]
    mulss xmm4, [vec2 + 4]
    addss xmm3, xmm4
    
    movss xmm4, [vec2 + 8]
    mulss xmm4, [vec2 + 8]
    addss xmm3, xmm4
    
    movss xmm4, [vec2 + 12]
    mulss xmm4, [vec2 + 12]
    addss xmm3, xmm4
    sqrtss xmm3, xmm3
    
    mulss xmm2, xmm3
    divss xmm0, xmm2
    
    ret             
  
sse_vector:
    movaps xmm0, [vec1]
    movaps xmm1, [vec2]
    mulps xmm0, xmm1    

    haddps xmm0, xmm0
    haddps xmm0, xmm0
    
    
    movaps xmm2, [vec1]
    mulps xmm2, xmm2
    haddps xmm2, xmm2
    haddps xmm2, xmm2
    sqrtss xmm2, xmm2
    
    movaps xmm3, [vec2]
    mulps xmm3, xmm3
    haddps xmm3,xmm3
    haddps xmm3, xmm3
    sqrtss xmm3, xmm3
    
    mulss xmm2, xmm3
    divss xmm0, xmm2
    
    ret

main:

    call sse_scalar
    call sse_vector
    ret
  
  