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
	.file	"CSC_main.c"
	.text
	.section	.text.startup,"ax",%progbits
	.align	1
	.p2align 2,,3
	.global	main
	.syntax unified
	.thumb
	.thumb_func
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 9360
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
	vmov.i64	d16, #0	@ float
	movs	r2, #0
	sub	sp, sp, #9344
	mov	r6, r1
	sub	sp, sp, #44
	add	r8, sp, #1192
	add	fp, sp, #104
	subw	r3, r8, #1124
	sub	r4, fp, #24
	vstr.64	d16, [fp, #-32]
	str	r2, [r3]
	mov	r2, r4
	bl	csc_parse_args(PLT)
	cmp	r0, #0
	bne	.L15
	sub	r10, r8, #1112
	ldr	r2, [r10, #20]
	cmp	r2, #0
	bne	.L16
	ldr	r0, [r10]
	bl	csc_load_input_image(PLT)
	mov	r9, r0
	cbz	r0, .L6
.L3:
	movs	r5, #1
.L1:
	mov	r0, r5
	add	sp, sp, #9344
	add	sp, sp, #44
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r9, r10, fp, pc}
.L6:
	add	r3, sp, #6304
	addw	r1, sp, #3240
	adds	r3, r3, #8
	add	r0, sp, #168
	mov	r7, r3
	mov	r2, r3
	mov	r6, r1
	mov	r5, r0
	str	r3, [sp, #44]
	str	r1, [sp, #40]
	str	r0, [sp, #48]
	bl	csc_snapshot_rgb(PLT)
	mov	r2, r7
	mov	r1, r6
	mov	r0, r5
	bl	csc_restore_rgb(PLT)
	bl	CSC_RGB_to_YCC(PLT)
	bl	CSC_YCC_to_RGB(PLT)
	ldr	r2, [r10, #16]
	cmp	r2, #0
	ble	.L11
	mov	r7, r9
	mov	r5, r9
	mov	r3, #-1
	str	r9, [sp, #28]
	str	r3, [sp, #32]
	str	r3, [sp, #36]
	str	r9, [sp, #24]
	strd	r4, r8, [sp, #52]
	str	fp, [sp, #60]
.L9:
	ldrd	r1, r2, [sp, #40]
	add	r9, r9, #1
	ldr	r0, [sp, #48]
	bl	csc_restore_rgb(PLT)
	bl	csc_now_ns(PLT)
	mov	r8, r0
	mov	fp, r1
	bl	CSC_RGB_to_YCC(PLT)
	bl	csc_now_ns(PLT)
	mov	r4, r0
	mov	r6, r1
	bl	CSC_YCC_to_RGB(PLT)
	bl	csc_now_ns(PLT)
	subs	r0, r0, r4
	sbc	r1, r1, r6
	ldr	r3, [sp, #24]
	subs	r4, r4, r8
	sbc	r6, r6, fp
	adds	r4, r4, r5
	adc	r3, r3, r6
	str	r3, [sp, #24]
	ldr	r3, [sp, #28]
	adds	r7, r0, r7
	mov	r5, r4
	adc	r3, r1, r3
	str	r3, [sp, #28]
	ldr	r3, [sp, #32]
	cmp	r0, r3
	ldr	r3, [sp, #36]
	sbcs	r2, r1, r3
	ldr	r2, [r10, #16]
	it	cc
	strdcc	r0, r1, [sp, #32]
	cmp	r2, r9
	bgt	.L9
	ldrd	r4, r8, [sp, #52]
	ldr	fp, [sp, #60]
.L7:
	sub	r6, r8, #1112
	ldr	r0, [sp, #48]
	sub	r3, fp, #32
	str	r3, [sp]
	ldrd	r1, r2, [sp, #40]
	sub	r3, fp, #36
	bl	csc_compute_quality(PLT)
	ldr	r0, [r6, #4]
	bl	csc_write_ppm(PLT)
	cmp	r0, #0
	bne	.L3
	ldr	r3, [sp, #32]
	subw	r8, r8, #1124
	str	r3, [sp, #8]
	mov	r2, r5
	ldr	r3, [sp, #36]
	str	r3, [sp, #12]
	ldr	r3, [sp, #28]
	str	r3, [sp, #4]
	str	r7, [sp]
	ldr	r3, [sp, #24]
	ldr	r0, [r6, #16]
	vldr.64	d0, [fp, #-32]
	str	fp, [sp, #20]
	ldr	r1, [r8]
	str	r1, [sp, #16]
	bl	csc_fill_wall_metrics(PLT)
	mov	r1, fp
	mov	r0, r4
	bl	csc_report_wall_metrics(PLT)
	mov	r5, r0
	b	.L1
.L16:
	mov	r5, r0
	ldr	r0, [r6]
	bl	csc_print_usage(PLT)
	b	.L1
.L15:
	ldr	r0, [r6]
	bl	csc_print_usage(PLT)
	b	.L3
.L11:
	mov	r3, #-1
	mov	r7, r9
	mov	r5, r9
	strd	r3, r3, [sp, #32]
	str	r9, [sp, #28]
	str	r9, [sp, #24]
	b	.L7
	.size	main, .-main
	.global	Cr_temp
	.global	Cb_temp
	.global	Cr
	.global	Cb
	.global	Y
	.global	B
	.global	G
	.global	R
	.bss
	.align	3
	.type	Cr_temp, %object
	.size	Cr_temp, 3072
Cr_temp:
	.space	3072
	.type	Cb_temp, %object
	.size	Cb_temp, 3072
Cb_temp:
	.space	3072
	.type	Cr, %object
	.size	Cr, 768
Cr:
	.space	768
	.type	Cb, %object
	.size	Cb, 768
Cb:
	.space	768
	.type	Y, %object
	.size	Y, 3072
Y:
	.space	3072
	.type	B, %object
	.size	B, 3072
B:
	.space	3072
	.type	G, %object
	.size	G, 3072
G:
	.space	3072
	.type	R, %object
	.size	R, 3072
R:
	.space	3072
	.ident	"GCC: (Debian 14.2.0-19) 14.2.0"
	.section	.note.GNU-stack,"",%progbits
