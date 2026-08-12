	.arch armv7-a
	.fpu neon
	.eabi_attribute 28, 1
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 2
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"CSC_RGB_to_YCC.c"
	.text
	.align	1
	.p2align 2,,3
	.global	CSC_RGB_to_YCC
	.syntax unified
	.thumb
	.thumb_func
	.type	CSC_RGB_to_YCC, %function
CSC_RGB_to_YCC:
	@ args = 0, pretend = 0, frame = 80
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
	movs	r3, #0
	mov	r9, #48
	sub	sp, sp, #84
	movw	r0, #:lower16:Cb
	movt	r0, #:upper16:Cb
	movw	r2, #:lower16:Cr
	movt	r2, #:upper16:Cr
	mov	r10, #112	@ movhi
	str	r2, [sp, #68]
	movs	r2, #49
	str	r3, [sp, #16]
	str	r2, [sp, #12]
	str	r9, [sp, #8]
	str	r0, [sp, #76]
.L2:
	asrs	r2, r3, #1
	movs	r1, #24
	ldr	r0, .L8
	str	r3, [sp, #72]
	mul	r1, r1, r2
	ldr	r2, [sp, #8]
	str	r1, [sp, #60]
	add	r0, r0, r2
	str	r0, [sp, #36]
	ldr	r0, .L8+4
	add	r9, r0, r2
	ldr	r0, .L8+8
	add	fp, r0, r2
	ldr	r0, .L8+12
	add	r8, r0, r2
	movs	r2, #0
	str	r2, [sp, #32]
	ldr	r2, [sp, #76]
	str	r8, [sp, #4]
	mov	r8, fp
	add	r2, r2, r1
	str	r2, [sp, #64]
.L3:
	ldr	r1, [sp, #36]
	movw	fp, #65498
	ldr	r0, [sp, #16]
	movw	lr, 65462	@ movhi
	ldrb	r3, [r9, #1]	@ zero_extendqisi2
	adds	r2, r0, r1
	str	r3, [sp, #24]
	ldr	r3, [sp, #8]
	add	r4, r0, r8
	ldrb	r6, [r8, #1]	@ zero_extendqisi2
	adds	r1, r1, #2
	str	r6, [sp, #52]
	add	r5, r0, r9
	ldrb	r6, [r2, r3]	@ zero_extendqisi2
	add	r9, r9, #2
	str	r6, [sp, #20]
	add	r8, r8, #2
	ldr	r6, [sp, #12]
	ldrb	r7, [r1, #-1]	@ zero_extendqisi2
	ldrb	ip, [r1, #-2]	@ zero_extendqisi2
	str	r1, [sp, #36]
	mov	r1, r3
	ldrb	r2, [r2, r6]	@ zero_extendqisi2
	str	r2, [sp, #40]
	ldrb	r2, [r8, #-2]	@ zero_extendqisi2
	str	r2, [sp, #48]
	ldrb	r2, [r4, r1]	@ zero_extendqisi2
	str	r2, [sp, #28]
	mov	r2, #32768
	ldrb	r3, [r5, r3]	@ zero_extendqisi2
	ldrb	r5, [r5, r6]	@ zero_extendqisi2
	str	r5, [sp, #44]
	smlabb	r5, r7, fp, r2
	ldr	r2, [sp, #24]
	ldrb	r4, [r4, r6]	@ zero_extendqisi2
	str	r4, [sp, #56]
	ldr	r6, [sp, #52]
	smlabb	r5, r2, lr, r5
	mov	r2, #32768
	movw	lr, 65442	@ movhi
	ldrb	r0, [r9, #-2]	@ zero_extendqisi2
	ldr	r1, [sp, #48]
	smlabb	r4, r7, r10, r2
	ldr	r2, [sp, #24]
	smlabb	r5, r6, r10, r5
	adds	r5, r5, #128
	smlabb	r4, r2, lr, r4
	movw	lr, #65518
	mov	r2, fp
	asrs	r5, r5, #8
	smlabb	r4, r6, lr, r4
	mov	lr, #32768
	adds	r4, r4, #128
	smlabb	fp, ip, fp, lr
	movw	lr, 65462	@ movhi
	asrs	r4, r4, #8
	smlabb	fp, r0, lr, fp
	mov	lr, #32768
	smlabb	fp, r1, r10, fp
	add	fp, fp, #128
	add	r5, r5, fp, asr #8
	smlabb	fp, ip, r10, lr
	movw	lr, #65442
	smlabb	fp, r0, lr, fp
	movw	lr, #65518
	smlabb	fp, r1, lr, fp
	mov	lr, #32768
	add	fp, fp, #128
	add	r4, r4, fp, asr #8
	mov	fp, r2
	ldr	r2, [sp, #20]
	smlabb	fp, r2, fp, lr
	movw	r2, #65462
	smlabb	fp, r3, r2, fp
	ldr	r2, [sp, #28]
	smlabb	fp, r2, r10, fp
	movw	r2, 65442	@ movhi
	add	fp, fp, #128
	add	fp, r5, fp, asr #8
	ldr	r5, [sp, #20]
	smlabb	r5, r5, r10, lr
	movw	lr, #65518
	smlabb	r5, r3, r2, r5
	ldr	r2, [sp, #28]
	smlabb	r5, r2, lr, r5
	mov	lr, #129	@ movhi
	ldr	r2, [sp, #24]
	adds	r5, r5, #128
	add	r4, r4, r5, asr #8
	movs	r5, #66
	str	r4, [sp, #48]
	mov	r4, #4096
	smlabb	ip, ip, r5, r4
	smlabb	r0, r0, lr, ip
	mov	ip, #25
	smlabb	r7, r7, r5, r4
	mov	lr, ip
	smlabb	r0, r1, ip, r0
	mov	r1, #129	@ movhi
	smlabb	r1, r2, r1, r7
	ldr	r2, [sp, #20]
	mov	r7, #129	@ movhi
	smlabb	r1, r6, ip, r1
	adds	r0, r0, #128
	adds	r1, r1, #128
	smlabb	r6, r2, r5, r4
	asrs	r0, r0, #8
	smlabb	r2, r3, r7, r6
	ldr	r7, [sp, #28]
	ldr	r6, [sp, #44]
	asrs	r1, r1, #8
	ldr	r3, [sp, #4]
	smlabb	r2, r7, ip, r2
	ldr	r7, [sp, #40]
	strb	r0, [r3]
	strb	r1, [r3, #1]
	mov	r3, #32768
	ldr	r0, [sp, #16]
	adds	r2, r2, #128
	smlabb	r4, r7, r5, r4
	movs	r5, #129
	asrs	r2, r2, #8
	smlabb	r4, r6, r5, r4
	ldr	r5, [sp, #56]
	smlabb	r4, r5, ip, r4
	movw	ip, #65498
	smlabb	r1, r7, ip, r3
	movw	ip, #65462
	smlabb	r3, r7, r10, r3
	ldr	r7, [sp, #4]
	smlabb	r1, r6, ip, r1
	movw	ip, 65442	@ movhi
	smlabb	r1, r5, r10, r1
	add	r0, r0, r7
	smlabb	r3, r6, ip, r3
	movw	ip, 65518	@ movhi
	ldr	r6, [sp, #12]
	adds	r4, r4, #128
	smlabb	r3, r5, ip, r3
	ldr	r5, [sp, #48]
	asrs	r4, r4, #8
	adds	r1, r1, #128
	adds	r3, r3, #128
	adds	r7, r7, #2
	add	r1, fp, r1, asr #8
	str	r7, [sp, #4]
	add	r3, r5, r3, asr #8
	ldr	r5, [sp, #8]
	adds	r1, r1, #2
	adds	r3, r3, #2
	strb	r2, [r0, r5]
	asrs	r1, r1, #2
	strb	r4, [r0, r6]
	asrs	r3, r3, #2
	ldr	r0, [sp, #32]
	ldr	r4, [sp, #64]
	asrs	r2, r0, #1
	adds	r0, r0, #2
	cmp	r0, #48
	str	r0, [sp, #32]
	strb	r1, [r4, r2]
	ldr	r1, [sp, #68]
	ldr	r4, [sp, #60]
	add	r1, r1, r4
	strb	r3, [r1, r2]
	bne	.L3
	ldr	r3, [sp, #72]
	ldr	r2, [sp, #16]
	adds	r3, r3, #2
	subs	r2, r2, #96
	cmp	r3, #64
	str	r2, [sp, #16]
	add	r2, r5, #96
	str	r2, [sp, #8]
	add	r2, r6, #96
	str	r2, [sp, #12]
	bne	.L2
	add	sp, sp, #84
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r9, r10, fp, pc}
.L9:
	.align	2
.L8:
	.word	R-48
	.word	G-48
	.word	B-48
	.word	Y-48
	.size	CSC_RGB_to_YCC, .-CSC_RGB_to_YCC
	.ident	"GCC: (Arm GNU Toolchain 15.3.Rel1 (Build arm-15.149)) 15.3.1 20260627"
	.section	.note.GNU-stack,"",%progbits
