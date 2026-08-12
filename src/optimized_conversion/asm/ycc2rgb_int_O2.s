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
	@ args = 0, pretend = 0, frame = 368
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
	movw	r1, #:lower16:Cr
	movt	r1, #:upper16:Cr
	vpush.64	{d8, d9, d10, d11, d12, d13, d14, d15}
	sub	sp, sp, #372
	mov	ip, r1
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	movw	r2, #:lower16:Cb
	movt	r2, #:upper16:Cb
	str	r1, [sp, #192]
	vmov.i16	q10, #2  @ v8hi
	movs	r1, #81
	str	r2, [sp, #176]
	adds	r2, r2, #23
	str	r1, [sp, #80]
	movs	r1, #80
	str	r2, [sp, #64]
	mov	r2, r3
	str	r1, [sp, #96]
	movs	r1, #24
	str	r1, [sp, #48]
	mov	r1, ip
	movs	r0, #0
	movw	r4, #:lower16:Cb_temp
	movt	r4, #:upper16:Cb_temp
	str	r0, [sp, #112]
	str	r4, [sp, #208]
	str	r0, [sp]
	str	r3, [sp, #224]
.L2:
	ldr	r0, [sp, #64]
	add	r5, r4, #48
	ldr	r6, .L16
	sub	r3, r0, #22
	mov	r7, r0
	str	r4, [sp, #144]
	str	r2, [sp, #160]
	vld1.8	{q14}, [r3]
	sub	r3, r0, #23
	vmovl.u8 q9, d28
	vld1.8	{q11}, [r3]
	adds	r3, r0, #1
	vmovl.u8 q8, d29
	vaddw.u8	q9, q9, d22
	vld1.8	{q3}, [r3]
	adds	r3, r0, #2
	vaddw.u8	q8, q8, d23
	vadd.i16	q9, q9, q10
	vrhadd.u8	q13, q11, q14
	vmov	q12, q11  @ v16qi
	vadd.i16	q8, q8, q10
	vrhadd.u8	q14, q11, q3
	vaddw.u8	q9, q9, d6
	vld1.8	{q11}, [r3]
	mov	r3, r1
	vaddw.u8	q8, q8, d7
	adds	r1, r1, #24
	vst2.8	{d24-d27}, [r4]
	mov	r10, r3
	vaddw.u8	q9, q9, d22
	str	r1, [sp, #128]
	vaddw.u8	q8, q8, d23
	vld1.8	{q11}, [r3]
	vshr.u16	q9, q9, #2
	vshr.u16	q8, q8, #2
	vld1.8	{q1}, [r1]
	vmov	q2, q11  @ v16qi
	vmovn.i16	d30, q9
	vmovn.i16	d31, q8
	vmov	q8, q10  @ v8hi
	vaddw.u8	q9, q10, d22
	vrhadd.u8	q12, q11, q1
	vst2.8	{d28-d31}, [r5]
	ldr	r5, [sp, #48]
	vaddw.u8	q8, q8, d23
	vaddw.u8	q9, q9, d2
	adds	r5, r6, r5
	vld1.8	{q14}, [r5]
	vaddw.u8	q8, q8, d3
	ldr	r5, [sp]
	vaddw.u8	q9, q9, d28
	subs	r5, r6, r5
	mov	r6, r2
	vaddw.u8	q8, q8, d29
	vld1.8	{q14}, [r5]
	add	r5, r2, #48
	vaddw.u8	q9, q9, d28
	vaddw.u8	q8, q8, d29
	vrhadd.u8	q3, q11, q14
	vshr.u16	q9, q9, #2
	vshr.u16	q8, q8, #2
	vst2.8	{d4-d7}, [r2]
	vmovn.i16	d26, q9
	vmovn.i16	d27, q8
	vst2.8	{d24-d27}, [r5]
	mov	r5, r4
	ldrb	r9, [r3, #40]	@ zero_extendqisi2
	ldrb	r8, [r0, #17]	@ zero_extendqisi2
	ldrb	lr, [r10, #16]!	@ zero_extendqisi2
	ldrb	ip, [r7, #-7]!	@ zero_extendqisi2
.L3:
	ldr	r4, [sp, #112]
	mov	r0, ip
	strb	ip, [r5, #32]
	mov	r1, lr
	add	fp, r5, r4
	ldrb	ip, [r7, #1]!	@ zero_extendqisi2
	add	r4, r4, r6
	str	r4, [sp, #16]
	ldr	r4, [sp]
	mov	r2, r8
	ldr	r3, [sp, #48]
	adds	r5, r5, #2
	adds	r4, r7, r4
	strb	lr, [r6, #32]
	ldrb	lr, [r10, #1]!	@ zero_extendqisi2
	adds	r6, r6, #2
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
	strb	r4, [r5, #31]
	ldr	r4, [sp, #96]
	asrs	r0, r0, #1
	adds	r2, r2, #2
	strb	r0, [fp, r4]
	asrs	r2, r2, #2
	ldr	r0, [sp, #80]
	strb	r2, [fp, r0]
	add	r2, lr, r1
	add	r1, r1, r3
	add	r3, r3, r2
	adds	r2, r2, #1
	add	r3, r3, r9
	adds	r1, r1, #1
	adds	r3, r3, #2
	asrs	r2, r2, #1
	strb	r2, [r6, #31]
	ldr	r2, [sp, #16]
	asrs	r3, r3, #2
	asrs	r1, r1, #1
	strb	r1, [r2, r4]
	strb	r3, [r2, r0]
	ldr	r3, [sp, #64]
	cmp	r7, r3
	bne	.L3
	ldr	r0, [sp]
	ldr	r3, [sp, #112]
	subs	r0, r0, #24
	str	r0, [sp]
	ldr	r0, [sp, #48]
	subs	r3, r3, #96
	ldr	r4, [sp, #144]
	cmn	r3, #2976
	add	r0, r0, #24
	str	r0, [sp, #48]
	ldr	r0, [sp, #96]
	add	r4, r4, #96
	ldr	r2, [sp, #160]
	add	r0, r0, #96
	str	r0, [sp, #96]
	ldr	r0, [sp, #80]
	add	r2, r2, #96
	ldr	r1, [sp, #128]
	add	r0, r0, #96
	str	r3, [sp, #112]
	str	r0, [sp, #80]
	add	r0, r7, #24
	str	r0, [sp, #64]
	bne	.L2
	ldr	r2, [sp, #192]
	movw	r5, #:lower16:Cr_temp
	movt	r5, #:upper16:Cr_temp
	ldr	r8, .L16+8
	ldr	r3, [sp, #224]
	movw	r4, #:lower16:Cb_temp
	movt	r4, #:upper16:Cb_temp
	ldrb	ip, [r2, #23]	@ zero_extendqisi2
	ldr	r2, [sp, #176]
	sub	r6, r8, #744
	str	r6, [sp, #176]
	ldrb	r7, [r2, #23]	@ zero_extendqisi2
	movw	r2, #:lower16:Cr
	movt	r2, #:upper16:Cr
	str	r2, [sp, #192]
	mov	lr, r2
.L5:
	mov	r1, r7
	ldrb	r7, [r6, #47]	@ zero_extendqisi2
	strb	r1, [r4, #46]
	mov	r2, ip
	adds	r0, r1, r7
	strb	r1, [r4, #47]
	add	r1, r1, r0
	strb	ip, [r5, #46]
	add	r1, r1, r7
	strb	ip, [r5, #47]
	adds	r1, r1, #2
	ldrb	ip, [lr, #47]	@ zero_extendqisi2
	adds	r0, r0, #1
	adds	r6, r6, #24
	asrs	r1, r1, #2
	strb	r1, [r4, #95]
	add	r1, r2, ip
	asrs	r0, r0, #1
	add	r2, r2, r1
	adds	r1, r1, #1
	add	r2, r2, ip
	strb	r0, [r4, #94]
	adds	r2, r2, #2
	asrs	r1, r1, #1
	add	lr, lr, #24
	strb	r1, [r5, #94]
	asrs	r2, r2, #2
	adds	r4, r4, #96
	strb	r2, [r5, #95]
	cmp	r8, r6
	add	r5, r5, #96
	bne	.L5
	vld1.8	{q9}, [r8]
	vmov.i8	q15, #2  @ v16qi
	ldr	r6, .L16+4
	vmov.i16	q14, #1  @ v8hi
	ldr	r8, .L16+12
	vmov	q4, q9  @ v16qi
	add	fp, r6, #1
	vmovl.u8 q12, d18
	ldr	r2, [sp, #192]
	vmull.u8 q10, d18, d30
	ldr	lr, .L16+16
	vmull.u8 q8, d19, d31
	ldr	ip, .L16+20
	vld1.8	{q1}, [r8]
	add	r10, lr, #48
	vadd.i16	q10, q10, q14
	ldrb	r4, [r2, #760]	@ zero_extendqisi2
	vadd.i16	q8, q8, q14
	ldr	r2, [sp, #176]
	vrhadd.u8	q5, q9, q1
	add	r9, ip, #48
	vmovl.u8 q11, d19
	add	r5, r8, #15
	vshr.u16	q10, q10, #1
	ldrb	r0, [r2, #760]	@ zero_extendqisi2
	vshr.u16	q8, q8, #1
	add	r7, r8, #22
	vmov.i16	q0, #2  @ v8hi
	sub	r1, ip, #2976
	vadd.i16	q12, q12, q12
	sub	r2, lr, #2976
	vadd.i16	q11, q11, q11
	vst2.8	{d8-d11}, [lr]
	vmovn.i16	d4, q10
	vmovn.i16	d5, q8
	vld1.8	{q8}, [r6]
	adds	r6, r6, #16
	vadd.i16	q12, q12, q0
	vadd.i16	q11, q11, q0
	vmovl.u8 q10, d16
	vmovl.u8 q9, d17
	vld1.8	{q13}, [fp]
	vadd.i16	q10, q10, q10
	vadd.i16	q9, q9, q9
	vrhadd.u8	q7, q8, q13
	vmov	q6, q8  @ v16qi
	vadd.i16	q10, q10, q0
	vadd.i16	q9, q9, q0
	vmovl.u8 q0, d2
	vmovl.u8 q1, d3
	vst2.8	{d12-d15}, [ip]
	vadd.i16	q12, q12, q0
	vadd.i16	q11, q11, q1
	vadd.i16	q12, q12, q0
	vadd.i16	q11, q11, q1
	vshr.u16	q12, q12, #2
	vshr.u16	q11, q11, #2
	vmovn.i16	d6, q12
	vmovn.i16	d7, q11
	vmovl.u8 q12, d26
	vmovl.u8 q13, d27
	vmull.u8 q11, d16, d30
	vmull.u8 q8, d17, d31
	vst2.8	{d4-d7}, [r10]
	vadd.i16	q10, q10, q12
	vadd.i16	q9, q9, q13
	vadd.i16	q11, q11, q14
	vadd.i16	q8, q8, q14
	vadd.i16	q10, q10, q12
	vadd.i16	q9, q9, q13
	vshr.u16	q11, q11, #1
	vshr.u16	q8, q8, #1
	vshr.u16	q10, q10, #2
	vshr.u16	q9, q9, #2
	vmovn.i16	d24, q11
	vmovn.i16	d25, q8
	vmovn.i16	d26, q10
	vmovn.i16	d27, q9
	vst2.8	{d24-d27}, [r9]
	b	.L17
.L18:
	.align	2
.L16:
	.word	Cr+1
	.word	Cr+744
	.word	Cb+744
	.word	Cb+745
	.word	Cb_temp+2976
	.word	Cr_temp+2976
.L17:
.L6:
	mov	lr, r0
	ldrb	r0, [r5, #1]!	@ zero_extendqisi2
	mov	ip, r4
	strb	lr, [r2, #3008]
	adds	r1, r1, #2
	add	r8, lr, r0
	strb	lr, [r2, #3056]
	add	lr, lr, r8
	strb	r4, [r1, #3006]
	add	lr, lr, r0
	strb	r4, [r1, #3054]
	add	lr, lr, #2
	ldrb	r4, [r6, #1]!	@ zero_extendqisi2
	add	r8, r8, #1
	adds	r2, r2, #2
	asr	lr, lr, #2
	strb	lr, [r2, #3055]
	add	lr, ip, r4
	asr	r8, r8, #1
	add	ip, ip, lr
	add	lr, lr, #1
	add	ip, ip, r4
	strb	r8, [r2, #3007]
	add	ip, ip, #2
	asr	lr, lr, #1
	cmp	r7, r5
	strb	lr, [r1, #3007]
	asr	ip, ip, #2
	strb	ip, [r1, #3055]
	bne	.L6
	ldr	r2, [sp, #176]
	movw	fp, #:lower16:B
	movt	fp, #:upper16:B
	vmov.i32	q5, #128  @ v4si
	add	r4, fp, #48
	vmov.i32	q6, #255  @ v4si
	ldrb	r0, [r2, #767]	@ zero_extendqisi2
	ldr	r2, [sp, #192]
	ldrb	r1, [r2, #767]	@ zero_extendqisi2
	mov	r2, #0	@ movhi
	bfi	r2, r0, #0, #8
	bfi	r2, r0, #8, #8
	ldr	r0, [sp, #208]
	strh	r2, [r0, #3022]	@ unaligned
	strh	r2, [r0, #3070]	@ unaligned
	mov	r2, #0	@ movhi
	bfi	r2, r1, #0, #8
	ldr	r0, .L19+16
	str	r0, [sp, #356]
	bfi	r2, r1, #8, #8
	movw	r1, #:lower16:Cr_temp
	movt	r1, #:upper16:Cr_temp
	ldr	r0, .L19+20
	str	r0, [sp, #360]
	ldr	r0, .L19+24
	strh	r2, [r1, #3022]	@ unaligned
	strh	r2, [r1, #3070]	@ unaligned
	movw	r2, #:lower16:G
	movt	r2, #:upper16:G
	movw	r1, #:lower16:R
	movt	r1, #:upper16:R
	str	r2, [sp, #344]
	str	r1, [sp, #352]
	adds	r2, r2, #48
	str	r0, [sp, #364]
	str	r2, [sp, #340]
	add	r2, r1, #48
	str	r2, [sp, #348]
.L8:
	movs	r2, #0
.L7:
	ldr	r1, [sp, #364]
	add	r6, r2, fp
	vmov.i8	q14, #128  @ v16qi
	ldr	r5, [sp, #352]
	vmov.i16	q2, #65328  @ v8hi
	adds	r0, r2, r1
	adds	r1, r2, r3
	sub	r10, r0, #48
	vmov.i16	q3, #65520  @ v8hi
	add	r8, r2, r5
	vld1.8	{q13}, [r0]
	mov	r0, #298	@ movhi
	vld1.8	{q8}, [r1]
	ldr	r1, [sp, #356]
	vld1.8	{q12}, [r10]
	adds	r1, r2, r1
	vadd.i8	q8, q8, q14
	ldr	r5, [sp, #348]
	vaddw.u8	q15, q3, d24
	add	lr, r2, r5
	ldr	r5, [sp, #344]
	vmovl.s8 q11, d16
	vmovl.s8 q8, d17
	add	ip, r2, r5
	ldr	r5, [sp, #340]
	vmul.i16	q9, q11, q2
	adds	r7, r2, r5
	adds	r5, r2, r4
	vstr	d18, [sp, #32]
	vstr	d19, [sp, #40]
	vmul.i16	q9, q8, q2
	vstr	d18, [sp, #128]
	vstr	d19, [sp, #136]
	vld1.8	{q9}, [r1]
	ldr	r1, [sp, #360]
	vadd.i8	q9, q9, q14
	adds	r1, r2, r1
	sub	r9, r1, #48
	adds	r2, r2, #16
	cmp	r2, #48
	vmovl.s8 q1, d18
	vmovl.s8 q0, d19
	vld1.8	{q10}, [r9]
	vmul.i16	q4, q1, q2
	vstr	d2, [sp, #96]
	vstr	d3, [sp, #104]
	vmul.i16	q2, q0, q2
	vstr	d0, [sp, #112]
	vstr	d1, [sp, #120]
	vld1.8	{q9}, [r1]
	vstr	d8, [sp, #160]
	vstr	d9, [sp, #168]
	vdup.16	q4, r0
	vadd.i8	q10, q10, q14
	vstr	d4, [sp, #288]
	vstr	d5, [sp, #296]
	vdup.16	d5, r0
	vadd.i8	q9, q9, q14
	vmov	q14, q3  @ v8hi
	vaddw.u8	q3, q3, d26
	vmull.s16 q1, d30, d5
	vdup.16	q2, r0
	vmov.i16	q0, #65436  @ v8hi
	vaddw.u8	q14, q14, d25
	vmov.i16	q12, #65520  @ v8hi
	vmull.s16 q15, d31, d5
	vdup.16	d5, r0
	vmull.s16 q7, d29, d9
	vaddw.u8	q12, q12, d27
	vmull.s16 q2, d28, d5
	vdup.16	d28, r0
	vmovl.s8 q13, d20
	vmovl.s8 q10, d21
	vstr	d14, [sp, #48]
	vstr	d15, [sp, #56]
	vmull.s16 q14, d6, d28
	vmull.s16 q3, d7, d9
	vstr	d28, [sp, #64]
	vstr	d29, [sp, #72]
	vdup.16	d29, r0
	movw	r0, 517	@ movhi
	vstr	d6, [sp, #16]
	vstr	d7, [sp, #24]
	vdup.16	q7, r0
	vldr	d6, .L19
	vldr	d7, .L19+8
	vmull.s16 q4, d24, d29
	vmull.s16 q14, d25, d7
	vdup.16	d7, r0
	vmovl.s8 q12, d18
	vmovl.s8 q9, d19
	vstr	d8, [sp, #80]
	vstr	d9, [sp, #88]
	vmull.s16 q3, d26, d7
	vmul.i16	q4, q13, q0
	vmull.s16 q13, d27, d15
	vmul.i16	q0, q10, q0
	vadd.i32	q3, q3, q1
	vadd.i32	q13, q13, q15
	vadd.i32	q3, q3, q5
	vadd.i32	q13, q13, q5
	vshr.s32	q3, q3, #8
	vstr	d6, [sp, #272]
	vstr	d7, [sp, #280]
	vshr.s32	q3, q13, #8
	vmov.i16	q13, #65436  @ v8hi
	vstr	d6, [sp, #176]
	vstr	d7, [sp, #184]
	vmul.i16	q3, q12, q13
	vmul.i16	q13, q9, q13
	vstr	d26, [sp, #144]
	vstr	d27, [sp, #152]
	vdup.16	d27, r0
	vmull.s16 q13, d20, d27
	vmull.s16 q10, d21, d15
	vldr	d14, [sp, #48]
	vldr	d15, [sp, #56]
	vadd.i32	q13, q13, q2
	vadd.i32	q10, q10, q7
	vdup.16	q7, r0
	vadd.i32	q13, q13, q5
	vadd.i32	q10, q10, q5
	vshr.s32	q13, q13, #8
	vshr.s32	q10, q10, #8
	vstr	d26, [sp, #192]
	vstr	d27, [sp, #200]
	vst1.64	{d20-d21}, [sp:64]
	vdup.16	d21, r0
	vldr	d26, [sp, #64]
	vldr	d27, [sp, #72]
	vmull.s16 q10, d24, d21
	vmull.s16 q12, d25, d15
	vadd.i32	q10, q10, q13
	vldr	d26, [sp, #16]
	vldr	d27, [sp, #24]
	vadd.i32	q10, q10, q5
	vadd.i32	q12, q12, q13
	vshr.s32	q10, q10, #8
	vadd.i32	q12, q12, q5
	vstr	d20, [sp, #208]
	vstr	d21, [sp, #216]
	vdup.16	d21, r0
	movw	r0, 409	@ movhi
	vshr.s32	q12, q12, #8
	vmull.s16 q10, d18, d21
	vmull.s16 q9, d19, d15
	vstr	d24, [sp, #224]
	vstr	d25, [sp, #232]
	vldr	d26, [sp, #80]
	vldr	d27, [sp, #88]
	vadd.i32	q9, q9, q14
	vmov	q12, q15  @ v4si
	vadd.i32	q10, q10, q13
	vmov	q13, q14  @ v4si
	vadd.i32	q9, q9, q5
	vldr	d14, [sp, #48]
	vldr	d15, [sp, #56]
	vadd.i32	q10, q10, q5
	vshr.s32	q14, q10, #8
	vshr.s32	q10, q9, #8
	vldr	d18, [sp, #32]
	vldr	d19, [sp, #40]
	vstr	d28, [sp, #240]
	vstr	d29, [sp, #248]
	vaddw.s16	q12, q12, d19
	vstr	d20, [sp, #256]
	vstr	d21, [sp, #264]
	vaddw.s16	q10, q1, d18
	vmov	q14, q7  @ v4si
	vmov	q9, q12  @ v4si
	vldr	d24, [sp, #160]
	vldr	d25, [sp, #168]
	vaddw.s16	q10, q10, d8
	vaddw.s16	q9, q9, d9
	vadd.i32	q10, q10, q5
	vadd.i32	q9, q9, q5
	vshr.s32	q4, q10, #8
	vshr.s32	q9, q9, #8
	vstr	d18, [sp, #32]
	vstr	d19, [sp, #40]
	vldr	d18, [sp, #128]
	vldr	d19, [sp, #136]
	vaddw.s16	q14, q14, d19
	vaddw.s16	q10, q2, d18
	vmov	q9, q14  @ v4si
	vaddw.s16	q10, q10, d0
	vldr	d28, [sp, #64]
	vldr	d29, [sp, #72]
	vaddw.s16	q9, q9, d1
	vadd.i32	q10, q10, q5
	vadd.i32	q9, q9, q5
	vshr.s32	q10, q10, #8
	vshr.s32	q0, q9, #8
	vdup.16	d19, r0
	vmull.s16 q9, d22, d19
	vadd.i32	q9, q9, q1
	vdup.16	q1, r0
	vadd.i32	q9, q9, q5
	vmull.s16 q11, d23, d3
	vadd.i32	q11, q11, q15
	vshr.s32	q15, q9, #8
	vdup.16	d19, r0
	vadd.i32	q11, q11, q5
	vmull.s16 q9, d16, d19
	vshr.s32	q1, q11, #8
	vdup.16	d23, r0
	vadd.i32	q9, q9, q2
	vdup.16	q2, r0
	vadd.i32	q9, q9, q5
	vmull.s16 q8, d17, d5
	vshr.s32	q2, q9, #8
	vadd.i32	q8, q8, q7
	vaddw.s16	q9, q14, d24
	vldr	d14, [sp, #80]
	vldr	d15, [sp, #88]
	vadd.i32	q8, q8, q5
	vaddw.s16	q9, q9, d6
	vshr.s32	q8, q8, #8
	vadd.i32	q9, q9, q5
	vstr	d16, [sp, #48]
	vstr	d17, [sp, #56]
	vldr	d16, [sp, #16]
	vldr	d17, [sp, #24]
	vaddw.s16	q8, q8, d25
	vldr	d24, [sp, #288]
	vldr	d25, [sp, #296]
	vaddw.s16	q8, q8, d7
	vshr.s32	q3, q9, #8
	vaddw.s16	q9, q7, d24
	vadd.i32	q8, q8, q5
	vshr.s32	q8, q8, #8
	b	.L20
.L21:
	.align	3
.L19:
	.short	298
	.short	298
	.short	298
	.short	298
	.short	298
	.short	298
	.short	298
	.short	298
	.word	Cr_temp+48
	.word	Cb_temp+48
	.word	Y+48
.L20:
	vstr	d16, [sp, #128]
	vstr	d17, [sp, #136]
	vmov	q8, q13  @ v4si
	vaddw.s16	q8, q8, d25
	vldr	d24, [sp, #144]
	vldr	d25, [sp, #152]
	vaddw.s16	q9, q9, d24
	vaddw.s16	q8, q8, d25
	vdup.16	q12, r0
	vadd.i32	q9, q9, q5
	vadd.i32	q8, q8, q5
	vshr.s32	q9, q9, #8
	vstr	d18, [sp, #144]
	vstr	d19, [sp, #152]
	vshr.s32	q9, q8, #8
	vstr	d18, [sp, #160]
	vstr	d19, [sp, #168]
	vldr	d18, [sp, #96]
	vldr	d19, [sp, #104]
	vmull.s16 q8, d18, d23
	vldr	d22, [sp, #16]
	vldr	d23, [sp, #24]
	vmull.s16 q9, d19, d25
	vadd.i32	q8, q8, q14
	vldr	d28, [sp, #192]
	vldr	d29, [sp, #200]
	vadd.i32	q9, q9, q11
	vadd.i32	q8, q8, q5
	vclt.s32	q14, q14, #0
	vadd.i32	q9, q9, q5
	vshr.s32	q11, q8, #8
	vstr	d22, [sp, #16]
	vstr	d23, [sp, #24]
	vshr.s32	q11, q9, #8
	vldr	d18, [sp, #112]
	vldr	d19, [sp, #120]
	vstr	d22, [sp, #64]
	vstr	d23, [sp, #72]
	vdup.16	d23, r0
	vmull.s16 q8, d18, d23
	vmull.s16 q9, d19, d25
	vadd.i32	q8, q8, q7
	vadd.i32	q9, q9, q13
	vld1.64	{d14-d15}, [sp:64]
	vadd.i32	q8, q8, q5
	vadd.i32	q9, q9, q5
	vshr.s32	q13, q8, #8
	vshr.s32	q11, q9, #8
	vldr	d18, [sp, #176]
	vldr	d19, [sp, #184]
	vstr	d26, [sp, #80]
	vstr	d27, [sp, #88]
	vldr	d26, [sp, #272]
	vldr	d27, [sp, #280]
	vstr	d22, [sp, #96]
	vstr	d23, [sp, #104]
	vclt.s32	q8, q9, #0
	vclt.s32	q11, q13, #0
	vmovn.i32	d18, q11
	vmovn.i32	d19, q8
	vclt.s32	q11, q7, #0
	vmovn.i32	d16, q14
	vmovn.i32	d17, q11
	vmovn.i16	d24, q9
	vmovn.i16	d25, q8
	vldr	d22, [sp, #208]
	vldr	d23, [sp, #216]
	vldr	d16, [sp, #224]
	vldr	d17, [sp, #232]
	vclt.s32	q11, q11, #0
	vldr	d28, [sp, #240]
	vldr	d29, [sp, #248]
	vclt.s32	q8, q8, #0
	vclt.s32	q14, q14, #0
	vmovn.i32	d18, q11
	vmovn.i32	d19, q8
	vldr	d22, [sp, #256]
	vldr	d23, [sp, #264]
	vclt.s32	q11, q11, #0
	vmovn.i32	d16, q14
	vmovn.i32	d17, q11
	vclt.s32	q11, q4, #0
	vmovn.i16	d28, q9
	vmovn.i16	d29, q8
	vstr	d28, [sp, #112]
	vstr	d29, [sp, #120]
	vldr	d16, [sp, #32]
	vldr	d17, [sp, #40]
	vclt.s32	q14, q10, #0
	vclt.s32	q8, q8, #0
	vmovn.i32	d18, q11
	vmovn.i32	d19, q8
	vclt.s32	q11, q0, #0
	vmovn.i32	d16, q14
	vmovn.i32	d17, q11
	vclt.s32	q11, q15, #0
	vmovn.i16	d28, q9
	vmovn.i16	d29, q8
	vclt.s32	q8, q1, #0
	vstr	d28, [sp, #272]
	vstr	d29, [sp, #280]
	vclt.s32	q14, q2, #0
	vmovn.i32	d18, q11
	vmovn.i32	d19, q8
	vldr	d22, [sp, #48]
	vldr	d23, [sp, #56]
	vclt.s32	q11, q11, #0
	vmovn.i32	d16, q14
	vmovn.i32	d17, q11
	vclt.s32	q11, q3, #0
	vmovn.i16	d28, q9
	vmovn.i16	d29, q8
	vstr	d28, [sp, #288]
	vstr	d29, [sp, #296]
	vldr	d28, [sp, #128]
	vldr	d29, [sp, #136]
	vclt.s32	q8, q14, #0
	vldr	d28, [sp, #144]
	vldr	d29, [sp, #152]
	vmovn.i32	d18, q11
	vmovn.i32	d19, q8
	vldr	d16, [sp, #160]
	vldr	d17, [sp, #168]
	vclt.s32	q14, q14, #0
	vclt.s32	q11, q8, #0
	vmovn.i32	d16, q14
	vmovn.i32	d17, q11
	vmovn.i16	d22, q9
	vmovn.i16	d23, q8
	vldr	d18, [sp, #16]
	vldr	d19, [sp, #24]
	vldr	d16, [sp, #64]
	vldr	d17, [sp, #72]
	vstr	d22, [sp, #304]
	vstr	d23, [sp, #312]
	vclt.s32	q11, q9, #0
	vclt.s32	q8, q8, #0
	vmovn.i32	d18, q11
	vmovn.i32	d19, q8
	vldr	d22, [sp, #80]
	vldr	d23, [sp, #88]
	vclt.s32	q14, q11, #0
	vldr	d22, [sp, #96]
	vldr	d23, [sp, #104]
	vclt.s32	q11, q11, #0
	vmovn.i32	d16, q14
	vmovn.i32	d17, q11
	vmovn.i16	d22, q9
	vmovn.i16	d23, q8
	vldr	d18, [sp, #176]
	vldr	d19, [sp, #184]
	vstr	d22, [sp, #320]
	vstr	d23, [sp, #328]
	vcgt.s32	q14, q9, q6
	vmovn.i32	d16, q13
	vmovn.i32	d17, q9
	vcgt.s32	q11, q13, q6
	vmov	q13, q7  @ v4si
	vmovn.i32	d18, q11
	vmovn.i32	d19, q14
	vldr	d28, [sp, #192]
	vldr	d29, [sp, #200]
	vmov	q7, q14  @ v4si
	vcgt.s32	q11, q14, q6
	vmovn.i32	d28, q7
	vmovn.i32	d29, q13
	vmovn.i16	d26, q8
	vmovn.i16	d27, q14
	vld1.64	{d16-d17}, [sp:64]
	vmov.i32	q14, #0  @ v16qi
	vldr	d14, [sp, #256]
	vldr	d15, [sp, #264]
	vcgt.s32	q8, q8, q6
	vbit	q13, q14, q12
	vmovn.i32	d28, q11
	vmovn.i32	d29, q8
	vmovn.i16	d16, q9
	vmovn.i16	d17, q14
	vmov.i32	q14, #0  @ v16qi
	vorr	q12, q13, q8
	vldr	d16, [sp, #208]
	vldr	d17, [sp, #216]
	vldr	d26, [sp, #240]
	vldr	d27, [sp, #248]
	vst1.64	{d24-d25}, [sp:64]
	vmov	q11, q8  @ v4si
	vldr	d24, [sp, #224]
	vldr	d25, [sp, #232]
	vcgt.s32	q9, q8, q6
	vmovn.i32	d16, q11
	vmovn.i32	d17, q12
	vcgt.s32	q12, q12, q6
	vmovn.i32	d22, q9
	vmovn.i32	d23, q12
	vmovn.i32	d24, q13
	vmovn.i32	d25, q7
	vcgt.s32	q9, q13, q6
	vmovn.i16	d26, q8
	vmovn.i16	d27, q12
	vldr	d24, [sp, #112]
	vldr	d25, [sp, #120]
	vcgt.s32	q8, q7, q6
	vbit	q13, q14, q12
	vmovn.i32	d24, q9
	vmovn.i32	d25, q8
	vmovn.i16	d16, q11
	vmovn.i16	d17, q12
	vldr	d24, [sp, #32]
	vldr	d25, [sp, #40]
	vcgt.s32	q11, q4, q6
	vorr	q8, q13, q8
	vmovn.i32	d26, q10
	vmovn.i32	d27, q0
	vcgt.s32	q7, q12, q6
	vmovn.i32	d18, q4
	vmovn.i32	d19, q12
	vcgt.s32	q0, q0, q6
	vmov	q4, q14  @ v16qi
	vmovn.i32	d24, q11
	vmovn.i32	d25, q7
	vcgt.s32	q11, q10, q6
	vmovn.i16	d20, q9
	vmovn.i16	d21, q13
	vldr	d14, [sp, #272]
	vldr	d15, [sp, #280]
	vmovn.i32	d18, q11
	vmovn.i32	d19, q0
	vbit	q10, q14, q7
	vmovn.i16	d22, q12
	vmovn.i16	d23, q9
	vmovn.i32	d18, q15
	vmovn.i32	d19, q1
	vcgt.s32	q1, q1, q6
	vldr	d0, [sp, #288]
	vldr	d1, [sp, #296]
	vorr	q11, q10, q11
	vcgt.s32	q10, q15, q6
	vmovn.i32	d24, q10
	vmovn.i32	d25, q1
	vldr	d2, [sp, #48]
	vldr	d3, [sp, #56]
	vcgt.s32	q10, q2, q6
	vmovn.i32	d26, q2
	vmovn.i32	d27, q1
	vmovn.i16	d28, q9
	vmovn.i16	d29, q13
	vcgt.s32	q9, q1, q6
	vldr	d4, [sp, #160]
	vldr	d5, [sp, #168]
	vbit	q14, q4, q0
	vmovn.i32	d26, q10
	vmovn.i32	d27, q9
	vcgt.s32	q10, q3, q6
	vmovn.i16	d18, q12
	vmovn.i16	d19, q13
	vldr	d24, [sp, #128]
	vldr	d25, [sp, #136]
	vorr	q14, q14, q9
	vldr	d2, [sp, #304]
	vldr	d3, [sp, #312]
	vmovn.i32	d18, q3
	vmovn.i32	d19, q12
	vcgt.s32	q13, q12, q6
	vst1.8	{q14}, [r8]
	vldr	d28, [sp, #144]
	vldr	d29, [sp, #152]
	vmovn.i32	d24, q10
	vmovn.i32	d25, q13
	vcgt.s32	q10, q14, q6
	vmovn.i32	d26, q14
	vmovn.i32	d27, q2
	vmovn.i16	d28, q9
	vmovn.i16	d29, q13
	vcgt.s32	q9, q2, q6
	vbit	q14, q4, q1
	vmovn.i32	d26, q10
	vmovn.i32	d27, q9
	vmovn.i16	d18, q12
	vmovn.i16	d19, q13
	vorr	q14, q14, q9
	vldr	d18, [sp, #16]
	vldr	d19, [sp, #24]
	vldr	d26, [sp, #64]
	vldr	d27, [sp, #72]
	vcgt.s32	q12, q9, q6
	vldr	d4, [sp, #96]
	vldr	d5, [sp, #104]
	vmovn.i32	d20, q9
	vmovn.i32	d21, q13
	vcgt.s32	q9, q13, q6
	vmovn.i32	d26, q12
	vmovn.i32	d27, q9
	vldr	d18, [sp, #80]
	vldr	d19, [sp, #88]
	vcgt.s32	q15, q9, q6
	vmovn.i32	d24, q9
	vmovn.i32	d25, q2
	vmovn.i16	d18, q10
	vmovn.i16	d19, q12
	vldr	d20, [sp, #320]
	vldr	d21, [sp, #328]
	vbit	q9, q4, q10
	vcgt.s32	q10, q2, q6
	vmovn.i32	d24, q15
	vmovn.i32	d25, q10
	vmovn.i16	d20, q13
	vmovn.i16	d21, q12
	vld1.64	{d24-d25}, [sp:64]
	vorr	q9, q9, q10
	vst1.8	{q9}, [lr]
	vst1.8	{q11}, [ip]
	vst1.8	{q14}, [r7]
	vst1.8	{q12}, [r6]
	vst1.8	{q8}, [r5]
	bne	.L7
	ldr	r2, [sp, #340]
	adds	r4, r4, #96
	add	fp, fp, #96
	adds	r2, r2, #96
	str	r2, [sp, #340]
	ldr	r2, [sp, #344]
	adds	r3, r3, #96
	adds	r2, r2, #96
	str	r2, [sp, #344]
	ldr	r2, [sp, #348]
	adds	r2, r2, #96
	str	r2, [sp, #348]
	ldr	r2, [sp, #352]
	adds	r2, r2, #96
	str	r2, [sp, #352]
	ldr	r2, [sp, #356]
	adds	r2, r2, #96
	str	r2, [sp, #356]
	ldr	r2, [sp, #360]
	adds	r2, r2, #96
	str	r2, [sp, #360]
	ldr	r2, [sp, #364]
	adds	r2, r2, #96
	str	r2, [sp, #364]
	ldr	r2, .L22
	cmp	r4, r2
	bne	.L8
	add	sp, sp, #372
	@ sp needed
	vldm	sp!, {d8-d15}
	pop	{r4, r5, r6, r7, r8, r9, r10, fp, pc}
.L23:
	.align	2
.L22:
	.word	B+3120
	.size	CSC_YCC_to_RGB, .-CSC_YCC_to_RGB
	.ident	"GCC: (Arm GNU Toolchain 15.3.Rel1 (Build arm-15.149)) 15.3.1 20260627"
	.section	.note.GNU-stack,"",%progbits
