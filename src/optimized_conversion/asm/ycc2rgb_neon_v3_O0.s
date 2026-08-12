	.arch armv7-a
	.fpu neon
	.eabi_attribute 28, 1
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"CSC_YCC_to_RGB.c"
	.text
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.type	saturation_float, %function
saturation_float:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #12
	add	r7, sp, #0
	vstr.32	s0, [r7, #4]
	vldr.32	s15, [r7, #4]
	vldr.32	s14, .L11
	vcmpe.f32	s15, s14
	vmrs	APSR_nzcv, FPSCR
	ble	.L9
	movs	r3, #255
	b	.L4
.L9:
	vldr.32	s15, [r7, #4]
	vcmpe.f32	s15, #0
	vmrs	APSR_nzcv, FPSCR
	bpl	.L10
	movs	r3, #0
	b	.L4
.L10:
	vldr.32	s15, [r7, #4]
	vcvt.u32.f32	s15, s15
	vstr.32	s15, [r7]	@ int
	ldrb	r3, [r7]
	uxtb	r3, r3
.L4:
	mov	r0, r3
	adds	r7, r7, #12
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
.L12:
	.align	2
.L11:
	.word	1132396544
	.size	saturation_float, .-saturation_float
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.type	CSC_YCC_to_RGB_brute_force_float, %function
CSC_YCC_to_RGB_brute_force_float:
	@ args = 0, pretend = 0, frame = 56
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r5, r7, lr}
	sub	sp, sp, #56
	add	r7, sp, #0
	str	r0, [r7, #4]
	str	r1, [r7]
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	ldr	r2, [r7, #4]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vmov.f64	d17, #1.6e+1
	vsub.f64	d16, d16, d17
	vldr.64	d17, .L14
	vmul.f64	d17, d16, d17
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	ldr	r2, [r7, #4]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L14+40
	vsub.f64	d16, d16, d18
	vldr.64	d18, .L14+8
	vmul.f64	d16, d16, d18
	vadd.f64	d16, d17, d16
	vcvt.f32.f64	s15, d16
	vstr.32	s15, [r7, #52]
	vldr.32	s0, [r7, #52]
	bl	saturation_float
	mov	r3, r0
	mov	r0, r3
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	ldr	r2, [r7, #4]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	mov	r2, r0
	strb	r2, [r3]
	ldr	r3, [r7]
	adds	r2, r3, #1
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	ldr	r1, [r7, #4]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vmov.f64	d17, #1.6e+1
	vsub.f64	d16, d16, d17
	vldr.64	d17, .L14
	vmul.f64	d17, d16, d17
	ldr	r3, [r7]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	ldr	r1, [r7, #4]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L14+40
	vsub.f64	d16, d16, d18
	vldr.64	d18, .L14+8
	vmul.f64	d16, d16, d18
	vadd.f64	d16, d17, d16
	vcvt.f32.f64	s15, d16
	vstr.32	s15, [r7, #48]
	ldr	r3, [r7]
	adds	r4, r3, #1
	vldr.32	s0, [r7, #48]
	bl	saturation_float
	mov	r3, r0
	mov	r0, r3
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	ldr	r2, [r7, #4]
	movs	r1, #48
	mul	r2, r1, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r0
	strb	r2, [r3]
	ldr	r3, [r7, #4]
	adds	r2, r3, #1
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vmov.f64	d17, #1.6e+1
	vsub.f64	d16, d16, d17
	vldr.64	d17, .L14
	vmul.f64	d17, d16, d17
	ldr	r3, [r7, #4]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L14+40
	vsub.f64	d16, d16, d18
	vldr.64	d18, .L14+8
	vmul.f64	d16, d16, d18
	vadd.f64	d16, d17, d16
	vcvt.f32.f64	s15, d16
	vstr.32	s15, [r7, #44]
	ldr	r3, [r7, #4]
	adds	r4, r3, #1
	vldr.32	s0, [r7, #44]
	bl	saturation_float
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	movs	r2, #48
	mul	r2, r4, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	mov	r2, r1
	strb	r2, [r3]
	ldr	r3, [r7, #4]
	adds	r1, r3, #1
	ldr	r3, [r7]
	adds	r2, r3, #1
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vmov.f64	d17, #1.6e+1
	vsub.f64	d16, d16, d17
	vldr.64	d17, .L14
	vmul.f64	d17, d16, d17
	ldr	r3, [r7, #4]
	adds	r1, r3, #1
	ldr	r3, [r7]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L14+40
	vsub.f64	d16, d16, d18
	vldr.64	d18, .L14+8
	vmul.f64	d16, d16, d18
	vadd.f64	d16, d17, d16
	vcvt.f32.f64	s15, d16
	vstr.32	s15, [r7, #40]
	ldr	r3, [r7, #4]
	adds	r5, r3, #1
	ldr	r3, [r7]
	adds	r4, r3, #1
	vldr.32	s0, [r7, #40]
	bl	saturation_float
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	movs	r2, #48
	mul	r2, r5, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r1
	strb	r2, [r3]
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	ldr	r2, [r7, #4]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vmov.f64	d17, #1.6e+1
	vsub.f64	d16, d16, d17
	vldr.64	d17, .L14
	vmul.f64	d17, d16, d17
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	ldr	r2, [r7, #4]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L14+40
	vsub.f64	d16, d16, d18
	vldr.64	d18, .L14+16
	vmul.f64	d16, d16, d18
	vsub.f64	d17, d17, d16
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	ldr	r2, [r7, #4]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L14+40
	vsub.f64	d16, d16, d18
	vldr.64	d18, .L14+24
	vmul.f64	d16, d16, d18
	vsub.f64	d16, d17, d16
	vcvt.f32.f64	s15, d16
	vstr.32	s15, [r7, #36]
	vldr.32	s0, [r7, #36]
	bl	saturation_float
	mov	r3, r0
	mov	r0, r3
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	ldr	r2, [r7, #4]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	mov	r2, r0
	strb	r2, [r3]
	ldr	r3, [r7]
	adds	r2, r3, #1
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	ldr	r1, [r7, #4]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vmov.f64	d17, #1.6e+1
	vsub.f64	d16, d16, d17
	vldr.64	d17, .L14
	vmul.f64	d17, d16, d17
	ldr	r3, [r7]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	ldr	r1, [r7, #4]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L14+40
	vsub.f64	d16, d16, d18
	vldr.64	d18, .L14+16
	vmul.f64	d16, d16, d18
	vsub.f64	d17, d17, d16
	ldr	r3, [r7]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	ldr	r1, [r7, #4]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	b	.L15
.L16:
	.align	3
.L14:
	.word	1992864825
	.word	1072865214
	.word	1271310320
	.word	1073318199
	.word	-1821066134
	.word	1072301080
	.word	-584115552
	.word	1071187492
	.word	1992864825
	.word	1072865214
	.word	0
	.word	1080033280
	.word	790273982
	.word	1073751261
.L15:
	vldr.64	d18, .L14+40
	vsub.f64	d16, d16, d18
	vldr.64	d18, .L14+24
	vmul.f64	d16, d16, d18
	vsub.f64	d16, d17, d16
	vcvt.f32.f64	s15, d16
	vstr.32	s15, [r7, #32]
	ldr	r3, [r7]
	adds	r4, r3, #1
	vldr.32	s0, [r7, #32]
	bl	saturation_float
	mov	r3, r0
	mov	r0, r3
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	ldr	r2, [r7, #4]
	movs	r1, #48
	mul	r2, r1, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r0
	strb	r2, [r3]
	ldr	r3, [r7, #4]
	adds	r2, r3, #1
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vmov.f64	d17, #1.6e+1
	vsub.f64	d16, d16, d17
	vldr.64	d17, .L14+32
	vmul.f64	d17, d16, d17
	ldr	r3, [r7, #4]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L14+40
	vsub.f64	d16, d16, d18
	vldr.64	d18, .L14+16
	vmul.f64	d16, d16, d18
	vsub.f64	d17, d17, d16
	ldr	r3, [r7, #4]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L14+40
	vsub.f64	d16, d16, d18
	vldr.64	d18, .L14+24
	vmul.f64	d16, d16, d18
	vsub.f64	d16, d17, d16
	vcvt.f32.f64	s15, d16
	vstr.32	s15, [r7, #28]
	ldr	r3, [r7, #4]
	adds	r4, r3, #1
	vldr.32	s0, [r7, #28]
	bl	saturation_float
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	movs	r2, #48
	mul	r2, r4, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	mov	r2, r1
	strb	r2, [r3]
	ldr	r3, [r7, #4]
	adds	r1, r3, #1
	ldr	r3, [r7]
	adds	r2, r3, #1
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vmov.f64	d17, #1.6e+1
	vsub.f64	d16, d16, d17
	vldr.64	d17, .L14+32
	vmul.f64	d17, d16, d17
	ldr	r3, [r7, #4]
	adds	r1, r3, #1
	ldr	r3, [r7]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L14+40
	vsub.f64	d16, d16, d18
	vldr.64	d18, .L14+16
	vmul.f64	d16, d16, d18
	vsub.f64	d17, d17, d16
	ldr	r3, [r7, #4]
	adds	r1, r3, #1
	ldr	r3, [r7]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L14+40
	vsub.f64	d16, d16, d18
	vldr.64	d18, .L14+24
	vmul.f64	d16, d16, d18
	vsub.f64	d16, d17, d16
	vcvt.f32.f64	s15, d16
	vstr.32	s15, [r7, #24]
	ldr	r3, [r7, #4]
	adds	r5, r3, #1
	ldr	r3, [r7]
	adds	r4, r3, #1
	vldr.32	s0, [r7, #24]
	bl	saturation_float
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	movs	r2, #48
	mul	r2, r5, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r1
	strb	r2, [r3]
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	ldr	r2, [r7, #4]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vmov.f64	d17, #1.6e+1
	vsub.f64	d16, d16, d17
	vldr.64	d17, .L14+32
	vmul.f64	d17, d16, d17
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	ldr	r2, [r7, #4]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L14+40
	vsub.f64	d16, d16, d18
	vldr.64	d18, .L14+48
	vmul.f64	d16, d16, d18
	vadd.f64	d16, d17, d16
	vcvt.f32.f64	s15, d16
	vstr.32	s15, [r7, #20]
	vldr.32	s0, [r7, #20]
	bl	saturation_float
	mov	r3, r0
	mov	r0, r3
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	ldr	r2, [r7, #4]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	mov	r2, r0
	strb	r2, [r3]
	ldr	r3, [r7]
	adds	r2, r3, #1
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	ldr	r1, [r7, #4]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vmov.f64	d17, #1.6e+1
	vsub.f64	d16, d16, d17
	vldr.64	d17, .L14+32
	vmul.f64	d17, d16, d17
	ldr	r3, [r7]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	ldr	r1, [r7, #4]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L14+40
	vsub.f64	d16, d16, d18
	vldr.64	d18, .L14+48
	vmul.f64	d16, d16, d18
	vadd.f64	d16, d17, d16
	vcvt.f32.f64	s15, d16
	vstr.32	s15, [r7, #16]
	ldr	r3, [r7]
	adds	r4, r3, #1
	vldr.32	s0, [r7, #16]
	bl	saturation_float
	mov	r3, r0
	mov	r0, r3
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	ldr	r2, [r7, #4]
	movs	r1, #48
	mul	r2, r1, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r0
	strb	r2, [r3]
	ldr	r3, [r7, #4]
	adds	r2, r3, #1
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vmov.f64	d17, #1.6e+1
	vsub.f64	d16, d16, d17
	vldr.64	d17, .L14+32
	vmul.f64	d17, d16, d17
	ldr	r3, [r7, #4]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L14+40
	vsub.f64	d16, d16, d18
	vldr.64	d18, .L14+48
	vmul.f64	d16, d16, d18
	vadd.f64	d16, d17, d16
	vcvt.f32.f64	s15, d16
	vstr.32	s15, [r7, #12]
	ldr	r3, [r7, #4]
	adds	r4, r3, #1
	vldr.32	s0, [r7, #12]
	bl	saturation_float
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	movs	r2, #48
	mul	r2, r4, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	mov	r2, r1
	strb	r2, [r3]
	ldr	r3, [r7, #4]
	adds	r1, r3, #1
	ldr	r3, [r7]
	adds	r2, r3, #1
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vmov.f64	d17, #1.6e+1
	vsub.f64	d16, d16, d17
	vldr.64	d17, .L17
	vmul.f64	d17, d16, d17
	ldr	r3, [r7, #4]
	adds	r1, r3, #1
	ldr	r3, [r7]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L17+8
	vsub.f64	d16, d16, d18
	vldr.64	d18, .L17+16
	vmul.f64	d16, d16, d18
	vadd.f64	d16, d17, d16
	vcvt.f32.f64	s15, d16
	vstr.32	s15, [r7, #8]
	ldr	r3, [r7, #4]
	adds	r5, r3, #1
	ldr	r3, [r7]
	adds	r4, r3, #1
	vldr.32	s0, [r7, #8]
	bl	saturation_float
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	movs	r2, #48
	mul	r2, r5, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r1
	strb	r2, [r3]
	nop
	adds	r7, r7, #56
	mov	sp, r7
	@ sp needed
	pop	{r4, r5, r7, pc}
.L18:
	.align	3
.L17:
	.word	1992864825
	.word	1072865214
	.word	0
	.word	1080033280
	.word	790273982
	.word	1073751261
	.size	CSC_YCC_to_RGB_brute_force_float, .-CSC_YCC_to_RGB_brute_force_float
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.type	saturation_int, %function
saturation_int:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #12
	add	r7, sp, #0
	str	r0, [r7, #4]
	ldr	r3, [r7, #4]
	cmp	r3, #255
	ble	.L20
	movs	r3, #255
	b	.L21
.L20:
	ldr	r3, [r7, #4]
	cmp	r3, #0
	bge	.L22
	movs	r3, #0
	b	.L21
.L22:
	ldr	r3, [r7, #4]
	uxtb	r3, r3
.L21:
	mov	r0, r3
	adds	r7, r7, #12
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
	.size	saturation_int, .-saturation_int
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.type	CSC_YCC_to_RGB_brute_force_int, %function
CSC_YCC_to_RGB_brute_force_int:
	@ args = 0, pretend = 0, frame = 104
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r5, r7, lr}
	sub	sp, sp, #104
	add	r7, sp, #0
	str	r0, [r7, #4]
	str	r1, [r7]
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	ldr	r2, [r7, #4]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #100]
	ldr	r3, [r7]
	adds	r2, r3, #1
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	ldr	r1, [r7, #4]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #96]
	ldr	r3, [r7, #4]
	adds	r2, r3, #1
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #92]
	ldr	r3, [r7, #4]
	adds	r1, r3, #1
	ldr	r3, [r7]
	adds	r2, r3, #1
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #88]
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	ldr	r2, [r7, #4]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #84]
	ldr	r3, [r7]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	ldr	r1, [r7, #4]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #80]
	ldr	r3, [r7, #4]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #76]
	ldr	r3, [r7, #4]
	adds	r1, r3, #1
	ldr	r3, [r7]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #72]
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	ldr	r2, [r7, #4]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #68]
	ldr	r3, [r7]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	ldr	r1, [r7, #4]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #64]
	ldr	r3, [r7, #4]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #60]
	ldr	r3, [r7, #4]
	adds	r1, r3, #1
	ldr	r3, [r7]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #56]
	ldr	r3, [r7, #100]
	subs	r3, r3, #16
	str	r3, [r7, #100]
	ldr	r3, [r7, #96]
	subs	r3, r3, #16
	str	r3, [r7, #96]
	ldr	r3, [r7, #92]
	subs	r3, r3, #16
	str	r3, [r7, #92]
	ldr	r3, [r7, #88]
	subs	r3, r3, #16
	str	r3, [r7, #88]
	ldr	r3, [r7, #84]
	subs	r3, r3, #128
	str	r3, [r7, #84]
	ldr	r3, [r7, #80]
	subs	r3, r3, #128
	str	r3, [r7, #80]
	ldr	r3, [r7, #76]
	subs	r3, r3, #128
	str	r3, [r7, #76]
	ldr	r3, [r7, #72]
	subs	r3, r3, #128
	str	r3, [r7, #72]
	ldr	r3, [r7, #68]
	subs	r3, r3, #128
	str	r3, [r7, #68]
	ldr	r3, [r7, #64]
	subs	r3, r3, #128
	str	r3, [r7, #64]
	ldr	r3, [r7, #60]
	subs	r3, r3, #128
	str	r3, [r7, #60]
	ldr	r3, [r7, #56]
	subs	r3, r3, #128
	str	r3, [r7, #56]
	ldr	r3, [r7, #100]
	mov	r2, #298
	mul	r2, r3, r2
	ldr	r3, [r7, #68]
	movw	r1, #409
	mul	r3, r1, r3
	add	r3, r3, r2
	str	r3, [r7, #52]
	ldr	r3, [r7, #52]
	adds	r3, r3, #128
	str	r3, [r7, #52]
	ldr	r3, [r7, #52]
	asrs	r3, r3, #8
	str	r3, [r7, #52]
	ldr	r3, [r7, #96]
	mov	r2, #298
	mul	r2, r3, r2
	ldr	r3, [r7, #64]
	movw	r1, #409
	mul	r3, r1, r3
	add	r3, r3, r2
	str	r3, [r7, #48]
	ldr	r3, [r7, #48]
	adds	r3, r3, #128
	str	r3, [r7, #48]
	ldr	r3, [r7, #48]
	asrs	r3, r3, #8
	str	r3, [r7, #48]
	ldr	r3, [r7, #92]
	mov	r2, #298
	mul	r2, r3, r2
	ldr	r3, [r7, #60]
	movw	r1, #409
	mul	r3, r1, r3
	add	r3, r3, r2
	str	r3, [r7, #44]
	ldr	r3, [r7, #44]
	adds	r3, r3, #128
	str	r3, [r7, #44]
	ldr	r3, [r7, #44]
	asrs	r3, r3, #8
	str	r3, [r7, #44]
	ldr	r3, [r7, #88]
	mov	r2, #298
	mul	r2, r3, r2
	ldr	r3, [r7, #56]
	movw	r1, #409
	mul	r3, r1, r3
	add	r3, r3, r2
	str	r3, [r7, #40]
	ldr	r3, [r7, #40]
	adds	r3, r3, #128
	str	r3, [r7, #40]
	ldr	r3, [r7, #40]
	asrs	r3, r3, #8
	str	r3, [r7, #40]
	ldr	r0, [r7, #52]
	bl	saturation_int
	mov	r3, r0
	mov	r0, r3
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	ldr	r2, [r7, #4]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	mov	r2, r0
	strb	r2, [r3]
	ldr	r3, [r7]
	adds	r4, r3, #1
	ldr	r0, [r7, #48]
	bl	saturation_int
	mov	r3, r0
	mov	r0, r3
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	ldr	r2, [r7, #4]
	movs	r1, #48
	mul	r2, r1, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r0
	strb	r2, [r3]
	ldr	r3, [r7, #4]
	adds	r4, r3, #1
	ldr	r0, [r7, #44]
	bl	saturation_int
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	movs	r2, #48
	mul	r2, r4, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	mov	r2, r1
	strb	r2, [r3]
	ldr	r3, [r7, #4]
	adds	r5, r3, #1
	ldr	r3, [r7]
	adds	r4, r3, #1
	ldr	r0, [r7, #40]
	bl	saturation_int
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	movs	r2, #48
	mul	r2, r5, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r1
	strb	r2, [r3]
	ldr	r3, [r7, #100]
	mov	r2, #298
	mul	r2, r3, r2
	ldr	r3, [r7, #68]
	mvn	r1, #207
	mul	r3, r1, r3
	add	r2, r2, r3
	ldr	r3, [r7, #84]
	mvn	r1, #99
	mul	r3, r1, r3
	add	r3, r3, r2
	str	r3, [r7, #36]
	ldr	r3, [r7, #36]
	adds	r3, r3, #128
	str	r3, [r7, #36]
	ldr	r3, [r7, #36]
	asrs	r3, r3, #8
	str	r3, [r7, #36]
	ldr	r3, [r7, #96]
	mov	r2, #298
	mul	r2, r3, r2
	ldr	r3, [r7, #64]
	mvn	r1, #207
	mul	r3, r1, r3
	add	r2, r2, r3
	ldr	r3, [r7, #80]
	mvn	r1, #99
	mul	r3, r1, r3
	add	r3, r3, r2
	str	r3, [r7, #32]
	ldr	r3, [r7, #32]
	adds	r3, r3, #128
	str	r3, [r7, #32]
	ldr	r3, [r7, #32]
	asrs	r3, r3, #8
	str	r3, [r7, #32]
	ldr	r3, [r7, #92]
	mov	r2, #298
	mul	r2, r3, r2
	ldr	r3, [r7, #60]
	mvn	r1, #207
	mul	r3, r1, r3
	add	r2, r2, r3
	ldr	r3, [r7, #76]
	mvn	r1, #99
	mul	r3, r1, r3
	add	r3, r3, r2
	str	r3, [r7, #28]
	ldr	r3, [r7, #28]
	adds	r3, r3, #128
	str	r3, [r7, #28]
	ldr	r3, [r7, #28]
	asrs	r3, r3, #8
	str	r3, [r7, #28]
	ldr	r3, [r7, #88]
	mov	r2, #298
	mul	r2, r3, r2
	ldr	r3, [r7, #56]
	mvn	r1, #207
	mul	r3, r1, r3
	add	r2, r2, r3
	ldr	r3, [r7, #72]
	mvn	r1, #99
	mul	r3, r1, r3
	add	r3, r3, r2
	str	r3, [r7, #24]
	ldr	r3, [r7, #24]
	adds	r3, r3, #128
	str	r3, [r7, #24]
	ldr	r3, [r7, #24]
	asrs	r3, r3, #8
	str	r3, [r7, #24]
	ldr	r0, [r7, #36]
	bl	saturation_int
	mov	r3, r0
	mov	r0, r3
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	ldr	r2, [r7, #4]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	mov	r2, r0
	strb	r2, [r3]
	ldr	r3, [r7]
	adds	r4, r3, #1
	ldr	r0, [r7, #32]
	bl	saturation_int
	mov	r3, r0
	mov	r0, r3
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	ldr	r2, [r7, #4]
	movs	r1, #48
	mul	r2, r1, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r0
	strb	r2, [r3]
	ldr	r3, [r7, #4]
	adds	r4, r3, #1
	ldr	r0, [r7, #28]
	bl	saturation_int
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	movs	r2, #48
	mul	r2, r4, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	mov	r2, r1
	strb	r2, [r3]
	ldr	r3, [r7, #4]
	adds	r5, r3, #1
	ldr	r3, [r7]
	adds	r4, r3, #1
	ldr	r0, [r7, #24]
	bl	saturation_int
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	movs	r2, #48
	mul	r2, r5, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r1
	strb	r2, [r3]
	ldr	r3, [r7, #100]
	mov	r2, #298
	mul	r2, r3, r2
	ldr	r3, [r7, #84]
	movw	r1, #517
	mul	r3, r1, r3
	add	r3, r3, r2
	str	r3, [r7, #20]
	ldr	r3, [r7, #20]
	adds	r3, r3, #128
	str	r3, [r7, #20]
	ldr	r3, [r7, #20]
	asrs	r3, r3, #8
	str	r3, [r7, #20]
	ldr	r3, [r7, #96]
	mov	r2, #298
	mul	r2, r3, r2
	ldr	r3, [r7, #80]
	movw	r1, #517
	mul	r3, r1, r3
	add	r3, r3, r2
	str	r3, [r7, #16]
	ldr	r3, [r7, #16]
	adds	r3, r3, #128
	str	r3, [r7, #16]
	ldr	r3, [r7, #16]
	asrs	r3, r3, #8
	str	r3, [r7, #16]
	ldr	r3, [r7, #92]
	mov	r2, #298
	mul	r2, r3, r2
	ldr	r3, [r7, #76]
	movw	r1, #517
	mul	r3, r1, r3
	add	r3, r3, r2
	str	r3, [r7, #12]
	ldr	r3, [r7, #12]
	adds	r3, r3, #128
	str	r3, [r7, #12]
	ldr	r3, [r7, #12]
	asrs	r3, r3, #8
	str	r3, [r7, #12]
	ldr	r3, [r7, #88]
	mov	r2, #298
	mul	r2, r3, r2
	ldr	r3, [r7, #72]
	movw	r1, #517
	mul	r3, r1, r3
	add	r3, r3, r2
	str	r3, [r7, #8]
	ldr	r3, [r7, #8]
	adds	r3, r3, #128
	str	r3, [r7, #8]
	ldr	r3, [r7, #8]
	asrs	r3, r3, #8
	str	r3, [r7, #8]
	ldr	r0, [r7, #20]
	bl	saturation_int
	mov	r3, r0
	mov	r0, r3
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	ldr	r2, [r7, #4]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	mov	r2, r0
	strb	r2, [r3]
	ldr	r3, [r7]
	adds	r4, r3, #1
	ldr	r0, [r7, #16]
	bl	saturation_int
	mov	r3, r0
	mov	r0, r3
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	ldr	r2, [r7, #4]
	movs	r1, #48
	mul	r2, r1, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r0
	strb	r2, [r3]
	ldr	r3, [r7, #4]
	adds	r4, r3, #1
	ldr	r0, [r7, #12]
	bl	saturation_int
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	movs	r2, #48
	mul	r2, r4, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	mov	r2, r1
	strb	r2, [r3]
	ldr	r3, [r7, #4]
	adds	r5, r3, #1
	ldr	r3, [r7]
	adds	r4, r3, #1
	ldr	r0, [r7, #8]
	bl	saturation_int
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	movs	r2, #48
	mul	r2, r5, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r1
	strb	r2, [r3]
	nop
	adds	r7, r7, #104
	mov	sp, r7
	@ sp needed
	pop	{r4, r5, r7, pc}
	.size	CSC_YCC_to_RGB_brute_force_int, .-CSC_YCC_to_RGB_brute_force_int
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.type	CSC_YCC_to_RGB_neon_v2, %function
CSC_YCC_to_RGB_neon_v2:
	@ args = 0, pretend = 0, frame = 856
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}
	sub	sp, sp, #860
	add	r7, sp, #0
	movs	r3, #0
	str	r3, [r7, #852]
	b	.L25
.L59:
	movs	r3, #0
	str	r3, [r7, #848]
	b	.L26
.L58:
	ldr	r3, [r7, #852]
	movs	r2, #48
	mul	r2, r3, r2
	ldr	r3, [r7, #848]
	add	r2, r2, r3
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	add	r2, r2, r3
	add	r3, r7, #856
	sub	r3, r3, #756
	str	r2, [r3]
	add	r3, r7, #856
	sub	r3, r3, #756
	ldr	r3, [r3]
	vld1.8	{d16}, [r3]
	vstr	d16, [r7, #840]
	ldr	r3, [r7, #852]
	movs	r2, #48
	mul	r2, r3, r2
	ldr	r3, [r7, #848]
	add	r2, r2, r3
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	add	r2, r2, r3
	add	r3, r7, #856
	sub	r3, r3, #752
	str	r2, [r3]
	add	r3, r7, #856
	sub	r3, r3, #752
	ldr	r3, [r3]
	vld1.8	{d16}, [r3]
	vstr	d16, [r7, #832]
	ldr	r3, [r7, #852]
	movs	r2, #48
	mul	r2, r3, r2
	ldr	r3, [r7, #848]
	add	r2, r2, r3
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	add	r2, r2, r3
	add	r3, r7, #856
	sub	r3, r3, #748
	str	r2, [r3]
	add	r3, r7, #856
	sub	r3, r3, #748
	ldr	r3, [r3]
	vld1.8	{d16}, [r3]
	vstr	d16, [r7, #824]
	vldr	d16, [r7, #840]
	vstr	d16, [r7, #112]
	vldr	d16, [r7, #112]
	vmovl.u8	q8, d16
	vstr	d16, [r7, #120]
	vstr	d17, [r7, #128]
	vldr	d16, [r7, #120]
	vldr	d17, [r7, #128]
	vstr	d16, [r7, #808]
	vstr	d17, [r7, #816]
	vldr	d16, [r7, #832]
	vstr	d16, [r7, #136]
	vldr	d16, [r7, #136]
	vmovl.u8	q8, d16
	vstr	d16, [r7, #144]
	vstr	d17, [r7, #152]
	vldr	d16, [r7, #144]
	vldr	d17, [r7, #152]
	vstr	d16, [r7, #792]
	vstr	d17, [r7, #800]
	vldr	d16, [r7, #824]
	vstr	d16, [r7, #160]
	vldr	d16, [r7, #160]
	vmovl.u8	q8, d16
	vstr	d16, [r7, #168]
	vstr	d17, [r7, #176]
	vldr	d16, [r7, #168]
	vldr	d17, [r7, #176]
	vstr	d16, [r7, #776]
	vstr	d17, [r7, #784]
	add	r3, r7, #856
	subw	r3, r3, #666
	movs	r2, #16
	strh	r2, [r3]	@ movhi
	add	r3, r7, #856
	subw	lr, r3, #666
	add	r3, r7, #856
	subw	ip, r3, #666
	add	r3, r7, #856
	subw	r6, r3, #666
	add	r3, r7, #856
	subw	r5, r3, #666
	add	r3, r7, #856
	subw	r4, r3, #666
	add	r3, r7, #856
	subw	r0, r3, #666
	add	r3, r7, #856
	subw	r1, r3, #666
	add	r3, r7, #856
	subw	r2, r3, #666
	add	r3, r7, #856
	sub	r3, r3, #776
	ldrh	lr, [lr]	@ movhi
	strh	lr, [r3]	@ movhi
	add	r3, r7, #856
	subw	r3, r3, #774
	ldrh	ip, [ip]	@ movhi
	strh	ip, [r3]	@ movhi
	add	r3, r7, #856
	sub	r3, r3, #772
	ldrh	r6, [r6]	@ movhi
	strh	r6, [r3]	@ movhi
	add	r3, r7, #856
	subw	r3, r3, #770
	ldrh	r5, [r5]	@ movhi
	strh	r5, [r3]	@ movhi
	add	r3, r7, #856
	sub	r3, r3, #768
	ldrh	r4, [r4]	@ movhi
	strh	r4, [r3]	@ movhi
	add	r3, r7, #856
	subw	r3, r3, #766
	ldrh	r0, [r0]	@ movhi
	strh	r0, [r3]	@ movhi
	add	r3, r7, #856
	sub	r3, r3, #764
	ldrh	r1, [r1]	@ movhi
	strh	r1, [r3]	@ movhi
	add	r3, r7, #856
	subw	r3, r3, #762
	ldrh	r2, [r2]	@ movhi
	strh	r2, [r3]	@ movhi
	vldr	d16, [r7, #80]
	vldr	d17, [r7, #88]
	vmov	q9, q8  @ v8hi
	vldr	d16, [r7, #808]
	vldr	d17, [r7, #816]
	vstr	d16, [r7, #208]
	vstr	d17, [r7, #216]
	vstr	d18, [r7, #192]
	vstr	d19, [r7, #200]
	vldr	d18, [r7, #208]
	vldr	d19, [r7, #216]
	vldr	d16, [r7, #192]
	vldr	d17, [r7, #200]
	vsub.i16	q8, q9, q8
	vstr	d16, [r7, #808]
	vstr	d17, [r7, #816]
	add	r3, r7, #856
	subw	r3, r3, #626
	movs	r2, #128
	strh	r2, [r3]	@ movhi
	add	r3, r7, #856
	subw	lr, r3, #626
	add	r3, r7, #856
	subw	ip, r3, #626
	add	r3, r7, #856
	subw	r6, r3, #626
	add	r3, r7, #856
	subw	r5, r3, #626
	add	r3, r7, #856
	subw	r4, r3, #626
	add	r3, r7, #856
	subw	r0, r3, #626
	add	r3, r7, #856
	subw	r1, r3, #626
	add	r3, r7, #856
	subw	r2, r3, #626
	add	r3, r7, #856
	sub	r3, r3, #792
	ldrh	lr, [lr]	@ movhi
	strh	lr, [r3]	@ movhi
	add	r3, r7, #856
	subw	r3, r3, #790
	ldrh	ip, [ip]	@ movhi
	strh	ip, [r3]	@ movhi
	add	r3, r7, #856
	sub	r3, r3, #788
	ldrh	r6, [r6]	@ movhi
	strh	r6, [r3]	@ movhi
	add	r3, r7, #856
	subw	r3, r3, #786
	ldrh	r5, [r5]	@ movhi
	strh	r5, [r3]	@ movhi
	add	r3, r7, #856
	sub	r3, r3, #784
	ldrh	r4, [r4]	@ movhi
	strh	r4, [r3]	@ movhi
	add	r3, r7, #856
	subw	r3, r3, #782
	ldrh	r0, [r0]	@ movhi
	strh	r0, [r3]	@ movhi
	add	r3, r7, #856
	sub	r3, r3, #780
	ldrh	r1, [r1]	@ movhi
	strh	r1, [r3]	@ movhi
	add	r3, r7, #856
	subw	r3, r3, #778
	ldrh	r2, [r2]	@ movhi
	strh	r2, [r3]	@ movhi
	vldr	d16, [r7, #64]
	vldr	d17, [r7, #72]
	vmov	q9, q8  @ v8hi
	vldr	d16, [r7, #792]
	vldr	d17, [r7, #800]
	vstr	d16, [r7, #248]
	vstr	d17, [r7, #256]
	vstr	d18, [r7, #232]
	vstr	d19, [r7, #240]
	vldr	d18, [r7, #248]
	vldr	d19, [r7, #256]
	vldr	d16, [r7, #232]
	vldr	d17, [r7, #240]
	vsub.i16	q8, q9, q8
	vstr	d16, [r7, #792]
	vstr	d17, [r7, #800]
	add	r3, r7, #856
	subw	r3, r3, #586
	movs	r2, #128
	strh	r2, [r3]	@ movhi
	add	r3, r7, #856
	subw	lr, r3, #586
	add	r3, r7, #856
	subw	ip, r3, #586
	add	r3, r7, #856
	subw	r6, r3, #586
	add	r3, r7, #856
	subw	r5, r3, #586
	add	r3, r7, #856
	subw	r4, r3, #586
	add	r3, r7, #856
	subw	r0, r3, #586
	add	r3, r7, #856
	subw	r1, r3, #586
	add	r3, r7, #856
	subw	r2, r3, #586
	add	r3, r7, #856
	sub	r3, r3, #808
	ldrh	lr, [lr]	@ movhi
	strh	lr, [r3]	@ movhi
	add	r3, r7, #856
	subw	r3, r3, #806
	ldrh	ip, [ip]	@ movhi
	strh	ip, [r3]	@ movhi
	add	r3, r7, #856
	sub	r3, r3, #804
	ldrh	r6, [r6]	@ movhi
	strh	r6, [r3]	@ movhi
	add	r3, r7, #856
	subw	r3, r3, #802
	ldrh	r5, [r5]	@ movhi
	strh	r5, [r3]	@ movhi
	add	r3, r7, #856
	sub	r3, r3, #800
	ldrh	r4, [r4]	@ movhi
	strh	r4, [r3]	@ movhi
	add	r3, r7, #856
	subw	r3, r3, #798
	ldrh	r0, [r0]	@ movhi
	strh	r0, [r3]	@ movhi
	add	r3, r7, #856
	sub	r3, r3, #796
	ldrh	r1, [r1]	@ movhi
	strh	r1, [r3]	@ movhi
	add	r3, r7, #856
	subw	r3, r3, #794
	ldrh	r2, [r2]	@ movhi
	strh	r2, [r3]	@ movhi
	vldr	d16, [r7, #48]
	vldr	d17, [r7, #56]
	vmov	q9, q8  @ v8hi
	vldr	d16, [r7, #776]
	vldr	d17, [r7, #784]
	vstr	d16, [r7, #288]
	vstr	d17, [r7, #296]
	vstr	d18, [r7, #272]
	vstr	d19, [r7, #280]
	vldr	d18, [r7, #288]
	vldr	d19, [r7, #296]
	vldr	d16, [r7, #272]
	vldr	d17, [r7, #280]
	vsub.i16	q8, q9, q8
	vstr	d16, [r7, #776]
	vstr	d17, [r7, #784]
	add	r3, r7, #856
	sub	r3, r3, #548
	movs	r2, #128
	strh	r2, [r3]	@ movhi
	add	r3, r7, #856
	sub	lr, r3, #548
	add	r3, r7, #856
	sub	ip, r3, #548
	add	r3, r7, #856
	sub	r6, r3, #548
	add	r3, r7, #856
	sub	r5, r3, #548
	add	r3, r7, #856
	sub	r4, r3, #548
	add	r3, r7, #856
	sub	r0, r3, #548
	add	r3, r7, #856
	sub	r1, r3, #548
	add	r3, r7, #856
	sub	r2, r3, #548
	add	r3, r7, #856
	sub	r3, r3, #824
	ldrh	lr, [lr]	@ movhi
	strh	lr, [r3]	@ movhi
	add	r3, r7, #856
	subw	r3, r3, #822
	ldrh	ip, [ip]	@ movhi
	strh	ip, [r3]	@ movhi
	add	r3, r7, #856
	sub	r3, r3, #820
	ldrh	r6, [r6]	@ movhi
	strh	r6, [r3]	@ movhi
	add	r3, r7, #856
	subw	r3, r3, #818
	ldrh	r5, [r5]	@ movhi
	strh	r5, [r3]	@ movhi
	add	r3, r7, #856
	sub	r3, r3, #816
	ldrh	r4, [r4]	@ movhi
	strh	r4, [r3]	@ movhi
	add	r3, r7, #856
	subw	r3, r3, #814
	ldrh	r0, [r0]	@ movhi
	strh	r0, [r3]	@ movhi
	add	r3, r7, #856
	sub	r3, r3, #812
	ldrh	r1, [r1]	@ movhi
	strh	r1, [r3]	@ movhi
	add	r3, r7, #856
	subw	r3, r3, #810
	ldrh	r2, [r2]	@ movhi
	strh	r2, [r3]	@ movhi
	vldr	d16, [r7, #32]
	vldr	d17, [r7, #40]
	vstr	d16, [r7, #760]
	vstr	d17, [r7, #768]
	vldr	d16, [r7, #760]
	vldr	d17, [r7, #768]
	vstr	d16, [r7, #328]
	vstr	d17, [r7, #336]
	vldr	d16, [r7, #808]
	vldr	d17, [r7, #816]
	vstr	d16, [r7, #312]
	vstr	d17, [r7, #320]
	add	r3, r7, #856
	subw	r3, r3, #546
	mov	r2, #298
	strh	r2, [r3]	@ movhi
	vldr	d16, [r7, #328]
	vldr	d17, [r7, #336]
	vldr	d18, [r7, #312]
	vldr	d19, [r7, #320]
	add	r3, r7, #856
	subw	r3, r3, #546
	ldrh	r3, [r3]	@ movhi
	vmov.16	d7[0], r3
	vmla.i16	q8, q9, d7[0]
	vstr	d16, [r7, #760]
	vstr	d17, [r7, #768]
	vldr	d16, [r7, #760]
	vldr	d17, [r7, #768]
	vstr	d16, [r7, #368]
	vstr	d17, [r7, #376]
	vldr	d16, [r7, #776]
	vldr	d17, [r7, #784]
	vstr	d16, [r7, #352]
	vstr	d17, [r7, #360]
	add	r3, r7, #856
	sub	r3, r3, #506
	movw	r2, #409
	strh	r2, [r3]	@ movhi
	vldr	d16, [r7, #368]
	vldr	d17, [r7, #376]
	vldr	d18, [r7, #352]
	vldr	d19, [r7, #360]
	add	r3, r7, #856
	sub	r3, r3, #506
	ldrh	r3, [r3]	@ movhi
	vmov.16	d6[0], r3
	vmla.i16	q8, q9, d6[0]
	vstr	d16, [r7, #760]
	vstr	d17, [r7, #768]
	vldr	d16, [r7, #760]
	vldr	d17, [r7, #768]
	vstr	d16, [r7, #384]
	vstr	d17, [r7, #392]
	vldr	d16, [r7, #384]
	vldr	d17, [r7, #392]
	vshr.s16	q8, q8, #8
	vstr	d16, [r7, #760]
	vstr	d17, [r7, #768]
	add	r3, r7, #856
	sub	r3, r3, #452
	movs	r2, #128
	strh	r2, [r3]	@ movhi
	add	r3, r7, #856
	sub	lr, r3, #452
	add	r3, r7, #856
	sub	ip, r3, #452
	add	r3, r7, #856
	sub	r6, r3, #452
	add	r3, r7, #856
	sub	r5, r3, #452
	add	r3, r7, #856
	sub	r4, r3, #452
	add	r3, r7, #856
	sub	r0, r3, #452
	add	r3, r7, #856
	sub	r1, r3, #452
	add	r3, r7, #856
	sub	r2, r3, #452
	add	r3, r7, #856
	sub	r3, r3, #840
	ldrh	lr, [lr]	@ movhi
	strh	lr, [r3]	@ movhi
	add	r3, r7, #856
	subw	r3, r3, #838
	ldrh	ip, [ip]	@ movhi
	strh	ip, [r3]	@ movhi
	add	r3, r7, #856
	sub	r3, r3, #836
	ldrh	r6, [r6]	@ movhi
	strh	r6, [r3]	@ movhi
	add	r3, r7, #856
	subw	r3, r3, #834
	ldrh	r5, [r5]	@ movhi
	strh	r5, [r3]	@ movhi
	add	r3, r7, #856
	sub	r3, r3, #832
	ldrh	r4, [r4]	@ movhi
	strh	r4, [r3]	@ movhi
	add	r3, r7, #856
	subw	r3, r3, #830
	ldrh	r0, [r0]	@ movhi
	strh	r0, [r3]	@ movhi
	add	r3, r7, #856
	sub	r3, r3, #828
	ldrh	r1, [r1]	@ movhi
	strh	r1, [r3]	@ movhi
	add	r3, r7, #856
	subw	r3, r3, #826
	ldrh	r2, [r2]	@ movhi
	strh	r2, [r3]	@ movhi
	vldr	d16, [r7, #16]
	vldr	d17, [r7, #24]
	vstr	d16, [r7, #744]
	vstr	d17, [r7, #752]
	vldr	d16, [r7, #744]
	vldr	d17, [r7, #752]
	vstr	d16, [r7, #424]
	vstr	d17, [r7, #432]
	vldr	d16, [r7, #808]
	vldr	d17, [r7, #816]
	vstr	d16, [r7, #408]
	vstr	d17, [r7, #416]
	add	r3, r7, #856
	sub	r3, r3, #450
	mov	r2, #298
	strh	r2, [r3]	@ movhi
	vldr	d16, [r7, #424]
	vldr	d17, [r7, #432]
	vldr	d18, [r7, #408]
	vldr	d19, [r7, #416]
	add	r3, r7, #856
	sub	r3, r3, #450
	ldrh	r3, [r3]	@ movhi
	vmov.16	d5[0], r3
	vmla.i16	q8, q9, d5[0]
	vstr	d16, [r7, #744]
	vstr	d17, [r7, #752]
	vldr	d16, [r7, #744]
	vldr	d17, [r7, #752]
	vstr	d16, [r7, #464]
	vstr	d17, [r7, #472]
	vldr	d16, [r7, #776]
	vldr	d17, [r7, #784]
	vstr	d16, [r7, #448]
	vstr	d17, [r7, #456]
	add	r3, r7, #856
	sub	r3, r3, #410
	movs	r2, #208
	strh	r2, [r3]	@ movhi
	vldr	d16, [r7, #464]
	vldr	d17, [r7, #472]
	vldr	d18, [r7, #448]
	vldr	d19, [r7, #456]
	add	r3, r7, #856
	sub	r3, r3, #410
	ldrh	r3, [r3]	@ movhi
	vmov.16	d4[0], r3
	vmls.i16	q8, q9, d4[0]
	vstr	d16, [r7, #744]
	vstr	d17, [r7, #752]
	vldr	d16, [r7, #744]
	vldr	d17, [r7, #752]
	vstr	d16, [r7, #504]
	vstr	d17, [r7, #512]
	vldr	d16, [r7, #792]
	vldr	d17, [r7, #800]
	vstr	d16, [r7, #488]
	vstr	d17, [r7, #496]
	add	r3, r7, #856
	sub	r3, r3, #370
	movs	r2, #100
	strh	r2, [r3]	@ movhi
	vldr	d16, [r7, #504]
	vldr	d17, [r7, #512]
	vldr	d18, [r7, #488]
	vldr	d19, [r7, #496]
	add	r3, r7, #856
	sub	r3, r3, #370
	ldrh	r3, [r3]	@ movhi
	vmov.16	d3[0], r3
	vmls.i16	q8, q9, d3[0]
	vstr	d16, [r7, #744]
	vstr	d17, [r7, #752]
	vldr	d16, [r7, #744]
	vldr	d17, [r7, #752]
	vstr	d16, [r7, #520]
	vstr	d17, [r7, #528]
	vldr	d16, [r7, #520]
	vldr	d17, [r7, #528]
	vshr.s16	q8, q8, #8
	vstr	d16, [r7, #744]
	vstr	d17, [r7, #752]
	add	r3, r7, #856
	sub	r3, r3, #316
	movs	r2, #128
	strh	r2, [r3]	@ movhi
	add	r3, r7, #856
	sub	lr, r3, #316
	add	r3, r7, #856
	sub	ip, r3, #316
	add	r3, r7, #856
	sub	r6, r3, #316
	add	r3, r7, #856
	sub	r5, r3, #316
	add	r3, r7, #856
	sub	r4, r3, #316
	add	r3, r7, #856
	sub	r0, r3, #316
	add	r3, r7, #856
	sub	r1, r3, #316
	add	r3, r7, #856
	sub	r2, r3, #316
	add	r3, r7, #856
	sub	r3, r3, #856
	ldrh	lr, [lr]	@ movhi
	strh	lr, [r3]	@ movhi
	add	r3, r7, #856
	subw	r3, r3, #854
	ldrh	ip, [ip]	@ movhi
	strh	ip, [r3]	@ movhi
	add	r3, r7, #856
	sub	r3, r3, #852
	ldrh	r6, [r6]	@ movhi
	strh	r6, [r3]	@ movhi
	add	r3, r7, #856
	subw	r3, r3, #850
	ldrh	r5, [r5]	@ movhi
	strh	r5, [r3]	@ movhi
	add	r3, r7, #856
	sub	r3, r3, #848
	ldrh	r4, [r4]	@ movhi
	strh	r4, [r3]	@ movhi
	add	r3, r7, #856
	subw	r3, r3, #846
	ldrh	r0, [r0]	@ movhi
	strh	r0, [r3]	@ movhi
	add	r3, r7, #856
	sub	r3, r3, #844
	ldrh	r1, [r1]	@ movhi
	strh	r1, [r3]	@ movhi
	add	r3, r7, #856
	subw	r3, r3, #842
	ldrh	r2, [r2]	@ movhi
	strh	r2, [r3]	@ movhi
	vld1.64	{d16-d17}, [r7:64]
	vstr	d16, [r7, #728]
	vstr	d17, [r7, #736]
	vldr	d16, [r7, #728]
	vldr	d17, [r7, #736]
	vstr	d16, [r7, #560]
	vstr	d17, [r7, #568]
	vldr	d16, [r7, #808]
	vldr	d17, [r7, #816]
	vstr	d16, [r7, #544]
	vstr	d17, [r7, #552]
	add	r3, r7, #856
	sub	r3, r3, #314
	mov	r2, #298
	strh	r2, [r3]	@ movhi
	vldr	d16, [r7, #560]
	vldr	d17, [r7, #568]
	vldr	d18, [r7, #544]
	vldr	d19, [r7, #552]
	add	r3, r7, #856
	sub	r3, r3, #314
	ldrh	r3, [r3]	@ movhi
	vmov.16	d2[0], r3
	vmla.i16	q8, q9, d2[0]
	vstr	d16, [r7, #728]
	vstr	d17, [r7, #736]
	vldr	d16, [r7, #728]
	vldr	d17, [r7, #736]
	vstr	d16, [r7, #600]
	vstr	d17, [r7, #608]
	vldr	d16, [r7, #792]
	vldr	d17, [r7, #800]
	vstr	d16, [r7, #584]
	vstr	d17, [r7, #592]
	add	r3, r7, #856
	sub	r3, r3, #274
	movw	r2, #517
	strh	r2, [r3]	@ movhi
	vldr	d16, [r7, #600]
	vldr	d17, [r7, #608]
	vldr	d18, [r7, #584]
	vldr	d19, [r7, #592]
	add	r3, r7, #856
	sub	r3, r3, #274
	ldrh	r3, [r3]	@ movhi
	vmov.16	d1[0], r3
	vmla.i16	q8, q9, d1[0]
	vstr	d16, [r7, #728]
	vstr	d17, [r7, #736]
	vldr	d16, [r7, #728]
	vldr	d17, [r7, #736]
	vstr	d16, [r7, #616]
	vstr	d17, [r7, #624]
	vldr	d16, [r7, #616]
	vldr	d17, [r7, #624]
	vshr.s16	q8, q8, #8
	vstr	d16, [r7, #728]
	vstr	d17, [r7, #736]
	ldr	r3, [r7, #852]
	movs	r2, #48
	mul	r2, r3, r2
	ldr	r3, [r7, #848]
	add	r2, r2, r3
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	add	r3, r3, r2
	vldr	d16, [r7, #760]
	vldr	d17, [r7, #768]
	vstr	d16, [r7, #632]
	vstr	d17, [r7, #640]
	vldr	d16, [r7, #632]
	vldr	d17, [r7, #640]
	vqmovun.s16	d16, q8
	str	r3, [r7, #660]
	vstr	d16, [r7, #648]
	vldr	d16, [r7, #648]
	ldr	r3, [r7, #660]
	vst1.8	{d16}, [r3]
	nop
	ldr	r3, [r7, #852]
	movs	r2, #48
	mul	r2, r3, r2
	ldr	r3, [r7, #848]
	add	r2, r2, r3
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	add	r3, r3, r2
	vldr	d16, [r7, #744]
	vldr	d17, [r7, #752]
	vstr	d16, [r7, #664]
	vstr	d17, [r7, #672]
	vldr	d16, [r7, #664]
	vldr	d17, [r7, #672]
	vqmovun.s16	d16, q8
	str	r3, [r7, #692]
	vstr	d16, [r7, #680]
	vldr	d16, [r7, #680]
	ldr	r3, [r7, #692]
	vst1.8	{d16}, [r3]
	nop
	ldr	r3, [r7, #852]
	movs	r2, #48
	mul	r2, r3, r2
	ldr	r3, [r7, #848]
	add	r2, r2, r3
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	add	r3, r3, r2
	vldr	d16, [r7, #728]
	vldr	d17, [r7, #736]
	vstr	d16, [r7, #696]
	vstr	d17, [r7, #704]
	vldr	d16, [r7, #696]
	vldr	d17, [r7, #704]
	vqmovun.s16	d16, q8
	str	r3, [r7, #724]
	vstr	d16, [r7, #712]
	vldr	d16, [r7, #712]
	ldr	r3, [r7, #724]
	vst1.8	{d16}, [r3]
	nop
	ldr	r3, [r7, #848]
	adds	r3, r3, #8
	str	r3, [r7, #848]
.L26:
	ldr	r3, [r7, #848]
	cmp	r3, #47
	ble	.L58
	ldr	r3, [r7, #852]
	adds	r3, r3, #1
	str	r3, [r7, #852]
.L25:
	ldr	r3, [r7, #852]
	cmp	r3, #63
	ble	.L59
	nop
	nop
	add	r7, r7, #860
	mov	sp, r7
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
	.size	CSC_YCC_to_RGB_neon_v2, .-CSC_YCC_to_RGB_neon_v2
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.type	neon_ycc_to_rgb_strip, %function
neon_ycc_to_rgb_strip:
	@ args = 0, pretend = 0, frame = 1664
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}
	vpush.64	{d8, d9, d10, d11, d12, d13, d14, d15}
	subw	sp, sp, #1668
	add	r7, sp, #0
	add	r4, r7, #1664
	subw	r4, r4, #1492
	str	r0, [r4]
	add	r0, r7, #1664
	sub	r0, r0, #1496
	str	r1, [r0]
	add	r1, r7, #1664
	subw	r1, r1, #1500
	str	r2, [r1]
	add	r2, r7, #1664
	sub	r2, r2, #1504
	str	r3, [r2]
	add	r3, r7, #1664
	sub	r3, r3, #1512
	vstr	d0, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #1520
	vstr	d1, [r3]
	add	r3, r7, #1664
	subw	r3, r3, #1484
	add	r2, r7, #1664
	sub	r2, r2, #1504
	ldr	r2, [r2]
	str	r2, [r3]
	add	r3, r7, #1664
	subw	r3, r3, #1484
	ldr	r3, [r3]
	vld1.8	{d16}, [r3]
	add	r3, r7, #1656
	vstr	d16, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #1480
	add	r2, r7, #1656
	vldr	d16, [r2]
	vstr	d16, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #1480
	vldr	d16, [r3]
	vmovl.u8	q8, d16
	add	r3, r7, #1664
	sub	r3, r3, #1472
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1472
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1640
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1456
	add	r2, r7, #1664
	sub	r2, r2, #1512
	vldr	d16, [r2]
	vstr	d16, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #1456
	vldr	d16, [r3]
	vmovl.u8	q8, d16
	add	r3, r7, #1664
	sub	r3, r3, #1448
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1448
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1624
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1432
	add	r2, r7, #1664
	sub	r2, r2, #1520
	vldr	d16, [r2]
	vstr	d16, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #1432
	vldr	d16, [r3]
	vmovl.u8	q8, d16
	add	r3, r7, #1664
	sub	r3, r3, #1424
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1424
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1608
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	subw	r3, r3, #1402
	movs	r2, #16
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1664
	subw	lr, r3, #1402
	add	r3, r7, #1664
	subw	ip, r3, #1402
	add	r3, r7, #1664
	subw	r6, r3, #1402
	add	r3, r7, #1664
	subw	r5, r3, #1402
	add	r3, r7, #1664
	subw	r4, r3, #1402
	add	r3, r7, #1664
	subw	r0, r3, #1402
	add	r3, r7, #1664
	subw	r1, r3, #1402
	add	r3, r7, #1664
	subw	r2, r3, #1402
	add	r3, r7, #1664
	sub	r3, r3, #1536
	ldrh	lr, [lr]	@ movhi
	strh	lr, [r3]	@ movhi
	add	r3, r7, #1664
	subw	r3, r3, #1534
	ldrh	ip, [ip]	@ movhi
	strh	ip, [r3]	@ movhi
	add	r3, r7, #1664
	subw	r3, r3, #1532
	ldrh	r6, [r6]	@ movhi
	strh	r6, [r3]	@ movhi
	add	r3, r7, #1664
	subw	r3, r3, #1530
	ldrh	r5, [r5]	@ movhi
	strh	r5, [r3]	@ movhi
	add	r3, r7, #1664
	sub	r3, r3, #1528
	ldrh	r4, [r4]	@ movhi
	strh	r4, [r3]	@ movhi
	add	r3, r7, #1664
	subw	r3, r3, #1526
	ldrh	r0, [r0]	@ movhi
	strh	r0, [r3]	@ movhi
	add	r3, r7, #1664
	subw	r3, r3, #1524
	ldrh	r1, [r1]	@ movhi
	strh	r1, [r3]	@ movhi
	add	r3, r7, #1664
	subw	r3, r3, #1522
	ldrh	r2, [r2]	@ movhi
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1664
	sub	r3, r3, #1536
	vld1.64	{d16-d17}, [r3:64]
	vmov	q9, q8  @ v8hi
	add	r3, r7, #1664
	sub	r3, r3, #1384
	add	r2, r7, #1640
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1400
	vst1.64	{d18-d19}, [r3:64]
	add	r3, r7, #1664
	sub	r2, r3, #1384
	add	r3, r7, #1664
	sub	r3, r3, #1400
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vsub.i16	q8, q9, q8
	add	r3, r7, #1640
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	subw	r3, r3, #1362
	movs	r2, #128
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1664
	subw	lr, r3, #1362
	add	r3, r7, #1664
	subw	ip, r3, #1362
	add	r3, r7, #1664
	subw	r6, r3, #1362
	add	r3, r7, #1664
	subw	r5, r3, #1362
	add	r3, r7, #1664
	subw	r4, r3, #1362
	add	r3, r7, #1664
	subw	r0, r3, #1362
	add	r3, r7, #1664
	subw	r1, r3, #1362
	add	r3, r7, #1664
	subw	r2, r3, #1362
	add	r3, r7, #1664
	sub	r3, r3, #1552
	ldrh	lr, [lr]	@ movhi
	strh	lr, [r3]	@ movhi
	add	r3, r7, #1664
	subw	r3, r3, #1550
	ldrh	ip, [ip]	@ movhi
	strh	ip, [r3]	@ movhi
	add	r3, r7, #1664
	subw	r3, r3, #1548
	ldrh	r6, [r6]	@ movhi
	strh	r6, [r3]	@ movhi
	add	r3, r7, #1664
	subw	r3, r3, #1546
	ldrh	r5, [r5]	@ movhi
	strh	r5, [r3]	@ movhi
	add	r3, r7, #1664
	sub	r3, r3, #1544
	ldrh	r4, [r4]	@ movhi
	strh	r4, [r3]	@ movhi
	add	r3, r7, #1664
	subw	r3, r3, #1542
	ldrh	r0, [r0]	@ movhi
	strh	r0, [r3]	@ movhi
	add	r3, r7, #1664
	subw	r3, r3, #1540
	ldrh	r1, [r1]	@ movhi
	strh	r1, [r3]	@ movhi
	add	r3, r7, #1664
	subw	r3, r3, #1538
	ldrh	r2, [r2]	@ movhi
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1664
	sub	r3, r3, #1552
	vld1.64	{d16-d17}, [r3:64]
	vmov	q9, q8  @ v8hi
	add	r3, r7, #1664
	sub	r3, r3, #1344
	add	r2, r7, #1624
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1360
	vst1.64	{d18-d19}, [r3:64]
	add	r3, r7, #1664
	sub	r2, r3, #1344
	add	r3, r7, #1664
	sub	r3, r3, #1360
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vsub.i16	q8, q9, q8
	add	r3, r7, #1624
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	subw	r3, r3, #1322
	movs	r2, #128
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1664
	subw	lr, r3, #1322
	add	r3, r7, #1664
	subw	ip, r3, #1322
	add	r3, r7, #1664
	subw	r6, r3, #1322
	add	r3, r7, #1664
	subw	r5, r3, #1322
	add	r3, r7, #1664
	subw	r4, r3, #1322
	add	r3, r7, #1664
	subw	r0, r3, #1322
	add	r3, r7, #1664
	subw	r1, r3, #1322
	add	r3, r7, #1664
	subw	r2, r3, #1322
	add	r3, r7, #1664
	sub	r3, r3, #1568
	ldrh	lr, [lr]	@ movhi
	strh	lr, [r3]	@ movhi
	add	r3, r7, #1664
	subw	r3, r3, #1566
	ldrh	ip, [ip]	@ movhi
	strh	ip, [r3]	@ movhi
	add	r3, r7, #1664
	subw	r3, r3, #1564
	ldrh	r6, [r6]	@ movhi
	strh	r6, [r3]	@ movhi
	add	r3, r7, #1664
	subw	r3, r3, #1562
	ldrh	r5, [r5]	@ movhi
	strh	r5, [r3]	@ movhi
	add	r3, r7, #1664
	sub	r3, r3, #1560
	ldrh	r4, [r4]	@ movhi
	strh	r4, [r3]	@ movhi
	add	r3, r7, #1664
	subw	r3, r3, #1558
	ldrh	r0, [r0]	@ movhi
	strh	r0, [r3]	@ movhi
	add	r3, r7, #1664
	subw	r3, r3, #1556
	ldrh	r1, [r1]	@ movhi
	strh	r1, [r3]	@ movhi
	add	r3, r7, #1664
	subw	r3, r3, #1554
	ldrh	r2, [r2]	@ movhi
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1664
	sub	r3, r3, #1568
	vld1.64	{d16-d17}, [r3:64]
	vmov	q9, q8  @ v8hi
	add	r3, r7, #1664
	sub	r3, r3, #1304
	add	r2, r7, #1608
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1320
	vst1.64	{d18-d19}, [r3:64]
	add	r3, r7, #1664
	sub	r2, r3, #1304
	add	r3, r7, #1664
	sub	r3, r3, #1320
	vld1.64	{d18-d19}, [r2:64]
	vld1.64	{d16-d17}, [r3:64]
	vsub.i16	q8, q9, q8
	add	r3, r7, #1608
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1288
	add	r2, r7, #1640
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1288
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1272
	vstr	d16, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #1272
	vldr	d16, [r3]
	vmovl.s16	q8, d16
	add	r3, r7, #1592
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1264
	add	r2, r7, #1640
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1264
	vld1.64	{d16-d17}, [r3:64]
	vmov	d16, d17  @ v4hi
	add	r3, r7, #1664
	sub	r3, r3, #1248
	vstr	d16, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #1248
	vldr	d16, [r3]
	vmovl.s16	q8, d16
	add	r3, r7, #1576
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1240
	add	r2, r7, #1624
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1240
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1224
	vstr	d16, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #1224
	vldr	d16, [r3]
	vmovl.s16	q8, d16
	add	r3, r7, #1560
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1216
	add	r2, r7, #1624
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1216
	vld1.64	{d16-d17}, [r3:64]
	vmov	d16, d17  @ v4hi
	add	r3, r7, #1664
	sub	r3, r3, #1200
	vstr	d16, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #1200
	vldr	d16, [r3]
	vmovl.s16	q8, d16
	add	r3, r7, #1544
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1192
	add	r2, r7, #1608
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1192
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1176
	vstr	d16, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #1176
	vldr	d16, [r3]
	vmovl.s16	q8, d16
	add	r3, r7, #1528
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1168
	add	r2, r7, #1608
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1168
	vld1.64	{d16-d17}, [r3:64]
	vmov	d16, d17  @ v4hi
	add	r3, r7, #1664
	sub	r3, r3, #1152
	vstr	d16, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #1152
	vldr	d16, [r3]
	vmovl.s16	q8, d16
	add	r3, r7, #1512
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1144
	movs	r2, #128
	str	r2, [r3]
	add	r3, r7, #1664
	sub	r4, r3, #1144
	add	r3, r7, #1664
	sub	r0, r3, #1144
	add	r3, r7, #1664
	sub	r1, r3, #1144
	add	r3, r7, #1664
	sub	r2, r3, #1144
	add	r3, r7, #1664
	sub	r3, r3, #1584
	ldr	r4, [r4]
	str	r4, [r3]
	add	r3, r7, #1664
	subw	r3, r3, #1580
	ldr	r0, [r0]
	str	r0, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #1576
	ldr	r1, [r1]
	str	r1, [r3]
	add	r3, r7, #1664
	subw	r3, r3, #1572
	ldr	r2, [r2]
	str	r2, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #1584
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1496
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1120
	add	r2, r7, #1496
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1136
	add	r2, r7, #1592
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	subw	r3, r3, #1140
	mov	r2, #298
	str	r2, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #1120
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1136
	vld1.64	{d18-d19}, [r3:64]
	add	r3, r7, #1664
	subw	r3, r3, #1140
	ldr	r3, [r3]
	vmov.32	d15[0], r3
	vmla.i32	q8, q9, d15[0]
	add	r3, r7, #1496
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1080
	add	r2, r7, #1496
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1096
	add	r2, r7, #1528
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	subw	r3, r3, #1100
	movw	r2, #409
	str	r2, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #1080
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1096
	vld1.64	{d18-d19}, [r3:64]
	add	r3, r7, #1664
	subw	r3, r3, #1100
	ldr	r3, [r3]
	vmov.32	d14[0], r3
	vmla.i32	q8, q9, d14[0]
	add	r3, r7, #1496
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1064
	add	r2, r7, #1496
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1064
	vld1.64	{d16-d17}, [r3:64]
	vshr.s32	q8, q8, #8
	add	r3, r7, #1496
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1048
	movs	r2, #128
	str	r2, [r3]
	add	r3, r7, #1664
	sub	r4, r3, #1048
	add	r3, r7, #1664
	sub	r0, r3, #1048
	add	r3, r7, #1664
	sub	r1, r3, #1048
	add	r3, r7, #1664
	sub	r2, r3, #1048
	add	r3, r7, #1664
	sub	r3, r3, #1600
	ldr	r4, [r4]
	str	r4, [r3]
	add	r3, r7, #1664
	subw	r3, r3, #1596
	ldr	r0, [r0]
	str	r0, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #1592
	ldr	r1, [r1]
	str	r1, [r3]
	add	r3, r7, #1664
	subw	r3, r3, #1588
	ldr	r2, [r2]
	str	r2, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #1600
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1480
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1024
	add	r2, r7, #1480
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1040
	add	r2, r7, #1576
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	subw	r3, r3, #1044
	mov	r2, #298
	str	r2, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #1024
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #1040
	vld1.64	{d18-d19}, [r3:64]
	add	r3, r7, #1664
	subw	r3, r3, #1044
	ldr	r3, [r3]
	vmov.32	d13[0], r3
	vmla.i32	q8, q9, d13[0]
	add	r3, r7, #1480
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1480
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #680]
	vstr	d17, [r7, #688]
	add	r3, r7, #1512
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #664]
	vstr	d17, [r7, #672]
	add	r3, r7, #1664
	sub	r3, r3, #1004
	movw	r2, #409
	str	r2, [r3]
	vldr	d16, [r7, #680]
	vldr	d17, [r7, #688]
	vldr	d18, [r7, #664]
	vldr	d19, [r7, #672]
	add	r3, r7, #1664
	sub	r3, r3, #1004
	ldr	r3, [r3]
	vmov.32	d12[0], r3
	vmla.i32	q8, q9, d12[0]
	add	r3, r7, #1480
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1480
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #696]
	vstr	d17, [r7, #704]
	vldr	d16, [r7, #696]
	vldr	d17, [r7, #704]
	vshr.s32	q8, q8, #8
	add	r3, r7, #1480
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #952
	movs	r2, #128
	str	r2, [r3]
	add	r3, r7, #1664
	sub	r4, r3, #952
	add	r3, r7, #1664
	sub	r0, r3, #952
	add	r3, r7, #1664
	sub	r1, r3, #952
	add	r3, r7, #1664
	sub	r2, r3, #952
	add	r3, r7, #1664
	sub	r3, r3, #1616
	ldr	r4, [r4]
	str	r4, [r3]
	add	r3, r7, #1664
	subw	r3, r3, #1612
	ldr	r0, [r0]
	str	r0, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #1608
	ldr	r1, [r1]
	str	r1, [r3]
	add	r3, r7, #1664
	subw	r3, r3, #1604
	ldr	r2, [r2]
	str	r2, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #1616
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1464
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1464
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #736]
	vstr	d17, [r7, #744]
	add	r3, r7, #1592
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #720]
	vstr	d17, [r7, #728]
	add	r3, r7, #1664
	sub	r3, r3, #948
	mov	r2, #298
	str	r2, [r3]
	vldr	d16, [r7, #736]
	vldr	d17, [r7, #744]
	vldr	d18, [r7, #720]
	vldr	d19, [r7, #728]
	add	r3, r7, #1664
	sub	r3, r3, #948
	ldr	r3, [r3]
	vmov.32	d11[0], r3
	vmla.i32	q8, q9, d11[0]
	add	r3, r7, #1464
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1464
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #776]
	vstr	d17, [r7, #784]
	add	r3, r7, #1528
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #760]
	vstr	d17, [r7, #768]
	add	r3, r7, #1664
	sub	r3, r3, #908
	movs	r2, #208
	str	r2, [r3]
	vldr	d16, [r7, #776]
	vldr	d17, [r7, #784]
	vldr	d18, [r7, #760]
	vldr	d19, [r7, #768]
	add	r3, r7, #1664
	sub	r3, r3, #908
	ldr	r3, [r3]
	vmov.32	d10[0], r3
	vmls.i32	q8, q9, d10[0]
	add	r3, r7, #1464
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1464
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #816]
	vstr	d17, [r7, #824]
	add	r3, r7, #1560
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #800]
	vstr	d17, [r7, #808]
	add	r3, r7, #1664
	sub	r3, r3, #868
	movs	r2, #100
	str	r2, [r3]
	vldr	d16, [r7, #816]
	vldr	d17, [r7, #824]
	vldr	d18, [r7, #800]
	vldr	d19, [r7, #808]
	add	r3, r7, #1664
	sub	r3, r3, #868
	ldr	r3, [r3]
	vmov.32	d9[0], r3
	vmls.i32	q8, q9, d9[0]
	add	r3, r7, #1464
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1464
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #832]
	vstr	d17, [r7, #840]
	vldr	d16, [r7, #832]
	vldr	d17, [r7, #840]
	vshr.s32	q8, q8, #8
	add	r3, r7, #1464
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #816
	movs	r2, #128
	str	r2, [r3]
	add	r3, r7, #1664
	sub	r4, r3, #816
	add	r3, r7, #1664
	sub	r0, r3, #816
	add	r3, r7, #1664
	sub	r1, r3, #816
	add	r3, r7, #1664
	sub	r2, r3, #816
	add	r3, r7, #1664
	sub	r3, r3, #1632
	ldr	r4, [r4]
	str	r4, [r3]
	add	r3, r7, #1664
	subw	r3, r3, #1628
	ldr	r0, [r0]
	str	r0, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #1624
	ldr	r1, [r1]
	str	r1, [r3]
	add	r3, r7, #1664
	subw	r3, r3, #1620
	ldr	r2, [r2]
	str	r2, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #1632
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1448
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1448
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #872]
	vstr	d17, [r7, #880]
	add	r3, r7, #1576
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #856]
	vstr	d17, [r7, #864]
	add	r3, r7, #1664
	sub	r3, r3, #812
	mov	r2, #298
	str	r2, [r3]
	vldr	d16, [r7, #872]
	vldr	d17, [r7, #880]
	vldr	d18, [r7, #856]
	vldr	d19, [r7, #864]
	add	r3, r7, #1664
	sub	r3, r3, #812
	ldr	r3, [r3]
	vmov.32	d8[0], r3
	vmla.i32	q8, q9, d8[0]
	add	r3, r7, #1448
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1448
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #912]
	vstr	d17, [r7, #920]
	add	r3, r7, #1512
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #896]
	vstr	d17, [r7, #904]
	add	r3, r7, #1664
	sub	r3, r3, #772
	movs	r2, #208
	str	r2, [r3]
	vldr	d16, [r7, #912]
	vldr	d17, [r7, #920]
	vldr	d18, [r7, #896]
	vldr	d19, [r7, #904]
	add	r3, r7, #1664
	sub	r3, r3, #772
	ldr	r3, [r3]
	vmov.32	d2[0], r3
	vmls.i32	q8, q9, d2[0]
	add	r3, r7, #1448
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1448
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #952]
	vstr	d17, [r7, #960]
	add	r3, r7, #1544
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #936]
	vstr	d17, [r7, #944]
	add	r3, r7, #1664
	sub	r3, r3, #732
	movs	r2, #100
	str	r2, [r3]
	vldr	d16, [r7, #952]
	vldr	d17, [r7, #960]
	vldr	d18, [r7, #936]
	vldr	d19, [r7, #944]
	add	r3, r7, #1664
	sub	r3, r3, #732
	ldr	r3, [r3]
	vmov.32	d3[0], r3
	vmls.i32	q8, q9, d3[0]
	add	r3, r7, #1448
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1448
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #968]
	vstr	d17, [r7, #976]
	vldr	d16, [r7, #968]
	vldr	d17, [r7, #976]
	vshr.s32	q8, q8, #8
	add	r3, r7, #1448
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #680
	movs	r2, #128
	str	r2, [r3]
	add	r3, r7, #1664
	sub	r4, r3, #680
	add	r3, r7, #1664
	sub	r0, r3, #680
	add	r3, r7, #1664
	sub	r1, r3, #680
	add	r3, r7, #1664
	sub	r2, r3, #680
	add	r3, r7, #1664
	sub	r3, r3, #1648
	ldr	r4, [r4]
	str	r4, [r3]
	add	r3, r7, #1664
	subw	r3, r3, #1644
	ldr	r0, [r0]
	str	r0, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #1640
	ldr	r1, [r1]
	str	r1, [r3]
	add	r3, r7, #1664
	subw	r3, r3, #1636
	ldr	r2, [r2]
	str	r2, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #1648
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1432
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1432
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #1008]
	vstr	d17, [r7, #1016]
	add	r3, r7, #1592
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #992]
	vstr	d17, [r7, #1000]
	add	r3, r7, #1664
	sub	r3, r3, #676
	mov	r2, #298
	str	r2, [r3]
	vldr	d16, [r7, #1008]
	vldr	d17, [r7, #1016]
	vldr	d18, [r7, #992]
	vldr	d19, [r7, #1000]
	add	r3, r7, #1664
	sub	r3, r3, #676
	ldr	r3, [r3]
	vmov.32	d4[0], r3
	vmla.i32	q8, q9, d4[0]
	add	r3, r7, #1432
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1432
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1048
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1560
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1032
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #636
	movw	r2, #517
	str	r2, [r3]
	add	r3, r7, #1048
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1032
	vld1.64	{d18-d19}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #636
	ldr	r3, [r3]
	vmov.32	d5[0], r3
	vmla.i32	q8, q9, d5[0]
	add	r3, r7, #1432
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1432
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1064
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1064
	vld1.64	{d16-d17}, [r3:64]
	vshr.s32	q8, q8, #8
	add	r3, r7, #1432
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #584
	movs	r2, #128
	str	r2, [r3]
	add	r3, r7, #1664
	sub	r4, r3, #584
	add	r3, r7, #1664
	sub	r0, r3, #584
	add	r3, r7, #1664
	sub	r1, r3, #584
	add	r3, r7, #1664
	sub	r2, r3, #584
	add	r3, r7, #1664
	sub	r3, r3, #1664
	ldr	r4, [r4]
	str	r4, [r3]
	add	r3, r7, #1664
	subw	r3, r3, #1660
	ldr	r0, [r0]
	str	r0, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #1656
	ldr	r1, [r1]
	str	r1, [r3]
	add	r3, r7, #1664
	subw	r3, r3, #1652
	ldr	r2, [r2]
	str	r2, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #1664
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1416
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1416
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1104
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1576
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1088
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #580
	mov	r2, #298
	str	r2, [r3]
	add	r3, r7, #1104
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1088
	vld1.64	{d18-d19}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #580
	ldr	r3, [r3]
	vmov.32	d6[0], r3
	vmla.i32	q8, q9, d6[0]
	add	r3, r7, #1416
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1416
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1144
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1544
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1128
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #540
	movw	r2, #517
	str	r2, [r3]
	add	r3, r7, #1144
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1128
	vld1.64	{d18-d19}, [r3:64]
	add	r3, r7, #1664
	sub	r3, r3, #540
	ldr	r3, [r3]
	vmov.32	d7[0], r3
	vmla.i32	q8, q9, d7[0]
	add	r3, r7, #1416
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1416
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1160
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1160
	vld1.64	{d16-d17}, [r3:64]
	vshr.s32	q8, q8, #8
	add	r3, r7, #1416
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1496
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1176
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1176
	vld1.64	{d16-d17}, [r3:64]
	vqmovn.s32	d18, q8
	add	r3, r7, #1480
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1192
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1192
	vld1.64	{d16-d17}, [r3:64]
	vqmovn.s32	d16, q8
	add	r3, r7, #1216
	vstr	d18, [r3]
	add	r3, r7, #1208
	vstr	d16, [r3]
	add	r3, r7, #1216
	vldr	d17, [r3]
	add	r3, r7, #1208
	vldr	d16, [r3]
	vswp	d16, d17
	add	r3, r7, #1224
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1224
	vld1.64	{d16-d17}, [r3:64]
	vqmovun.s16	d16, q8
	add	r3, r7, #1664
	sub	r3, r3, #412
	add	r2, r7, #1664
	subw	r2, r2, #1492
	ldr	r2, [r2]
	str	r2, [r3]
	add	r3, r7, #1240
	vstr	d16, [r3]
	add	r3, r7, #1240
	vldr	d16, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #412
	ldr	r3, [r3]
	vst1.8	{d16}, [r3]
	nop
	add	r3, r7, #1464
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1256
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1256
	vld1.64	{d16-d17}, [r3:64]
	vqmovn.s32	d18, q8
	add	r3, r7, #1448
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1272
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1272
	vld1.64	{d16-d17}, [r3:64]
	vqmovn.s32	d16, q8
	add	r3, r7, #1296
	vstr	d18, [r3]
	add	r3, r7, #1288
	vstr	d16, [r3]
	add	r3, r7, #1296
	vldr	d17, [r3]
	add	r3, r7, #1288
	vldr	d16, [r3]
	vswp	d16, d17
	add	r3, r7, #1304
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1304
	vld1.64	{d16-d17}, [r3:64]
	vqmovun.s16	d16, q8
	add	r3, r7, #1664
	sub	r3, r3, #332
	add	r2, r7, #1664
	sub	r2, r2, #1496
	ldr	r2, [r2]
	str	r2, [r3]
	add	r3, r7, #1320
	vstr	d16, [r3]
	add	r3, r7, #1320
	vldr	d16, [r3]
	add	r3, r7, #1664
	sub	r3, r3, #332
	ldr	r3, [r3]
	vst1.8	{d16}, [r3]
	nop
	add	r3, r7, #1432
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1336
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1336
	vld1.64	{d16-d17}, [r3:64]
	vqmovn.s32	d18, q8
	add	r3, r7, #1416
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1352
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1352
	vld1.64	{d16-d17}, [r3:64]
	vqmovn.s32	d16, q8
	add	r3, r7, #1376
	vstr	d18, [r3]
	add	r3, r7, #1368
	vstr	d16, [r3]
	add	r3, r7, #1376
	vldr	d17, [r3]
	add	r3, r7, #1368
	vldr	d16, [r3]
	vswp	d16, d17
	add	r3, r7, #1384
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1384
	vld1.64	{d16-d17}, [r3:64]
	vqmovun.s16	d16, q8
	add	r3, r7, #1664
	subw	r3, r3, #1500
	ldr	r3, [r3]
	str	r3, [r7, #1412]
	add	r3, r7, #1400
	vstr	d16, [r3]
	add	r3, r7, #1400
	vldr	d16, [r3]
	ldr	r3, [r7, #1412]
	vst1.8	{d16}, [r3]
	nop
	nop
	addw	r7, r7, #1668
	mov	sp, r7
	@ sp needed
	vldm	sp!, {d8-d15}
	pop	{r4, r5, r6, r7, pc}
	.size	neon_ycc_to_rgb_strip, .-neon_ycc_to_rgb_strip
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.type	CSC_YCC_to_RGB_neon_v3, %function
CSC_YCC_to_RGB_neon_v3:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r5, r7, lr}
	sub	sp, sp, #16
	add	r7, sp, #0
	movs	r3, #0
	str	r3, [r7, #12]
	b	.L125
.L130:
	movs	r3, #0
	str	r3, [r7, #8]
	b	.L126
.L129:
	ldr	r3, [r7, #12]
	movs	r2, #48
	mul	r2, r3, r2
	ldr	r3, [r7, #8]
	add	r2, r2, r3
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	adds	r0, r2, r3
	ldr	r3, [r7, #12]
	movs	r2, #48
	mul	r2, r3, r2
	ldr	r3, [r7, #8]
	add	r2, r2, r3
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	adds	r1, r2, r3
	ldr	r3, [r7, #12]
	movs	r2, #48
	mul	r2, r3, r2
	ldr	r3, [r7, #8]
	add	r2, r2, r3
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	adds	r4, r2, r3
	ldr	r3, [r7, #12]
	movs	r2, #48
	mul	r2, r3, r2
	ldr	r3, [r7, #8]
	add	r2, r2, r3
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	adds	r5, r2, r3
	ldr	r3, [r7, #12]
	movs	r2, #48
	mul	r2, r3, r2
	ldr	r3, [r7, #8]
	add	r2, r2, r3
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	add	r3, r3, r2
	str	r3, [r7]
	ldr	r3, [r7]
	vld1.8	{d16}, [r3]
	vmov	d17, d16  @ v8qi
	ldr	r3, [r7, #12]
	movs	r2, #48
	mul	r2, r3, r2
	ldr	r3, [r7, #8]
	add	r2, r2, r3
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	add	r3, r3, r2
	str	r3, [r7, #4]
	ldr	r3, [r7, #4]
	vld1.8	{d16}, [r3]
	nop
	vmov	d1, d16  @ v8qi
	vmov	d0, d17  @ v8qi
	mov	r3, r5
	mov	r2, r4
	bl	neon_ycc_to_rgb_strip
	ldr	r3, [r7, #8]
	adds	r3, r3, #8
	str	r3, [r7, #8]
.L126:
	ldr	r3, [r7, #8]
	cmp	r3, #47
	ble	.L129
	ldr	r3, [r7, #12]
	adds	r3, r3, #1
	str	r3, [r7, #12]
.L125:
	ldr	r3, [r7, #12]
	cmp	r3, #63
	ble	.L130
	nop
	nop
	adds	r7, r7, #16
	mov	sp, r7
	@ sp needed
	pop	{r4, r5, r7, pc}
	.size	CSC_YCC_to_RGB_neon_v3, .-CSC_YCC_to_RGB_neon_v3
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.type	chrominance_upsample, %function
chrominance_upsample:
	@ args = 12, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r4, r7}
	sub	sp, sp, #24
	add	r7, sp, #0
	mov	r4, r0
	mov	r0, r1
	mov	r1, r2
	mov	r2, r3
	mov	r3, r4
	strb	r3, [r7, #7]
	mov	r3, r0
	strb	r3, [r7, #6]
	mov	r3, r1
	strb	r3, [r7, #5]
	mov	r3, r2
	strb	r3, [r7, #4]
	ldrb	r2, [r7, #7]	@ zero_extendqisi2
	ldrb	r3, [r7, #6]	@ zero_extendqisi2
	add	r3, r3, r2
	str	r3, [r7, #20]
	ldr	r3, [r7, #20]
	adds	r3, r3, #1
	str	r3, [r7, #20]
	ldr	r3, [r7, #20]
	asrs	r3, r3, #1
	uxtb	r2, r3
	ldr	r3, [r7, #32]
	strb	r2, [r3]
	ldrb	r2, [r7, #7]	@ zero_extendqisi2
	ldrb	r3, [r7, #5]	@ zero_extendqisi2
	add	r3, r3, r2
	str	r3, [r7, #16]
	ldr	r3, [r7, #16]
	adds	r3, r3, #1
	str	r3, [r7, #16]
	ldr	r3, [r7, #16]
	asrs	r3, r3, #1
	uxtb	r2, r3
	ldr	r3, [r7, #36]
	strb	r2, [r3]
	ldrb	r2, [r7, #7]	@ zero_extendqisi2
	ldrb	r3, [r7, #6]	@ zero_extendqisi2
	add	r2, r2, r3
	ldrb	r3, [r7, #5]	@ zero_extendqisi2
	add	r2, r2, r3
	ldrb	r3, [r7, #4]	@ zero_extendqisi2
	add	r3, r3, r2
	str	r3, [r7, #12]
	ldr	r3, [r7, #12]
	adds	r3, r3, #2
	str	r3, [r7, #12]
	ldr	r3, [r7, #12]
	asrs	r3, r3, #2
	uxtb	r2, r3
	ldr	r3, [r7, #40]
	strb	r2, [r3]
	nop
	nop
	adds	r7, r7, #24
	mov	sp, r7
	@ sp needed
	pop	{r4, r7}
	bx	lr
	.size	chrominance_upsample, .-chrominance_upsample
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.type	chrominance_array_upsample, %function
chrominance_array_upsample:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}
	sub	sp, sp, #36
	add	r7, sp, #16
	movs	r3, #0
	str	r3, [r7, #12]
	b	.L133
.L136:
	movs	r3, #0
	str	r3, [r7, #8]
	b	.L134
.L135:
	movw	r3, #:lower16:Cb
	movt	r3, #:upper16:Cb
	ldr	r2, [r7, #12]
	movs	r1, #24
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r0, [r3]	@ zero_extendqisi2
	ldr	r3, [r7, #8]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cb
	movt	r3, #:upper16:Cb
	ldr	r1, [r7, #12]
	movs	r4, #24
	mul	r1, r4, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r4, [r3]	@ zero_extendqisi2
	ldr	r3, [r7, #12]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cb
	movt	r3, #:upper16:Cb
	movs	r1, #24
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r5, [r3]	@ zero_extendqisi2
	ldr	r3, [r7, #12]
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cb
	movt	r3, #:upper16:Cb
	movs	r6, #24
	mul	r1, r6, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r2, [r3]	@ zero_extendqisi2
	adds	r3, r7, #5
	str	r3, [sp, #8]
	adds	r3, r7, #6
	str	r3, [sp, #4]
	adds	r3, r7, #7
	str	r3, [sp]
	mov	r3, r2
	mov	r2, r5
	mov	r1, r4
	bl	chrominance_upsample
	ldr	r3, [r7, #12]
	lsls	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r2, r3, #1
	movw	r3, #:lower16:Cb
	movt	r3, #:upper16:Cb
	ldr	r0, [r7, #12]
	movs	r4, #24
	mul	r0, r4, r0
	add	r0, r0, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r0
	ldrb	r4, [r3]	@ zero_extendqisi2
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	lsls	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r3, r3, #1
	adds	r2, r3, #1
	ldrb	r4, [r7, #7]	@ zero_extendqisi2
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	lsls	r3, r3, #1
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r2, r3, #1
	ldrb	r4, [r7, #6]	@ zero_extendqisi2
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	lsls	r3, r3, #1
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r3, r3, #1
	adds	r2, r3, #1
	ldrb	r4, [r7, #5]	@ zero_extendqisi2
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	ldr	r2, [r7, #12]
	movs	r1, #24
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r0, [r3]	@ zero_extendqisi2
	ldr	r3, [r7, #8]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	ldr	r1, [r7, #12]
	movs	r4, #24
	mul	r1, r4, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r4, [r3]	@ zero_extendqisi2
	ldr	r3, [r7, #12]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	movs	r1, #24
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r5, [r3]	@ zero_extendqisi2
	ldr	r3, [r7, #12]
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	movs	r6, #24
	mul	r1, r6, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r2, [r3]	@ zero_extendqisi2
	adds	r3, r7, #5
	str	r3, [sp, #8]
	adds	r3, r7, #6
	str	r3, [sp, #4]
	adds	r3, r7, #7
	str	r3, [sp]
	mov	r3, r2
	mov	r2, r5
	mov	r1, r4
	bl	chrominance_upsample
	ldr	r3, [r7, #12]
	lsls	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r2, r3, #1
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	ldr	r0, [r7, #12]
	movs	r4, #24
	mul	r0, r4, r0
	add	r0, r0, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r0
	ldrb	r4, [r3]	@ zero_extendqisi2
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	lsls	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r3, r3, #1
	adds	r2, r3, #1
	ldrb	r4, [r7, #7]	@ zero_extendqisi2
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	lsls	r3, r3, #1
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r2, r3, #1
	ldrb	r4, [r7, #6]	@ zero_extendqisi2
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	lsls	r3, r3, #1
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r3, r3, #1
	adds	r2, r3, #1
	ldrb	r4, [r7, #5]	@ zero_extendqisi2
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #8]
	adds	r3, r3, #1
	str	r3, [r7, #8]
.L134:
	ldr	r3, [r7, #8]
	cmp	r3, #22
	ble	.L135
	ldr	r3, [r7, #12]
	adds	r3, r3, #1
	str	r3, [r7, #12]
.L133:
	ldr	r3, [r7, #12]
	cmp	r3, #30
	ble	.L136
	movs	r3, #23
	str	r3, [r7, #8]
	movs	r3, #0
	str	r3, [r7, #12]
	b	.L137
.L138:
	movw	r3, #:lower16:Cb
	movt	r3, #:upper16:Cb
	ldr	r2, [r7, #12]
	movs	r1, #24
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r0, [r3]	@ zero_extendqisi2
	movw	r3, #:lower16:Cb
	movt	r3, #:upper16:Cb
	ldr	r2, [r7, #12]
	movs	r1, #24
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r1, [r3]	@ zero_extendqisi2
	ldr	r3, [r7, #12]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cb
	movt	r3, #:upper16:Cb
	movs	r4, #24
	mul	r2, r4, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r4, [r3]	@ zero_extendqisi2
	ldr	r3, [r7, #12]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cb
	movt	r3, #:upper16:Cb
	movs	r5, #24
	mul	r2, r5, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r2, [r3]	@ zero_extendqisi2
	adds	r3, r7, #5
	str	r3, [sp, #8]
	adds	r3, r7, #6
	str	r3, [sp, #4]
	adds	r3, r7, #7
	str	r3, [sp]
	mov	r3, r2
	mov	r2, r4
	bl	chrominance_upsample
	ldr	r3, [r7, #12]
	lsls	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r2, r3, #1
	movw	r3, #:lower16:Cb
	movt	r3, #:upper16:Cb
	ldr	r0, [r7, #12]
	movs	r4, #24
	mul	r0, r4, r0
	add	r0, r0, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r0
	ldrb	r4, [r3]	@ zero_extendqisi2
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	lsls	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r3, r3, #1
	adds	r2, r3, #1
	ldrb	r4, [r7, #7]	@ zero_extendqisi2
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	lsls	r3, r3, #1
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r2, r3, #1
	ldrb	r4, [r7, #6]	@ zero_extendqisi2
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	lsls	r3, r3, #1
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r3, r3, #1
	adds	r2, r3, #1
	ldrb	r4, [r7, #5]	@ zero_extendqisi2
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	ldr	r2, [r7, #12]
	movs	r1, #24
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r0, [r3]	@ zero_extendqisi2
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	ldr	r2, [r7, #12]
	movs	r1, #24
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r1, [r3]	@ zero_extendqisi2
	ldr	r3, [r7, #12]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	movs	r4, #24
	mul	r2, r4, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r4, [r3]	@ zero_extendqisi2
	ldr	r3, [r7, #12]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	movs	r5, #24
	mul	r2, r5, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r2, [r3]	@ zero_extendqisi2
	adds	r3, r7, #5
	str	r3, [sp, #8]
	adds	r3, r7, #6
	str	r3, [sp, #4]
	adds	r3, r7, #7
	str	r3, [sp]
	mov	r3, r2
	mov	r2, r4
	bl	chrominance_upsample
	ldr	r3, [r7, #12]
	lsls	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r2, r3, #1
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	ldr	r0, [r7, #12]
	movs	r4, #24
	mul	r0, r4, r0
	add	r0, r0, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r0
	ldrb	r4, [r3]	@ zero_extendqisi2
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	lsls	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r3, r3, #1
	adds	r2, r3, #1
	ldrb	r4, [r7, #7]	@ zero_extendqisi2
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	lsls	r3, r3, #1
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r2, r3, #1
	ldrb	r4, [r7, #6]	@ zero_extendqisi2
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	lsls	r3, r3, #1
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r3, r3, #1
	adds	r2, r3, #1
	ldrb	r4, [r7, #5]	@ zero_extendqisi2
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	adds	r3, r3, #1
	str	r3, [r7, #12]
.L137:
	ldr	r3, [r7, #12]
	cmp	r3, #30
	ble	.L138
	movs	r3, #31
	str	r3, [r7, #12]
	movs	r3, #0
	str	r3, [r7, #8]
	b	.L139
.L140:
	movw	r3, #:lower16:Cb
	movt	r3, #:upper16:Cb
	ldr	r2, [r7, #12]
	movs	r1, #24
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r0, [r3]	@ zero_extendqisi2
	ldr	r3, [r7, #8]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cb
	movt	r3, #:upper16:Cb
	ldr	r1, [r7, #12]
	movs	r4, #24
	mul	r1, r4, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r4, [r3]	@ zero_extendqisi2
	movw	r3, #:lower16:Cb
	movt	r3, #:upper16:Cb
	ldr	r2, [r7, #12]
	movs	r1, #24
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r5, [r3]	@ zero_extendqisi2
	ldr	r3, [r7, #8]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cb
	movt	r3, #:upper16:Cb
	ldr	r1, [r7, #12]
	movs	r6, #24
	mul	r1, r6, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r2, [r3]	@ zero_extendqisi2
	adds	r3, r7, #5
	str	r3, [sp, #8]
	adds	r3, r7, #6
	str	r3, [sp, #4]
	adds	r3, r7, #7
	str	r3, [sp]
	mov	r3, r2
	mov	r2, r5
	mov	r1, r4
	bl	chrominance_upsample
	ldr	r3, [r7, #12]
	lsls	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r2, r3, #1
	movw	r3, #:lower16:Cb
	movt	r3, #:upper16:Cb
	ldr	r0, [r7, #12]
	movs	r4, #24
	mul	r0, r4, r0
	add	r0, r0, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r0
	ldrb	r4, [r3]	@ zero_extendqisi2
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	lsls	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r3, r3, #1
	adds	r2, r3, #1
	ldrb	r4, [r7, #7]	@ zero_extendqisi2
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	lsls	r3, r3, #1
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r2, r3, #1
	ldrb	r4, [r7, #6]	@ zero_extendqisi2
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	lsls	r3, r3, #1
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r3, r3, #1
	adds	r2, r3, #1
	ldrb	r4, [r7, #5]	@ zero_extendqisi2
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	ldr	r2, [r7, #12]
	movs	r1, #24
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r0, [r3]	@ zero_extendqisi2
	ldr	r3, [r7, #8]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	ldr	r1, [r7, #12]
	movs	r4, #24
	mul	r1, r4, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r4, [r3]	@ zero_extendqisi2
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	ldr	r2, [r7, #12]
	movs	r1, #24
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r5, [r3]	@ zero_extendqisi2
	ldr	r3, [r7, #8]
	adds	r2, r3, #1
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	ldr	r1, [r7, #12]
	movs	r6, #24
	mul	r1, r6, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r2, [r3]	@ zero_extendqisi2
	adds	r3, r7, #5
	str	r3, [sp, #8]
	adds	r3, r7, #6
	str	r3, [sp, #4]
	adds	r3, r7, #7
	str	r3, [sp]
	mov	r3, r2
	mov	r2, r5
	mov	r1, r4
	bl	chrominance_upsample
	ldr	r3, [r7, #12]
	lsls	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r2, r3, #1
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	ldr	r0, [r7, #12]
	movs	r4, #24
	mul	r0, r4, r0
	add	r0, r0, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r0
	ldrb	r4, [r3]	@ zero_extendqisi2
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	lsls	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r3, r3, #1
	adds	r2, r3, #1
	ldrb	r4, [r7, #7]	@ zero_extendqisi2
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	lsls	r3, r3, #1
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r2, r3, #1
	ldrb	r4, [r7, #6]	@ zero_extendqisi2
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	lsls	r3, r3, #1
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r3, r3, #1
	adds	r2, r3, #1
	ldrb	r4, [r7, #5]	@ zero_extendqisi2
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #8]
	adds	r3, r3, #1
	str	r3, [r7, #8]
.L139:
	ldr	r3, [r7, #8]
	cmp	r3, #22
	ble	.L140
	movs	r3, #31
	str	r3, [r7, #12]
	movs	r3, #23
	str	r3, [r7, #8]
	ldr	r3, [r7, #12]
	lsls	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r2, r3, #1
	movw	r3, #:lower16:Cb
	movt	r3, #:upper16:Cb
	ldr	r0, [r7, #12]
	movs	r4, #24
	mul	r0, r4, r0
	add	r0, r0, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r0
	ldrb	r4, [r3]	@ zero_extendqisi2
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	lsls	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r3, r3, #1
	adds	r2, r3, #1
	movw	r3, #:lower16:Cb
	movt	r3, #:upper16:Cb
	ldr	r0, [r7, #12]
	movs	r4, #24
	mul	r0, r4, r0
	add	r0, r0, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r0
	ldrb	r4, [r3]	@ zero_extendqisi2
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	lsls	r3, r3, #1
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r2, r3, #1
	movw	r3, #:lower16:Cb
	movt	r3, #:upper16:Cb
	ldr	r0, [r7, #12]
	movs	r4, #24
	mul	r0, r4, r0
	add	r0, r0, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r0
	ldrb	r4, [r3]	@ zero_extendqisi2
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	lsls	r3, r3, #1
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r3, r3, #1
	adds	r2, r3, #1
	movw	r3, #:lower16:Cb
	movt	r3, #:upper16:Cb
	ldr	r0, [r7, #12]
	movs	r4, #24
	mul	r0, r4, r0
	add	r0, r0, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r0
	ldrb	r4, [r3]	@ zero_extendqisi2
	movw	r3, #:lower16:Cb_temp
	movt	r3, #:upper16:Cb_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	lsls	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r2, r3, #1
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	ldr	r0, [r7, #12]
	movs	r4, #24
	mul	r0, r4, r0
	add	r0, r0, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r0
	ldrb	r4, [r3]	@ zero_extendqisi2
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	lsls	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r3, r3, #1
	adds	r2, r3, #1
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	ldr	r0, [r7, #12]
	movs	r4, #24
	mul	r0, r4, r0
	add	r0, r0, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r0
	ldrb	r4, [r3]	@ zero_extendqisi2
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	lsls	r3, r3, #1
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r2, r3, #1
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	ldr	r0, [r7, #12]
	movs	r4, #24
	mul	r0, r4, r0
	add	r0, r0, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r0
	ldrb	r4, [r3]	@ zero_extendqisi2
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	lsls	r3, r3, #1
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	lsls	r3, r3, #1
	adds	r2, r3, #1
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	ldr	r0, [r7, #12]
	movs	r4, #24
	mul	r0, r4, r0
	add	r0, r0, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r0
	ldrb	r4, [r3]	@ zero_extendqisi2
	movw	r3, #:lower16:Cr_temp
	movt	r3, #:upper16:Cr_temp
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	nop
	adds	r7, r7, #20
	mov	sp, r7
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
	.size	chrominance_array_upsample, .-chrominance_array_upsample
	.align	1
	.global	CSC_YCC_to_RGB
	.syntax unified
	.thumb
	.thumb_func
	.type	CSC_YCC_to_RGB, %function
CSC_YCC_to_RGB:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
	bl	chrominance_array_upsample
	bl	CSC_YCC_to_RGB_neon_v3
	nop
	pop	{r7, pc}
	.size	CSC_YCC_to_RGB, .-CSC_YCC_to_RGB
	.ident	"GCC: (Arm GNU Toolchain 15.3.Rel1 (Build arm-15.149)) 15.3.1 20260627"
	.section	.note.GNU-stack,"",%progbits
