	.arch armv7-a
	.fpu vfpv3-d16
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
.Ltext0:
	.cfi_sections	.debug_frame
	.file 1 "CSC_main.c"
	.section	.text.startup,"ax",%progbits
	.align	1
	.p2align 2,,3
	.global	main
	.syntax unified
	.thumb
	.thumb_func
	.type	main, %function
main:
.LVL0:
.LFB11:
	.loc 1 11 35 view -0
	.cfi_startproc
	@ args = 0, pretend = 0, frame = 9360
	@ frame_needed = 0, uses_anonymous_args = 0
	.loc 1 12 3 view .LVU1
	.loc 1 13 3 view .LVU2
	.loc 1 14 3 view .LVU3
	.loc 1 15 3 view .LVU4
	.loc 1 16 3 view .LVU5
	.loc 1 17 3 view .LVU6
	.loc 1 18 3 view .LVU7
	.loc 1 11 35 is_stmt 0 view .LVU8
	push	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
	.cfi_def_cfa_offset 36
	.cfi_offset 4, -36
	.cfi_offset 5, -32
	.cfi_offset 6, -28
	.cfi_offset 7, -24
	.cfi_offset 8, -20
	.cfi_offset 9, -16
	.cfi_offset 10, -12
	.cfi_offset 11, -8
	.cfi_offset 14, -4
	.loc 1 18 7 view .LVU9
	movs	r2, #0
	.loc 1 19 10 view .LVU10
	vldr.64	d7, .L17
	.loc 1 11 35 view .LVU11
	sub	sp, sp, #9344
	.cfi_def_cfa_offset 9380
	mov	r6, r1
	sub	sp, sp, #44
	.cfi_def_cfa_offset 9424
	.loc 1 18 7 view .LVU12
	add	r8, sp, #1192
	.loc 1 19 10 view .LVU13
	add	fp, sp, #104
	.loc 1 18 7 view .LVU14
	subw	r3, r8, #1124
	.loc 1 24 7 view .LVU15
	sub	r4, fp, #24
	.loc 1 19 10 view .LVU16
	vstr.64	d7, [fp, #-32]
	.loc 1 18 7 view .LVU17
	str	r2, [r3]
	.loc 1 19 3 is_stmt 1 view .LVU18
	.loc 1 20 3 view .LVU19
.LVL1:
	.loc 1 21 3 view .LVU20
	.loc 1 22 3 view .LVU21
	.loc 1 24 3 view .LVU22
	.loc 1 24 7 is_stmt 0 view .LVU23
	mov	r2, r4
	bl	csc_parse_args(PLT)
.LVL2:
	.loc 1 24 5 discriminator 1 view .LVU24
	cmp	r0, #0
	bne	.L15
	.loc 1 28 3 is_stmt 1 view .LVU25
	.loc 1 28 10 is_stmt 0 view .LVU26
	sub	r10, r8, #1112
	.loc 1 28 5 view .LVU27
	ldr	r2, [r10, #20]
	cmp	r2, #0
	bne	.L16
	.loc 1 33 3 is_stmt 1 view .LVU28
	.loc 1 33 7 is_stmt 0 view .LVU29
	ldr	r0, [r10]
	bl	csc_load_input_image(PLT)
.LVL3:
	.loc 1 33 5 discriminator 1 view .LVU30
	mov	r9, r0
	cbz	r0, .L6
.LVL4:
.L3:
	.loc 1 26 12 view .LVU31
	movs	r5, #1
.L1:
	.loc 1 76 1 view .LVU32
	mov	r0, r5
	add	sp, sp, #9344
	add	sp, sp, #44
	.cfi_remember_state
	.cfi_def_cfa_offset 36
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r9, r10, fp, pc}
.LVL5:
.L6:
	.cfi_restore_state
	.loc 1 37 3 is_stmt 1 view .LVU33
	add	r3, sp, #6304
	addw	r1, sp, #3240
	adds	r3, r3, #8
	add	r0, sp, #168
	mov	r7, r3
	mov	r2, r3
	mov	r6, r1
.LVL6:
	.loc 1 37 3 is_stmt 0 view .LVU34
	mov	r5, r0
	str	r3, [sp, #44]
	str	r1, [sp, #40]
	str	r0, [sp, #48]
	bl	csc_snapshot_rgb(PLT)
.LVL7:
	.loc 1 40 3 is_stmt 1 view .LVU35
	mov	r2, r7
	mov	r1, r6
	mov	r0, r5
	bl	csc_restore_rgb(PLT)
.LVL8:
	.loc 1 41 3 view .LVU36
	bl	CSC_RGB_to_YCC(PLT)
.LVL9:
	.loc 1 42 3 view .LVU37
	bl	CSC_YCC_to_RGB(PLT)
.LVL10:
	.loc 1 45 3 view .LVU38
	.loc 1 45 15 discriminator 1 view .LVU39
	ldr	r2, [r10, #16]
	cmp	r2, #0
	ble	.L11
	.loc 1 21 12 is_stmt 0 view .LVU40
	mov	r7, r9
	.loc 1 20 12 view .LVU41
	mov	r5, r9
	.loc 1 22 12 view .LVU42
	mov	r3, #-1
	.loc 1 21 12 view .LVU43
	str	r9, [sp, #28]
	.loc 1 22 12 view .LVU44
	str	r3, [sp, #32]
	str	r3, [sp, #36]
	.loc 1 20 12 view .LVU45
	str	r9, [sp, #24]
	strd	r4, r8, [sp, #52]
	str	fp, [sp, #60]
.LVL11:
.L9:
.LBB2:
	.loc 1 46 5 is_stmt 1 view .LVU46
	.loc 1 47 5 view .LVU47
	.loc 1 49 5 view .LVU48
	ldrd	r1, r2, [sp, #40]
.LBE2:
	.loc 1 45 34 is_stmt 0 discriminator 2 view .LVU49
	add	r9, r9, #1
.LVL12:
.LBB3:
	.loc 1 49 5 view .LVU50
	ldr	r0, [sp, #48]
	bl	csc_restore_rgb(PLT)
.LVL13:
	.loc 1 51 5 is_stmt 1 view .LVU51
	.loc 1 51 10 is_stmt 0 view .LVU52
	bl	csc_now_ns(PLT)
.LVL14:
	mov	r8, r0
	mov	fp, r1
.LVL15:
	.loc 1 52 5 is_stmt 1 view .LVU53
	bl	CSC_RGB_to_YCC(PLT)
.LVL16:
	.loc 1 53 5 view .LVU54
	.loc 1 53 10 is_stmt 0 view .LVU55
	bl	csc_now_ns(PLT)
.LVL17:
	mov	r4, r0
	mov	r6, r1
.LVL18:
	.loc 1 54 5 is_stmt 1 view .LVU56
	bl	CSC_YCC_to_RGB(PLT)
.LVL19:
	.loc 1 55 5 view .LVU57
	.loc 1 55 10 is_stmt 0 view .LVU58
	bl	csc_now_ns(PLT)
.LVL20:
	.loc 1 57 5 is_stmt 1 view .LVU59
	.loc 1 58 5 view .LVU60
	.loc 1 58 12 is_stmt 0 view .LVU61
	subs	r0, r0, r4
.LVL21:
	.loc 1 58 12 view .LVU62
	sbc	r1, r1, r6
.LVL22:
	.loc 1 59 5 is_stmt 1 view .LVU63
	.loc 1 59 16 is_stmt 0 view .LVU64
	ldr	r3, [sp, #24]
	subs	r4, r4, r8
.LVL23:
	.loc 1 59 16 view .LVU65
	sbc	r6, r6, fp
	adds	r4, r4, r5
	adc	r3, r3, r6
	str	r3, [sp, #24]
.LVL24:
	.loc 1 60 5 is_stmt 1 view .LVU66
	.loc 1 60 16 is_stmt 0 view .LVU67
	ldr	r3, [sp, #28]
	adds	r7, r0, r7
.LVL25:
	.loc 1 59 16 view .LVU68
	mov	r5, r4
	.loc 1 60 16 view .LVU69
	adc	r3, r1, r3
	str	r3, [sp, #28]
	.loc 1 61 5 is_stmt 1 view .LVU70
	.loc 1 61 7 is_stmt 0 view .LVU71
	ldr	r3, [sp, #32]
	cmp	r0, r3
	ldr	r3, [sp, #36]
	sbcs	r2, r1, r3
.LBE3:
	.loc 1 45 15 discriminator 1 view .LVU72
	ldr	r2, [r10, #16]
.LBB4:
	.loc 1 61 7 view .LVU73
	it	cc
	strdcc	r0, r1, [sp, #32]
.LVL26:
	.loc 1 61 7 view .LVU74
.LBE4:
	.loc 1 45 34 is_stmt 1 discriminator 2 view .LVU75
	.loc 1 45 15 discriminator 1 view .LVU76
	cmp	r2, r9
	bgt	.L9
	ldrd	r4, r8, [sp, #52]
.LVL27:
	.loc 1 45 15 is_stmt 0 discriminator 1 view .LVU77
	ldr	fp, [sp, #60]
.LVL28:
.L7:
	.loc 1 66 3 is_stmt 1 view .LVU78
	.loc 1 68 7 is_stmt 0 view .LVU79
	sub	r6, r8, #1112
	.loc 1 66 3 view .LVU80
	ldr	r0, [sp, #48]
	sub	r3, fp, #32
	str	r3, [sp]
	ldrd	r1, r2, [sp, #40]
	sub	r3, fp, #36
	bl	csc_compute_quality(PLT)
.LVL29:
	.loc 1 68 3 is_stmt 1 view .LVU81
	.loc 1 68 7 is_stmt 0 view .LVU82
	ldr	r0, [r6, #4]
	bl	csc_write_ppm(PLT)
.LVL30:
	.loc 1 68 5 discriminator 1 view .LVU83
	cmp	r0, #0
	bne	.L3
	.loc 1 72 3 is_stmt 1 view .LVU84
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
.LVL31:
	.loc 1 75 3 view .LVU85
	.loc 1 75 10 is_stmt 0 view .LVU86
	mov	r1, fp
	mov	r0, r4
	bl	csc_report_wall_metrics(PLT)
.LVL32:
	mov	r5, r0
	b	.L1
.LVL33:
.L16:
	.loc 1 75 10 view .LVU87
	mov	r5, r0
	.loc 1 29 5 is_stmt 1 view .LVU88
	ldr	r0, [r6]
	bl	csc_print_usage(PLT)
.LVL34:
	.loc 1 30 5 view .LVU89
	.loc 1 30 12 is_stmt 0 view .LVU90
	b	.L1
.L15:
	.loc 1 25 5 is_stmt 1 view .LVU91
	ldr	r0, [r6]
	bl	csc_print_usage(PLT)
.LVL35:
	.loc 1 26 5 view .LVU92
	.loc 1 26 12 is_stmt 0 view .LVU93
	b	.L3
.LVL36:
.L11:
	.loc 1 22 12 view .LVU94
	mov	r3, #-1
	.loc 1 21 12 view .LVU95
	mov	r7, r9
	.loc 1 20 12 view .LVU96
	mov	r5, r9
	.loc 1 22 12 view .LVU97
	strd	r3, r3, [sp, #32]
	.loc 1 21 12 view .LVU98
	str	r9, [sp, #28]
	.loc 1 20 12 view .LVU99
	str	r9, [sp, #24]
	b	.L7
.L18:
	.align	3
.L17:
	.word	0
	.word	0
	.cfi_endproc
.LFE11:
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
	.align	2
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
	.text
.Letext0:
	.file 2 "/usr/include/arm-linux-gnueabihf/bits/types.h"
	.file 3 "/usr/include/arm-linux-gnueabihf/bits/stdint-uintn.h"
	.file 4 "CSC_global.h"
	.file 5 "CSC_harness.h"
	.section	.debug_info,"",%progbits
.Ldebug_info0:
	.4byte	0x63c
	.2byte	0x5
	.byte	0x1
	.byte	0x4
	.4byte	.Ldebug_abbrev0
	.uleb128 0x16
	.4byte	.LASF54
	.byte	0x1d
	.4byte	.LASF55
	.4byte	.LASF56
	.4byte	.LLRL11
	.4byte	0
	.4byte	.Ldebug_line0
	.uleb128 0x4
	.byte	0x8
	.byte	0x7
	.4byte	.LASF0
	.uleb128 0x4
	.byte	0x4
	.byte	0x7
	.4byte	.LASF1
	.uleb128 0x4
	.byte	0x1
	.byte	0x8
	.4byte	.LASF2
	.uleb128 0x4
	.byte	0x2
	.byte	0x7
	.4byte	.LASF3
	.uleb128 0x4
	.byte	0x4
	.byte	0x7
	.4byte	.LASF4
	.uleb128 0x4
	.byte	0x1
	.byte	0x6
	.4byte	.LASF5
	.uleb128 0x8
	.4byte	.LASF8
	.byte	0x2
	.byte	0x26
	.byte	0x17
	.4byte	0x34
	.uleb128 0x4
	.byte	0x2
	.byte	0x5
	.4byte	.LASF6
	.uleb128 0x17
	.byte	0x4
	.byte	0x5
	.ascii	"int\000"
	.uleb128 0x4
	.byte	0x8
	.byte	0x5
	.4byte	.LASF7
	.uleb128 0x8
	.4byte	.LASF9
	.byte	0x2
	.byte	0x30
	.byte	0x2e
	.4byte	0x26
	.uleb128 0x4
	.byte	0x4
	.byte	0x5
	.4byte	.LASF10
	.uleb128 0x5
	.4byte	0x89
	.uleb128 0x4
	.byte	0x1
	.byte	0x8
	.4byte	.LASF11
	.uleb128 0xd
	.4byte	0x89
	.uleb128 0x5
	.4byte	0x90
	.uleb128 0x8
	.4byte	.LASF12
	.byte	0x3
	.byte	0x18
	.byte	0x13
	.4byte	0x50
	.uleb128 0xd
	.4byte	0x9a
	.uleb128 0x8
	.4byte	.LASF13
	.byte	0x3
	.byte	0x1b
	.byte	0x14
	.4byte	0x71
	.uleb128 0xe
	.4byte	0x9a
	.4byte	0xcd
	.uleb128 0x9
	.4byte	0x2d
	.byte	0x3f
	.uleb128 0x9
	.4byte	0x2d
	.byte	0x2f
	.byte	0
	.uleb128 0xa
	.ascii	"R\000"
	.byte	0x61
	.4byte	0xb7
	.uleb128 0x5
	.byte	0x3
	.4byte	R
	.uleb128 0xa
	.ascii	"G\000"
	.byte	0x62
	.4byte	0xb7
	.uleb128 0x5
	.byte	0x3
	.4byte	G
	.uleb128 0xa
	.ascii	"B\000"
	.byte	0x63
	.4byte	0xb7
	.uleb128 0x5
	.byte	0x3
	.4byte	B
	.uleb128 0xa
	.ascii	"Y\000"
	.byte	0x64
	.4byte	0xb7
	.uleb128 0x5
	.byte	0x3
	.4byte	Y
	.uleb128 0xe
	.4byte	0x9a
	.4byte	0x11b
	.uleb128 0x9
	.4byte	0x2d
	.byte	0x1f
	.uleb128 0x9
	.4byte	0x2d
	.byte	0x17
	.byte	0
	.uleb128 0xa
	.ascii	"Cb\000"
	.byte	0x65
	.4byte	0x105
	.uleb128 0x5
	.byte	0x3
	.4byte	Cb
	.uleb128 0xa
	.ascii	"Cr\000"
	.byte	0x66
	.4byte	0x105
	.uleb128 0x5
	.byte	0x3
	.4byte	Cr
	.uleb128 0x12
	.4byte	.LASF14
	.byte	0x67
	.4byte	0xb7
	.uleb128 0x5
	.byte	0x3
	.4byte	Cb_temp
	.uleb128 0x12
	.4byte	.LASF15
	.byte	0x68
	.4byte	0xb7
	.uleb128 0x5
	.byte	0x3
	.4byte	Cr_temp
	.uleb128 0x13
	.byte	0x18
	.byte	0xc
	.4byte	0x1a9
	.uleb128 0x3
	.4byte	.LASF16
	.byte	0xd
	.byte	0xf
	.4byte	0x95
	.byte	0
	.uleb128 0x3
	.4byte	.LASF17
	.byte	0xe
	.byte	0xf
	.4byte	0x95
	.byte	0x4
	.uleb128 0x3
	.4byte	.LASF18
	.byte	0xf
	.byte	0xf
	.4byte	0x95
	.byte	0x8
	.uleb128 0x3
	.4byte	.LASF19
	.byte	0x10
	.byte	0xf
	.4byte	0x95
	.byte	0xc
	.uleb128 0x3
	.4byte	.LASF20
	.byte	0x11
	.byte	0x7
	.4byte	0x63
	.byte	0x10
	.uleb128 0x3
	.4byte	.LASF21
	.byte	0x12
	.byte	0x7
	.4byte	0x63
	.byte	0x14
	.byte	0
	.uleb128 0x8
	.4byte	.LASF22
	.byte	0x5
	.byte	0x13
	.byte	0x3
	.4byte	0x159
	.uleb128 0xd
	.4byte	0x1a9
	.uleb128 0x13
	.byte	0x40
	.byte	0x15
	.4byte	0x222
	.uleb128 0x3
	.4byte	.LASF23
	.byte	0x16
	.byte	0xa
	.4byte	0x222
	.byte	0
	.uleb128 0x3
	.4byte	.LASF24
	.byte	0x17
	.byte	0xa
	.4byte	0x222
	.byte	0x8
	.uleb128 0x3
	.4byte	.LASF25
	.byte	0x18
	.byte	0xa
	.4byte	0x222
	.byte	0x10
	.uleb128 0x3
	.4byte	.LASF26
	.byte	0x19
	.byte	0xa
	.4byte	0x222
	.byte	0x18
	.uleb128 0x3
	.4byte	.LASF27
	.byte	0x1a
	.byte	0xa
	.4byte	0x222
	.byte	0x20
	.uleb128 0x3
	.4byte	.LASF28
	.byte	0x1b
	.byte	0xa
	.4byte	0x222
	.byte	0x28
	.uleb128 0x3
	.4byte	.LASF29
	.byte	0x1c
	.byte	0x7
	.4byte	0x63
	.byte	0x30
	.uleb128 0x3
	.4byte	.LASF30
	.byte	0x1d
	.byte	0xa
	.4byte	0x222
	.byte	0x38
	.byte	0
	.uleb128 0x4
	.byte	0x8
	.byte	0x4
	.4byte	.LASF31
	.uleb128 0x8
	.4byte	.LASF32
	.byte	0x5
	.byte	0x1e
	.byte	0x3
	.4byte	0x1ba
	.uleb128 0xd
	.4byte	0x229
	.uleb128 0xf
	.4byte	.LASF33
	.byte	0x49
	.4byte	0x63
	.4byte	0x253
	.uleb128 0x1
	.4byte	0x253
	.uleb128 0x1
	.4byte	0x258
	.byte	0
	.uleb128 0x5
	.4byte	0x1b5
	.uleb128 0x5
	.4byte	0x235
	.uleb128 0xc
	.4byte	.LASF35
	.byte	0x3b
	.4byte	0x28b
	.uleb128 0x1
	.4byte	0x63
	.uleb128 0x1
	.4byte	0xab
	.uleb128 0x1
	.4byte	0xab
	.uleb128 0x1
	.4byte	0xab
	.uleb128 0x1
	.4byte	0x63
	.uleb128 0x1
	.4byte	0x222
	.uleb128 0x1
	.4byte	0x28b
	.byte	0
	.uleb128 0x5
	.4byte	0x229
	.uleb128 0xf
	.4byte	.LASF34
	.byte	0x28
	.4byte	0x63
	.4byte	0x2a4
	.uleb128 0x1
	.4byte	0x95
	.byte	0
	.uleb128 0xc
	.4byte	.LASF36
	.byte	0x34
	.4byte	0x2c8
	.uleb128 0x1
	.4byte	0x2c8
	.uleb128 0x1
	.4byte	0x2c8
	.uleb128 0x1
	.4byte	0x2c8
	.uleb128 0x1
	.4byte	0x2dd
	.uleb128 0x1
	.4byte	0x2e2
	.byte	0
	.uleb128 0x5
	.4byte	0x2cd
	.uleb128 0xe
	.4byte	0xa6
	.4byte	0x2dd
	.uleb128 0x9
	.4byte	0x2d
	.byte	0x2f
	.byte	0
	.uleb128 0x5
	.4byte	0x63
	.uleb128 0x5
	.4byte	0x222
	.uleb128 0x18
	.4byte	.LASF57
	.byte	0x5
	.byte	0x21
	.byte	0xa
	.4byte	0xab
	.uleb128 0x14
	.4byte	.LASF37
	.byte	0x5e
	.uleb128 0x14
	.4byte	.LASF38
	.byte	0x5d
	.uleb128 0xc
	.4byte	.LASF39
	.byte	0x2f
	.4byte	0x319
	.uleb128 0x1
	.4byte	0x2c8
	.uleb128 0x1
	.4byte	0x2c8
	.uleb128 0x1
	.4byte	0x2c8
	.byte	0
	.uleb128 0xc
	.4byte	.LASF40
	.byte	0x2a
	.4byte	0x333
	.uleb128 0x1
	.4byte	0x333
	.uleb128 0x1
	.4byte	0x333
	.uleb128 0x1
	.4byte	0x333
	.byte	0
	.uleb128 0x5
	.4byte	0x338
	.uleb128 0xe
	.4byte	0x9a
	.4byte	0x348
	.uleb128 0x9
	.4byte	0x2d
	.byte	0x2f
	.byte	0
	.uleb128 0xf
	.4byte	.LASF41
	.byte	0x27
	.4byte	0x63
	.4byte	0x35c
	.uleb128 0x1
	.4byte	0x95
	.byte	0
	.uleb128 0xc
	.4byte	.LASF42
	.byte	0x25
	.4byte	0x36c
	.uleb128 0x1
	.4byte	0x95
	.byte	0
	.uleb128 0xf
	.4byte	.LASF43
	.byte	0x24
	.4byte	0x63
	.4byte	0x38a
	.uleb128 0x1
	.4byte	0x63
	.uleb128 0x1
	.4byte	0x38a
	.uleb128 0x1
	.4byte	0x38f
	.byte	0
	.uleb128 0x5
	.4byte	0x84
	.uleb128 0x5
	.4byte	0x1a9
	.uleb128 0x19
	.4byte	.LASF58
	.byte	0x1
	.byte	0xb
	.byte	0x5
	.4byte	0x63
	.4byte	.LFB11
	.4byte	.LFE11-.LFB11
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x15
	.4byte	.LASF44
	.byte	0xf
	.4byte	0x63
	.4byte	.LLST0
	.4byte	.LVUS0
	.uleb128 0x15
	.4byte	.LASF45
	.byte	0x1b
	.4byte	0x38a
	.4byte	.LLST1
	.4byte	.LVUS1
	.uleb128 0x1a
	.ascii	"cfg\000"
	.byte	0x1
	.byte	0xc
	.byte	0x11
	.4byte	0x1a9
	.uleb128 0x4
	.byte	0x91
	.sleb128 -9344
	.uleb128 0xb
	.4byte	.LASF46
	.byte	0xd
	.byte	0x13
	.4byte	0x229
	.uleb128 0x4
	.byte	0x91
	.sleb128 -9320
	.uleb128 0xb
	.4byte	.LASF47
	.byte	0xe
	.byte	0xb
	.4byte	0xb7
	.uleb128 0x4
	.byte	0x91
	.sleb128 -9256
	.uleb128 0xb
	.4byte	.LASF48
	.byte	0xf
	.byte	0xb
	.4byte	0xb7
	.uleb128 0x3
	.byte	0x91
	.sleb128 -6184
	.uleb128 0xb
	.4byte	.LASF49
	.byte	0x10
	.byte	0xb
	.4byte	0xb7
	.uleb128 0x3
	.byte	0x91
	.sleb128 -3112
	.uleb128 0x10
	.ascii	"i\000"
	.byte	0x11
	.byte	0x7
	.4byte	0x63
	.4byte	.LLST2
	.4byte	.LVUS2
	.uleb128 0xb
	.4byte	.LASF29
	.byte	0x12
	.byte	0x7
	.4byte	0x63
	.uleb128 0x4
	.byte	0x91
	.sleb128 -9356
	.uleb128 0xb
	.4byte	.LASF30
	.byte	0x13
	.byte	0xa
	.4byte	0x222
	.uleb128 0x4
	.byte	0x91
	.sleb128 -9352
	.uleb128 0x11
	.4byte	.LASF50
	.byte	0x14
	.byte	0xc
	.4byte	0xab
	.4byte	.LLST3
	.4byte	.LVUS3
	.uleb128 0x11
	.4byte	.LASF51
	.byte	0x15
	.byte	0xc
	.4byte	0xab
	.4byte	.LLST4
	.4byte	.LVUS4
	.uleb128 0x11
	.4byte	.LASF52
	.byte	0x16
	.byte	0xc
	.4byte	0xab
	.4byte	.LLST5
	.4byte	.LVUS5
	.uleb128 0x1b
	.4byte	.LLRL6
	.4byte	0x53c
	.uleb128 0x10
	.ascii	"t0\000"
	.byte	0x2e
	.byte	0xe
	.4byte	0xab
	.4byte	.LLST7
	.4byte	.LVUS7
	.uleb128 0x10
	.ascii	"t1\000"
	.byte	0x2e
	.byte	0x12
	.4byte	0xab
	.4byte	.LLST8
	.4byte	.LVUS8
	.uleb128 0x10
	.ascii	"t2\000"
	.byte	0x2e
	.byte	0x16
	.4byte	0xab
	.4byte	.LLST9
	.4byte	.LVUS9
	.uleb128 0x1c
	.4byte	.LASF59
	.byte	0x1
	.byte	0x2f
	.byte	0xe
	.4byte	0xab
	.uleb128 0x11
	.4byte	.LASF53
	.byte	0x2f
	.byte	0x16
	.4byte	0xab
	.4byte	.LLST10
	.4byte	.LVUS10
	.uleb128 0x7
	.4byte	.LVL13
	.4byte	0x2ff
	.4byte	0x50e
	.uleb128 0x2
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x5
	.byte	0x91
	.sleb128 -9376
	.byte	0x6
	.uleb128 0x2
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x5
	.byte	0x91
	.sleb128 -9384
	.byte	0x6
	.uleb128 0x2
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x5
	.byte	0x91
	.sleb128 -9380
	.byte	0x6
	.byte	0
	.uleb128 0x6
	.4byte	.LVL14
	.4byte	0x2e7
	.uleb128 0x6
	.4byte	.LVL16
	.4byte	0x2f9
	.uleb128 0x6
	.4byte	.LVL17
	.4byte	0x2e7
	.uleb128 0x6
	.4byte	.LVL19
	.4byte	0x2f3
	.uleb128 0x6
	.4byte	.LVL20
	.4byte	0x2e7
	.byte	0
	.uleb128 0x7
	.4byte	.LVL2
	.4byte	0x36c
	.4byte	0x563
	.uleb128 0x2
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x9
	.byte	0xa3
	.uleb128 0x3
	.byte	0xa5
	.uleb128 0
	.uleb128 0x26
	.byte	0xa8
	.uleb128 0x2d
	.byte	0xa8
	.uleb128 0
	.uleb128 0x2
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x76
	.sleb128 0
	.uleb128 0x2
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x74
	.sleb128 0
	.byte	0
	.uleb128 0x6
	.4byte	.LVL3
	.4byte	0x348
	.uleb128 0x7
	.4byte	.LVL7
	.4byte	0x319
	.4byte	0x58c
	.uleb128 0x2
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x75
	.sleb128 0
	.uleb128 0x2
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x76
	.sleb128 0
	.uleb128 0x2
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x77
	.sleb128 0
	.byte	0
	.uleb128 0x7
	.4byte	.LVL8
	.4byte	0x2ff
	.4byte	0x5ac
	.uleb128 0x2
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x75
	.sleb128 0
	.uleb128 0x2
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x76
	.sleb128 0
	.uleb128 0x2
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x77
	.sleb128 0
	.byte	0
	.uleb128 0x6
	.4byte	.LVL9
	.4byte	0x2f9
	.uleb128 0x6
	.4byte	.LVL10
	.4byte	0x2f3
	.uleb128 0x7
	.4byte	.LVL29
	.4byte	0x2a4
	.4byte	0x5f4
	.uleb128 0x2
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x5
	.byte	0x91
	.sleb128 -9376
	.byte	0x6
	.uleb128 0x2
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x5
	.byte	0x91
	.sleb128 -9384
	.byte	0x6
	.uleb128 0x2
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x5
	.byte	0x91
	.sleb128 -9380
	.byte	0x6
	.uleb128 0x2
	.uleb128 0x1
	.byte	0x53
	.uleb128 0x2
	.byte	0x7b
	.sleb128 -36
	.uleb128 0x2
	.uleb128 0x2
	.byte	0x7d
	.sleb128 0
	.uleb128 0x2
	.byte	0x7b
	.sleb128 -32
	.byte	0
	.uleb128 0x6
	.4byte	.LVL30
	.4byte	0x290
	.uleb128 0x7
	.4byte	.LVL31
	.4byte	0x25d
	.4byte	0x612
	.uleb128 0x2
	.uleb128 0x2
	.byte	0x7d
	.sleb128 20
	.uleb128 0x2
	.byte	0x7b
	.sleb128 0
	.byte	0
	.uleb128 0x7
	.4byte	.LVL32
	.4byte	0x23a
	.4byte	0x62c
	.uleb128 0x2
	.uleb128 0x1
	.byte	0x50
	.uleb128 0x2
	.byte	0x74
	.sleb128 0
	.uleb128 0x2
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x7b
	.sleb128 0
	.byte	0
	.uleb128 0x6
	.4byte	.LVL34
	.4byte	0x35c
	.uleb128 0x6
	.4byte	.LVL35
	.4byte	0x35c
	.byte	0
	.byte	0
	.section	.debug_abbrev,"",%progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x49
	.byte	0
	.uleb128 0x2
	.uleb128 0x18
	.uleb128 0x7e
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 5
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0x21
	.sleb128 4
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0x48
	.byte	0
	.uleb128 0x7d
	.uleb128 0x1
	.uleb128 0x7f
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x48
	.byte	0x1
	.uleb128 0x7d
	.uleb128 0x1
	.uleb128 0x7f
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 4
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 16
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 5
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 6
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 5
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 5
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 4
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 16
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x13
	.byte	0x1
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 5
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 9
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 4
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 6
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0x21
	.sleb128 11
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1b
	.uleb128 0xe
	.uleb128 0x55
	.uleb128 0x17
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x17
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x18
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x19
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x6
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7a
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x1a
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x1b
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x55
	.uleb128 0x17
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1c
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_loclists,"",%progbits
	.4byte	.Ldebug_loc3-.Ldebug_loc2
.Ldebug_loc2:
	.2byte	0x5
	.byte	0x4
	.byte	0
	.4byte	0
.Ldebug_loc0:
.LVUS0:
	.uleb128 0
	.uleb128 .LVU24
	.uleb128 .LVU24
	.uleb128 0
.LLST0:
	.byte	0x6
	.4byte	.LVL0
	.byte	0x4
	.uleb128 .LVL0-.LVL0
	.uleb128 .LVL2-1-.LVL0
	.uleb128 0x1
	.byte	0x50
	.byte	0x4
	.uleb128 .LVL2-1-.LVL0
	.uleb128 .LFE11-.LVL0
	.uleb128 0xa
	.byte	0xa3
	.uleb128 0x3
	.byte	0xa5
	.uleb128 0
	.uleb128 0x26
	.byte	0xa8
	.uleb128 0x2d
	.byte	0xa8
	.uleb128 0
	.byte	0x9f
	.byte	0
.LVUS1:
	.uleb128 0
	.uleb128 .LVU24
	.uleb128 .LVU24
	.uleb128 .LVU31
	.uleb128 .LVU31
	.uleb128 .LVU33
	.uleb128 .LVU33
	.uleb128 .LVU34
	.uleb128 .LVU34
	.uleb128 .LVU87
	.uleb128 .LVU87
	.uleb128 .LVU94
	.uleb128 .LVU94
	.uleb128 0
.LLST1:
	.byte	0x6
	.4byte	.LVL0
	.byte	0x4
	.uleb128 .LVL0-.LVL0
	.uleb128 .LVL2-1-.LVL0
	.uleb128 0x1
	.byte	0x51
	.byte	0x4
	.uleb128 .LVL2-1-.LVL0
	.uleb128 .LVL4-.LVL0
	.uleb128 0x1
	.byte	0x56
	.byte	0x4
	.uleb128 .LVL4-.LVL0
	.uleb128 .LVL5-.LVL0
	.uleb128 0xa
	.byte	0xa3
	.uleb128 0x3
	.byte	0xa5
	.uleb128 0x1
	.uleb128 0x26
	.byte	0xa8
	.uleb128 0x2d
	.byte	0xa8
	.uleb128 0
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL5-.LVL0
	.uleb128 .LVL6-.LVL0
	.uleb128 0x1
	.byte	0x56
	.byte	0x4
	.uleb128 .LVL6-.LVL0
	.uleb128 .LVL33-.LVL0
	.uleb128 0xa
	.byte	0xa3
	.uleb128 0x3
	.byte	0xa5
	.uleb128 0x1
	.uleb128 0x26
	.byte	0xa8
	.uleb128 0x2d
	.byte	0xa8
	.uleb128 0
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL33-.LVL0
	.uleb128 .LVL36-.LVL0
	.uleb128 0x1
	.byte	0x56
	.byte	0x4
	.uleb128 .LVL36-.LVL0
	.uleb128 .LFE11-.LVL0
	.uleb128 0xa
	.byte	0xa3
	.uleb128 0x3
	.byte	0xa5
	.uleb128 0x1
	.uleb128 0x26
	.byte	0xa8
	.uleb128 0x2d
	.byte	0xa8
	.uleb128 0
	.byte	0x9f
	.byte	0
.LVUS2:
	.uleb128 .LVU39
	.uleb128 .LVU46
	.uleb128 .LVU46
	.uleb128 .LVU50
	.uleb128 .LVU50
	.uleb128 .LVU76
	.uleb128 .LVU76
	.uleb128 .LVU78
	.uleb128 .LVU94
	.uleb128 0
.LLST2:
	.byte	0x6
	.4byte	.LVL10
	.byte	0x4
	.uleb128 .LVL10-.LVL10
	.uleb128 .LVL11-.LVL10
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL11-.LVL10
	.uleb128 .LVL12-.LVL10
	.uleb128 0x1
	.byte	0x59
	.byte	0x4
	.uleb128 .LVL12-.LVL10
	.uleb128 .LVL26-.LVL10
	.uleb128 0x3
	.byte	0x79
	.sleb128 -1
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL26-.LVL10
	.uleb128 .LVL28-.LVL10
	.uleb128 0x1
	.byte	0x59
	.byte	0x4
	.uleb128 .LVL36-.LVL10
	.uleb128 .LFE11-.LVL10
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0
.LVUS3:
	.uleb128 .LVU20
	.uleb128 .LVU31
	.uleb128 .LVU33
	.uleb128 .LVU46
	.uleb128 .LVU46
	.uleb128 .LVU66
	.uleb128 .LVU87
	.uleb128 0
.LLST3:
	.byte	0x6
	.4byte	.LVL1
	.byte	0x4
	.uleb128 .LVL1-.LVL1
	.uleb128 .LVL4-.LVL1
	.uleb128 0xa
	.byte	0x9e
	.uleb128 0x8
	.8byte	0
	.byte	0x4
	.uleb128 .LVL5-.LVL1
	.uleb128 .LVL11-.LVL1
	.uleb128 0xa
	.byte	0x9e
	.uleb128 0x8
	.8byte	0
	.byte	0x4
	.uleb128 .LVL11-.LVL1
	.uleb128 .LVL24-.LVL1
	.uleb128 0x9
	.byte	0x55
	.byte	0x93
	.uleb128 0x4
	.byte	0x91
	.sleb128 -9400
	.byte	0x93
	.uleb128 0x4
	.byte	0x4
	.uleb128 .LVL33-.LVL1
	.uleb128 .LFE11-.LVL1
	.uleb128 0xa
	.byte	0x9e
	.uleb128 0x8
	.8byte	0
	.byte	0
.LVUS4:
	.uleb128 .LVU21
	.uleb128 .LVU31
	.uleb128 .LVU33
	.uleb128 .LVU46
	.uleb128 .LVU46
	.uleb128 .LVU68
	.uleb128 .LVU87
	.uleb128 0
.LLST4:
	.byte	0x6
	.4byte	.LVL1
	.byte	0x4
	.uleb128 .LVL1-.LVL1
	.uleb128 .LVL4-.LVL1
	.uleb128 0xa
	.byte	0x9e
	.uleb128 0x8
	.8byte	0
	.byte	0x4
	.uleb128 .LVL5-.LVL1
	.uleb128 .LVL11-.LVL1
	.uleb128 0xa
	.byte	0x9e
	.uleb128 0x8
	.8byte	0
	.byte	0x4
	.uleb128 .LVL11-.LVL1
	.uleb128 .LVL25-.LVL1
	.uleb128 0x9
	.byte	0x57
	.byte	0x93
	.uleb128 0x4
	.byte	0x91
	.sleb128 -9396
	.byte	0x93
	.uleb128 0x4
	.byte	0x4
	.uleb128 .LVL33-.LVL1
	.uleb128 .LFE11-.LVL1
	.uleb128 0xa
	.byte	0x9e
	.uleb128 0x8
	.8byte	0
	.byte	0
.LVUS5:
	.uleb128 .LVU22
	.uleb128 .LVU31
	.uleb128 .LVU33
	.uleb128 .LVU46
	.uleb128 .LVU46
	.uleb128 .LVU78
	.uleb128 .LVU87
	.uleb128 0
.LLST5:
	.byte	0x6
	.4byte	.LVL1
	.byte	0x4
	.uleb128 .LVL1-.LVL1
	.uleb128 .LVL4-.LVL1
	.uleb128 0xa
	.byte	0x9e
	.uleb128 0x8
	.8byte	0xffffffffffffffff
	.byte	0x4
	.uleb128 .LVL5-.LVL1
	.uleb128 .LVL11-.LVL1
	.uleb128 0xa
	.byte	0x9e
	.uleb128 0x8
	.8byte	0xffffffffffffffff
	.byte	0x4
	.uleb128 .LVL11-.LVL1
	.uleb128 .LVL28-.LVL1
	.uleb128 0xc
	.byte	0x91
	.sleb128 -9392
	.byte	0x93
	.uleb128 0x4
	.byte	0x91
	.sleb128 -9388
	.byte	0x93
	.uleb128 0x4
	.byte	0x4
	.uleb128 .LVL33-.LVL1
	.uleb128 .LFE11-.LVL1
	.uleb128 0xa
	.byte	0x9e
	.uleb128 0x8
	.8byte	0xffffffffffffffff
	.byte	0
.LVUS7:
	.uleb128 .LVU53
	.uleb128 .LVU54
	.uleb128 .LVU54
	.uleb128 .LVU77
.LLST7:
	.byte	0x6
	.4byte	.LVL15
	.byte	0x4
	.uleb128 .LVL15-.LVL15
	.uleb128 .LVL16-1-.LVL15
	.uleb128 0x6
	.byte	0x50
	.byte	0x93
	.uleb128 0x4
	.byte	0x51
	.byte	0x93
	.uleb128 0x4
	.byte	0x4
	.uleb128 .LVL16-1-.LVL15
	.uleb128 .LVL27-.LVL15
	.uleb128 0x6
	.byte	0x58
	.byte	0x93
	.uleb128 0x4
	.byte	0x5b
	.byte	0x93
	.uleb128 0x4
	.byte	0
.LVUS8:
	.uleb128 .LVU56
	.uleb128 .LVU57
	.uleb128 .LVU57
	.uleb128 .LVU65
.LLST8:
	.byte	0x6
	.4byte	.LVL18
	.byte	0x4
	.uleb128 .LVL18-.LVL18
	.uleb128 .LVL19-1-.LVL18
	.uleb128 0x6
	.byte	0x50
	.byte	0x93
	.uleb128 0x4
	.byte	0x51
	.byte	0x93
	.uleb128 0x4
	.byte	0x4
	.uleb128 .LVL19-1-.LVL18
	.uleb128 .LVL23-.LVL18
	.uleb128 0x6
	.byte	0x54
	.byte	0x93
	.uleb128 0x4
	.byte	0x56
	.byte	0x93
	.uleb128 0x4
	.byte	0
.LVUS9:
	.uleb128 .LVU59
	.uleb128 .LVU62
.LLST9:
	.byte	0x8
	.4byte	.LVL20
	.uleb128 .LVL21-.LVL20
	.uleb128 0x6
	.byte	0x50
	.byte	0x93
	.uleb128 0x4
	.byte	0x51
	.byte	0x93
	.uleb128 0x4
	.byte	0
.LVUS10:
	.uleb128 .LVU63
	.uleb128 .LVU78
.LLST10:
	.byte	0x8
	.4byte	.LVL22
	.uleb128 .LVL28-.LVL22
	.uleb128 0x6
	.byte	0x50
	.byte	0x93
	.uleb128 0x4
	.byte	0x51
	.byte	0x93
	.uleb128 0x4
	.byte	0
.Ldebug_loc3:
	.section	.debug_aranges,"",%progbits
	.4byte	0x1c
	.2byte	0x2
	.4byte	.Ldebug_info0
	.byte	0x4
	.byte	0
	.2byte	0
	.2byte	0
	.4byte	.LFB11
	.4byte	.LFE11-.LFB11
	.4byte	0
	.4byte	0
	.section	.debug_rnglists,"",%progbits
.Ldebug_ranges0:
	.4byte	.Ldebug_ranges3-.Ldebug_ranges2
.Ldebug_ranges2:
	.2byte	0x5
	.byte	0x4
	.byte	0
	.4byte	0
.LLRL6:
	.byte	0x5
	.4byte	.LBB2
	.byte	0x4
	.uleb128 .LBB2-.LBB2
	.uleb128 .LBE2-.LBB2
	.byte	0x4
	.uleb128 .LBB3-.LBB2
	.uleb128 .LBE3-.LBB2
	.byte	0x4
	.uleb128 .LBB4-.LBB2
	.uleb128 .LBE4-.LBB2
	.byte	0
.LLRL11:
	.byte	0x7
	.4byte	.LFB11
	.uleb128 .LFE11-.LFB11
	.byte	0
.Ldebug_ranges3:
	.section	.debug_line,"",%progbits
.Ldebug_line0:
	.section	.debug_str,"MS",%progbits,1
.LASF13:
	.ascii	"uint64_t\000"
.LASF8:
	.ascii	"__uint8_t\000"
.LASF25:
	.ascii	"ycc_to_rgb_ms_min\000"
.LASF14:
	.ascii	"Cb_temp\000"
.LASF0:
	.ascii	"long long unsigned int\000"
.LASF7:
	.ascii	"long long int\000"
.LASF5:
	.ascii	"signed char\000"
.LASF32:
	.ascii	"CSC_WallMetrics\000"
.LASF10:
	.ascii	"long int\000"
.LASF31:
	.ascii	"double\000"
.LASF38:
	.ascii	"CSC_RGB_to_YCC\000"
.LASF48:
	.ascii	"G_orig\000"
.LASF1:
	.ascii	"unsigned int\000"
.LASF18:
	.ascii	"metrics_path\000"
.LASF23:
	.ascii	"rgb_to_ycc_ms_mean\000"
.LASF59:
	.ascii	"rgb_ns\000"
.LASF46:
	.ascii	"metrics\000"
.LASF4:
	.ascii	"long unsigned int\000"
.LASF29:
	.ascii	"diff_max\000"
.LASF17:
	.ascii	"output_path\000"
.LASF43:
	.ascii	"csc_parse_args\000"
.LASF19:
	.ascii	"label\000"
.LASF49:
	.ascii	"B_orig\000"
.LASF3:
	.ascii	"short unsigned int\000"
.LASF28:
	.ascii	"ns_per_pixel\000"
.LASF51:
	.ascii	"ycc_ns_sum\000"
.LASF54:
	.ascii	"GNU C17 14.2.0 -mfloat-abi=hard -mtls-dialect=gnu -"
	.ascii	"mthumb -march=armv7-a+fp -g -O2\000"
.LASF36:
	.ascii	"csc_compute_quality\000"
.LASF33:
	.ascii	"csc_report_wall_metrics\000"
.LASF22:
	.ascii	"CSC_RunConfig\000"
.LASF15:
	.ascii	"Cr_temp\000"
.LASF20:
	.ascii	"iterations\000"
.LASF35:
	.ascii	"csc_fill_wall_metrics\000"
.LASF9:
	.ascii	"__uint64_t\000"
.LASF50:
	.ascii	"rgb_ns_sum\000"
.LASF2:
	.ascii	"unsigned char\000"
.LASF26:
	.ascii	"total_ms_mean\000"
.LASF30:
	.ascii	"mean_abs_delta\000"
.LASF6:
	.ascii	"short int\000"
.LASF39:
	.ascii	"csc_restore_rgb\000"
.LASF24:
	.ascii	"ycc_to_rgb_ms_mean\000"
.LASF37:
	.ascii	"CSC_YCC_to_RGB\000"
.LASF56:
	.ascii	"/root/SENG440RGB-YCC/src/optimized_conversion\000"
.LASF16:
	.ascii	"input_path\000"
.LASF41:
	.ascii	"csc_load_input_image\000"
.LASF11:
	.ascii	"char\000"
.LASF40:
	.ascii	"csc_snapshot_rgb\000"
.LASF55:
	.ascii	"CSC_main.c\000"
.LASF34:
	.ascii	"csc_write_ppm\000"
.LASF47:
	.ascii	"R_orig\000"
.LASF45:
	.ascii	"argv\000"
.LASF57:
	.ascii	"csc_now_ns\000"
.LASF12:
	.ascii	"uint8_t\000"
.LASF21:
	.ascii	"show_help\000"
.LASF42:
	.ascii	"csc_print_usage\000"
.LASF53:
	.ascii	"ycc_ns\000"
.LASF44:
	.ascii	"argc\000"
.LASF52:
	.ascii	"ycc_ns_min\000"
.LASF58:
	.ascii	"main\000"
.LASF27:
	.ascii	"mpix_per_s\000"
	.ident	"GCC: (Debian 14.2.0-19) 14.2.0"
	.section	.note.GNU-stack,"",%progbits
