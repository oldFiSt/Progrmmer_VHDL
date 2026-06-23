// Created with Corsair v1.0.4
#ifndef __REGS_H
#define __REGS_H

#define __I  volatile const // 'read only' permissions
#define __O  volatile       // 'write only' permissions
#define __IO volatile       // 'read / write' permissions


#ifdef __cplusplus
#include <cstdint>
extern "C" {
#else
#include <stdint.h>
#endif

#define CSR_BASE_ADDR 0x0

// TEST_RW_0 - Test register RW 0
#define CSR_TEST_RW_0_ADDR 0x0
#define CSR_TEST_RW_0_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_rw_0_t;

// TEST_RW_0.data - Test data field
#define CSR_TEST_RW_0_DATA_WIDTH 32
#define CSR_TEST_RW_0_DATA_LSB 0
#define CSR_TEST_RW_0_DATA_MASK 0xffffffff
#define CSR_TEST_RW_0_DATA_RESET 0x0

// TEST_RW_1 - Test register RW 1
#define CSR_TEST_RW_1_ADDR 0x4
#define CSR_TEST_RW_1_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_rw_1_t;

// TEST_RW_1.data - Test data field
#define CSR_TEST_RW_1_DATA_WIDTH 32
#define CSR_TEST_RW_1_DATA_LSB 0
#define CSR_TEST_RW_1_DATA_MASK 0xffffffff
#define CSR_TEST_RW_1_DATA_RESET 0x0

// TEST_RW_2 - Test register RW 2
#define CSR_TEST_RW_2_ADDR 0x8
#define CSR_TEST_RW_2_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_rw_2_t;

// TEST_RW_2.data - Test data field
#define CSR_TEST_RW_2_DATA_WIDTH 32
#define CSR_TEST_RW_2_DATA_LSB 0
#define CSR_TEST_RW_2_DATA_MASK 0xffffffff
#define CSR_TEST_RW_2_DATA_RESET 0x0

// TEST_RW_3 - Test register RW 3
#define CSR_TEST_RW_3_ADDR 0xc
#define CSR_TEST_RW_3_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_rw_3_t;

// TEST_RW_3.data - Test data field
#define CSR_TEST_RW_3_DATA_WIDTH 32
#define CSR_TEST_RW_3_DATA_LSB 0
#define CSR_TEST_RW_3_DATA_MASK 0xffffffff
#define CSR_TEST_RW_3_DATA_RESET 0x0

// TEST_RW_4 - Test register RW 4
#define CSR_TEST_RW_4_ADDR 0x10
#define CSR_TEST_RW_4_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_rw_4_t;

// TEST_RW_4.data - Test data field
#define CSR_TEST_RW_4_DATA_WIDTH 32
#define CSR_TEST_RW_4_DATA_LSB 0
#define CSR_TEST_RW_4_DATA_MASK 0xffffffff
#define CSR_TEST_RW_4_DATA_RESET 0x0

// TEST_RW_5 - Test register RW 5
#define CSR_TEST_RW_5_ADDR 0x14
#define CSR_TEST_RW_5_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_rw_5_t;

// TEST_RW_5.data - Test data field
#define CSR_TEST_RW_5_DATA_WIDTH 32
#define CSR_TEST_RW_5_DATA_LSB 0
#define CSR_TEST_RW_5_DATA_MASK 0xffffffff
#define CSR_TEST_RW_5_DATA_RESET 0x0

// TEST_RW_6 - Test register RW 6
#define CSR_TEST_RW_6_ADDR 0x18
#define CSR_TEST_RW_6_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_rw_6_t;

// TEST_RW_6.data - Test data field
#define CSR_TEST_RW_6_DATA_WIDTH 32
#define CSR_TEST_RW_6_DATA_LSB 0
#define CSR_TEST_RW_6_DATA_MASK 0xffffffff
#define CSR_TEST_RW_6_DATA_RESET 0x0

// TEST_RW_7 - Test register RW 7
#define CSR_TEST_RW_7_ADDR 0x1c
#define CSR_TEST_RW_7_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_rw_7_t;

// TEST_RW_7.data - Test data field
#define CSR_TEST_RW_7_DATA_WIDTH 32
#define CSR_TEST_RW_7_DATA_LSB 0
#define CSR_TEST_RW_7_DATA_MASK 0xffffffff
#define CSR_TEST_RW_7_DATA_RESET 0x0

// TEST_RW_8 - Test register RW 8
#define CSR_TEST_RW_8_ADDR 0x20
#define CSR_TEST_RW_8_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_rw_8_t;

// TEST_RW_8.data - Test data field
#define CSR_TEST_RW_8_DATA_WIDTH 32
#define CSR_TEST_RW_8_DATA_LSB 0
#define CSR_TEST_RW_8_DATA_MASK 0xffffffff
#define CSR_TEST_RW_8_DATA_RESET 0x0

// TEST_RW_9 - Test register RW 9
#define CSR_TEST_RW_9_ADDR 0x24
#define CSR_TEST_RW_9_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_rw_9_t;

// TEST_RW_9.data - Test data field
#define CSR_TEST_RW_9_DATA_WIDTH 32
#define CSR_TEST_RW_9_DATA_LSB 0
#define CSR_TEST_RW_9_DATA_MASK 0xffffffff
#define CSR_TEST_RW_9_DATA_RESET 0x0

// TEST_RW_10 - Test register RW 10
#define CSR_TEST_RW_10_ADDR 0x28
#define CSR_TEST_RW_10_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_rw_10_t;

// TEST_RW_10.data - Test data field
#define CSR_TEST_RW_10_DATA_WIDTH 32
#define CSR_TEST_RW_10_DATA_LSB 0
#define CSR_TEST_RW_10_DATA_MASK 0xffffffff
#define CSR_TEST_RW_10_DATA_RESET 0x0

// TEST_RW_11 - Test register RW 11
#define CSR_TEST_RW_11_ADDR 0x2c
#define CSR_TEST_RW_11_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_rw_11_t;

// TEST_RW_11.data - Test data field
#define CSR_TEST_RW_11_DATA_WIDTH 32
#define CSR_TEST_RW_11_DATA_LSB 0
#define CSR_TEST_RW_11_DATA_MASK 0xffffffff
#define CSR_TEST_RW_11_DATA_RESET 0x0

// TEST_RW_12 - Test register RW 12
#define CSR_TEST_RW_12_ADDR 0x30
#define CSR_TEST_RW_12_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_rw_12_t;

// TEST_RW_12.data - Test data field
#define CSR_TEST_RW_12_DATA_WIDTH 32
#define CSR_TEST_RW_12_DATA_LSB 0
#define CSR_TEST_RW_12_DATA_MASK 0xffffffff
#define CSR_TEST_RW_12_DATA_RESET 0x0

// TEST_RW_13 - Test register RW 13
#define CSR_TEST_RW_13_ADDR 0x34
#define CSR_TEST_RW_13_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_rw_13_t;

// TEST_RW_13.data - Test data field
#define CSR_TEST_RW_13_DATA_WIDTH 32
#define CSR_TEST_RW_13_DATA_LSB 0
#define CSR_TEST_RW_13_DATA_MASK 0xffffffff
#define CSR_TEST_RW_13_DATA_RESET 0x0

// TEST_RW_14 - Test register RW 14
#define CSR_TEST_RW_14_ADDR 0x38
#define CSR_TEST_RW_14_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_rw_14_t;

// TEST_RW_14.data - Test data field
#define CSR_TEST_RW_14_DATA_WIDTH 32
#define CSR_TEST_RW_14_DATA_LSB 0
#define CSR_TEST_RW_14_DATA_MASK 0xffffffff
#define CSR_TEST_RW_14_DATA_RESET 0x0

// TEST_RW_15 - Test register RW 15
#define CSR_TEST_RW_15_ADDR 0x3c
#define CSR_TEST_RW_15_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_rw_15_t;

// TEST_RW_15.data - Test data field
#define CSR_TEST_RW_15_DATA_WIDTH 32
#define CSR_TEST_RW_15_DATA_LSB 0
#define CSR_TEST_RW_15_DATA_MASK 0xffffffff
#define CSR_TEST_RW_15_DATA_RESET 0x0

// TEST_W_0 - Test register W 0
#define CSR_TEST_W_0_ADDR 0x40
#define CSR_TEST_W_0_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_w_0_t;

// TEST_W_0.data - Test data field
#define CSR_TEST_W_0_DATA_WIDTH 32
#define CSR_TEST_W_0_DATA_LSB 0
#define CSR_TEST_W_0_DATA_MASK 0xffffffff
#define CSR_TEST_W_0_DATA_RESET 0x0

// TEST_W_1 - Test register W 1
#define CSR_TEST_W_1_ADDR 0x44
#define CSR_TEST_W_1_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_w_1_t;

// TEST_W_1.data - Test data field
#define CSR_TEST_W_1_DATA_WIDTH 32
#define CSR_TEST_W_1_DATA_LSB 0
#define CSR_TEST_W_1_DATA_MASK 0xffffffff
#define CSR_TEST_W_1_DATA_RESET 0x0

// TEST_W_2 - Test register W 2
#define CSR_TEST_W_2_ADDR 0x48
#define CSR_TEST_W_2_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_w_2_t;

// TEST_W_2.data - Test data field
#define CSR_TEST_W_2_DATA_WIDTH 32
#define CSR_TEST_W_2_DATA_LSB 0
#define CSR_TEST_W_2_DATA_MASK 0xffffffff
#define CSR_TEST_W_2_DATA_RESET 0x0

// TEST_W_3 - Test register W 3
#define CSR_TEST_W_3_ADDR 0x4c
#define CSR_TEST_W_3_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_w_3_t;

// TEST_W_3.data - Test data field
#define CSR_TEST_W_3_DATA_WIDTH 32
#define CSR_TEST_W_3_DATA_LSB 0
#define CSR_TEST_W_3_DATA_MASK 0xffffffff
#define CSR_TEST_W_3_DATA_RESET 0x0

// TEST_W_4 - Test register W 4
#define CSR_TEST_W_4_ADDR 0x50
#define CSR_TEST_W_4_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_w_4_t;

// TEST_W_4.data - Test data field
#define CSR_TEST_W_4_DATA_WIDTH 32
#define CSR_TEST_W_4_DATA_LSB 0
#define CSR_TEST_W_4_DATA_MASK 0xffffffff
#define CSR_TEST_W_4_DATA_RESET 0x0

// TEST_W_5 - Test register W 5
#define CSR_TEST_W_5_ADDR 0x54
#define CSR_TEST_W_5_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_w_5_t;

// TEST_W_5.data - Test data field
#define CSR_TEST_W_5_DATA_WIDTH 32
#define CSR_TEST_W_5_DATA_LSB 0
#define CSR_TEST_W_5_DATA_MASK 0xffffffff
#define CSR_TEST_W_5_DATA_RESET 0x0

// TEST_W_6 - Test register W 6
#define CSR_TEST_W_6_ADDR 0x58
#define CSR_TEST_W_6_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_w_6_t;

// TEST_W_6.data - Test data field
#define CSR_TEST_W_6_DATA_WIDTH 32
#define CSR_TEST_W_6_DATA_LSB 0
#define CSR_TEST_W_6_DATA_MASK 0xffffffff
#define CSR_TEST_W_6_DATA_RESET 0x0

// TEST_W_7 - Test register W 7
#define CSR_TEST_W_7_ADDR 0x5c
#define CSR_TEST_W_7_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_w_7_t;

// TEST_W_7.data - Test data field
#define CSR_TEST_W_7_DATA_WIDTH 32
#define CSR_TEST_W_7_DATA_LSB 0
#define CSR_TEST_W_7_DATA_MASK 0xffffffff
#define CSR_TEST_W_7_DATA_RESET 0x0

// TEST_W_8 - Test register W 8
#define CSR_TEST_W_8_ADDR 0x60
#define CSR_TEST_W_8_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_w_8_t;

// TEST_W_8.data - Test data field
#define CSR_TEST_W_8_DATA_WIDTH 32
#define CSR_TEST_W_8_DATA_LSB 0
#define CSR_TEST_W_8_DATA_MASK 0xffffffff
#define CSR_TEST_W_8_DATA_RESET 0x0

// TEST_W_9 - Test register W 9
#define CSR_TEST_W_9_ADDR 0x64
#define CSR_TEST_W_9_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_w_9_t;

// TEST_W_9.data - Test data field
#define CSR_TEST_W_9_DATA_WIDTH 32
#define CSR_TEST_W_9_DATA_LSB 0
#define CSR_TEST_W_9_DATA_MASK 0xffffffff
#define CSR_TEST_W_9_DATA_RESET 0x0

// TEST_W_10 - Test register W 10
#define CSR_TEST_W_10_ADDR 0x68
#define CSR_TEST_W_10_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_w_10_t;

// TEST_W_10.data - Test data field
#define CSR_TEST_W_10_DATA_WIDTH 32
#define CSR_TEST_W_10_DATA_LSB 0
#define CSR_TEST_W_10_DATA_MASK 0xffffffff
#define CSR_TEST_W_10_DATA_RESET 0x0

// TEST_W_11 - Test register W 11
#define CSR_TEST_W_11_ADDR 0x6c
#define CSR_TEST_W_11_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_w_11_t;

// TEST_W_11.data - Test data field
#define CSR_TEST_W_11_DATA_WIDTH 32
#define CSR_TEST_W_11_DATA_LSB 0
#define CSR_TEST_W_11_DATA_MASK 0xffffffff
#define CSR_TEST_W_11_DATA_RESET 0x0

// TEST_W_12 - Test register W 12
#define CSR_TEST_W_12_ADDR 0x70
#define CSR_TEST_W_12_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_w_12_t;

// TEST_W_12.data - Test data field
#define CSR_TEST_W_12_DATA_WIDTH 32
#define CSR_TEST_W_12_DATA_LSB 0
#define CSR_TEST_W_12_DATA_MASK 0xffffffff
#define CSR_TEST_W_12_DATA_RESET 0x0

// TEST_W_13 - Test register W 13
#define CSR_TEST_W_13_ADDR 0x74
#define CSR_TEST_W_13_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_w_13_t;

// TEST_W_13.data - Test data field
#define CSR_TEST_W_13_DATA_WIDTH 32
#define CSR_TEST_W_13_DATA_LSB 0
#define CSR_TEST_W_13_DATA_MASK 0xffffffff
#define CSR_TEST_W_13_DATA_RESET 0x0

// TEST_W_14 - Test register W 14
#define CSR_TEST_W_14_ADDR 0x78
#define CSR_TEST_W_14_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_w_14_t;

// TEST_W_14.data - Test data field
#define CSR_TEST_W_14_DATA_WIDTH 32
#define CSR_TEST_W_14_DATA_LSB 0
#define CSR_TEST_W_14_DATA_MASK 0xffffffff
#define CSR_TEST_W_14_DATA_RESET 0x0

// TEST_W_15 - Test register W 15
#define CSR_TEST_W_15_ADDR 0x7c
#define CSR_TEST_W_15_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_w_15_t;

// TEST_W_15.data - Test data field
#define CSR_TEST_W_15_DATA_WIDTH 32
#define CSR_TEST_W_15_DATA_LSB 0
#define CSR_TEST_W_15_DATA_MASK 0xffffffff
#define CSR_TEST_W_15_DATA_RESET 0x0

// TEST_R_0 - Test register R 0
#define CSR_TEST_R_0_ADDR 0x80
#define CSR_TEST_R_0_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_r_0_t;

// TEST_R_0.data - Test data field
#define CSR_TEST_R_0_DATA_WIDTH 32
#define CSR_TEST_R_0_DATA_LSB 0
#define CSR_TEST_R_0_DATA_MASK 0xffffffff
#define CSR_TEST_R_0_DATA_RESET 0x0

// TEST_R_1 - Test register R 1
#define CSR_TEST_R_1_ADDR 0x84
#define CSR_TEST_R_1_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_r_1_t;

// TEST_R_1.data - Test data field
#define CSR_TEST_R_1_DATA_WIDTH 32
#define CSR_TEST_R_1_DATA_LSB 0
#define CSR_TEST_R_1_DATA_MASK 0xffffffff
#define CSR_TEST_R_1_DATA_RESET 0x0

// TEST_R_2 - Test register R 2
#define CSR_TEST_R_2_ADDR 0x88
#define CSR_TEST_R_2_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_r_2_t;

// TEST_R_2.data - Test data field
#define CSR_TEST_R_2_DATA_WIDTH 32
#define CSR_TEST_R_2_DATA_LSB 0
#define CSR_TEST_R_2_DATA_MASK 0xffffffff
#define CSR_TEST_R_2_DATA_RESET 0x0

// TEST_R_3 - Test register R 3
#define CSR_TEST_R_3_ADDR 0x8c
#define CSR_TEST_R_3_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_r_3_t;

// TEST_R_3.data - Test data field
#define CSR_TEST_R_3_DATA_WIDTH 32
#define CSR_TEST_R_3_DATA_LSB 0
#define CSR_TEST_R_3_DATA_MASK 0xffffffff
#define CSR_TEST_R_3_DATA_RESET 0x0

// TEST_R_4 - Test register R 4
#define CSR_TEST_R_4_ADDR 0x90
#define CSR_TEST_R_4_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_r_4_t;

// TEST_R_4.data - Test data field
#define CSR_TEST_R_4_DATA_WIDTH 32
#define CSR_TEST_R_4_DATA_LSB 0
#define CSR_TEST_R_4_DATA_MASK 0xffffffff
#define CSR_TEST_R_4_DATA_RESET 0x0

// TEST_R_5 - Test register R 5
#define CSR_TEST_R_5_ADDR 0x94
#define CSR_TEST_R_5_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_r_5_t;

// TEST_R_5.data - Test data field
#define CSR_TEST_R_5_DATA_WIDTH 32
#define CSR_TEST_R_5_DATA_LSB 0
#define CSR_TEST_R_5_DATA_MASK 0xffffffff
#define CSR_TEST_R_5_DATA_RESET 0x0

// TEST_R_6 - Test register R 6
#define CSR_TEST_R_6_ADDR 0x98
#define CSR_TEST_R_6_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_r_6_t;

// TEST_R_6.data - Test data field
#define CSR_TEST_R_6_DATA_WIDTH 32
#define CSR_TEST_R_6_DATA_LSB 0
#define CSR_TEST_R_6_DATA_MASK 0xffffffff
#define CSR_TEST_R_6_DATA_RESET 0x0

// TEST_R_7 - Test register R 7
#define CSR_TEST_R_7_ADDR 0x9c
#define CSR_TEST_R_7_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_r_7_t;

// TEST_R_7.data - Test data field
#define CSR_TEST_R_7_DATA_WIDTH 32
#define CSR_TEST_R_7_DATA_LSB 0
#define CSR_TEST_R_7_DATA_MASK 0xffffffff
#define CSR_TEST_R_7_DATA_RESET 0x0

// TEST_R_8 - Test register R 8
#define CSR_TEST_R_8_ADDR 0xa0
#define CSR_TEST_R_8_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_r_8_t;

// TEST_R_8.data - Test data field
#define CSR_TEST_R_8_DATA_WIDTH 32
#define CSR_TEST_R_8_DATA_LSB 0
#define CSR_TEST_R_8_DATA_MASK 0xffffffff
#define CSR_TEST_R_8_DATA_RESET 0x0

// TEST_R_9 - Test register R 9
#define CSR_TEST_R_9_ADDR 0xa4
#define CSR_TEST_R_9_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_r_9_t;

// TEST_R_9.data - Test data field
#define CSR_TEST_R_9_DATA_WIDTH 32
#define CSR_TEST_R_9_DATA_LSB 0
#define CSR_TEST_R_9_DATA_MASK 0xffffffff
#define CSR_TEST_R_9_DATA_RESET 0x0

// TEST_R_10 - Test register R 10
#define CSR_TEST_R_10_ADDR 0xa8
#define CSR_TEST_R_10_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_r_10_t;

// TEST_R_10.data - Test data field
#define CSR_TEST_R_10_DATA_WIDTH 32
#define CSR_TEST_R_10_DATA_LSB 0
#define CSR_TEST_R_10_DATA_MASK 0xffffffff
#define CSR_TEST_R_10_DATA_RESET 0x0

// TEST_R_11 - Test register R 11
#define CSR_TEST_R_11_ADDR 0xac
#define CSR_TEST_R_11_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_r_11_t;

// TEST_R_11.data - Test data field
#define CSR_TEST_R_11_DATA_WIDTH 32
#define CSR_TEST_R_11_DATA_LSB 0
#define CSR_TEST_R_11_DATA_MASK 0xffffffff
#define CSR_TEST_R_11_DATA_RESET 0x0

// TEST_R_12 - Test register R 12
#define CSR_TEST_R_12_ADDR 0xb0
#define CSR_TEST_R_12_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_r_12_t;

// TEST_R_12.data - Test data field
#define CSR_TEST_R_12_DATA_WIDTH 32
#define CSR_TEST_R_12_DATA_LSB 0
#define CSR_TEST_R_12_DATA_MASK 0xffffffff
#define CSR_TEST_R_12_DATA_RESET 0x0

// TEST_R_13 - Test register R 13
#define CSR_TEST_R_13_ADDR 0xb4
#define CSR_TEST_R_13_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_r_13_t;

// TEST_R_13.data - Test data field
#define CSR_TEST_R_13_DATA_WIDTH 32
#define CSR_TEST_R_13_DATA_LSB 0
#define CSR_TEST_R_13_DATA_MASK 0xffffffff
#define CSR_TEST_R_13_DATA_RESET 0x0

// TEST_R_14 - Test register R 14
#define CSR_TEST_R_14_ADDR 0xb8
#define CSR_TEST_R_14_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_r_14_t;

// TEST_R_14.data - Test data field
#define CSR_TEST_R_14_DATA_WIDTH 32
#define CSR_TEST_R_14_DATA_LSB 0
#define CSR_TEST_R_14_DATA_MASK 0xffffffff
#define CSR_TEST_R_14_DATA_RESET 0x0

// TEST_R_15 - Test register R 15
#define CSR_TEST_R_15_ADDR 0xbc
#define CSR_TEST_R_15_RESET 0x0
typedef struct {
    uint32_t DATA : 32; // Test data field
} csr_test_r_15_t;

// TEST_R_15.data - Test data field
#define CSR_TEST_R_15_DATA_WIDTH 32
#define CSR_TEST_R_15_DATA_LSB 0
#define CSR_TEST_R_15_DATA_MASK 0xffffffff
#define CSR_TEST_R_15_DATA_RESET 0x0


// Register map structure
typedef struct {
    union {
        __IO uint32_t TEST_RW_0; // Test register RW 0
        __IO csr_test_rw_0_t TEST_RW_0_bf; // Bit access for TEST_RW_0 register
    };
    union {
        __IO uint32_t TEST_RW_1; // Test register RW 1
        __IO csr_test_rw_1_t TEST_RW_1_bf; // Bit access for TEST_RW_1 register
    };
    union {
        __IO uint32_t TEST_RW_2; // Test register RW 2
        __IO csr_test_rw_2_t TEST_RW_2_bf; // Bit access for TEST_RW_2 register
    };
    union {
        __IO uint32_t TEST_RW_3; // Test register RW 3
        __IO csr_test_rw_3_t TEST_RW_3_bf; // Bit access for TEST_RW_3 register
    };
    union {
        __IO uint32_t TEST_RW_4; // Test register RW 4
        __IO csr_test_rw_4_t TEST_RW_4_bf; // Bit access for TEST_RW_4 register
    };
    union {
        __IO uint32_t TEST_RW_5; // Test register RW 5
        __IO csr_test_rw_5_t TEST_RW_5_bf; // Bit access for TEST_RW_5 register
    };
    union {
        __IO uint32_t TEST_RW_6; // Test register RW 6
        __IO csr_test_rw_6_t TEST_RW_6_bf; // Bit access for TEST_RW_6 register
    };
    union {
        __IO uint32_t TEST_RW_7; // Test register RW 7
        __IO csr_test_rw_7_t TEST_RW_7_bf; // Bit access for TEST_RW_7 register
    };
    union {
        __IO uint32_t TEST_RW_8; // Test register RW 8
        __IO csr_test_rw_8_t TEST_RW_8_bf; // Bit access for TEST_RW_8 register
    };
    union {
        __IO uint32_t TEST_RW_9; // Test register RW 9
        __IO csr_test_rw_9_t TEST_RW_9_bf; // Bit access for TEST_RW_9 register
    };
    union {
        __IO uint32_t TEST_RW_10; // Test register RW 10
        __IO csr_test_rw_10_t TEST_RW_10_bf; // Bit access for TEST_RW_10 register
    };
    union {
        __IO uint32_t TEST_RW_11; // Test register RW 11
        __IO csr_test_rw_11_t TEST_RW_11_bf; // Bit access for TEST_RW_11 register
    };
    union {
        __IO uint32_t TEST_RW_12; // Test register RW 12
        __IO csr_test_rw_12_t TEST_RW_12_bf; // Bit access for TEST_RW_12 register
    };
    union {
        __IO uint32_t TEST_RW_13; // Test register RW 13
        __IO csr_test_rw_13_t TEST_RW_13_bf; // Bit access for TEST_RW_13 register
    };
    union {
        __IO uint32_t TEST_RW_14; // Test register RW 14
        __IO csr_test_rw_14_t TEST_RW_14_bf; // Bit access for TEST_RW_14 register
    };
    union {
        __IO uint32_t TEST_RW_15; // Test register RW 15
        __IO csr_test_rw_15_t TEST_RW_15_bf; // Bit access for TEST_RW_15 register
    };
    union {
        __O uint32_t TEST_W_0; // Test register W 0
        __O csr_test_w_0_t TEST_W_0_bf; // Bit access for TEST_W_0 register
    };
    union {
        __O uint32_t TEST_W_1; // Test register W 1
        __O csr_test_w_1_t TEST_W_1_bf; // Bit access for TEST_W_1 register
    };
    union {
        __O uint32_t TEST_W_2; // Test register W 2
        __O csr_test_w_2_t TEST_W_2_bf; // Bit access for TEST_W_2 register
    };
    union {
        __O uint32_t TEST_W_3; // Test register W 3
        __O csr_test_w_3_t TEST_W_3_bf; // Bit access for TEST_W_3 register
    };
    union {
        __O uint32_t TEST_W_4; // Test register W 4
        __O csr_test_w_4_t TEST_W_4_bf; // Bit access for TEST_W_4 register
    };
    union {
        __O uint32_t TEST_W_5; // Test register W 5
        __O csr_test_w_5_t TEST_W_5_bf; // Bit access for TEST_W_5 register
    };
    union {
        __O uint32_t TEST_W_6; // Test register W 6
        __O csr_test_w_6_t TEST_W_6_bf; // Bit access for TEST_W_6 register
    };
    union {
        __O uint32_t TEST_W_7; // Test register W 7
        __O csr_test_w_7_t TEST_W_7_bf; // Bit access for TEST_W_7 register
    };
    union {
        __O uint32_t TEST_W_8; // Test register W 8
        __O csr_test_w_8_t TEST_W_8_bf; // Bit access for TEST_W_8 register
    };
    union {
        __O uint32_t TEST_W_9; // Test register W 9
        __O csr_test_w_9_t TEST_W_9_bf; // Bit access for TEST_W_9 register
    };
    union {
        __O uint32_t TEST_W_10; // Test register W 10
        __O csr_test_w_10_t TEST_W_10_bf; // Bit access for TEST_W_10 register
    };
    union {
        __O uint32_t TEST_W_11; // Test register W 11
        __O csr_test_w_11_t TEST_W_11_bf; // Bit access for TEST_W_11 register
    };
    union {
        __O uint32_t TEST_W_12; // Test register W 12
        __O csr_test_w_12_t TEST_W_12_bf; // Bit access for TEST_W_12 register
    };
    union {
        __O uint32_t TEST_W_13; // Test register W 13
        __O csr_test_w_13_t TEST_W_13_bf; // Bit access for TEST_W_13 register
    };
    union {
        __O uint32_t TEST_W_14; // Test register W 14
        __O csr_test_w_14_t TEST_W_14_bf; // Bit access for TEST_W_14 register
    };
    union {
        __O uint32_t TEST_W_15; // Test register W 15
        __O csr_test_w_15_t TEST_W_15_bf; // Bit access for TEST_W_15 register
    };
    union {
        __I uint32_t TEST_R_0; // Test register R 0
        __I csr_test_r_0_t TEST_R_0_bf; // Bit access for TEST_R_0 register
    };
    union {
        __I uint32_t TEST_R_1; // Test register R 1
        __I csr_test_r_1_t TEST_R_1_bf; // Bit access for TEST_R_1 register
    };
    union {
        __I uint32_t TEST_R_2; // Test register R 2
        __I csr_test_r_2_t TEST_R_2_bf; // Bit access for TEST_R_2 register
    };
    union {
        __I uint32_t TEST_R_3; // Test register R 3
        __I csr_test_r_3_t TEST_R_3_bf; // Bit access for TEST_R_3 register
    };
    union {
        __I uint32_t TEST_R_4; // Test register R 4
        __I csr_test_r_4_t TEST_R_4_bf; // Bit access for TEST_R_4 register
    };
    union {
        __I uint32_t TEST_R_5; // Test register R 5
        __I csr_test_r_5_t TEST_R_5_bf; // Bit access for TEST_R_5 register
    };
    union {
        __I uint32_t TEST_R_6; // Test register R 6
        __I csr_test_r_6_t TEST_R_6_bf; // Bit access for TEST_R_6 register
    };
    union {
        __I uint32_t TEST_R_7; // Test register R 7
        __I csr_test_r_7_t TEST_R_7_bf; // Bit access for TEST_R_7 register
    };
    union {
        __I uint32_t TEST_R_8; // Test register R 8
        __I csr_test_r_8_t TEST_R_8_bf; // Bit access for TEST_R_8 register
    };
    union {
        __I uint32_t TEST_R_9; // Test register R 9
        __I csr_test_r_9_t TEST_R_9_bf; // Bit access for TEST_R_9 register
    };
    union {
        __I uint32_t TEST_R_10; // Test register R 10
        __I csr_test_r_10_t TEST_R_10_bf; // Bit access for TEST_R_10 register
    };
    union {
        __I uint32_t TEST_R_11; // Test register R 11
        __I csr_test_r_11_t TEST_R_11_bf; // Bit access for TEST_R_11 register
    };
    union {
        __I uint32_t TEST_R_12; // Test register R 12
        __I csr_test_r_12_t TEST_R_12_bf; // Bit access for TEST_R_12 register
    };
    union {
        __I uint32_t TEST_R_13; // Test register R 13
        __I csr_test_r_13_t TEST_R_13_bf; // Bit access for TEST_R_13 register
    };
    union {
        __I uint32_t TEST_R_14; // Test register R 14
        __I csr_test_r_14_t TEST_R_14_bf; // Bit access for TEST_R_14 register
    };
    union {
        __I uint32_t TEST_R_15; // Test register R 15
        __I csr_test_r_15_t TEST_R_15_bf; // Bit access for TEST_R_15 register
    };
} csr_t;

#define CSR ((csr_t*)(CSR_BASE_ADDR))

#ifdef __cplusplus
}
#endif

#endif /* __REGS_H */