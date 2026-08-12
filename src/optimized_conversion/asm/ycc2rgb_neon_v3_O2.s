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
	.file	"CSC_YCC_to_RGB.c"
	.text
	.align	1
	.p2align 2,,3
	.global	CSC_YCC_to_RGB
	.syntax unified
	.thumb
	.thumb_func
	.type	CSC_YCC_to_RGB, %function
CSC_YCC_to_RGB:
	@ args = 0, pretend = 0, frame = 192
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	vpush.64	{d8, d9, d10, d11, d12, d13, d14, d15}
	sub	sp, sp, #196
	movw	r2, #:lower16:Cr_temp
	movt	r2, #:upper16:Cr_temp
	movw	r1, #:lower16:Cb
	movt	r1, #:upper16:Cb
	movw	r5, #:lower16:Cr
	movt	r5, #:upper16:Cr
	vmov.i16	q4, #2  @ v8hi
	movs	r0, #80
	add	fp, r1, #23
	movs	r4, #81
	str	r2, [sp, #68]
	str	r1, [sp, #148]
	movs	r1, #0
	strd	r4, r0, [sp, #112]
	movs	r0, #24
	str	r1, [sp, #104]
	str	r0, [sp, #108]
	mov	r0, r5
	str	r1, [sp]
	mov	r1, r2
	mov	r2, r3
	str	r5, [sp, #152]
	str	r3, [sp, #156]
.L2:
	sub	r3, fp, #22
	sub	r5, fp, #23
	vld1.8	{q12}, [r0]
	add	r4, sp, #72
	vld1.8	{q11}, [r5]
	adds	r5, r0, #1
	vld1.8	{q15}, [r3]
	mov	r3, r0
	vmov	q13, q4  @ v8hi
	adds	r0, r0, #24
	vld1.8	{q2}, [r5]
	vmovl.u8 q9, d30
	vmovl.u8 q8, d31
	add	r5, fp, #1
	vrhadd.u8	q15, q11, q15
	vstr	d24, [sp, #32]
	vstr	d25, [sp, #40]
	mov	r10, r3
	vaddw.u8	q10, q4, d24
	vstr	d22, [sp, #72]
	vstr	d23, [sp, #80]
	mov	r7, r1
	vaddw.u8	q13, q13, d25
	vstr	d30, [sp, #88]
	vstr	d31, [sp, #96]
	mov	r6, r2
	vld1.8	{q15}, [r0]
	strd	r1, r0, [sp, #136]
	vaddw.u8	q9, q9, d22
	str	r2, [sp, #144]
	vaddw.u8	q8, q8, d23
	vaddw.u8	q10, q10, d4
	vaddw.u8	q13, q13, d5
	vrhadd.u8	q0, q12, q15
	vadd.i16	q9, q9, q4
	vaddw.u8	q10, q10, d30
	vaddw.u8	q13, q13, d31
	vadd.i16	q8, q8, q4
	vld1.8	{q15}, [r5]
	add	r5, fp, #2
	vrhadd.u8	q12, q12, q2
	vmov	q2, q13  @ v8hi
	vaddw.u8	q9, q9, d30
	vaddw.u8	q8, q8, d31
	vstr	d24, [sp, #48]
	vstr	d25, [sp, #56]
	vrhadd.u8	q12, q11, q15
	vstr	d18, [sp, #120]
	vstr	d19, [sp, #128]
	vmov	q15, q8  @ v8hi
	vld1.64	{d16-d19}, [r4:64]
	add	r4, sp, #32
	vld1.8	{q11}, [r5]
	add	r5, r3, #25
	vst2.8	{d16-d19}, [r2]
	vld1.64	{d16-d19}, [r4:64]
	vst2.8	{d16-d19}, [r1]
	vldr	d16, [sp, #120]
	vldr	d17, [sp, #128]
	str	fp, [sp, #120]
	vaddw.u8	q9, q8, d22
	vmov	q8, q15  @ v8hi
	vshr.u16	q9, q9, #2
	vaddw.u8	q8, q8, d23
	vshr.u16	q8, q8, #2
	vmovn.i16	d26, q9
	vmovn.i16	d27, q8
	vld1.8	{q8}, [r5]
	add	r5, r2, #48
	vaddw.u8	q10, q10, d16
	vst2.8	{d24-d27}, [r5]
	add	r5, r1, #48
	vaddw.u8	q2, q2, d17
	vshr.u16	q10, q10, #2
	vshr.u16	q2, q2, #2
	vmovn.i16	d2, q10
	vmovn.i16	d3, q2
	vst2.8	{d0-d3}, [r5]
	mov	r5, fp
	ldrb	r9, [r3, #40]	@ zero_extendqisi2
	ldrb	r8, [fp, #17]	@ zero_extendqisi2
	ldrb	lr, [r10, #16]!	@ zero_extendqisi2
	ldrb	ip, [r5, #-7]!	@ zero_extendqisi2
.L3:
	ldr	r4, [sp, #104]
	mov	r0, ip
	strb	ip, [r6, #32]
	mov	r1, lr
	add	fp, r6, r4
	ldrb	ip, [r5, #1]!	@ zero_extendqisi2
	adds	r4, r7, r4
	str	r4, [sp, #72]
	ldr	r4, [sp]
	mov	r2, r8
	ldr	r3, [sp, #108]
	adds	r6, r6, #2
	add	r4, r4, r5
	strb	lr, [r7, #32]
	ldrb	lr, [r10, #1]!	@ zero_extendqisi2
	adds	r7, r7, #2
	str	r9, [sp, #32]
	ldrb	r8, [r4, r3]	@ zero_extendqisi2
	ldr	r4, [sp]
	add	r4, r10, r4
	ldrb	r9, [r4, r3]	@ zero_extendqisi2
	add	r4, ip, r0
	add	r0, r0, r2
	add	r2, r2, r4
	adds	r4, r4, #1
	adds	r0, r0, #1
	add	r2, r2, r8
	ldr	r3, [sp, #32]
	asrs	r4, r4, #1
	strb	r4, [r6, #31]
	ldr	r4, [sp, #116]
	asrs	r0, r0, #1
	adds	r2, r2, #2
	strb	r0, [fp, r4]
	asrs	r2, r2, #2
	ldr	r0, [sp, #112]
	strb	r2, [fp, r0]
	add	r2, lr, r1
	add	r1, r1, r3
	add	r3, r3, r2
	adds	r2, r2, #1
	add	r3, r3, r9
	adds	r1, r1, #1
	adds	r3, r3, #2
	asrs	r2, r2, #1
	strb	r2, [r7, #31]
	ldr	r2, [sp, #72]
	asrs	r3, r3, #2
	asrs	r1, r1, #1
	strb	r1, [r2, r4]
	strb	r3, [r2, r0]
	ldr	r3, [sp, #120]
	cmp	r5, r3
	bne	.L3
	ldr	r4, [sp, #108]
	add	fp, r5, #24
	ldr	r3, [sp]
	adds	r4, r4, #24
	str	r4, [sp, #108]
	ldr	r4, [sp, #104]
	subs	r3, r3, #24
	ldrd	r1, r0, [sp, #136]
	subs	r4, r4, #96
	str	r4, [sp, #104]
	cmn	r3, #744
	ldr	r4, [sp, #116]
	add	r1, r1, #96
	ldr	r2, [sp, #144]
	add	r4, r4, #96
	str	r4, [sp, #116]
	ldr	r4, [sp, #112]
	add	r2, r2, #96
	str	r3, [sp]
	add	r4, r4, #96
	str	r4, [sp, #112]
	bne	.L2
	ldrd	r2, r3, [sp, #152]
	movw	r5, #:lower16:Cr_temp
	movt	r5, #:upper16:Cr_temp
	ldr	r8, .L16+4
	movw	r4, #:lower16:Cb_temp
	movt	r4, #:upper16:Cb_temp
	ldrb	ip, [r2, #23]	@ zero_extendqisi2
	sub	r6, r8, #744
	ldr	r2, [sp, #148]
	str	r6, [sp, #148]
	ldrb	r7, [r2, #23]	@ zero_extendqisi2
	movw	r2, #:lower16:Cr
	movt	r2, #:upper16:Cr
	str	r2, [sp, #152]
	mov	lr, r2
.L5:
	mov	r1, r7
	strb	r7, [r4, #46]
	strb	r7, [r4, #47]
	mov	r2, ip
	ldrb	r7, [r6, #47]	@ zero_extendqisi2
	adds	r6, r6, #24
	strb	ip, [r5, #46]
	add	lr, lr, #24
	adds	r0, r1, r7
	strb	ip, [r5, #47]
	add	r1, r1, r0
	ldrb	ip, [lr, #23]	@ zero_extendqisi2
	add	r1, r1, r7
	adds	r0, r0, #1
	adds	r1, r1, #2
	adds	r4, r4, #96
	asrs	r0, r0, #1
	adds	r5, r5, #96
	asrs	r1, r1, #2
	strb	r1, [r4, #-1]
	add	r1, r2, ip
	strb	r0, [r4, #-2]
	add	r2, r2, r1
	adds	r1, r1, #1
	add	r2, r2, ip
	cmp	r8, r6
	add	r2, r2, #2
	asr	r1, r1, #1
	strb	r1, [r5, #-2]
	asr	r2, r2, #2
	strb	r2, [r5, #-1]
	bne	.L5
	vld1.8	{q10}, [r8]
	vmov.i8	q12, #2  @ v16qi
	ldr	r6, .L16
	vmov.i16	q11, #1  @ v8hi
	ldr	r8, .L16+8
	vmovl.u8 q8, d21
	ldr	lr, .L16+12
	vmov.i16	q13, #2  @ v8hi
	add	r5, r8, #15
	vmull.u8 q2, d20, d24
	vmovl.u8 q9, d20
	vmull.u8 q1, d21, d25
	add	r7, r8, #22
	vadd.i16	q8, q8, q8
	vstr	d20, [sp, #32]
	vstr	d21, [sp, #40]
	add	fp, r6, #1
	vadd.i16	q2, q2, q11
	ldr	ip, .L16+16
	vadd.i16	q1, q1, q11
	ldr	r2, [sp, #152]
	vadd.i16	q15, q8, q13
	add	r10, lr, #48
	vadd.i16	q9, q9, q9
	add	r9, ip, #48
	vshr.u16	q2, q2, #1
	ldrb	r4, [r2, #760]	@ zero_extendqisi2
	vshr.u16	q1, q1, #1
	ldr	r2, [sp, #148]
	sub	r1, ip, #2976
	vadd.i16	q4, q9, q13
	ldrb	r0, [r2, #760]	@ zero_extendqisi2
	sub	r2, lr, #2976
	vmovn.i16	d16, q2
	vmovn.i16	d17, q1
	vst1.64	{d16-d17}, [sp:64]
	vld1.8	{q8}, [r6]
	adds	r6, r6, #16
	vmovl.u8 q9, d16
	vmov	q0, q8  @ v16qi
	vadd.i16	q9, q9, q9
	vadd.i16	q2, q9, q13
	vld1.8	{q9}, [r8]
	add	r8, sp, #32
	vstr	d18, [sp, #72]
	vstr	d19, [sp, #80]
	vrhadd.u8	q9, q9, q10
	vstr	d18, [sp, #48]
	vstr	d19, [sp, #56]
	vld1.64	{d18-d21}, [r8:64]
	vst2.8	{d18-d21}, [lr]
	vld1.8	{q10}, [fp]
	vldr	d18, [sp, #72]
	vldr	d19, [sp, #80]
	vrhadd.u8	q1, q10, q8
	vst2.8	{d0-d3}, [ip]
	vmovl.u8 q1, d17
	vadd.i16	q1, q1, q1
	vadd.i16	q13, q1, q13
	vstr	d26, [sp, #32]
	vstr	d27, [sp, #40]
	vmovl.u8 q13, d18
	vmovl.u8 q9, d19
	vadd.i16	q0, q4, q13
	vadd.i16	q15, q15, q9
	vadd.i16	q13, q0, q13
	vadd.i16	q9, q15, q9
	vshr.u16	q13, q13, #2
	vshr.u16	q9, q9, #2
	vmovn.i16	d30, q13
	vmovn.i16	d31, q9
	vmovl.u8 q13, d20
	vmull.u8 q9, d17, d25
	vmovl.u8 q10, d21
	vstr	d30, [sp, #16]
	vstr	d31, [sp, #24]
	vmull.u8 q15, d16, d24
	vldr	d16, [sp, #32]
	vldr	d17, [sp, #40]
	vadd.i16	q12, q2, q13
	vadd.i16	q15, q15, q11
	vadd.i16	q8, q8, q10
	vadd.i16	q9, q9, q11
	vadd.i16	q12, q12, q13
	vshr.u16	q15, q15, #1
	vadd.i16	q8, q8, q10
	vshr.u16	q9, q9, #1
	vshr.u16	q12, q12, #2
	vld1.64	{d0-d3}, [sp:64]
	vshr.u16	q8, q8, #2
	vmovn.i16	d20, q15
	vmovn.i16	d21, q9
	vst2.8	{d0-d3}, [r10]
	vmovn.i16	d22, q12
	vmovn.i16	d23, q8
	vst2.8	{d20-d23}, [r9]
.L6:
	mov	lr, r0
	strb	r0, [r2, #3008]
	adds	r2, r2, #2
	strb	r0, [r2, #3054]
	mov	ip, r4
	ldrb	r0, [r5, #1]!	@ zero_extendqisi2
	adds	r1, r1, #2
	strb	r4, [r1, #3006]
	add	r8, r0, lr
	strb	r4, [r1, #3054]
	add	lr, lr, r8
	ldrb	r4, [r6, #1]!	@ zero_extendqisi2
	add	lr, lr, r0
	add	r8, r8, #1
	add	lr, lr, #2
	cmp	r7, r5
	asr	r8, r8, #1
	strb	r8, [r2, #3007]
	asr	lr, lr, #2
	strb	lr, [r2, #3055]
	add	lr, r4, ip
	add	ip, ip, lr
	add	lr, lr, #1
	add	ip, ip, r4
	add	ip, ip, #2
	asr	lr, lr, #1
	strb	lr, [r1, #3007]
	asr	ip, ip, #2
	strb	ip, [r1, #3055]
	bne	.L6
	ldr	r2, [sp, #148]
	movw	r6, #:lower16:R
	movt	r6, #:upper16:R
	movw	r5, #:lower16:G
	movt	r5, #:upper16:G
	movw	r4, #:lower16:B
	movt	r4, #:upper16:B
	ldrb	r0, [r2, #767]	@ zero_extendqisi2
	ldr	r2, [sp, #152]
	mov	r10, #0
	vmov.i16	q13, #128  @ v8hi
	mov	r8, #208
	vmov.i32	q10, #128  @ v4si
	mov	lr, #100
	ldrb	r1, [r2, #767]	@ zero_extendqisi2
	mov	r2, #0	@ movhi
	bfi	r2, r0, #0, #8
	vldr	d5, [sp, #160]
	vldr	d4, [sp, #168]
	movw	ip, #409
	bfi	r2, r0, #8, #8
	movw	r0, #:lower16:Cb_temp
	movt	r0, #:upper16:Cb_temp
	vldr	d3, [sp, #176]
	vldr	d2, [sp, #184]
	strh	r2, [r0, #3022]	@ unaligned
	strh	r2, [r0, #3070]	@ unaligned
	mov	r2, #0	@ movhi
	bfi	r2, r1, #0, #8
	movw	r0, #:lower16:Y
	movt	r0, #:upper16:Y
	bfi	r2, r1, #8, #8
	movw	r1, #:lower16:Cr_temp
	movt	r1, #:upper16:Cr_temp
	strh	r2, [r1, #3022]	@ unaligned
	strh	r2, [r1, #3070]	@ unaligned
	mov	r1, #298
.L7:
	movs	r2, #0
	str	r10, [sp, #72]
	b	.L17
.L18:
	.align	2
.L16:
	.word	Cr+744
	.word	Cb+744
	.word	Cb+745
	.word	Cb_temp+2976
	.word	Cr_temp+2976
.L17:
.L8:
	add	r9, r2, r0
	movw	r7, #517
	vmov.i16	q9, #16  @ v8hi
	add	fp, r2, r5
	vmov.32	d2[0], r7
	vmov.32	d6[0], r7
	vld1.8	{d16}, [r9]
	vmov.32	d14[0], r1
	ldr	r7, [sp, #68]
	vmov.32	d29[0], r1
	vmov.32	d15[0], r8
	vmov.32	d5[0], r8
	vmovl.u8	q8, d16
	add	r9, r2, r7
	vmov.32	d28[0], lr
	vmov.32	d4[0], lr
	vmov	d8, d29  @ v2si
	vmov.32	d3[0], r1
	vmov.32	d10[0], r1
	vmov.32	d11[0], ip
	vsub.i16	q8, q8, q9
	add	r10, r2, r6
	vmov	q9, q10  @ v4si
	vmov.32	d12[0], r1
	vmov.32	d7[0], r1
	vmov.32	d13[0], ip
	vmovl.s16	q11, d16
	vld1.8	{d16}, [r9]
	vmovl.s16	q12, d17
	add	r9, r2, r3
	vmovl.u8	q8, d16
	vmla.i32	q9, q11, d14[0]
	vld1.8	{d30}, [r9]
	add	r9, r2, r4
	adds	r2, r2, #8
	cmp	r2, #48
	vsub.i16	q8, q8, q13
	vmovl.u8	q15, d30
	vmovl.s16	q0, d16
	vmovl.s16	q8, d17
	vsub.i16	q15, q15, q13
	vmls.i32	q9, q0, d15[0]
	vst1.64	{d0-d1}, [sp:64]
	vstr	d16, [sp, #32]
	vstr	d17, [sp, #40]
	vmov	q8, q10  @ v4si
	vldr	d0, [sp, #32]
	vldr	d1, [sp, #40]
	vmla.i32	q8, q12, d8[0]
	vmovl.s16	q4, d30
	vmovl.s16	q15, d31
	vmls.i32	q8, q0, d5[0]
	vmov	d1, d28  @ v2si
	vmls.i32	q8, q15, d4[0]
	vmls.i32	q9, q4, d1[0]
	vld1.64	{d0-d1}, [sp:64]
	vshr.s32	q8, q8, #8
	vshr.s32	q9, q9, #8
	vqmovn.s32	d16, q8
	vqmovn.s32	d18, q9
	vmov	d17, d16  @ v4hi
	vmov	d16, d18  @ v4hi
	vmov	q9, q10  @ v4si
	vqmovun.s16	d16, q8
	vmla.i32	q9, q11, d3[0]
	vst1.8	{d16}, [fp]
	vmov	q8, q10  @ v4si
	vmla.i32	q9, q4, d2[0]
	vmla.i32	q8, q11, d10[0]
	vmov	q11, q10  @ v4si
	vmla.i32	q8, q0, d11[0]
	vmov	q0, q9  @ v4si
	vmov	q9, q10  @ v4si
	vmla.i32	q11, q12, d12[0]
	vshr.s32	q8, q8, #8
	vmla.i32	q9, q12, d7[0]
	vldr	d24, [sp, #32]
	vldr	d25, [sp, #40]
	vqmovn.s32	d16, q8
	vmla.i32	q9, q15, d6[0]
	vmla.i32	q11, q12, d13[0]
	vshr.s32	q12, q0, #8
	vshr.s32	q9, q9, #8
	vshr.s32	q11, q11, #8
	vqmovn.s32	d24, q12
	vqmovn.s32	d18, q9
	vqmovn.s32	d22, q11
	vmov	d19, d18  @ v4hi
	vmov	d18, d24  @ v4hi
	vmov	d23, d22  @ v4hi
	vmov	d22, d16  @ v4hi
	vqmovun.s16	d18, q9
	vqmovun.s16	d22, q11
	vst1.8	{d18}, [r9]
	vst1.8	{d22}, [r10]
	bne	.L8
	ldr	r10, [sp, #72]
	add	r2, r7, #48
	adds	r6, r6, #48
	adds	r5, r5, #48
	add	r10, r10, #48
	adds	r4, r4, #48
	adds	r0, r0, #48
	adds	r3, r3, #48
	cmp	r10, #3072
	str	r2, [sp, #68]
	bne	.L7
	add	sp, sp, #196
	@ sp needed
	vldm	sp!, {d8-d15}
	pop	{r4, r5, r6, r7, r8, r9, r10, fp, pc}
	.size	CSC_YCC_to_RGB, .-CSC_YCC_to_RGB
	.ident	"GCC: (Arm GNU Toolchain 15.3.Rel1 (Build arm-15.149)) 15.3.1 20260627"
	.section	.note.GNU-stack,"",%progbits
