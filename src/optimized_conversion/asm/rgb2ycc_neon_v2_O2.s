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
	@ args = 0, pretend = 0, frame = 112
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	vpush.64	{d8, d9, d10, d11, d12, d13, d14, d15}
	sub	sp, sp, #116
	movs	r5, #0
	movw	r7, #:lower16:Cb
	movt	r7, #:upper16:Cb
	mov	r8, #112	@ movhi
	str	r3, [sp, #96]
	movs	r3, #48
	vldr	d5, [sp]
	vldr	d4, [sp, #8]
	str	r7, [sp, #108]
.L2:
	movs	r1, #24
	asrs	r2, r5, #1
	mov	r10, #0
	strd	r5, r3, [sp, #100]
	vstr	d5, [sp]
	mul	r2, r1, r2
	ldr	r1, .L8+16
	str	r2, [sp, #92]
	add	r1, r1, r3
	str	r1, [sp, #56]
	ldr	r1, .L8+20
	vstr	d3, [sp, #8]
	adds	r7, r1, r3
	ldr	r1, .L8+24
	str	r7, [sp, #80]
	add	lr, r1, r3
	ldr	r1, .L8+28
	str	lr, [sp, #60]
	add	fp, r1, r3
	ldr	r1, [sp, #108]
	vstr	d2, [sp, #16]
	add	r9, r1, r2
	vstr	d4, [sp, #24]
.L3:
	movs	r2, #38
	vldr	d30, [sp, #8]
	ldr	r1, [sp, #80]
	mov	r0, #94	@ movhi
	vmov.16	d0[0], r2
	vmov.16	d21[0], r2
	movs	r2, #74
	vldr	d5, [sp, #24]
	vldr	d3, [sp]
	vmov.16	d24[0], r0
	vmov.16	d19[0], r2
	vmov.16	d22[0], r2
	mov	r2, #94	@ movhi
	ldr	r3, [sp, #56]
	vmov.16	d5[0], r8
	vld1.8	{d16}, [r1]
	vmov.16	d27[0], r2
	movs	r2, #18
	ldr	r0, [sp, #60]
	vmov.16	d20[0], r8
	vmov.16	d25[0], r2
	vmov.16	d28[0], r2
	movs	r2, #66
	vld1.8	{d6}, [r3]
	vstr	d5, [sp, #24]
	vmov.16	d26[0], r8
	vmov.16	d30[0], r2
	vmov.16	d18[0], r2
	movs	r2, #129
	vld1.8	{d8}, [r0]
	vmovl.u8	q2, d16
	asr	lr, r10, #1
	vmov.16	d3[0], r2
	vmov.16	d23[0], r8
	vstr	d30, [sp, #8]
	add	r7, lr, #3
	vldr	d30, [sp, #16]
	add	r10, r10, #8
	vmovl.u8	q3, d6
	str	r7, [sp, #88]
	vmov	q8, q2  @ v8hi
	vstr	d3, [sp]
	vmov.16	d30[0], r2
	movs	r2, #25
	vmov	d5, d18  @ v4hi
	cmp	r10, #48
	vmov.16	d29[0], r2
	vmov.16	d1[0], r2
	mov	r2, r3
	add	r3, r3, #48
	vmovl.u8	q4, d8
	vstr	d30, [sp, #16]
	vldr	d30, .L8
	vldr	d31, .L8+8
	vstr	d16, [sp, #32]
	vstr	d17, [sp, #40]
	vld1.8	{d14}, [r3]
	add	r3, r2, #8
	str	r3, [sp, #56]
	vmla.i16	q15, q3, d5[0]
	vmov	d5, d29  @ v4hi
	vmovl.u8	q1, d14
	add	r3, r1, #48
	vmov.i8	q7, #128  @ v8hi
	add	r2, lr, #2
	str	r2, [sp, #52]
	vld1.8	{d12}, [r3]
	add	r3, r1, #8
	vstr	d2, [sp, #64]
	vstr	d3, [sp, #72]
	add	r1, lr, #1
	vldr	d3, [sp]
	vmovl.u8	q6, d12
	str	r3, [sp, #80]
	add	r3, r0, #48
	str	r1, [sp, #84]
	vmla.i16	q15, q8, d3[0]
	vmov	q8, q7  @ v8hi
	vldr	d2, [sp, #64]
	vldr	d3, [sp, #72]
	vmla.i16	q15, q4, d5[0]
	vldr	d5, [sp, #24]
	vmls.i16	q8, q3, d0[0]
	vld1.8	{d10}, [r3]
	add	r3, r0, #8
	str	r3, [sp, #60]
	add	r3, fp, #48
	vshr.u16	q15, q15, #8
	vmovl.u8	q5, d10
	vmovn.i16	d30, q15
	vst1.8	{d30}, [fp]
	add	fp, fp, #8
	vmov	q15, q7  @ v8hi
	vmla.i16	q15, q3, d5[0]
	vmov	d7, d19  @ v4hi
	vldr	d4, [sp, #32]
	vldr	d5, [sp, #40]
	vmls.i16	q8, q2, d7[0]
	vmov	q3, q8  @ v8hi
	vmov	q8, q2  @ v8hi
	vmov	d5, d24  @ v4hi
	vmls.i16	q15, q8, d5[0]
	vmov	d5, d20  @ v4hi
	vmov	q8, q7  @ v8hi
	vmla.i16	q3, q4, d5[0]
	vmov	d5, d25  @ v4hi
	vmls.i16	q15, q4, d5[0]
	vmov	d5, d26  @ v4hi
	vshr.u16	q3, q3, #8
	vmla.i16	q8, q1, d5[0]
	vmov	d5, d21  @ v4hi
	vshr.u16	q15, q15, #8
	vmovn.i16	d6, q3
	vmov	q4, q8  @ v8hi
	vmov	q8, q7  @ v8hi
	vmovn.i16	d7, q15
	vldr	d30, .L8
	vldr	d31, .L8+8
	vmov.u8	ip, d6[2]
	vmls.i16	q8, q1, d5[0]
	vldr	d5, [sp, #8]
	vmov.u8	r1, d7[3]
	vmov.u8	r5, d7[2]
	vmov.u8	r4, d7[4]
	vmov.u8	r0, d7[6]
	vmla.i16	q15, q1, d5[0]
	vmov	d5, d27  @ v4hi
	vmov.u8	r7, d6[4]
	vmov.u8	r6, d6[6]
	vmov.u8	r2, d6[1]
	add	r5, r5, r1
	vmov.u8	r1, d7[5]
	vmls.i16	q4, q6, d5[0]
	vmov	d5, d22  @ v4hi
	vmls.i16	q8, q6, d5[0]
	vldr	d5, [sp, #16]
	add	r4, r4, r1
	vmov.u8	r1, d7[7]
	vmla.i16	q15, q6, d5[0]
	vmov	d5, d28  @ v4hi
	add	r0, r0, r1
	vmls.i16	q4, q5, d5[0]
	vmov	d5, d23  @ v4hi
	vmla.i16	q15, q5, d1[0]
	vmla.i16	q8, q5, d5[0]
	vshr.u16	q15, q15, #8
	vshr.u16	q4, q4, #8
	vshr.u16	q8, q8, #8
	vmovn.i16	d30, q15
	vmovn.i16	d9, q4
	vmovn.i16	d8, q8
	vst1.8	{d30}, [r3]
	vmov.u8	r3, d6[3]
	vmov.u8	r1, d8[2]
	add	ip, ip, r3
	vmov.u8	r3, d6[5]
	add	ip, ip, r1
	vmov.u8	r1, d8[4]
	add	r7, r7, r3
	vmov.u8	r3, d6[7]
	add	r7, r7, r1
	vmov.u8	r1, d8[6]
	add	r6, r6, r3
	vmov.u8	r3, d7[1]
	add	r6, r6, r1
	vmov.u8	r1, d9[2]
	add	r5, r5, r1
	vmov.u8	r1, d9[4]
	add	r4, r4, r1
	vmov.u8	r1, d9[6]
	add	r0, r0, r1
	vmov.u8	r1, d8[1]
	str	r1, [sp, #32]
	vmov.u8	r1, d8[3]
	add	ip, ip, r1
	vmov.u8	r1, d8[5]
	add	ip, ip, #2
	asr	ip, ip, #2
	add	r7, r7, r1
	vmov.u8	r1, d8[7]
	add	r7, r7, #2
	asr	r7, r7, #2
	add	r6, r6, r1
	vmov.u8	r1, d9[1]
	add	r6, r6, #2
	asr	r6, r6, #2
	str	r1, [sp, #64]
	vmov.u8	r1, d9[3]
	add	r5, r5, r1
	vmov.u8	r1, d9[5]
	add	r5, r5, #2
	asr	r5, r5, #2
	add	r4, r4, r1
	vmov.u8	r1, d9[7]
	add	r4, r4, #2
	asr	r4, r4, #2
	add	r0, r0, r1
	vmov	r1, s12	@ int
	add	r0, r0, #2
	asr	r0, r0, #2
	uxtab	r1, r2, r1
	vmov	r2, s14	@ int
	uxtab	r2, r3, r2
	vmov	r3, s16	@ int
	uxtab	r3, r1, r3
	ldr	r1, [sp, #32]
	add	r3, r3, r1
	ldr	r1, [sp, #84]
	add	r3, r3, #2
	asr	r3, r3, #2
	strb	r3, [r9, lr]
	ldr	r3, [sp, #52]
	strb	ip, [r9, r1]
	strb	r7, [r9, r3]
	vmov	r3, s18	@ int
	ldr	r7, [sp, #88]
	strb	r6, [r9, r7]
	uxtab	r3, r2, r3
	ldr	r6, [sp, #64]
	add	r3, r3, r6
	ldrd	r2, r6, [sp, #92]
	add	r3, r3, #2
	add	r2, r6, r2
	asr	r3, r3, #2
	strb	r3, [r2, lr]
	ldr	r3, [sp, #52]
	strb	r5, [r2, r1]
	strb	r4, [r2, r3]
	strb	r0, [r2, r7]
	bne	.L3
	ldrd	r5, r3, [sp, #100]
	vldr	d5, [sp]
	adds	r3, r3, #96
	vldr	d3, [sp, #8]
	vldr	d2, [sp, #16]
	adds	r5, r5, #2
	vldr	d4, [sp, #24]
	cmp	r3, #3120
	bne	.L2
	add	sp, sp, #116
	@ sp needed
	vldm	sp!, {d8-d15}
	pop	{r4, r5, r6, r7, r8, r9, r10, fp, pc}
.L9:
	.align	3
.L8:
	.short	4224
	.short	4224
	.short	4224
	.short	4224
	.short	4224
	.short	4224
	.short	4224
	.short	4224
	.word	R-48
	.word	G-48
	.word	B-48
	.word	Y-48
	.size	CSC_RGB_to_YCC, .-CSC_RGB_to_YCC
	.ident	"GCC: (Arm GNU Toolchain 15.3.Rel1 (Build arm-15.149)) 15.3.1 20260627"
	.section	.note.GNU-stack,"",%progbits
