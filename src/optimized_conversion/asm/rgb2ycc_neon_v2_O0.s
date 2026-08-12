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
	.file	"CSC_RGB_to_YCC.c"
	.text
	.local	lut_Y_R
	.comm	lut_Y_R,1024,4
	.local	lut_Y_G
	.comm	lut_Y_G,1024,4
	.local	lut_Y_B
	.comm	lut_Y_B,1024,4
	.local	lut_Cb_R
	.comm	lut_Cb_R,1024,4
	.local	lut_Cb_G
	.comm	lut_Cb_G,1024,4
	.local	lut_Cb_B
	.comm	lut_Cb_B,1024,4
	.local	lut_Cr_R
	.comm	lut_Cr_R,1024,4
	.local	lut_Cr_G
	.comm	lut_Cr_G,1024,4
	.local	lut_Cr_B
	.comm	lut_Cr_B,1024,4
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.type	CSC_RGB_to_YCC_brute_force_float, %function
CSC_RGB_to_YCC_brute_force_float:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r5, r7, lr}
	sub	sp, sp, #24
	add	r7, sp, #0
	str	r0, [r7, #12]
	str	r1, [r7, #8]
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	ldr	r2, [r7, #12]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d17, .L2
	vmul.f64	d16, d16, d17
	vmov.f64	d17, #1.6e+1
	vadd.f64	d17, d16, d17
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	ldr	r2, [r7, #12]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L2+8
	vmul.f64	d16, d16, d18
	vadd.f64	d17, d17, d16
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	ldr	r2, [r7, #12]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L2+16
	vmul.f64	d16, d16, d18
	vadd.f64	d7, d17, d16
	vcvt.u32.f64	s15, d7
	vstr.32	s15, [r7, #4]	@ int
	ldrb	r3, [r7, #4]
	uxtb	r0, r3
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	ldr	r2, [r7, #12]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	mov	r2, r0
	strb	r2, [r3]
	ldr	r3, [r7, #8]
	adds	r2, r3, #1
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	ldr	r1, [r7, #12]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d17, .L2
	vmul.f64	d16, d16, d17
	vmov.f64	d17, #1.6e+1
	vadd.f64	d17, d16, d17
	ldr	r3, [r7, #8]
	adds	r2, r3, #1
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	ldr	r1, [r7, #12]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L2+8
	vmul.f64	d16, d16, d18
	vadd.f64	d17, d17, d16
	ldr	r3, [r7, #8]
	adds	r2, r3, #1
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	ldr	r1, [r7, #12]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L2+16
	vmul.f64	d16, d16, d18
	vadd.f64	d7, d17, d16
	ldr	r3, [r7, #8]
	adds	r2, r3, #1
	vcvt.u32.f64	s15, d7
	vstr.32	s15, [r7, #4]	@ int
	ldrb	r3, [r7, #4]
	uxtb	r4, r3
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	ldr	r1, [r7, #12]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	adds	r2, r3, #1
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d17, .L2
	vmul.f64	d16, d16, d17
	vmov.f64	d17, #1.6e+1
	vadd.f64	d17, d16, d17
	ldr	r3, [r7, #12]
	adds	r2, r3, #1
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L2+8
	vmul.f64	d16, d16, d18
	vadd.f64	d17, d17, d16
	ldr	r3, [r7, #12]
	adds	r2, r3, #1
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L2+16
	vmul.f64	d16, d16, d18
	vadd.f64	d7, d17, d16
	ldr	r3, [r7, #12]
	adds	r2, r3, #1
	vcvt.u32.f64	s15, d7
	vstr.32	s15, [r7, #4]	@ int
	ldrb	r3, [r7, #4]
	uxtb	r0, r3
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	mov	r2, r0
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	adds	r2, r3, #1
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d17, .L2
	vmul.f64	d16, d16, d17
	vmov.f64	d17, #1.6e+1
	vadd.f64	d17, d16, d17
	ldr	r3, [r7, #12]
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	adds	r2, r3, #1
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L2+8
	vmul.f64	d16, d16, d18
	vadd.f64	d17, d17, d16
	ldr	r3, [r7, #12]
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	adds	r2, r3, #1
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L2+16
	vmul.f64	d16, d16, d18
	vadd.f64	d7, d17, d16
	ldr	r3, [r7, #12]
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	adds	r2, r3, #1
	vcvt.u32.f64	s15, d7
	vstr.32	s15, [r7, #4]	@ int
	ldrb	r3, [r7, #4]
	uxtb	r4, r3
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	ldr	r2, [r7, #12]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d17, .L2+24
	vmul.f64	d16, d16, d17
	vldr.64	d17, .L2+48
	vsub.f64	d17, d17, d16
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	ldr	r2, [r7, #12]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L2+32
	vmul.f64	d16, d16, d18
	vsub.f64	d17, d17, d16
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	ldr	r2, [r7, #12]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L2+40
	vmul.f64	d16, d16, d18
	vadd.f64	d7, d17, d16
	vcvt.u32.f64	s15, d7
	vstr.32	s15, [r7, #4]	@ int
	ldrb	r3, [r7, #4]
	strb	r3, [r7, #23]
	ldr	r3, [r7, #8]
	adds	r2, r3, #1
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	ldr	r1, [r7, #12]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d17, .L2+24
	vmul.f64	d16, d16, d17
	vldr.64	d17, .L2+48
	vsub.f64	d17, d17, d16
	ldr	r3, [r7, #8]
	b	.L3
.L4:
	.align	3
.L2:
	.word	549755814
	.word	1070625456
	.word	-1683627180
	.word	1071653060
	.word	721554506
	.word	1069094535
	.word	-68719477
	.word	1069740457
	.word	1992864825
	.word	1070768062
	.word	1958505087
	.word	1071388819
	.word	0
	.word	1080033280
	.word	-549755814
	.word	1071091023
	.word	1443109011
	.word	1068641550
.L3:
	adds	r2, r3, #1
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	ldr	r1, [r7, #12]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L2+32
	vmul.f64	d16, d16, d18
	vsub.f64	d17, d17, d16
	ldr	r3, [r7, #8]
	adds	r2, r3, #1
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	ldr	r1, [r7, #12]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L2+40
	vmul.f64	d16, d16, d18
	vadd.f64	d7, d17, d16
	vcvt.u32.f64	s15, d7
	vstr.32	s15, [r7, #4]	@ int
	ldrb	r3, [r7, #4]
	strb	r3, [r7, #22]
	ldr	r3, [r7, #12]
	adds	r2, r3, #1
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d17, .L2+24
	vmul.f64	d16, d16, d17
	vldr.64	d17, .L2+48
	vsub.f64	d17, d17, d16
	ldr	r3, [r7, #12]
	adds	r2, r3, #1
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L2+32
	vmul.f64	d16, d16, d18
	vsub.f64	d17, d17, d16
	ldr	r3, [r7, #12]
	adds	r2, r3, #1
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L2+40
	vmul.f64	d16, d16, d18
	vadd.f64	d7, d17, d16
	vcvt.u32.f64	s15, d7
	vstr.32	s15, [r7, #4]	@ int
	ldrb	r3, [r7, #4]
	strb	r3, [r7, #21]
	ldr	r3, [r7, #12]
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	adds	r2, r3, #1
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d17, .L2+24
	vmul.f64	d16, d16, d17
	vldr.64	d17, .L2+48
	vsub.f64	d17, d17, d16
	ldr	r3, [r7, #12]
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	adds	r2, r3, #1
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L2+32
	vmul.f64	d16, d16, d18
	vsub.f64	d17, d17, d16
	ldr	r3, [r7, #12]
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	adds	r2, r3, #1
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L2+40
	vmul.f64	d16, d16, d18
	vadd.f64	d7, d17, d16
	vcvt.u32.f64	s15, d7
	vstr.32	s15, [r7, #4]	@ int
	ldrb	r3, [r7, #4]
	strb	r3, [r7, #20]
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	ldr	r2, [r7, #12]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d17, .L2+40
	vmul.f64	d16, d16, d17
	vldr.64	d17, .L2+48
	vadd.f64	d17, d16, d17
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	ldr	r2, [r7, #12]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L2+56
	vmul.f64	d16, d16, d18
	vsub.f64	d17, d17, d16
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	ldr	r2, [r7, #12]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L2+64
	vmul.f64	d16, d16, d18
	vsub.f64	d7, d17, d16
	vcvt.u32.f64	s15, d7
	vstr.32	s15, [r7, #4]	@ int
	ldrb	r3, [r7, #4]
	strb	r3, [r7, #19]
	ldr	r3, [r7, #8]
	adds	r2, r3, #1
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	ldr	r1, [r7, #12]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d17, .L2+40
	vmul.f64	d16, d16, d17
	vldr.64	d17, .L2+48
	vadd.f64	d17, d16, d17
	ldr	r3, [r7, #8]
	adds	r2, r3, #1
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	ldr	r1, [r7, #12]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L2+56
	vmul.f64	d16, d16, d18
	vsub.f64	d17, d17, d16
	ldr	r3, [r7, #8]
	adds	r2, r3, #1
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	ldr	r1, [r7, #12]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L2+64
	vmul.f64	d16, d16, d18
	vsub.f64	d7, d17, d16
	vcvt.u32.f64	s15, d7
	vstr.32	s15, [r7, #4]	@ int
	ldrb	r3, [r7, #4]
	strb	r3, [r7, #18]
	ldr	r3, [r7, #12]
	adds	r2, r3, #1
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d17, .L2+40
	vmul.f64	d16, d16, d17
	vldr.64	d17, .L2+48
	vadd.f64	d17, d16, d17
	ldr	r3, [r7, #12]
	adds	r2, r3, #1
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L2+56
	vmul.f64	d16, d16, d18
	vsub.f64	d17, d17, d16
	ldr	r3, [r7, #12]
	adds	r2, r3, #1
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7, #8]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L2+64
	vmul.f64	d16, d16, d18
	vsub.f64	d7, d17, d16
	vcvt.u32.f64	s15, d7
	vstr.32	s15, [r7, #4]	@ int
	ldrb	r3, [r7, #4]
	strb	r3, [r7, #17]
	ldr	r3, [r7, #12]
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	adds	r2, r3, #1
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d17, .L5
	vmul.f64	d16, d16, d17
	vldr.64	d17, .L5+8
	vadd.f64	d17, d16, d17
	ldr	r3, [r7, #12]
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	adds	r2, r3, #1
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L5+16
	vmul.f64	d16, d16, d18
	vsub.f64	d17, d17, d16
	ldr	r3, [r7, #12]
	adds	r1, r3, #1
	ldr	r3, [r7, #8]
	adds	r2, r3, #1
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	vmov	s15, r3	@ int
	vcvt.f64.s32	d16, s15
	vldr.64	d18, .L5+24
	vmul.f64	d16, d16, d18
	vsub.f64	d7, d17, d16
	vcvt.u32.f64	s15, d7
	vstr.32	s15, [r7, #4]	@ int
	ldrb	r3, [r7, #4]
	strb	r3, [r7, #16]
	ldr	r3, [r7, #12]
	asrs	r5, r3, #1
	ldr	r3, [r7, #8]
	asrs	r4, r3, #1
	ldrb	r3, [r7, #20]	@ zero_extendqisi2
	ldrb	r2, [r7, #21]	@ zero_extendqisi2
	ldrb	r1, [r7, #22]	@ zero_extendqisi2
	ldrb	r0, [r7, #23]	@ zero_extendqisi2
	bl	chrominance_downsample
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:Cb
	movt	r3, #:upper16:Cb
	movs	r2, #24
	mul	r2, r5, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r1
	strb	r2, [r3]
	ldr	r3, [r7, #12]
	asrs	r5, r3, #1
	ldr	r3, [r7, #8]
	asrs	r4, r3, #1
	ldrb	r3, [r7, #16]	@ zero_extendqisi2
	ldrb	r2, [r7, #17]	@ zero_extendqisi2
	ldrb	r1, [r7, #18]	@ zero_extendqisi2
	ldrb	r0, [r7, #19]	@ zero_extendqisi2
	bl	chrominance_downsample
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	movs	r2, #24
	mul	r2, r5, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r1
	strb	r2, [r3]
	nop
	adds	r7, r7, #24
	mov	sp, r7
	@ sp needed
	pop	{r4, r5, r7, pc}
.L6:
	.align	3
.L5:
	.word	1958505087
	.word	1071388819
	.word	0
	.word	1080033280
	.word	-549755814
	.word	1071091023
	.word	1443109011
	.word	1068641550
	.size	CSC_RGB_to_YCC_brute_force_float, .-CSC_RGB_to_YCC_brute_force_float
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.type	CSC_RGB_to_YCC_brute_force_int, %function
CSC_RGB_to_YCC_brute_force_int:
	@ args = 0, pretend = 0, frame = 104
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}
	sub	sp, sp, #108
	add	r7, sp, #0
	str	r0, [r7, #4]
	str	r1, [r7]
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
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
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	ldr	r1, [r7, #4]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #96]
	ldr	r3, [r7, #4]
	adds	r2, r3, #1
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
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
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #88]
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
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
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	ldr	r1, [r7, #4]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #80]
	ldr	r3, [r7, #4]
	adds	r2, r3, #1
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
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
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #72]
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
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
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	ldr	r1, [r7, #4]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #64]
	ldr	r3, [r7, #4]
	adds	r2, r3, #1
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
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
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #56]
	ldr	r3, [r7, #100]
	movs	r2, #66
	mul	r3, r2, r3
	add	r1, r3, #4096
	ldr	r2, [r7, #84]
	mov	r3, r2
	lsls	r3, r3, #7
	add	r3, r3, r2
	adds	r2, r1, r3
	ldr	r3, [r7, #68]
	movs	r1, #25
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
	movs	r2, #66
	mul	r3, r2, r3
	add	r1, r3, #4096
	ldr	r2, [r7, #80]
	mov	r3, r2
	lsls	r3, r3, #7
	add	r3, r3, r2
	adds	r2, r1, r3
	ldr	r3, [r7, #64]
	movs	r1, #25
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
	movs	r2, #66
	mul	r3, r2, r3
	add	r1, r3, #4096
	ldr	r2, [r7, #76]
	mov	r3, r2
	lsls	r3, r3, #7
	add	r3, r3, r2
	adds	r2, r1, r3
	ldr	r3, [r7, #60]
	movs	r1, #25
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
	movs	r2, #66
	mul	r3, r2, r3
	add	r1, r3, #4096
	ldr	r2, [r7, #72]
	mov	r3, r2
	lsls	r3, r3, #7
	add	r3, r3, r2
	adds	r2, r1, r3
	ldr	r3, [r7, #56]
	movs	r1, #25
	mul	r3, r1, r3
	add	r3, r3, r2
	str	r3, [r7, #40]
	ldr	r3, [r7, #40]
	adds	r3, r3, #128
	str	r3, [r7, #40]
	ldr	r3, [r7, #40]
	asrs	r3, r3, #8
	str	r3, [r7, #40]
	ldr	r3, [r7, #52]
	uxtb	r0, r3
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
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
	ldr	r3, [r7, #48]
	uxtb	r4, r3
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	ldr	r1, [r7, #4]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #4]
	adds	r2, r3, #1
	ldr	r3, [r7, #44]
	uxtb	r0, r3
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	mov	r2, r0
	strb	r2, [r3]
	ldr	r3, [r7, #4]
	adds	r1, r3, #1
	ldr	r3, [r7]
	adds	r2, r3, #1
	ldr	r3, [r7, #40]
	uxtb	r4, r3
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	ldr	r3, [r7, #100]
	mvn	r2, #37
	mul	r3, r2, r3
	add	r2, r3, #32768
	ldr	r3, [r7, #84]
	mvn	r1, #73
	mul	r3, r1, r3
	add	r2, r2, r3
	ldr	r3, [r7, #68]
	movs	r1, #112
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
	mvn	r2, #37
	mul	r3, r2, r3
	add	r2, r3, #32768
	ldr	r3, [r7, #80]
	mvn	r1, #73
	mul	r3, r1, r3
	add	r2, r2, r3
	ldr	r3, [r7, #64]
	movs	r1, #112
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
	mvn	r2, #37
	mul	r3, r2, r3
	add	r2, r3, #32768
	ldr	r3, [r7, #76]
	mvn	r1, #73
	mul	r3, r1, r3
	add	r2, r2, r3
	ldr	r3, [r7, #60]
	movs	r1, #112
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
	mvn	r2, #37
	mul	r3, r2, r3
	add	r2, r3, #32768
	ldr	r3, [r7, #72]
	mvn	r1, #73
	mul	r3, r1, r3
	add	r2, r2, r3
	ldr	r3, [r7, #56]
	movs	r1, #112
	mul	r3, r1, r3
	add	r3, r3, r2
	str	r3, [r7, #24]
	ldr	r3, [r7, #24]
	adds	r3, r3, #128
	str	r3, [r7, #24]
	ldr	r3, [r7, #24]
	asrs	r3, r3, #8
	str	r3, [r7, #24]
	ldr	r3, [r7, #100]
	movs	r2, #112
	mul	r3, r2, r3
	add	r2, r3, #32768
	ldr	r3, [r7, #84]
	mvn	r1, #93
	mul	r3, r1, r3
	add	r2, r2, r3
	ldr	r3, [r7, #68]
	mvn	r1, #17
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
	movs	r2, #112
	mul	r3, r2, r3
	add	r2, r3, #32768
	ldr	r3, [r7, #80]
	mvn	r1, #93
	mul	r3, r1, r3
	add	r2, r2, r3
	ldr	r3, [r7, #64]
	mvn	r1, #17
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
	movs	r2, #112
	mul	r3, r2, r3
	add	r2, r3, #32768
	ldr	r3, [r7, #76]
	mvn	r1, #93
	mul	r3, r1, r3
	add	r2, r2, r3
	ldr	r3, [r7, #60]
	mvn	r1, #17
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
	movs	r2, #112
	mul	r3, r2, r3
	add	r2, r3, #32768
	ldr	r3, [r7, #72]
	mvn	r1, #93
	mul	r3, r1, r3
	add	r2, r2, r3
	ldr	r3, [r7, #56]
	mvn	r1, #17
	mul	r3, r1, r3
	add	r3, r3, r2
	str	r3, [r7, #8]
	ldr	r3, [r7, #8]
	adds	r3, r3, #128
	str	r3, [r7, #8]
	ldr	r3, [r7, #8]
	asrs	r3, r3, #8
	str	r3, [r7, #8]
	ldr	r3, [r7, #36]
	uxtb	r0, r3
	ldr	r3, [r7, #32]
	uxtb	r1, r3
	ldr	r3, [r7, #28]
	uxtb	r2, r3
	ldr	r3, [r7, #24]
	uxtb	r6, r3
	ldr	r3, [r7, #4]
	asrs	r5, r3, #1
	ldr	r3, [r7]
	asrs	r4, r3, #1
	mov	r3, r6
	bl	chrominance_downsample
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:Cb
	movt	r3, #:upper16:Cb
	movs	r2, #24
	mul	r2, r5, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r1
	strb	r2, [r3]
	ldr	r3, [r7, #20]
	uxtb	r0, r3
	ldr	r3, [r7, #16]
	uxtb	r1, r3
	ldr	r3, [r7, #12]
	uxtb	r2, r3
	ldr	r3, [r7, #8]
	uxtb	r6, r3
	ldr	r3, [r7, #4]
	asrs	r5, r3, #1
	ldr	r3, [r7]
	asrs	r4, r3, #1
	mov	r3, r6
	bl	chrominance_downsample
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	movs	r2, #24
	mul	r2, r5, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r1
	strb	r2, [r3]
	nop
	adds	r7, r7, #108
	mov	sp, r7
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
	.size	CSC_RGB_to_YCC_brute_force_int, .-CSC_RGB_to_YCC_brute_force_int
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.type	CSC_RGB_to_YCC_neon, %function
CSC_RGB_to_YCC_neon:
	@ args = 0, pretend = 0, frame = 800
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}
	vpush.64	{d8}
	sub	sp, sp, #804
	add	r7, sp, #0
	add	r3, r7, #800
	sub	r3, r3, #700
	str	r0, [r3]
	add	r3, r7, #800
	sub	r3, r3, #704
	str	r1, [r3]
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	add	r2, r7, #800
	sub	r2, r2, #700
	ldr	r2, [r2]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	add	r3, r7, #800
	sub	r3, r3, #704
	ldr	r3, [r3]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r6, r3
	add	r3, r7, #800
	sub	r3, r3, #704
	ldr	r3, [r3]
	adds	r2, r3, #1
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	add	r1, r7, #800
	sub	r1, r1, #700
	ldr	r1, [r1]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r5, r3
	add	r3, r7, #800
	sub	r3, r3, #700
	ldr	r3, [r3]
	adds	r2, r3, #1
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	add	r3, r7, #800
	sub	r3, r3, #704
	ldr	r3, [r3]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r4, r3
	add	r3, r7, #800
	sub	r3, r3, #700
	ldr	r3, [r3]
	adds	r1, r3, #1
	add	r3, r7, #800
	sub	r3, r3, #704
	ldr	r3, [r3]
	adds	r2, r3, #1
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r2, r3
	add	r3, r7, #800
	sub	r3, r3, #720
	str	r6, [r3]
	add	r3, r7, #800
	sub	r3, r3, #716
	str	r5, [r3]
	add	r3, r7, #800
	sub	r3, r3, #712
	str	r4, [r3]
	add	r3, r7, #800
	sub	r3, r3, #708
	str	r2, [r3]
	vldr	d16, [r7, #80]
	vldr	d17, [r7, #88]
	vstr	d16, [r7, #784]
	vstr	d17, [r7, #792]
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	add	r2, r7, #800
	sub	r2, r2, #700
	ldr	r2, [r2]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	add	r3, r7, #800
	sub	r3, r3, #704
	ldr	r3, [r3]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r6, r3
	add	r3, r7, #800
	sub	r3, r3, #704
	ldr	r3, [r3]
	adds	r2, r3, #1
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	add	r1, r7, #800
	sub	r1, r1, #700
	ldr	r1, [r1]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r5, r3
	add	r3, r7, #800
	sub	r3, r3, #700
	ldr	r3, [r3]
	adds	r2, r3, #1
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	add	r3, r7, #800
	sub	r3, r3, #704
	ldr	r3, [r3]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r4, r3
	add	r3, r7, #800
	sub	r3, r3, #700
	ldr	r3, [r3]
	adds	r1, r3, #1
	add	r3, r7, #800
	sub	r3, r3, #704
	ldr	r3, [r3]
	adds	r2, r3, #1
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r2, r3
	add	r3, r7, #800
	sub	r3, r3, #736
	str	r6, [r3]
	add	r3, r7, #800
	sub	r3, r3, #732
	str	r5, [r3]
	add	r3, r7, #800
	sub	r3, r3, #728
	str	r4, [r3]
	add	r3, r7, #800
	sub	r3, r3, #724
	str	r2, [r3]
	vldr	d16, [r7, #64]
	vldr	d17, [r7, #72]
	vstr	d16, [r7, #768]
	vstr	d17, [r7, #776]
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	add	r2, r7, #800
	sub	r2, r2, #700
	ldr	r2, [r2]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	add	r3, r7, #800
	sub	r3, r3, #704
	ldr	r3, [r3]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r6, r3
	add	r3, r7, #800
	sub	r3, r3, #704
	ldr	r3, [r3]
	adds	r2, r3, #1
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	add	r1, r7, #800
	sub	r1, r1, #700
	ldr	r1, [r1]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r5, r3
	add	r3, r7, #800
	sub	r3, r3, #700
	ldr	r3, [r3]
	adds	r2, r3, #1
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	add	r3, r7, #800
	sub	r3, r3, #704
	ldr	r3, [r3]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r4, r3
	add	r3, r7, #800
	sub	r3, r3, #700
	ldr	r3, [r3]
	adds	r1, r3, #1
	add	r3, r7, #800
	sub	r3, r3, #704
	ldr	r3, [r3]
	adds	r2, r3, #1
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r2, r3
	add	r3, r7, #800
	sub	r3, r3, #752
	str	r6, [r3]
	add	r3, r7, #800
	sub	r3, r3, #748
	str	r5, [r3]
	add	r3, r7, #800
	sub	r3, r3, #744
	str	r4, [r3]
	add	r3, r7, #800
	sub	r3, r3, #740
	str	r2, [r3]
	vldr	d16, [r7, #48]
	vldr	d17, [r7, #56]
	vstr	d16, [r7, #752]
	vstr	d17, [r7, #760]
	add	r3, r7, #800
	sub	r3, r3, #696
	mov	r2, #4224
	str	r2, [r3]
	add	r3, r7, #800
	sub	r4, r3, #696
	add	r3, r7, #800
	sub	r0, r3, #696
	add	r3, r7, #800
	sub	r1, r3, #696
	add	r3, r7, #800
	sub	r2, r3, #696
	add	r3, r7, #800
	sub	r3, r3, #768
	ldr	r4, [r4]
	str	r4, [r3]
	add	r3, r7, #800
	sub	r3, r3, #764
	ldr	r0, [r0]
	str	r0, [r3]
	add	r3, r7, #800
	sub	r3, r3, #760
	ldr	r1, [r1]
	str	r1, [r3]
	add	r3, r7, #800
	sub	r3, r3, #756
	ldr	r2, [r2]
	str	r2, [r3]
	vldr	d16, [r7, #32]
	vldr	d17, [r7, #40]
	vstr	d16, [r7, #736]
	vstr	d17, [r7, #744]
	vldr	d16, [r7, #736]
	vldr	d17, [r7, #744]
	vstr	d16, [r7, #128]
	vstr	d17, [r7, #136]
	vldr	d16, [r7, #784]
	vldr	d17, [r7, #792]
	vstr	d16, [r7, #112]
	vstr	d17, [r7, #120]
	add	r3, r7, #800
	sub	r3, r3, #692
	movs	r2, #66
	str	r2, [r3]
	vldr	d16, [r7, #128]
	vldr	d17, [r7, #136]
	vldr	d18, [r7, #112]
	vldr	d19, [r7, #120]
	add	r3, r7, #800
	sub	r3, r3, #692
	ldr	r3, [r3]
	vmov.32	d8[0], r3
	vmla.i32	q8, q9, d8[0]
	vstr	d16, [r7, #736]
	vstr	d17, [r7, #744]
	vldr	d16, [r7, #736]
	vldr	d17, [r7, #744]
	vstr	d16, [r7, #168]
	vstr	d17, [r7, #176]
	vldr	d16, [r7, #768]
	vldr	d17, [r7, #776]
	vstr	d16, [r7, #152]
	vstr	d17, [r7, #160]
	add	r3, r7, #800
	sub	r3, r3, #652
	movs	r2, #129
	str	r2, [r3]
	vldr	d16, [r7, #168]
	vldr	d17, [r7, #176]
	vldr	d18, [r7, #152]
	vldr	d19, [r7, #160]
	add	r3, r7, #800
	sub	r3, r3, #652
	ldr	r3, [r3]
	vmov.32	d0[0], r3
	vmla.i32	q8, q9, d0[0]
	vstr	d16, [r7, #736]
	vstr	d17, [r7, #744]
	vldr	d16, [r7, #736]
	vldr	d17, [r7, #744]
	vstr	d16, [r7, #208]
	vstr	d17, [r7, #216]
	vldr	d16, [r7, #752]
	vldr	d17, [r7, #760]
	vstr	d16, [r7, #192]
	vstr	d17, [r7, #200]
	add	r3, r7, #800
	sub	r3, r3, #612
	movs	r2, #25
	str	r2, [r3]
	vldr	d16, [r7, #208]
	vldr	d17, [r7, #216]
	vldr	d18, [r7, #192]
	vldr	d19, [r7, #200]
	add	r3, r7, #800
	sub	r3, r3, #612
	ldr	r3, [r3]
	vmov.32	d1[0], r3
	vmla.i32	q8, q9, d1[0]
	vstr	d16, [r7, #736]
	vstr	d17, [r7, #744]
	vldr	d16, [r7, #736]
	vldr	d17, [r7, #744]
	vstr	d16, [r7, #224]
	vstr	d17, [r7, #232]
	vldr	d16, [r7, #224]
	vldr	d17, [r7, #232]
	vshr.s32	q8, q8, #8
	vstr	d16, [r7, #736]
	vstr	d17, [r7, #744]
	vldr	d16, [r7, #736]
	vldr	d17, [r7, #744]
	vstr	d16, [r7, #240]
	vstr	d17, [r7, #248]
	vldr	d16, [r7, #240]
	vldr	d17, [r7, #248]
	vmov.32	r3, d16[0]
	uxtb	r0, r3
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	add	r2, r7, #800
	sub	r2, r2, #700
	ldr	r2, [r2]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	add	r3, r7, #800
	sub	r3, r3, #704
	ldr	r3, [r3]
	add	r3, r3, r2
	mov	r2, r0
	strb	r2, [r3]
	vldr	d16, [r7, #736]
	vldr	d17, [r7, #744]
	vstr	d16, [r7, #256]
	vstr	d17, [r7, #264]
	vldr	d16, [r7, #256]
	vldr	d17, [r7, #264]
	vmov.32	r1, d16[1]
	add	r3, r7, #800
	sub	r3, r3, #704
	ldr	r3, [r3]
	adds	r2, r3, #1
	uxtb	r4, r1
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	add	r1, r7, #800
	sub	r1, r1, #700
	ldr	r1, [r1]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	vldr	d16, [r7, #736]
	vldr	d17, [r7, #744]
	vstr	d16, [r7, #272]
	vstr	d17, [r7, #280]
	vldr	d16, [r7, #272]
	vldr	d17, [r7, #280]
	vmov.32	r1, d17[0]
	add	r3, r7, #800
	sub	r3, r3, #700
	ldr	r3, [r3]
	adds	r2, r3, #1
	uxtb	r0, r1
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	add	r3, r7, #800
	sub	r3, r3, #704
	ldr	r3, [r3]
	add	r3, r3, r2
	mov	r2, r0
	strb	r2, [r3]
	vldr	d16, [r7, #736]
	vldr	d17, [r7, #744]
	vstr	d16, [r7, #288]
	vstr	d17, [r7, #296]
	vldr	d16, [r7, #288]
	vldr	d17, [r7, #296]
	vmov.32	r0, d17[1]
	add	r3, r7, #800
	sub	r3, r3, #700
	ldr	r3, [r3]
	adds	r1, r3, #1
	add	r3, r7, #800
	sub	r3, r3, #704
	ldr	r3, [r3]
	adds	r2, r3, #1
	uxtb	r4, r0
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	add	r3, r7, #800
	sub	r3, r3, #496
	movw	r2, #32896
	str	r2, [r3]
	add	r3, r7, #800
	sub	r4, r3, #496
	add	r3, r7, #800
	sub	r0, r3, #496
	add	r3, r7, #800
	sub	r1, r3, #496
	add	r3, r7, #800
	sub	r2, r3, #496
	add	r3, r7, #800
	sub	r3, r3, #784
	ldr	r4, [r4]
	str	r4, [r3]
	add	r3, r7, #800
	sub	r3, r3, #780
	ldr	r0, [r0]
	str	r0, [r3]
	add	r3, r7, #800
	sub	r3, r3, #776
	ldr	r1, [r1]
	str	r1, [r3]
	add	r3, r7, #800
	sub	r3, r3, #772
	ldr	r2, [r2]
	str	r2, [r3]
	vldr	d16, [r7, #16]
	vldr	d17, [r7, #24]
	vstr	d16, [r7, #720]
	vstr	d17, [r7, #728]
	vldr	d16, [r7, #720]
	vldr	d17, [r7, #728]
	vstr	d16, [r7, #328]
	vstr	d17, [r7, #336]
	vldr	d16, [r7, #784]
	vldr	d17, [r7, #792]
	vstr	d16, [r7, #312]
	vstr	d17, [r7, #320]
	add	r3, r7, #800
	sub	r3, r3, #492
	movs	r2, #38
	str	r2, [r3]
	vldr	d16, [r7, #328]
	vldr	d17, [r7, #336]
	vldr	d18, [r7, #312]
	vldr	d19, [r7, #320]
	add	r3, r7, #800
	sub	r3, r3, #492
	ldr	r3, [r3]
	vmov.32	d2[0], r3
	vmls.i32	q8, q9, d2[0]
	vstr	d16, [r7, #720]
	vstr	d17, [r7, #728]
	vldr	d16, [r7, #720]
	vldr	d17, [r7, #728]
	vstr	d16, [r7, #368]
	vstr	d17, [r7, #376]
	vldr	d16, [r7, #768]
	vldr	d17, [r7, #776]
	vstr	d16, [r7, #352]
	vstr	d17, [r7, #360]
	add	r3, r7, #800
	sub	r3, r3, #452
	movs	r2, #74
	str	r2, [r3]
	vldr	d16, [r7, #368]
	vldr	d17, [r7, #376]
	vldr	d18, [r7, #352]
	vldr	d19, [r7, #360]
	add	r3, r7, #800
	sub	r3, r3, #452
	ldr	r3, [r3]
	vmov.32	d3[0], r3
	vmls.i32	q8, q9, d3[0]
	vstr	d16, [r7, #720]
	vstr	d17, [r7, #728]
	vldr	d16, [r7, #720]
	vldr	d17, [r7, #728]
	vstr	d16, [r7, #408]
	vstr	d17, [r7, #416]
	vldr	d16, [r7, #752]
	vldr	d17, [r7, #760]
	vstr	d16, [r7, #392]
	vstr	d17, [r7, #400]
	add	r3, r7, #800
	sub	r3, r3, #412
	movs	r2, #112
	str	r2, [r3]
	vldr	d16, [r7, #408]
	vldr	d17, [r7, #416]
	vldr	d18, [r7, #392]
	vldr	d19, [r7, #400]
	add	r3, r7, #800
	sub	r3, r3, #412
	ldr	r3, [r3]
	vmov.32	d4[0], r3
	vmla.i32	q8, q9, d4[0]
	vstr	d16, [r7, #720]
	vstr	d17, [r7, #728]
	vldr	d16, [r7, #720]
	vldr	d17, [r7, #728]
	vstr	d16, [r7, #424]
	vstr	d17, [r7, #432]
	vldr	d16, [r7, #424]
	vldr	d17, [r7, #432]
	vshr.s32	q8, q8, #8
	vstr	d16, [r7, #720]
	vstr	d17, [r7, #728]
	add	r3, r7, #800
	sub	r3, r3, #360
	movw	r2, #32896
	str	r2, [r3]
	add	r3, r7, #800
	sub	r4, r3, #360
	add	r3, r7, #800
	sub	r0, r3, #360
	add	r3, r7, #800
	sub	r1, r3, #360
	add	r3, r7, #800
	sub	r2, r3, #360
	add	r3, r7, #800
	sub	r3, r3, #800
	ldr	r4, [r4]
	str	r4, [r3]
	add	r3, r7, #800
	sub	r3, r3, #796
	ldr	r0, [r0]
	str	r0, [r3]
	add	r3, r7, #800
	sub	r3, r3, #792
	ldr	r1, [r1]
	str	r1, [r3]
	add	r3, r7, #800
	sub	r3, r3, #788
	ldr	r2, [r2]
	str	r2, [r3]
	vld1.64	{d16-d17}, [r7:64]
	vstr	d16, [r7, #704]
	vstr	d17, [r7, #712]
	vldr	d16, [r7, #704]
	vldr	d17, [r7, #712]
	vstr	d16, [r7, #464]
	vstr	d17, [r7, #472]
	vldr	d16, [r7, #784]
	vldr	d17, [r7, #792]
	vstr	d16, [r7, #448]
	vstr	d17, [r7, #456]
	add	r3, r7, #800
	sub	r3, r3, #356
	movs	r2, #112
	str	r2, [r3]
	vldr	d16, [r7, #464]
	vldr	d17, [r7, #472]
	vldr	d18, [r7, #448]
	vldr	d19, [r7, #456]
	add	r3, r7, #800
	sub	r3, r3, #356
	ldr	r3, [r3]
	vmov.32	d5[0], r3
	vmla.i32	q8, q9, d5[0]
	vstr	d16, [r7, #704]
	vstr	d17, [r7, #712]
	vldr	d16, [r7, #704]
	vldr	d17, [r7, #712]
	vstr	d16, [r7, #504]
	vstr	d17, [r7, #512]
	vldr	d16, [r7, #768]
	vldr	d17, [r7, #776]
	vstr	d16, [r7, #488]
	vstr	d17, [r7, #496]
	add	r3, r7, #800
	sub	r3, r3, #316
	movs	r2, #94
	str	r2, [r3]
	vldr	d16, [r7, #504]
	vldr	d17, [r7, #512]
	vldr	d18, [r7, #488]
	vldr	d19, [r7, #496]
	add	r3, r7, #800
	sub	r3, r3, #316
	ldr	r3, [r3]
	vmov.32	d6[0], r3
	vmls.i32	q8, q9, d6[0]
	vstr	d16, [r7, #704]
	vstr	d17, [r7, #712]
	vldr	d16, [r7, #704]
	vldr	d17, [r7, #712]
	vstr	d16, [r7, #544]
	vstr	d17, [r7, #552]
	vldr	d16, [r7, #752]
	vldr	d17, [r7, #760]
	vstr	d16, [r7, #528]
	vstr	d17, [r7, #536]
	add	r3, r7, #800
	sub	r3, r3, #276
	movs	r2, #18
	str	r2, [r3]
	vldr	d16, [r7, #544]
	vldr	d17, [r7, #552]
	vldr	d18, [r7, #528]
	vldr	d19, [r7, #536]
	add	r3, r7, #800
	sub	r3, r3, #276
	ldr	r3, [r3]
	vmov.32	d7[0], r3
	vmls.i32	q8, q9, d7[0]
	vstr	d16, [r7, #704]
	vstr	d17, [r7, #712]
	vldr	d16, [r7, #704]
	vldr	d17, [r7, #712]
	vstr	d16, [r7, #560]
	vstr	d17, [r7, #568]
	vldr	d16, [r7, #560]
	vldr	d17, [r7, #568]
	vshr.s32	q8, q8, #8
	vstr	d16, [r7, #704]
	vstr	d17, [r7, #712]
	vldr	d16, [r7, #720]
	vldr	d17, [r7, #728]
	vstr	d16, [r7, #576]
	vstr	d17, [r7, #584]
	vldr	d16, [r7, #576]
	vldr	d17, [r7, #584]
	vmov.32	r3, d16[0]
	uxtb	r0, r3
	vldr	d16, [r7, #720]
	vldr	d17, [r7, #728]
	vstr	d16, [r7, #592]
	vstr	d17, [r7, #600]
	vldr	d16, [r7, #592]
	vldr	d17, [r7, #600]
	vmov.32	r3, d16[1]
	uxtb	r1, r3
	vldr	d16, [r7, #720]
	vldr	d17, [r7, #728]
	vstr	d16, [r7, #608]
	vstr	d17, [r7, #616]
	vldr	d16, [r7, #608]
	vldr	d17, [r7, #616]
	vmov.32	r3, d17[0]
	uxtb	r2, r3
	vldr	d16, [r7, #720]
	vldr	d17, [r7, #728]
	vstr	d16, [r7, #624]
	vstr	d17, [r7, #632]
	vldr	d16, [r7, #624]
	vldr	d17, [r7, #632]
	vmov.32	r3, d17[1]
	uxtb	r6, r3
	add	r3, r7, #800
	sub	r3, r3, #700
	ldr	r3, [r3]
	asrs	r5, r3, #1
	add	r3, r7, #800
	sub	r3, r3, #704
	ldr	r3, [r3]
	asrs	r4, r3, #1
	mov	r3, r6
	bl	chrominance_downsample
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:Cb
	movt	r3, #:upper16:Cb
	movs	r2, #24
	mul	r2, r5, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r1
	strb	r2, [r3]
	vldr	d16, [r7, #704]
	vldr	d17, [r7, #712]
	vstr	d16, [r7, #640]
	vstr	d17, [r7, #648]
	vldr	d16, [r7, #640]
	vldr	d17, [r7, #648]
	vmov.32	r3, d16[0]
	uxtb	r0, r3
	vldr	d16, [r7, #704]
	vldr	d17, [r7, #712]
	vstr	d16, [r7, #656]
	vstr	d17, [r7, #664]
	vldr	d16, [r7, #656]
	vldr	d17, [r7, #664]
	vmov.32	r3, d16[1]
	uxtb	r1, r3
	vldr	d16, [r7, #704]
	vldr	d17, [r7, #712]
	vstr	d16, [r7, #672]
	vstr	d17, [r7, #680]
	vldr	d16, [r7, #672]
	vldr	d17, [r7, #680]
	vmov.32	r3, d17[0]
	uxtb	r2, r3
	vldr	d16, [r7, #704]
	vldr	d17, [r7, #712]
	vstr	d16, [r7, #688]
	vstr	d17, [r7, #696]
	vldr	d16, [r7, #688]
	vldr	d17, [r7, #696]
	vmov.32	r3, d17[1]
	uxtb	r6, r3
	add	r3, r7, #800
	sub	r3, r3, #700
	ldr	r3, [r3]
	asrs	r5, r3, #1
	add	r3, r7, #800
	sub	r3, r3, #704
	ldr	r3, [r3]
	asrs	r4, r3, #1
	mov	r3, r6
	bl	chrominance_downsample
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	movs	r2, #24
	mul	r2, r5, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r1
	strb	r2, [r3]
	nop
	add	r7, r7, #804
	mov	sp, r7
	@ sp needed
	vldm	sp!, {d8}
	pop	{r4, r5, r6, r7, pc}
	.size	CSC_RGB_to_YCC_neon, .-CSC_RGB_to_YCC_neon
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.type	CSC_RGB_to_YCC_neon_tiled, %function
CSC_RGB_to_YCC_neon_tiled:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	sub	sp, sp, #16
	add	r7, sp, #0
	movs	r3, #0
	str	r3, [r7, #12]
	b	.L37
.L44:
	movs	r3, #0
	str	r3, [r7, #8]
	b	.L38
.L43:
	ldr	r3, [r7, #12]
	str	r3, [r7, #4]
	b	.L39
.L42:
	ldr	r3, [r7, #8]
	str	r3, [r7]
	b	.L40
.L41:
	ldr	r1, [r7]
	ldr	r0, [r7, #4]
	bl	CSC_RGB_to_YCC_neon
	ldr	r3, [r7]
	adds	r3, r3, #2
	str	r3, [r7]
.L40:
	ldr	r3, [r7, #8]
	adds	r3, r3, #15
	ldr	r2, [r7]
	cmp	r2, r3
	ble	.L41
	ldr	r3, [r7, #4]
	adds	r3, r3, #2
	str	r3, [r7, #4]
.L39:
	ldr	r3, [r7, #12]
	adds	r3, r3, #15
	ldr	r2, [r7, #4]
	cmp	r2, r3
	ble	.L42
	ldr	r3, [r7, #8]
	adds	r3, r3, #16
	str	r3, [r7, #8]
.L38:
	ldr	r3, [r7, #8]
	cmp	r3, #47
	ble	.L43
	ldr	r3, [r7, #12]
	adds	r3, r3, #16
	str	r3, [r7, #12]
.L37:
	ldr	r3, [r7, #12]
	cmp	r3, #63
	ble	.L44
	nop
	nop
	adds	r7, r7, #16
	mov	sp, r7
	@ sp needed
	pop	{r7, pc}
	.size	CSC_RGB_to_YCC_neon_tiled, .-CSC_RGB_to_YCC_neon_tiled
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.type	lut_init, %function
lut_init:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7}
	sub	sp, sp, #12
	add	r7, sp, #0
	movs	r3, #0
	str	r3, [r7, #4]
	b	.L46
.L47:
	ldr	r3, [r7, #4]
	movs	r2, #66
	mul	r1, r2, r3
	movw	r3, #:lower16:lut_Y_R
	movt	r3, #:upper16:lut_Y_R
	ldr	r2, [r7, #4]
	str	r1, [r3, r2, lsl #2]
	ldr	r2, [r7, #4]
	mov	r3, r2
	lsls	r3, r3, #7
	adds	r1, r3, r2
	movw	r3, #:lower16:lut_Y_G
	movt	r3, #:upper16:lut_Y_G
	ldr	r2, [r7, #4]
	str	r1, [r3, r2, lsl #2]
	ldr	r3, [r7, #4]
	movs	r2, #25
	mul	r1, r2, r3
	movw	r3, #:lower16:lut_Y_B
	movt	r3, #:upper16:lut_Y_B
	ldr	r2, [r7, #4]
	str	r1, [r3, r2, lsl #2]
	ldr	r3, [r7, #4]
	mvn	r2, #37
	mul	r1, r2, r3
	movw	r3, #:lower16:lut_Cb_R
	movt	r3, #:upper16:lut_Cb_R
	ldr	r2, [r7, #4]
	str	r1, [r3, r2, lsl #2]
	ldr	r3, [r7, #4]
	mvn	r2, #73
	mul	r1, r2, r3
	movw	r3, #:lower16:lut_Cb_G
	movt	r3, #:upper16:lut_Cb_G
	ldr	r2, [r7, #4]
	str	r1, [r3, r2, lsl #2]
	ldr	r3, [r7, #4]
	movs	r2, #112
	mul	r1, r2, r3
	movw	r3, #:lower16:lut_Cb_B
	movt	r3, #:upper16:lut_Cb_B
	ldr	r2, [r7, #4]
	str	r1, [r3, r2, lsl #2]
	ldr	r3, [r7, #4]
	movs	r2, #112
	mul	r1, r2, r3
	movw	r3, #:lower16:lut_Cr_R
	movt	r3, #:upper16:lut_Cr_R
	ldr	r2, [r7, #4]
	str	r1, [r3, r2, lsl #2]
	ldr	r3, [r7, #4]
	mvn	r2, #93
	mul	r1, r2, r3
	movw	r3, #:lower16:lut_Cr_G
	movt	r3, #:upper16:lut_Cr_G
	ldr	r2, [r7, #4]
	str	r1, [r3, r2, lsl #2]
	ldr	r3, [r7, #4]
	mvn	r2, #17
	mul	r1, r2, r3
	movw	r3, #:lower16:lut_Cr_B
	movt	r3, #:upper16:lut_Cr_B
	ldr	r2, [r7, #4]
	str	r1, [r3, r2, lsl #2]
	ldr	r3, [r7, #4]
	adds	r3, r3, #1
	str	r3, [r7, #4]
.L46:
	ldr	r3, [r7, #4]
	cmp	r3, #255
	ble	.L47
	nop
	nop
	adds	r7, r7, #12
	mov	sp, r7
	@ sp needed
	pop	{r7}
	bx	lr
	.size	lut_init, .-lut_init
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.type	CSC_RGB_to_YCC_lut, %function
CSC_RGB_to_YCC_lut:
	@ args = 0, pretend = 0, frame = 72
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r5, r7, lr}
	sub	sp, sp, #72
	add	r7, sp, #0
	str	r0, [r7, #4]
	str	r1, [r7]
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	ldr	r2, [r7, #4]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #68]
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	ldr	r2, [r7, #4]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #64]
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	ldr	r2, [r7, #4]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #60]
	ldr	r3, [r7]
	adds	r2, r3, #1
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	ldr	r1, [r7, #4]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #56]
	ldr	r3, [r7]
	adds	r2, r3, #1
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	ldr	r1, [r7, #4]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #52]
	ldr	r3, [r7]
	adds	r2, r3, #1
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	ldr	r1, [r7, #4]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #48]
	ldr	r3, [r7, #4]
	adds	r2, r3, #1
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #44]
	ldr	r3, [r7, #4]
	adds	r2, r3, #1
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #40]
	ldr	r3, [r7, #4]
	adds	r2, r3, #1
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #36]
	ldr	r3, [r7, #4]
	adds	r1, r3, #1
	ldr	r3, [r7]
	adds	r2, r3, #1
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #32]
	ldr	r3, [r7, #4]
	adds	r1, r3, #1
	ldr	r3, [r7]
	adds	r2, r3, #1
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #28]
	ldr	r3, [r7, #4]
	adds	r1, r3, #1
	ldr	r3, [r7]
	adds	r2, r3, #1
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [r7, #24]
	mov	r3, #4224
	str	r3, [r7, #20]
	movw	r3, #32896
	str	r3, [r7, #16]
	movw	r3, #:lower16:lut_Y_R
	movt	r3, #:upper16:lut_Y_R
	ldr	r2, [r7, #68]
	ldr	r2, [r3, r2, lsl #2]
	ldr	r3, [r7, #20]
	add	r2, r2, r3
	movw	r3, #:lower16:lut_Y_G
	movt	r3, #:upper16:lut_Y_G
	ldr	r1, [r7, #64]
	ldr	r3, [r3, r1, lsl #2]
	add	r2, r2, r3
	movw	r3, #:lower16:lut_Y_B
	movt	r3, #:upper16:lut_Y_B
	ldr	r1, [r7, #60]
	ldr	r3, [r3, r1, lsl #2]
	add	r3, r3, r2
	asrs	r3, r3, #8
	uxtb	r0, r3
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	ldr	r2, [r7, #4]
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	mov	r2, r0
	strb	r2, [r3]
	movw	r3, #:lower16:lut_Y_R
	movt	r3, #:upper16:lut_Y_R
	ldr	r2, [r7, #56]
	ldr	r2, [r3, r2, lsl #2]
	ldr	r3, [r7, #20]
	add	r2, r2, r3
	movw	r3, #:lower16:lut_Y_G
	movt	r3, #:upper16:lut_Y_G
	ldr	r1, [r7, #52]
	ldr	r3, [r3, r1, lsl #2]
	add	r2, r2, r3
	movw	r3, #:lower16:lut_Y_B
	movt	r3, #:upper16:lut_Y_B
	ldr	r1, [r7, #48]
	ldr	r3, [r3, r1, lsl #2]
	add	r3, r3, r2
	asrs	r1, r3, #8
	ldr	r3, [r7]
	adds	r2, r3, #1
	uxtb	r4, r1
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	ldr	r1, [r7, #4]
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	movw	r3, #:lower16:lut_Y_R
	movt	r3, #:upper16:lut_Y_R
	ldr	r2, [r7, #44]
	ldr	r2, [r3, r2, lsl #2]
	ldr	r3, [r7, #20]
	add	r2, r2, r3
	movw	r3, #:lower16:lut_Y_G
	movt	r3, #:upper16:lut_Y_G
	ldr	r1, [r7, #40]
	ldr	r3, [r3, r1, lsl #2]
	add	r2, r2, r3
	movw	r3, #:lower16:lut_Y_B
	movt	r3, #:upper16:lut_Y_B
	ldr	r1, [r7, #36]
	ldr	r3, [r3, r1, lsl #2]
	add	r3, r3, r2
	asrs	r1, r3, #8
	ldr	r3, [r7, #4]
	adds	r2, r3, #1
	uxtb	r0, r1
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	movs	r1, #48
	mul	r2, r1, r2
	add	r2, r2, r3
	ldr	r3, [r7]
	add	r3, r3, r2
	mov	r2, r0
	strb	r2, [r3]
	movw	r3, #:lower16:lut_Y_R
	movt	r3, #:upper16:lut_Y_R
	ldr	r2, [r7, #32]
	ldr	r2, [r3, r2, lsl #2]
	ldr	r3, [r7, #20]
	add	r2, r2, r3
	movw	r3, #:lower16:lut_Y_G
	movt	r3, #:upper16:lut_Y_G
	ldr	r1, [r7, #28]
	ldr	r3, [r3, r1, lsl #2]
	add	r2, r2, r3
	movw	r3, #:lower16:lut_Y_B
	movt	r3, #:upper16:lut_Y_B
	ldr	r1, [r7, #24]
	ldr	r3, [r3, r1, lsl #2]
	add	r3, r3, r2
	asrs	r0, r3, #8
	ldr	r3, [r7, #4]
	adds	r1, r3, #1
	ldr	r3, [r7]
	adds	r2, r3, #1
	uxtb	r4, r0
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	movs	r0, #48
	mul	r1, r0, r1
	add	r3, r3, r1
	add	r3, r3, r2
	mov	r2, r4
	strb	r2, [r3]
	movw	r3, #:lower16:lut_Cb_R
	movt	r3, #:upper16:lut_Cb_R
	ldr	r2, [r7, #68]
	ldr	r2, [r3, r2, lsl #2]
	ldr	r3, [r7, #16]
	add	r2, r2, r3
	movw	r3, #:lower16:lut_Cb_G
	movt	r3, #:upper16:lut_Cb_G
	ldr	r1, [r7, #64]
	ldr	r3, [r3, r1, lsl #2]
	add	r2, r2, r3
	movw	r3, #:lower16:lut_Cb_B
	movt	r3, #:upper16:lut_Cb_B
	ldr	r1, [r7, #60]
	ldr	r3, [r3, r1, lsl #2]
	add	r3, r3, r2
	asrs	r3, r3, #8
	strb	r3, [r7, #15]
	movw	r3, #:lower16:lut_Cb_R
	movt	r3, #:upper16:lut_Cb_R
	ldr	r2, [r7, #56]
	ldr	r2, [r3, r2, lsl #2]
	ldr	r3, [r7, #16]
	add	r2, r2, r3
	movw	r3, #:lower16:lut_Cb_G
	movt	r3, #:upper16:lut_Cb_G
	ldr	r1, [r7, #52]
	ldr	r3, [r3, r1, lsl #2]
	add	r2, r2, r3
	movw	r3, #:lower16:lut_Cb_B
	movt	r3, #:upper16:lut_Cb_B
	ldr	r1, [r7, #48]
	ldr	r3, [r3, r1, lsl #2]
	add	r3, r3, r2
	asrs	r3, r3, #8
	strb	r3, [r7, #14]
	movw	r3, #:lower16:lut_Cb_R
	movt	r3, #:upper16:lut_Cb_R
	ldr	r2, [r7, #44]
	ldr	r2, [r3, r2, lsl #2]
	ldr	r3, [r7, #16]
	add	r2, r2, r3
	movw	r3, #:lower16:lut_Cb_G
	movt	r3, #:upper16:lut_Cb_G
	ldr	r1, [r7, #40]
	ldr	r3, [r3, r1, lsl #2]
	add	r2, r2, r3
	movw	r3, #:lower16:lut_Cb_B
	movt	r3, #:upper16:lut_Cb_B
	ldr	r1, [r7, #36]
	ldr	r3, [r3, r1, lsl #2]
	add	r3, r3, r2
	asrs	r3, r3, #8
	strb	r3, [r7, #13]
	movw	r3, #:lower16:lut_Cb_R
	movt	r3, #:upper16:lut_Cb_R
	ldr	r2, [r7, #32]
	ldr	r2, [r3, r2, lsl #2]
	ldr	r3, [r7, #16]
	add	r2, r2, r3
	movw	r3, #:lower16:lut_Cb_G
	movt	r3, #:upper16:lut_Cb_G
	ldr	r1, [r7, #28]
	ldr	r3, [r3, r1, lsl #2]
	add	r2, r2, r3
	movw	r3, #:lower16:lut_Cb_B
	movt	r3, #:upper16:lut_Cb_B
	ldr	r1, [r7, #24]
	ldr	r3, [r3, r1, lsl #2]
	add	r3, r3, r2
	asrs	r3, r3, #8
	strb	r3, [r7, #12]
	movw	r3, #:lower16:lut_Cr_R
	movt	r3, #:upper16:lut_Cr_R
	ldr	r2, [r7, #68]
	ldr	r2, [r3, r2, lsl #2]
	ldr	r3, [r7, #16]
	add	r2, r2, r3
	movw	r3, #:lower16:lut_Cr_G
	movt	r3, #:upper16:lut_Cr_G
	ldr	r1, [r7, #64]
	ldr	r3, [r3, r1, lsl #2]
	add	r2, r2, r3
	movw	r3, #:lower16:lut_Cr_B
	movt	r3, #:upper16:lut_Cr_B
	ldr	r1, [r7, #60]
	ldr	r3, [r3, r1, lsl #2]
	add	r3, r3, r2
	asrs	r3, r3, #8
	strb	r3, [r7, #11]
	movw	r3, #:lower16:lut_Cr_R
	movt	r3, #:upper16:lut_Cr_R
	ldr	r2, [r7, #56]
	ldr	r2, [r3, r2, lsl #2]
	ldr	r3, [r7, #16]
	add	r2, r2, r3
	movw	r3, #:lower16:lut_Cr_G
	movt	r3, #:upper16:lut_Cr_G
	ldr	r1, [r7, #52]
	ldr	r3, [r3, r1, lsl #2]
	add	r2, r2, r3
	movw	r3, #:lower16:lut_Cr_B
	movt	r3, #:upper16:lut_Cr_B
	ldr	r1, [r7, #48]
	ldr	r3, [r3, r1, lsl #2]
	add	r3, r3, r2
	asrs	r3, r3, #8
	strb	r3, [r7, #10]
	movw	r3, #:lower16:lut_Cr_R
	movt	r3, #:upper16:lut_Cr_R
	ldr	r2, [r7, #44]
	ldr	r2, [r3, r2, lsl #2]
	ldr	r3, [r7, #16]
	add	r2, r2, r3
	movw	r3, #:lower16:lut_Cr_G
	movt	r3, #:upper16:lut_Cr_G
	ldr	r1, [r7, #40]
	ldr	r3, [r3, r1, lsl #2]
	add	r2, r2, r3
	movw	r3, #:lower16:lut_Cr_B
	movt	r3, #:upper16:lut_Cr_B
	ldr	r1, [r7, #36]
	ldr	r3, [r3, r1, lsl #2]
	add	r3, r3, r2
	asrs	r3, r3, #8
	strb	r3, [r7, #9]
	movw	r3, #:lower16:lut_Cr_R
	movt	r3, #:upper16:lut_Cr_R
	ldr	r2, [r7, #32]
	ldr	r2, [r3, r2, lsl #2]
	ldr	r3, [r7, #16]
	add	r2, r2, r3
	movw	r3, #:lower16:lut_Cr_G
	movt	r3, #:upper16:lut_Cr_G
	ldr	r1, [r7, #28]
	ldr	r3, [r3, r1, lsl #2]
	add	r2, r2, r3
	movw	r3, #:lower16:lut_Cr_B
	movt	r3, #:upper16:lut_Cr_B
	ldr	r1, [r7, #24]
	ldr	r3, [r3, r1, lsl #2]
	add	r3, r3, r2
	asrs	r3, r3, #8
	strb	r3, [r7, #8]
	ldr	r3, [r7, #4]
	asrs	r5, r3, #1
	ldr	r3, [r7]
	asrs	r4, r3, #1
	ldrb	r3, [r7, #12]	@ zero_extendqisi2
	ldrb	r2, [r7, #13]	@ zero_extendqisi2
	ldrb	r1, [r7, #14]	@ zero_extendqisi2
	ldrb	r0, [r7, #15]	@ zero_extendqisi2
	bl	chrominance_downsample
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:Cb
	movt	r3, #:upper16:Cb
	movs	r2, #24
	mul	r2, r5, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r1
	strb	r2, [r3]
	ldr	r3, [r7, #4]
	asrs	r5, r3, #1
	ldr	r3, [r7]
	asrs	r4, r3, #1
	ldrb	r3, [r7, #8]	@ zero_extendqisi2
	ldrb	r2, [r7, #9]	@ zero_extendqisi2
	ldrb	r1, [r7, #10]	@ zero_extendqisi2
	ldrb	r0, [r7, #11]	@ zero_extendqisi2
	bl	chrominance_downsample
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	movs	r2, #24
	mul	r2, r5, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r1
	strb	r2, [r3]
	nop
	adds	r7, r7, #72
	mov	sp, r7
	@ sp needed
	pop	{r4, r5, r7, pc}
	.size	CSC_RGB_to_YCC_lut, .-CSC_RGB_to_YCC_lut
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.type	CSC_RGB_to_YCC_neon_v2, %function
CSC_RGB_to_YCC_neon_v2:
	@ args = 0, pretend = 0, frame = 1776
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, lr}
	subw	sp, sp, #1780
	add	r7, sp, #0
	movs	r3, #0
	str	r3, [r7, #1772]
	b	.L50
.L133:
	movs	r3, #0
	str	r3, [r7, #1768]
	b	.L51
.L132:
	ldr	r3, [r7, #1772]
	movs	r2, #48
	mul	r2, r3, r2
	ldr	r3, [r7, #1768]
	add	r2, r2, r3
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	add	r2, r2, r3
	add	r3, r7, #1776
	sub	r3, r3, #1536
	str	r2, [r3]
	add	r3, r7, #1776
	sub	r3, r3, #1536
	ldr	r3, [r3]
	vld1.8	{d16}, [r3]
	add	r3, r7, #1760
	vstr	d16, [r3]
	ldr	r3, [r7, #1772]
	movs	r2, #48
	mul	r2, r3, r2
	ldr	r3, [r7, #1768]
	add	r2, r2, r3
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	add	r2, r2, r3
	add	r3, r7, #1776
	subw	r3, r3, #1532
	str	r2, [r3]
	add	r3, r7, #1776
	subw	r3, r3, #1532
	ldr	r3, [r3]
	vld1.8	{d16}, [r3]
	add	r3, r7, #1752
	vstr	d16, [r3]
	ldr	r3, [r7, #1772]
	movs	r2, #48
	mul	r2, r3, r2
	ldr	r3, [r7, #1768]
	add	r2, r2, r3
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	add	r2, r2, r3
	add	r3, r7, #1776
	sub	r3, r3, #1528
	str	r2, [r3]
	add	r3, r7, #1776
	sub	r3, r3, #1528
	ldr	r3, [r3]
	vld1.8	{d16}, [r3]
	add	r3, r7, #1744
	vstr	d16, [r3]
	ldr	r3, [r7, #1772]
	adds	r3, r3, #1
	movs	r2, #48
	mul	r2, r3, r2
	ldr	r3, [r7, #1768]
	add	r2, r2, r3
	movw	r3, #:lower16:R
	movt	r3, #:upper16:R
	add	r2, r2, r3
	add	r3, r7, #1776
	subw	r3, r3, #1524
	str	r2, [r3]
	add	r3, r7, #1776
	subw	r3, r3, #1524
	ldr	r3, [r3]
	vld1.8	{d16}, [r3]
	add	r3, r7, #1736
	vstr	d16, [r3]
	ldr	r3, [r7, #1772]
	adds	r3, r3, #1
	movs	r2, #48
	mul	r2, r3, r2
	ldr	r3, [r7, #1768]
	add	r2, r2, r3
	movw	r3, #:lower16:G
	movt	r3, #:upper16:G
	add	r2, r2, r3
	add	r3, r7, #1776
	sub	r3, r3, #1520
	str	r2, [r3]
	add	r3, r7, #1776
	sub	r3, r3, #1520
	ldr	r3, [r3]
	vld1.8	{d16}, [r3]
	add	r3, r7, #1728
	vstr	d16, [r3]
	ldr	r3, [r7, #1772]
	adds	r3, r3, #1
	movs	r2, #48
	mul	r2, r3, r2
	ldr	r3, [r7, #1768]
	add	r2, r2, r3
	movw	r3, #:lower16:B
	movt	r3, #:upper16:B
	add	r2, r2, r3
	add	r3, r7, #1776
	subw	r3, r3, #1516
	str	r2, [r3]
	add	r3, r7, #1776
	subw	r3, r3, #1516
	ldr	r3, [r3]
	vld1.8	{d16}, [r3]
	add	r3, r7, #1720
	vstr	d16, [r3]
	add	r3, r7, #1776
	sub	r3, r3, #1512
	add	r2, r7, #1760
	vldr	d16, [r2]
	vstr	d16, [r3]
	add	r3, r7, #1776
	sub	r3, r3, #1512
	vldr	d16, [r3]
	vmovl.u8	q8, d16
	add	r3, r7, #1704
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1504
	add	r2, r7, #1752
	vldr	d16, [r2]
	vstr	d16, [r3]
	add	r3, r7, #1776
	sub	r3, r3, #1504
	vldr	d16, [r3]
	vmovl.u8	q8, d16
	add	r3, r7, #1688
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1496
	add	r2, r7, #1744
	vldr	d16, [r2]
	vstr	d16, [r3]
	add	r3, r7, #1776
	sub	r3, r3, #1496
	vldr	d16, [r3]
	vmovl.u8	q8, d16
	add	r3, r7, #1672
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1488
	add	r2, r7, #1736
	vldr	d16, [r2]
	vstr	d16, [r3]
	add	r3, r7, #1776
	sub	r3, r3, #1488
	vldr	d16, [r3]
	vmovl.u8	q8, d16
	add	r3, r7, #1656
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1480
	add	r2, r7, #1728
	vldr	d16, [r2]
	vstr	d16, [r3]
	add	r3, r7, #1776
	sub	r3, r3, #1480
	vldr	d16, [r3]
	vmovl.u8	q8, d16
	add	r3, r7, #1640
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1472
	add	r2, r7, #1720
	vldr	d16, [r2]
	vstr	d16, [r3]
	add	r3, r7, #1776
	sub	r3, r3, #1472
	vldr	d16, [r3]
	vmovl.u8	q8, d16
	add	r3, r7, #1624
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	subw	r3, r3, #1460
	mov	r2, #4224
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1776
	subw	lr, r3, #1460
	add	r3, r7, #1776
	subw	ip, r3, #1460
	add	r3, r7, #1776
	subw	r6, r3, #1460
	add	r3, r7, #1776
	subw	r5, r3, #1460
	add	r3, r7, #1776
	subw	r4, r3, #1460
	add	r3, r7, #1776
	subw	r0, r3, #1460
	add	r3, r7, #1776
	subw	r1, r3, #1460
	add	r3, r7, #1776
	subw	r2, r3, #1460
	add	r3, r7, #1776
	sub	r3, r3, #1552
	ldrh	lr, [lr]	@ movhi
	strh	lr, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1550
	ldrh	ip, [ip]	@ movhi
	strh	ip, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1548
	ldrh	r6, [r6]	@ movhi
	strh	r6, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1546
	ldrh	r5, [r5]	@ movhi
	strh	r5, [r3]	@ movhi
	add	r3, r7, #1776
	sub	r3, r3, #1544
	ldrh	r4, [r4]	@ movhi
	strh	r4, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1542
	ldrh	r0, [r0]	@ movhi
	strh	r0, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1540
	ldrh	r1, [r1]	@ movhi
	strh	r1, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1538
	ldrh	r2, [r2]	@ movhi
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1776
	sub	r3, r3, #1552
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1608
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1440
	add	r2, r7, #1608
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1456
	add	r2, r7, #1704
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	subw	r3, r3, #1458
	movs	r2, #66
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1776
	sub	r3, r3, #1440
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1456
	vld1.64	{d18-d19}, [r3:64]
	add	r3, r7, #1776
	subw	r3, r3, #1458
	ldrsh	r3, [r3]
	vldr	d7, [r7, #136]
	vmov.16	d7[0], r3
	vstr	d7, [r7, #136]
	vmla.i16	q8, q9, d7[0]
	add	r3, r7, #1608
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1400
	add	r2, r7, #1608
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1416
	add	r2, r7, #1688
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	subw	r3, r3, #1418
	movs	r2, #129
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1776
	sub	r3, r3, #1400
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1416
	vld1.64	{d18-d19}, [r3:64]
	add	r3, r7, #1776
	subw	r3, r3, #1418
	ldrsh	r3, [r3]
	vldr	d7, [r7, #128]
	vmov.16	d7[0], r3
	vstr	d7, [r7, #128]
	vmla.i16	q8, q9, d7[0]
	add	r3, r7, #1608
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1360
	add	r2, r7, #1608
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1376
	add	r2, r7, #1672
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	subw	r3, r3, #1378
	movs	r2, #25
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1776
	sub	r3, r3, #1360
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1376
	vld1.64	{d18-d19}, [r3:64]
	add	r3, r7, #1776
	subw	r3, r3, #1378
	ldrsh	r3, [r3]
	vldr	d7, [r7, #120]
	vmov.16	d7[0], r3
	vstr	d7, [r7, #120]
	vmla.i16	q8, q9, d7[0]
	add	r3, r7, #1608
	vst1.64	{d16-d17}, [r3:64]
	ldr	r3, [r7, #1772]
	movs	r2, #48
	mul	r2, r3, r2
	ldr	r3, [r7, #1768]
	add	r2, r2, r3
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	add	r2, r2, r3
	add	r3, r7, #1776
	sub	r3, r3, #1344
	add	r1, r7, #1608
	vld1.64	{d16-d17}, [r1:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1344
	vld1.64	{d16-d17}, [r3:64]
	vshr.u16	q8, q8, #8
	add	r3, r7, #1776
	sub	r3, r3, #1328
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1328
	vld1.64	{d16-d17}, [r3:64]
	vmovn.i16	d16, q8
	add	r3, r7, #1776
	sub	r3, r3, #1304
	str	r2, [r3]
	add	r3, r7, #1776
	sub	r3, r3, #1312
	vstr	d16, [r3]
	add	r3, r7, #1776
	sub	r3, r3, #1312
	vldr	d16, [r3]
	add	r3, r7, #1776
	sub	r3, r3, #1304
	ldr	r3, [r3]
	vst1.8	{d16}, [r3]
	nop
	add	r3, r7, #1776
	subw	r3, r3, #1300
	mov	r2, #4224
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1776
	subw	lr, r3, #1300
	add	r3, r7, #1776
	subw	ip, r3, #1300
	add	r3, r7, #1776
	subw	r6, r3, #1300
	add	r3, r7, #1776
	subw	r5, r3, #1300
	add	r3, r7, #1776
	subw	r4, r3, #1300
	add	r3, r7, #1776
	subw	r0, r3, #1300
	add	r3, r7, #1776
	subw	r1, r3, #1300
	add	r3, r7, #1776
	subw	r2, r3, #1300
	add	r3, r7, #1776
	sub	r3, r3, #1568
	ldrh	lr, [lr]	@ movhi
	strh	lr, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1566
	ldrh	ip, [ip]	@ movhi
	strh	ip, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1564
	ldrh	r6, [r6]	@ movhi
	strh	r6, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1562
	ldrh	r5, [r5]	@ movhi
	strh	r5, [r3]	@ movhi
	add	r3, r7, #1776
	sub	r3, r3, #1560
	ldrh	r4, [r4]	@ movhi
	strh	r4, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1558
	ldrh	r0, [r0]	@ movhi
	strh	r0, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1556
	ldrh	r1, [r1]	@ movhi
	strh	r1, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1554
	ldrh	r2, [r2]	@ movhi
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1776
	sub	r3, r3, #1568
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1592
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1280
	add	r2, r7, #1592
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1296
	add	r2, r7, #1656
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	subw	r3, r3, #1298
	movs	r2, #66
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1776
	sub	r3, r3, #1280
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1296
	vld1.64	{d18-d19}, [r3:64]
	add	r3, r7, #1776
	subw	r3, r3, #1298
	ldrsh	r3, [r3]
	vldr	d7, [r7, #112]
	vmov.16	d7[0], r3
	vstr	d7, [r7, #112]
	vmla.i16	q8, q9, d7[0]
	add	r3, r7, #1592
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1240
	add	r2, r7, #1592
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1256
	add	r2, r7, #1640
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	subw	r3, r3, #1258
	movs	r2, #129
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1776
	sub	r3, r3, #1240
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1256
	vld1.64	{d18-d19}, [r3:64]
	add	r3, r7, #1776
	subw	r3, r3, #1258
	ldrsh	r3, [r3]
	vldr	d7, [r7, #104]
	vmov.16	d7[0], r3
	vstr	d7, [r7, #104]
	vmla.i16	q8, q9, d7[0]
	add	r3, r7, #1592
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1200
	add	r2, r7, #1592
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1216
	add	r2, r7, #1624
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	subw	r3, r3, #1218
	movs	r2, #25
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1776
	sub	r3, r3, #1200
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1216
	vld1.64	{d18-d19}, [r3:64]
	add	r3, r7, #1776
	subw	r3, r3, #1218
	ldrsh	r3, [r3]
	vldr	d7, [r7, #96]
	vmov.16	d7[0], r3
	vstr	d7, [r7, #96]
	vmla.i16	q8, q9, d7[0]
	add	r3, r7, #1592
	vst1.64	{d16-d17}, [r3:64]
	ldr	r3, [r7, #1772]
	adds	r3, r3, #1
	movs	r2, #48
	mul	r2, r3, r2
	ldr	r3, [r7, #1768]
	add	r2, r2, r3
	movw	r3, #:lower16:Y
	movt	r3, #:upper16:Y
	add	r2, r2, r3
	add	r3, r7, #1776
	sub	r3, r3, #1184
	add	r1, r7, #1592
	vld1.64	{d16-d17}, [r1:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1184
	vld1.64	{d16-d17}, [r3:64]
	vshr.u16	q8, q8, #8
	add	r3, r7, #1776
	sub	r3, r3, #1168
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1168
	vld1.64	{d16-d17}, [r3:64]
	vmovn.i16	d16, q8
	add	r3, r7, #1776
	sub	r3, r3, #1144
	str	r2, [r3]
	add	r3, r7, #1776
	sub	r3, r3, #1152
	vstr	d16, [r3]
	add	r3, r7, #1776
	sub	r3, r3, #1152
	vldr	d16, [r3]
	add	r3, r7, #1776
	sub	r3, r3, #1144
	ldr	r3, [r3]
	vst1.8	{d16}, [r3]
	nop
	add	r3, r7, #1776
	subw	r3, r3, #1140
	movw	r2, #32896
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1776
	subw	lr, r3, #1140
	add	r3, r7, #1776
	subw	ip, r3, #1140
	add	r3, r7, #1776
	subw	r6, r3, #1140
	add	r3, r7, #1776
	subw	r5, r3, #1140
	add	r3, r7, #1776
	subw	r4, r3, #1140
	add	r3, r7, #1776
	subw	r0, r3, #1140
	add	r3, r7, #1776
	subw	r1, r3, #1140
	add	r3, r7, #1776
	subw	r2, r3, #1140
	add	r3, r7, #1776
	sub	r3, r3, #1584
	ldrh	lr, [lr]	@ movhi
	strh	lr, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1582
	ldrh	ip, [ip]	@ movhi
	strh	ip, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1580
	ldrh	r6, [r6]	@ movhi
	strh	r6, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1578
	ldrh	r5, [r5]	@ movhi
	strh	r5, [r3]	@ movhi
	add	r3, r7, #1776
	sub	r3, r3, #1576
	ldrh	r4, [r4]	@ movhi
	strh	r4, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1574
	ldrh	r0, [r0]	@ movhi
	strh	r0, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1572
	ldrh	r1, [r1]	@ movhi
	strh	r1, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1570
	ldrh	r2, [r2]	@ movhi
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1776
	sub	r3, r3, #1584
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1576
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1120
	add	r2, r7, #1576
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1136
	add	r2, r7, #1704
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	subw	r3, r3, #1138
	movs	r2, #38
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1776
	sub	r3, r3, #1120
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1136
	vld1.64	{d18-d19}, [r3:64]
	add	r3, r7, #1776
	subw	r3, r3, #1138
	ldrsh	r3, [r3]
	vldr	d7, [r7, #88]
	vmov.16	d7[0], r3
	vstr	d7, [r7, #88]
	vmls.i16	q8, q9, d7[0]
	add	r3, r7, #1576
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1080
	add	r2, r7, #1576
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1096
	add	r2, r7, #1688
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	subw	r3, r3, #1098
	movs	r2, #74
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1776
	sub	r3, r3, #1080
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1096
	vld1.64	{d18-d19}, [r3:64]
	add	r3, r7, #1776
	subw	r3, r3, #1098
	ldrsh	r3, [r3]
	vldr	d7, [r7, #80]
	vmov.16	d7[0], r3
	vstr	d7, [r7, #80]
	vmls.i16	q8, q9, d7[0]
	add	r3, r7, #1576
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1040
	add	r2, r7, #1576
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1056
	add	r2, r7, #1672
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	subw	r3, r3, #1058
	movs	r2, #112
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1776
	sub	r3, r3, #1040
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1056
	vld1.64	{d18-d19}, [r3:64]
	add	r3, r7, #1776
	subw	r3, r3, #1058
	ldrsh	r3, [r3]
	vldr	d7, [r7, #72]
	vmov.16	d7[0], r3
	vstr	d7, [r7, #72]
	vmla.i16	q8, q9, d7[0]
	add	r3, r7, #1576
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1024
	add	r2, r7, #1576
	vld1.64	{d16-d17}, [r2:64]
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	sub	r3, r3, #1024
	vld1.64	{d16-d17}, [r3:64]
	vshr.u16	q8, q8, #8
	vstr	d16, [r7, #768]
	vstr	d17, [r7, #776]
	vldr	d16, [r7, #768]
	vldr	d17, [r7, #776]
	vmovn.i16	d16, q8
	add	r3, r7, #1568
	vstr	d16, [r3]
	add	r3, r7, #1776
	sub	r3, r3, #988
	movw	r2, #32896
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1776
	sub	lr, r3, #988
	add	r3, r7, #1776
	sub	ip, r3, #988
	add	r3, r7, #1776
	sub	r6, r3, #988
	add	r3, r7, #1776
	sub	r5, r3, #988
	add	r3, r7, #1776
	sub	r4, r3, #988
	add	r3, r7, #1776
	sub	r0, r3, #988
	add	r3, r7, #1776
	sub	r1, r3, #988
	add	r3, r7, #1776
	sub	r2, r3, #988
	add	r3, r7, #1776
	sub	r3, r3, #1600
	ldrh	lr, [lr]	@ movhi
	strh	lr, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1598
	ldrh	ip, [ip]	@ movhi
	strh	ip, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1596
	ldrh	r6, [r6]	@ movhi
	strh	r6, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1594
	ldrh	r5, [r5]	@ movhi
	strh	r5, [r3]	@ movhi
	add	r3, r7, #1776
	sub	r3, r3, #1592
	ldrh	r4, [r4]	@ movhi
	strh	r4, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1590
	ldrh	r0, [r0]	@ movhi
	strh	r0, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1588
	ldrh	r1, [r1]	@ movhi
	strh	r1, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1586
	ldrh	r2, [r2]	@ movhi
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1776
	sub	r3, r3, #1600
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1552
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1552
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #808]
	vstr	d17, [r7, #816]
	add	r3, r7, #1656
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #792]
	vstr	d17, [r7, #800]
	add	r3, r7, #1776
	subw	r3, r3, #986
	movs	r2, #38
	strh	r2, [r3]	@ movhi
	vldr	d16, [r7, #808]
	vldr	d17, [r7, #816]
	vldr	d18, [r7, #792]
	vldr	d19, [r7, #800]
	add	r3, r7, #1776
	subw	r3, r3, #986
	ldrsh	r3, [r3]
	vldr	d7, [r7, #64]
	vmov.16	d7[0], r3
	vstr	d7, [r7, #64]
	vmls.i16	q8, q9, d7[0]
	add	r3, r7, #1552
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1552
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #848]
	vstr	d17, [r7, #856]
	add	r3, r7, #1640
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #832]
	vstr	d17, [r7, #840]
	add	r3, r7, #1776
	subw	r3, r3, #946
	movs	r2, #74
	strh	r2, [r3]	@ movhi
	vldr	d16, [r7, #848]
	vldr	d17, [r7, #856]
	vldr	d18, [r7, #832]
	vldr	d19, [r7, #840]
	add	r3, r7, #1776
	subw	r3, r3, #946
	ldrsh	r3, [r3]
	vldr	d7, [r7, #56]
	vmov.16	d7[0], r3
	vstr	d7, [r7, #56]
	vmls.i16	q8, q9, d7[0]
	add	r3, r7, #1552
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1552
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #888]
	vstr	d17, [r7, #896]
	add	r3, r7, #1624
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #872]
	vstr	d17, [r7, #880]
	add	r3, r7, #1776
	subw	r3, r3, #906
	movs	r2, #112
	strh	r2, [r3]	@ movhi
	vldr	d16, [r7, #888]
	vldr	d17, [r7, #896]
	vldr	d18, [r7, #872]
	vldr	d19, [r7, #880]
	add	r3, r7, #1776
	subw	r3, r3, #906
	ldrsh	r3, [r3]
	vldr	d7, [r7, #48]
	vmov.16	d7[0], r3
	vstr	d7, [r7, #48]
	vmla.i16	q8, q9, d7[0]
	add	r3, r7, #1552
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1552
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #904]
	vstr	d17, [r7, #912]
	vldr	d16, [r7, #904]
	vldr	d17, [r7, #912]
	vshr.u16	q8, q8, #8
	vstr	d16, [r7, #920]
	vstr	d17, [r7, #928]
	vldr	d16, [r7, #920]
	vldr	d17, [r7, #928]
	vmovn.i16	d16, q8
	add	r3, r7, #1544
	vstr	d16, [r3]
	add	r3, r7, #1776
	sub	r3, r3, #836
	movw	r2, #32896
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1776
	sub	lr, r3, #836
	add	r3, r7, #1776
	sub	ip, r3, #836
	add	r3, r7, #1776
	sub	r6, r3, #836
	add	r3, r7, #1776
	sub	r5, r3, #836
	add	r3, r7, #1776
	sub	r4, r3, #836
	add	r3, r7, #1776
	sub	r0, r3, #836
	add	r3, r7, #1776
	sub	r1, r3, #836
	add	r3, r7, #1776
	sub	r2, r3, #836
	add	r3, r7, #1776
	sub	r3, r3, #1616
	ldrh	lr, [lr]	@ movhi
	strh	lr, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1614
	ldrh	ip, [ip]	@ movhi
	strh	ip, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1612
	ldrh	r6, [r6]	@ movhi
	strh	r6, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1610
	ldrh	r5, [r5]	@ movhi
	strh	r5, [r3]	@ movhi
	add	r3, r7, #1776
	sub	r3, r3, #1608
	ldrh	r4, [r4]	@ movhi
	strh	r4, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1606
	ldrh	r0, [r0]	@ movhi
	strh	r0, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1604
	ldrh	r1, [r1]	@ movhi
	strh	r1, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1602
	ldrh	r2, [r2]	@ movhi
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1776
	sub	r3, r3, #1616
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1528
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1528
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #960]
	vstr	d17, [r7, #968]
	add	r3, r7, #1704
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #944]
	vstr	d17, [r7, #952]
	add	r3, r7, #1776
	subw	r3, r3, #834
	movs	r2, #112
	strh	r2, [r3]	@ movhi
	vldr	d16, [r7, #960]
	vldr	d17, [r7, #968]
	vldr	d18, [r7, #944]
	vldr	d19, [r7, #952]
	add	r3, r7, #1776
	subw	r3, r3, #834
	ldrsh	r3, [r3]
	vldr	d7, [r7, #40]
	vmov.16	d7[0], r3
	vstr	d7, [r7, #40]
	vmla.i16	q8, q9, d7[0]
	add	r3, r7, #1528
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1528
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #1000]
	vstr	d17, [r7, #1008]
	add	r3, r7, #1688
	vld1.64	{d16-d17}, [r3:64]
	vstr	d16, [r7, #984]
	vstr	d17, [r7, #992]
	add	r3, r7, #1776
	subw	r3, r3, #794
	movs	r2, #94
	strh	r2, [r3]	@ movhi
	vldr	d16, [r7, #1000]
	vldr	d17, [r7, #1008]
	vldr	d18, [r7, #984]
	vldr	d19, [r7, #992]
	add	r3, r7, #1776
	subw	r3, r3, #794
	ldrsh	r3, [r3]
	vldr	d7, [r7, #32]
	vmov.16	d7[0], r3
	vstr	d7, [r7, #32]
	vmls.i16	q8, q9, d7[0]
	add	r3, r7, #1528
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1528
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1040
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1672
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1024
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	subw	r3, r3, #754
	movs	r2, #18
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1040
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1024
	vld1.64	{d18-d19}, [r3:64]
	add	r3, r7, #1776
	subw	r3, r3, #754
	ldrsh	r3, [r3]
	vldr	d7, [r7, #24]
	vmov.16	d7[0], r3
	vstr	d7, [r7, #24]
	vmls.i16	q8, q9, d7[0]
	add	r3, r7, #1528
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1528
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1056
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1056
	vld1.64	{d16-d17}, [r3:64]
	vshr.u16	q8, q8, #8
	add	r3, r7, #1072
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1072
	vld1.64	{d16-d17}, [r3:64]
	vmovn.i16	d16, q8
	add	r3, r7, #1520
	vstr	d16, [r3]
	add	r3, r7, #1776
	sub	r3, r3, #684
	movw	r2, #32896
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1776
	sub	lr, r3, #684
	add	r3, r7, #1776
	sub	ip, r3, #684
	add	r3, r7, #1776
	sub	r6, r3, #684
	add	r3, r7, #1776
	sub	r5, r3, #684
	add	r3, r7, #1776
	sub	r4, r3, #684
	add	r3, r7, #1776
	sub	r0, r3, #684
	add	r3, r7, #1776
	sub	r1, r3, #684
	add	r3, r7, #1776
	sub	r2, r3, #684
	add	r3, r7, #1776
	sub	r3, r3, #1632
	ldrh	lr, [lr]	@ movhi
	strh	lr, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1630
	ldrh	ip, [ip]	@ movhi
	strh	ip, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1628
	ldrh	r6, [r6]	@ movhi
	strh	r6, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1626
	ldrh	r5, [r5]	@ movhi
	strh	r5, [r3]	@ movhi
	add	r3, r7, #1776
	sub	r3, r3, #1624
	ldrh	r4, [r4]	@ movhi
	strh	r4, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1622
	ldrh	r0, [r0]	@ movhi
	strh	r0, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1620
	ldrh	r1, [r1]	@ movhi
	strh	r1, [r3]	@ movhi
	add	r3, r7, #1776
	subw	r3, r3, #1618
	ldrh	r2, [r2]	@ movhi
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1776
	sub	r3, r3, #1632
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1504
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1504
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1112
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1656
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1096
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	subw	r3, r3, #682
	movs	r2, #112
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1112
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1096
	vld1.64	{d18-d19}, [r3:64]
	add	r3, r7, #1776
	subw	r3, r3, #682
	ldrsh	r3, [r3]
	vldr	d7, [r7, #16]
	vmov.16	d7[0], r3
	vstr	d7, [r7, #16]
	vmla.i16	q8, q9, d7[0]
	add	r3, r7, #1504
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1504
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1152
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1640
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1136
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	subw	r3, r3, #642
	movs	r2, #94
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1152
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1136
	vld1.64	{d18-d19}, [r3:64]
	add	r3, r7, #1776
	subw	r3, r3, #642
	ldrsh	r3, [r3]
	vldr	d7, [r7, #8]
	vmov.16	d7[0], r3
	vstr	d7, [r7, #8]
	vmls.i16	q8, q9, d7[0]
	add	r3, r7, #1504
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1504
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1192
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1624
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1176
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1776
	subw	r3, r3, #602
	movs	r2, #18
	strh	r2, [r3]	@ movhi
	add	r3, r7, #1192
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1176
	vld1.64	{d18-d19}, [r3:64]
	add	r3, r7, #1776
	subw	r3, r3, #602
	ldrsh	r3, [r3]
	vldr	d7, [r7]
	vmov.16	d7[0], r3
	vstr	d7, [r7]
	vmls.i16	q8, q9, d7[0]
	add	r3, r7, #1504
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1504
	vld1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1208
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1208
	vld1.64	{d16-d17}, [r3:64]
	vshr.u16	q8, q8, #8
	add	r3, r7, #1224
	vst1.64	{d16-d17}, [r3:64]
	add	r3, r7, #1224
	vld1.64	{d16-d17}, [r3:64]
	vmovn.i16	d16, q8
	add	r3, r7, #1496
	vstr	d16, [r3]
	add	r3, r7, #1568
	vldr	d16, [r3]
	add	r3, r7, #1240
	vstr	d16, [r3]
	add	r3, r7, #1240
	vldr	d16, [r3]
	vmov.u8	r3, d16[0]
	uxtb	r0, r3
	add	r3, r7, #1568
	vldr	d16, [r3]
	add	r3, r7, #1248
	vstr	d16, [r3]
	add	r3, r7, #1248
	vldr	d16, [r3]
	vmov.u8	r3, d16[1]
	uxtb	r1, r3
	add	r3, r7, #1544
	vldr	d16, [r3]
	add	r3, r7, #1256
	vstr	d16, [r3]
	add	r3, r7, #1256
	vldr	d16, [r3]
	vmov.u8	r3, d16[0]
	uxtb	r2, r3
	add	r3, r7, #1544
	vldr	d16, [r3]
	add	r3, r7, #1264
	vstr	d16, [r3]
	add	r3, r7, #1264
	vldr	d16, [r3]
	vmov.u8	r3, d16[1]
	uxtb	r6, r3
	ldr	r3, [r7, #1772]
	asrs	r5, r3, #1
	ldr	r3, [r7, #1768]
	asrs	r4, r3, #1
	mov	r3, r6
	bl	chrominance_downsample
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:Cb
	movt	r3, #:upper16:Cb
	movs	r2, #24
	mul	r2, r5, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r1
	strb	r2, [r3]
	add	r3, r7, #1568
	vldr	d16, [r3]
	add	r3, r7, #1272
	vstr	d16, [r3]
	add	r3, r7, #1272
	vldr	d16, [r3]
	vmov.u8	r3, d16[2]
	uxtb	r0, r3
	add	r3, r7, #1568
	vldr	d16, [r3]
	add	r3, r7, #1280
	vstr	d16, [r3]
	add	r3, r7, #1280
	vldr	d16, [r3]
	vmov.u8	r3, d16[3]
	uxtb	r1, r3
	add	r3, r7, #1544
	vldr	d16, [r3]
	add	r3, r7, #1288
	vstr	d16, [r3]
	add	r3, r7, #1288
	vldr	d16, [r3]
	vmov.u8	r3, d16[2]
	uxtb	r2, r3
	add	r3, r7, #1544
	vldr	d16, [r3]
	add	r3, r7, #1296
	vstr	d16, [r3]
	add	r3, r7, #1296
	vldr	d16, [r3]
	vmov.u8	r3, d16[3]
	uxtb	r6, r3
	ldr	r3, [r7, #1772]
	asrs	r5, r3, #1
	ldr	r3, [r7, #1768]
	asrs	r3, r3, #1
	adds	r4, r3, #1
	mov	r3, r6
	bl	chrominance_downsample
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:Cb
	movt	r3, #:upper16:Cb
	movs	r2, #24
	mul	r2, r5, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r1
	strb	r2, [r3]
	add	r3, r7, #1568
	vldr	d16, [r3]
	add	r3, r7, #1304
	vstr	d16, [r3]
	add	r3, r7, #1304
	vldr	d16, [r3]
	vmov.u8	r3, d16[4]
	uxtb	r0, r3
	add	r3, r7, #1568
	vldr	d16, [r3]
	add	r3, r7, #1312
	vstr	d16, [r3]
	add	r3, r7, #1312
	vldr	d16, [r3]
	vmov.u8	r3, d16[5]
	uxtb	r1, r3
	add	r3, r7, #1544
	vldr	d16, [r3]
	add	r3, r7, #1320
	vstr	d16, [r3]
	add	r3, r7, #1320
	vldr	d16, [r3]
	vmov.u8	r3, d16[4]
	uxtb	r2, r3
	add	r3, r7, #1544
	vldr	d16, [r3]
	add	r3, r7, #1328
	vstr	d16, [r3]
	add	r3, r7, #1328
	vldr	d16, [r3]
	vmov.u8	r3, d16[5]
	uxtb	r6, r3
	ldr	r3, [r7, #1772]
	asrs	r5, r3, #1
	ldr	r3, [r7, #1768]
	asrs	r3, r3, #1
	adds	r4, r3, #2
	mov	r3, r6
	bl	chrominance_downsample
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:Cb
	movt	r3, #:upper16:Cb
	movs	r2, #24
	mul	r2, r5, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r1
	strb	r2, [r3]
	add	r3, r7, #1568
	vldr	d16, [r3]
	add	r3, r7, #1336
	vstr	d16, [r3]
	add	r3, r7, #1336
	vldr	d16, [r3]
	vmov.u8	r3, d16[6]
	uxtb	r0, r3
	add	r3, r7, #1568
	vldr	d16, [r3]
	add	r3, r7, #1344
	vstr	d16, [r3]
	add	r3, r7, #1344
	vldr	d16, [r3]
	vmov.u8	r3, d16[7]
	uxtb	r1, r3
	add	r3, r7, #1544
	vldr	d16, [r3]
	add	r3, r7, #1352
	vstr	d16, [r3]
	add	r3, r7, #1352
	vldr	d16, [r3]
	vmov.u8	r3, d16[6]
	uxtb	r2, r3
	add	r3, r7, #1544
	vldr	d16, [r3]
	add	r3, r7, #1360
	vstr	d16, [r3]
	add	r3, r7, #1360
	vldr	d16, [r3]
	vmov.u8	r3, d16[7]
	uxtb	r6, r3
	ldr	r3, [r7, #1772]
	asrs	r5, r3, #1
	ldr	r3, [r7, #1768]
	asrs	r3, r3, #1
	adds	r4, r3, #3
	mov	r3, r6
	bl	chrominance_downsample
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:Cb
	movt	r3, #:upper16:Cb
	movs	r2, #24
	mul	r2, r5, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r1
	strb	r2, [r3]
	add	r3, r7, #1520
	vldr	d16, [r3]
	add	r3, r7, #1368
	vstr	d16, [r3]
	add	r3, r7, #1368
	vldr	d16, [r3]
	vmov.u8	r3, d16[0]
	uxtb	r0, r3
	add	r3, r7, #1520
	vldr	d16, [r3]
	add	r3, r7, #1376
	vstr	d16, [r3]
	add	r3, r7, #1376
	vldr	d16, [r3]
	vmov.u8	r3, d16[1]
	uxtb	r1, r3
	add	r3, r7, #1496
	vldr	d16, [r3]
	add	r3, r7, #1384
	vstr	d16, [r3]
	add	r3, r7, #1384
	vldr	d16, [r3]
	vmov.u8	r3, d16[0]
	uxtb	r2, r3
	add	r3, r7, #1496
	vldr	d16, [r3]
	add	r3, r7, #1392
	vstr	d16, [r3]
	add	r3, r7, #1392
	vldr	d16, [r3]
	vmov.u8	r3, d16[1]
	uxtb	r6, r3
	ldr	r3, [r7, #1772]
	asrs	r5, r3, #1
	ldr	r3, [r7, #1768]
	asrs	r4, r3, #1
	mov	r3, r6
	bl	chrominance_downsample
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	movs	r2, #24
	mul	r2, r5, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r1
	strb	r2, [r3]
	add	r3, r7, #1520
	vldr	d16, [r3]
	add	r3, r7, #1400
	vstr	d16, [r3]
	add	r3, r7, #1400
	vldr	d16, [r3]
	vmov.u8	r3, d16[2]
	uxtb	r0, r3
	add	r3, r7, #1520
	vldr	d16, [r3]
	add	r3, r7, #1408
	vstr	d16, [r3]
	add	r3, r7, #1408
	vldr	d16, [r3]
	vmov.u8	r3, d16[3]
	uxtb	r1, r3
	add	r3, r7, #1496
	vldr	d16, [r3]
	add	r3, r7, #1416
	vstr	d16, [r3]
	add	r3, r7, #1416
	vldr	d16, [r3]
	vmov.u8	r3, d16[2]
	uxtb	r2, r3
	add	r3, r7, #1496
	vldr	d16, [r3]
	add	r3, r7, #1424
	vstr	d16, [r3]
	add	r3, r7, #1424
	vldr	d16, [r3]
	vmov.u8	r3, d16[3]
	uxtb	r6, r3
	ldr	r3, [r7, #1772]
	asrs	r5, r3, #1
	ldr	r3, [r7, #1768]
	asrs	r3, r3, #1
	adds	r4, r3, #1
	mov	r3, r6
	bl	chrominance_downsample
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	movs	r2, #24
	mul	r2, r5, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r1
	strb	r2, [r3]
	add	r3, r7, #1520
	vldr	d16, [r3]
	add	r3, r7, #1432
	vstr	d16, [r3]
	add	r3, r7, #1432
	vldr	d16, [r3]
	vmov.u8	r3, d16[4]
	uxtb	r0, r3
	add	r3, r7, #1520
	vldr	d16, [r3]
	add	r3, r7, #1440
	vstr	d16, [r3]
	add	r3, r7, #1440
	vldr	d16, [r3]
	vmov.u8	r3, d16[5]
	uxtb	r1, r3
	add	r3, r7, #1496
	vldr	d16, [r3]
	add	r3, r7, #1448
	vstr	d16, [r3]
	add	r3, r7, #1448
	vldr	d16, [r3]
	vmov.u8	r3, d16[4]
	uxtb	r2, r3
	add	r3, r7, #1496
	vldr	d16, [r3]
	add	r3, r7, #1456
	vstr	d16, [r3]
	add	r3, r7, #1456
	vldr	d16, [r3]
	vmov.u8	r3, d16[5]
	uxtb	r6, r3
	ldr	r3, [r7, #1772]
	asrs	r5, r3, #1
	ldr	r3, [r7, #1768]
	asrs	r3, r3, #1
	adds	r4, r3, #2
	mov	r3, r6
	bl	chrominance_downsample
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	movs	r2, #24
	mul	r2, r5, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r1
	strb	r2, [r3]
	add	r3, r7, #1520
	vldr	d16, [r3]
	add	r3, r7, #1464
	vstr	d16, [r3]
	add	r3, r7, #1464
	vldr	d16, [r3]
	vmov.u8	r3, d16[6]
	uxtb	r0, r3
	add	r3, r7, #1520
	vldr	d16, [r3]
	add	r3, r7, #1472
	vstr	d16, [r3]
	add	r3, r7, #1472
	vldr	d16, [r3]
	vmov.u8	r3, d16[7]
	uxtb	r1, r3
	add	r3, r7, #1496
	vldr	d16, [r3]
	add	r3, r7, #1480
	vstr	d16, [r3]
	add	r3, r7, #1480
	vldr	d16, [r3]
	vmov.u8	r3, d16[6]
	uxtb	r2, r3
	add	r3, r7, #1496
	vldr	d16, [r3]
	add	r3, r7, #1488
	vstr	d16, [r3]
	add	r3, r7, #1488
	vldr	d16, [r3]
	vmov.u8	r3, d16[7]
	uxtb	r6, r3
	ldr	r3, [r7, #1772]
	asrs	r5, r3, #1
	ldr	r3, [r7, #1768]
	asrs	r3, r3, #1
	adds	r4, r3, #3
	mov	r3, r6
	bl	chrominance_downsample
	mov	r3, r0
	mov	r1, r3
	movw	r3, #:lower16:Cr
	movt	r3, #:upper16:Cr
	movs	r2, #24
	mul	r2, r5, r2
	add	r3, r3, r2
	add	r3, r3, r4
	mov	r2, r1
	strb	r2, [r3]
	ldr	r3, [r7, #1768]
	adds	r3, r3, #8
	str	r3, [r7, #1768]
.L51:
	ldr	r3, [r7, #1768]
	cmp	r3, #47
	ble	.L132
	ldr	r3, [r7, #1772]
	adds	r3, r3, #2
	str	r3, [r7, #1772]
.L50:
	ldr	r3, [r7, #1772]
	cmp	r3, #63
	ble	.L133
	nop
	nop
	addw	r7, r7, #1780
	mov	sp, r7
	@ sp needed
	pop	{r4, r5, r6, r7, pc}
	.size	CSC_RGB_to_YCC_neon_v2, .-CSC_RGB_to_YCC_neon_v2
	.align	1
	.syntax unified
	.thumb
	.thumb_func
	.type	chrominance_downsample, %function
chrominance_downsample:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r4, r7}
	sub	sp, sp, #16
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
	str	r3, [r7, #12]
	ldr	r3, [r7, #12]
	uxtb	r3, r3
	mov	r0, r3
	adds	r7, r7, #16
	mov	sp, r7
	@ sp needed
	pop	{r4, r7}
	bx	lr
	.size	chrominance_downsample, .-chrominance_downsample
	.align	1
	.global	CSC_RGB_to_YCC
	.syntax unified
	.thumb
	.thumb_func
	.type	CSC_RGB_to_YCC, %function
CSC_RGB_to_YCC:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr}
	add	r7, sp, #0
	bl	CSC_RGB_to_YCC_neon_v2
	nop
	pop	{r7, pc}
	.size	CSC_RGB_to_YCC, .-CSC_RGB_to_YCC
	.local	lut_ready.0
	.comm	lut_ready.0,4,4
	.ident	"GCC: (Arm GNU Toolchain 15.3.Rel1 (Build arm-15.149)) 15.3.1 20260627"
	.section	.note.GNU-stack,"",%progbits
